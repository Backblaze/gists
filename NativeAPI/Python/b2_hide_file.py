import requests
import json

api_url = ""  # Provided by b2_authorize_account
account_authorization_token = ""  # Provided by b2_authorize_account
bucket_id = ""  # The ID of the bucket containing the file
file_name = ""  # The name of the file you want to hide

response = requests.post(
    f"{api_url}/b2api/v4/b2_hide_file",
    headers={"Authorization": account_authorization_token},
    json={
        "bucketId": bucket_id,
        "fileName": file_name
    }
)
response_data = response.json()
print(json.dumps(response_data, indent=2))
