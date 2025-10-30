SELECT AccountNumber, TranID, RevTgt, CMTTRANTYPE, TranTime, PostTime, ArTxnType
INTO #TempRevTxns
FROM CCard_Primary WITH (NOLOCK)
WHERE RevTgt IS NOT NULL
--AND DATEDIFF(MONTH, TranTime, PostTime) > 1

SELECT ArTxnType, COUNT(1)
FROM #TempRevTxns
GROUP BY ArTxnType

DROP TABLE IF EXISTS #Ar93txns
SELECT *
INTO #Ar93txns
FROM #TempRevTxns
WHERE ArTxnType = '93'

DELETE FROM #TempRevTxns WHERE ArTxnType = '93'




DROP TABLE IF EXISTS #TempOriginalTxns
SELECT C.AccountNumber, C.TranID, T.RevTgt, C.CMTTRANTYPE, C.TranTime, C.PostTime, C.ArTxnType, T.PostTime ReversalTime
INTO #TempOriginalTxns
FROM CCard_Primary C WITH (NOLOCK)
JOIN #TempRevTxns T ON (C.TranID = T.RevTgt)
--WHERE DATEDIFF(MONTH, C.TranTime, T.PostTime) > 1

DROP TABLE IF EXISTS #AcrossCycleReversedTxns
SELECT *
INTO #AcrossCycleReversedTxns
FROM #TempOriginalTxns
WHERE DATEDIFF(MONTH, PostTime, ReversalTime) > 1

SELECT COUNT(DISTINCT AccountNumber)
FROM #AcrossCycleReversedTxns
--520892


--SELECT DATEDIFF(MONTH, '2025-05-10 12:55:56', GETDATE())

DROP TABLE IF EXISTS #TempBackdatedTxns
SELECT C.AccountNumber, C.TranID, C.CMTTRANTYPE, C.TranTime, C.PostTime, ArTxnType
INTO #TempBackdatedTxns
FROM CCard_Primary C WITH (NOLOCK)
WHERE DATEDIFF(MONTH, C.TranTime, C.PostTime) > 1




SELECT ArTxnType, COUNT(1)
FROM #TempBackdatedTxns
GROUP BY ArTxnType

SELECT CMTTRANTYPE, ArTxnType, COUNT(1)
FROM #TempBackdatedTxns
GROUP BY CMTTRANTYPE, ArTxnType


DROP TABLE IF EXISTS #TempActualBackdatedTxns
SELECT *
INTO #TempActualBackdatedTxns
FROM #TempBackdatedTxns
WHERE ArTxnType IN ('96', '91', '99', '961')

SELECT COUNT(DISTINCT AccountNumber)
FROM #TempActualBackdatedTxns
--142986

DROP TABLE IF EXISTS #TempStatusTxns
SELECT C.AccountNumber, C.TranID, C.CMTTRANTYPE, C.TranTime, C.PostTime, ArTxnType, C.FeesAcctID, C.CPMGroup 
INTO #TempStatusTxns
FROM CCard_Primary C WITH (NOLOCK)
WHERE CMTTRANTYPE = '*SCR'

SELECT *
FROM #TempStatusTxns
WHERE CPMGroup = ''

DROP TABLE IF EXISTS #ImpactedAccounts
;WITH CTE
AS
(
SELECT AccountNumber
FROM #AcrossCycleReversedTxns
UNION 
SELECT AccountNumber
FROM #TempActualBackdatedTxns
)
SELECT DISTINCT AccountNumber
INTO #ImpactedAccounts
FROM CTE
--598057

SELECT COUNT(1)
FROM #ImpactedAccounts

SELECT TOP 10 *
FROM #ImpactedAccounts

--1100011168878241   





SELECT AccountNumber
FROM BSegment_Balances BB WITH (NOLOCK)
JOIN BSegment_Primary BP WITH (NOLOCK) ON (BB.acctID = BP.acctID)
WHERE BB.CBRLastCalculatedDate IS NOT NULL



DROP TABLE IF EXISTS #CSHData
SELECT acctID, StatementDate, CurrentBalance, Principal, IntBilledNotPaid, AmtOfInterestCTD, RecoveryFeesBNP 
INTO #CSHData
FROM CurrentSummaryHeader SH WITH (NOLOCK)
WHERE StatementDate = '2025-05-31 23:59:57'
AND CurrentBalance <> Principal+IntBilledNotPaid+RecoveryFeesBNP
ORDer BY SH.StatementDate DESC

DROP TABLE IF EXISTS #SHData
SELECT CP.parent02AID, C.*, CSH.IsAcctSCRA
INTO #SHData
FROM #CSHData C
JOIN CPSgmentAccounts CP WITH (NOLOCK) ON (C.acctID = CP.acctid)
JOIN CurrentStatementHeader CSH WITH (NOLOCK) ON (CP.parent02AID = CSH.acctID AND C.StatementDate = CSH.StatementDate)

SELECT *, CurrentBalance-(Principal+IntBilledNotPaid+RecoveryFeesBNP) DELTA
FROM #SHData


SELECT SH.acctID, SH.parent02AID, SH.StatementDate, 
SH.CurrentBalance, SH.Principal, SH.IntBilledNotPaid, SH.AmtOfInterestCTD, SH.RecoveryFeesBNP,
CSH.CurrentBalance, CSH.Principal, CSH.IntBilledNotPaid, CSH.AmtOfInterestCTD, CSH.RecoveryFeesBNP
FROM SummaryHeader SH WITH (NOLOCK)
JOIN CurrentSummaryHeader CSH WITH (NOLOCK) ON (SH.acctID = CSH.acctId AND SH.StatementID = CSH.StatementID)
WHERE SH.parent02AID = 2635811
AND SH.StatementDate = '2025-05-31 23:59:57'
--2635811

SELECT SH.acctID, SH.StatementDate, sh.accountnumber,
SH.CurrentBalance, SH.Principal, SH.IntBilledNotPaid, SH.AmtOfInterestCTD, SH.RecoveryFeesBNP,
CSH.CurrentBalance
FROM StatementHeader SH WITH (NOLOCK)
JOIN CurrentStatementHeader CSH WITH (NOLOCK) ON (SH.acctID = CSH.acctId AND SH.StatementDate = CSH.StatementDate)
WHERE SH.acctID = 2635811
AND SH.StatementDate = '2025-05-31 23:59:57'

SELECT acctID, StatementDate, CurrentBalance, Principal, IntBilledNotPaid, AmtOfInterestCTD, RecoveryFeesBNP, *
FROM CurrentSummaryHeader SH WITH (NOLOCK)
WHERE StatementDate = '2025-05-31 23:59:57'
AND acctID = 2761731


SELECT TOP 10 acctID, StatementDate, CurrentBalance
FROM CurrentStatementHeader SH WITH (NOLOCK)
WHERE StatementDate = '2025-05-31 23:59:57'
AND IsAcctSCRA = 1

--584201


SELECT CMTTRANTYPE, TransactionAmount, *
FROM CCArd_Primary WITH (NOLOCK)
WHERE AccountNumber = '1100011126401490'
--AND TxnAcctID = 108783473
AND TranID = 130650254670
ORDER BY PostTime DESC