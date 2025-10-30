USE PP_CI
GO

--UPDATE BSegment_Secondary SET ClientId = '123' WHERE acctID = 14551608

--SELECT * FROM version  order by 1 desc

--S-1100001000001698   , D-1100001000001706 -- 1100001000002704
DECLARE @SrcBSAcctId INT = 0, @DestBSAcctId INT = 0, @LastStatementDate DATETIME

SELECT @SrcBSAcctId = acctid, @LastStatementDate = LastStatementDate 
FROM BSegment_Primary WITH (NOLOCK) 
WHERE 
AccountNumber = '1100001000006697' --5122300000002325
--acctId = 5005
--UniversalUniqueID = ''

SELECT @DestBSAcctId = acctid, @LastStatementDate = LastStatementDate 
FROM BSegment_Primary WITH (NOLOCK) 
WHERE 
--AccountNumber = '1100001000007703'
acctId = 0
--UniversalUniqueID = ''


SELECT        'BSegment_SRC==> ' [Table], BP.acctId, BillingCycle, BS.ClientId,RTRIM(BP.AccountNumber) AccountNumber, ccinhparent127AID BillingTable, AccountGraceStatus, BP.SystemStatus, 
							BP.ccinhparent125AID, BP.CycleDueDTD, BC.TCAPPaymentAmt, BP.AmountOfCreditsCTD,
							BP.CurrentBalance, BC.currentbalanceco, BC.DateOfTotalDue, BC.AmountOfTotalDue, BP.AmtOfPayCurrDue, 
							BC.AmtOfPayXDLate, BC.AmountOfPayment30DLate, BC.AmountOfPayment60DLate,
							(BC.AmtOfPayXDLate+ BC.AmountOfPayment30DLate+ BC.AmountOfPayment60DLate+ BC.AmountOfPayment90DLate+ 
							BC.AmountOfPayment120DLate+ BC.AmountOfPayment150DLate+ BC.AmountOfPayment180DLate+ BC.AmountOfPayment210DLate) PastDue, BP.LastStatementDate,
							RunningMinimumDue, RemainingMinimumDue, SRBWithInstallmentDue, BC.SBWithInstallmentDue, BB.AmtOfCrAdjMSBCTD, BC.NewTransactionsBSFC, 
							BC.RevolvingBSFC, BC.IntBilledNotPaid, BC.daysdelinquent, BC.DtOfLastDelinqCTD, BC.NoPayDaysDelinquent, 
							BC.DateOfOriginalPaymentDueDTD, BC.ChargeOffDateParam, BC.ChargeOffDate
FROM            BSegment_Primary AS BP WITH (nolock) INNER JOIN
							BSegmentCreditCard AS BC WITH (nolock) ON BP.acctId = BC.acctId INNER JOIN
							BSegment_Secondary AS BS WITH (nolock) ON BP.acctId = BS.acctId INNER JOIN
							BSegment_Balances AS bb WITH (NOLOCK) ON BP.acctId = bb.acctId
WHERE        (BP.acctId IN (@SrcBSAcctId))

SELECT        'BSegment_DEST==> ' [Table], BP.acctId, BS.ClientId,RTRIM(BP.AccountNumber) AccountNumber, ccinhparent127AID BillingTable, AccountGraceStatus, BP.SystemStatus, 
							BP.ccinhparent125AID, BP.CycleDueDTD, BC.TCAPPaymentAmt, BP.AmountOfCreditsCTD,
							BP.CurrentBalance, BC.currentbalanceco, BC.DateOfTotalDue, BC.AmountOfTotalDue, BP.AmtOfPayCurrDue, 
							(BC.AmtOfPayXDLate+ BC.AmountOfPayment30DLate+ BC.AmountOfPayment60DLate+ BC.AmountOfPayment90DLate+ 
							BC.AmountOfPayment120DLate+ BC.AmountOfPayment150DLate+ BC.AmountOfPayment180DLate+ BC.AmountOfPayment210DLate) PastDue, BP.LastStatementDate,
							RunningMinimumDue, RemainingMinimumDue, SRBWithInstallmentDue, BC.SBWithInstallmentDue, BB.AmtOfCrAdjMSBCTD, BC.NewTransactionsBSFC, 
							BC.RevolvingBSFC, BC.IntBilledNotPaid, BC.daysdelinquent, BC.DtOfLastDelinqCTD, BC.NoPayDaysDelinquent, BC.DateOfOriginalPaymentDueDTD, BC.ChargeOffDateParam, BC.ChargeOffDate
FROM            BSegment_Primary AS BP WITH (nolock) INNER JOIN
							BSegmentCreditCard AS BC WITH (nolock) ON BP.acctId = BC.acctId INNER JOIN
							BSegment_Secondary AS BS WITH (nolock) ON BP.acctId = BS.acctId INNER JOIN
							BSegment_Balances AS bb WITH (NOLOCK) ON BP.acctId = bb.acctId
WHERE        (BP.acctId IN (@DestBSAcctId))

SELECT 'CPSgment_SRC==> ' [Table], CPA.acctId, CPA.creditplantype, CPA.parent02AID, CPA.parent01AID, 
CASE 
	WHEN CPA.creditplantype = '16' THEN 'RETAIL'
	WHEN CPA.creditplantype = '10' THEN 'RRC'
	ELSE 'Normal Plan' END AS PlanType, 
AmountOfPaymentsCTD,CPA.AmountOfCreditsRevCTD, CPCC.MergeIndicator, CPCC.PlanUUID, CPA.CurrentBalance, --CPCC.TCAPPaymentAmt, 
CPCC.OrigEqualPmtAmt, CPCC.CycleDueDTD, 
CPCC.AmountOfTotalDue, AmtOfPayCurrDue,
(AmtOfPayXDLate+ AmountOfPayment30DLate+ AmountOfPayment60DLate+ AmountOfPayment90DLate+ 
AmountOfPayment120DLate+ AmountOfPayment150DLate+ AmountOfPayment180DLate+ AmountOfPayment210DLate) PastDue, SRBWithInstallmentDue
, EstimatedDue, RolloverDue, CPA.DisputesAmtNS, InterestRate1, CPCC.EqualPaymentAmt, CPCC.LoanEndDate--, CPCC.TCAPPaymentAmt
FROM CPSgmentAccounts CPA WITH (NOLOCK)
JOIN CPSgmentCreditCard CPCC WITH (NOLOCK) ON (CPA.acctId = CPCC.acctId)
--WHERE CPA.acctId = 5040
WHERE CPA.parent02AID = @SrcBSAcctId

SELECT 'CPSgment_DEST==> ' [Table], CPA.acctId, CPA.creditplantype, CPA.parent02AID, CPA.parent01AID,
CASE 
	WHEN CPA.creditplantype = '16' THEN 'RETAIL'
	WHEN CPA.creditplantype = '10' THEN 'RRC'
	ELSE 'Normal Plan' END AS PlanType, 
AmountOfPaymentsCTD,CPA.AmountOfCreditsRevCTD, CPCC.MergeIndicator, CPCC.PlanUUID, CPA.CurrentBalance, --CPCC.TCAPPaymentAmt, 
CPCC.OrigEqualPmtAmt, CPCC.CycleDueDTD, 
CPCC.AmountOfTotalDue, AmtOfPayCurrDue,
(AmtOfPayXDLate+ AmountOfPayment30DLate+ AmountOfPayment60DLate+ AmountOfPayment90DLate+ 
AmountOfPayment120DLate+ AmountOfPayment150DLate+ AmountOfPayment180DLate+ AmountOfPayment210DLate) PastDue, SRBWithInstallmentDue
, EstimatedDue, RolloverDue, CPA.DisputesAmtNS, InterestRate1, CPCC.EqualPaymentAmt, CPCC.LoanEndDate--, CPCC.TCAPPaymentAmt
FROM CPSgmentAccounts CPA WITH (NOLOCK)
JOIN CPSgmentCreditCard CPCC WITH (NOLOCK) ON (CPA.acctId = CPCC.acctId)
--WHERE CPA.acctId = 5040
WHERE CPA.parent02AID = @DestBSAcctId

SELECT 'ILP_SRC==> ' [Table],
	BP.AccountNumber, ILPS.PlanID, ILPS.PlanUUID, ILPS.ActivityAmount, ILPS.ActivityOrder, RTRIM(CL.LutDescription) AS ActivityDescription, 
	ILPS.OriginalLoanAmount, ILPS.CurrentBalance, ILPS.LoanTerm, ILPS.LoanDate, ILPS.OriginalLoanEndDate, ILPS.LoanEndDate, ILPS.ScheduleType,
	ILPS.CorrectionDate, ILPS.ScheduleID, ILPS.MaturityDate, ILPS.TranId, ILPS.PaidOffDate
FROM ILPScheduleDetailSummary AS ILPS WITH (NOLOCK) 
INNER JOIN BSegment_Primary AS bp WITH (nolock) ON ILPS.parent02AID = bp.acctId 
LEFT OUTER JOIN CCardLookUp AS CL WITH (NOLOCK) ON (TRY_CONVERT(VARCHAR, ILPS.Activity) = CL.LutCode)
WHERE (CL.LUTid = 'EPPReasonCode') 
AND (ILPS.parent02AID = @SrcBSAcctId) 
--AND ILPS.PlanID IN (5078)
--AND ILPS.PlanUUID LIKE '%SC37%'
--AND BP.AccountNumber = '1100000100200374'
--AND ILPS.Activity = 1
ORDER BY ILPS.PlanID, ILPS.ActivityOrder

SELECT 'ILP_DEST==> ' [Table],
	BP.AccountNumber, ILPS.PlanID, ILPS.PlanUUID, ILPS.ActivityAmount, ILPS.ActivityOrder, RTRIM(CL.LutDescription) AS ActivityDescription, 
	ILPS.OriginalLoanAmount, ILPS.CurrentBalance, ILPS.LoanTerm, ILPS.LoanDate, ILPS.OriginalLoanEndDate, ILPS.LoanEndDate, ILPS.ScheduleType,
	ILPS.CorrectionDate, ILPS.ScheduleID, ILPS.MaturityDate, ILPS.TranId, ILPS.PaidOffDate
FROM ILPScheduleDetailSummary AS ILPS WITH (NOLOCK) 
INNER JOIN BSegment_Primary AS bp WITH (nolock) ON ILPS.parent02AID = bp.acctId 
LEFT OUTER JOIN CCardLookUp AS CL WITH (NOLOCK) ON (TRY_CONVERT(VARCHAR, ILPS.Activity) = CL.LutCode)
WHERE (CL.LUTid = 'EPPReasonCode') 
AND (ILPS.parent02AID = @DestBSAcctId) 
--AND ILPS.PlanID IN (5078)
--AND ILPS.PlanUUID LIKE '%SC37%'
--AND BP.AccountNumber = '1100000100200374'
--AND ILPS.Activity = 1
ORDER BY ILPS.PlanID, ILPS.ActivityOrder

SELECT 'StatementHeader_SRC==> ' [Table], acctId, StatementDate, AccountGraceStatus, minimumPaymentDue, CycleDueDTD, SystemStatus, CurrentBalance, SRBWithInstallmentDue, AmountOfTotalDue, AmtOfPayCurrDue,
(AmtOfPayXDLate+ AmountOfPayment30DLate+ AmountOfPayment60DLate+ AmountOfPayment90DLate+ 
AmountOfPayment120DLate+ AmountOfPayment150DLate+ AmountOfPayment180DLate+ AmountOfPayment210DLate) PastDue, IntBilledNotPaid, RevolvingBSFC, 
NewTransactionsBSFC, APR, InterestRate1, YTDtotalInt
FROM StatementHeader WITH (NOLOCK)
WHERE acctId = @SrcBSAcctId AND StatementDate = @LastStatementDate

SELECT 'SummaryHeader_SRC==> ' [Table], SH.acctId, SH.parent02AID, SH.StatementDate, AccountGraceStatus, SHCC.CycleDueDTD, SHCC.DisputesAmtNS, SH.CurrentBalance, SRBWithInstallmentDue, AmountOfTotalDue, CurrentDue,
(AmtOfPayXDLate+ AmountOfPayment30DLate+ AmountOfPayment60DLate+ AmountOfPayment90DLate+ 
AmountOfPayment120DLate+ AmountOfPayment150DLate+ AmountOfPayment180DLate+ AmountOfPayment210DLate) PastDue, SHCC.PayOffDate, SHCC.LoanEndDate
FROM SummaryHeader SH WITH (NOLOCK)
JOIN SummaryHeaderCreditCard SHCC WITH (NOLOCK) ON (SH.acctId = SHCC.acctId AND SH.StatementID = SHCC.StatementID)
WHERE SH.parent02AID = @SrcBSAcctId AND SH.StatementDate = @LastStatementDate

SELECT 'StatementHeader_DEST==> ' [Table], acctId, StatementDate, AccountGraceStatus, CycleDueDTD, SystemStatus, CurrentBalance, SRBWithInstallmentDue, AmountOfTotalDue, AmtOfPayCurrDue,
(AmtOfPayXDLate+ AmountOfPayment30DLate+ AmountOfPayment60DLate+ AmountOfPayment90DLate+ 
AmountOfPayment120DLate+ AmountOfPayment150DLate+ AmountOfPayment180DLate+ AmountOfPayment210DLate) PastDue, IntBilledNotPaid, RevolvingBSFC, 
NewTransactionsBSFC, APR, InterestRate1, YTDtotalInt
FROM StatementHeader WITH (NOLOCK)
WHERE acctId = @DestBSAcctId AND StatementDate = @LastStatementDate

SELECT 'SummaryHeader_DEST==> ' [Table], SH.acctId, SH.parent02AID, SH.StatementDate, AccountGraceStatus, SHCC.CycleDueDTD, SHCC.DisputesAmtNS, SH.CurrentBalance, SRBWithInstallmentDue, AmountOfTotalDue, CurrentDue,
(AmtOfPayXDLate+ AmountOfPayment30DLate+ AmountOfPayment60DLate+ AmountOfPayment90DLate+ 
AmountOfPayment120DLate+ AmountOfPayment150DLate+ AmountOfPayment180DLate+ AmountOfPayment210DLate) PastDue, SHCC.PayOffDate, SHCC.LoanEndDate
FROM SummaryHeader SH WITH (NOLOCK)
JOIN SummaryHeaderCreditCard SHCC WITH (NOLOCK) ON (SH.acctId = SHCC.acctId AND SH.StatementID = SHCC.StatementID)
WHERE SH.parent02AID = @DestBSAcctId AND SH.StatementDate = @LastStatementDate



SELECT * FROM MergeAccountJob WITH (NOLOCK) WHERE (destBSAcctId = @DestBSAcctId OR SrcBSAcctId = @SrcBSAcctId)


SELECT TOP(1) * FROM CommonTNP WITH(NOLOCK) WHERE ATID = 60 --AND InstitutionID = 6969

SELECT * FROM CommonTNP with(nolock) where TranId > 0 AND acctId IN (@DestBSAcctId, @SrcBSAcctId)

SELECT * FROM ErrorTNP with(nolock) where TranId > 0 AND acctId IN (@DestBSAcctId, @SrcBSAcctId)

SELECT 'PendingJobs_CCard===> ' [Table], CMTTRANTYPE, TransactionAmount, * 
FROM CCard_Primary with(nolock) 
where TranId IN (SELECT TranId FROM CommonTNP with(nolock) where TranId > 0 AND acctId IN (@DestBSAcctId, @SrcBSAcctId))