import requests
import json

api_url = ""  # Provided by b2_authorize_account
account_authorization_token = ""  # Provided by b2_authorize_account
file_name = ""  # The name of the file you want to delete
file_id = ""  # The fileId of the file you want to delete

response = requests.post(
    f"{api_url}/b2api/v4/b2_delete_file_version",
    headers={"Authorization": account_authorization_token},
    json={
        "fileName": file_name,
        "fileId": file_id
    }
)
response_data = response.json()
print(json.dumps(response_data, indent=2))
