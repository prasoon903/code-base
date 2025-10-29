class SetUp:
    POTBInputFile = "P:\Dump\POTB\Input"
    POTBErrorFile = "P:\Dump\POTB\ERROR"
    POTBOutFile = "P:\Dump\POTB\OUT"
    POTBLogFile = "P:\Dump\POTB\LOG"
    InsitutionID = 6981
    MailFrom = "PlatProduction@corecard.com"
    MailTo = "cmanagement@corecard.com,rohit.soni@corecard.com,prasoon.parashar@corecard.com,Raktim.Mitra@ny.email.gs.com,gs-credit-cookie-cm-jobs@ny.email.gs.com,platprodalert@corecard.com,platalertsupport@corecard.com"
    #MailTo = "prasoon.parashar@corecard.com,vijay.chandel@corecard.com,samadhan.gogate@corecard.com"
    SMTP_SERVER = "10.32.14.1"
    SMTPPORT = 25
    CI_DB = "PP_CI"
    CL_DB = "PP_CL"
    CAuth_DB = "PP_CAuth"
    SERVERNAME = "XEON-S8"

	
    #Irving Embossing File Setup..................................
    OutGoing_Emb_In='P:\OutgoingFiles\Irving'
    OutGoing_Emb_Error_Dir='P:\OutgoingFiles\Irving\ERROR'
    OutGoing_Emb_Processed='P:\OutgoingFiles\Irving\OUT'
    OutGoing_Emb_Log_Dir='P:\OutgoingFiles\Irving\LOG'
    
    SQLLiteDBPath='P:\OutgoingFiles\Irving\SQLite_DB'   
	
    OTBReleaseFileIN='P:\Dump\OTBRelaseAPI\Incoming_file'
    OTBReleaseFileError='P:\Dump\OTBRelaseAPI\Error'
    OTBReleaseFileOUT='P:\Dump\OTBRelaseAPI\Processed'
    OTBReleaseFileLog='P:\Dump\OTBRelaseAPI\Log'
    SQLLiteOTBDBPath='P:\Dump\OTBRelaseAPI\SQLite_DB'
    BulkCardResponseFileIN='P:\Dump\BulkResponseFile\PythonScript\Incoming_file'
    BulkCardResponseFileError='P:\Dump\BulkResponseFile\PythonScript\Error'
    BulkCardResponseFileOUT='P:\Dump\BulkResponseFile'
    BulkCardResponseFileLog='P:\Dump\BulkResponseFile\PythonScript\Log'
    SQLLiteBulkCreationPath='P:\Dump\BulkResponseFile\PythonScript\SQLite_DB'
    RetailInputFile = 'P:\Dump\MilkReplaySchedules\MilkReplaySchedules\INPUT'
    RetailErrorFile = 'P:\Dump\MilkReplaySchedules\MilkReplaySchedules\ERROR'
    RetailOutFile = 'P:\Dump\MilkReplaySchedules\MilkReplaySchedules\OUT'
    RetailLogFile = 'P:\Dump\MilkReplaySchedules\MilkReplaySchedules\LOG'
    RetailInsitutionID = 6981
    POTBEnvironment = "PRODUCTION"
    POTBInstitutionID = 6981
    EnvironmentName = "PLATPROD"
    IrvingReport_FileIN='P:\Dump\IrvingReport\In'
    IrvingReport_FileERROR='P:\Dump\IrvingReport\Error'
    IrvingReport_FileOUT='P:\Dump\IrvingReport\Out'
    IrvingReport_FileLOG='P:\Dump\IrvingReport\Log'
    IrvingReport_FileException="P:\Dump\IrvingReport\Exception"
    IrvingReport_FileEmpty=r"P:\Dump\IrvingReport\Out\6981"
    IsEmbReportSplitByInsId = "YES"
    POTBPolicy = "G2"
    POTBIdentifier = "ACCOUNTNUMBER"
    POTBAWSEnvironment = 0 # 0 = NotAWS, 1 = AWS environment
    POTBAWS_secret_name = "ses-smtp-secret"
    POTBAWS_region_name = "ap-south-1"
    POTBAWS_service_name = "secretsmanager"
    POTBSES_smtp_url = "email-smtp.ap-south-1.amazonaws.com"
    POTBAWSPort = 587
    AccountUpdate_FileIN = "P:\Dump\Embossing\WFAccountParametersUpdatess\InputFolder"
    AccountUpdate_FileERROR = "P:\Dump\Embossing\WFAccountParametersUpdates\ErrorFolder"
    AccountUpdate_FileLOG = "P:\Dump\Embossing\WFAccountParametersUpdates\LogFolder"
    AccountUpdate_FileOUT = "P:\Dump\Embossing\WFAccountParametersUpdates\OutFolder"
    AccountUpdate_EmptyFolder = "P:\Dump\Embossing\WFAccountParametersUpdates\EmptyFolder"
    AccountUpdate_DebugMode = "P:\Dump\Embossing\WFAccountParametersUpdates\ExceptionFolder"
