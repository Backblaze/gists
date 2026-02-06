import requests
import json

api_url = ""  # Provided by b2_authorize_account
account_authorization_token = ""  # Provided by b2_authorize_account
file_id = ""  # The fileId of the file you want to update
file_name = ""  # The name of the file you want to update
legal_hold = ""  # "on" or "off"

response = requests.post(
    f"{api_url}/b2api/v4/b2_update_file_legal_hold",
    headers={"Authorization": account_authorization_token},
    json={
        "fileName": file_name,
        "fileId": file_id,
        "legalHold": legal_hold
    }
)
response_data = response.json()
print(json.dumps(response_data, indent=2))
