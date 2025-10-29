import time
from SetUp import SetUp as S1
from ConnectDB import ConnectDB

def CheckTNPJobs(Time):
    Connect = ConnectDB()
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