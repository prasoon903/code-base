import json
import requests
from APIHandlers import APIHandlers

def RemoveManualStatus(AccountNumber, Status):
    
    # API_NAME = "AddManualStatusToAccount"
    
    A1 = APIHandlers()
    headers = A1.headers
    API_ENDPOINT = A1.RemoveManualStatus

    RemoveManualStatusToAccount = {
                                    "Password": "Test123!",
                                    "UserID": "PLATCall",
                                    "APIVersion": "2.0",
                                    "AccountNumber": AccountNumber,
                                    "AdminNumber": "",
                                    "ApplicationVersion": "",
                                    "CardNumber": "",
                                    "CalledID": "",
                                    "CallerID": "",
                                    "IPAddress": "",
                                    "ManualStatus": Status,
                                    "RequestTime": "",
                                    "SessionID": "",
                                    "Source": "Plat"
                                }

    # sending post request and saving response as response object
    r = requests.post(url=API_ENDPOINT, json=RemoveManualStatusToAccount, headers=headers)

    RRemoveManualStatusToAccount = json.loads(r.text)
    return RRemoveManualStatusToAccount