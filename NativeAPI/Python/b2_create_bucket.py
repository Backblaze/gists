import requests
import json

api_url = '' # Provided by b2_authorize_account
account_authorization_token = '' # Provided by b2_authorize_account
account_id = '' # Provided by b2_authorize_account
bucket_name = "any-name-you-pick"  # 63 char max: letters, digits, and hyphen -
bucket_type = "allPrivate"  # Either allPublic or allPrivate

response = requests.post(
    f"{api_url}/b2api/v4/b2_create_bucket",
    headers={"Authorization": account_authorization_token},
    json={
        "accountId": account_id,
        "bucketName": bucket_name,
        "bucketType": bucket_type
    }
)
response_data = response.json()
print(json.dumps(response_data, indent=2))
