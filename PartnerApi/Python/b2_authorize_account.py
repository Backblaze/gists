import json
import requests

master_application_key_id = ""  # Obtained from your B2 account page.
master_application_key = ""  # Obtained from your B2 account page.

response = requests.get(
    "https://api.backblazeb2.com/b2api/v4/b2_authorize_account",
    auth=(master_application_key_id, master_application_key),
)
response_data = response.json()
print(json.dumps(response_data, indent=2))
