SET NOCOUNT ON

DECLARE @URL VARCHAR(50) = '/DBBWEB/CoreCardServices/CoreCardServices.svc/', 
		@END VARCHAR(10) = '',
		@POD2URL VARCHAR(50) = '/PrasoonP/PrasoonPOD2'

DELETE FROM PP_CI..CommonTNP WHERE ATID NOT IN (60, 110) 

--UPDATE PP_CI..Logo_Balances SET TNPPDFXmlGeneration = NULL, StatementAPIJSON = NULL
--UPDATE PP_CI..Org_Balances SET AsynchronousPosting = NULL
----, RealTimePostingDuringEOM = NULL
--, NewTNPQueue = NULL
UPDATE PP_CI..ConfigStore SET KeyValue = '0' WHERE KeyName = 'COMMONAP_QNAJOB'

UPDATE  PP_CL..APICallSetup SET Environment = 'LOCAL', host='pparashar.corecard.in'

UPDATE  PP_CL..APICallSetup SET url= @URL + 'AddManualStatusToAccount' + @END WHERE APINAME = 'svcAddManualStatusToAccount'
UPDATE  PP_CL..APICallSetup SET url= @URL + 'RemoveManualStatusFromAccount' + @END WHERE APINAME = 'svcRemoveManualStatus'
UPDATE  PP_CL..APICallSetup SET url= @POD2URL + 'MergeAccountsAcrossPOD' + @END WHERE APINAME = 'svcMergeAccountsAcrossPOD'
UPDATE  PP_CL..APICallSetup SET url= @POD2URL + 'MrgTxnOnDestAcctAcrossPOD' + @END WHERE APINAME = 'svcMrgTxnOnDestAcctAcrossPOD'
UPDATE  PP_CL..APICallSetup SET url= @POD2URL + 'MrgLoyaltyRetailTxnAcrossPOD' + @END WHERE APINAME = 'svcMrgLoyaltyRetailTxnAcrossPOD'
UPDATE  PP_CL..APICallSetup SET url= @POD2URL + 'MergeUtilityAcrossPOD' + @END WHERE APINAME = 'svcMergeUtilityAcrossPOD'
UPDATE  PP_CL..APICallSetup SET url= @POD2URL + 'AcrossPodTxnCreation' + @END WHERE APINAME = 'svcAcrossPodTxnCreation'

--UPDATE PP_CI..Logo_Secondary SET RetailLog = 1 WHERE acctId <> 1

UPDATE PP_CI..ARSystemHSAccounts SET InstitutionID = NULL

UPDATE PP_CL..UserInformation SET usrPassword=convert(varbinary,'#bqhEnrY5ii/CDE90'),
usrErnLogin='0',usrStatus = '0',PasswordDate = '2037-10-27 00:06:04.000' WHERE usrid IN('MayorsCall','CreditStacksCall','PortalSuperUser', 'PortalManager',
'BCAdmin','FinalAdmin','AOCAdmin','AuthUser','ServiceUser', 'SystemCommSvc')


--SELECT * FROM PP_CL..APICallSetup

--SELECT * FROM KK_CL..APICallSetup