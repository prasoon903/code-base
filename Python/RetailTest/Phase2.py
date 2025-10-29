# Dependency on CreateAccountVirtual_main.py must run 1 time
class Phase2:

    def RetailAuth(self, TestNumber, TotalCount, ThreadCount):

        import os
        from RetailRun import RetailRun

        # TestNumber = TestNumber
        TotalCount = TotalCount
        # Path = "TestNumber_" + str(TestNumber) + "/" + "Account/"
        AllActivityFilePath = "TestNumber_" + str(TestNumber) + "/" + "Activity/"
        AllActivityFileName = "AllActivity.txt"
        Message = ""

        '''
        Message = "\n" + "************** Phase 2 Started *************"
        with open(os.path.join(AllActivityFilePath, AllActivityFileName), 'a+') as ActivityFile:
            ActivityFile.write(Message)
            ActivityFile.write("\n")
        ActivityFile.close()
        Message = ""
        '''

        for LoopCount in range(TotalCount):

            r1 = RetailRun(TestNumber,
                            LoopCount,
                            ThreadCount,
                            200, #LoanAmountTax  = 100,
                            "13776", #PlanID = 13776,
                            1200, # Retail1Amount = 200,
                            0, # Retail1EqualPayment
                            0, #Retail1Term
                            1080, #Retail2Amount =600,
                            0, # Retail2EqualPayment
                            0,# Retail2Term = 6,
                            "9200" #MTI= 0200
                           )
            RRetailManualAuth = r1.RetailRun()

            Message = Message + "\n" + str(RRetailManualAuth)

            # print("Retail Auth done for this account")

        with open(os.path.join(AllActivityFilePath, AllActivityFileName), 'a+') as ActivityFile:
            ActivityFile.write(Message)
            ActivityFile.write("\n")
        ActivityFile.close()

        # print("*************** END OF PHASE 2 ***************")

    def RetailAuthorization(self, MultiThreading, TestNumber, TotalCount):
        import threading
        import os
        # from RetailTest import RetailTestVariable

        # R1 = RetailTestVariable()

        TestNumber = TestNumber
        TotalCount = TotalCount
        ThreadCount = 8
        PerThreadCount = int(TotalCount/ThreadCount)

        AllActivityFilePath = "TestNumber_" + str(TestNumber) + "/" + "Activity/"
        AllActivityFileName = "AllActivity.txt"

        Message = "\n" + "************** Phase 2 Started *************"
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

            t1 = threading.Thread(target=self.RetailAuth, args=(TestNumber, TotalCount_Thread1, 1,))
            t2 = threading.Thread(target=self.RetailAuth, args=(TestNumber, TotalCount_Thread2, 2,))
            t3 = threading.Thread(target=self.RetailAuth, args=(TestNumber, TotalCount_Thread3, 3,))
            t4 = threading.Thread(target=self.RetailAuth, args=(TestNumber, TotalCount_Thread4, 4,))
            t5 = threading.Thread(target=self.RetailAuth, args=(TestNumber, TotalCount_Thread5, 5,))
            t6 = threading.Thread(target=self.RetailAuth, args=(TestNumber, TotalCount_Thread6, 6,))
            t7 = threading.Thread(target=self.RetailAuth, args=(TestNumber, TotalCount_Thread7, 7,))
            t8 = threading.Thread(target=self.RetailAuth, args=(TestNumber, TotalCount_Thread8, 8,))

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
            self.RetailAuth(TestNumber, TotalCount, 0)

        Message = Message + "\n" + "*************** END OF PHASE 2 ***************"
        with open(os.path.join(AllActivityFilePath, AllActivityFileName), 'a+') as ActivityFile:
            ActivityFile.write(Message)
            ActivityFile.write("\n")
        ActivityFile.close()

        print("*************** END OF PHASE 2 ***************")



