
DROP TABLE IF EXISTS #TempActivePlans
SELECT CP.acctID, CP.parent02AID, OriginalPurchaseAmount, CurrentBalance, CurrentBalanceCO, PaidOutDate
INTO #TempActivePlans
FROM CPSgmentAccounts CP WITH (NOLOCK)
JOIN CPSgmentCreditcard CPC WITH (NOLOCK) ON (CP.acctID = CPC.acctID)
WHERE CurrentBalance+CurrentBalanceCO > 0
AND CP.CreditPlanType = '16'

DROP TABLE IF EXISTS #TempSchedules
;WITH CTE
AS
(
SELECT T.*, ILP.ScheduleID, ILP.PaidOffDate, ROW_NUMBER() OVER(PARTITION BY ILP.parent02AID, ILP.PlanID ORDER BY ActivityOrder DESC) ScheduleCount
FROM #TempActivePlans T
JOIN ILPScheduleDetailSummary ILP WITH (NOLOCK) ON (T.acctID = ILP.PlanID AND T.parent02AID = ILP.parent02AID)
)
SELECT *
INTO #TempSchedules 
FROM CTE 
WHERE ScheduleCount = 1 
--ORDER BY acctID

SELECT COUNT(1) FROM #TempSchedules WHERE PaidOffDate IS NOT NULL
--8958

SELECT *
FROM #TempSchedules
WHERE PaidOffDate IS NOT NULL
--ORDER BY parent02AID
AND CurrentBalance > 0
ORDER BY PaidOffDate DESC
