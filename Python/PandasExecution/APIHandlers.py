class APIHandlers:
    import requests
    import json

    StartPoint = "http://xeon-web1/PrasoonP/PrasoonP"
    EndPoint = ".aspx"
    headers = {'Content-type': 'application/json', 'Accept': 'application/json'}

    # API_NAME = "AccountCreation"
    AccountCreation = StartPoint + "AccountCreation" + EndPoint
    AddManualStatusToAccount = StartPoint + "AddManualStatusToAccount" + EndPoint
    RemoveManualStatus = StartPoint + "RemoveManualStatusAction" + EndPoint
    GetCardHolderDetail = StartPoint + "GetCardHolderDetail" + EndPoint
    ApplyManualChargeOff = StartPoint + "ApplyManualChargeOff" + EndPoint
    PostSingleTransaction = StartPoint + "PostSingleTransaction" + EndPoint
    ReceiveDisputeResolution = StartPoint + "ReceiveDisputeResolution" + EndPoint
    InitiateTransactionDispute = StartPoint + "InitiateTransactionDispute" + EndPoint
    ManualAuth = StartPoint + "ManualAuth" + EndPoint
    RetailManualAuth = StartPoint + "RetailManualAuth" + EndPoint
    SecondaryCardCreation = StartPoint + "SecondaryCardCreation" + EndPoint
    AccountUpdate = StartPoint + "AccountUpdate" + EndPoint
    ReAgeEnrollment = StartPoint + "ReAgeEnrollment" + EndPoint