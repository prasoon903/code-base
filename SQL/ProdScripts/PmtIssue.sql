;WITH CTE
AS
(
	SELECT AccountNumber, SUM(TransactionAmount) TransactionAmount, COUNT(1) PaymentCount
	FROM CCard_Primary WITH (NOLOCK)
	WHERE CMTTranType = '21'
	AND TranTime = '2023-07-31 23:30:00'
	AND ArTxnType = '91'
	GROUP BY AccountNumber
	HAVING COUNT(1) > 1
)
SELECT C.*, SH.StatementDate, SH.acctID, SH.SRBWithInstallmentDue, SH.AmountOfTotalDue, SH.CurrentBalance, SH.CycleDueDTD
FROM StatementHeader SH WITH (NOLOCK)
JOIN CTE C ON (SH.StatementDate = '2023-06-30 23:59:57' AND SH.AccountNumber = C.AccountNumber)
WHERE TransactionAmount >= SH.SRBWithInstallmentDue