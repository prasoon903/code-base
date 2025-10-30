

DROP TABLE IF EXISTS #ValidData
;WITH CTE
AS
(
	SELECT *, ROW_NUMBER() OVER (PARTITION BY AccountUUID, CaseID ORDER BY SN) [Rank] 
	FROM ##TempDCAReversals
	WHERE CaseID IS NOT NULL
)
SELECT * INTO #ValidData FROM CTE WHERE [Rank] = 1

DROP TABLE IF EXISTS #ValidData_NonMerge
SELECT * INTO #ValidData_NonMerge FROM #ValidData WHERE MergeInProcessPH IS NULL

DROP TABLE IF EXISTS #ValidData_Merge
SELECT T1.*, DestBSAcctId, DestAccountNumber, DestBSAccountUUID, AcrossPODMerge
INTO #ValidData_Merge 
FROM #ValidData T1
JOIN LS_PRODDRGSDB01.ccgs_coreissue.dbo.MergeAccountJob m1 WITH (NOLOCK) ON (T1.acctId = M1.SrcBSAcctId)
WHERE MergeInProcessPH IS NOT NULL

SELECT COUNT(1) FROM #ValidData_NonMerge

SELECT COUNT(1) FROM #ValidData_Merge



DROP TABLE IF EXISTS #LM16_NonMerge
SELECT T1.acctId, T1.AccountNumber, T1.AccountUUID, CP.ClaimID, CP.TransactionAmount, T1.Amount, CP.TranTime, CP.ArTxnType, CP.TranID,
ROW_NUMBER() OVER (PARTITION BY CP.AccountNumber, CP.ClaimID ORDER BY CP.TranTime) [Rank]
INTO #LM16_NonMerge
FROM #ValidData_NonMerge T1
JOIN CCard_Primary CP WITH (NOLOCK) ON (T1.AccountNumber = CP.AccountNumber AND T1.CaseID = CP.ClaimID)
WHERE CP.CMTTranType = '16'


DROP TABLE IF EXISTS #LM16_Merge
SELECT T1.acctId, T1.AccountNumber, T1.AccountUUID, CP.ClaimID, CP.TransactionAmount, T1.Amount, CP.TranTime, CP.ArTxnType, CP.TranID,
T1.DestBSAcctId, T1.DestAccountNumber, T1.DestBSAccountUUID,
ROW_NUMBER() OVER (PARTITION BY CP.AccountNumber, CP.ClaimID ORDER BY CP.TranTime) [Rank]
INTO #LM16_Merge
FROM #ValidData_Merge T1
JOIN CCard_Primary CP WITH (NOLOCK) ON (T1.DestAccountNumber = CP.AccountNumber AND T1.CaseID = CP.ClaimID)
WHERE CP.CMTTranType = '16'

SELECT * FROM #LM16_NonMerge WHERE TransactionAmount <> Amount ORDER BY TranTime

SELECT * FROM #LM16_Merge ORDER BY TranTime



SELECT RTRIM(AccountNumber) AccountNumber, AccountUUID, CaseID, Amount TransactionAmount--, TranTime TransactionTime 
FROM #ValidData 
ORDER BY AccountNumber


SELECT RTRIM(AccountNumber) AccountNumber, AccountUUID, ClaimID CaseID, TransactionAmount, TranTime TransactionTime 
FROM #LM16_NonMerge 
ORDER BY AccountNumber

SELECT RTRIM(AccountNumber) SourceAccountNumber,AccountUUID SourceAccountUUID, 
RTRIM(DestAccountNumber) DestAccountNumber, DestBSAccountUUID,ClaimID CaseID,
TransactionAmount,TranTime TransactionTime 
FROM #LM16_Merge 
ORDER BY AccountNumber


SELECT 
'INSERT INTO CreateNewSingleTransactionData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (' + TRY_CONVERT(VARCHAR, acctID) + ', '''+RTRIM(AccountNumber)+''', ' + TRY_CONVERT(VARCHAR, TransactionAmount) + ', ''17''' + ', ''1702''' + ', ''' + TRY_CONVERT(VARCHAR(20), TranTime, 20) + ''')'
FROM #LM16_NonMerge 
ORDER BY TranTime

SELECT 
'INSERT INTO CreateNewSingleTransactionData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (' + TRY_CONVERT(VARCHAR, DestBSacctID) + ', '''+RTRIM(DestAccountNumber)+''', ' + TRY_CONVERT(VARCHAR, TransactionAmount) + ', ''17''' + ', ''1702''' + ', ''' + TRY_CONVERT(VARCHAR(20), TranTime, 20) + ''')' 
FROM #LM16_Merge 
ORDER BY TranTime
