class RetailAuth_SingleItem:
    def __init__(self
                 , AccountNumber
                 , Amount
                 , PlanID
                 , EqualPaymentAmount
                 , Term
                 , MTI
                 , TransactionID
                 , PlanUUID):
        self.AccountNumber = AccountNumber
        self.Amount = Amount
        self.PlanID = PlanID
        self.EqualPaymentAmount = EqualPaymentAmount
        self.Term = Term
        self.MTI = MTI
        self.TransactionID = TransactionID
        self.PlanUUID = PlanUUID

    def RetailAuth_SingleItem(self):
        import json
        import requests
        import uuid

        # API_NAME = "RetailManualAuth"
        from APIHandlers import APIHandlers
        A1 = APIHandlers()
        headers = A1.headers

        API_ENDPOINT = A1.RetailManualAuth

        if self.MTI != "9220":
            self.PlanUUID = str(uuid.uuid4())

        # print("Before")

        RetailAuth_SingleItem = {
                                    "UserID": "PlatCall",
                                    "Password": "Test123!",
                                    "APIVersion": "2.0",
                                    "Source": "plat",
                                    "Client": "RMA",
                                    "TransactionType": self.MTI,
                                    "AccountNumber": self.AccountNumber,
                                    "LoanDetails": "true",
                                    "DateTime": "20191218141203",
                                    "RequestId": str(uuid.uuid4()),
                                    "OtbRelease": "",
                                    "CurrencyCode": "840",
                                    "Authorizations": [
                                        {
                                            "Uuid": self.PlanUUID,
                                            "PlanId": self.PlanID,
                                            "Amount": self.Amount,
                                            "CardAcceptorNameLocation": "Merchant Name",
                                            "APR": "",
                                            "MerchantId": "426177173660295",
                                            "MonthlyPaymentAmount": self.EqualPaymentAmount,
                                            "Term": self.Term,
                                            "TransactionId": self.TransactionID
                                        }
                                    ]
                                }

        # print("After")
        # print(RetailAuth_SingleItem)

        # sending post request and saving response as response object
        r = requests.post(url=API_ENDPOINT, json=RetailAuth_SingleItem, headers=headers)

        RRetailAuth_SingleItem = json.loads(r.text)
        return RRetailAuth_SingleItem
