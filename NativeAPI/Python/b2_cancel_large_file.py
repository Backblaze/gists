import requests
import json

api_url = ""  # Provided by b2_authorize_account
account_authorization_token = ""  # Provided by b2_authorize_account
file_id = ""  # Provided by b2_start_large_file

response = requests.post(
    f"{api_url}/b2api/v4/b2_cancel_large_file",
    headers={"Authorization": account_authorization_token},
    json={"fileId": file_id}
)
response_data = response.json()
print(json.dumps(response_data, indent=2))
