class Phase1:

    def AccountCreation(self, TestNumber, TotalCount, ThreadCount):
        import os
        from CreateAccountandVirtualCard import CreateAccountAndVirtualCard
        # TestNumber = TestNumber
        TotalCount = TotalCount
        ThreadCount = ThreadCount
        # directoryPath = "TestNumber_" + str(TestNumber)
        AllActivityFilePath = "TestNumber_" + str(TestNumber) + "/" + "Activity/"
        AllActivityFileName = "AllActivity.txt"
        Message = ""
        '''
        Message = "************** Phase 1 Started *************"
        Message = Message + "\n" + "************ Account Generation Starts ************"
        
        if not os.path.exists(directoryPath):
            print("Path doesn't exist. trying to make main directory")
            os.makedirs(directoryPath)

        AccountPath = directoryPath + "/Account"
        if not os.path.exists(AccountPath):
            print("Path doesn't exist. trying to make account folder")
            os.makedirs(AccountPath)

        VirtualCardPath = directoryPath + "/VirtualCard"
        if not os.path.exists(VirtualCardPath):
            print("Path doesn't exist. trying to make VirtualCard folder")
            os.makedirs(VirtualCardPath)

        Activity = directoryPath + "/Activity"
        if not os.path.exists(Activity):
            print("Path doesn't exist. trying to make Activity folder")
            os.makedirs(Activity)        

        with open(os.path.join(AllActivityFilePath, AllActivityFileName), 'a+') as ActivityFile:
            ActivityFile.write(Message)
            ActivityFile.write("\n")
        ActivityFile.close()
        Message = ""
        
        '''

        for LoopCount in range(TotalCount):

            # Message = Message + "\n" + "************ Account Generation Starts ************"

            CA = CreateAccountAndVirtualCard(TestNumber, LoopCount, ThreadCount)
            RAccountCreation = CA.CreateAccountAndVirtualCard()
            AccountNumber = RAccountCreation["AccountNumber"]

            Message = Message + "\n" + str(AccountNumber)

        with open(os.path.join(AllActivityFilePath, AllActivityFileName), 'a+') as ActivityFile:
            ActivityFile.write(Message)
            ActivityFile.write("\n")
        ActivityFile.close()

    def GenerateAccount(self, MultiThreading, TestNumber, TotalCount):
        import threading
        import os
        # from RetailTest import RetailTestVariable

        # R1 = RetailTestVariable()

        TestNumber = TestNumber
        TotalCount = TotalCount
        ThreadCount = 8

        PerThreadCount = int(TotalCount/ThreadCount)

        directoryPath = "TestNumber_" + str(TestNumber)
        AllActivityFilePath = "TestNumber_" + str(TestNumber) + "/" + "Activity/"
        AllActivityFileName = "AllActivity.txt"

        Message = "************** Phase 1 Started *************"
        Message = Message + "\n" + "************ Account Generation Starts ************"

        if not os.path.exists(directoryPath):
            print("Path doesn't exist. trying to make main directory")
            os.makedirs(directoryPath)

        AccountPath = directoryPath + "/Account"
        if not os.path.exists(AccountPath):
            print("Path doesn't exist. trying to make account folder")
            os.makedirs(AccountPath)

        VirtualCardPath = directoryPath + "/VirtualCard"
        if not os.path.exists(VirtualCardPath):
            print("Path doesn't exist. trying to make VirtualCard folder")
            os.makedirs(VirtualCardPath)

        Activity = directoryPath + "/Activity"
        if not os.path.exists(Activity):
            print("Path doesn't exist. trying to make Activity folder")
            os.makedirs(Activity)

        with open(os.path.join(AllActivityFilePath, AllActivityFileName), 'a+') as ActivityFile:
            ActivityFile.write(Message)
            ActivityFile.write("\n")
        ActivityFile.close()
        Message = ""

        '''
        while True:
            MultiThreading = int(input("MultiThreading (0 - NO / 1 - YES): "))
            if MultiThreading == 0 or MultiThreading == 1:
                break
            else:
                print("Please select valid option !")
        '''

        MultiThreading = MultiThreading

        if MultiThreading == 1:
            TotalCount_Thread1 = PerThreadCount
            TotalCount_Thread2 = PerThreadCount
            TotalCount_Thread3 = PerThreadCount
            TotalCount_Thread4 = PerThreadCount
            TotalCount_Thread5 = PerThreadCount
            TotalCount_Thread6 = PerThreadCount
            TotalCount_Thread7 = PerThreadCount
            TotalCount_Thread8 = TotalCount - (7*PerThreadCount)

            t1 = threading.Thread(target=self.AccountCreation, args=(TestNumber, TotalCount_Thread1, 1,))
            t2 = threading.Thread(target=self.AccountCreation, args=(TestNumber, TotalCount_Thread2, 2,))
            t3 = threading.Thread(target=self.AccountCreation, args=(TestNumber, TotalCount_Thread3, 3,))
            t4 = threading.Thread(target=self.AccountCreation, args=(TestNumber, TotalCount_Thread4, 4,))
            t5 = threading.Thread(target=self.AccountCreation, args=(TestNumber, TotalCount_Thread5, 5,))
            t6 = threading.Thread(target=self.AccountCreation, args=(TestNumber, TotalCount_Thread6, 6,))
            t7 = threading.Thread(target=self.AccountCreation, args=(TestNumber, TotalCount_Thread7, 7,))
            t8 = threading.Thread(target=self.AccountCreation, args=(TestNumber, TotalCount_Thread8, 8,))

            t1.start()
            t2.start()
            t3.start()
            t4.start()
            t5.start()
            t6.start()
            t7.start()
            t8.start()

            t1.join()
            t2.join()
            t3.join()
            t4.join()
            t5.join()
            t6.join()
            t7.join()
            t8.join()

        else:
            self.AccountCreation(TestNumber, TotalCount, 0)

        Message = Message + "\n" + "************ End of Phase 1 ************"
        with open(os.path.join(AllActivityFilePath, AllActivityFileName), 'a+') as ActivityFile:
            ActivityFile.write(Message)
            ActivityFile.write("\n")
        ActivityFile.close()

