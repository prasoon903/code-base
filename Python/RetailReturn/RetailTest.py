import time
import subprocess
from SetUp import SetUp
from ConnectDB import ConnectDB
from Phase1 import GenerateAccount
from Phase2 import RetailAuthorization

S1 = SetUp()


def Connection():
    C1 = ConnectDB()
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
            break
        else:
            print("RemainingJobs: " + str(RemainingJobs))
            print("Waiting...")
            time.sleep(Time)

#########################################################################################


if __name__ == "__main__":
    # S1 = SetUp()
    MultiThreading = 0
    TestNumber = 0
    TotalCount = 0
    while True:
        MultiThreading = int(input("MultiThreading (0 - NO / 1 - YES): "))
        if MultiThreading == 0 or MultiThreading == 1:
            break
        else:
            print("Please select valid option !")

    while True:
        TestNumber = int(input("TestNumber: "))
        if TestNumber > 0:
            break
        else:
            print("Please select valid option (greater than 0) !")

    while True:
        TotalCount = int(input("TotalCount: "))
        if TotalCount > 0:
            break
        else:
            print("Please select valid option (greater than 0) !")

    print("Account creation starts...")
    ProductID = '7131'
    GenerateAccount(MultiThreading, TestNumber, TotalCount, ProductID)

    CheckTNPJobs(20)

    print("Retail Auth starts...")
    RetailAuthorization(MultiThreading, TestNumber, TotalCount)

    print("ALL JOB DONE !!!")
