import requests
import json

api_url = ""  # Provided by b2_authorize_account
account_authorization_token = ""  # Provided by b2_authorize_account
file_id = ""  # The fileId of the file you want to get info on

response = requests.get(
    f"{api_url}/b2api/v4/b2_get_file_info",
    headers={"Authorization": account_authorization_token},
    params={"fileId": file_id}
)
response_data = response.json()
print(json.dumps(response_data, indent=2))
