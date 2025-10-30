DROP TABLE IF EXISTS #TempData
SELECT CPS.acctID, parent01AID, PlanUUID, CurrentBalance, CurrentBalanceCO, OriginalPurchaseAmount, DisputesAmtNS, OrigEqualPmtAmt, EqualPaymentAmt, TCAPPaymentAmt, LoanEndDate
INTO #TempData
FROM CPSgmentAccounts CPS WITH (NOLOCK)
JOIN CPSgmentCreditCard CPC WITH (NOLOCK) ON (CPS.acctID = CPC.acctID)
WHERE CreditPlanType = '16'
AND CurrentBalance+CurrentBalanceCO = OriginalPurchaseAmount

DROP TABLE IF EXISTS #TempRecords
;WITH CTE
AS
(
SELECT T.*, Activity, ILP.OriginalLoanEndDate, ILP.MaturityDate, ROW_NUMBER() OVER(PARTITION BY ILP.PlanID ORDER BY ActivityOrder DESC) RN
FROM #TempData T
JOIN ILPScheduleDetailSummary ILP WITH (NOLOCK) ON (T.acctID = ILP.PlanID)
)
SELECT acctID, parent01AID, PlanUUID, CurrentBalance, CurrentBalanceCO, OriginalPurchaseAmount, DisputesAmtNS, 
OrigEqualPmtAmt, EqualPaymentAmt, TCAPPaymentAmt, LoanEndDate, OriginalLoanEndDate, MaturityDate
INTO #TempRecords
FROM CTE
WHERE RN = 1
AND OriginalLoanEndDate <> MaturityDate

SELECT * FROM #TempRecords

DROP TABLE IF EXISTS #TempPlans
SELECT acctID, parent01AID, T.PlanUUID, T.CurrentBalance, CurrentBalanceCO, OriginalPurchaseAmount, DisputesAmtNS, 
OrigEqualPmtAmt, EqualPaymentAmt, TCAPPaymentAmt, ILP.LoanEndDate, ILP.Activity, C.LutDescription ActivityDescription, 
ILP.OriginalLoanEndDate, ILP.MaturityDate, ILP.ActivityOrder, ILP.WaiveMinDueCycle, ILP.MergeIndicator, ROW_NUMBER() OVER(PARTITION BY ILP.PlanID ORDER BY ActivityOrder) RN
INTO #TempPlans
FROM #TempRecords T
JOIN ILPScheduleDetailSummary ILP WITH (NOLOCK) ON (T.acctID = ILP.PlanID)
LEFT JOIN CCardLookUp C WITH (NOLOCK) ON (C.LutId = 'EPPReasonCode' AND ILP.Activity = TRY_CAST(LutCode AS INT))
WHERE ILP.OriginalLoanEndDate <> ILP.MaturityDate

SELECT * FROM #TempPlans ORDER BY acctID, ActivityOrder

SELECT ActivityDescription--, WaiveMinDueCycle, MergeIndicator
, COUNT(1) Count 
FROM #TempPlans 
WHERE RN = 1
GROUP BY ActivityDescription--, WaiveMinDueCycle, MergeIndicator

--Principal Debit                                                                                     
--Plan Initiated 


SELECT * FROM #TempPlans WHERE ActivityDescription =  'Principal Debit' AND RN = 1

SELECT * FROM #TempPlans WHERE acctID = 134793300 ORDER BY RN
SELECT * FROM #TempRecords WHERE acctID = 105436006 

SELECT C.LutDescription ActivityDescription,*
FROM ILPScheduleDetailSummary ILP WITH (NOLOCK)
LEFT JOIN CCardLookUp C WITH (NOLOCK) ON (C.LutId = 'EPPReasonCode' AND ILP.Activity = TRY_CAST(LutCode AS INT))
WHERE PlanID = 159477329
ORDER BY ActivityOrder
