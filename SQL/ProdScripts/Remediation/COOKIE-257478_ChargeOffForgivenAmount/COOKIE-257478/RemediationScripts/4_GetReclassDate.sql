
--;WITH CTE
--AS
--(
--	SELECT CP.AccountNumber, PostTime, 
--	ROW_NUMBER() OVER(PARTITION BY CP.AccountNumber ORDER BY PostTime DESC) RowCounter
--	FROM CCard_Primary CP WITH (NOLOCK)
--	JOIN COOKIE_257478_ChargeOffAccount T ON (T.AccountNumber = CP.AccountNumber)
--	WHERE CMTTranType IN ('RCLS', '51')
--	--AND T.RCLSDateOnAccount IS NULL
--)
--UPDATE T
--SET RCLSDateToSet = PostTime
--FROM COOKIE_257478_ChargeOffAccount T 
--JOIN CTE C ON (T.AccountNumber = C.AccountNumber)
--WHERE RowCounter = 1


;WITH CTE
AS
(
	SELECT CP.AccountNumber, PostTime, CMTTRanType, TransactionAmount, TranID, TranRef, TxnSource, CP.Transactionidentifier,
	ROW_NUMBER() OVER(PARTITION BY CP.AccountNumber, CP.CMTTRanType ORDER BY PostTime) Txn
	FROM CCard_Primary CP WITH (NOLOCK)
	JOIN COOKIE_257478_ChargeOffAccount T ON (T.AccountNumber = CP.AccountNumber)
	WHERE CMTTranType IN ('RCLS', '51', '54')
	AND CP.Transactionidentifier IS NULL
)
, CORev
AS
(
	SELECT C1.*
	FROM CTE C1
	JOIN CTE C2 ON (C1.AccountNumber = C2.AccountNumber AND C1.CMTTRanType = '51' AND C2.CMTTRanType = '54' AND C1.Txn = C2.Txn)
)
, AllTxn
AS
(
	SELECT *, ROW_NUMBER() OVER(PARTITION BY AccountNumber, CMTTRanType ORDER BY PostTime) TxnCounter
	FROM CTE
	WHERE CMTTranType IN ('RCLS', '51')
	AND TranID NOT IN (SELECT TranID FROM CORev)
)
,
TxnData
AS
(
	SELECT C1.AccountNumber, C1.PostTime RCLSDate, C2.TransactionAmount OriginalCOAmount,
	ROW_NUMBER() OVER(PARTITION BY C1.AccountNumber ORDER BY C1.PostTime DESC) RowCounter
	FROM AllTxn C1
	JOIN AllTxn C2 ON (C1.AccountNumber = C2.AccountNumber AND C1.CMTTRanType = 'RCLS' AND C2.CMTTRanType = '51')
	WHERE C1.TxnCounter = 1
	AND C2.TxnCounter = 1
)
UPDATE T
SET 
	RCLSDateToSet = RCLSDate,
	TotalAmountCO_Before = OriginalCOAmount,
	TotalAmountCO_After = OriginalCOAmount - T.ForgivenAmount
FROM COOKIE_257478_ChargeOffAccount T 
JOIN TxnData C ON (T.AccountNumber = C.AccountNumber)
WHERE RowCounter = 1
