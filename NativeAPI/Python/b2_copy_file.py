import requests
import json

api_url = '' # Provided by b2_authorize_account
account_authorization_token = '' # Provided by b2_authorize_account
source_file_id = '' # The file you wish to copy
file_name = 'test-b2-copy-file-python'

response = requests.post(
    f"{api_url}/b2api/v4/b2_copy_file",
    headers={"Authorization": account_authorization_token},
    json={
        "sourceFileId": source_file_id,
        "fileName": file_name
    }
)
response_data = response.json()
print(json.dumps(response_data, indent=2))
