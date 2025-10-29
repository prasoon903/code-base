class SetUp:
    InputFile = "E:\Python\FileConverter\INPUT"
    ErrorFile = "E:\Python\FileConverter\ERROR"
    OutFile = "E:\Python\FileConverter\OUT"
    LogFile = "E:\Python\FileConverter\LOG"
    ResponseFile = "E:\Python\FileConverter\ResponseFile"
    DumpedFile = "E:\Python\FileConverter\DumpedFile"
    SQL = "E:\Python\FileConverter\SQL"
    OutFileNamePrefix = "GoodWillCredits_"
    SheetName = 'FinalPopulation'
    Columns = ['ACCOUNT_ID', 'TRANSACTION_DATE', 'ORIGINAL_DISPUTE_AMOUNT']
    DataTypes = ['VARCHAR', 'DATETIME', 'MONEY']
    Prefix = 'INSERT INTO RemediationData (AccountUUID, TranTime, Amount) VALUES ('
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