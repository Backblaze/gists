import requests
import json

api_url = ""  # Provided by b2_authorize_account
account_authorization_token = ""  # Provided by b2_authorize_account
file_id = ""  # Provided by b2_start_large_file

response = requests.get(
    f"{api_url}/b2api/v4/b2_get_upload_part_url",
    headers={"Authorization": account_authorization_token},
    params={"fileId": file_id}
)
response_data = response.json()
print(json.dumps(response_data, indent=2))
