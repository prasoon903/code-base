from APIHandlers import APIHandlers
def VirtualCard(Accountnumber):
    import json
    import requests
    # importing the requests library

    # defining the api-endpoint
    # API_ENDPOINT = "http://xeon-web1/PrasoonP/PrasoonPSecondaryCardCreation.aspx"
    # headers = {'Content-type': 'application/json', 'Accept': 'application/json'}

    # API_NAME = "SecondaryCardCreation"
    
    A1 = APIHandlers()
    headers = A1.headers

    API_ENDPOINT = A1.SecondaryCardCreation

    # data to be sent to api
    VirtualCard = {
        "Password": "Test123!",
        "UserID": "PlatCall",
        "ANI": "",
        "APIVersion": "2.0",
        "AccountNumber": Accountnumber,
        "Address1": "",
        "Address2": "",
        "Address3": "",
        "AdminNumber": "",
        "ApplicationVersion": "",
        "CIPNumber": "",
        "CIPStatus": "",
        "CIPType": "",
        "CalledID": "",
        "CallerID": "",
        "CardNumber": "",
        "City": "",
        "Country": "",
        "CountryCode": "",
        "DNS": "",
        "DateOfBirth": "",
        "DealerNumber": "",
        "EmailPrimary": "",
        "EmailSecondary": "",
        "EmbossingHotStamp": "",
        "EmbossingLine4": "",
        "FirstName": "",
        "HomeFaxNumber": "",
        "HomePhoneCountryCode": "",
        "HomePhoneExtention": "",
        "IDCode": "",
        "IDCountry": "",
        "IDExpirationDate": "",
        "IDIssueDate": "",
        "IDIssueState": "",
        "IDNumber": "",
        "IPAddress": "",
        "LanguageIndicator": "",
        "LastName": "",
        "MiddleName": "",
        "MobilePhoneNumber": "",
        "MotherMaidenName": "",
        "NameOnCard": "",
        "NewAdminNumber": "",
        "NewCardNumber": "",
        "OtherIDDescription": "",
        "PIN": "",
        "PhoneNumber": "",
        "PostalCode": "",
        "Privacy": "",
        "RequestTime": "",
        "SecondLastName": "",
        "SecondaryCardType": "1",
        "SecurityAnswer": "",
        "SecurityQuestion": "",
        "SessionID": "",
        "SocialSecurityNumber": "",
        "Source": "Plat",
        "State": "",
        "Title": "",
        "VirtualCardExpAfterDays": "",
        "VirtualCardExpAfterTxn": "",
        "VirtualCardExpDate": "",
        "VirtualCardExpDuration": "",
        "VirtualCardExpOption": "3",
        "VirtualCardLimit": "15000",
        "VirtualCardResetAllow": "1",
        "VirtualCardStandInLimit": "",
        "WorkFaxNumber": "",
        "WorkPhoneCountryCode": "",
        "WorkPhoneExtention": "",
        "WorkPhoneNumber": "",
        "AdminUUID": ""
    }

    # sending post request and saving response as response object
    r = requests.post(url=API_ENDPOINT, json=VirtualCard, headers=headers)

    RVirtualCard = json.loads(r.text)
    # print(RVirtualCard)
    return RVirtualCard

