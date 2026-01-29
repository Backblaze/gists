import json
import requests

api_url = ""  # Provided by b2_authorize_account
account_authorization_token = ""  # Provided by b2_authorize_account
admin_account_id = ""  # Provided by b2_authorize_account
group_id = ""  # Provided by b2_list_groups
member_email = (
    "new-group-member@mycompany.com"  # Email address for account being created
)


response = requests.post(
    f"{api_url}/b2api/v4/b2_create_group_member",
    headers={"Authorization": account_authorization_token},
    json={
        "adminAccountId": admin_account_id,
        "groupId": group_id,
        "memberEmail": member_email,
    },
)
response_data = response.json()
print(json.dumps(response_data, indent=2))
