import time
from SetUp import SetUp as S1
from ConnectDB import ConnectDB


def CheckSystemAging(NewDate):
    Connect = ConnectDB()
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