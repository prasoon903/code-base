SELECT ScheduleID, Activity, activityOrder AO, ActivityAmount,* 
FROM ILPScheduleDetailSummary WITH (NOLOCK) 
WHERE  PlanID = 10729627 
--AND ScheduleID = 1056725 
ORDER BY activityOrder

SELECT * FROM LS_P1MARPRODDB01.CCGS_CoreIssue.DBO.ILPScheduleDetailsBAD IB WITH (NOLOCK) WHERE acctID = 13814

SELECT * FROM CCardLookUp WITH (NOLOCK) WHERE LutId = 'EPPReasonCode' ORDER BY DisplayOrdr

SELECT CPMDescription,* FROM CPMAccounts WITH (NOLOCK) WHERE acctID = 13814

SELECT * FROM ILPScheduleDetails WITH (NOLOCK) WHERE ScheduleID = 2602176 AND acctID = 10729627

SELECT * FROM ILPScheduleDetailsRevised WITH (NOLOCK) WHERE ScheduleID = 24020963 AND acctID = 10729627

SELECT * FROM CPSgmentAccounts WITH (NOLOCK) WHERE acctID = 111402852

SELECT EqualPayments, CPMDescription,* FROM CPMAccounts WITH (NOLOCK) WHERE acctID = 14737

DROP TABLE IF EXISTS #OriginalSchedule
SELECT I.acctID, I.parent02AID, I.ScheduleID, ActivityOrder, Activity, I.LoanTerm, I.OriginalLoanTerm, I.OriginalLoanAmount, ILP.ActivityAmount, I.DateOfTotalDue, I.CurrentBalance, I.RemainingPrincipal, I.PrincipalBilledCTD 
INTO #OriginalSchedule
FROM ILPScheduleDetails I  WITH (NOLOCK) 
JOIN ILPScheduleDetailSummary ILP WITH (NOLOCK) ON (I.acctID = ILP.PlanID AND I.ScheduleID = ILP.ScheduleID)
WHERE acctID = 10729627

DROP TABLE IF EXISTS #RevisedSchedule
SELECT I.acctID, I.parent02AID, I.ScheduleID, ActivityOrder, Activity, I.LoanTerm, I.OriginalLoanTerm, I.OriginalLoanAmount, ILP.ActivityAmount, I.DateOfTotalDue, I.CurrentBalance, I.RemainingPrincipal, I.PrincipalBilledCTD 
INTO #RevisedSchedule
FROM ILPScheduleDetailsRevised I WITH (NOLOCK)
JOIN ILPScheduleDetailSummary ILP WITH (NOLOCK) ON (I.acctID = ILP.PlanID AND I.ScheduleID = ILP.ScheduleID) 
WHERE acctID = 10729627


--SELECT * FROM #OriginalSchedule

--SELECT * FROM #RevisedSchedule

DROP TABLE IF EXISTS #RevisedScheduleFiltered
;WITH CTE
AS
(
SELECT *, ROW_NUMBER() OVER(PARTITION BY acctID, DateOfTotalDue ORDER BY ActivityOrder DESC) RowCounter
FROM #RevisedSchedule
)
SELECT I.acctID, I.parent02AID, I.ScheduleID, ActivityOrder, Activity, I.LoanTerm, I.OriginalLoanTerm, I.OriginalLoanAmount, I.ActivityAmount, I.DateOfTotalDue, I.CurrentBalance, I.RemainingPrincipal, I.PrincipalBilledCTD 
INTO #RevisedScheduleFiltered 
FROM CTE I WHERE RowCounter = 1 ORDER BY DateOfTotalDue



SELECT I.acctID, I.parent02AID, I.ScheduleID, COALESCE(R.ActivityOrder, I.ActivityOrder) ActivityOrder, COALESCE(R.Activity, I.Activity) Activity, I.LoanTerm, I.OriginalLoanTerm, I.OriginalLoanAmount
, COALESCE(R.ActivityAmount, I.ActivityAmount) ActivityAmount, I.DateOfTotalDue, 
COALESCE(R.CurrentBalance, I.CurrentBalance) CurrentBalance, COALESCE(R.RemainingPrincipal, I.RemainingPrincipal) RemainingPrincipal, COALESCE(R.PrincipalBilledCTD, I.PrincipalBilledCTD) PrincipalBilledCTD 
FROM #OriginalSchedule I
LEFT JOIN #RevisedScheduleFiltered R ON (I.acctID = R.acctID AND I.DateOfTotalDue = R.DateOfTotalDue)
ORDER BY I.DateOfTotalDue

;WITH CTE
AS
(
SELECT I.acctID, I.parent02AID, I.ScheduleID, ISNULL(R.ActivityOrder, I.ActivityOrder) ActivityOrder, ISNULL(R.Activity, I.Activity) Activity, I.LoanTerm, I.OriginalLoanTerm, I.DateOfTotalDue, 
ISNULL(R.CurrentBalance, I.CurrentBalance) CurrentBalance, ISNULL(R.RemainingPrincipal, I.RemainingPrincipal) RemainingPrincipal, ISNULL(R.PrincipalBilledCTD, I.PrincipalBilledCTD) PrincipalBilledCTD 
FROM #OriginalSchedule I
LEFT JOIN #RevisedScheduleFiltered R ON (I.acctID = R.acctID AND I.DateOfTotalDue = R.DateOfTotalDue)
)
SELECT MAX(CurrentBalance) CurrentBalance, SUM(PrincipalBilledCTD) PrincipalBilledCTD FROM CTE