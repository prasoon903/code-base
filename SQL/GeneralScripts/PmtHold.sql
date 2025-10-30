SELECT * FROM HoldPaymentDynamicLogic WHERE ProductId = 7131 AND HoldPaymentRuleID = 65

SELECT ReportingData, * 
FROM HoldPaymentAcctDynamicLogic 
WHERE PaymentHoldPolicyVersion = 'G2'
AND ReportingData = 'HR_EPH'
--and HoldPaymentRuleID=69 

order by RulePriority

SELECT * FROM RuleDynamicLogic WHERE RuleID = 112
SELECT * FROM HoldPayment where productid =7131 and UniqueId = 69
SELECT * FROM HoldPayment


SELECT M.ActualTranCode, M.BackupPolicyRIPcheck, H.AccountLevelCheck, H.* 
FROM HoldPayment H WITH (NOLOCK)
LEFT JOIN MonetaryTxnControl M WITH (NOLOCK) ON (H.PymtHoldTranCode = M.TransactionCode)
WHERE M.ActualTranCode = '2115'


SELECT M.ActualTranCode, M.BackupPolicyRIPcheck, H.AccountLevelCheck, H.* 
FROM HoldPayment H WITH (NOLOCK)
LEFT JOIN MonetaryTxnControl M WITH (NOLOCK) ON (H.PymtHoldTranCode = M.TransactionCode)
WHERE productid =7131 and UniqueId = 69 AND 

SELECT BackupPolicyRIPcheck,* FROM MonetaryTxnControl WITH (NOLOCK) WHERE ActualTranCode = '2115'

SELECT BackupPolicyRIPcheck,* FROM MonetaryTxnControl WITH (NOLOCK) WHERE LogicModule IN ('22')





SELECT * FROM CCardLookUp WITH (NOLOCK) WHERE LUTid LIKE '%pmt%'


--USP_InsertInto_IntraDayAccountOTBRule_Internal

SELECT PolicyVersion, PolicySubVersion,* FROM DPUSHPAD_CI..IntradayAccountOTBRule_Internal WHERE FileName = '3FEB2802_Sample_File_file1.csv'

SELECT PolicyVersion, PolicySubVersion, VIPFlag,* FROM DPUSHPAD_TempDB..IntradayAccountOTBRule_Internal WHERE FileName = '3FEB2802_Sample_File_file1.csv'

SELECT * FROM PaymentHoldDetails WHERE AccountNumber = '1100001000006705'


SELECT * FROM DPUSHPAD_TempDB..PaymentHoldDetails WHERE AccountNumber = '1100001000006705'


SELECT * FROM DPUSHPAD_TempDB..PaymentHoldFileProcessing



SELECT 
	CP.BSAcctid, CP.CMTTRANTYPE, TransactionDescription, CP.TxnSource, CP.TransactionAmount, CP.TranTime, CP.PostTime, 
	CP.TranId, CP.TranRef, CP.tranorig, CP.RevTgt, CP.NoBlobIndicator, CP.NoBlobIndicatorGEN
FROM DPUSHPAD_TempDB..CCard_Primary CP WITH (NOLOCK)
LEFT JOIN DPUSHPAD_TempDB..CCard_Secondary CS WITH (NOLOCK) ON (CP.TranID = CS.TranId)
WHERE CP.AccountNumber = '1100001000006705'
ORDER BY CP.PostTime DESC

