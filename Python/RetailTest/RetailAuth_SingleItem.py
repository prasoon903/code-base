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
                                    "UserID": "MilkUser",
                                    "Password": "Test123!",
                                    "APIVersion": "2.0",
                                    "Source": "plat",
                                    "Client": "RMA",
                                    "TransactionType": self.MTI,
                                    "AccountNumber": self.AccountNumber,
                                    # "DateTime": "20201218141203",
                                    "RequestId": str(uuid.uuid4()),
                                    "CurrencyCode": "840",
                                    "MerchantId": "426177173660295",
                                    "MerchantCategoryCode": "125",
                                    "MerchantCategoryName": "Dummy",
                                    "MerchantZip": "1245",
                                    "MerchantCity": "California",
                                    "MerchantState": "CA",
                                    "FraudBlob": str(uuid.uuid4()),
                                    "Authorizations": [
                                        {
                                            "RMATranUUID": self.PlanUUID,
                                            "PlanId": self.PlanID,
                                            "Amount": self.Amount,
                                            "TransactionDescription": "D43 Device 512GB Space Gray",
                                            "CardAcceptorNameLocation": "Saturn Store #43 Phoenix AZUS",
                                            "Term": self.Term,
                                            "MonthlyPaymentAmount": self.EqualPaymentAmount,
                                            "ReverseMDR": "true",
                                            "OrderNumber": 333333,
                                            "InvoiceNumber": "444444",
                                            "TransmissionDateTime": 1210031223,
                                            "RMAGroupId": 1234
                                        }
                                    ]
                                }

        # print("After")
        # print(RetailAuth_SingleItem)

        # sending post request and saving response as response object
        r = requests.post(url=API_ENDPOINT, json=RetailAuth_SingleItem, headers=headers)

        RRetailAuth_SingleItem = json.loads(r.text)
        return RRetailAuth_SingleItem
