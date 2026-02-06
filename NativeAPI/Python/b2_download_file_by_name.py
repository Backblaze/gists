import requests

download_url = ""  # Provided by b2_authorize_account
account_authorization_token = ""  # Provided by b2_authorize_account
bucket_name = ""  # The name of the bucket containing the file
file_name = ""  # The name of the file you want to download

response = requests.get(
    f"{download_url}/file/{bucket_name}/{file_name}",
    headers={"Authorization": account_authorization_token},
)
content = response.text
print(content)
