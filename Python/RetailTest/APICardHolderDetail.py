class APICardHolderDetail:

    def __init__(self, accountnumber):
        self.AccountNumber = accountnumber

    def APICardHolderDetail(self):
        import requests
        import json
        # import uuid
        # importing the requests library
        # defining the api-endpoint
        # API_ENDPOINT = "http://xeon-web1/PrasoonP/PrasoonPGetCardHolderDetail.aspx"
        # headers = {'Content-type': 'application/json', 'Accept': 'application/json'}

        # API_NAME = "GetCardHolderDetail"
        from APIHandlers import APIHandlers
        A1 = APIHandlers()
        headers = A1.headers
        API_ENDPOINT = A1.GetCardHolderDetail

        # data to be sent to api
        APICardHolderDetail = {
            "Password": "Test123!",
            "UserID": "platcall",
            "APIVersion": "",
            "AccountNumber": self.AccountNumber,
            "Source": "plat"
        }
        # sending post request and saving response as response object
        r = requests.post(url=API_ENDPOINT, json=APICardHolderDetail, headers=headers)
        RAPICardHolderDetail = json.loads(r.text)
        print(RAPICardHolderDetail)
        return RAPICardHolderDetail
