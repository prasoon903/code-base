import json
import requests
from APIHandlers import APIHandlers

def AccountUpdate(AccountNumber
                    , Field1
                    , Value1
                    , Field2 = ""
                    , Value2 = ""):
    
    # API_NAME = "AddManualStatusToAccount"
    
    A1 = APIHandlers()
    headers = A1.headers
    API_ENDPOINT = A1.AccountUpdate

    AccountUpdate = {
                        "Password": "Test123!",
                        "UserID": "PlatCall",
                        "AccountNumber": AccountNumber,
                        "CardNumber": "",
                        "Field1": Field1,
                        "Value1": Value1,
                        "Field2": Field2,
                        "Value2": Value2,
                        "ApplicationVersion": "2.0",
                        "APIVersion": "",
                        "CalledID": "",
                        "CallerID": "",
                        "IPAddress": "",
                        "SessionID": "",
                        "Source": "PLAT"
                    }

    # sending post request and saving response as response object
    r = requests.post(url=API_ENDPOINT, json=AccountUpdate, headers=headers)

    RAccountUpdate = json.loads(r.text)
    return RAccountUpdate