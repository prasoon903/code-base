--SELECT TOP 5 * FROM AccountInfoForReport WITH (NOLOCK) WHERE BusinessDay = '2024-11-19 23:59:57' AND systemStatus = 14

--SELECT Principal, CurrentBalance, CurrentBalanceCo,* FROM PLanInfoForReport WITH (NOLOCK) WHERE BusinessDay = '2024-11-19 23:59:57' AND BSAcctID IN (
--120657
--, 5054
--, 5075
--, 5095
--, 120694)

DROP TABLE IF EXISTS #AllImpactedPlans
;WITH Account
AS
(
SELECT BSAcctID FROM AccountInfoForReport WITH (NOLOCK) WHERE BusinessDay = '2024-11-19 23:59:57' AND systemStatus = 14
)
, Plans
AS
(
SELECT P.BSAcctID, CPSAcctID, Principal, CurrentBalance+CurrentBalanceCo CurrentBalance, CreditPlanType, LAD 
FROM PlanInfoForReport P WITH (NOLOCK) 
JOIN Account A ON (A.BSAcctID = P.BSAcctID AND P.BusinessDay = '2024-11-19 23:59:57')
--WHERE BusinessDay = '2024-11-19 23:59:57'
)
SELECT *, 0 JobStatus
INTO #AllImpactedPlans
--CreditPlanType, COUNT(1)
FROM Plans 
--WHERE LAD < '2024-11-19 23:59:57'
--AND CreditPlanType = '0'
--GROUP BY CreditPlanType

UPDATE #AllImpactedPlans SET JobStatus = -2 WHERE LAD > '2024-11-18 23:59:57'



SELECT COUNT(1)
FROM #AllImpactedPlans
WHERE CreditPlanType = '0'
AND ISNULL(CurrentBalance, 0) > 0 --577515
AND ISNULL(Principal, 0) <= 0 --576969

UPDATE #AllImpactedPlans SET Principal = CurrentBalance, JobStatus = 1 WHERE CreditPlanType = '16' AND JobStatus = 0
UPDATE #AllImpactedPlans SET JobStatus = -1 WHERE CreditPlanType = '10' AND JobStatus = 0

DROP TABLE IF EXISTS #RevPlans
SELECT *
INTO #RevPlans
FROM #AllImpactedPlans
WHERE CreditPlanType = '0'
--AND ISNULL(CurrentBalance, 0) > 0 --577515
--AND ISNULL(Principal, 0) <= 0 --576969
AND JobStatus = 0

;WITH CTE
AS
(
SELECT R.*, S.CurrentBalance+SC.CurrentBalanceCO CB_SH, S.Principal+SC.PrincipalCO Principal_SH
FROM #RevPlans R
JOIN CPSgmentAccounts S WITH (NOLOCK) ON (R.CPSAcctID = S.acctID)
JOIN CPSgmentCreditCard SC WITH (NOLOCK) ON (S.acctID = SC.acctID)
WHERE R.CurrentBalance = S.CurrentBalance+SC.CurrentBalanceCO
AND R.JobStatus = 0
AND S.LAD < '2024-11-18 23:59:57'
)
UPDATE T
SET Principal = Principal_SH, JobStatus = 1
FROM #AllImpactedPlans T
JOIN CTE C ON (T.CPSAcctID = C.CPSACCTid)

SELECT JobStatus, COUNT(1) FROm #AllImpactedPlans GROUP BY JobStatus

--;WITH CTE
--AS
--(
--SELECT R.*, S.CurrentBalance+SC.CurrentBalanceCO CB_SH, S.Principal+SC.PrincipalCO Principal_SH
--FROM #RevPlans R
--JOIN SummaryHeader S WITH (NOLOCK) ON (R.CPSAcctID = S.acctID AND S.StatementDate = '2024-10-31 23:59:57')
--JOIN SummaryHeaderCreditCard SC WITH (NOLOCK) ON (S.acctID = SC.acctID AND S.StatementId = SC.StatementID)
--WHERE R.CurrentBalance = S.CurrentBalance+SC.CurrentBalanceCO
--AND R.JobStatus = 0
--AND S.StatementDate = '2024-10-31 23:59:57'
--)
--UPDATE T1
--SET Principal = Principal_SH, JobStatus = 1
--FROM #AllImpactedPlans T1
--JOIN CTE C ON (C.CPSAcctID = T1.CPSAcctid)



UPDATE T1
SET JobStatus = T2.JobStatus
FROM #RevPlans T1
JOIN #AllImpactedPlans T2 ON (T1.CPSAcctID = T2.CPSAcctID)




;WITH CBA
AS
(
SELECT R.*, C.BusinessDay, TRY_CAST(C.newvalue AS MONEY) PrincipalCBA, ROW_NUMBER() OVER(PARTITION BY C.AID ORDER BY BusinessDay DESC) RN
FROM CurrentBalanceAuditPS C WITH (NOLOCK)
JOIN #RevPlans R ON (C.AID = R.CPSAcctID AND C.DENAME IN (240))
AND R.JobStatus = 0
AND C.BusinessDay < '2024-11-19 23:59:57'
),
CTE
AS
(
SELECT *
FROM CBA 
WHERE RN = 1
)
UPDATE T1
SET Principal = C.PrincipalCBA, JobStatus = 1
FROM #AllImpactedPlans T1
JOIN CTE C ON (T1.CPSAcctID = C.CPSAcctID)

SELECT * FROM #RevPlans WHERE JobStatus = 0


SELECT * FROM CurrentBalanceAuditPS WITH (NOLOCK) WHERE AID = 4664144 ORDER BY BusinessDay DESC

DROP TABLE IF EXISTS #Accounts
SELECT BSAcctID, Principal, CurrentBalance+CurrentBalanceCo CurrentBalance INTO #Accounts FROM AccountInfoForReport WITH (NOLOCK) WHERE BusinessDay = '2024-11-19 23:59:57' AND systemStatus = 14

;WITH CTE
AS
(
SELECT BSAcctID, SUM(ISNULL(Principal, 0)) Principal FROM #AllImpactedPlans GROUP BY BSAcctID
)
SELECT *
FROM CTE C
JOIN #Accounts A ON (C.BSAcctID = A.BSAcctID)
WHERE C.Principal <> A.Principal

SELECT * FROM #AllImpactedPlans WHERE BSAcctID = 4675690
SELECT * FROM #Accounts WHERE BSAcctID = 4675690