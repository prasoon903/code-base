DECLARE @AccountID INT = 21382331

SELECT BSAcctid, --MergeActivityFlag, CP.ARTxnType, CP.TxnSource, 
RTRIM(CP.CMTTRANTYPE) AS CMTTRANTYPE, 
--CP.TransactionDescription,
CP.TxnAcctId, txnsource, CP.creditplanmaster, --EqualPayments, 
CP.TransactionAmount,CP.TranId,CP.TranRef,--CP.tranorig,CP.TransmissionDateTime,
CP.atid,Trantime,CP.PostTime, CP.NoblobIndicator,CP.MemoIndicator,CP.RevTgt, FeesAcctID, CPMGroup, ClaimID, RMATranUUID, TranOrig
FROM  CCard_Primary CP WITH (NOLOCK)
LEFT JOIN  CCard_Secondary CS WITH (NOLOCK) ON (CP.TranId = CS.TranId)
LEFT JOIN  CPMAccounts CPM WITH (NOLOCK) ON (CP.CreditPlanMaster = CPM.acctId AND CP.TxnSource = '29' AND CP.CMTTRANTYPE = '40')
WHERE CP.AccountNumber IN (SELECT AccountNumber FROM  BSegment_Primary WITH(NOLOCK) WHERE acctId = @AccountID) 
AND CP.CMTTRANTYPE NOT IN ('HPOTB','PPR','MMR')
--AND (LEN(CP.CMTTRANTYPE) = 2 OR TRY_CAST(CP.CMTTRANTYPE AS INT) < 120 OR TRY_CAST(CP.CMTTRANTYPE AS INT) > 1000 OR CP.CMTTRANTYPE IN ('QNA', '*SCR', 'MMRMD', 'ReageTot'))
--AND CP.TxnSource NOT IN ('4','10')
--AND CP.MemoIndicator IS NULL
--AND (CP.ArTxnType <> '93' OR CP.ArTxnType IS NULL)
--AND CP.PostTime BETWEEN '2023-07-31 23:59:57.000' AND '2023-08-31 23:59:57.000'
--AND CP.PostTime > '2022-08-31 23:59:57.000'
--AND CMTTranType NOT in ('40')
AND CP.TxnAcctId = 67203856
--AND CP.TranID = 72211033242
--AND CP.TranRef = 72211033242
--AND ClaimID = '7f52a7f1-e00c-47e9-a97d-aeacee9093de'
--AND CP.PostTime >= '2020-09-15 01:07:24.000'
--AND CP.PostTime < '2022-10-13 07:40:18.000'
--AND TransactionAmount = 38.05
ORDER BY CP.POSTTIME DESC

--2020-09-15 01:07:24.000

--AND CP.TranRef = 30464300166

/*
DECLARE @AccountID INT = 21160686

;WITH CCard
AS
(
	
	SELECT BSAcctid, MergeActivityFlag, CP.ARTxnType, CP.TxnSource, RTRIM(CP.CMTTRANTYPE) AS CMTTRANTYPE, CP.TransactionDescription,CP.TxnAcctId, CP.creditplanmaster, EqualPayments, 
	CP.TransactionAmount,CP.TranId,CP.TranRef,CP.tranorig,CP.TransmissionDateTime,CP.atid,Trantime,CP.PostTime,CP.MemoIndicator,CP.RevTgt, FeesAcctID, CPMGroup
	FROM  CCard_Primary CP WITH (NOLOCK)
	LEFT JOIN  CCard_Secondary CS WITH (NOLOCK) ON (CP.TranId = CS.TranId)
	LEFT JOIN  CPMAccounts CPM WITH (NOLOCK) ON (CP.CreditPlanMaster = CPM.acctId AND CP.TxnSource = 29 AND CP.CMTTRANTYPE = '40')
	WHERE CP.AccountNumber IN (SELECT AccountNumber FROM  BSegment_Primary WITH(NOLOCK) WHERE acctId = @AccountID) 
	AND CP.CMTTRANTYPE NOT IN ('HPOTB','PPR','MMR')
	AND (LEN(CP.CMTTRANTYPE) = 2 OR TRY_CAST(CP.CMTTRANTYPE AS INT) < 120 OR TRY_CAST(CP.CMTTRANTYPE AS INT) > 1000 OR CP.CMTTRANTYPE IN ('QNA', '*SCR', 'MMRMD', 'ReageTot'))
	--AND CP.TxnSource NOT IN ('4','10')
	--AND CP.MemoIndicator IS NULL
	AND (CP.ArTxnType <> 93 OR CP.ArTxnType IS NULL)
	--AND CP.PostTime BETWEEN '2023-07-31 23:59:57.000' AND '2023-08-31 23:59:57.000'
	--AND CP.PostTime > '2022-08-31 23:59:57.000'
	--AND CMTTranType NOT in ('40')
	--AND CP.TxnAcctId = 25496592
	--ORDER BY CP.POSTTIME --DESC
)
,Transactions
AS
(
	SELECT SUM(TransactionAmount) AS TransactionAmount,CMTTRANTYPE, TxnAcctid,
	--CAST(YEAR(TranTime) AS VARCHAR) + '/' + CASE WHEN LEN(CAST(MONTH(TranTime) AS VARCHAR)) = 1 THEN '0' + CAST(MONTH(TranTime) AS VARCHAR) ELSE CAST(MONTH(TranTime) AS VARCHAR) END AS Accumulator_TranTime,
	CAST(YEAR(PostTime) AS VARCHAR) + '/' + CASE WHEN LEN(CAST(MONTH(PostTime) AS VARCHAR)) = 1 THEN '0' + CAST(MONTH(PostTime) AS VARCHAR) ELSE CAST(MONTH(PostTime) AS VARCHAR) END AS Accumulator_PostTime,
	CASE WHEN TranTime < PostTime THEN 'BackDated_T_' + CONVERT(VARCHAR, TranTime, 101) + '_P_' + CONVERT(VARCHAR, PostTime, 101) ELSE 'PostDated' END AS TransactionType
	FROM CCard 
	--WHERE CMTTRANTYPE = '121'
	GROUP BY TranTime, PostTime, CMTTRANTYPE, TxnAcctid
	--ORDER BY TranTime DESC
)
, TransactionsWithStatement
AS
(
	SELECT SUM(TransactionAmount) AS TransactionAmount, CMTTRANTYPE, TxnAcctid, TransactionType, Accumulator_PostTime, 0 AS TP
	FROM Transactions
	GROUP BY CMTTRANTYPE, TxnAcctid, Accumulator_PostTime, TransactionType
	--ORDER BY Accumulator_PostTime DESC
	UNION
	SELECT AmountOfTotalDue AS TransactionAmount,NULL AS CMTTRANTYPE, 0 AS TxnAcctid, 'Statementing' AS TransactionType,
	CAST(YEAR(StatementDate) AS VARCHAR) + '/' + CASE WHEN LEN(CAST(MONTH(StatementDate) AS VARCHAR)) = 1 THEN '0' + CAST(MONTH(StatementDate) AS VARCHAR) ELSE CAST(MONTH(StatementDate) AS VARCHAR) END AS Accumulator_PostTime, 1 AS TP
	FROM StatementHeader WITH (NOLOCK) 
	WHERE acctId = @AccountID 
	--ORDER BY StatementDate DESC
)
SELECT *
FROM TransactionsWithStatement
ORDER BY Accumulator_PostTime DESC

*/