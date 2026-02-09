import json
import requests

api_url = ""  # Provided by b2_authorize_account
account_authorization_token = ""  # Provided by b2_authorize_account
admin_account_id = ""  # Provided by b2_authorize_account
group_id = ""  # Provided by b2_list_groups
member_account_id = ""  # Provided by b2_create_group_member or b2_list_group_members

response = requests.post(
    f"{api_url}/b2api/v4/b2_eject_group_member",
    headers={"Authorization": account_authorization_token},
    json={
        "adminAccountId": admin_account_id,
        "groupId": group_id,
        "memberAccountId": member_account_id,
    },
)
response_data = response.json()
print(json.dumps(response_data, indent=2))
