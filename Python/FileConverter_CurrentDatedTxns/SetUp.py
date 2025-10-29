class SetUp:
    InputFile = "E:\Python\FileConverter_CurrentDatedTxns\INPUT"
    ErrorFile = "E:\Python\FileConverter_CurrentDatedTxns\ERROR"
    OutFile = "E:\Python\FileConverter_CurrentDatedTxns\OUT"
    LogFile = "E:\Python\FileConverter_CurrentDatedTxns\LOG"
    ResponseFile = "E:\Python\FileConverter_CurrentDatedTxns\ResponseFile"
    DumpedFile = "E:\Python\FileConverter_CurrentDatedTxns\DumpedFile"
    OutFileNamePrefix = "COOKIE-231352_"
    SheetName = 'Cookie-8200'
    Columns = ['ACCOUNT_UUID', 'DISPUTE_AMOUNT']
    DataTypes = ['VARCHAR', 'MONEY']
    Prefix = 'INSERT INTO #TempRecords (AccountUUID, Amount) VALUES ('
    Suffix = ' )'