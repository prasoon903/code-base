DROP TABLE IF EXISTS #TempPlans
SELECT CPS.parent02AID, CPS.parent01AID CreditPlanMaster, RTRIM(CpmDescription) CpmDescription, CPM.EqualPayments, CPS.acctId PlanID, 
RTRIM(AccountNumber) AccountNumber, BP.UniversalUniqueID AccountUUID, PlanUUID RMATranUUID, 
CPS.CurrentBalance+CPC.CurrentBalanceCO CurrentBalance, OriginalPurchaseAmount, 
CPS.DisputesAmtNS, BS.DisputesAmtNS DisputesAmtNS_Account, CPS.AmountOfReturnsLTD, CPS.PlanSegCreateDate LoanStartDate, BP.LastStatementDate,
TRY_CAST('NA' AS VARCHAR(10)) PaidOff, TRY_CAST('NA' AS VARCHAR(10)) Returned, TRY_CAST('NA' AS VARCHAR(10)) Active, TRY_CAST('NA' AS VARCHAR(10)) Closed, TRY_CAST(NULL AS DATETIME) PaidOffDate
, TRY_CAST(NULL AS DATETIME) OriginalLoanEndDate, TRY_CAST(NULL AS DATETIME) MaturityDate, TRY_CAST(NULL AS INT) OriginalLoanTerm
INTO #TempPlans
FROM CPSgmentAccounts CPS WITH (NOLOCK)
JOIN CPSgmentCreditCard CPC WITH (NOLOCK) ON (CPS.acctID = CPC.acctID)
LEFT JOIN CPMAccounts CPM WITH (NOLOCK) ON (CPS.parent01AID = CPM.acctID)
JOIN BSegment_Primary BP WITH (NOLOCK) ON (BP.acctId = CPS.parent02AID)
JOIN BSegment_Secondary BS WITH (NOLOCK) ON (BS.acctID = BP.acctID)
WHERE CPS.CreditPlanType = '16'
--AND CPS.parent02AID IN (12964025,1678239,4584522, 4949540)


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
SET Returned = 'YES', Closed = 'YES'
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
SET PaidOff = 'YES', Closed = 'YES'
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
WHERE PaidOff = 'YES' OR Returned = 'YES'
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
WHERE PaidOffDate IS NOT NULL
--ORDER BY Parent02AID
)
SELECT *, DATEDIFF(MONTH, PaidOffDate_EOM, LastStatementDate) MonthCount
INTO #TempData
FROM CTE
ORDER BY Parent02AID

SELECT * FROM #TempData WHERE Parent02AID = 14370354


DROP TABLE IF EXISTS #PaidOffmoreThan3Months
SELECT * INTO #PaidOffmoreThan3Months FROM #TempData WHERE MonthCount > 3

SELECT * FROM #PaidOffmoreThan3Months WHERE Parent02AID = 14370354

;WITH CTE
AS
(
SELECT Parent02AID, AccountUUID, COUNT(1) [TotalCount]
FROM #TempData
GROUP BY Parent02AID, AccountUUID
HAVING COUNT(1) > 50
),
PaidOff3Months
AS
(
SELECT P.Parent02AID, COUNT(1) [PaidOff3MonthsCount]
FROM CTE C
JOIN #PaidOffmoreThan3Months P ON (C.Parent02AID = P.Parent02AID)
GROUP BY P.Parent02AID
)
SELECT C.*, ISNULL(P.[PaidOff3MonthsCount], 0) [PaidOff3MonthsCount]
FROM CTE C 
LEFT JOIN PaidOff3Months P ON C.Parent02AID = P.Parent02AID
WHERE [PaidOff3MonthsCount] > 0



SELECT Parent02AID, AccountUUID, COUNT(1) [Count]
FROM #TempData
WHERE MonthCount > 3
GROUP BY Parent02AID, AccountUUID



SELECT TOP 5 * FROM periodtable WITH (NOLOCK) WHERE period_name = 'STMT.31' AND period_time > '2022-11-22'


SELECT TOP 5 * 
FROM #TempPlans
WHERE PaidOff = 'NA'
AND Returned = 'YES'
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

--PaidOff	Returned	Active	TotalCount
--NA	NA	YES	3603996
--NA	YES	NA	828753
--YES	NA	NA	7290477

*/

;WITH CTE
AS
(
SELECT Parent02AID, COUNT(1) [TotalCount]
FROM #TempPlans
GROUP BY Parent02AID
--ORDER BY COUNT(1) DESC
),
PlanCategory AS
(
SELECT *,
CASE 
	WHEN [TotalCount] BETWEEN 1 AND 10 THEN '1-10'
	WHEN [TotalCount] BETWEEN 11 AND 20 THEN '11-20'
	WHEN [TotalCount] BETWEEN 21 AND 50 THEN '21-50'
	WHEN [TotalCount] BETWEEN 51 AND 100 THEN '51-100'
	WHEN [TotalCount] BETWEEN 101 AND 200 THEN '101-200'
	WHEN [TotalCount] >= 201 THEN '200+'
ELSE 'NA' END AS PlanCountCategory
FROM CTE
)
SELECT PlanCountCategory, COUNT(1) [TotalCount]
FROM PlanCategory
GROUP BY PlanCountCategory
ORDER BY COUNT(1) DESC

;WITH CTE
AS
(
SELECT Parent02AID, COUNT(1) [ClosedCount]
FROM #TempPlans
--WHERE PaidOff = 'YES' OR Returned = 'YES'
WHERE Closed = 'YES'
GROUP BY Parent02AID
--ORDER BY COUNT(1) DESC
),
PlanCategory AS
(
SELECT *,
CASE 
	WHEN [ClosedCount] BETWEEN 1 AND 10 THEN '1-10'
	WHEN [ClosedCount] BETWEEN 11 AND 20 THEN '11-20'
	WHEN [ClosedCount] BETWEEN 21 AND 50 THEN '21-50'
	WHEN [ClosedCount] BETWEEN 51 AND 100 THEN '51-100'
	WHEN [ClosedCount] BETWEEN 101 AND 200 THEN '101-200'
	WHEN [ClosedCount] >= 201 THEN '200+'
ELSE 'NA' END AS PlanCountCategory
FROM CTE
)
SELECT PlanCountCategory, COUNT(1) [TotalClosedCount]
FROM PlanCategory
GROUP BY PlanCountCategory
ORDER BY COUNT(1) DESC


;WITH CTE
AS
(
SELECT Parent02AID, COUNT(1) [ActiveCount]
FROM #TempPlans
WHERE Active = 'YES'
GROUP BY Parent02AID
--ORDER BY COUNT(1) DESC
),
PlanCategory AS
(
SELECT *,
CASE 
	WHEN [ActiveCount] BETWEEN 1 AND 10 THEN '1-10'
	WHEN [ActiveCount] BETWEEN 11 AND 20 THEN '11-20'
	WHEN [ActiveCount] BETWEEN 21 AND 50 THEN '21-50'
	WHEN [ActiveCount] BETWEEN 51 AND 100 THEN '51-100'
	WHEN [ActiveCount] BETWEEN 101 AND 200 THEN '101-200'
	WHEN [ActiveCount] >= 201 THEN '200+'
ELSE 'NA' END AS PlanCountCategory
FROM CTE
)
SELECT PlanCountCategory, COUNT(1) [TotalActiveCount]
FROM PlanCategory
GROUP BY PlanCountCategory
ORDER BY COUNT(1) DESC



SELECT Parent02AID, COUNT(1) [ClosedCount]
FROM #TempPlans
WHERE PaidOff = 'YES' OR Returned = 'YES'
GROUP BY Parent02AID
ORDER BY COUNT(1) DESC

SELECT Parent02AID, COUNT(1) [ActiveCount]
FROM #TempPlans
WHERE Active = 'YES'
GROUP BY Parent02AID
ORDER BY COUNT(1) DESC

SELECT Active, Closed, COUNT(1) [TotalCount] 
FROM #TempPlans
GROUP BY Active, Closed

SELECT COUNT(1) [TotalCount] FROM #TempPlans 

SELECT parent02AID, AccountNumber, AccountUUID, RMATranUUID, Active, Closed, CurrentBalance, DisputesAmtNS 
FROM #TempPlans
ORDER BY parent02AID



SELECT Parent02AID, COUNT(1) [ActiveCount]
FROM #TempPlans
--WHERE Active = 'YES'
GROUP BY Parent02AID, Active, Closed


SELECT Parent02AID, COUNT(1) [TotalCount]
FROM #TempPlans
GROUP BY Parent02AID
HAVING COUNT(1) >=200
ORDER BY COUNT(1)


SELECT Parent02AID, COUNT(1) [TotalCount]
FROM #TempPlans
WHERE Active = 'YES'
GROUP BY Parent02AID
HAVING COUNT(1) >=200

SELECT Parent02AID, COUNT(1) [TotalCount]
FROM #TempPlans
WHERE Closed = 'YES'
GROUP BY Parent02AID
HAVING COUNT(1) >=200
ORDER BY COUNT(1)