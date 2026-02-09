import hashlib
import requests
import json

upload_url = "" # Provided by b2_get_upload_url
upload_authorization_token = "" # Provided by b2_get_upload_url
file_data = "The quick brown fox jumps over the lazy dog."
file_name = "typing_test.txt"
content_type = "text/plain"
sha1_of_file_data = hashlib.sha1(file_data.encode("utf-8")).hexdigest()

response = requests.post(
    upload_url,
    headers={
        "Authorization": upload_authorization_token,
        "X-Bz-File-Name": file_name,
        "Content-Type": content_type,
        "X-Bz-Content-Sha1": sha1_of_file_data
    },
    data=file_data
)
response_data = response.json()
print(json.dumps(response_data, indent=2))
