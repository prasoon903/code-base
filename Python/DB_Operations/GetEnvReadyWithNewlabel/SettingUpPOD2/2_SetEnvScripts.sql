SET NOCOUNT ON

DECLARE @URL VARCHAR(50) = '/PrasoonP/PrasoonPOD2', 
		@END VARCHAR(10) = '.aspx',
		@POD1URL VARCHAR(50) = '/PrasoonP/PrasoonP'

DELETE FROM PP_POD2_CI..CommonTNP WHERE ATID NOT IN (60, 110)

UPDATE PP_POD2_CI..Logo_Balances SET TNPPDFXmlGeneration = NULL, StatementAPIJSON = NULL

UPDATE  PP_POD2_CL..APICallSetup SET Environment = 'LOCAL', host='Xeon-web1'

UPDATE  PP_POD2_CL..APICallSetup SET url= @URL + 'AddManualStatusToAccount' + @END WHERE APINAME = 'svcAddManualStatusToAccount'
UPDATE  PP_POD2_CL..APICallSetup SET url= @URL + 'RemoveManualStatusAction' + @END WHERE APINAME = 'svcRemoveManualStatus'
UPDATE  PP_POD2_CL..APICallSetup SET url= @POD1URL + 'MergeAccountsAcrossPOD' + @END WHERE APINAME = 'svcMergeAccountsAcrossPOD'
UPDATE  PP_POD2_CL..APICallSetup SET url= @POD1URL + 'MrgTxnOnDestAcctAcrossPOD' + @END WHERE APINAME = 'svcMrgTxnOnDestAcctAcrossPOD'
UPDATE  PP_POD2_CL..APICallSetup SET url= @POD1URL + 'MrgLoyaltyRetailTxnAcrossPOD' + @END WHERE APINAME = 'svcMrgLoyaltyRetailTxnAcrossPOD'
UPDATE  PP_POD2_CL..APICallSetup SET url= @POD1URL + 'MergeUtilityAcrossPOD' + @END WHERE APINAME = 'svcMergeUtilityAcrossPOD'
UPDATE  PP_POD2_CL..APICallSetup SET url= @POD1URL + 'AcrossPodTxnCreation' + @END WHERE APINAME = 'svcAcrossPodTxnCreation'

UPDATE PP_POD2_CI..Logo_Secondary SET RetailLog = 1 WHERE acctId <> 1

UPDATE PP_POD2_CI..ARSystemHSAccounts SET InstitutionID = NULL

UPDATE PP_POD2_CL..UserInformation SET usrPassword=convert(varbinary,'#bqhEnrY5ii/CDE90'),
usrErnLogin='0',usrStatus = '0',PasswordDate = '2037-10-27 00:06:04.000' WHERE usrid IN('MayorsCall','CreditStacksCall','PortalSuperUser',
'BCAdmin','FinalAdmin','AOCAdmin','AuthUser','ServiceUser', 'SystemCommSvc')

--SELECT * FROM PP_POD2_CL..APICallSetup