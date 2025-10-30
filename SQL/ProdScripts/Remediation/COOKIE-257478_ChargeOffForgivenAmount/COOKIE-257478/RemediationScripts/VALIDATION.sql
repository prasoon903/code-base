--SELECT * FROM MonetaryTxnControl WITH (NOLOCK) WHERE LogicModule IN ('49', '88', '89') AND ChargeOffReason IS NOT NULL

--SELECT * FROM COOKIE_257478_ChargeOffAccount WITH (NOLOCK)

SELECT CASE 
	WHEN JobStatus = 0 THEN 'Records created and in Txn Posting State'
	WHEN JobStatus = 1 THEN 'Txn posted and need to update account'
	WHEN JobStatus = 2 THEN 'All activities performed successfully'
	ELSE 'Error in processing'
	END JobStatus, 
COUNT(1) [RecordCount]
FROM COOKIE_257478_ChargeOffAccount WITH (NOLOCK) 
GROUP BY JobStatus


;WITH CTE
AS
(
	SELECT TranID
	FROM CreateNewSingleTransactionData WITH (NOLOCK)
	WHERE Reason = 'COOKIE-257478'
),
PostedTxns 
AS 
(
	SELECT AccountNumber, SUM(CP.TransactionAmount) TransactionAmount
	FROM CCard_Primary CP WITH (NOLOCK)
	JOIN CTE C ON (C.TranID = CP.TranID)
	GROUP BY AccountNumber
),
TxnsToPost
AS
(
	SELECT AccountNumber, ForgivenAmount 
	FROM COOKIE_257478_ChargeOffAccount WITH (NOLOCK) 
	WHERE JobStatus = 2
)
SELECT COUNT(1) [AccountsWithInvalidTxnAmountPosted]
FROM TxnsToPost T
JOIN PostedTxns P ON (T.AccountNumber = P.AccountNumber)
WHERE P.TransactionAmount <> T.ForgivenAmount

SELECT COUNT(1) [AccountsWithInvalidChargeOffAmount] 
FROM COOKIE_257478_ChargeOffAccount T WITH (NOLOCK) 
JOIN BSegmentCreditCard B WITH (NOLOCK) ON (T.acctID = B.acctID)
WHERE JobStatus = 2
AND T.TotalAmountCO_After <> B.TotalAmountCO


SELECT COUNT(1) [AccountsWithIncorrectReclassDate] 
FROM COOKIE_257478_ChargeOffAccount T WITH (NOLOCK) 
JOIN BSegmentCreditCard B WITH (NOLOCK) ON (T.acctID = B.acctID)
WHERE JobStatus = 2
AND CASE WHEN T.RCLSDateToSet IS NOT NULL THEN T.RCLSDateToSet ELSE RCLSDateOnAccount END <> B.ChargeOffReclassDate
