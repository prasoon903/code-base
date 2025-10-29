import time
import subprocess
from SetUp import SetUp
from ConnectDB import ConnectDB
from Phase1 import Phase1
from Phase2 import Phase2
from Phase3 import Phase3Process
from Phase4 import Phase4Process

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


def SetTView(Type, Number):
    Connect = Connection()
    CI_DB = S1.CI_DB
    TDate = ""
    Query = "SELECT TOP 1 CONVERT(VARCHAR(50), DATEADD(" + Type + ", " + Number + ", tnpdate), 101) AS TDate " \
            "FROM " + CI_DB + "..CommonTNP WITH (NOLOCK) WHERE ATID = 60"

    Result = Connect.execute(Query)
    Row = Result.fetchall()

    for r in Row:
        TDate = str(r.TDate)

    Connect.close()

    CMD = 'D:\BankCard\Platform\dt.exe -s "VirtualTime" "' + TDate + '"'

    # print(CMD)

    subprocess.run(CMD)

    return TDate

#########################################################################################


def CheckSystemAging(NewDate):
    Connect = Connection()
    CI_DB = S1.CI_DB
    TDate = ""

    while True:
        Query = "SELECT TOP 1 CONVERT(VARCHAR(50), tnpdate, 101) AS TDate FROM " + CI_DB + "..CommonTNP WITH (NOLOCK) " \
                                                                                           "WHERE ATID = 60"

        Result = Connect.execute(Query)
        Row = Result.fetchall()

        for r in Row:
            TDate = str(r.TDate)

        if TDate == NewDate:
            print("System Aged to " + NewDate)
            break
        else:
            print("Current Time: " + TDate)
            print("Waiting for the system to age...")
            time.sleep(30)

#########################################################################################


class RetailTestVariable:
    # S1 = SetUp()
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
    P1 = Phase1()
    P1.GenerateAccount(MultiThreading, TestNumber, TotalCount)

    CheckTNPJobs(20)

    print("Retail Auth starts...")
    P2 = Phase2()
    P2.RetailAuthorization(MultiThreading, TestNumber, TotalCount)

    if MultiThreading == 0:

        CheckTNPJobs(20)

        NewDate = SetTView("MONTH", "1")

        CheckSystemAging(NewDate)

        Phase3Process(TestNumber, TotalCount)

        CheckTNPJobs(20)

        NewDate = SetTView("DAY", "3")

        CheckSystemAging(NewDate)

        Phase4Process(TestNumber, TotalCount)

    print("ALL JOB DONE !!!")
