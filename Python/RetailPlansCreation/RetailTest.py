import time
import subprocess
from SetUp import SetUp
from ConnectDB import ConnectDB
from Phase1 import GenerateAccount
from Phase2 import RetailAuthorization
from CallMerge import ProcessMergeRequest
from Logger import get_logger
import datetime
import pandas as pd

S1 = SetUp()

LogDateTime = datetime.datetime.now()

LOG_FILE = S1.LogDir + "\\" + "LOG_" + str(LogDateTime.strftime("%Y%m%d%H%M%S")) + ".log"

MessageLogger = get_logger(LOG_FILE)

def Connection():
    try:
        C1 = ConnectDB()
    except Exception:
        MessageLogger.error("Connection not established, inside the exception block ", exc_info=True)
    return C1.ConnectDB()

#########################################################################################


def CheckTNPJobs(Time):
    # S1 = SetUp()
    Connect = Connection()
    CI_DB = S1.CI_DB
    while True:
        RemainingJobs = -1
        Query = "SELECT COUNT(1) AS RemainingJobs FROM " + CI_DB + "..CommonTNP WITH (NOLOCK) WHERE TranId > 0"
        # Connection = Connection()

        Result = Connect.execute(Query)
        Row = Result.fetchall()
        # RowCount = len(Row)

        for r in Row:
            RemainingJobs = r.RemainingJobs

        if RemainingJobs == 0:
            Connect.close()
            MessageLogger.info("All jobs processed from the TNP")
            break
        else:
            print("RemainingJobs: " + str(RemainingJobs) + "\n" + "Waiting...")
            MessageLogger.info("RemainingJobs: " + str(RemainingJobs) + ", Waiting...")
            time.sleep(Time)

#########################################################################################


def CheckRetailMSMQJobs(Time):
    # S1 = SetUp()
    Connect = Connection()
    CAuth_DB = S1.CAuth_DB
    while True:
        RemainingJobs = -1
        Query = "SELECT COUNT(1) AS RemainingJobs FROM " + CAuth_DB + "..RetailAuthJobs WITH (NOLOCK) WHERE JobStatus IN ('NEW', 'ERROR')"
        # Connection = Connection()

        Result = Connect.execute(Query)
        Row = Result.fetchall()
        # RowCount = len(Row)

        for r in Row:
            RemainingJobs = r.RemainingJobs

        if RemainingJobs == 0:
            Connect.close()
            MessageLogger.info("All jobs processed from the RetailMSMQ")
            break
        else:
            print("RemainingJobs: " + str(RemainingJobs) + "\n" + "Waiting...")
            MessageLogger.info("RemainingJobs: " + str(RemainingJobs) + ", Waiting...")
            time.sleep(Time)

#########################################################################################


if __name__ == "__main__":
    # S1 = SetUp()
    MessageLogger.info("Processing starts... ")

    MultiThreading = 0
    TestNumber = 0
    TotalCountForAccount = 0
    TotalRetailPlans = 0
    MergeProcess = 0
    TotalThreads = 0
    SourceAccountList = []
    DestinationAccountList = []
    AccountType = 0 # 1=Source/2=Destination
    try:
        while True:
            MultiThreading = int(input("MultiThreading (0 - NO / 1 - YES): "))
            if MultiThreading == 0 or MultiThreading == 1:
                MessageLogger.info("Value passed for MultiThreading: " + str(MultiThreading))
                break
            else:
                print("Please select valid option !")
                MessageLogger.info("Invalid value is passed for MultiThreading: " + str(MultiThreading))

        while True:
            TotalThreads = int(input("TotalThreads (1 to 8): "))
            if TotalThreads >= 1 and TotalThreads <= 8:
                MessageLogger.info("Value passed for TotalThreads: " + str(TotalThreads))
                break
            else:
                print("Please select valid option !")
                MessageLogger.info("Invalid value is passed for TotalThreads: " + str(TotalThreads))

        while True:
            TestNumber = int(input("TestNumber: "))
            if TestNumber > 0:
                break
            else:
                print("Please select valid option (greater than 0) !")

        while True:
            TotalCountForAccount = int(input("TotalCountForAccount: "))
            if TotalCountForAccount > 0:
                break
            else:
                print("Please select valid option (greater than 0) !")

        while True:
            TotalRetailPlans = int(input("TotalRetailPlansForEachAccount: "))
            if TotalRetailPlans >= 0:
                break
            else:
                print("Please select valid option (greater than 0) !")

        while True:
            MergeProcess = int(input("MergeProcess (0 - NO / 1 - YES): "))
            if MergeProcess == 0 or MultiThreading == 1:
                MessageLogger.info("Value passed for MergeProcess: " + str(MergeProcess))
                break
            else:
                print("Please select valid option !")
                MessageLogger.info("Invalid value is passed for MergeProcess: " + str(MergeProcess))

        MessageLogger.info("Total number of accounts to make :: " + str(TotalCountForAccount))
        MessageLogger.info("Total number of RetailPlans to make :: " + str(TotalRetailPlans))
        MessageLogger.info("Account creation starts...")
        print("Account creation starts...")
        ProductID = '7131'
        MessageLogger.info("************************* CREATING SOURCE ACCOUNTS ***************************")
        AccountType = 1
        SourceAccountListRet, DestinationAccountListRet = GenerateAccount(MultiThreading, TotalThreads, TestNumber, TotalCountForAccount, ProductID, MessageLogger, AccountType)
        SourceAccountList = SourceAccountListRet

        SurceAccounts = pd.DataFrame({"Source":SourceAccountList})

        AllActivityFilePath = "TestNumber_" + str(TestNumber) + "/"
        AllActivityFileName = "SourceAccounts.csv"
        SurceAccounts.to_csv(AllActivityFilePath+AllActivityFileName, index=False)

        CheckTNPJobs(20)

        MessageLogger.info("Account creation finished...")
        MessageLogger.info("Retail Auth starts...")
        print("Retail Auth starts...")
        RetailAuthorization(MultiThreading, TotalThreads, TestNumber, TotalCountForAccount, TotalRetailPlans, MessageLogger)

        MessageLogger.info("Retail Auth finished...")

        if MergeProcess == 1:
            # DestinationAccounts
            MessageLogger.info("************************* CREATING DESTINATION ACCOUNTS ***************************")
            AccountType = 2
            SourceAccountListRet, DestinationAccountListRet = GenerateAccount(MultiThreading, TotalThreads, TestNumber, TotalCountForAccount, ProductID, MessageLogger, AccountType)
            DestinationAccountList = DestinationAccountListRet

            MergeAccountDF = pd.DataFrame({"Source":SourceAccountList, "Destination":DestinationAccountList})

            AllActivityFilePath = "TestNumber_" + str(TestNumber) + "/"
            AllActivityFileName = "MergeAccounts.csv"
            MergeAccountDF.to_csv(AllActivityFilePath+AllActivityFileName, index=False)

            CheckRetailMSMQJobs(30)

            StartMerge = 1
            '''
            while True:
                StartMerge = int(input("Start processing merge transactions (0-No/1-Yes): "))
                if StartMerge == 1:
                    break
                else:                
                    MessageLogger.info("StartMerge passed as No, waiting for 30 seconds")
                    time.sleep(30)
            '''

            if StartMerge == 1:
                ProcessMergeRequest(MultiThreading, TestNumber, MessageLogger)

        print("ALL JOB DONE !!!")
        MessageLogger.info("ALL JOB DONE !!!")

    except Exception:
        MessageLogger.error("Error while processing records, inside the exception block ", exc_info=True)
