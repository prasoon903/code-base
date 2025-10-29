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
                 MTI,
                 TransactionId,
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
        self.TransactionId = TransactionId

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

        # data to be sent to api
        RetailManualAuth = {
            "UserID": "platcall",
            "Password": "Test123!",
            "APIVersion": "2.0",
            "Source": "plat",
            "Client": "RMA",
            "TransactionType": self.MTI,
            "AccountNumber":  self.Accountnumber,
            "LoanDetails": "true",
            "DateTime": "20191218141203",
            "RequestId": str(uuid.uuid4()),
            "OtbRelease": "",
            "CurrencyCode": "840",
            "Authorizations": [

                {
                    "Uuid": str(uuid.uuid4()),
                    "Amount": self.LoanAmountTax,
                    "CardAcceptorNameLocation": "Merchant Name",
                    "APR": "",
                    "MerchantId": "426177173660295",
                    "TransactionId": self.TransactionId
                },
                {
                    "Uuid": str(uuid.uuid4()),
                    "PlanId": self.PlanID,
                    "Amount": self.Retail1Amount,
                    "CardAcceptorNameLocation": "Merchant Name",
                    "APR": "",
                    "MerchantId": "426177173660295",
                    "MonthlyPaymentAmount": self.Retail1EqualPayment,
                    "Term": self.Retail1Term,
                    "TransactionId": self.TransactionId
                },
                {
                    "Uuid": str(uuid.uuid4()),
                    "PlanId": self.PlanID,
                    "Amount": self.Retail2Amount,
                    "CardAcceptorNameLocation": "Merchant Name",
                    "APR": "",
                    "MerchantId": "426177173660295",
                    "MonthlyPaymentAmount": self.Retail2EqualPayment,
                    "Term": self.Retail2Term,
                    "TransactionId": self.TransactionId
                }


            ]
        }

        # sending post request and saving response as response object
        r = requests.post(url=API_ENDPOINT, json=RetailManualAuth, headers=headers)

        RRetailManualAuth= json.loads(r.text)
        return RRetailManualAuth

