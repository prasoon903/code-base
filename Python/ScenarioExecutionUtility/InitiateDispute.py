import json
import requests
from APIHandlers import APIHandlers

def InitiateDispute(AccountNumber
                , Action
                , Reason
                , Amount
                , TranID):
    

    # API_NAME = "InitiateTransactionDispute"
    
    A1 = APIHandlers()
    headers = A1.headers

    API_ENDPOINT = A1.InitiateTransactionDispute

    InitiateDispute = {
                        "Password": "Test123!",
                        "UserID": "PlatCall",
                        "APIVersion": "2.0",
                        "AccountNumber": AccountNumber,
                        "Action": Action,
                        "AdminNumber": "",
                        "ApplicationVersion": "",
                        "CalledID": "",
                        "CallerID": "",
                        "CardNumber": "",
                        "IPAddress": "",
                        "Notes": "",
                        "Reason": Reason,
                        "TransactionAmount": Amount,
                        "RequestTime": "",
                        "SessionID": "",
                        "Source": "PLAT",
                        "TransactionNumber": TranID,
                        "CardIssuerReferenceData": "",
                        "AccountUUID": "",
                        "AdminUUID": ""
                    }

    # sending post request and saving response as response object
    # print(InitiateDispute)
    r = requests.post(url=API_ENDPOINT, json=InitiateDispute, headers=headers)

    RInitiateDispute = json.loads(r.text)
    return RInitiateDispute
