import requests

api_url = ""  # Provided by b2_authorize_account
account_authorization_token = ""  # Provided by b2_authorize_account
file_id = ""  # The fileId of the file you want to download

response = requests.get(
    f"{api_url}/b2api/v4/b2_download_file_by_id",
    headers={"Authorization": account_authorization_token},
    params={"fileId": file_id}
)
content = response.text
print(content)
