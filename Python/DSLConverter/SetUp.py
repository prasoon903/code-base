class SetUp:
    InputFile = "E:\\Python\\DSLConverter\\INPUT"
    ErrorFile = "E:\\Python\\DSLConverter\\ERROR"
    OutFile = "E:\\Python\\DSLConverter\\OUT"
    LogFile = "E:\\Python\\DSLConverter\\LOG"
    ResponseFile = "E:\\Python\\DSLConverter\\ResponseFile"
    DSLToDumpFile = "E:\\Python\\DSLConverter\\DumpedFile"
    DSLPath = "D:\\ApplicationSetup\\POD1\\DBBSetup\\DSLs"
    OutFileNamePrefix = "COOKIE-288629_"
    SheetName = 'Sheet2'
    Columns = ['ACCOUNT_UUID', 'CORE_CARD_CASE_ID', 'CORE_CARD_TRANSACTION_ID', 'TRANSACTION_AMOUNT', 'DISPUTE_AMOUNT', 'CLIENT_ID']
    DataTypes = ['VARCHAR', 'VARCHAR', 'VARCHAR', 'MONEY', 'MONEY', 'VARCHAR']
    Prefix = 'INSERT INTO ##TempData (ACCOUNT_UUID, CORE_CARD_CASE_ID, CORE_CARD_TRANSACTION_ID, TRANSACTION_AMOUNT, DISPUTE_AMOUNT, CLIENT_ID) VALUES ('
    Suffix = ')'
    ReadAllFiles = 0
    IDEElements = ['BalanceContributor', 'EnumMember', 'DataElement', 'Expression', 'Restriction', 'Index',
                   'MessageType', 'MessageStore', 'Query', 'Join', 'QueryNode', 'Action', 'Category', 'WorkStep',
                   'Rule', 'Account']
    ElementsToScan = []
