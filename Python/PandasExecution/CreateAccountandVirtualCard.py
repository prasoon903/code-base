import os
import json
from AccountCreation import AccountCreation
from VirtualCard import VirtualCard


def CreateAccountAndVirtualCard(ProductID, Store):

    RAccountCreation = AccountCreation(ProductID, Store)
    AccountNumber = RAccountCreation["AccountNumber"]
    # print(RAccountCreation)
    print(AccountNumber)
    
    V1 = VirtualCard(AccountNumber)
    RVirtualCard = V1.VirtualCard()
    
    return RAccountCreation
