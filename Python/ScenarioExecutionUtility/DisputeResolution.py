import json
import requests
from APIHandlers import APIHandlers

def DisputeResolution(self
                        , AccountNumber
                        , Action
                        , Reason
                        , Amount
                        , TranID
                        , CaseID):
    

    # API_NAME = "ReceiveDisputeResolution"
    
    A1 = APIHandlers()
    headers = A1.headers

    API_ENDPOINT = A1.ReceiveDisputeResolution

    DisputeResolution = {
                            "Password": "Test123!",
                            "UserID": "PlatCall",
                            "APIVersion": "2.0",
                            "AccountNumber": AccountNumber,
                            "Action": Action,
                            "AdminNumber": "",
                            "ApplicationVersion": "",
                            "CPM1": "",
                            "CPM2": "",
                            "CPM3": "",
                            "CPM4": "",
                            "CalledID": "",
                            "CallerID": "",
                            "CardNumber": "",
                            "IPAddress": "",
                            "Notes": "2",
                            "Reason": Reason,
                            "RequestTime": "",
                            "SessionID": "",
                            "Source": "PLAT",
                            "TransactionAmount": Amount,
                            "TransactionDate": "",
                            "TransactionNumber": TranID,
                            "TransactionTime": "",
                            "TxnAmount1": "",
                            "TxnAmount2": "",
                            "TxnAmount3": "",
                            "TxnAmount4": "",
                            "CardIssuerReferenceData": CaseID,
                            "ResolvedTranID": "",
                            "AccountUUID": "",
                            "AdminUUID": ""
                        }

    # sending post request and saving response as response object
    r = requests.post(url=API_ENDPOINT, json=DisputeResolution, headers=headers)

    RDisputeResolution = json.loads(r.text)
    return RDisputeResolution
