class SetUp:
    InputFile = "E:\Python\FileConverter_BackdatedTxns\INPUT"
    ErrorFile = "E:\Python\FileConverter_BackdatedTxns\ERROR"
    OutFile = "E:\Python\FileConverter_BackdatedTxns\OUT"
    LogFile = "E:\Python\FileConverter_BackdatedTxns\LOG"
    ResponseFile = "E:\Python\FileConverter_BackdatedTxns\ResponseFile"
    DumpedFile = "E:\Python\FileConverter_BackdatedTxns\DumpedFile"
    OutFileNamePrefix = "COOKIE-232597_"
    SheetName = 'Sheet1'
    Columns = ['ACCOUNT_UUID', 'CLEARING_TIMESTAMP', 'ORIGINAL_DISPUTE_AMOUNT']
    DataTypes = ['VARCHAR', 'DATETIME', 'MONEY']
    Prefix = 'INSERT INTO #TempRecords (AccountUUID, TranTime, Amount) VALUES ('
    Suffix = ' )'