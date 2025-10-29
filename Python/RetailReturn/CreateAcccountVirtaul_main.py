class TestRetailCase1:
    from CreateAccountandVirtualCard import CreateAccountAndVirtualCard

    TestNumber = 2
    NumberOfAccountToCreate = 1
    TotalCount = NumberOfAccountToCreate
    for LoopCount in range(TotalCount):
        CA = CreateAccountAndVirtualCard(TestNumber, LoopCount)
        RAccountCreation = CA.CreateAccountAndVirtualCard()
        AccountNumber = RAccountCreation["AccountNumber"]
        from APICardHolderDetail import APICardHolderDetail
        T1 = APICardHolderDetail(AccountNumber)
        RAPICardHolderDetail = T1.APICardHolderDetail()
        ErrorFound = RAPICardHolderDetail["ErrorFound"]
        AvailableBalance = RAPICardHolderDetail["AvailableBalance"]
        CurrentBalance = RAPICardHolderDetail["CurrentBalance"]
        AmountOfTotalDue = RAPICardHolderDetail["AmountOfTotalDue"]
        CycleDue = RAPICardHolderDetail["CycleDue"]
        LastPaymentAmount = RAPICardHolderDetail["LastPaymentAmount"]
        LastStatementDate = RAPICardHolderDetail["LastStatementDate"]
        GeneratedStatus = RAPICardHolderDetail["GeneratedStatus"]
        AccountID = RAPICardHolderDetail["AccountID"]
        # print(AccountNumber)
        print(ErrorFound)
        print(AvailableBalance)
        print(CurrentBalance)
        import json

        with open('RAPICardHolderDetail_beforeLoan_step1.json', 'w') as f:  # writing JSON object
            json.dump(RAPICardHolderDetail, f)


