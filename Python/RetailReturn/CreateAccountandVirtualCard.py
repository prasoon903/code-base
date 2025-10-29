import os
import json
from AccountCreation import AccountCreation
from VirtualCard import VirtualCard


def CreateAccountAndVirtualCard (TestNumber, LoopCount, ThreadCount, ProductID, Store):

    Directory = "TestNumber_" + str(TestNumber) + "/"
    RAccountCreation = AccountCreation(ProductID, Store)
    AccountNumber = RAccountCreation["AccountNumber"]
    # print(RAccountCreation)
    print(AccountNumber)

    Path = Directory + 'Account/'
    FileName = 'TestAccount_' + str(TestNumber) + '_' + str(LoopCount) + '_' + str(ThreadCount) \
                + '.json'
    with open(os.path.join(Path, FileName), 'w') as f:
        json.dump(RAccountCreation, f)

    
    V1 = VirtualCard(AccountNumber)
    RVirtualCard = V1.VirtualCard()
    
    Path = Directory + 'VirtualCard/'
    FileName = 'TestVirtualCard_' + str(TestNumber) + '_' + str(LoopCount) + '_' + str(ThreadCount)\
                + '.json'
    with open(os.path.join(Path, FileName), 'w') as f:
        json.dump(RVirtualCard, f)

    return RAccountCreation
