import json
import requests
import uuid
from APIHandlers import APIHandlers


def MergeAccounts(SourceAccountNumber,
                    DestinationAccountNumber,
                    NewCreditLimit):
    
    A1 = APIHandlers()
    headers = A1.headers

    Message = ""

    API_ENDPOINT = A1.MergeAccounts

    MergeAPI = {
                  
                "Password": "Test123!",
                "UserID": "PlatCall",
                "APIVersion": "2.0",
                "ApplicationVersion": "",
                "CalledID": "",
                "CallerID": "",
                "IPAddress": "",
                "RequestTime": "",
                "SessionID": "",
                "Source": "Plat",
                "SourceAccountNumber": SourceAccountNumber,
                "DestinationAccountNumber": DestinationAccountNumber,
                "SourceAccountUUID": "",
                "DestinationAccountUUID": "",
                "NewCreditLimit": NewCreditLimit

                }

    r = requests.post(url=API_ENDPOINT, json=MergeAPI, headers=headers)

    RMergeAPI = json.loads(r.text)

    Message = "Merge API response  :: " + RMergeAPI["ErrorMessage"]
    
    return RMergeAPI, Message
