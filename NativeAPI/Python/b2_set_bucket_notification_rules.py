import requests
import json

api_url = ""  # Provided by b2_authorize_account
account_authorization_token = ""  # Provided by b2_authorize_account
bucket_id = ""  # Provided by b2_list_buckets
event_types = [ "b2:ObjectCreated:Upload", "b2:ObjectCreated:MultipartUpload" ]  # Events that will trigger the rule
rule_name = ""  # The name of the rule you want to create
prefix = ""  # The file name prefix to which the rule applies
url = "https://www.example.com"  # Your webhook URL

response = requests.post(
    f"{api_url}/b2api/v4/b2_set_bucket_notification_rules",
    headers={"Authorization": account_authorization_token},
    json={
        "bucketId": bucket_id,
        "eventNotificationRules": [
            {
                "eventTypes": event_types,
                "isEnabled": True,
                "name": rule_name,
                "objectNamePrefix": prefix,
                "targetConfiguration": {
                    "targetType": "webhook",
                    "url": url
                }
            }
        ]
    }
)
response_data = response.json()
print(json.dumps(response_data, indent=2))
