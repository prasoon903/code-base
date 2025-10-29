import threading
import os
from CreateAccountandVirtualCard import CreateAccountAndVirtualCard
from ConnectDB import ConnectDB


def AccountCreation(TestNumber, TotalCount, ThreadCount, ProductID, Store):
    TotalCount = TotalCount
    ThreadCount = ThreadCount
    AllActivityFilePath = "TestNumber_" + str(TestNumber) + "/" + "Activity/"
    AllActivityFileName = "AllActivity.txt"
    Message = ""

    for LoopCount in range(TotalCount):

        # Message = Message + "\n" + "************ Account Generation Starts ************"

        RAccountCreation = CreateAccountAndVirtualCard(TestNumber, LoopCount, ThreadCount, ProductID, Store)
        AccountNumber = RAccountCreation["AccountNumber"]

        Message = Message + "\n" + str(AccountNumber)

    with open(os.path.join(AllActivityFilePath, AllActivityFileName), 'a+') as ActivityFile:
        ActivityFile.write(Message)
        ActivityFile.write("\n")
    ActivityFile.close()

def GenerateAccount(MultiThreading, TestNumber, TotalCount, ProductID):

    TestNumber = TestNumber
    TotalCount = TotalCount
    ThreadCount = 8
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

    print(Query)

    Connection = C1.ConnectDB()

    try:
        Result = Connection.execute(Query)
        Row = Result.fetchall()
        RowCount = len(Row)
    except:
        RowCount = 0

    if RowCount > 0:
        for r in Row:
            Store = str(r.MPLMerchantDesc)

    print(Store)
    Connection.close()

    
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

        t1 = threading.Thread(target=AccountCreation, args=(TestNumber, TotalCount_Thread1, 1, ProductID, Store,))
        t2 = threading.Thread(target=AccountCreation, args=(TestNumber, TotalCount_Thread2, 2, ProductID, Store,))
        t3 = threading.Thread(target=AccountCreation, args=(TestNumber, TotalCount_Thread3, 3, ProductID, Store,))
        t4 = threading.Thread(target=AccountCreation, args=(TestNumber, TotalCount_Thread4, 4, ProductID, Store,))
        t5 = threading.Thread(target=AccountCreation, args=(TestNumber, TotalCount_Thread5, 5, ProductID, Store,))
        t6 = threading.Thread(target=AccountCreation, args=(TestNumber, TotalCount_Thread6, 6, ProductID, Store,))
        t7 = threading.Thread(target=AccountCreation, args=(TestNumber, TotalCount_Thread7, 7, ProductID, Store,))
        t8 = threading.Thread(target=AccountCreation, args=(TestNumber, TotalCount_Thread8, 8, ProductID, Store,))

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
        AccountCreation(TestNumber, TotalCount, 0, ProductID, Store)

    Message = Message + "\n" + "************ End of Phase 1 ************"
    with open(os.path.join(AllActivityFilePath, AllActivityFileName), 'a+') as ActivityFile:
        ActivityFile.write(Message)
        ActivityFile.write("\n")
    ActivityFile.close()

