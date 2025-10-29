class SetUp:
    InputFile = "E:\Python\FileConverter_InterestCredit\INPUT"
    ErrorFile = "E:\Python\FileConverter_InterestCredit\ERROR"
    OutFile = "E:\Python\FileConverter_InterestCredit\OUT"
    LogFile = "E:\Python\FileConverter_InterestCredit\LOG"
    ResponseFile = "E:\Python\FileConverter_InterestCredit\ResponseFile"
    DumpedFile = "E:\Python\FileConverter_InterestCredit\DumpedFile"
    OutFileNamePrefix = "InterestCredits_"
    SheetName = 'Sheet2'
    Columns = ['ACCOUNT_UUID', 'TRANSACTION_AMOUNT']
    DataTypes = ['VARCHAR', 'MONEY']
    Prefix = 'INSERT INTO ##TempData (AccountUUID, Amount) VALUES ('
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