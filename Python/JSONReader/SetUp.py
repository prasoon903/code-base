class SetUp:
    CI_DB = "PP_CI"
    CL_DB = "PP_CL"
    CAuth_DB = "PP_CAuth"
    SERVERNAME = "XEON-S8"
    TableName1 = "IPMMAsterInterim"
    TableName2 = "IPMAddendumDetails"
    JSONInputFile = "E:\Python\JSONReader\JSONFile\INPUT"
    JSONErrorFile = "E:\Python\JSONReader\JSONFile\ERROR"
    JSONOutFile = "E:\Python\JSONReader\JSONFile\OUTPUT"
    JSONLogFile = "E:\Python\JSONReader\JSONFile\LOG"
    JSONSplitFile = "E:\Python\JSONReader\JSONFile\SPLITTED"
    XML1 = "IPM.xml"
    XML2 = "Addendum.xml"
    BulkInsert = 0
    JSONEnvironment = "LOCAL"
    MULTI_ROW_INSERT_LIMIT = 10
    WORKERS = 4