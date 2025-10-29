# Dependency on CreatAccountVirtual_main.py must run 1 time
import json
from RetailRun import RetailRun
from ManualAuth import ManualAuth
TestNumber = 1
TotalCount = 14
for LoopCount in range(TotalCount):
    r1 = RetailRun(TestNumber,
                    LoopCount,
                    200,  # LoanAmountTax  = 100,
                    13776,  # PlanID = 13776,
                    1200,  # Retail1Amount = 200,
                    41.99,  # Retail1EqualPayment
                    0,  # Retail1Term
                    1000,  # Retail2Amount =600,
                    0,  # Retail2EqualPayment
                    9,  # Retail2Term = 6,
                    9000,  # MTI= 0100
                    0
                   )
    RRetailManualAuth = r1.RetailRun()
    print(RRetailManualAuth)

    with open('TestAccount_' + str(TestNumber) + '_' + str(LoopCount) + '.json') as json_file:
        RAccountCreation = json.load(json_file)

    AccountNumber = RAccountCreation["AccountNumber"]
    print(AccountNumber)
    # do Manual Auth

    m1 = ManualAuth(TestNumber,
                    LoopCount,
                    AccountNumber,
                    1000,
                    '0100'
                   )
    RManualAuth = m1.ManualAuth()
    print(RManualAuth)


    TransactionID  = RManualAuth["TranID"]
    print(TransactionID)
    # do Retail Complition of manual auth

    r1 = RetailRun(TestNumber,
                   LoopCount,
                    200, #LoanAmountTax  = 100,
                    13776, #PlanID = 13776,
                    1200, # Retail1Amount = 200,
                    41.99, # Retail1EqualPayment
                    0, #Retail1Term
                    1000, #Retail2Amount =600,
                    0, # Retail2EqualPayment
                    9,# Retail2Term = 6,
                    9200, #MTI= 0200
                    TransactionID
                   )
    RRetailManualAuth = r1.RetailRun()
    print(RRetailManualAuth)

