DROP TABLE IF EXISTS #TempPlans
SELECT CPS.parent02AID, AccountNumber, BP.UniversalUniqueID AccountUUID, COUNT(1) TotalRetailPlanCount, 0 CreatedPlans, 0 ActivePlans, 0 PaidOffPlans, 0 RefundedPlans, 0 CancelledPlans
INTO #TempPlans
FROM CPSgmentAccounts CPS WITH (NOLOCK)
JOIN BSegment_Primary BP WITH (NOLOCK) ON (BP.acctId = CPS.parent02AID)
WHERE CPS.CreditPlanType = '16'
GROUP BY CPS.parent02AID, BP.UniversalUniqueID,AccountNumber
HAVING COUNT(1) >= 50


--SELECT * FROM #tempPlans

/*
SELECT CPS.parent02AID, AccountUUID, CPS.acctId, CPC.PlanUUID RMATranUUID, CPS.CurrentBalance + CPC.CurrentBalanceCO CurrentBalance
FROM CPSgmentAccounts CPS WITH (NOLOCK)
JOIN CPSgmentCreditCard CPC WITH (NOLOCK) ON (CPS.acctId = CPC.acctId)
JOIN #tempPlans T1 ON (CPs.parent02AID = T1.parent02AID)
WHERE ((CPS.CurrentBalance + CPC.CurrentBalanceCO > 0) OR (CPS.CurrentBalance + CPC.CurrentBalanceCO <= 0 AND DisputesAmtNS > 0))
AND CPS.CreditPlanType = '16'
ORDER BY CPS.parent02AID


SELECT CPS.parent02AID, AccountUUID, CPS.acctId, CPC.PlanUUID RMATranUUID, CPS.CurrentBalance + CPC.CurrentBalanceCO CurrentBalance
FROM CPSgmentAccounts CPS WITH (NOLOCK)
JOIN CPSgmentCreditCard CPC WITH (NOLOCK) ON (CPS.acctId = CPC.acctId)
JOIN #tempPlans T1 ON (CPs.parent02AID = T1.parent02AID)
WHERE ((CPS.CurrentBalance + CPC.CurrentBalanceCO > 0) OR (CPS.CurrentBalance + CPC.CurrentBalanceCO <= 0 AND DisputesAmtNS > 0))
AND CPS.CreditPlanType = '16'
AND T1.parent02AID = 942600
*/


--Active Plans

;with CTE
AS
(
SELECT CPS.parent02AID, COUNT(1) PlanCount
FROM CPSgmentAccounts CPS WITH (NOLOCK)
JOIN CPSgmentCreditCard CPC WITH (NOLOCK) ON (CPS.acctId = CPC.acctId)
JOIN #tempPlans T1 ON (CPs.parent02AID = T1.parent02AID)
WHERE ((CPS.CurrentBalance + CPC.CurrentBalanceCO > 0) OR (CPS.CurrentBalance + CPC.CurrentBalanceCO <= 0 AND DisputesAmtNS > 0))
AND CPS.CreditPlanType = '16'
--ORDER BY CPS.parent02AID
GROUP BY CPS.parent02AID
)
UPDATE T1
SET T1.ActivePlans = C.PlanCount
FROM #TempPlans T1
JOIN CTE C ON (T1.parent02AID = C.Parent02AID)



--Refunded Plans
;with CTE
AS
(
SELECT CPS.parent02AID, COUNT(1) PlanCount
FROM CPSgmentAccounts CPS WITH (NOLOCK)
JOIN CPSgmentCreditCard CPC WITH (NOLOCK) ON (CPS.acctId = CPC.acctId)
JOIN #tempPlans T1 ON (CPs.parent02AID = T1.parent02AID)
WHERE CPS.CurrentBalance + CPC.CurrentBalanceCO <= 0
AND OriginalpurchaseAmount = AmountOfReturnsLTD
AND DisputesAmtNS = 0
AND CPS.CreditPlanType = '16'
--ORDER BY CPS.parent02AID
GROUP BY CPS.parent02AID
)
UPDATE T1
SET T1.RefundedPlans = C.PlanCount
FROM #TempPlans T1
JOIN CTE C ON (T1.parent02AID = C.Parent02AID)


--PaidOff Plans
;with CTE
AS
(
SELECT CPS.parent02AID, COUNT(1) PlanCount
FROM CPSgmentAccounts CPS WITH (NOLOCK)
JOIN CPSgmentCreditCard CPC WITH (NOLOCK) ON (CPS.acctId = CPC.acctId)
JOIN #tempPlans T1 ON (CPs.parent02AID = T1.parent02AID)
WHERE CPS.CurrentBalance + CPC.CurrentBalanceCO <= 0
AND OriginalpurchaseAmount <> AmountOfReturnsLTD
AND DisputesAmtNS = 0
AND CPS.CreditPlanType = '16'
--ORDER BY CPS.parent02AID
GROUP BY CPS.parent02AID
)
UPDATE T1
SET T1.PaidOffPlans = C.PlanCount
FROM #TempPlans T1
JOIN CTE C ON (T1.parent02AID = C.Parent02AID)




--SELECt *, ActivePlans+PaidOffPlans+RefundedPlans [Count] 
--FROM #TempPlans
--WHERE ActivePlans+PaidOffPlans+RefundedPlans <> TotalRetailPlanCount

--SELECT * FROM #TempPlans --WHERE Parent02AID = 942600



DROP TABLE IF EXISTS #TempFinal
;WITH CTE
AS
(
SELECT
B.AccountNumber, A.uuid RMATranUUID, A.MTI, A.Amount, 
CASE WHEN A.MTI = '9420' THEN ISNULL(OTBReleaseAmount, 0) ELSE 0 END OTBReleaseAmount,
CASE WHEN A.MTI = '9420' THEN (ISNULL(OTBReleaseAmount, 0) + A.Amount) * -1 ELSE A.Amount END TransactionAmount
FROM PROD1GSDB02.CoreAuth_Snapshot_Snap_221001.dbo.RetailAPILineItems A WITH (NOLOCK)
JOIN PROD1GSDB02.CoreAuth_Snapshot_Snap_221001.dbo.RetailAPILog B WITH (NOLOCK) ON (A.request_id = B.request_id)
JOIN PROD1GSDB02.CoreAuth_Snapshot_Snap_221001.dbo.CPMAccounts C WITH (NOLOCK) ON (A.Plan_ID = C.acctId AND C.CreditPlanType = '16')
JOIN #TempPlans T1 with(nolock) on (B.accountnumber=T1.accountnumber)
WHERE A.MTI IN ('9100', '9420')
AND APIErrorFound = 0
)
, PlanDetails
AS
(
SELECT RMATranUUID, SUM(TransactionAmount) TransactionAmount
FROM CTE 
GROUP BY RMATranUUID
)
, FinalDetails
AS
(
SELECT
B.AccountNumber, A.uuid RMATranUUID, A.MTI, A.Amount, P.TransactionAmount, 1 CreatedPlans,
CASE WHEN P.TransactionAmount <= 0 THEN 1 ELSE 0 END CancelledPlans
FROM PROD1GSDB02.CoreAuth_Snapshot_Snap_221001.dbo.RetailAPILineItems A WITH (NOLOCK)
JOIN PROD1GSDB02.CoreAuth_Snapshot_Snap_221001.dbo.RetailAPILog B WITH (NOLOCK) ON (A.request_id = B.request_id)
JOIN PlanDetails P ON (A.uuid = P.RmaTranUUID)
JOIN #TempPlans T1 with(nolock) on (B.accountnumber=T1.accountnumber)
WHERE /*P.TransactionAmount <=0
AND*/ A.MTI = '9100'
)
SELECT AccountNumber, SUM(CreatedPlans) CreatedPlans, SUM(CancelledPlans) CancelledPlans
INTO #TempFinal
FROM FinalDetails
GROUP BY AccountNumber

--SELECT SUM(CreatedPlans) FROm #TempFinal


UPDATE T1
SET 
	CreatedPlans = T2.CreatedPlans,
	CancelledPlans = T2.CancelledPlans
FROM #TempPlans T1
JOIN #TempFinal T2 ON (T1.AccountNumber = T2.AccountNumber)

SELECT * FROM #TempPlans