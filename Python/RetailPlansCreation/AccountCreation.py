import json
import requests
import uuid

def AccountCreation(ProductID, Store):
    from APIHandlers import APIHandlers
    A1 = APIHandlers()
    headers = A1.headers
    API_ENDPOINT = A1.AccountCreation

    AccountCreation = {
        "Password": "Test123!",
        "UserID": "PlatCall",
        "RecordNumber": "1",
        "ProductID": ProductID,
        "MerchantID": "",
        "StoreName": Store,
        "CreditLimit": "20000",
        "CurrencyCode": "840",
        "AccountType": "01",
        "Title": "",
        "FirstName": "Prasoon",
        "MiddleName": "",
        "LastName": "Parashar",
        "SNSuffix": "",
        "AddressLine1": "New York",
        "AddressLine2": "",
        "State": "NY",
        "City": "New York",
        "PostalCode": "43635",
        "Country": "US",
        "EmailID": "",
        "LanguageIndicator": "",
        "HomePhoneNumber": "4568963153",
        "WorkPhoneNumber": "",
        "MobilePhoneNumber": "",
        "DateOfBirth": "01011990",
        "EmployerName": "Corecard",
        "EmployeeNumber": "",
        "MotherMaidenName": "",
        "SocialSecurityNumber": "",
        "GovernmentIDType": "",
        "GovernmentID": "",
        "IDIssueDate": "",
        "IDExpirationDate": "",
        "IDIssueCountry": "",
        "IDIssueState": "",
        "BillingTable": "",
        "CardsRequested": "",
        "MobileCarrier": "",
        "EmbossingLine4": "",
        "BillingCycle": "31",
        "NameonCard": "",
        "TotalAnnualIncome": "20000",
        "CurrentEmploymentMonths": "40",
        "ResidenceType": "",
        "MonthsAtResidence": "",
        "EmploymentType": "",
        "Position": "",
        "EmployerContactPhoneNumber": "",
        "ApplicationVersion": "",
        "APIVersion": "2.0",
        "CalledID": "",
        "CallerID": "",
        "IPAddress": "",
        "SessionID": "",
        "Source": "PLAT",
        "AccountCreationDateTime": "",
        "PartnerId": str(uuid.uuid4()),
        "ClientId": str(uuid.uuid4())
    }

    r = requests.post(url=API_ENDPOINT, json=AccountCreation, headers=headers)

    RAccountCreation = json.loads(r.text)
    return RAccountCreation
