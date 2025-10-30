

--S-1100001000001698   , D-1100001000001706 -- 1100001000002704
DECLARE @SrcBSAcctId INT = 0, @DestBSAcctId INT = 0, @LastStatementDate DATETIME

SELECT @SrcBSAcctId = acctid, @DestBSAcctId = acctid, @LastStatementDate = LastStatementDate 
FROM BSegment_Primary WITH (NOLOCK) 
WHERE 
--AccountNumber = '1100081250883839' --5122300000002325
acctId = 2320434
--UniversalUniqueID = '00c850ab-ad3f-46e8-93a1-bd745334b660'



SELECT        'BSegment==> ' [Table], Principal, PrincipalCO, BP.acctId, UniversalUniqueID, PendingOTB, PendingOTB_STMT, AccountGraceStatus, CycleDueDTD, AutoInitialChargeOffStartDate,ChargeOffDateParam, NAD, MergeInProcessPH, MergeDate, BC.daysdelinquent, BP.CreatedTime, 
							DateAcctClosed, BS.TestAccount, BillingCycle,RTRIM(BP.AccountNumber) AccountNumber, 
							ccinhparent127AID BillingTable, BP.AmtOfAcctHighBalLTD, BS.latefeesbnp,
							AccountGraceStatus, BP.SystemStatus, UserChargeOffStatus, BC.SystemChargeOffStatus, BC.ChargeOffDate, COInitiateSource, 
							BC.ManualInitialChargeOffStartDate, BC.ChargeOffDateParam, BC.ManualInitialChargeOffReason, 
							BP.ccinhparent125AID, BP.CycleDueDTD, BC.TCAPPaymentAmt, BP.AmountOfCreditsCTD,
							BP.CurrentBalance, BC.currentbalanceco, BC.DateOfTotalDue, BC.AmountOfTotalDue, BP.AmtOfPayCurrDue, 
							BC.AmtOfPayXDLate, BC.AmountOfPayment30DLate, BC.AmountOfPayment60DLate,
							(BC.AmtOfPayXDLate+ BC.AmountOfPayment30DLate+ BC.AmountOfPayment60DLate+ BC.AmountOfPayment90DLate+ 
							BC.AmountOfPayment120DLate+ BC.AmountOfPayment150DLate+ BC.AmountOfPayment180DLate+ BC.AmountOfPayment210DLate) PastDue, BP.LastStatementDate,
							RunningMinimumDue, RemainingMinimumDue, SRBWithInstallmentDue, BC.SBWithInstallmentDue, BB.AmtOfCrAdjMSBCTD, BC.NewTransactionsBSFC, 
							BC.RevolvingBSFC, BC.IntBilledNotPaid, BC.daysdelinquent, BC.DtOfLastDelinqCTD, BC.NoPayDaysDelinquent, 
							BC.DateOfOriginalPaymentDueDTD, BC.ChargeOffDateParam, BC.ChargeOffDate, BC.AutoInitialChargeOffStartDate, BC.ManualInitialChargeOffStartDate--, BC.StatementUUIDCC1, BC.StatementUUIDCC2
FROM            BSegment_Primary AS BP WITH (nolock) INNER JOIN
							BSegmentCreditCard AS BC WITH (nolock) ON BP.acctId = BC.acctId INNER JOIN
							BSegment_Secondary AS BS WITH (nolock) ON BP.acctId = BS.acctId INNER JOIN
							BSegment_Balances AS bb WITH (NOLOCK) ON BP.acctId = bb.acctId
WHERE        (BP.acctId IN (@SrcBSAcctId))


SELECT 'CPSgment==> ' [Table], CPA.acctId, CPCC.paidoutdate, Principal, PrincipalCO, AccountGraceStatus, CycleDueDTD, CurrentBalance, CurrentBalanceCO, CPCC.MergeIndicator, CPA.creditplantype, CPA.parent02AID, CPA.parent01AID, CL.LutDescription PlanType, AmountOfTotalDue, 
OriginalPurchaseAmount, AmountOfPurchasesLTD, AmountOfDebitsLTD, Currentbalance, AmountOfCreditsLTD,AmountOfCreditsRevLTD, AmountOfCreditsLTD-AmountOfCreditsRevLTD TotalCredits,
AmountOfPaymentsCTD,CPA.AmountOfCreditsRevCTD, CPCC.MergeIndicator, CPCC.PlanUUID, CPA.CurrentBalance, --CPCC.TCAPPaymentAmt, 
CPCC.OrigEqualPmtAmt, CPCC.CycleDueDTD, CPCC.AmountOfTotalDue, AmtOfPayCurrDue,
(AmtOfPayXDLate+ AmountOfPayment30DLate+ AmountOfPayment60DLate+ AmountOfPayment90DLate+ 
AmountOfPayment120DLate+ AmountOfPayment150DLate+ AmountOfPayment180DLate+ AmountOfPayment210DLate) PastDue, SRBWithInstallmentDue
, EstimatedDue, RolloverDue, CPA.DisputesAmtNS, InterestRate1, CPCC.EqualPaymentAmt, CPCC.LoanEndDate, CPCC.InterestRate1--, CPCC.TCAPPaymentAmt
, CPA.plansegcreatedate, CPCC.PromoStartDate, CPCC.PromoRateEndDate
FROM CPSgmentAccounts CPA WITH (NOLOCK)
JOIN CPSgmentCreditCard CPCC WITH (NOLOCK) ON (CPA.acctId = CPCC.acctId)
LEFT JOIN CCardLookUp CL WITH (NOLOCK) ON (CL.LutCode = CPA.creditplantype AND CL.LUTid = 'CPMCrPlanType')
--WHERE CPA.acctId = 5040
WHERE CPA.parent02AID = @SrcBSAcctId
--AND PlanUUID = '6ee36cce-5a31-44bf-b016-4494971175c8'
ORDER BY CPA.acctID


;WITH CTE
AS
(
SELECT 'ILP==> ' [Table],
	BP.AccountNumber, ILPS.PlanID, ILPS.PlanUUID,ILPS.PaidOffDate, ILPS.ActivityAmount, ILPS.ActivityOrder, RTRIM(CL.LutDescription) AS ActivityDescription, 
	ILPS.OriginalLoanAmount, ILPS.CurrentBalance, ILPS.LoanTerm, ILPS.LoanDate, ILPS.OriginalLoanEndDate, ILPS.LoanEndDate, ILPS.ScheduleType,
	ILPS.CorrectionDate, ILPS.ScheduleID, ILPS.MaturityDate, ILPS.TranId,  
	ROW_NUMBER() OVER(PARTITION BY ILPS.parent02AID, ILPS.PlanID ORDER BY ActivityOrder DESC) ScheduleCount
FROM ILPScheduleDetailSummary AS ILPS WITH (NOLOCK) 
INNER JOIN BSegment_Primary AS bp WITH (nolock) ON ILPS.parent02AID = bp.acctId 
LEFT OUTER JOIN CCardLookUp AS CL WITH (NOLOCK) ON (TRY_CONVERT(VARCHAR, ILPS.Activity) = CL.LutCode)
WHERE (CL.LUTid = 'EPPReasonCode') 
AND (ILPS.parent02AID = @SrcBSAcctId) 
--AND ILPS.PlanID IN (5078)
--AND ILPS.PlanUUID LIKE '%SC37%'
--AND BP.AccountNumber = '1100000100200374'
--AND ILPS.Activity = 1
--ORDER BY ILPS.PlanID, ILPS.ActivityOrder
)
SELECT * FROM CTE WHERE ScheduleCount = 1 ORDER BY PlanID


SELECT 'StatementHeader==> ' [Table], SH.acctId, APR, HostMachinename, SH.RowCreatedDate, ccinhparent125AID, DateAcctClosed, DaysDelinquent, NoPayDaysDelinquent, DTOfLastDelinqCTD, SH.StatementDate, latefeesbnp, AccountGraceStatus, minimumPaymentDue, CycleDueDTD, SystemStatus, CurrentBalance, SRBWithInstallmentDue, AmountOfTotalDue, AmtOfPayCurrDue,
(AmtOfPayXDLate+ AmountOfPayment30DLate+ AmountOfPayment60DLate+ AmountOfPayment90DLate+ 
AmountOfPayment120DLate+ AmountOfPayment150DLate+ AmountOfPayment180DLate+ AmountOfPayment210DLate) PastDue, IntBilledNotPaid, RevolvingBSFC, 
NewTransactionsBSFC, APR, InterestRate1, YTDtotalInt, AmtOfInterestCTD, AmtInterestCreditsCTD
FROM StatementHeader SH WITH (NOLOCK)
JOIN StatementHeaderEX SE WITH (NOLOCK) ON (SH.acctID = SE.acctID AND SH.StatementID = SE.StatementID)
WHERE SH.acctId = @SrcBSAcctId AND SH.StatementDate = @LastStatementDate

SELECT 'SummaryHeader==> ' [Table], SH.acctId, APR, SH.parent01AID, SH.parent02AID, SH.StatementDate, APR, AccountGraceStatus, SHCC.CycleDueDTD, CreditBalanceMovement,
SHCC.DisputesAmtNS, SH.CurrentBalance, AmtOfInterestCTD, IntBilledNotPaid, SRBWithInstallmentDue, AmountOfTotalDue, CurrentDue,
(AmtOfPayXDLate+ AmountOfPayment30DLate+ AmountOfPayment60DLate+ AmountOfPayment90DLate+ 
AmountOfPayment120DLate+ AmountOfPayment150DLate+ AmountOfPayment180DLate+ AmountOfPayment210DLate) PastDue, SHCC.PayOffDate, SHCC.LoanEndDate
FROM SummaryHeader SH WITH (NOLOCK)
JOIN SummaryHeaderCreditCard SHCC WITH (NOLOCK) ON (SH.acctId = SHCC.acctId AND SH.StatementID = SHCC.StatementID)
WHERE SH.parent02AID = @SrcBSAcctId AND SH.StatementDate = @LastStatementDate


SELECT 'MergeAccountJob===> ' [Table], * FROM MergeAccountJob WITH (NOLOCK) WHERE (destBSAcctId = @DestBSAcctId OR SrcBSAcctId = @SrcBSAcctId)


--SELECT TOP(1) 'TNP Time===> ' [Table], * FROM LS_P1MARPRODDB01.ccgs_coreissue.dbo.CommonTNP WITH(NOLOCK) WHERE ATID = 60 --AND InstitutionID = 6969

--SELECT 'PendingJobs_TNP===> ' [Table], * FROM LS_P1MARPRODDB01.ccgs_coreissue.dbo.CommonTNP with(nolock) where TranId > 0 AND acctId IN (@DestBSAcctId, @SrcBSAcctId)

--SELECT 'PendingNADJobs_TNP===> ' [Table], * FROM LS_P1MARPRODDB01.ccgs_coreissue.dbo.CommonTNP with(nolock) where TranId = 0 AND acctId IN (@DestBSAcctId, @SrcBSAcctId)

--SELECT * FROM ErrorTNP with(nolock) where TranId > 0 AND acctId IN (@DestBSAcctId, @SrcBSAcctId)

--SELECT 'PendingJobs_CCard===> ' [Table], CMTTRANTYPE, TransactionAmount, * 
--FROM CCard_Primary with(nolock) 
--where TranId IN (SELECT TranId FROM LS_P1MARPRODDB01.ccgs_coreissue.dbo.CommonTNP with(nolock) where TranId > 0 AND acctId IN (@DestBSAcctId, @SrcBSAcctId))