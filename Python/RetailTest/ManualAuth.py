class ManualAuth:

    def __init__(self, TestNumber, LoopCount, Accountnumber,
                 TransactionAmount, MTI):
        self.TestNumber = TestNumber
        self.Accountnumber = Accountnumber
        self.TransactionAmount = TransactionAmount
        self.MTI = MTI
        self.LoopCount = LoopCount

    def ManualAuth(self):
        import requests
        import json
        import uuid
        import os

        Directory = "TestNumber_" + str(self.TestNumber) + "/"
        Path = Directory + 'VirtualCard/'
        # importing the requests library
        # defining the api-endpoint
        # API_ENDPOINT = "http://xeon-web1/PrasoonP/PrasoonPFNLManualAuth.aspx"
        # headers = {'Content-type': 'application/json', 'Accept': 'application/json'}

        # API_NAME = "ManualAuth"
        from APIHandlers import APIHandlers
        A1 = APIHandlers()
        headers = A1.headers

        API_ENDPOINT = A1.ManualAuth

        FileName = 'TestVirtualCard_' + str(self.TestNumber) + '_' + str(self.LoopCount) + '.json'

        with open(os.path.join(Path, FileName)) as json_file:
            RVirtualCard = json.load(json_file)

        CardNumber = RVirtualCard["CardNumber"]

        # data to be sent to api
        ManualAuth = {
            'Password': 'Test123!',
            'UserID': 'MilkUser',
            'APIVersion': '2.0',
            'AccountNumber': self.Accountnumber,
            'CardNumber':  CardNumber,
            'Client': 'RMA',
            'Source': 'Plat',
            'TransactionAmount': self.TransactionAmount,
            'ProcCode': '',
            'TransactionType': self.MTI,
            'CardholderPresenceInd': '1',
            'CardPresenceInd': '0',
            'TransactionDefinition': 'RetailManualAuth',
            'PosTransactionStatusIndicator': '',
            'TokenNumberIndicator': '',
            'TraceID': '',
            'AuthTranID': '',
            'RequestId': str(uuid.uuid4())
        }
        # sending post request and saving response as response object
        r = requests.post(url=API_ENDPOINT, json=ManualAuth, headers=headers)

        RManualAuth = json.loads(r.text)
        return RManualAuth
