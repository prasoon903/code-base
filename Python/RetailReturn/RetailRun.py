import json
import os
from RetailManualAuth import RetailManualAuth


def RetailRun(TestNumber
                , LoopCount
                , ThreadCount
                , LoanAmountTax
                , PlanID
                , Retail1Amount
                , Retail1EqualPayment
                , Retail1Term
                , Retail2Amount
                , Retail2EqualPayment
                , Retail2Term
                , MTI):

    Path = "TestNumber_" + str(TestNumber) + "/" + "Account/"
    FileName = 'TestAccount_' + str(TestNumber) + '_' + str(LoopCount) + '_' + str(ThreadCount) \
                + '.json'

    with open(os.path.join(Path, FileName)) as json_file:
        RAccountCreation = json.load(json_file)

    AccountNumber = RAccountCreation["AccountNumber"]
    print(AccountNumber)
    
    R1 = RetailManualAuth(AccountNumber,
                            LoanAmountTax,
                            PlanID,
                            Retail1Amount,
                            Retail1EqualPayment,
                            Retail1Term,
                            Retail2Amount,
                            Retail2EqualPayment,
                            Retail2Term,
                            MTI
                            )

    RRetailManualAuth = R1.RetailManualAuth()

    return RRetailManualAuth