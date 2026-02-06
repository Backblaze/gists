import requests
import json

api_url = ""  # Provided by b2_authorize_account
account_id = ""  # Provided by b2_authorize_account
account_authorization_token = ""  # Provided by b2_authorize_account
capabilities = []  # Array of key capabilities
key_name = ""  # Name for the key
valid_duration_in_seconds = 0  # Validity period, positive integer less than 86,400,000 (optional)
bucket_ids = []  # Restrict key to these buckets (optional)
name_prefix = ""  # Restrict access to files with names starting with this prefix (optional)

response = requests.post(
    f"{api_url}/b2api/v4/b2_create_key",
    headers={"Authorization": account_authorization_token},
    json={
        "accountId": account_id,
        "capabilities": capabilities,
        "keyName": key_name,
        "validDurationInSeconds": valid_duration_in_seconds,
        "bucketIds": bucket_ids,
        "namePrefix": name_prefix
    }
)
response_data = response.json()
print(json.dumps(response_data, indent=2))
