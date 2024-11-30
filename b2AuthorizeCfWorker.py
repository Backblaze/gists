import requests
import base64
import json

flagDebug = True

bucketSourceId = ''
bucketFilenamePrefix = ''
# for b64 encoding.
b2AppKey = b'' # Your b2 Application key
b2AppKeyId = b'' # Your b2 Application key ID

# Cloudflare settings
cfAccountEmail = ''
cfAccountId = '' # Your Cloudflare Account ID
cfWorkerApi = '' # The API key to modify the below worker
cfWorkerName = 'b2cdn' # worker script name

# An authorization token is valid for not more than 1 week
# This sets it to the maximum time value
maxSecondsAuthValid = 7*24*60*60 # one week in seconds

# DO NOT CHANGE ANYTHING BELOW THIS LINE ###

baseAuthorizationUrl = 'https://api.backblazeb2.com/b2api/v2/b2_authorize_account'
b2GetDownloadAuthApi = '/b2api/v2/b2_get_download_authorization'

# Get fundamental authorization code

idAndKey = b2AppKeyId + b':' + b2AppKey
b2AuthKeyAndId = base64.b64encode(idAndKey)
basicAuthString = 'Basic ' + b2AuthKeyAndId.decode('UTF-8')
authorizationHeaders = {'Authorization' : basicAuthString}
resp = requests.get(baseAuthorizationUrl, headers=authorizationHeaders)

if flagDebug:
    print (resp.status_code)
    print (resp.headers)
    print (resp.content)

respData = json.loads(resp.content.decode("UTF-8"))

bAuToken = respData["authorizationToken"]
bFileDownloadUrl = respData["downloadUrl"]
bPartSize = respData["recommendedPartSize"]
bApiUrl = respData["apiUrl"]

# Get specific download authorization

getDownloadAuthorizationUrl = bApiUrl + b2GetDownloadAuthApi
downloadAuthorizationHeaders = { 'Authorization' : bAuToken}

resp2 = requests.post(getDownloadAuthorizationUrl,
                      json = {'bucketId' : bucketSourceId,
                              'fileNamePrefix' : "",
                              'validDurationInSeconds' : maxSecondsAuthValid },
                      headers=downloadAuthorizationHeaders )

resp2Content = resp2.content.decode("UTF-8")
resp2Data = json.loads(resp2Content)

bDownAuToken = resp2Data["authorizationToken"]

if flagDebug:
    print("authorizationToken: " + bDownAuToken)
    print("downloadUrl: " + bFileDownloadUrl)
    print("recommendedPartSize: " + str(bPartSize))
    print("apiUrl: " + bApiUrl)

workerTemplate = """addEventListener('fetch', event => {
    event.respondWith(handleRequest(event.request))
})
async function handleRequest(request) {
let authToken='<B2_DOWNLOAD_TOKEN>'
let b2Headers = new Headers(request.headers)
b2Headers.append("Authorization", authToken)
modRequest = new Request(request.url, {
    method: request.method,
    headers: b2Headers
})
const response = await fetch(modRequest)
return response
}"""

workerCode = workerTemplate.replace('<B2_DOWNLOAD_TOKEN>', bDownAuToken)

cfHeaders = { 'X-Auth-Email' : cfAccountEmail,
              'X-Auth-Key' : cfWorkerApi,
              'Content-Type': 'application/javascript' }

cfUrl = 'https://api.cloudflare.com/client/v4/accounts/' + cfAccountId + "/workers/scripts/" + cfWorkerName

resp = requests.put(cfUrl, headers=cfHeaders, data=workerCode)

if flagDebug:
    print(cfUrl)
    print(resp)
    print(resp.headers)
    print(resp.content)
