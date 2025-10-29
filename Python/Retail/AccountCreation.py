class AccountCreation:

    def __init__(self, productid):
        self.productid = productid

    def AccountCreation(self):
        import json
        import requests
        # importing the requests library

        # defining the api-endpoint
        # API_ENDPOINT = "http://xeon-web1/PrasoonP/PrasoonPAccountCreation.aspx"
        # headers = {'Content-type': 'application/json', 'Accept': 'application/json'}

        # API_NAME = "AccountCreation"
        from APIHandlers import APIHandlers
        A1 = APIHandlers()
        headers = A1.headers
        API_ENDPOINT = A1.AccountCreation
        # your API key here
        # API_KEY = ""

        # your source code here
        # source_code = ''

        # data to be sent to api
        AccountCreation = {
            "Password": "Test123!",
            "UserID": "PlatCall",
            "RecordNumber": "1",
            "ProductID": self.productid,
            "MerchantID": "",
            "StoreName": "CookieStore",
            "CreditLimit": "20000",
            "CurrencyCode": "840",
            "AccountType": "01",
            "Title": "",
            "FirstName": "Prasoon",
            "MiddleName": "",
            "LastName": "Parashar",
            "SNSuffix": "",
            "AddressLine1": "Bhopal",
            "AddressLine2": "",
            "State": "AK",
            "City": "Georgia",
            "PostalCode": "43635",
            "Country": "US",
            "EmailID": "",
            "LanguageIndicator": "",
            "HomePhoneNumber": "4568963466",
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
            "BillingTable": "10370",
            "CardsRequested": "",
            "MobileCarrier": "",
            "EmbossingLine4": "",
            "BillingCycle": "31",
            "NameonCard": "",
            "TotalAnnualIncome": "10000",
            "CurrentEmploymentMonths": "80",
            "ResidenceType": "1",
            "MonthsAtResidence": "31",
            "EmploymentType": "20",
            "Position": "",
            "EmployerContactPhoneNumber": "",
            "ApplicationVersion": "",
            "APIVersion": "2.0",
            "CalledID": "",
            "CallerID": "",
            "IPAddress": "",
            "SessionID": "",
            "Source": "plat",
            "AccountCreationDateTime": "",
            "PartnerId": "123456",
            "ClientId": "123456"
        }

        # sending post request and saving response as response object
        r = requests.post(url=API_ENDPOINT, json=AccountCreation, headers=headers)

        RAccountCreation = json.loads(r.text)
        # print(RAccountCreation)
        return RAccountCreation
        # AccountNumber = RAccountCreation["AccountNumber"]
        # PrimaryAccountNumber = RAccountCreation["CardNumber"]
        # print(AccountNumber);
        # print(PrimaryAccountNumber);
