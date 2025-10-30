DROP TABLE IF EXISTS #TempDelinkedPlans
SELECT CP.acctID, parent02AID, OriginalPurchaseAmount, SingleSaleTranID
INTO #TempDelinkedPlans
FROM CPSgmentAccounts CP WITH (NOLOCK)
JOIN CPSgmentCreditCard CPC WITH (NOLOCK) ON (CP.acctID = CPC.acctID)
WHERE parent02AID < 0
AND CreditPlanType = '16'

;WITH CTE
AS
(
SELECT *
FROM #TempDelinkedPlans
--WHERE OriginalPurchaseAmount > 1
)
SELECT C.CMTTRANTYPE, COUNT(1)
FROM CCard_Primary C WITH (NOLOCK)
JOIN CTE CTE ON (C.TranID = CTE.SingleSaleTranID)
GROUP BY C.CMTTRANTYPE

SELECT COUNT(1) FROM #TempDelinkedPlans

SELECT COUNT(1) FROM #TempDelinkedPlans WHERE SingleSaleTranID IS NULL

SELECT parent02AID, COUNT(1) FROM #TempDelinkedPlans WHERE SingleSaleTranID IS NULL GROUP BY parent02AID

SELECT TOP 10 * FROM #TempDelinkedPlans WHERE SingleSaleTranID IS NULL

SELECT TOP 10 PlanSegCreateDate, CreditPlanType,* FROM CPSgmentAccounts WITH (NOLOCK) WHERE parent02AID = -1000 ORDER BY LAD DESC


SELECT COUNT(1) FROM #TempDelinkedPlans WHERE OriginalPurchaseAmount > 1

SELECT TOP 10 * FROM #TempDelinkedPlans WHERE OriginalPurchaseAmount <= 0

SELECT TOP 10 * FROM #TempDelinkedPlans WHERE OriginalPurchaseAmount BETWEEN 0.01 AND 1

SELECT COUNT(1) FROM #TempDelinkedPlans WHERE OriginalPurchaseAmount BETWEEN 0.01 AND 1

SELECT * FROM ILPScheduleDetailSummary WITH (NOLOCK) WHERE PlanID = 45447540

DROP TABLE IF EXISTS #TempDelinkedPlans_LastStmt
SELECT T.*, S.StatementDate, ROW_NUMBER() OVER(PARTITION BY T.acctID ORDER BY S.StatementDate DESC)
INTO #TempDelinkedPlans_LastStmt
FROM #TempDelinkedPlans T
JOIN SummaryHeader S WITH (NOLOCK) ON (T.acctID = S.acctID)


SELECT T.*, S.parent02AID, S.StatementDate
FROM #TempDelinkedPlans T
JOIN SummaryHeader S WITH (NOLOCK) ON (T.acctID = S.acctID)
WHERE --S.parent02AID < 0 AND 
T.acctID = 45447540
ORDER BY S.StatementDate DESC

SELECT S.StatementDate, COUNT(1)
FROM SummaryHeader S WITH (NOLOCK)
WHERE S.parent02AID = 21953418
GROUP BY S.StatementDate
ORDER BY S.StatementDate DESC

SELECT COUNT(1) FROM #TempDelinkedPlans WHERE parent02AID = -21953418
