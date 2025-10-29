import requests
import uuid
import json
from APIHandlers import APIHandlers


def RetailManualAuth(Accountnumber,
                LoanAmountTax,
                PlanID,
                Retail1Amount,
                Retail1EqualPayment,
                Retail1Term,
                Retail2Amount,
                Retail2EqualPayment,
                Retail2Term,
                MTI):
    
    A1 = APIHandlers()
    headers = A1.headers

    API_ENDPOINT = A1.RetailManualAuth

    # data to be sent to api
    RetailManualAuth = {
                        "UserID": "MilkUser",
                        "Password": "Test123!",
                        "APIVersion": "2.0",
                        "Source": "plat",
                        "Client": "RMA",
                        "TransactionType": MTI,
                        "AccountNumber": Accountnumber,
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
                                "Amount": LoanAmountTax,
                                "TransactionDescription": "D42 Device 512GB Rose Gold",
                                "CardAcceptorNameLocation": "Saturn Store #43 Phoenix AZUS",
                                "ReverseRewards": "true",
                                "ReverseMDR": "false",
                                "OrderNumber": 111111,
                                "InvoiceNumber": 22222,
                                "RMAGroupId": 1234
                            },
                            {
                                "RMATranUUID": str(uuid.uuid4()),
                                "PlanId": PlanID,
                                "Amount": Retail1Amount,
                                "TransactionDescription": "D43 Device 512GB Space Gray",
                                "CardAcceptorNameLocation": "Saturn Store #43 Phoenix AZUS",
                                "Term": Retail1Term,
                                "MonthlyPaymentAmount": Retail1EqualPayment,
                                "ReverseMDR": "true",
                                "OrderNumber": 333333,
                                "InvoiceNumber": "444444",
                                "RMAGroupId": 1234
                            },
                            {
                                "RMATranUUID": str(uuid.uuid4()),
                                "PlanId": PlanID,
                                "Amount": Retail2Amount,
                                "TransactionDescription": "D43 Device 512GB Space Gray",
                                "CardAcceptorNameLocation": "Saturn Store #43 Phoenix AZUS",
                                "Term": Retail2Term,
                                "MonthlyPaymentAmount": Retail2EqualPayment,
                                "ReverseMDR": "true",
                                "OrderNumber": 333333,
                                "InvoiceNumber": "444444",
                                "RMAGroupId": 1234
                            }
                        ]
                    }

    # sending post request and saving response as response object
    r = requests.post(url=API_ENDPOINT, json=RetailManualAuth, headers=headers)

    RRetailManualAuth= json.loads(r.text)
    return RRetailManualAuth

