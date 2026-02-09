import json
import requests

api_url = ""  # Provided by b2_authorize_account
account_authorization_token = ""  # Provided by b2_authorize_account
account_id = ""  # Provided by b2_list_group_members
computer_id = ""  # Provided by bz_list_computers

response = requests.post(
    f"{api_url}/api/backup/v1/bz_delete_computer",
    headers={"Authorization": account_authorization_token},
    json={"accountId": account_id, "computerId": computer_id},
)
response_data = response.json()
print(json.dumps(response_data, indent=2))
