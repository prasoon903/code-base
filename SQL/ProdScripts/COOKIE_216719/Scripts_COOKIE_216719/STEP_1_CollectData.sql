
DROP TABLE IF EXISTS #TempData_CT_111770
;WITH BS
AS
(
SELECT AccountNumber,acctID BSAcctID, LastStatementDate
FROM BSegment_Primary BP WITH (NOLOCK)
WHERE acctID IN (12964025, 4584522, 1678239, 4949540)
)
, ILP
AS
( 
SELECT BS.*,parent02AID, PlanID, CurrentBalance, PaidOffDate, 
DATEADD(SS, 86397, CAST(EOMONTH(PaidOffDate) AS DATETIME)) PaidOffDate_EOM, ScheduleID,
RANK() OVER(PARTITION BY PlanID ORDER BY ActivityOrder DESC) [Rank]
FROM ILPScheduleDetailSummary ILPS WITH (NOLOCK)
JOIN BS ON (BS.BSAcctID = ILPS.parent02AID)
WHERE ILPS.CurrentBalance <= 0
)
, PaidOffPlans
AS
(
SELECT *, DATEDIFF(MM, PaidOffDate_EOM, LastStatementDate) MonthCount, 
TRY_CAST(0 AS INT) JobStatus
FROM ILP 
WHERE Rank = 1
)
SELECT * 
INTO #TempData_CT_111770
FROM PaidOffPlans
WHERE MonthCount >= 3


SELECT 'CPSgmentAccounts', COUNT(1)
FROM CPSgmentAccounts CPS WITH (NOLOCK)
JOIN #TempData_CT_111770 T1 ON (CPS.acctID = T1.PlanID)

SELECT 'ILPScheduleDetailSummary', COUNT(1)
FROM ILPScheduleDetailSummary ILP WITH (NOLOCK)
JOIN #TempData_CT_111770 T1 ON (ILP.PlanID = T1.PlanID)

SELECT 'ILPScheduleDetails', COUNT(1)
FROM ILPScheduleDetails ILP WITH (NOLOCK)
JOIN #TempData_CT_111770 T1 ON (ILP.acctId = T1.PlanID)

SELECT 'ILPScheduleDetailsRevised', COUNT(1)
FROM ILPScheduleDetailsRevised ILP WITH (NOLOCK)
JOIN #TempData_CT_111770 T1 ON (ILP.acctId = T1.PlanID)

SELECT 'XRefTable', COUNT(1)
FROM XRefTable X WITH (NOLOCK)
JOIN #TempData_CT_111770 T ON (X.ParentATID = 51 AND X.parentAID = T.parent02AID AND ChildATID = 52 AND X.ChildAID = T.PlanID)


--SELECT * FROM TempData_CT_111770
--SELECT * FROM TempXRef_CT_111770

--DROP TABLE IF EXISTS #TempXRef_CT_111770
--SELECT X.*
--INTO TempXRef_CT_111770
--FROM XRefTable X WITH (NOLOCK)
--JOIN TempData_CT_111770 T ON (X.ParentATID = 51 AND X.parentAID = T.parent02AID AND ChildATID = 52 AND X.ChildAID = T.PlanID)
