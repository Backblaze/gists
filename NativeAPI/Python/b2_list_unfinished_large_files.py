import requests
import json

api_url = ""  # Provided by b2_authorize_account
account_authorization_token = ""  # Provided by b2_authorize_account
bucket_id = ""  # Provided by b2_list_buckets

response = requests.get(
    f"{api_url}/b2api/v4/b2_list_unfinished_large_files",
    headers={"Authorization": account_authorization_token},
    params={"bucketId": bucket_id}
)
response_data = response.json()
print(json.dumps(response_data, indent=2))
