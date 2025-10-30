DROP TABLE IF EXISTS ##tempPlans_Corrected
SELECT * INTO ##tempPlans_Corrected FROM #tempPlans_Corrected WHERE BSAcctId NOT IN (17528033)

DROP TABLE IF EXISTS ##tempAccounts_Corrected
SELECT BSacctId, BusinessDay, SUM(SRBToAdjust) SRBToAdjust
INTO ##tempAccounts_Corrected
FROM #tempPlans_Corrected
WHERE BSAcctId NOT IN (17528033)
GROUP BY BSacctId, BusinessDay 

SELECT * FROM #tempPlans_Corrected WHERE BSAcctId = 17528033

SELECT * FROM #tempPlans WHERE BSAcctId = 17528033
SELECT * FROM #TempAccount WHERE BSAcctId = 17528033

SELECT BSacctId, SUM(AdjustedRetailDue) AdjustedRetailDue, SUM(AdjustedRRDue) AdjustedRRDue
FROM #tempPlans_Corrected
GROUP BY BSacctId
HAVING SUM(AdjustedRetailDue) <> SUM(AdjustedRRDue)


;WITH CTE
AS
(
SELECT BSacctId, SUM(SRBToAdjust) SRBToAdjust
FROM #tempPlans_Corrected
GROUP BY BSacctId
)
SELECT *, SRB_Account-SRBToAdjust
FROM #TempAccount T1
JOIN CTE C ON (T1.BSAcctId = C.BSAcctId)
WHERE SRB_Account-SRBToAdjust <> AD_Account
AND T1.BSAcctId NOT IN (17528033)



SELECT * FROM ##Ankit

DROP TABLE IF EXISTS #TempAccount
SELECT BSAcctId, BusinessDay, AIR.AccountNumber, CurrentBalance CB_Account, SRBWithInstallmentDue SRB_Account, AmountOfTotalDue AD_Account, AmtOfPayCurrDue CD_Account
INTO #TempAccount
FROM AccountInfoForReport AIR WITH (NOLOCK)
JOIN ##Ankit T1 ON (AIR.AccountNumber = T1.AccountNumber AND AIR.BusinessDay = '2022-04-30 23:59:57')
--WHERE BusinessDay = '2022-04-30 23:59:57'

DROP TABLE IF EXISTS #AllPlans
SELECT acctId 
INTO #AllPlans
FROM CPSgmentAccounts CP WITH (NOLOCK)
JOIN #TempAccount T1 ON (T1.BSAcctId = CP.parent02AID)


DROP TABLE IF EXISTS #TempPlans
SELECT BSAcctID, BusinessDay, CPSAcctId, CurrentBalance, CreditPlanType, AmountOfTotalDue, AmtOfPayCurrDue, EqualPaymentAmt, CycleDueDTD, SRBWithInstallmentDue,
CAST(0 AS Money) AdjustedRRDue, CAST(0 AS Money) AdjustedRetailDue
INTO #TempPlans
FROM PlanInfoForReport PIR WITH (NOLOCK)
JOIN #AllPlans T1 ON (T1.acctId = PIR.CPSAcctId AND PIR.BusinessDay = '2022-04-30 23:59:57')

DROP TABLE IF EXISTS #tempPlans_Corrected
SELECT *, CASE WHEN CreditPlanType = '16' THEN AdjustedRetailDue ELSE 0 END SRBToAdjust 
INTO #tempPlans_Corrected 
FROM #TempPlans 
WHERE (AdjustedRRDue > 0 OR AdjustedRetailDue > 0) 
AND CurrentBalance <> AmountofTotalDue 

SELECT *, AmountOfTotalDue - AdjustedRRDue 
FROM #TempPlans
WHERE CreditPlanType = '16'
AND AmountOfTotalDue <> EqualPaymentAmt

UPDATE T1
SET AdjustedRetailDue = AmtOfPayCurrDue - (AmtOfPayCurrDue - AdjustedRRDue)
FROM #TempPlans T1
WHERE CreditPlanType = '16'
AND AmountOfTotalDue <> EqualPaymentAmt

UPDATE #TempPlans SET AdjustedRRDue = 0 WHERE CreditPlanType = '16'


UPDATE T1
SET  AdjustedRRDue = CurrentBalance
FROM #TempPlans T1
WHERE CreditPlanType = '0'
AND CurrentBalance > 0

SELECT * FROM #TempPlans WHERE BSAcctID = 9864384

SELECT *
FROM #TempPlans T2
LEFT JOIN #TempPlans T1 ON (T1.CPSacctId = T2.CPSacctId AND T1.CreditPlanType = '0' AND T1.CurrentBalance > 0)
--WHERE T1.CreditPlanType <> '0'
--AND T1.CurrentBalance > 0

;WITH CTE
AS
(
SELECT *
FROM #TempPlans T1
WHERE CreditPlanType = '0'
AND CurrentBalance > 0
AND AdjustedRRDue > 0
)
SELECT *
FROM #TempPlans T1
JOIN CTE C ON (T1.BSAcctId = C.BSAcctId)
AND T1.CurrentBalance > 0
AND T1.BSAcctID = 9864384


;WITH CTE
AS
(
SELECT *
FROM #TempPlans T1
WHERE CreditPlanType = '0'
AND CurrentBalance > 0
AND AdjustedRRDue > 0
)
UPDATE T1
SET AdjustedRRDue = C.AdjustedRRDue
FROM #TempPlans T1
JOIN CTE C ON (T1.BSAcctId = C.BSAcctId)
AND T1.CurrentBalance > 0




