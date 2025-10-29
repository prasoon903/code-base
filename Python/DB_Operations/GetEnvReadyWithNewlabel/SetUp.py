class SetUp:
    CI_DB_POD1 = "PP_CI"
    CI_SEC_DB_POD1 = "PP_CI_Secondary"
    CL_DB_POD1 = "PP_CL"
    CAuth_DB_POD1 = "PP_CAuth"
    CC_DB_POD1 = "PP_CC"
    CoreApp_DB_POD1 = "PP_CoreApp"
    CoreCredit_DB_POD1 = "PP_CoreCredit"
    SERVERNAME_POD1 = "BPLDEVDB01"
    POD1_MDF = "\\\\BPLDEVDB01\Prasoon_Parashar\MDF"
    POD1_LDF = "\\\\BPLDEVDB01\Prasoon_Parashar\LDF"

    CI_DB_POD2 = "PP_POD2_CI"
    CI_SEC_DB_POD2 = "PP_POD2_CI_Secondary"
    CL_DB_POD2 = "PP_POD2_CL"
    CAuth_DB_POD2 = "PP_POD2_CAuth"
    CC_DB_POD2 = "PP_POD2_CC"
    CoreApp_DB_POD2 = "PP_POD2_CoreApp"
    CoreCredit_DB_POD2 = "PP_POD2_CoreCredit"
    SERVERNAME_POD2 = "BPLDEVDB01"
    POD2_MDF = "\\\\BPLDEVDB01\Prasoon_Parashar\MDF"
    POD2_LDF = "\\\\BPLDEVDB01\Prasoon_Parashar\LDF"

    GetJazzEnv = 1  # 1-YES/0-NO
    JAZZ_CI_DB = "PP_JAZZ_CI"
    JAZZ_CI_SEC_DB = "PP_JAZZ_CI_Secondary"
    JAZZ_CL_DB = "PP_JAZZ_CL"
    JAZZ_CAuth_DB = "PP_JAZZ_CAuth"
    JAZZ_CC_DB = "PP_JAZZ_CC"
    JAZZ_CoreApp_DB = "PP_JAZZ_CoreApp"
    JAZZ_CoreCredit_DB = "PP_JAZZ_CoreCredit"
    JAZZ_SERVERNAME = "BPLDEVDB01"
    JAZZ_MDF = "\\\\BPLDEVDB01\Prasoon_Parashar\JazzDB\MDF"
    JAZZ_LDF = "\\\\BPLDEVDB01\Prasoon_Parashar\JazzDB\LDF"

    LogDir = "E:\Python\DB_Operations\LOG"

    LabelPathPrefix = "VMCCRMP01\ReleaseManagement\PLAT\Labels"
    #LabelPathPrefix = "VMCCRMP01\ReleaseManagement\Posting_2.0\Labels"

    LabelPathSuffix_POD1 = "Application\DB\MasterDB_New"
    LabelPathSuffix_POD2 = "Application\DB\MasterDB_POD2"
    JAZZ_LabelPathSuffix = "Application\DB\Jazz_MasterDB_New"

    DSLPathSuffix = "Application\DSL"
    DSLCopyLocation = "D:\ApplicationSetup\DSLMaster"
    EnvDSLLocation_POD1 = "D:\ApplicationSetup\POD1\DBBSetup\DSLs"
    EnvDSLLocation_POD2 = "D:\ApplicationSetup\POD2\DBBSetup\DSLs"
    EnvDSLLocation_JAZZ = "D:\ApplicationSetup\JAZZ\DBBSetup\DSLs"

    BackupLocation_POD1 = "D:\ApplicationSetup\POD1\DBBSetup\DSLs\Backup"
    BackupLocation_POD2 = "D:\ApplicationSetup\POD2\DBBSetup\DSLs\Backup"
    BackupLocation_JAZZ = "D:\ApplicationSetup\JAZZ\DBBSetup\DSLs\Backup"

    AdjustDSLs = 0
    DSLAdjusmentLoc = "E:\Python\DB_Operations\__ClientDSL"
    
    SQL = "E:\Python\DB_Operations"

    DBBackupLocation_POD1 = "\\\\BPLDEVDB01\Prasoon_Parashar\\backup"
    DBBackupLocation_POD2 = "\\\\BPLDEVDB01\Prasoon_Parashar\\backup"
    JAZZ_DBBackupLocation = "\\\\BPLDEVDB01\Prasoon_Parashar\\JazzDB\\backup"

    Driver = "{ODBC Driver 17 for SQL Server}"

    #1-- Normal / 2-- Enhanced
    RestoreProcess_POD1 = 3
    RestoreProcess_POD2 = 3
    RestoreProcess_JAZZ = 3

    DefaultDB_Master = 1
