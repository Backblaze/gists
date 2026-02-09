import requests
import json

api_url = '' # Provided by b2_authorize_account
account_authorization_token = '' # Provided by b2_authorize_account
source_file_id = '' # The file you wish to copy
large_file_id = '' # Provided by b2_start_large_file
part_number = 1

response = requests.post(
    f"{api_url}/b2api/v4/b2_copy_part",
    headers={"Authorization": account_authorization_token},
    json={
        "sourceFileId": source_file_id,
        "largeFileId": large_file_id,
        "partNumber": 1
    }
)
response_data = response.json()
print(json.dumps(response_data, indent=2))
