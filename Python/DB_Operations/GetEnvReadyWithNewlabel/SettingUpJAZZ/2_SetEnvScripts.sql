SET NOCOUNT ON


DELETE FROM PP_JAZZ_CI..CommonTNP WHERE ATID NOT IN (60, 110)

UPDATE PP_JAZZ_CI..Logo_Balances SET TNPPDFXmlGeneration = NULL, StatementAPIJSON = NULL
UPDATE PP_JAZZ_CI..Org_Balances SET AsynchronousPosting = NULL
--, RealTimePostingDuringEOM = NULL
, NewTNPQueue = NULL
UPDATE PP_JAZZ_CI..ConfigStore SET KeyValue = '0' WHERE KeyName = 'COMMONAP_QNAJOB'

UPDATE PP_JAZZ_CI..Logo_Secondary SET RetailLog = 1 WHERE acctId <> 1

UPDATE PP_JAZZ_CI..ARSystemHSAccounts SET InstitutionID = NULL

UPDATE PP_JAZZ_CL..UserInformation SET usrPassword=convert(varbinary,'#bqhEnrY5ii/CDE90'),
usrErnLogin='0',usrStatus = '0',PasswordDate = '2037-10-27 00:06:04.000' WHERE usrid IN('MayorsCall','CreditStacksCall','PortalSuperUser', 'PortalManager',
'BCAdmin','FinalAdmin','AOCAdmin','AuthUser','ServiceUser', 'SystemCommSvc')


--SELECT * FROM PP_JAZZ_CL..APICallSetup