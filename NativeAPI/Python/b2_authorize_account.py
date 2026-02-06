import requests
import json

# You use either your master application key, provided by the B2 web console,
# or an application key created in the B2 web console or using the b2_create_key
# API.
application_key_id = ""
application_key = ""

response = requests.get(
    "https://api.backblazeb2.com/b2api/v4/b2_authorize_account",
    auth=(application_key_id, application_key)
)
response_data = response.json()
print(json.dumps(response_data, indent=2))
