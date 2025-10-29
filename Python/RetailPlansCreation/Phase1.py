import threading
import os
from CreateAccountandVirtualCard import CreateAccountAndVirtualCard
from ConnectDB import ConnectDB


SourceAccountList = [] 
DestinationAccountList = []

def AccountCreation(TestNumber, TotalCount, ThreadCount, ProductID, Store, MessageLogger, AccountType):
    TotalCount = TotalCount
    ThreadCount = ThreadCount
    AllActivityFilePath = "TestNumber_" + str(TestNumber) + "/" + "Activity/"
    AllActivityFileName = "AllActivity.txt"
    Message = ""

    MessageLogger.info("Calling for function AccountCreation :: THREAD Number Start :: " + str(ThreadCount))

    for LoopCount in range(TotalCount):

        # Message = Message + "\n" + "************ Account Generation Starts ************"
        MessagePassed = ""

        try:
            RAccountCreation, MessagePassed = CreateAccountAndVirtualCard(TestNumber, LoopCount, ThreadCount, ProductID, Store)
            AccountNumber = RAccountCreation["AccountNumber"]

            if AccountType == 1:
                SourceAccountList.append(AccountNumber)
            elif AccountType == 2:
                DestinationAccountList.append(AccountNumber)

            Message = Message + "\n" + str(AccountNumber)

            MessageLogger.info("Account generated :: " + str(AccountNumber) + ":: Message :: " + MessagePassed)
        except Exception:
            MessageLogger.error("Error encountered in generating the account :: ", exc_info=True)

    with open(os.path.join(AllActivityFilePath, AllActivityFileName), 'a+') as ActivityFile:
        ActivityFile.write(Message)
        ActivityFile.write("\n")
    ActivityFile.close()

    MessageLogger.info("Calling for function AccountCreation :: THREAD Number Finish :: " + str(ThreadCount))


def GenerateAccount(MultiThreading, TotalThreads, TestNumber, TotalCount, ProductID, MessageLogger, AccountType):

    try:

        TestNumber = TestNumber
        TotalCount = TotalCount
        ThreadCount = TotalThreads
        Store = ''

        PerThreadCount = int(TotalCount/ThreadCount)

        directoryPath = "TestNumber_" + str(TestNumber)
        AllActivityFilePath = "TestNumber_" + str(TestNumber) + "/" + "Activity/"
        AllActivityFileName = "AllActivity.txt"

        C1 = ConnectDB()
        
        CI_DB = C1.CI_DB

        Query = "SELECT TOP 1 LTRIM(RTRIM(MPL.MPLMerchantDesc)) AS MPLMerchantDesc FROM " + CI_DB +"..MerchantPLAccounts MPL WITH (NOLOCK) "\
                "JOIN " + CI_DB +"..Logo_Primary LP WITH (NOLOCK) ON (MPL.parent02AID = LP.parent02AID) "\
                "WHERE LP.acctId = " + ProductID + " AND MPL.MPLMerchantLevel = 1"

        # print(Query)

        Connection = C1.ConnectDB()

        try:
            Result = Connection.execute(Query)
            Row = Result.fetchall()
            RowCount = len(Row)
        except Exception:
            RowCount = 0
            MessageLogger.error("Error while executing the below query, inside the exception block ", exc_info=True)
            MessageLogger.debug("Query:: ", + Query)

        if RowCount > 0:
            for r in Row:
                Store = str(r.MPLMerchantDesc)

        # print(Store)
        Connection.close()

        
        Message = "************** Phase 1 Started *************"
        Message = Message + "\n" + "************ Account Generation Starts ************"

        MessageLogger.info("************** Phase 1 Started *************")
        MessageLogger.info("************ Account Generation Starts ************")

        if not os.path.exists(directoryPath):
            # print("Path doesn't exist. trying to make main directory")
            MessageLogger.info("Path doesn't exist. trying to make main directory")
            os.makedirs(directoryPath)

        AccountPath = directoryPath + "/Account"
        if not os.path.exists(AccountPath):
            # print("Path doesn't exist. trying to make account folder")
            MessageLogger.info("Path doesn't exist. trying to make account folder")
            os.makedirs(AccountPath)

        VirtualCardPath = directoryPath + "/VirtualCard"
        if not os.path.exists(VirtualCardPath):
            # print("Path doesn't exist. trying to make VirtualCard folder")
            MessageLogger.info("Path doesn't exist. trying to make VirtualCard folder")
            os.makedirs(VirtualCardPath)

        Activity = directoryPath + "/Activity"
        if not os.path.exists(Activity):
            # print("Path doesn't exist. trying to make Activity folder")
            MessageLogger.info("Path doesn't exist. trying to make Activity folder")
            os.makedirs(Activity)

        with open(os.path.join(AllActivityFilePath, AllActivityFileName), 'a+') as ActivityFile:
            ActivityFile.write(Message)
            ActivityFile.write("\n")
        ActivityFile.close()
        Message = ""

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
                threadValue["Thread"+str(threadCount)] = threading.Thread(target=AccountCreation, args=(TestNumber, TotalCountPerThread, threadCount, ProductID, Store, MessageLogger, AccountType,))

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

            t1 = threading.Thread(target=AccountCreation, args=(TestNumber, TotalCount_Thread1, 1, ProductID, Store, MessageLogger, AccountType,))
            t2 = threading.Thread(target=AccountCreation, args=(TestNumber, TotalCount_Thread2, 2, ProductID, Store, MessageLogger, AccountType,))
            t3 = threading.Thread(target=AccountCreation, args=(TestNumber, TotalCount_Thread3, 3, ProductID, Store, MessageLogger, AccountType,))
            t4 = threading.Thread(target=AccountCreation, args=(TestNumber, TotalCount_Thread4, 4, ProductID, Store, MessageLogger, AccountType,))
            t5 = threading.Thread(target=AccountCreation, args=(TestNumber, TotalCount_Thread5, 5, ProductID, Store, MessageLogger, AccountType,))
            t6 = threading.Thread(target=AccountCreation, args=(TestNumber, TotalCount_Thread6, 6, ProductID, Store, MessageLogger, AccountType,))
            t7 = threading.Thread(target=AccountCreation, args=(TestNumber, TotalCount_Thread7, 7, ProductID, Store, MessageLogger, AccountType,))
            t8 = threading.Thread(target=AccountCreation, args=(TestNumber, TotalCount_Thread8, 8, ProductID, Store, MessageLogger, AccountType,))

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
            AccountCreation(TestNumber, TotalCount, 0, ProductID, Store, MessageLogger)

        Message = Message + "\n" + "************ End of Phase 1 ************"
        with open(os.path.join(AllActivityFilePath, AllActivityFileName), 'a+') as ActivityFile:
            ActivityFile.write(Message)
            ActivityFile.write("\n")
        ActivityFile.close()

        MessageLogger.info("************ End of Phase 1 ************")

    except Exception:
        MessageLogger.error("Error found in GenerateAccount function, inside the exception block ", exc_info=True)

    return SourceAccountList, DestinationAccountList

