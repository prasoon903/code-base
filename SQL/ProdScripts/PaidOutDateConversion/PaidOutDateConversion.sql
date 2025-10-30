DROP TABLE IF EXISTS #Plans
SELECT --COUNT(1)
CP.acctID, CP.parent02AID, CurrentBalance, CurrentBalanceCO, PlanUUID, LoanEndDate, PaidOutDate
INTO #Plans
FROM CPSgmentAccounts CP WITH (NOLOCK)
JOIN CPSgmentCreditCard CPC WITH (NOLOCK) ON CP.acctID = CPC.acctID
WHERE CreditPlanType = '16'
AND CurrentBalance+CurrentBalanceCO <= 0 AND DisputesAmtNS <= 0
AND PaidOutDate IS NULL
AND parent02AID > 0
--8306232


DROP TABLE IF EXISTS #PlanPaidOffDetails
;WITH CTE
AS
(
SELECT P.*, CBA.BusinessDay, CBA.TID, ROW_NUMBER() OVER(PARTITION BY CBA.AID ORDER BY CBA.BusinessDay DESC, CBA.IdentityField DESC) [RowCount]
FROM CurrentBalanceAuditPS CBA WITH (NOLOCK)
JOIN #Plans P ON CBA.AID = P.acctId AND CBA.ATID = 52 AND CBA.DENAME IN (111, 222) AND TRY_CAST(CBA.NewValue AS MONEY) = 0.00
)
SELECT *
INTO #PlanPaidOffDetails 
FROM CTE
WHERE [RowCount] = 1


SELECT TOP 10 * FROM #PlanPaidOffDetails

SELECT *
FROM #PlanPaidOffDetails P2
RIGHT JOIN #Plans P1 ON P1.acctId = P2.acctID
WHERE P2.acctID IS NULL

SELECT * FROM CurrentBalanceAuditPS WITH (NOLOCK)
WHERE AID = 72002786 --AND ATID = 52 --AND DENAME IN (111, 222)
ORDER BY IdentityField DESC

SELECT * 
FROM LS_P1MARPRODDB01.ccgs_coreissue.dbo.CurrentBalanceAuditPS WITH (NOLOCK)
WHERE AID = 72002786 --AND ATID = 52 --AND DENAME IN (111, 222)
ORDER BY IdentityField DESC

DROP TABLE IF EXISTS #PlanPaidOffDetails_NotInCBA
;WITH CTE
AS
(
SELECT P1.*
FROM #PlanPaidOffDetails P2
RIGHT JOIN #Plans P1 ON P1.acctId = P2.acctID
WHERE P2.acctID IS NULL
),
ILPDetails AS
(
SELECT C.*, ILPS.PaidOffDate, ILPS.TranID, ROW_NUMBER() OVER(PARTITION BY ILPS.PlanID ORDER BY ActivityOrder DESC) [RowCount]
FROM CTE C 
JOIN ILPScheduleDetailSummary ILPS WITH (NOLOCK) ON C.acctID = ILPS.PlanID
WHERE ILPS.PaidOffDate IS NOT NULL
)
SELECT *
INTO #PlanPaidOffDetails_NotInCBA
FROM ILPDetails
WHERE [RowCount] = 1





SELECT *
FROM #PlanPaidOffDetails_NotInCBA P2
RIGHT JOIN 
(SELECT P1.*
FROM #PlanPaidOffDetails P2
RIGHT JOIN #Plans P1 ON P1.acctId = P2.acctID
WHERE P2.acctID IS NULL) P1
ON P1.acctId = P2.acctID
WHERE P2.acctID IS NULL

DROP TABLE IF EXISTS #PaidOutDate_Phase1
CREATE TABLE #PaidOutDate_Phase1 
(
	SN DECIMAL(19,0) IDENTITY(1,1),
	acctID INT,
	parent02AID INT,
	CurrentBalance MONEY,
	PaidOutDate DATETIME,
	LoanEndDate Datetime,
	JobStatus INT DEFAULT(0)
)

INSERT INTO #PaidOutDate_Phase1 (acctID, parent02AID, CurrentBalance, PaidOutDate, LoanEndDate)
SELECT acctID, parent02AID, CurrentBalance+CurrentBalanceCO, BusinessDay, LoanEndDate FROM #PlanPaidOffDetails

INSERT INTO #PaidOutDate_Phase1 (acctID, parent02AID, CurrentBalance, PaidOutDate, LoanEndDate)
SELECT acctID, parent02AID, CurrentBalance+CurrentBalanceCO, PaidOffDate, LoanEndDate FROM #PlanPaidOffDetails_NotInCBA

SELECT TOP 10 * FROM #PaidOutDate_Phase1


SELECT COUNT(1) FROM #PaidOutDate_Phase1
SELECT COUNT(1) FROM #PaidOutDate_Phase1 WHERE PaidOutDate < LoanEndDate

SELECT 8033126.0/8306232.0*100