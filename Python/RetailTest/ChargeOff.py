class ChargeOff:

    def ChargeOff(self,
                  AccountNumber
                     , Status
                     , Reason):
        import json
        import requests

        # API_NAME = "ApplyManualChargeOff"
        from APIHandlers import APIHandlers
        A1 = APIHandlers()
        headers = A1.headers

        API_ENDPOINT = A1.ApplyManualChargeOff

        ChargeOff = {
                        "Password": "Test123!",
                        "UserID": "PlatCall",
                        "ApplicationVersion": "",
                        "APIVersion": "2.0",
                        "CalledID": "",
                        "CallerID": "",
                        "IPAddress": "",
                        "SessionID": "",
                        "AccountNumber": AccountNumber,
                        "AdminNumber": "",
                        "AccountId": "",
                        "ManualChargeOffStatus": Status,
                        "ManualChargeOffReason": Reason,
                        "FinalStatement": "1",
                        "ManualChargeOffStartDate": "",
                        "TimingOption": "1",
                        "AutoInitialChargeOff": "",
                        "RequestTime": "",
                        "Source": "PLAT"
                    }

        # sending post request and saving response as response object
        # print(ChargeOff)
        r = requests.post(url=API_ENDPOINT, json=ChargeOff, headers=headers)

        Rchargeoff = json.loads(r.text)
        return Rchargeoff
