import requests
import json

api_url = ""  # Provided by b2_authorize_account
account_authorization_token = ""  # Provided by b2_authorize_account
file_id = ""  # Provided by b2_start_large_file
part_sha1_array = ["<sha1_of_part_1>", "<sha1_of_part_2>", "<sha1_of_part_3>"]  # See b2_upload_part

response = requests.post(
    f"{api_url}/b2api/v4/b2_finish_large_file",
    headers={"Authorization": account_authorization_token},
    json={
        "fileId": file_id,
        "partSha1Array": part_sha1_array
    }
)
response_data = response.json()
print(json.dumps(response_data, indent=2))
