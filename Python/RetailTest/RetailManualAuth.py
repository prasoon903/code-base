class RetailManualAuth:

    def __init__(self, Accountnumber,
                 LoanAmountTax,
                 PlanID,
                 Retail1Amount,
                 Retail1EqualPayment,
                 Retail1Term,
                 Retail2Amount,
                 Retail2EqualPayment,
                 Retail2Term,
                 MTI
                 ):
        self.Accountnumber = Accountnumber
        self.LoanAmountTax = LoanAmountTax
        self.PlanID = PlanID
        self.Retail1Amount = Retail1Amount
        self.Retail2Amount = Retail2Amount
        self.Retail1Term = Retail1Term
        self.Retail2Term = Retail2Term
        self.Retail1EqualPayment = Retail1EqualPayment
        self.Retail2EqualPayment = Retail2EqualPayment
        self.MTI = MTI

    def RetailManualAuth(self):
        import requests,json,uuid
        # importing the requests library
        # defining the api-endpoint
        # API_ENDPOINT = "http://xeon-web1/PrasoonP/PrasoonPRetailManualAuth.aspx"
        # headers = {'Content-type': 'application/json', 'Accept': 'application/json'}

        # API_NAME = "RetailManualAuth"
        from APIHandlers import APIHandlers
        A1 = APIHandlers()
        headers = A1.headers

        API_ENDPOINT = A1.RetailManualAuth
        # print("Inside retail manualauth")

        # data to be sent to api
        RetailManualAuth = {
                            "UserID": "MilkUser",
                            "Password": "Test123!",
                            "APIVersion": "2.0",
                            "Source": "plat",
                            "Client": "RMA",
                            "TransactionType": self.MTI,
                            "AccountNumber": self.Accountnumber,
                            # "DateTime": null,
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
                                    "RMATranUUID": str(uuid.uuid4()),
                                    "Amount": self.LoanAmountTax,
                                    "TransactionDescription": "D42 Device 512GB Rose Gold",
                                    "CardAcceptorNameLocation": "Saturn Store #43 Phoenix AZUS",
                                    "ReverseRewards": "true",
                                    "ReverseMDR": "false",
                                    "OrderNumber": 111111,
                                    "InvoiceNumber": 22222,
                                    "TransmissionDateTime": 1210031223,
                                    "RMAGroupId": 1234
                                },
                                {
                                    "RMATranUUID": str(uuid.uuid4()),
                                    "PlanId": self.PlanID,
                                    "Amount": self.Retail1Amount,
                                    "TransactionDescription": "D43 Device 512GB Space Gray",
                                    "CardAcceptorNameLocation": "Saturn Store #43 Phoenix AZUS",
                                    "Term": self.Retail1Term,
                                    "MonthlyPaymentAmount": self.Retail1EqualPayment,
                                    "ReverseMDR": "true",
                                    "OrderNumber": 333333,
                                    "InvoiceNumber": "444444",
                                    "TransmissionDateTime": 1210031223,
                                    "RMAGroupId": 1234
                                },
                                {
                                    "RMATranUUID": str(uuid.uuid4()),
                                    "PlanId": self.PlanID,
                                    "Amount": self.Retail2Amount,
                                    "TransactionDescription": "D43 Device 512GB Space Gray",
                                    "CardAcceptorNameLocation": "Saturn Store #43 Phoenix AZUS",
                                    "Term": self.Retail2Term,
                                    "MonthlyPaymentAmount": self.Retail2EqualPayment,
                                    "ReverseMDR": "true",
                                    "OrderNumber": 333333,
                                    "InvoiceNumber": "444444",
                                    "TransmissionDateTime": 1210031223,
                                    "RMAGroupId": 1234
                                }
                            ]
                        }

        # sending post request and saving response as response object
        r = requests.post(url=API_ENDPOINT, json=RetailManualAuth, headers=headers)

        RRetailManualAuth= json.loads(r.text)
        return RRetailManualAuth

