--MidCycleChargeOff-390 STARTS
DROP TABLE IF EXISTS #COAccounts
;WITH CTE
AS
(
SELECT AccountNumber, PostTime, TranID,
ROW_NUMBER() OVER(PARTITION BY AccountNumber ORDER BY PostTime) COCount
FROM LS_P1MARPRODDB01.CCGS_CoreIssue.DBO.CCARD_Primary C1 WITH (NOLOCK) 
WHERE CMTTranType = '51'
)
SELECT C2.AccountNumber, C2.PostTime, C2.TranID, 
DATEADD(SECOND, 86397,TRY_CAST(EOMONTH(C2.PostTime) AS DATETIME)) CycleDate,
DATEADD(SECOND, 86397,TRY_CAST(TRY_CAST(C2.PostTime AS DATE) AS DATETIME)) BusinessDay
INTO #COAccounts
FROM LS_P1MARPRODDB01.CCGS_CoreIssue.DBO.CCARD_Primary C1 WITH (NOLOCK)
RIGHT JOIN CTE C2 ON (C1.AccountNumber = C2.AccountNumber AND C1.CMTTranType = 'RCLS') 
WHERE C1.AccountNumber IS NULL
AND COCount = 1
--381223
--392358

--SELECT T.*, COALESCE(A.CycleDueDTD, B.CycleDueDTD) CycleDueDTD, COALESCE(A.daysDelinquent,B.daysDelinquent) daysDelinquent
DROP TABLE IF EXISTS #COAccountsMidCycle
SELECT T.*, A.BSAcctID acctID, A.CycleDueDTD, A.daysDelinquent, A.SystemStatus, A.ccinhparent125AID, A.ChargeOffDAte--, ChargeOffDateParam
,CASE	WHEN A.ccinhparent125AID IN (5202, 16010) THEN 2 
		WHEN A.ccinhparent125AID IN (2) THEN 0
		ELSE 1 
END CycleToCO
INTO #COAccountsMidCycle
FROM #COAccounts T
JOIN AccountInfoForreport A WITH (NOLOCK) ON (T.AccountNumber = A.AccountNumber AND T.BusinessDay = A.BusinessDay)
--LEFT JOIN AccountInfoForReport_SwitchOut B WITH (NOLOCK) ON (T.AccountNumber = B.AccountNumber AND T.BusinessDay = B.BusinessDay)
WHERE DATEADD(SS, 2, PostTime) < CycleDate --AND DATEADD(SS, 4, PostTime) < CycleDate
ORDER BY BusinessDay DESC

INSERT INTO #COAccountsMidCycle
SELECT T.*, A.BSAcctID acctID, A.CycleDueDTD, A.daysDelinquent, A.SystemStatus, A.ccinhparent125AID, A.ChargeOffDAte
,CASE WHEN A.ccinhparent125AID IN (5202, 16010) THEN 2 
WHEN A.ccinhparent125AID IN (5211,16022,16030,16334) THEN 1
		ELSE 0 END CycleToCO
FROM #COAccounts T
JOIN AccountInfoForReport_SwitchOut a WITH (NOLOCK) ON (T.AccountNumber = A.AccountNumber AND T.BusinessDay = A.BusinessDay)
WHERE DATEADD(SS, 2, PostTime) < CycleDate --AND DATEADD(SS, 4, PostTime) < CycleDate
ORDER BY BusinessDay DESC


SELECT * FROM #COAccountsMidCycle WHERE acctId = 68640



DROP TABLE IF EXISTS #CBA
SELECT T.*, OldValue, NewValue, DATEADD(SECOND, 86397,TRY_CAST(EOMONTH(CBA.BusinessDay) AS DATETIME)) StatusAddedOn,
--ROW_NUMBER() OVER(PARTITION BY AID, DATEADD(SECOND, 86397,TRY_CAST(EOMONTH(CBA.BusinessDay) AS DATETIME)) ORDER BY IdentityField DESC) StatusCount
ROW_NUMBER() OVER(PARTITION BY AID ORDER BY IdentityField DESC) StatusCount
INTO #CBA
FROM #COAccountsMidCycle T
JOIN CurrentBalanceAudit CBA WITH (NOLOCK) ON (T.acctID = CBA.AID AND CBA.DENAME = 114)
--AND TRY_CAST(CBA.NewValue AS INT) IN (5202, 5211, 16010, 16022)
WHERE CBA.BusinessDay < PostTime

SELECT * FROM #CBA ORDER BY acctid, CycleDate

DROP TABLE IF EXISTS #MissingCOAccounts
;WITH CTE
AS
(
SELECT M.*, C.NewValue, C.BusinessDay BusinessDay_CBA, C.StatusAddedOn,
--DATEADD(MONTH, M.CycleToCO-1, C.CycleDate) ExpectedCODate
DATEADD(SECOND, 86397,TRY_CAST(EOMONTH(DATEADD(MONTH, M.CycleToCO-1, C.StatusAddedOn)) AS DATETIME)) ExpectedCODate
FROM #CBA C
RIGHT JOIN #COAccountsMidCycle M ON (C.acctID = M.acctID AND M.CycleDate = C.CycleDate AND C.StatusCount = 1)
--ORDER BY acctid, StatementDate
)
SELECT C.*, BCC.ChargeOffDate ChargeOffDateAccount
--INTO #MissingCOAccounts
FROM CTE C 
JOIN BSegmentCreditCard BCC WITH (NOLOCK)  ON (C.acctID = BCC.acctID)
WHERE ExpectedCODate IS NOT NULL
--AND BCC.acctID = 68640
--AND ccinhparent125AID = 2
--AND ExpectedCODate < BCC.ChargeOffDate

--MidCycleChargeOff-390 ENDS


--180+DPD-InterestCharged-256 STARTS

DROP TABLE IF EXISTS #IntCharged
;WITH CTE
AS
(
SELECT acctId, StatementDate, DaysDelinquent
FROM StatementHeaderEX WITH (NOLOCK)
WHERE DaysDelinquent > 180
)
SELECT SH.AccountNumber, SH.StatementDate, SH.acctID, C.DAysDelinquent, SH.ccinhparent125AID, SH.SystemStatus, CycleDueDTD, AmtOfInterestCTD 
INTO #IntCharged
FROM StatementHeader SH WITH (NOLOCK)
JOIN CTE C ON (SH.acctID = C.acctID AND SH.StatementDate = C.StatementDate)
WHERE AmtOfInterestCTD > 0
AND CycleDueDTD > 7
AND systemstatus <> 14
and ccinhparent125AID NOT In (16304,16384,16392, 15996, 16000)
--order by sh.statementdate desc

SELECT * FROM #IntCharged

SELECT T.*, OldValue, NewValue, DATEADD(SECOND, 86397,TRY_CAST(EOMONTH(CBA.BusinessDay) AS DATETIME)) StatusAddedOn,
CASE WHEN ccinhparent125AID IN (5211,16022,16030,16334) THEN 1 ELSE 2 END  CycleToCO,
--ROW_NUMBER() OVER(PARTITION BY AID, DATEADD(SECOND, 86397,TRY_CAST(EOMONTH(CBA.BusinessDay) AS DATETIME)) ORDER BY IdentityField DESC) StatusCount
ROW_NUMBER() OVER(PARTITION BY AID ORDER BY IdentityField DESC) StatusCount
FROM #IntCharged T
JOIN CurrentBalanceAudit CBA WITH (NOLOCK) ON (T.acctID = CBA.AID AND CBA.DENAME = 114)
WHERE ccinhparent125AID IN (5211,16022,16030,16334,5202,16010)
AND T.acctID = 1702485

DROP TABLE IF EXISTS #ManualStatus_IntCharged
;WITH CTE
AS
(
SELECT T.*, OldValue, NewValue, DATEADD(SECOND, 86397,TRY_CAST(EOMONTH(CBA.BusinessDay) AS DATETIME)) StatusAddedOn,
CASE WHEN ccinhparent125AID IN (5211,16022,16030,16334) THEN 1 ELSE 2 END  CycleToCO,
--ROW_NUMBER() OVER(PARTITION BY AID, DATEADD(SECOND, 86397,TRY_CAST(EOMONTH(CBA.BusinessDay) AS DATETIME)) ORDER BY IdentityField DESC) StatusCount
ROW_NUMBER() OVER(PARTITION BY AID ORDER BY IdentityField DESC) StatusCount
FROM #IntCharged T
JOIN CurrentBalanceAudit CBA WITH (NOLOCK) ON (T.acctID = CBA.AID AND CBA.DENAME = 114)
WHERE ccinhparent125AID IN (5211,16022,16030,16334,5202,16010)
)
SELECT M.*, C.NewValue, C.StatusAddedOn,
--DATEADD(MONTH, M.CycleToCO-1, C.CycleDate) ExpectedCODate
DATEADD(SECOND, 86397,TRY_CAST(EOMONTH(DATEADD(MONTH, C.CycleToCO-1, C.StatusAddedOn)) AS DATETIME)) ExpectedCODate
INTO #ManualStatus_IntCharged
FROM CTE C
RIGHT JOIN #IntCharged M ON (C.acctID = M.acctID AND C.StatusCount = 1)
WHERE M.ccinhparent125AID IN (5211,16022,16030,16334,5202,16010)
--AND M.acctID = 1702485



DROP TABLE IF EXISTS #Delnq_IntCharged
;WITH CTE
AS
(
SELECT T.*, OldValue, NewValue,DATEADD(SECOND, 86397,TRY_CAST(EOMONTH(CBA.BusinessDay) AS DATETIME)) DelnqReached,
--ROW_NUMBER() OVER(PARTITION BY AID, DATEADD(SECOND, 86397,TRY_CAST(EOMONTH(CBA.BusinessDay) AS DATETIME)) ORDER BY IdentityField DESC) StatusCount
ROW_NUMBER() OVER(PARTITION BY AID ORDER BY IdentityField) StatusCount
FROM #IntCharged T
JOIN CurrentBalanceAudit CBA WITH (NOLOCK) ON (T.acctID = CBA.AID AND CBA.DENAME = 115)
WHERE ccinhparent125AID NOT IN (5211,16022,16030,16334,5202,16010)
AND TRY_CAST(NewValue AS INT) >= 8
)
SELECT M.*, C.NewValue, C.DelnqReached ExpectedCODate
INTO #Delnq_IntCharged
FROM CTE C
RIGHT JOIN #IntCharged M ON (C.acctID = M.acctID AND C.StatusCount = 1)
WHERE M.ccinhparent125AID NOT IN (5211,16022,16030,16334,5202,16010)
--AND M.acctID = 1702485

DROP TABLE IF EXISTS #180DPDIntCharged
SELECT acctId, AccountNumber, ccinhparent125AID, SystemStatus, DaysDelinquent, CycleDueDTD, AmtOfInterestCTD, ExpectedCODate INTO #180DPDIntCharged FROM #Delnq_IntCharged
INSERT INTO #180DPDIntCharged
SELECT acctId, AccountNumber, ccinhparent125AID, SystemStatus, DaysDelinquent, CycleDueDTD, AmtOfInterestCTD, ExpectedCODate FROM #ManualStatus_IntCharged

SELECT T.*, ChargeOffDate 
FROM #180DPDIntCharged T
JOIN BSegmentCreditCard BC WITH (NOLOCK) ON (T.acctid = BC.acctID)

--180+DPD-InterestCharged-256 ENDS


--180+DPD-NotCO-108


DROP TABLE IF EXISTS  #MissingCO
SELECT SH.AccountNumber, SH.StatementDate, SH.acctID, SH.CycleDueDTD, C.DAysDelinquent, SH.ccinhparent125AID, SH.SystemStatus, AmtOfInterestCTD, ChargeOffDate,
CASE WHEN ccinhparent125AID IN (5202, 16010) THEN 2 ELSE 1 END CycleToCO
INTO #MissingCO
FROM StatementHeader SH WITH (NOLOCK)
JOIN StatementHeaderEx C WITH (NOLOCK)  ON (SH.acctID = C.acctID AND SH.StatementDate = C.StatementDate)
WHERE SH.SystemStatus <> 14
AND SH.CycleDueDTD > 7
AND SH.ccinhparent125AID NOT In (16304,16384,16392, 15996, 16000, 16326)
--AND (ChargeOffDate IS NULL OR ChargeOffDate < SH.StatementDate)
--order by sh.statementdate desc



DROP TABLE IF EXISTS #ManualStatus_NoCO
;WITH CTE
AS
(
SELECT T.*, OldValue, NewValue, DATEADD(SECOND, 86397,TRY_CAST(EOMONTH(CBA.BusinessDay) AS DATETIME)) StatusAddedOn,
--CASE WHEN ccinhparent125AID IN (5211,16022,16030,16334) THEN 1 ELSE 2 END  CycleToCO,
--ROW_NUMBER() OVER(PARTITION BY AID, DATEADD(SECOND, 86397,TRY_CAST(EOMONTH(CBA.BusinessDay) AS DATETIME)) ORDER BY IdentityField DESC) StatusCount
ROW_NUMBER() OVER(PARTITION BY AID ORDER BY IdentityField DESC) StatusCount
FROM #MissingCO T
JOIN CurrentBalanceAudit CBA WITH (NOLOCK) ON (T.acctID = CBA.AID AND CBA.DENAME = 114)
WHERE ccinhparent125AID IN (5211,16022,16030,16334,5202,16010)
)
SELECT M.*, C.NewValue, C.StatusAddedOn,
--DATEADD(MONTH, M.CycleToCO-1, C.CycleDate) ExpectedCODate
DATEADD(SECOND, 86397,TRY_CAST(EOMONTH(DATEADD(MONTH, C.CycleToCO-1, C.StatusAddedOn)) AS DATETIME)) ExpectedCODate
INTO #ManualStatus_NoCO
FROM CTE C
RIGHT JOIN #MissingCO M ON (C.acctID = M.acctID AND C.StatusCount = 1)
WHERE M.ccinhparent125AID IN (5211,16022,16030,16334,5202,16010)
--AND M.acctID = 1702485


DROP TABLE IF EXISTS #Delnq_NoCharged
;WITH CTE
AS
(
SELECT T.*, OldValue, NewValue,DATEADD(SECOND, 86397,TRY_CAST(EOMONTH(CBA.BusinessDay) AS DATETIME)) DelnqReached,
--ROW_NUMBER() OVER(PARTITION BY AID, DATEADD(SECOND, 86397,TRY_CAST(EOMONTH(CBA.BusinessDay) AS DATETIME)) ORDER BY IdentityField DESC) StatusCount
ROW_NUMBER() OVER(PARTITION BY AID ORDER BY IdentityField) StatusCount
FROM #MissingCO T
JOIN CurrentBalanceAudit CBA WITH (NOLOCK) ON (T.acctID = CBA.AID AND CBA.DENAME = 115)
WHERE ccinhparent125AID NOT IN (5211,16022,16030,16334,5202,16010)
AND TRY_CAST(NewValue AS INT) >= 8
)
SELECT M.*, C.NewValue, C.DelnqReached ExpectedCODate
INTO #Delnq_NoCharged
FROM CTE C
RIGHT JOIN #MissingCO M ON (C.acctID = M.acctID AND C.StatusCount = 1)
WHERE M.ccinhparent125AID NOT IN (5211,16022,16030,16334,5202,16010)
--AND M.acctID = 1702485

DROP TABLE IF EXISTS #180DPDNoCharged
SELECT acctId, AccountNumber, ccinhparent125AID, SystemStatus, DaysDelinquent, CycleDueDTD, AmtOfInterestCTD, ExpectedCODAte INTO #180DPDNoCharged FROM #Delnq_IntCharged
INSERT INTO #180DPDNoCharged
SELECT acctId, AccountNumber, ccinhparent125AID, SystemStatus, DaysDelinquent, CycleDueDTD, AmtOfInterestCTD, ExpectedCODAte  FROM #ManualStatus_IntCharged

SELECT * FROM #180DPDNoCharged

SELECT T.*, ChargeOffDate 
FROM #180DPDNoCharged T
JOIN BSegmentCreditCard BC WITH (NOLOCK) ON (T.acctid = BC.acctID)


--SELECT C.*, BCC.ChargeOffDate ChargeOffDateAccount
----INTO #MissingCOAccounts
--FROM #180DPDNoCharged C 
--JOIN BSegmentCreditCard BCC WITH (NOLOCK)  ON (C.acctID = BCC.acctID)
--WHERE ExpectedCODate IS NOT NULL
----AND BCC.acctID = 4495723
--AND C.DaysDelinquent > 180
--AND ExpectedCODate < BCC.ChargeOffDate


