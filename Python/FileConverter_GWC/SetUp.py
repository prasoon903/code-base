class SetUp:
    InputFile = "E:\Python\FileConverter_GWC\INPUT"
    ErrorFile = "E:\Python\FileConverter_GWC\ERROR"
    OutFile = "E:\Python\FileConverter_GWC\OUT"
    LogFile = "E:\Python\FileConverter_GWC\LOG"
    ResponseFile = "E:\Python\FileConverter_GWC\ResponseFile"
    DumpedFile = "E:\Python\FileConverter_GWC\DumpedFile"
    OutFileNamePrefix = "COOKIE-231352_"
    SheetName = 'Sheet1'
    Columns = ['ACCOUNTID', 'CLEARING_TIMESTAMP', 'DISPUTEAMOUNT']
    DataTypes = ['VARCHAR', 'DATETIME', 'MONEY']
    Prefix = 'INSERT INTO #TempRecords (AccountUUID, TranTime, Amount) VALUES ('
    Suffix = ' )'


    CI_DB_POD1 = "PP_CI"
    CI_SEC_DB_POD1 = "PP_CI_Secondary"
    CL_DB_POD1 = "PP_CL"
    CAuth_DB_POD1 = "PP_CAuth"
    CC_DB_POD1 = "PP_CC"
    CoreApp_DB_POD1 = "PP_CoreApp"
    CoreCredit_DB_POD1 = "PP_CoreCredit"
    SERVERNAME_POD1 = "XEON-S8"
    Driver = "{ODBC Driver 17 for SQL Server}"