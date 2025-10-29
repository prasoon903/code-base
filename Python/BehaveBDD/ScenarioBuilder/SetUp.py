class SetUp:
    InputFile = "E:\Python\BehaveBDD\ScenarioBuilder\INPUT"
    ErrorFile = "E:\Python\BehaveBDD\ScenarioBuilder\ERROR"
    OutFile = "E:\Python\BehaveBDD\ScenarioBuilder\OUT"
    LogFile = "E:\Python\BehaveBDD\ScenarioBuilder\LOG"
    ResponseFile = "E:\Python\BehaveBDD\ScenarioBuilder\ResponseFile"
    ProcessedFile = "E:\Python\BehaveBDD\ScenarioBuilder\ProcessedFile"
    DumpedFile = "E:\Python\BehaveBDD\ScenarioBuilder\DumpedFile"
    OutFileNamePrefix = "COOKIE-231352_"
    SheetName = 'Sheet1'
    Columns = ['Trantime', 'PostTime', 'CMTTRANTYPE', 'txnsource', 'creditplanmaster', 'TransactionAmount',
               'TransactionDescription', 'TranId', 'TranRef', 'RevTgt', 'ClaimID']
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