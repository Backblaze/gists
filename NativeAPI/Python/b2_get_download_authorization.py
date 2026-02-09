import requests
import json

api_url = ""  # Provided by b2_authorize_account
account_authorization_token = ""  # Provided by b2_authorize_account
bucket_id = "" # Provided by b2_list_buckets
file_name_prefix = ""  # The file name prefix of files the download authorization will allow
valid_duration_in_seconds = 86400  # The number of seconds the authorization is valid for

response = requests.post(
    f"{api_url}/b2api/v4/b2_get_download_authorization",
    headers={"Authorization": account_authorization_token},
    json={
        "bucketId": bucket_id,
        "fileNamePrefix": file_name_prefix,
        "validDurationInSeconds": valid_duration_in_seconds
    }
)
response_data = response.json()
print(json.dumps(response_data, indent=2))
