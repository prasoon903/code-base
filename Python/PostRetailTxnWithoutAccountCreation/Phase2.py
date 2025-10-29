import os
import threading
import json
from RetailAuth_SingleItem import RetailAuth_SingleItem
from VirtualCard import VirtualCard
import uuid
from SetUp import SetUp

S1 = SetUp()
DirectoryPath = S1.DirectoryPath
# Message = ""

if DirectoryPath != "":
    DirectoryPath = DirectoryPath + "\\"


def RetailAuth(TestNumber, TotalCount, ThreadCount):
    # TestNumber = TestNumber
    TotalCount = TotalCount
    # Path = "TestNumber_" + str(TestNumber) + "/" + "Account/"
    '''
    AllActivityFilePath = DirectoryPath + "TestNumber_" + str(TestNumber) + "/" + "Activity/"
    AllActivityFileName = "AllActivity.txt"
    Message = ""
    '''

    for LoopCount in range(TotalCount):

        Path = DirectoryPath + "TestNumber_" + str(TestNumber) + "/" + "Account/"
        FileName = 'TestAccount_' + str(TestNumber) + '_' + str(LoopCount) + '_' + str(ThreadCount) + '.txt'

        File = open(os.path.join(Path, FileName), 'r')
        AccountNumber = File.read()

        AccountNumber = AccountNumber.strip()

        #AccountNumber = RAccountCreation
        print(LoopCount)
        print(AccountNumber)

        # V1 = VirtualCard(AccountNumber)

        Amount = 5
        PlanID = '13776'
        EqualPaymentAmount = 0
        Term = 0
        MTI = '9200'
        PlanUUID = str(uuid.uuid4())
        print(Amount)
        print(PlanID)
        print(EqualPaymentAmount)
        print(Term)
        print(MTI)
        print(PlanUUID)

        AuthClearing = RetailAuth_SingleItem(AccountNumber
                , Amount
                , PlanID
                , EqualPaymentAmount
                , Term
                , MTI
                , PlanUUID
                )

        # Message = Message + "\n" + str(MTI)
        # Message = Message + "\n" + str(AuthClearing)

        '''
        MTI = '9220'

        AuthReturn = RetailAuth_SingleItem(AccountNumber
                , Amount
                , PlanID
                , EqualPaymentAmount
                , Term
                , MTI
                , PlanUUID
                )

        '''

        # Message = Message + "\n" + str(MTI)
        # Message = Message + "\n" + str(AuthReturn)

    '''
    with open(os.path.join(AllActivityFilePath, AllActivityFileName), 'a+') as ActivityFile:
        ActivityFile.write(Message)
        ActivityFile.write("\n")
    ActivityFile.close()
    '''

    # print("*************** END OF PHASE 2 ***************")

def RetailAuthorization(MultiThreading, TestNumber, TotalCount):
    TestNumber = TestNumber
    TotalCount = TotalCount
    ThreadCount = 8
    PerThreadCount = int(TotalCount/ThreadCount)

    # AllActivityFilePath = "TestNumber_" + str(TestNumber) + "/" + "Activity/"
    # AllActivityFileName = "AllActivity.txt"

    # Message = "\n" + "************** Phase 2 Started *************"
    '''
    with open(os.path.join(AllActivityFilePath, AllActivityFileName), 'a+') as ActivityFile:
        ActivityFile.write(Message)
        ActivityFile.write("\n")
    ActivityFile.close()
    Message = ""
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

        t1 = threading.Thread(target=RetailAuth, args=(TestNumber, TotalCount_Thread1, 1,))
        t2 = threading.Thread(target=RetailAuth, args=(TestNumber, TotalCount_Thread2, 2,))
        t3 = threading.Thread(target=RetailAuth, args=(TestNumber, TotalCount_Thread3, 3,))
        t4 = threading.Thread(target=RetailAuth, args=(TestNumber, TotalCount_Thread4, 4,))
        t5 = threading.Thread(target=RetailAuth, args=(TestNumber, TotalCount_Thread5, 5,))
        t6 = threading.Thread(target=RetailAuth, args=(TestNumber, TotalCount_Thread6, 6,))
        t7 = threading.Thread(target=RetailAuth, args=(TestNumber, TotalCount_Thread7, 7,))
        t8 = threading.Thread(target=RetailAuth, args=(TestNumber, TotalCount_Thread8, 8,))

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
        RetailAuth(TestNumber, TotalCount, 0)

    # Message = Message + "\n" + "*************** END OF PHASE 2 ***************"
    '''
    with open(os.path.join(AllActivityFilePath, AllActivityFileName), 'a+') as ActivityFile:
        ActivityFile.write(Message)
        ActivityFile.write("\n")
    ActivityFile.close()
    '''

    print("*************** END OF PHASE 2 ***************")



