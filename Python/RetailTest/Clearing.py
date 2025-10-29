class Clearing:
    # importing the requests library
    # defining the api-endpoint
    # API_ENDPOINT = "http://xeon-web1/PrasoonP/PrasoonPclearing.aspx"
    # headers = {'Content-type': 'application/json', 'Accept': 'application/json'}

    def __init__(self,
                 AccountNumber,
                 TranType,
                 ReversalTranID,
                 Amount):

        self.AccountNumber = AccountNumber
        self.TranType = TranType
        self.ReversalTranID = ReversalTranID
        self.Amount = Amount

    def clearing(self):
        import json
        import requests

        # API_NAME = "PostSingleTransaction"
        from APIHandlers import APIHandlers
        A1 = APIHandlers()
        headers = A1.headers

        API_ENDPOINT = A1.PostSingleTransaction

        # data to be sent to api
        clearing = {
            "Password": "Test123!",
            "UserID": "platcall",
            "AccountNumber": self.AccountNumber,
            "AdminNumber": "",
            "APIVersion": "2.0",
            "ApplicationVersion": "",
            "ApprovalCode": "",
            "CalledID": "",
            "CallerID": "",
            "CardAcceptorBusinessCode": "",
            "CardAcceptorIdCode": "",
            "CardAcceptorNameLocation": "",
            "CardAcceptorTerminalID": "",
            "CreditPlanMaster": "",
            "DateTimeLocalTransaction": "",
            "InventoryCode": "",
            "IPAddress": "",
            "LineItemSequenceNumber": "",
            "MerchantType": "",
            "MessageTypeIdentifier": "",
            "PaymentType": "",
            "PrimaryAccountNumber": "",
            "Quantity": "",
            "RequestTime": "",
            "RetrievalReferenceNumber": "",
            "ReversalTargetTranID": self.ReversalTranID,
            "SessionID": "",
            "Source": "plat",
            "SpecialMerchantIdentifier": "",
            "SystemTraceAuditNumber": "",
            "TMInvoiceNumber": "",
            "TNPFlag": "",
            "TranType": self.TranType,
            "TransactionAmount": self.Amount,
            "TransactionCurrencyCode": "",
            "TransactionDescription": "",
            "TransmissionDateTime": "",
            "TransactionTime": "",
            "TransactionPostTime": "",
            "UnitPrice": ""
        }

        # sending post request and saving response as response object
        # print(clearing)
        r = requests.post(url=API_ENDPOINT, json=clearing, headers=headers)

        Rclearing = json.loads(r.text)
        return Rclearing
