import requests
import json

api_url = ""  # Provided by b2_authorize_account
account_authorization_token = ""  # Provided by b2_authorize_account
application_key_id = ""  # The key to delete

response = requests.post(
    f"{api_url}/b2api/v4/b2_delete_key",
    headers={"Authorization": account_authorization_token},
    json={
        "applicationKeyId": application_key_id
    }
)
response_data = response.json()
print(json.dumps(response_data, indent=2))
