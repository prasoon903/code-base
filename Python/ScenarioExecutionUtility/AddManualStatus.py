import json
import requests
from APIHandlers import APIHandlers

def AddManualStatus(AccountNumber
                    , Status
                    , Date = ""):
    
    # API_NAME = "AddManualStatusToAccount"
    
    A1 = APIHandlers()
    headers = A1.headers
    API_ENDPOINT = A1.AddManualStatusToAccount

    AddManualStatusToAccount = {
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
                                    "Source": "Plat",
                                    "EffectiveEndDate": Date
                                }

    # sending post request and saving response as response object
    r = requests.post(url=API_ENDPOINT, json=AddManualStatusToAccount, headers=headers)

    RAddManualStatusToAccount = json.loads(r.text)
    return RAddManualStatusToAccount