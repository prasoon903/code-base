# This is for checking for OverPayment

import json
from Clearing import Clearing

TestNumber = 1
LoopCount = 1

with open('TestAccount_' + str(TestNumber) + '_' + str(LoopCount) + '.json') as json_file:
    ROverPayment = json.load(json_file)

AccountNumber = ROverPayment["AccountNumber"]
print(AccountNumber)

TranType = "2104"
ReversalTranID = ""
Amount = "120"

R1 = Clearing(AccountNumber,
              TranType,
              ReversalTranID,
              Amount)

OverPayment = R1.clearing()
print(OverPayment)