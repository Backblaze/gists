import requests
import json

api_url = '' # Provided by b2_authorize_account
account_authorization_token = '' # Provided by b2_authorize_account
account_id = '' # Provided by b2_authorize_account

response = requests.post(
    f"{api_url}/b2api/v4/b2_list_buckets",
    headers={"Authorization": account_authorization_token},
    json={"accountId": account_id}
)
response_data = response.json()
print(json.dumps(response_data, indent=2))
