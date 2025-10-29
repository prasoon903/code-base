class CreateAccountAndVirtualCard:
    def __init__(self, TestNumber, LoopCount, ThreadCount):
        self.TestNumber = TestNumber
        self.LoopCount = LoopCount
        self.ThreadCount = ThreadCount

        self.Directory = "TestNumber_" + str(self.TestNumber) + "/"

    def CreateAccountAndVirtualCard (self):
        import os
        import json
        from AccountCreation import AccountCreation

        A1 = AccountCreation(7131)
        RAccountCreation = A1.AccountCreation()
        AccountNumber = RAccountCreation["AccountNumber"]
        # print(RAccountCreation)
        print(AccountNumber)

        Path = self.Directory + 'Account/'
        FileName = 'TestAccount_' + str(self.TestNumber) + '_' + str(self.LoopCount) + '_' + str(self.ThreadCount) \
                   + '.json'
        with open(os.path.join(Path, FileName), 'w') as f:
            json.dump(RAccountCreation, f)

        # with open(self.Directory + 'Account/TestAccount_' + str(self.TestNumber) + '_' +
        # str(self.LoopCount) + '.json', 'w') as f:  # writing JSON object
        #  json.dump(RAccountCreation, f)

        from VirtualCard import VirtualCard
        V1 = VirtualCard(AccountNumber)
        RVirtualCard = V1.VirtualCard()
        # print(RVirtualCard)
        # ErrorFound = RVirtualCard["ErrorFound"]
        # print(ErrorFound)
        Path = self.Directory + 'VirtualCard/'
        FileName = 'TestVirtualCard_' + str(self.TestNumber) + '_' + str(self.LoopCount) + '_' + str(self.ThreadCount)\
                   + '.json'
        with open(os.path.join(Path, FileName), 'w') as f:
            json.dump(RAccountCreation, f)

        # with open(self.Directory + 'Account/TestAccount_' + str(self.TestNumber) + '_' + str(self.LoopCount)
        # + '.json', 'w') as f:  # writing JSON object
        #  json.dump(RVirtualCard, f)

        return RAccountCreation
