DROP TABLE IF EXISTS #TempPlans
SELECT CPS.parent02AID, CPS.parent01AID CreditPlanMaster, RTRIM(CpmDescription) CpmDescription, CPM.EqualPayments, CPS.acctId PlanID, 
RTRIM(AccountNumber) AccountNumber, BP.UniversalUniqueID AccountUUID, PlanUUID RMATranUUID, 
CPS.CurrentBalance+CPC.CurrentBalanceCO CurrentBalance, OriginalPurchaseAmount, 
CPS.DisputesAmtNS, BS.DisputesAmtNS DisputesAmtNS_Account, CPS.AmountOfReturnsLTD, CPS.PlanSegCreateDate LoanStartDate, BP.LastStatementDate,
TRY_CAST('NA' AS VARCHAR(10)) PaidOff, TRY_CAST('NA' AS VARCHAR(10)) Returned, TRY_CAST('NA' AS VARCHAR(10)) Active, TRY_CAST(NULL AS DATETIME) PaidOffDate
, TRY_CAST(NULL AS DATETIME) OriginalLoanEndDate, TRY_CAST(NULL AS DATETIME) MaturityDate, TRY_CAST(NULL AS INT) OriginalLoanTerm
INTO #TempPlans
FROM CPSgmentAccounts CPS WITH (NOLOCK)
JOIN CPSgmentCreditCard CPC WITH (NOLOCK) ON (CPS.acctID = CPC.acctID)
LEFT JOIN CPMAccounts CPM WITH (NOLOCK) ON (CPS.parent01AID = CPM.acctID)
JOIN BSegment_Primary BP WITH (NOLOCK) ON (BP.acctId = CPS.parent02AID)
JOIN BSegment_Secondary BS WITH (NOLOCK) ON (BS.acctID = BP.acctID)
WHERE CPS.CreditPlanType = '16'
AND CPS.parent02AID IN (12964025,1678239,4584522, 4949540)


--SELECT * FROM #TempPlans WHERE PlanID = 17952267

--SELECT * FROM #TempPlans WHERE parent02AID = 4949540

;WITH CTE
AS
(
SELECT PlanID
FROM #TempPlans
WHERE CurrentBalance > 0 OR (CurrentBalance <= 0 AND DisputesAmtNS > 0)
)
UPDATE P
SET Active = 'YES'
FROM #TempPlans P
JOIN CTE C ON (P.PlanID = C.PlanID)


;WITH CTE
AS
(
SELECT PlanID
FROM #TempPlans
WHERE CurrentBalance <= 0
AND OriginalpurchaseAmount = AmountOfReturnsLTD
AND DisputesAmtNS = 0
)
UPDATE P
SET Returned = 'YES'
FROM #TempPlans P
JOIN CTE C ON (P.PlanID = C.PlanID)



;WITH CTE
AS
(
SELECT PlanID
FROM #TempPlans
WHERE CurrentBalance <= 0
AND OriginalpurchaseAmount <> AmountOfReturnsLTD
AND DisputesAmtNS = 0
)
UPDATE P
SET PaidOff = 'YES'
FROM #TempPlans P
JOIN CTE C ON (P.PlanID = C.PlanID)





--SELECT PaidOff, Returned, Active, COUNT(1)
--FROM #TempPlans
--GROUP BY PaidOff, Returned, Active


;WITH ILP
AS
(
SELECT ILPS.PlanID, ILPS.PaidOffDate, RANK() OVER (PARTITION BY ILPS.PlanID ORDER BY ActivityOrder DESC) [Rank]
FROM ILPScheduleDetailSummary ILPS WITH (NOLOCK)
JOIN #TempPlans T ON (ILPS.PlanID = T.PlanID)
WHERE PaidOff = 'YES' OR Returned = 'YES'
)
UPDATE T
SET PaidOffDate = ILP.PaidOffDate
FROM #TempPlans T
JOIN ILP ON (T.PlanID = ILP.PlanID)
WHERE ILP.[Rank] = 1



;WITH ILP
AS
(
SELECT ILPS.PlanID, ILPS.OriginalLoanEndDate, ILPS.MaturityDate, ILPS.LoanTerm, 
RANK() OVER (PARTITION BY ILPS.PlanID ORDER BY ActivityOrder) [Rank]
FROM ILPScheduleDetailSummary ILPS WITH (NOLOCK)
JOIN #TempPlans T ON (ILPS.PlanID = T.PlanID)
--WHERE PaidOff = 'YES' OR Returned = 'YES'
)
UPDATE T
SET OriginalLoanEndDate = ILP.OriginalLoanEndDate, MaturityDate = ILP.MaturityDate, OriginalLoanTerm = ILP.LoanTerm
FROM #TempPlans T
JOIN ILP ON (T.PlanID = ILP.PlanID)
WHERE ILP.[Rank] = 1


SELECT * 
FROM #TempPlans
WHERE DisputesAmtNS < 0
ORDER BY Parent02AID

DROP TABLE IF EXISTS #TempData
;WITH CTE
AS
(
SELECT *, TRY_CAST(TRY_CAST(EOMONTH(PaidOffDate) AS VARCHAR) + ' 23:59:57' AS DATETIME) PaidOffDate_EOM
FROM #TempPlans
--ORDER BY Parent02AID
)
SELECT *, DATEDIFF(MONTH, PaidOffDate_EOM, LastStatementDate) MonthCount
INTO #TempData
FROM CTE
ORDER BY Parent02AID


SELECT Parent02AID, AccountUUID, COUNT(1) [Count]
FROM #TempData
WHERE MonthCount > 3
GROUP BY Parent02AID, AccountUUID



SELECT TOP 5 * FROM periodtable WITH (NOLOCK) WHERE period_name = 'STMT.31' AND period_time > '2022-11-22'


SELECT * 
FROM #TempPlans
WHERE PaidOff = 'YES'
AND Returned = 'NA'
AND Active = 'NA'

SELECT TOP 1 * FROM LS_P1MARPRODDB01.ccgs_CoreIssue.dbo.ILPScheduleDetailsBAD ILP WITH (NOLOCK) 

;WITH CTE
AS
(
SELECT *
FROM #TempData
WHERE MonthCount >= 3
)
SELECT *
FROM LS_P1MARPRODDB01.ccgs_CoreIssue.dbo.ILPScheduleDetailsBAD ILP WITH (NOLOCK) 
JOIN CTE C ON (C.PlanID = ILP.acctId)