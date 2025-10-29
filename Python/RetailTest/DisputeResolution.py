class DisputeResolution:
    """
    def __init__(self
                 , AccountNumber
                 , Action
                 , Reason
                 , Amount
                 , CaseID
                 ):
        self.AccountNumber = AccountNumber
        self.Action = Action
        self.Reason = Reason
        self.Amount = Amount
        self.CaseID = CaseID
    """

    def DisputeResolution(self
                             , AccountNumber
                             , Action
                             , Reason
                             , Amount
                             , CaseID):
        import json
        import requests

        # API_NAME = "ReceiveDisputeResolution"
        from APIHandlers import APIHandlers
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
                                "TransactionNumber": CaseID,
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
