class InitiateDispute:
    def __init__(self
                 , AccountNumber
                 , Action
                 , Reason
                 , Amount
                 , TranID
                 ):
        self.AccountNumber = AccountNumber
        self.Action = Action
        self.Reason = Reason
        self.Amount = Amount
        self.TranID = TranID

    def InitiateDispute(self):
        import json
        import requests

        # API_NAME = "InitiateTransactionDispute"
        from APIHandlers import APIHandlers
        A1 = APIHandlers()
        headers = A1.headers

        API_ENDPOINT = A1.InitiateTransactionDispute

        InitiateDispute = {
                            "Password": "Test123!",
                            "UserID": "PlatCall",
                            "APIVersion": "2.0",
                            "AccountNumber": self.AccountNumber,
                            "Action": self.Action,
                            "AdminNumber": "",
                            "ApplicationVersion": "",
                            "CalledID": "",
                            "CallerID": "",
                            "CardNumber": "",
                            "IPAddress": "",
                            "Notes": "",
                            "Reason": self.Reason,
                            "TransactionAmount": self.Amount,
                            "RequestTime": "",
                            "SessionID": "",
                            "Source": "PLAT",
                            "TransactionNumber": self.TranID,
                            "CardIssuerReferenceData": "",
                            "AccountUUID": "",
                            "AdminUUID": ""
                        }

        # sending post request and saving response as response object
        # print(InitiateDispute)
        r = requests.post(url=API_ENDPOINT, json=InitiateDispute, headers=headers)

        RInitiateDispute = json.loads(r.text)
        return RInitiateDispute
