import requests
import base64
import json

flagDebug = True

bucketSourceId = 'cdb0bd378798e11f6427041b'
bucketFilenamePrefix = ''
# for b64 encoding.
b2AppKey = b'K000uBzMpPUsL0zM32R9MEgpU9yT4IoQ'
b2AppKeyId = b'000d0da781f4e4b0000000033'

# Cloudflare settings
cfAccountId = '379de8739ad820309deed3244553423534532' # Your Cloudflare Account ID
cfWorkerApi = 'c641673a3ae68de751172aab8805a3579eca6' # The API key to modify the below worker
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
let response
let i = 3
do {
  response = await timeoutPromise(fetch(modRequest), 2000000)
  if (response) {
    return response
  }
  sleep(100000)
} while (--i)
}
function timeoutPromise(promise, ms) {
  return new Promise((resolve, reject) => {
    const timeoutId = setTimeout(() => {
      reject(new Error("promise timeout"))
    }, ms);
    promise.then(
      (res) => {
        clearTimeout(timeoutId);
        resolve(res);
      },
      (err) => {
        clearTimeout(timeoutId);
        reject(err);
      }
    );
  })
}
function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}
"""

workerCode = workerTemplate.replace('<B2_DOWNLOAD_TOKEN>', bDownAuToken)

cfHeaders = { 'Authorization' : "Bearer " + cfWorkerApi,
              'Content-Type' : 'application/javascript' }

cfUrl = 'https://api.cloudflare.com/client/v4/accounts/' + cfAccountId + "/workers/scripts/" + cfWorkerName

resp = requests.put(cfUrl, headers=cfHeaders, data=workerCode)

if flagDebug:
    print(resp)
    print(resp.headers)
    print(resp.content)
