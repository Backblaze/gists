import json
import requests

api_url = ""  # Provided by b2_authorize_account
account_authorization_token = ""  # Provided by b2_authorize_account
member_email = (
    "new-b2-reserve-member-b2r@mycompany.com"  # Email address for account being created
)
term_in_days = 7  # Length of trial period in days
storage_in_tb = 10  # Amount of storage in TB

response = requests.post(
    f"{api_url}/b2api/v4/b2_reserve_trial_create_account",
    headers={"Authorization": account_authorization_token},
    json={"email": member_email, "term": term_in_days, "storage": storage_in_tb},
)
response_data = response.json()
print(json.dumps(response_data, indent=2))
