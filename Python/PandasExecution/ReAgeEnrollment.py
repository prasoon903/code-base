import json
import requests
from APIHandlers import APIHandlers

def ReAgeEnrollment(AccountNumber
                , PaymentOptions
                , FixedPaymentAmount
                , NumberOfPayments
                , WaiveInterest):
    

    # API_NAME = "InitiateTransactionDispute"
    
    A1 = APIHandlers()
    headers = A1.headers

    API_ENDPOINT = A1.InitiateTransactionDispute

    ReAgeEnrollment = {
                        "Password": "Test123!",
                        "UserID": "PLATCall",
                        "AccountNumber":AccountNumber,
                        "AdminNumber": "",
                        "CardNumber": "",
                        "AccountUUID":"",
                        "AdminUUID":"",
                        "PaymentOptions":PaymentOptions,
                        "FixedPaymentAmount":FixedPaymentAmount,
                        "NumberOfPayments":NumberOfPayments,
                        "WaiveInterest":WaiveInterest,
                        "EnrollmentId":"",
                        "Source":"PLAT",
                        "IPAddress": "",
                        "CallerID": "",
                        "CalledID": "",
                        "RequestTime": "",
                        "SessionID": "",
                        "APIVersion": "2.0",
                        "ApplicationVersion": "0"
                    }

    # sending post request and saving response as response object
    # print(InitiateDispute)
    r = requests.post(url=API_ENDPOINT, json=ReAgeEnrollment, headers=headers)

    RReAgeEnrollment = json.loads(r.text)
    return RReAgeEnrollment
