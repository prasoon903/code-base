DROP TABLE IF EXISTS #TempRetailAuth
SELECT R1.AccountNumber, R2.TranID, R2.Amount, R2.UUID PlanUUID
INTO #TempRetailAuth
FROM LISTPRODPLAT.CCGS_CoreAuth.DBO.RetailAPILog R1 WITH (NOLOCK)
JOIN LISTPRODPLAT.CCGS_CoreAuth.DBO.RetailAPILineItems R2 WITH (NOLOCK) ON (R1.request_id = R2.request_id)
WHERE R1.AccountNumber = '1100011138946375'
AND R1.MTI IN ('9200')

DROP TABLE IF EXISTS #Authdata
SELECT T1.*, CA.TransactionLifeCycleUniqueID, CA.MessageTypeIdentifier, ProcCode
INTO #Authdata
FROM #TempRetailAuth T1
JOIN CCGS_RPT_CoreAuth..CoreAuthTransactions CA WITH (NOLOCK) ON (T1.TranID = CA.TranID)

SELECT MessageTypeIdentifier, ProcCode, COUNT(1) FROM #Authdata GROUP BY MessageTypeIdentifier, ProcCode

SELECT * FROM #Authdata WHERE MessageTypeIdentifier = '0420'

SELECT TransactionAmount, AuthTranID,  *
FROM Ccard_Primary WITH (NOLOCK)
WHERE AccountNumber = '1100011138946375'
AND TransactionLifeCycleUniqueID = 3261619263

SELECT MessageTypeIdentifier, AuthStatus,* 
FROM CCGS_RPT_CoreAuth..CoreAuthTransactions CA WITH (NOLOCK) WHERE TranID IN (
3261619317
,3261642630
,3261382578)


SELECT MessageTypeIdentifier, CoreAuthTranID,*
FROM Auth_Primary WITH (NOLOCK)
WHERE TranID IN (
80239784864
,80268049560
,80272257016)

SELECT *
FROM #Authdata A
LEFT JOIN CCard_Primary CP WITH (NOLOCK) ON (A.AccountNumber = CP.AccountNumber AND A.TransactionLifeCycleUniqueID = CP.TransactionLifeCycleUniqueID)
WHERE CP.CMTTRANTYPE = '40'
AND A.MessageTypeIdentifier = '0220'
--AND CP.TransactionLifeCycleUniqueID IS NULL


SELECT TransactionAmount, *
FROM CCard_Primary WITH (NOLOCK)
WHERE AccountNumber = '1100011138946375'
AND CMTTRANTYPE = '41'
--AND TransactionAmount > 1999

SELECT TxnSource, SUM(TransactionAmount)
FROM CCard_Primary WITH (NOLOCK)
WHERE AccountNumber = '1100011138946375'
AND CMTTRANTYPE = '41'
AND ArtXnType = '91'
GROUP BY TxnSource


SELECT *
FROM CurrentbalanceAudit WITH(NOLOCK)
WHERE AID = 435576
AND DENAME = 111
AND TRY_CAST(Newvalue AS MONEY) = 5183.44
ORDER BY BusinessDay DESC


SELECT SUM(TransactionAmount)
FROM CCard_Primary WITH (NOLOCK)
WHERE AccountNumber = '1100011138946375'
AND CMTTRANTYPE = ''
AND TranID NOT IN (98292823619)



DROP TABLE IF exists #AllPmts
SELECT AccountNumber, TranID, PostTime, TxnSource, CMTTRANTYPE, TransactionAmount PmtAmount, TRY_CAST(OldValue AS MONEY) BeforePmt, TRY_CAST(Newvalue AS MONEY) AfterPmt
INTO #AllPmts
FROM CCard_Primary CP WITH (NOLOCK)
JOIN CurrentbalanceAudit CBA WITH(NOLOCK) ON (CP.BSAcctID = CBA.AID AND CBA.DENAME = 111 AND CP.TranID = CBA.TID)
WHERE AccountNumber = '1100011138946375'
--AND CMTTRANTYPE = '21'

SELECT *
FROM #AllPmts

SELECT TOP 10 Accountnumber, TranID, PostTime, TransactionAmount, CurrentBalance, CurrentBalance_After, * 
FROM CCGS_RPT_CoreAuth..CoreAuthTransactions CA WITH (NOLOCK) 
WHERE AccountNumber = '1100011138946375'

DROP TABLE IF exists #Auth
SELECT *
INTO #Auth
FROM OPENQuery(LISTPRODPLAT, 'SELECT * FROM ##Auth WHERE TranType IS NOT NULL')

--SELECT * FROM #Auth1 WHERE TxnSource IN ('29', '39') AND RetailUUID IS NULL

DELETE FROM #Auth WHERE TxnSource IN ('29', '39') AND RetailUUID IS NULL

SELECT Accountnumber, TranID, MessageTypeIdentifier, ProcCode, AuthStatus, TxnSource, PostTime, TransactionAmount, CurrentBalance, CurrentBalance_After 
FROM #Auth

SELECT COALESCE(A.TranID, P.TranID) TranID, ROW_NUMBER() OVER(PARTITION BY COALESCE(A.PostTime, P.PostTime) ORDER BY COALESCE(A.TranID, P.TranID)) RN,
A.TranID AuthTranID, P.TranID PmtTranID, A.PostTime AuthTime, P.PostTime PmtTime
FROM #Auth A
JOIN #AllPmts P ON (A.AccountNumber = P.AccountNumber)

DROP TABLE IF EXISTS #TempTxns
;WITH CTE
AS
(
SELECT TranID, PostTime, 'Auth' Flag FROM #Auth
UNION ALL
SELECT TranID, PostTime, 'CCard' Flag FROM #AllPmts
), AllData
AS
(
SELECT *, ROW_NUMBER() OVER(PARTITION BY PostTime, TranID ORDER BY TranID) RN
FROM CTE
)
SELECT TranID, PostTime, Flag, ROW_NUMBER() OVER(PARTITION BY NULL ORDER BY PostTime, TranID) RN, 0 Status INTO #TempTxns FROM AllData WHERE RN = 1

SELECT *
FROM #TempTxns

DROP TABLE IF EXISTS #TempRecords
SELECT DISTINCT A.Accountnumber, A.TranID AuthTranID, P.TranID PmtTranID, A.PostTime AuthTime, P.PostTime PmtTime,
MessageTypeIdentifier, ProcCode, AuthStatus, A.TxnSource, TransactionAmount, CurrentBalance, CurrentBalance_After, BeforePmt, AfterPmt, TRY_CAST(0 AS INT) RN
INTO #TempRecords
FROM #Auth A
JOIN #AllPmts P ON (A.AccountNumber = P.AccountNumber)
JOIN #TempTxns T ON (T.TranID = CASE WHEN Flag = 'Auth' THEN A.TranID ELSE P.TranID END)
WHERE 1 =2 

DROP TABLE IF EXISTS ##TempTxns
SELECT *
INTO ##TempTxns
FROM #TempTxns

SET NOCOUNT ON
DECLARE @TempTranID DECIMAL(19, 0) = 0, @Flag VARCHAR(10) = '', @RN INT = 0
SELECT TOP(1) @TempTranID = TranID, @Flag = Flag, @RN = RN FROM ##TempTxns WHERE Status = 0 ORDER BY RN
WHILE(ISNULL(@TempTranID, 0) > 0)
BEGIN
	IF(@Flag = 'Auth')
	BEGIN
		INSERT INTO #TempRecords
		SELECT A.Accountnumber, A.TranID AuthTranID, 0 PmtTranID, A.PostTime AuthTime, NULL PmtTime,
		MessageTypeIdentifier, ProcCode, AuthStatus, TxnSource, TransactionAmount, CurrentBalance, CurrentBalance_After,
		 NULL BeforePmt, NULL AfterPmt, @RN 
		FROM #Auth A
		WHERE TranID = @TempTranID
	END
	ELSE
	BEGIN
		INSERT INTO #TempRecords
		SELECT P.Accountnumber, 0 AuthTranID, P.TranID PmtTranID, NULL AuthTime, P.PostTime PmtTime,
		NULL MessageTypeIdentifier, NULL ProcCode, NULL AuthStatus, NULL TxnSource, P.PmtAmount TransactionAmount
		, NULL CurrentBalance, NULL CurrentBalance_After, BeforePmt, AfterPmt, @RN
		FROM #AllPmts P
		WHERE TranID = @TempTranID
	END

	IF @@rowcount >= 1
	BEGIN
		UPDATE ##TempTxns SET Status = 1 WHERE TranID = @TempTranID
	END
	ELSE
	BEGIN
		UPDATE ##TempTxns SET Status = -1 WHERE TranID = @TempTranID
	END

	SET @TempTranID = 0
	SET @Flag = ''
	SELECT TOP(1) @TempTranID = TranID, @Flag = Flag, @RN = RN FROM ##TempTxns WHERE Status = 0 ORDER BY RN


END

SELECT * FROM #TempRecords ORDER BY RN

--DROP TABLE IF EXISTS #Txns
DROP TABLE IF EXISTS #TxnDetails
;WITH Pmts
AS
(
SELECT *, 0 Paired FROM #TempRecords WHERE PmtTranID > 0
), Auths
AS
(
SELECT T.*, 1 Paired 
FROM #TempRecords T
CROSS JOIN Pmts P
WHERE T.AuthTranID > 0 AND T.RN = P.RN+1
)
SELECT A.AccountNumber, A.AuthTranID, A.AuthTime, A.AuthStatus, P.PmtTranID, P.PmtTime, 
A.TransactionAmount AuthAmount, P.TransactionAmount PmtAmount,
P.BeforePmt, P.AfterPmt, A.CurrentBalance CurrentBalance_Before, A.CurrentBalance_After
INTO #TxnDetails
FROM Pmts P
JOIN Auths A ON (P.RN = A.RN-1)
WHERE A.Paired = 1


--SELECT * INTO #Txns FROM Pmts
--UNION ALL
--SELECT * FROM Auths

SELECT *, AfterPmt - CurrentBalance_Before DELTA
FROM #TxnDetails
--WHERE AfterPmt <> CurrentBalance_Before
--AND ABS(AfterPmt - CurrentBalance_Before) BETWEEN 37 AND 100
--WHERE ABS(AfterPmt - CurrentBalance_Before) = 0

SELECT *, AfterPmt - CurrentBalance_Before DELTA
FROM #TxnDetails
WHERE AuthTranID = 3856640650

SELECT CurrentBalance,CurrentBalance_After, TxnSource, TransactionAmount, ProcCode, * FROM #Auth WHERE TranID = 3856640650

SELECT * FROM #AllPmts WHERE TranID = 91124523993

SELECT CurrentBalance,CurrentBalance_After, TxnSource, TransactionAmount, ProcCode, * 
FROM #Auth
--WHERE TransactionAmount = 37.07 
ORDER By PostTime DESC, TranID

--WHERE TranID = 129655132

SELECT RetailUUID, CurrentBalance,CurrentBalance_After, TxnSource, TransactionAmount, ProcCode, MessageTypeIdentifier,* 
FROM #Auth1 
WHERE TxnSource IN ('29', '39') 
AND RetailParentUUID = '5e9066ed-9ed7-47af-a743-c544abe653f2'
ORDER BY PostTime DESC


SELECT *
FROM #Txns
ORDER BY RN


DROP TABLE IF exists #Auth
SELECT *
INTO #Auth
FROM CCGS_RPT_CoreAuth..CoreAuthTransactions CA WITH (NOLOCK) 
WHERE AccountNumber = '1100011138946375'
AND TranID > 0


