import json
import requests
import uuid
from APIHandlers import APIHandlers


def RetailAuth_SingleItem(AccountNumber
                , Amount
                , PlanID
                , EqualPaymentAmount
                , Term
                , MTI
                , PlanUUID):
    
    A1 = APIHandlers()
    headers = A1.headers

    API_ENDPOINT = A1.RetailManualAuth

    RetailAuth_SingleItem = {
                                "UserID": "MilkUser",
                                "Password": "Test123!",
                                "APIVersion": "2.0",
                                "Source": "plat",
                                "Client": "RMA",
                                "TransactionType": MTI,
                                "AccountNumber": AccountNumber,
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
                                        "RMATranUUID": PlanUUID,
                                        "PlanId": PlanID,
                                        "Amount": Amount,
                                        "TransactionDescription": "D43 Device 512GB Space Gray",
                                        "CardAcceptorNameLocation": "Saturn Store #43 Phoenix AZUS",
                                        "Term": Term,
                                        "MonthlyPaymentAmount": EqualPaymentAmount,
                                        "OrderNumber": 333333,
                                        "InvoiceNumber": "444444",
                                        "RMAGroupId": 1234
                                    }
                                ]
                            }

    print(RetailAuth_SingleItem)
    r = requests.post(url=API_ENDPOINT, json=RetailAuth_SingleItem, headers=headers)

    RRetailAuth_SingleItem = json.loads(r.text)
    
    return RRetailAuth_SingleItem
