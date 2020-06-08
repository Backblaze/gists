
import requests
import base64
import json

flagDebug = True

cloudflareEmail = 'fearlessleader@pottsylvania.gov'
bucketSourceId = 'cdb0bd378798e11f6427041b'
bucketFilenamePrefix = ''
cfZoneId = '625b68ff559a2fa5247c9c51e3c6374d'
cfAppKey = 'c641673a3ae68de751172aab8805a3579eca6'
# the preceding 'b' causes these to be treated as binary data
# for b64 encoding.
b2AppKey = b'K000uBzMpPUsL0zM32R9MEgpU9yT4IoQ'
b2AppKeyId = b'000d0da781f4e4b0000000033'

# An authorization token is valid for not more than 1 week
# This sets it to the maximum time value
maxSecondsAuthValid = 7*24*60*60 # one week in seconds

# DO NOT CHANGE ANYTHING BELOW THIS LINE ###

baseAuthorizationUrl = 'https://api.backblazeb2.com/b2api/v2/b2_authorize_account'
b2GetDownloadAuthApi = '/b2api/v2/b2_get_download_authorization'

cfUploadWWUrl = "https://api.cloudflare.com/client/v4/zones/" + cfZoneId + "/workers/script"

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

respData = json.loads(resp.content)

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

resp2Data = json.loads(resp2.content)


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


#Can now update the web worker
#curl -X PUT "https://api.cloudflare.com/client/v4/zones/:zone_id/workers/script" -H
#"X-Auth-Email:YOUR_CLOUDFLARE_EMAIL" -H "X-Auth-Key:ACCOUNT_AUTH_KEY" -H
#"Content-Type:application/javascript" --data-binary "@PATH_TO_YOUR_WORKER_SCRIPT"

cfHeaders = { 'X-Auth-Email' : cloudflareEmail,
              'X-Auth-Key' : cfAppKey,
              'Content-Type' : 'application/javascript' }

cfUrl = 'https://api.cloudflare.com/client/v4/zones/' + cfZoneId + "/workers/script"

resp = requests.put(cfUrl, headers=cfHeaders, data=workerCode)

if flagDebug:
    print(resp)
    print(resp.headers)
    print(resp.content)
