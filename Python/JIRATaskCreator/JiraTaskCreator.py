import requests
from requests.auth import HTTPBasicAuth
import json

# Replace with your own details
JIRA_DOMAIN = "https://corecard.atlassian.net"
EMAIL = "prasoon.parashar@corecard.com"
API_TOKEN = "ATATT3xFfGF07ucHHFlug1ho0U4Y8lZ6oaQba5S8u1aNn-d6gtsX5cBz5ytLHOxf-Gvw3BMv4S9GwiSHml8u5Pgvr3-Ln8TBNS8I0UhyKUB6wxfXlPrD8q-puIfKZxEJp5Dnc8QpENbEfGyhg_G9yw3rDMbS5Y_g-RrfNGKukOiSkQ2PnPUUvR8=5FC8B27B"
PROJECT_KEY = 10028
PARENT_ISSUE_KEY = "PLAT-218696"  # The task under which to create the sub-task

url = f"https://{JIRA_DOMAIN}/rest/api/2/issue"

headers = {
    "Content-Type": "application/json"
}

payload = {
    "fields": {
        "project": {
            "key": PROJECT_KEY
        },
        "parent": {
            "key": PARENT_ISSUE_KEY
        },
        "summary": "This is the sub-task summary",
        "description": "Detailed description of the sub-task",
        "issuetype": {
            "name": "Sub-task"
        }
    }
}

response = requests.post(
    url,
    headers=headers,
    data=json.dumps(payload),
    auth=HTTPBasicAuth(EMAIL, API_TOKEN)
)

if response.status_code == 201:
    print("Sub-task created successfully:", response.json()["key"])
else:
    print("Failed to create sub-task")
    print("Status Code:", response.status_code)
    print("Response:", response.text)
