
DROP TABLE IF EXISTS #TempTxns
SELECT BSAcctId, AccountNumber, TranID, TxnSource, TransactionAmount, TranTime, PostTime, ArTxnType 
INTO #TempTxns 
FROM CCArd_Primary WITH (NOLOCK) 
WHERE CMTTRanType IN ('41') 
--AND PostTime BETWEEN '2022-12-31 23:59:57' AND GETDATE() 
AND PostTime BETWEEN '2024-06-30 23:59:57' AND GETDATE() 


DROP TABLE IF EXISTS #TempBDCredits 
SELECT * 
INTO #TempBDCredits 
FRoM #TempTxns 
WHERE DATEPART(MONTH, TranTime) <> DATEPART(MONTH, PostTime) 

SeLECT * FROM #TempBDCredits ORDER BY PostTime DESC

DROP TABLE IF EXISTS #TempImpactedAccounts 
SELECT * 
INTO #TempImpactedAccounts 
FROM #TempTxns 
WHERE AccountNumber IN (SELECT DISTINCT AccountNumber FROM #TempBDCredits) 


DROP TABLE IF EXISTS #TempRecords 
SELECT *, TRY_CAST (OldValue AS MONEY) - TRY_CAST (NewValue AS MONEY) DELTA 
INTO #TempRecords 
FROM CurrentBalanceAudit CBA WITH (NOLOCK) 
JOIN #TempImpactedAccounts TB ON (CBA.AID = TB.BSACCtID AND CBA.DENAME = 200 AND CBA. TID = TB. TranID) 
WHERE TRY_CAST (OldValue AS MONEY) - TRY_CAST (NewValue AS MONEY) > TB. transactionAmount 

SELECT * 
FROM #TempRecords 
WHERE BSAcctID = 12958388
ORDER BY PostTime DESC

SELECT DATEADD(SECOND, 86397, TRY_CAST(EOMONTH(DATEADD(MONTH, -1, TRY_CAST(EOMONTH(GETDATE()) AS DATETIME))) AS DATETIME))

DROP TABLE IF EXISTS #TempImpactedTxns 
SELECT *, DATEADD(SECOND, 86397, TRY_CAST(EOMONTH(DATEADD(MONTH, 0, TRY_CAST(EOMONTH(PostTime) AS DATETIME))) AS DATETIME)) NextStatementDate,
DATEADD(SECOND, 86397, TRY_CAST(EOMONTH(DATEADD(MONTH, -1, TRY_CAST(EOMONTH(PostTime) AS DATETIME))) AS DATETIME)) LastStatementDate
INTO #TempImpactedTxns
FROM #TempRecords


SELECT * FROM #TempImpactedTxns

DROP TABLE IF EXISTS #TempIntCharged 
SELECT T.*, AmtOfInterestCTD
INTO #TempIntCharged
FROM #TempImpactedTxns T
JOIN StatementHeader S WITH (NOLOCK) ON (T.BSAcctID = S.acctID AND T.NextStatementDate = S.StatementDate)
WHERE AmtOfInterestCTD > 0

SELECT T.*, A.PaymentAmount, OriginalPaymentAmount, A.ActualPaymentDate
INTO #TempACHSchedules
FROM ACHIntermediate A WITH (NOLOCK)
JOIN #TempImpactedTxns T ON (T.BSAcctID = A.acctID AND A.PaymentType = '0')
AND A.ACHPaymentDate BETWEEN T.LastStatementDate AND T.NextStatementDate


SELECT * FROM #TempIntCharged WITH (NOLOCK) ORDER BY BSacctID
SELECT * FROM #TempACHSchedules WITH (NOLOCK) ORDER BY BSacctID


SELECT *
FROM #TempIntCharged T1
LEFT JOIN #TempACHSchedules T2 ON (T1.BSAcctid  = T2.BSAcctID and T1.TID = T2.TID)
WHERE T2.BSAcctID IS NOT NULL --AND T2.TID IS NULL


SELECT * FROM #TempIntCharged WITH (NOLOCK) WHERE BSacctID = 2334052

SELECT * FROM ACHIntermediate WITH (NOLOCK) WHERE acctID = 2334052 AND ACHPaymentDate BETWEEN '2023-12-31 23:59:57' AND '2024-01-31 23:59:57'

SELECT * FROM #TempACHSchedules WITH (NOLOCK) WHERE BSacctID = 2334052


SELECT BSAcctId, CMTTRanType, AccountNumber, TranID, TxnSource, TransactionAmount, TranTime, PostTime, ArTxnType 
FROM CCArd_Primary WITH (NOLOCK) 
WHERE AccountNumber = '1100011109877575   '
--AND PostTime BETWEEN '2022-12-31 23:59:57' AND GETDATE() 
ORDER BY PostTime DESC


DROP TABLE IF EXISTS #Accounts
SELECT DISTINCT AccountNumber, BSAcctID INTO #Accounts FROM #TempImpactedTxns

DROP TABLE IF EXISTS #Statements
SELECT A.*, SH.CurrentBalance+SH.CurrentBalanceCO CurrentBalance, SRBWithInstallmentDue, AmountOfTotalDue, CycleDueDTD
INTO #Statements
FROM StatementHeader SH WITH (NOLOCK)
JOIN #Accounts A ON (SH.acctID = A.BSAcctID AND SH.StatementDate = '2024-06-30 23:59:57')

DROP TABLE IF EXISTS #Transactions
SELECT C.BSAcctId, CMTTRanType, C.AccountNumber, TranID, TxnSource, TransactionAmount, TranTime, PostTime, ArTxnType
INTO #Transactions 
FROM CCArd_Primary C WITH (NOLOCK) 
JOIN #Accounts A ON (A.AccountNumber = C.AccountNumber)
WHERE CMTTRanType IN ('21', '41')
AND PostTime > '2024-06-30 23:59:57'
AND ArTxnType = '91'

DROP TABLE IF EXISTS #CurrentCycleImpactedList
;WITH CTE
AS
(
SELECT BSAcctID, AccountNumber, CMTTRanType, SUM(TransactionAmount) TransactionAmount FROM #Transactions GROUP BY BSAcctID, AccountNumber, CMTTRanType
),
AccountData
AS
(
SELECT S.*,
CASE WHEN CMTTRanType = '21' THEN ISNULL(TransactionAmount, 0) ELSE 0 END TotalPayments,
CASE WHEN CMTTRanType = '41' THEN ISNULL(TransactionAmount, 0) ELSE 0 END TotalCreditsWithoutPmts
FROM CTE C
RIGHT JOIN #Statements S ON (C.AccountNumber = S.AccountNumber)
--ORDER BY S.AccountNumber
)
SELECT BSAcctID, AccountNumber, CurrentBalance, SRBWithInstallmentDue, AmountOfTotalDue, CycleDueDTD, SUM(TotalPayments) TotalPayments, SUM(TotalCreditsWithoutPmts) TotalCreditsWithoutPmts
INTO #CurrentCycleImpactedList
FROM AccountData
GROUP BY BSAcctID, AccountNumber, CurrentBalance, SRBWithInstallmentDue, AmountOfTotalDue, CycleDueDTD

SELECT * FROM #CurrentCycleImpactedList

SELECT T.*, A.PaymentAmount, OriginalPaymentAmount, A.ActualPaymentDate
INTO #TempCurrentACHSchedules
FROM ACHIntermediate A WITH (NOLOCK)
JOIN #CurrentCycleImpactedList T ON (T.BSAcctID = A.acctID AND A.PaymentType = '0')
AND A.ACHPaymentDate BETWEEN '2024-06-30 23:59:57' AND '2024-07-31 23:59:57'