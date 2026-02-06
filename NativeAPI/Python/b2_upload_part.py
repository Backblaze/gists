import requests
import json
import hashlib
import os

upload_url = ""  # Provided by b2_get_upload_part_url
upload_authorization_token = ""  # Provided by b2_get_upload_part_url
local_file = "/path/to/file/on/disk"
local_file_size = os.stat(local_file).st_size
minimum_part_size = 5 * 1024 * 1024  #
size_of_part = minimum_part_size
total_bytes_sent = 0
part_no = 1
part_sha1_array = []

with open(local_file, "rb") as filed:
    while total_bytes_sent < local_file_size:
        if (local_file_size - total_bytes_sent) < minimum_part_size:
            size_of_part = local_file_size - total_bytes_sent
        file_data = filed.read(size_of_part)
        sha1_digester = hashlib.new("SHA1")
        sha1_digester.update(file_data)
        sha1_str = sha1_digester.hexdigest()
        part_sha1_array.append(sha1_str)
        response = requests.post(
            upload_url,
            headers={
                "Authorization": upload_authorization_token,
                "X-Bz-Part-Number": str(part_no),
                "X-Bz-Content-Sha1": sha1_str
            },
            data=file_data
        )
        response_data = response.json()
        print(json.dumps(response_data, indent=2))
        total_bytes_sent = total_bytes_sent + size_of_part
        part_no += 1
