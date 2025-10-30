DROP TABLE IF EXISTS #Plans
SELECT --COUNT(1)
CP.acctID, CP.parent02AID, CurrentBalance, CurrentBalanceCO, PlanUUID, PaidOutDate
INTO #Plans
FROM CPSgmentAccounts CP WITH (NOLOCK)
JOIN CPSgmentCreditCard CPC WITH (NOLOCK) ON CP.acctID = CPC.acctID
WHERE CreditPlanType = '16'
AND CurrentBalance+CurrentBalanceCO <= 0 AND DisputesAmtNS <= 0
AND PaidOutDate IS NULL
AND parent02AID > 0
--8276596


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


INSERT INTO PaidOutDate_Populator (acctID, parent02AID, CurrentBalance, PaidOutDate)
SELECT acctID, parent02AID, CurrentBalance+CurrentBalanceCO, BusinessDay FROM #PlanPaidOffDetails

INSERT INTO PaidOutDate_Populator (acctID, parent02AID, CurrentBalance, PaidOutDate)
SELECT acctID, parent02AID, CurrentBalance+CurrentBalanceCO, PaidOffDate FROM #PlanPaidOffDetails_NotInCBA

--SELECT TOP 10 * FROM PaidOutDate_Populator


--SELECT COUNT(1) FROM PaidOutDate_Populator