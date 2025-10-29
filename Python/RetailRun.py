class RetailRun:

    def __init__(self
                 , TestNumber
                 , LoopCount
                 , LoanAmountTax
                 , PlanID
                 , Retail1Amount
                 , Retail1EqualPayment
                 , Retail1Term
                 , Retail2Amount
                 , Retail2EqualPayment
                 , Retail2Term
                 , MTI
                 , TransactionID
                 ):
        self.TestNumber = TestNumber
        self.LoanAmountTax = LoanAmountTax
        self.PlanID = PlanID
        self.Retail1Amount = Retail1Amount
        self.Retail2Amount = Retail2Amount
        self.Retail1Term = Retail1Term
        self.Retail2Term = Retail2Term
        self.Retail1EqualPayment = Retail1EqualPayment
        self.Retail2EqualPayment = Retail2EqualPayment
        self.MTI = MTI
        self.TransactionID = TransactionID
        self.LoopCount = LoopCount

    def RetailRun(self):
        import json
        import os
        # Retail Variable can be picked from file
        # LoanAmountTax  = 100
        # PlanID = 13776
        # Retail1Amount = 200
        # Retail2Amount =600
        # Retail1Term = 6
        # Retail2EqualPayment = 25
        # MTI= 9220

        Path = "TestNumber_" + str(self.TestNumber) + "/" + "Account/"
        FileName = 'TestAccount_' + str(self.TestNumber) + '_' + str(self.LoopCount) + '.json'

        with open(os.path.join(Path, FileName)) as json_file:
            RAccountCreation = json.load(json_file)

        AccountNumber = RAccountCreation["AccountNumber"]
        from RetailManualAuth import RetailManualAuth
        R1 = RetailManualAuth(AccountNumber,
                     self.LoanAmountTax,
                     self.PlanID,
                     self.Retail1Amount,
                     self.Retail1EqualPayment,
                     self.Retail1Term,
                     self.Retail2Amount,
                     self.Retail2EqualPayment,
                     self.Retail2Term,
                     self.MTI,
                     self.TransactionID,
                     )

        RRetailManualAuth = R1.RetailManualAuth()
        # print(RRetailManualAuth)
        return RRetailManualAuth
