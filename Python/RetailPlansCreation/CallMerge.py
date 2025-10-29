import os
from RetailRun import RetailRun
import threading
import json
from MergeAPI import MergeAccounts
import uuid
import pandas as pd

MergeFilePath = ""
MergeFileName = ""
MergeAccountDF = ""
    

def MergeRequest(TestNumber, From, To, MergeAccountDF, MessageLogger, ThreadCount):
    # TestNumber = TestNumber
    TotalCount = To
    # Path = "TestNumber_" + str(TestNumber) + "/" + "Account/"
    AllActivityFilePath = "TestNumber_" + str(TestNumber) + "/" + "Activity/"
    AllActivityFileName = "AllActivity.txt"
    Message = ""

    MessageLogger.info("Calling for function MergeAccounts :: THREAD Number Start :: " + str(ThreadCount))

    for LoopCount in range(From, To):
        AccountDetails = MergeAccountDF.loc[LoopCount:LoopCount]
        SourceAccountList=list(AccountDetails["Source"])
        SourceAccount=SourceAccountList[0]
        DestinationAccountList=list(AccountDetails["Destination"])
        DestinationAccount=DestinationAccountList[0]
        NewCreditLimit = "90000"
        try:
            MergeResponse, Message = MergeAccounts(SourceAccount,
                                                    DestinationAccount,
                                                    NewCreditLimit
                    )

            MessageLogger.info("SourceAccount :: " + str(SourceAccount) + " :: DestinationAccount :: " + str(DestinationAccount) + " :: Message :: " + Message)
            Message = Message + "\n" + str(MergeResponse)
        except Exception:
            MessageLogger.error("SourceAccount :: " + str(SourceAccount) + " :: DestinationAccount :: " + str(DestinationAccount) + " :: Error encountered :: ", exc_info=True)

    with open(os.path.join(AllActivityFilePath, AllActivityFileName), 'a+') as ActivityFile:
        ActivityFile.write(Message)
        ActivityFile.write("\n")
    ActivityFile.close()

    MessageLogger.info("Calling for function MergeAccounts :: THREAD Number Finish :: " + str(ThreadCount))

    # print("*************** END OF PHASE 2 ***************")

def ProcessMergeRequest(MultiThreading, TestNumber, MessageLogger):
    try:
        AllActivityFilePath = "TestNumber_" + str(TestNumber) + "/" + "Activity/"
        AllActivityFileName = "AllActivity.txt"

        MergeFilePath = "TestNumber_" + str(TestNumber) + "/"
        MergeFileName = "MergeAccounts.csv"

        MergeAccountDF = pd.read_csv(MergeFilePath+MergeFileName)

        TestNumber = TestNumber
        TotalCount = MergeAccountDF.shape[0]
        ThreadCount = 8
        PerThreadCount = int(TotalCount/ThreadCount)

        Message = "\n" + "************** Phase 2 Started *************"
        with open(os.path.join(AllActivityFilePath, AllActivityFileName), 'a+') as ActivityFile:
            ActivityFile.write(Message)
            ActivityFile.write("\n")
        ActivityFile.close()
        Message = ""

        MessageLogger.info("************** Phase 2 Started *************")

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

            t1 = threading.Thread(target=MergeRequest, args=(TestNumber, 0, TotalCount_Thread1, MergeAccountDF, MessageLogger, 1,))
            t2 = threading.Thread(target=MergeRequest, args=(TestNumber, TotalCount_Thread1, TotalCount_Thread2, MergeAccountDF, MessageLogger, 2,))
            t3 = threading.Thread(target=MergeRequest, args=(TestNumber, TotalCount_Thread2, TotalCount_Thread3, MergeAccountDF, MessageLogger, 3,))
            t4 = threading.Thread(target=MergeRequest, args=(TestNumber, TotalCount_Thread3, TotalCount_Thread4, MergeAccountDF, MessageLogger, 4,))
            t5 = threading.Thread(target=MergeRequest, args=(TestNumber, TotalCount_Thread4, TotalCount_Thread5, MergeAccountDF, MessageLogger, 5,))
            t6 = threading.Thread(target=MergeRequest, args=(TestNumber, TotalCount_Thread5, TotalCount_Thread6, MergeAccountDF, MessageLogger, 6,))
            t7 = threading.Thread(target=MergeRequest, args=(TestNumber, TotalCount_Thread6, TotalCount_Thread7, MergeAccountDF, MessageLogger, 7,))
            t8 = threading.Thread(target=MergeRequest, args=(TestNumber, TotalCount_Thread7, TotalCount_Thread8, MergeAccountDF, MessageLogger, 8,))

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
            MergeRequest(TestNumber, 0, TotalCount, MergeAccountDF, MessageLogger, 0)

        Message = Message + "\n" + "*************** END OF PHASE 2 ***************"
        with open(os.path.join(AllActivityFilePath, AllActivityFileName), 'a+') as ActivityFile:
            ActivityFile.write(Message)
            ActivityFile.write("\n")
        ActivityFile.close()

        print("*************** END OF PHASE 2 ***************")

        MessageLogger.info("*************** END OF PHASE 2 ***************")

    except Exception:
        MessageLogger.error("Error in the function RetailAuthorization ", exc_info=True)






