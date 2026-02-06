import requests
import json

api_url = ""  # Provided by b2_authorize_account
account_authorization_token = ""  # Provided by b2_authorize_account
account_id = ""  # Provided by b2_authorize_account
bucket_id = ""  # Provided by b2_list_buckets
bucket_type = ""  # The type of bucket: "allPublic" or "allPrivate"

response = requests.post(
    f"{api_url}/b2api/v4/b2_update_bucket",
    headers={"Authorization": account_authorization_token},
    json={
        "accountId": account_id,
        "bucketId": bucket_id,
        "bucketType": bucket_type
    }
)
response_data = response.json()
print(json.dumps(response_data, indent=2))
