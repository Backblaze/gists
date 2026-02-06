import requests
import json

api_url = ""  # Provided by b2_authorize_account
account_authorization_token = ""  # Provided by b2_authorize_account
bucket_id = ""  # Provided by b2_list_buckets
file_name = ""  # The name of the file
content_type = ""  # Content Type of the file

response = requests.post(
    f"{api_url}/b2api/v4/b2_start_large_file",
    headers={"Authorization": account_authorization_token},
    json={
        "bucketId": bucket_id,
        "fileName": file_name,
        "contentType": content_type
    }
)
response_data = response.json()
print(json.dumps(response_data, indent=2))
