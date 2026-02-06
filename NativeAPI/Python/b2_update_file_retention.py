import requests
import json

api_url = ""  # Provided by b2_authorize_account
account_authorization_token = ""  # Provided by b2_authorize_account
file_id = ""  # The fileId of the file you want to update
file_name = ""  # The name of the file you want to update
mode = ""  # "compliance" or "governance"
retain_until_timestamp = 1770338946123  # Epoch time in milliseconds

response = requests.post(
    f"{api_url}/b2api/v4/b2_update_file_retention",
    headers={"Authorization": account_authorization_token},
    json={
        "fileName": file_name,
        "fileId": file_id,
        "fileRetention": {
            "mode": mode,
            "retainUntilTimestamp": retain_until_timestamp
        }
    }
)
response_data = response.json()
print(json.dumps(response_data, indent=2))
