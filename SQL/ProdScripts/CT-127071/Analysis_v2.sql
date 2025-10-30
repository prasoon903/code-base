SELECT * FROM ##TempAccounts

;WITH CTE AS (SELECT *, ROW_NUMBER() OVER(PARTITION BY DISPUTE_ID, CLIENT_ID ORDER BY TRANSACTION_DATE) [RowCount] FROM ##TempAccounts)
SELECT * INTO #TempData FROM CTE WHERE [RowCount] = 1

SELECT * FROM #TempData


SELECT *, TRY_CAST( 0 AS INT) LM49, TRY_CAST( 0 AS INT) LM43 INTO #TempFinal FROM #TempData

SELECT * FROM #TempFinal

SELECT * 
FROM #LM49 T1 JOIN #LM43 T2 ON (T1.AccountNumber = T2.AccountNumber AND T1.TransactionAmount = T2.TransactionAmount)

SELECT DISTINCT AccountNumber INTO #Accounts FROM ##TempAccounts


DROP TABLE IF exists #LM49
SELECT CP.AccountNumber, TranID, CMTTRanType, TransactionAmount, TxnSource, TransactionDescription, RevTgt, TranTime, PostTime, ArTxnType, MemoIndicator, ClaimID
INTO #LM49
FROM CCard_Primary CP WITH (NOLOCK)
JOIN #Accounts A ON (CP.AccountNumber = A.AccountNumber)
WHERE CP.CMTTranType = '49'
AND ArTxnType <> '104'

DROP TABLE IF exists #LM43
SELECT CP.AccountNumber, TranID, CMTTRanType, TransactionAmount, TxnSource, TransactionDescription, RevTgt, TranTime, PostTime, ArTxnType, MemoIndicator, ClaimID
INTO #LM43
FROM CCard_Primary CP WITH (NOLOCK)
JOIN #Accounts A ON (CP.AccountNumber = A.AccountNumber)
WHERE CP.CMTTranType = '43'
--AND MemoIndicator = 'Memo'
AND ArTxnType <> '104'

DELETE FROM #LM43 WHERE MemoIndicator IS NULL

SELECT CP.AccountNumber, TranID, CMTTRanType, TransactionAmount, TxnSource, TransactionDescription, RevTgt, TranTime, PostTime, ArTxnType, MemoIndicator, ClaimID
FROM CCard_Primary CP WITH (NOLOCK)
WHERE AccountNumber = '1100011123135497'
AND CMTTRanType = '43'

1100011123135497


SELECT * FROM #LM49 WHERE AccountNumber = '1100011123135497   '
SELECT * FROM #LM43 WHERE AccountNumber = '1100011123135497   '


SELECT * FROM #TempData WHERE AccountNumber = '1100011101330540'
SELECT * FROM #LM49 WHERE AccountNumber = '1100011101330540'
SELECT * FROM #LM43 WHERE AccountNumber = '1100011101330540'


;WITH CTE
AS
(
SELECT T.*, 
TranID, CMTTRanType, TransactionAmount, TxnSource, TransactionDescription, RevTgt, TranTime, PostTime, ArTxnType, MemoIndicator, ClaimID
, ROW_NUMBER() OVER(PARTITION BY DISPUTE_ID, CLIENT_ID ORDER BY TRANSACTION_DATE) [RowCount1] 
FROM #TempData T
JOIN #LM49 LM49 ON (T.AccountNumber = LM49.AccountNumber)
WHERE DISPUTE_AMOUNT = LM49.TransactionAMount
)
SELECT * INTO #PostedLM49 FROM CTE WHERE [RowCount1] = 1

SELECT * FROM #TempFinal
SELECT * FROM #PostedLM49


SELECT * 
FROM #TempFinal T1
JOIN #PostedLM49 T2 ON (T1.DISPUTE_ID = T2.DISPUTE_ID )



UPDATE T1
SET LM49 = 1 
FROM #TempFinal T1
JOIN #PostedLM49 T2 ON (T1.DISPUTE_ID = T2.DISPUTE_ID )

DROP TABLE IF EXISTS #LM49_SUM
DROP TABLE IF EXISTS #LM43_SUM
DROP TABLE IF EXISTS #TempData_SUM

SELECT AccountNumber, SUM(ISNULL(TransactionAmount, 0)) TransactionAmount INTO #LM49_SUM FROM #LM49 GROUP BY AccountNumber


SELECT AccountNumber, SUM(ISNULL(TransactionAmount, 0)) TransactionAmount INTO #LM43_SUM FROM #LM43 GROUP BY AccountNumber


SELECT AccountNumber, SUM(ISNULL(DISPUTE_AMOUNT, 0)) DISPUTE_AMOUNT INTO #TempData_SUM FROM #TempData GROUP BY AccountNumber 



SELECT T3.*, T1.*, T2.*
FROM #LM49_SUM T1
JOIN #LM43_SUM T2 ON (T1.AccountNumber = T2.AccountNumber)
JOIN #TempData_SUM T3 ON (T3.AccountNumber = T2.AccountNumber)

SELECT T1.*, ISNULL(T2.TransactionAmount, 0) LM43Amount, ISNULL(T3.TransactionAmount, 0) LM49Amount
INTO #AllTxnAmount
FROM #TempData_SUM T1
LEFT JOIN #LM43_SUM T2 ON (T1.AccountNumber = T2.AccountNumber)
LEFT JOIN #LM49_SUM T3 ON (T3.AccountNumber = T2.AccountNumber)


SELECT *
FROM #TempData T1
JOIN #AllTxnAmount A ON (T1.AccountNumber = A.AccountNumber)

;WITH CTE
AS
(
SELECT T.*, LM43.DISPUTE_AMOUNT SUM_DISPUTE_AMOUNT, LM43Amount, LM49Amount,  ROW_NUMBER() OVER(PARTITION BY T.AccountNumber ORDER BY TRANSACTION_DATE) [RowCount1] 
FROM #TempData T
JOIN #AllTxnAmount LM43 ON (T.AccountNumber = LM43.AccountNumber)
)
SELECT * FROM CTE WHERE [RowCount1] = 1



;WITH CTE
AS
(
SELECT T.*, 
TranID, CMTTRanType, TransactionAmount, TxnSource, TransactionDescription, RevTgt, TranTime, PostTime, ArTxnType, MemoIndicator, ClaimID
, ROW_NUMBER() OVER(PARTITION BY DISPUTE_ID, CLIENT_ID ORDER BY TRANSACTION_DATE) [RowCount1] 
FROM #TempData T
JOIN #LM43 LM43 ON (T.AccountNumber = LM43.AccountNumber)
WHERE DISPUTE_AMOUNT = LM43.TransactionAMount
)
SELECT * INTO #PostedLM43 FROM CTE WHERE [RowCount1] = 1



SELECT * 
FROM #TempFinal T1
JOIN #PostedLM43 T2 ON (T1.DISPUTE_ID = T2.DISPUTE_ID )



UPDATE T1
SET LM43 = 1 
FROM #TempFinal T1
JOIN #PostedLM43 T2 ON (T1.DISPUTE_ID = T2.DISPUTE_ID )


SELECT * FROM #TempFinal WHERE LM43 = 1 AND LM49 = 1

SELECT * FROM #TempFinal WHERE AccountNumber = '1100011123135497   '

SELECT * FROM #PostedLM43 WHERE AccountNumber = '1100011123135497   '


SELECT * FROM #TempFinal WHERE LM43 = 0 AND LM49 = 0

