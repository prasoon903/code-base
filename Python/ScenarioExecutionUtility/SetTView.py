import subprocess
from SetUp import SetUp as S1
from ConnectDB import ConnectDB
import datetime


def SetTView(Type, Number, InstitutionID):
    Connect = ConnectDB()
    CI_DB = S1.CI_DB
    TDate = ""
    Query = "SELECT TOP 1 CONVERT(VARCHAR(50), DATEADD(" + Type + ", " + Number + ", tnpdate), 101) AS TDate " \
            "FROM " + CI_DB + "..CommonTNP WITH (NOLOCK) WHERE ATID = 60 AND InstitutionID = " + str(InstitutionID)

    Result = Connect.execute(Query)
    Row = Result.fetchall()

    for r in Row:
        TDate = str(r.TDate)

    Connect.close()

    CMD = 'D:\BankCard\Platform\dt.exe -s "VirtualTime" "' + TDate + '"'

    # print(CMD)

    subprocess.run(CMD)

    return TDate


###################################################################################################

def SetTViewByPostTime(PostTime, InstitutionID):
    Error = False
    Query = "SELECT CAST(CONVERT(VARCHAR, tnpdate, 23) AS DATE) AS CurrentDate " \
            "FROM CommonTNP WITH (NOLOCK) " \
            "WHERE ATID = 60 AND InstitutionID = " + InstitutionID

    Connect = ConnectDB()

    try:
        Result = Connect.execute(Query)
        Row = Result.fetchall()
        RowCount = len(Row)
    except:
        RowCount = 0
        Error = True

    if(RowCount > 0):
        for r in Row:
            CurrentDate = r.CurrentDate

    if Error is False:
        try:
            PostTime = datetime.datetime.strptime(PostTime, '%Y-%m-%d')
        except:
            Error = True
            PostTime = ''

        if Error is False:
            if CurrentDate == PostTime:
                Message = 'CurrentDate == PostTime'
                PostTime = ''
            elif CurrentDate > PostTime:
                Error = True
                Message = 'System date is already passed the posttime'
                PostTime = ''
            else:
                TDate = str(PostTime)

                CMD = 'D:\BankCard\Platform\dt.exe -s "VirtualTime" "' + TDate + '"'

                subprocess.run(CMD)

    Connect.close()

    return Error, PostTime