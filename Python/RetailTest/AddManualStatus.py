class AddManualStatus:
    def __init__(self
                 , AccountNumber
                 , Status
                 , Date
                 ):
        self.AccountNumber = AccountNumber
        self.Status = Status
        self.Date = Date

    def AddManualStatus(self):
        import json
        import requests

        # API_NAME = "AddManualStatusToAccount"
        from APIHandlers import APIHandlers
        A1 = APIHandlers()
        headers = A1.headers
        API_ENDPOINT = A1.AddManualStatusToAccount

        AddManualStatusToAccount = {
                                        "Password": "Test123!",
                                        "UserID": "PLATCall",
                                        "APIVersion": "2.0",
                                        "AccountNumber": self.AccountNumber,
                                        "AdminNumber": "",
                                        "ApplicationVersion": "",
                                        "CardNumber": "",
                                        "CalledID": "",
                                        "CallerID": "",
                                        "IPAddress": "",
                                        "ManualStatus": self.Status,
                                        "RequestTime": "",
                                        "SessionID": "",
                                        "Source": "Plat",
                                        "EffectiveEndDate": self.Date
                                    }

        # sending post request and saving response as response object
        r = requests.post(url=API_ENDPOINT, json=AddManualStatusToAccount, headers=headers)

        RAddManualStatusToAccount = json.loads(r.text)
        return RAddManualStatusToAccount