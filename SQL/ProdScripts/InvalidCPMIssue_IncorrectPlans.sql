DROP TABLE IF EXISTS #AllPlans
SELECT * INTO #AllPlans FROM LISTPRODPLAT.CCGS_CoreIssue.dbo.Temp_PlanToChangeCPM


DROP TABLE IF EXISTS #AllPlansDetails
;WITH CTE
AS
(
SELECT DISTINCT parent02AID 
FROM #AllPlans A
JOIN CPSgmentAccounts C WITH (NOLOCK) ON (A.PlanID = C.acctID)
)
SELECT BP.AccountNumber, CP.acctID, CP.parent02AID, PlanUUID, OriginalPurchaseAmount, CP.CurrentBalance+CPC.CurrentBalanceCO CurrentBalance,
CP.AmountOfDebitsLTD, CP.AmountOfDebitsRevCTD, CP.AmountOfCreditsLTD, CPC.AmountOfCreditsRevLTD 
INTO #AllPlansDetails
FROM CTE C
JOIN CPSgmentAccounts CP WITH (NOLOCK) ON (C.parent02AID = CP.parent02AID)
JOIN CPSgmentCreditCard CPC WITH (NOLOCK) ON (Cp.acctID = CPC.acctID)
JOIN BSegment_Primary BP WITH (NOLOCK) ON (CP.parent02AID = BP.acctId)
WHERE CP.CreditPlanType = '16'

--SELECT *--parent02AID, SUM(OriginalPurchaseAmount) OriginalPurchaseAmount, SUM(CurrentBalance) CurrentBalance, SUM(Actualbalance) Actualbalance
--FROM #AllPlansDetails
--WHERE Actualbalance <> CurrentBalance
--AND parent02AID = 11402976
----GROUP BY parent02AID

--;AmountOfDebitsRevCTD

DROP TABLE IF EXISTS #PlanData
;WITH CTE
AS
(
SELECT S.acctId, ISNULL(S.AmountOfDebitsRevCTD, 0) AmountOfDebitsRevCTD
FROM #AllPlansDetails A
JOIN SummaryHeader S WITH (NOLOCK) ON (A.acctID = S.acctID)
),
Summary
As
(
SELECT acctId, SUM(AmountOfDebitsRevCTD) AmountOfDebitsRevLTD
FROM CTE
GROUP BY acctID
)
SELECT A.*, S.AmountOfDebitsRevLTD+A.AmountOfDebitsRevCTD, (AmountOfDebitsLTD - AmountOfDebitsRevLTD) - (AmountOfCreditsLTD - AmountOfCreditsRevLTD) Actualbalance
INTO #PlanData
FROM #AllPlansDetails A
JOIN Summary S WITH (NOLOCK) ON (A.acctID = S.acctID)

SELECT * 
FROM #PlanData 
WHERE parent02AID = 11402976
--AND Actualbalance <> CurrentBalance
AND AmountOfDebitsLTD - AmountOfDebitsRevLTD <> OriginalPurchaseAmount

DROP TABLE IF EXISTS #Txns
;WITH CTE
AS
(
SELECT CP.AccountNumber, CP.TxnAcctID, CMTTRANTYPE, TransactionAmount, NoblobIndicator
FROM #PlanData P 
JOIN CCArd_Primary CP WITH (NOLOCK) ON (P.AccountNumber = CP.AccountNumber AND P.acctID = CP.TxnAcctID)
WHERE CMTTRanType = '122'
AND TransactionDescription = 'Noblob Adjustment'
),
Txns
AS
(
SELECT TxnAcctID, SUM(TransactionAmount) TransactionAmount
FROM CTE
GROUP BY TxnAcctID
)
SELECT *
INTO #Txns
FROM Txns T
JOIN #PlanData P ON (T.TxnAcctID = P.acctID)

SELECT * FROM #Txns




SELECT *--parent02AID, SUM(OriginalPurchaseAmount) OriginalPurchaseAmount, SUM(CurrentBalance) CurrentBalance, SUM(Actualbalance) Actualbalance
FROM #AllPlansDetails
WHERE Actualbalance <> CurrentBalance
AND parent02AID = 11402976
--GROUP BY parent02AID


DROP TABLE IF EXISTS #IssuePlans
;WITH CTE
AS
(
SELECT A.*, TRY_CAST(C.NewValue AS MONEY) UpdatedBalance
, ROW_NUMBER() OVER(PARTITION BY C.AID ORDER BY TRY_CAST(C.NewValue AS MONEY) DESC) RN
FROM #AllPlansDetails A
JOIN CurrentBalanceAuditPS C WITH (NOLOCK) ON (A.acctID = C.AID AND C.DENAME IN (111, 222) AND C.ATID = 52)
)
SELECT * INTO #IssuePlans FROM CTE WHERE RN = 1 AND UpdatedBalance > OriginalPurchaseAmount

SELECT * FROM #IssuePlans


SELECT 'CPSgment==> ' [Table], CPA.acctId, CPA.creditplantype, CPA.parent02AID, CPA.parent01AID, CL.LutDescription PlanType, AmountOfDebitsLTD-AmountOfCreditsLTD Actualbalance,
OriginalPurchaseAmount, AmountOfPurchasesLTD, AmountOfDebitsLTD, Currentbalance, CurrentBalanceCO, AmountOfCreditsLTD,AmountOfCreditsRevLTD, AmountOfCreditsLTD-AmountOfCreditsRevLTD TotalCredits,
AmountOfPaymentsCTD,CPA.AmountOfCreditsRevCTD, CPCC.MergeIndicator, CPCC.PlanUUID, CPA.CurrentBalance, --CPCC.TCAPPaymentAmt, 
CPCC.OrigEqualPmtAmt, CPCC.CycleDueDTD, CPCC.AmountOfTotalDue, AmtOfPayCurrDue,
(AmtOfPayXDLate+ AmountOfPayment30DLate+ AmountOfPayment60DLate+ AmountOfPayment90DLate+ 
AmountOfPayment120DLate+ AmountOfPayment150DLate+ AmountOfPayment180DLate+ AmountOfPayment210DLate) PastDue, SRBWithInstallmentDue
, EstimatedDue, RolloverDue, CPA.DisputesAmtNS, InterestRate1, CPCC.EqualPaymentAmt, CPCC.LoanEndDate, CPCC.InterestRate1--, CPCC.TCAPPaymentAmt
, CPA.plansegcreatedate, CPCC.PromoStartDate, CPCC.PromoRateEndDate
FROM CPSgmentAccounts CPA WITH (NOLOCK)
JOIN CPSgmentCreditCard CPCC WITH (NOLOCK) ON (CPA.acctId = CPCC.acctId)
LEFT JOIN CCardLookUp CL WITH (NOLOCK) ON (CL.LutCode = CPA.creditplantype AND CL.LUTid = 'CPMCrPlanType')
--WHERE CPA.acctId = 106731352
WHERE CPA.parent02AID = 21382331
AND CreditPlanType = '16'

SELECT * FROM LISTPRODPLAT.CCGS_CoreIssue.dbo.Temp_PlanToChangeCPM WHERE PlanID = 112204705



SELECT object_name(object_id),* FROM sys.columns WHERE name like '%AmountOfDebitsRevCTD%'