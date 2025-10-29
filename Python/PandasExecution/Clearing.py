import json
import requests


def Clearing(AccountNumber,
                TranType,
                ReversalTranID,
                Amount,
                RMATranUUID,
                CreditPlanMaster,
                DateTimeLocalTransaction):
    

    # API_NAME = "PostSingleTransaction"
    from APIHandlers import APIHandlers
    A1 = APIHandlers()
    headers = A1.headers

    API_ENDPOINT = A1.PostSingleTransaction

    # data to be sent to api
    clearing = {
        "Password": "Test123!",
        "UserID": "platcall",
        "AccountNumber": AccountNumber,
        "AdminNumber": "",
        "APIVersion": "2.0",
        "ApplicationVersion": "",
        "ApprovalCode": "",
        "CalledID": "",
        "CallerID": "",
        "CardAcceptorBusinessCode": "",
        "CardAcceptorIdCode": "",
        "CardAcceptorNameLocation": "",
        "CardAcceptorTerminalID": "",
        "CreditPlanMaster": CreditPlanMaster,
        "DateTimeLocalTransaction": DateTimeLocalTransaction,
        "InventoryCode": "",
        "IPAddress": "",
        "LineItemSequenceNumber": "",
        "MerchantType": "",
        "MessageTypeIdentifier": "",
        "PaymentType": "",
        "PrimaryAccountNumber": "",
        "Quantity": "",
        "RequestTime": "",
        "RetrievalReferenceNumber": "",
        "ReversalTargetTranID": ReversalTranID,
        "SessionID": "",
        "Source": "plat",
        "SpecialMerchantIdentifier": "",
        "SystemTraceAuditNumber": "",
        "TMInvoiceNumber": "",
        "TNPFlag": "",
        "TranType": TranType,
        "TransactionAmount": Amount,
        "TransactionCurrencyCode": "",
        "TransactionDescription": "",
        "TransmissionDateTime": "",
        "TransactionTime": "",
        "TransactionPostTime": "",
        "UnitPrice": "",
        "OriginalLoanTerm": 0,
        "EqualPaymentAmount": 0,
        "RMATranUUID": RMATranUUID
    }

    # sending post request and saving response as response object
    # print(clearing)
    r = requests.post(url=API_ENDPOINT, json=clearing, headers=headers)

    ClearingResponse = json.loads(r.text)
    return ClearingResponse
