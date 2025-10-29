import os
from RetailRun import RetailRun
import threading
import json
from RetailAuth_SingleItem import RetailAuth_SingleItem
import uuid

def RetailAuth(TestNumber, TotalCount, TotalRetailPlans, MessageLogger, ThreadCount):
    # TestNumber = TestNumber
    TotalCount = TotalCount
    # Path = "TestNumber_" + str(TestNumber) + "/" + "Account/"
    AllActivityFilePath = "TestNumber_" + str(TestNumber) + "/" + "Activity/"
    AllActivityFileName = "AllActivity.txt"
    Message = ""

    MessageLogger.info("Calling for function RetailAuth :: THREAD Number Start :: " + str(ThreadCount))

    for LoopCount in range(TotalCount):

        Path = "TestNumber_" + str(TestNumber) + "/" + "Account/"
        FileName = 'TestAccount_' + str(TestNumber) + '_' + str(LoopCount) + '_' + str(ThreadCount) \
                    + '.json'

        with open(os.path.join(Path, FileName)) as json_file:
            RAccountCreation = json.load(json_file)

        AccountNumber = RAccountCreation["AccountNumber"]
        # print(AccountNumber)

        # MessageLogger.info("AccountNumber :: " + str(AccountNumber))

        TotalPlansToGenerate = TotalRetailPlans
        CountForPlans = 0

        for CountForPlans in range(TotalPlansToGenerate):
            Amount = 2
            PlanID = '13776'
            EqualPaymentAmount = 0
            Term = 0
            MTI = '9200'
            PlanUUID = str(uuid.uuid4())
            Message = ""

            try:
                AuthClearing, Message = RetailAuth_SingleItem(AccountNumber
                        , Amount
                        , PlanID
                        , EqualPaymentAmount
                        , Term
                        , MTI
                        , PlanUUID
                        )

                MessageLogger.info("ThreadCount :: " + str(ThreadCount) + " :: AccountNumber :: " + str(AccountNumber) + " :: PlanCount :: " + str(CountForPlans + 1) + " :: Message :: " + Message)
                Message = Message + "\n" + str(MTI)
                Message = Message + "\n" + str(AuthClearing)
            except Exception:
                MessageLogger.error("ThreadCount :: " + str(ThreadCount) + " :: AccountNumber :: " + str(AccountNumber) + " :: PlanCount :: " + str(CountForPlans + 1) + " :: Error encountered :: ", exc_info=True)

    with open(os.path.join(AllActivityFilePath, AllActivityFileName), 'a+') as ActivityFile:
        ActivityFile.write(Message)
        ActivityFile.write("\n")
    ActivityFile.close()

    MessageLogger.info("Calling for function RetailAuth :: THREAD Number Finish :: " + str(ThreadCount))

    # print("*************** END OF PHASE 2 ***************")

def RetailAuthorization(MultiThreading, TotalThreads, TestNumber, TotalCount, TotalRetailPlans, MessageLogger):
    try:
        TestNumber = TestNumber
        TotalCount = TotalCount
        ThreadCount = TotalThreads
        PerThreadCount = int(TotalCount/ThreadCount)

        AllActivityFilePath = "TestNumber_" + str(TestNumber) + "/" + "Activity/"
        AllActivityFileName = "AllActivity.txt"

        Message = "\n" + "************** Phase 2 Started *************"
        with open(os.path.join(AllActivityFilePath, AllActivityFileName), 'a+') as ActivityFile:
            ActivityFile.write(Message)
            ActivityFile.write("\n")
        ActivityFile.close()
        Message = ""

        MessageLogger.info("************** Phase 2 Started *************")

        MultiThreading = MultiThreading

        if MultiThreading == 1:

            threads = {}
            for threadNumber in range(TotalThreads):
                if threadNumber+1 == TotalThreads:
                    threads[threadNumber+1] = TotalCount - ((TotalThreads-1)*PerThreadCount)
                else:
                    threads[threadNumber+1] = PerThreadCount

            threadValue = {}
            for threadCount, TotalCountPerThread in threads.items():
                threadValue["Thread"+str(threadCount)] = threading.Thread(target=RetailAuth, args=(TestNumber, TotalCountPerThread, TotalRetailPlans, MessageLogger, threadCount,))

            for items in threadValue.values():
                items.start()
            
            for items in threadValue.values():
                items.join()

            '''

            TotalCount_Thread1 = PerThreadCount
            TotalCount_Thread2 = PerThreadCount
            TotalCount_Thread3 = PerThreadCount
            TotalCount_Thread4 = PerThreadCount
            TotalCount_Thread5 = PerThreadCount
            TotalCount_Thread6 = PerThreadCount
            TotalCount_Thread7 = PerThreadCount
            TotalCount_Thread8 = TotalCount - (7*PerThreadCount)

            t1 = threading.Thread(target=RetailAuth, args=(TestNumber, TotalCount_Thread1, TotalRetailPlans, MessageLogger, 1,))
            t2 = threading.Thread(target=RetailAuth, args=(TestNumber, TotalCount_Thread2, TotalRetailPlans, MessageLogger, 2,))
            t3 = threading.Thread(target=RetailAuth, args=(TestNumber, TotalCount_Thread3, TotalRetailPlans, MessageLogger, 3,))
            t4 = threading.Thread(target=RetailAuth, args=(TestNumber, TotalCount_Thread4, TotalRetailPlans, MessageLogger, 4,))
            t5 = threading.Thread(target=RetailAuth, args=(TestNumber, TotalCount_Thread5, TotalRetailPlans, MessageLogger, 5,))
            t6 = threading.Thread(target=RetailAuth, args=(TestNumber, TotalCount_Thread6, TotalRetailPlans, MessageLogger, 6,))
            t7 = threading.Thread(target=RetailAuth, args=(TestNumber, TotalCount_Thread7, TotalRetailPlans, MessageLogger, 7,))
            t8 = threading.Thread(target=RetailAuth, args=(TestNumber, TotalCount_Thread8, TotalRetailPlans, MessageLogger, 8,))

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

            '''

        else:
            RetailAuth(TestNumber, TotalCount, TotalRetailPlans, MessageLogger, 0)

        Message = Message + "\n" + "*************** END OF PHASE 2 ***************"
        with open(os.path.join(AllActivityFilePath, AllActivityFileName), 'a+') as ActivityFile:
            ActivityFile.write(Message)
            ActivityFile.write("\n")
        ActivityFile.close()

        print("*************** END OF PHASE 2 ***************")

        MessageLogger.info("*************** END OF PHASE 2 ***************")

    except Exception:
        MessageLogger.error("Error in the function RetailAuthorization ", exc_info=True)



