SET NOCOUNT ON;


---------------------------- STEP:1 ----------------------------------

DROP TABLE IF EXISTS #TempRevTxns
SELECT AccountNumber, TranID, RevTgt, CMTTRANTYPE, TranTime, PostTime, ArTxnType
INTO #TempRevTxns
FROM CCard_Primary WITH (NOLOCK)
WHERE RevTgt IS NOT NULL


---------------------------- STEP:2 ----------------------------------


DROP TABLE IF EXISTS #Ar93txns
SELECT *
INTO #Ar93txns
FROM #TempRevTxns
WHERE ArTxnType = '93'

---------------------------- STEP:3 ----------------------------------

DELETE FROM #TempRevTxns WHERE ArTxnType = '93'

---------------------------- STEP:4 ----------------------------------


DROP TABLE IF EXISTS #TempOriginalTxns
SELECT C.AccountNumber, C.TranID, T.RevTgt, C.CMTTRANTYPE, C.TranTime, C.PostTime, C.ArTxnType, T.PostTime ReversalTime
INTO #TempOriginalTxns
FROM CCard_Primary C WITH (NOLOCK)
JOIN #TempRevTxns T ON (C.TranID = T.RevTgt AND C.AccountNumber = T.AccountNumber)
--WHERE DATEDIFF(MONTH, C.TranTime, T.PostTime) > 1


---------------------------- STEP:5 ----------------------------------



--SELECT * FROM #TempOriginalTxns WHERE AccountNumber = '1100001000005699'

DROP TABLE IF EXISTS #AcrossCycleReversedTxns
SELECT *, 'AcrossCycleTxnRIP' Category
INTO #AcrossCycleReversedTxns
FROM #TempOriginalTxns
WHERE DATEDIFF(MONTH, PostTime, ReversalTime) >= 1


---------------------------- STEP:6 ----------------------------------


DROP TABLE IF EXISTS #TempBackdatedTxns
SELECT C.AccountNumber, C.TranID, C.CMTTRANTYPE, C.TranTime, C.PostTime, ArTxnType
INTO #TempBackdatedTxns
FROM CCard_Primary C WITH (NOLOCK)
WHERE DATEDIFF(MONTH, C.TranTime, C.PostTime) >= 1


---------------------------- STEP:7 ----------------------------------



DROP TABLE IF EXISTS #TempActualBackdatedTxns
SELECT *, 'AcrossCycleTxns' Category
INTO #TempActualBackdatedTxns
FROM #TempBackdatedTxns
WHERE ArTxnType IN ('96', '91', '99', '961')


---------------------------- STEP:8 ----------------------------------


DROP TABLE IF EXISTS #TempStatusTxns
SELECT C.AccountNumber, C.TranID, C.CMTTRANTYPE, C.TranTime, C.PostTime, ArTxnType, C.FeesAcctID, C.CPMGroup, 'EligibleStatus' Category
INTO #TempStatusTxns
FROM CCard_Primary C WITH (NOLOCK)
WHERE CMTTRANTYPE IN ('*SCR', 'ECD', 'ADDBK')


---------------------------- STEP:9 ----------------------------------



DELETE FROM #TempStatusTxns WHERE CPMGroup NOT IN (16038, 16392, 5202, 16010)


---------------------------- STEP:10 ----------------------------------


DROP TABLE IF EXISTS #ImpactedAccounts
;WITH CTE
AS
(
SELECT AccountNumber
FROM #AcrossCycleReversedTxns
UNION 
SELECT AccountNumber
FROM #TempActualBackdatedTxns
UNION 
SELECT AccountNumber
FROM #TempStatusTxns
--WHERE CPMGroup IN (16038, 16392, 5202, 16010)
)
SELECT DISTINCT AccountNumber, TRY_CAST(NULL AS VARCHAR(100)) Category
INTO #ImpactedAccounts
FROM CTE
--735944

---------------------------- STEP:11 ----------------------------------

UPDATE T
	SET Category = CASE WHEN ISNULL(T.Category, '') = '' THEN ISNULL(T1.Category, '') ELSE ISNULL(T.Category, '') + ' | ' + ISNULL(T1.Category, '') END
FROM #ImpactedAccounts T
JOIN #AcrossCycleReversedTxns T1 ON (T.AccountNumber = T1.AccountNumber) 
--538949

UPDATE T
	SET Category = CASE WHEN ISNULL(T.Category, '') = '' THEN ISNULL(T1.Category, '') ELSE ISNULL(T.Category, '') + ' | ' + ISNULL(T1.Category, '') END
FROM #ImpactedAccounts T
JOIN #TempActualBackdatedTxns T1 ON (T.AccountNumber = T1.AccountNumber)
--144959

UPDATE T
	SET Category = CASE WHEN ISNULL(T.Category, '') = '' THEN ISNULL(T1.Category, '') ELSE ISNULL(T.Category, '') + ' | ' + ISNULL(T1.Category, '') END
FROM #ImpactedAccounts T
JOIN #TempStatusTxns T1 ON (T.AccountNumber = T1.AccountNumber)
--152742

---------------------------- STEP:12 ----------------------------------




INSERT INTO TSDBOHBConversion (acctID, AccountNumber, CreatedTime, CurrentBalance, AmtOfAcctHighBalLTD, LastStatementDate, Category)
SELECT 
	BP.acctID, BP.AccountNumber, BP.CreatedTime, BP.CurrentBalance+BC.CurrentBalanceCO, BP.AmtOfAcctHighBalLTD, BP.LastStatementDate, T.Category
FROM BSegment_Primary BP WITH (NOLOCK)
JOIN BSegmentCreditCard BC WITH (NOLOCK) ON (BP.acctID = BC.acctID)
JOIN #ImpactedAccounts T ON (BP.AccountNumber = T.AccountNumber)
WHERE BP.MergeInProcessPH IS NULL






/*

--EXECUTE ON PRIMARY

INSERT INTO ##TSDBOHBConversion (acctID, AccountNumber, CreatedTime, CurrentBalance, AmtOfAcctHighBalLTD, LastStatementDate)
SELECT acctID, AccountNumber, CreatedTime, CurrentBalance, AmtOfAcctHighBalLTD, LastStatementDate
FROM OPENQuery(LISTRPTPLAT, 'SELECT * FROM ##TSDBOHBConversion')


SELECT HBRecalcRequired, *
FROM BSegment_Balances BC WITH (NOLOCK)
JOIN TSDBOHBConversion T ON (BC.acctID = T.acctID)



*/