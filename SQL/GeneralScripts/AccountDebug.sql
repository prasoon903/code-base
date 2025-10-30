--USE PP_CI
--GO

--UPDATE BSegmentCreditCard SET AutoInitialChargeOffStartDate = '2019-05-31 23:59:55.000' WHERE acctID = 14551608

--UPDATE CPSgmentCreditCard SET PromoRateEndDate = '2021-09-25 23:59:57.000' WHERE acctID = 3104715

--UPDATE ArSystemHSAccounts SET InstitutionId = NULL
	
--SELECT * FROM CommonAP
--SELECT * FROM CommonTNP
--SELECT * FROM APIQueue WITH (NOLOCK)
--EXEC USP_CCardDetails @AccountNumber = '1100001000006697', @LinkServer = 'BPLDEVDB01', @DB = 'PP_CI', @FromDate = '2018-02-06', @ToDate = '2018-05-13 20:00:01.000'
--EXEC USP_CCardDetails @AccountNumber = '1100001000006721', @LinkServer = 'XEON-S8', @DB = 'PP_CI', @FromDate = '2018-02-06'

--SELECT TOP 1 'Version==> ' [Table],* FROM Version ORDER BY EntryId DESC

--UPDATE BSegment_Secondary SET ClientId = '123' WHERE acctID = 14551608
--UPDATE Logo_Balances SET TNPPDFXmlGeneration = 1, StatementAPIJSON = 1
--UPDATE Org_Balances SET AsynchronousPosting = 1, RealTimePostingDuringEOM = 1, NewTNPQueue = 1
--UPDATE ConfigStore SET KeyValue = '0' WHERE KeyName = 'COMMONAP_QNAJOB'

--SELECT * FROM StatementJobs WITH (NOLOCK) WHERE acctID = 14551609

--UPDATE StatementJobs SET Status = 'NEW' WHERE acctID = 14551608

--SELECT NADMode,* FROM ARSystemAccounts
--SELECT NADMode,* FROM ARSystemHSAccounts
--SELECT TNPPDFXmlGeneration, StatementAPIJSON,* FROM Logo_Balances WHERE acctID = 7131
--SELECT * FROM Logo_Secondary WHERE acctID = 7131
--SELECT AsynchronousPosting, RealTimePostingDuringEOM,* FROM Org_Balances
--SELECT * FROM ConfigStore WHERE KeyName = 'COMMONAP_QNAJOB'
--SELECT * FROM Temp_APIQueue_Conversion

--SELECT * FROM CommonAP
--SELECT * FROM CommonTNP WITH (NOLOCK) WHERE TranID > 0

--INSERT INTO CommonTNP SELECT * FROM CommonAP
--DELETE FROM CommonAP

--DELETE FROM CommonTNP WHERE acctID NOT IN (2829255) AND ATID NOT IN (60, 110)

--select * from sys.servers

--SELECT * FROM sys.synonyms

--SELECT * FROM MonetaryTxnControl WITH (NOLOCK) WHERE ActualTranCode = 'F4009'

--EXEC USP_PDF_ReprocessErrorTnpJobs 14551608,51,NULL -- PLAT
--EXEC USP_PDF_ReprocessErrorTnpJobs 14551608,51,NULL,0 -- JAZZ

--SELECT * FROM sys.procedures WHERE name like '%ReprocessError%'

--EXEC AutoReprocessErrorAP 'PLAT'

--PPARASHAR.15380(02/10/21 15:15:49) dbbexpr.cpp(3510) : Expression '__ruNoBlobCombinedStatementRule_BSegment_body': Line 379: eval() caught an unknown exception

--SELECT * FROM ErrorTNP with(nolock)

--PPARASHAR.13460(05/10/21 19:38:12) dbbexcept.h(267) : Posting failed
--1100001000006697
--1100001000006705

--DELETE FROM CommonTNP WHERE ATID = 150

--S-1100001000006697   , D-1100001000006705 -- 1100001000002704
DECLARE @SrcBSAcctId INT = 0, @DestBSAcctId INT = 0, @LastStatementDate DATETIME

--UPDATE CCArd_Primary SET TranTime = '2021-02-13 11:48:28.000' WHERE TranID = 1814415510685286434
--UPDATE CommonTNP SET TranTime = '2021-02-13 11:48:28.000' WHERE TranID = 1814415510685286434

SELECT @SrcBSAcctId = acctid, @DestBSAcctId = acctid, @LastStatementDate = LastStatementDate 
FROM BSegment_Primary WITH (NOLOCK) 
WHERE 
AccountNumber = '1100000100200259' --5122300000002325
--acctId = 14551608
--UniversalUniqueID = ''
--



SELECT        'BSegment==> ' [Table], BP.acctId, BP.CycleDueDTD, BP.CreatedTime, DateOfTotalDue, BP.DateOfNextStmt, BP.PendingOTB, BP.LAD, BP.LAPD, BP.NAD, BP.ccinhparent125AID, BP.SystemStatus, BS.ClientId, BeginningBalance, BC.IndexRate, BC.daysdelinquent, BP.CreatedTime, DateAcctClosed, BS.TestAccount, 
							BillingCycle,RTRIM(BP.AccountNumber) AccountNumber, 
							ccinhparent127AID BillingTable, BP.AmtOfAcctHighBalLTD, BS.latefeesbnp,
							AccountGraceStatus, BP.GraceDaysStatus, BP.SystemStatus, UserChargeOffStatus, BC.SystemChargeOffStatus, BC.ChargeOffDate, COInitiateSource, 
							BC.ManualInitialChargeOffStartDate, BC.ChargeOffDateParam, BC.ManualInitialChargeOffReason, BC.AutoInitialChargeOffReason,
							BP.ccinhparent125AID, BP.CycleDueDTD, BC.TCAPPaymentAmt, BP.AmountOfCreditsCTD,
							BP.CurrentBalance, BC.currentbalanceco, BC.DateOfTotalDue, BC.AmountOfTotalDue, BP.AmtOfPayCurrDue, 
							BC.AmtOfPayXDLate, BC.AmountOfPayment30DLate, BC.AmountOfPayment60DLate,BC.AmountOfPayment90DLate,
							BC.AmountOfPayment120DLate, BC.AmountOfPayment150DLate, BC.AmountOfPayment180DLate, BC.AmountOfPayment210DLate,
							(BC.AmtOfPayXDLate+ BC.AmountOfPayment30DLate+ BC.AmountOfPayment60DLate+ BC.AmountOfPayment90DLate+ 
							BC.AmountOfPayment120DLate+ BC.AmountOfPayment150DLate+ BC.AmountOfPayment180DLate+ BC.AmountOfPayment210DLate) PastDue, BP.LastStatementDate,
							RunningMinimumDue, RemainingMinimumDue, SRBWithInstallmentDue, BC.SBWithInstallmentDue, BB.AmtOfCrAdjMSBCTD, BC.NewTransactionsBSFC, 
							BC.RevolvingBSFC, BC.IntBilledNotPaid, BC.daysdelinquent, BC.DtOfLastDelinqCTD, BC.NoPayDaysDelinquent, 
							BC.DateOfOriginalPaymentDueDTD, BC.ChargeOffDateParam, BC.ChargeOffDate, BC.AutoInitialChargeOffStartDate, BC.ManualInitialChargeOffStartDate--, BC.StatementUUIDCC1, BC.StatementUUIDCC2
							,bb.CBRLastCalculatedDate, BP.BillingCycle, BC.TCAPStatus, BC.TCAPPaymentAmt, BP.LastReageDate
FROM            BSegment_Primary AS BP WITH (nolock) INNER JOIN
							BSegmentCreditCard AS BC WITH (nolock) ON BP.acctId = BC.acctId INNER JOIN
							BSegment_Secondary AS BS WITH (nolock) ON BP.acctId = BS.acctId INNER JOIN
							BSegment_Balances AS bb WITH (NOLOCK) ON BP.acctId = bb.acctId
WHERE        (BP.acctId IN (@SrcBSAcctId))




SELECT 'CPSgment==> ' [Table], CPA.DeCurrentBalance_TranTime_PS,CPA.acctId, CPCC.PlanUUID, CPA.InvoiceNumber, CPA.parent01AID, CPCC.OrigEqualPmtAmt, 
CPCC.OriginalPurchaseAmount, CPA.AmountOfCreditsLTD, CPCC.AmountOfCreditsRevLTD, 
(CPA.CurrentBalance+CPCC.currentbalanceco) - (CPCC.OriginalPurchaseAmount - (CPA.AmountOfCreditsLTD + CPCC.AmountOfCreditsRevLTD)) Delta,
CPCC.paidoutdate, BeginningBalance, CPCC.AccountGraceStatus, CPCC.GraceDaysStatus, CPA.creditplantype, CPCC.TrailingInterestDate, 
CPA.parent02AID, CPA.parent01AID, CL.LutDescription PlanType,
AmountOfPaymentsCTD,CPA.AmountOfCreditsRevCTD, CPCC.MergeIndicator, CPCC.PlanUUID, CPA.CurrentBalance, --CPCC.TCAPPaymentAmt, 
CPCC.OrigEqualPmtAmt, CPCC.CycleDueDTD, CPCC.AmountOfTotalDue, AmtOfPayCurrDue,
(AmtOfPayXDLate+ AmountOfPayment30DLate+ AmountOfPayment60DLate+ AmountOfPayment90DLate+ 
AmountOfPayment120DLate+ AmountOfPayment150DLate+ AmountOfPayment180DLate+ AmountOfPayment210DLate) PastDue, SRBWithInstallmentDue
, EstimatedDue, RolloverDue, CPA.DisputesAmtNS, InterestRate1, CPCC.EqualPaymentAmt, CPCC.LoanEndDate, CPCC.InterestRate1, CPCC.TCAPPaymentAmt
, CPA.plansegcreatedate, CPCC.PromoStartDate, CPCC.PromoRateEndDate
FROM CPSgmentAccounts CPA WITH (NOLOCK)
JOIN CPSgmentCreditCard CPCC WITH (NOLOCK) ON (CPA.acctId = CPCC.acctId)
LEFT JOIN CCardLookUp CL WITH (NOLOCK) ON (CL.LutCode = CPA.creditplantype AND CL.LUTid = 'CPMCrPlanType')
--WHERE CPA.acctId = 5040
WHERE CPA.parent02AID = @SrcBSAcctId


SELECT 'ILP==> ' [Table],
	BP.AccountNumber, ILPS.PlanID, ILPS.PlanUUID, ILPS.ActivityAmount, ILPS.ActivityOrder, Activity, RTRIM(CL.LutDescription) AS ActivityDescription, 
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


SELECT 'StatementHeader==> ' [Table],acctId, DateOfTotalDue, StatementDate, BeginningBalance, ccinhparent127AID, SRBWithInstallmentDue, latefeesbnp, AccountGraceStatus, minimumPaymentDue, CycleDueDTD, SystemStatus, CurrentBalance, SRBWithInstallmentDue, AmountOfTotalDue, AmtOfPayCurrDue,
(AmtOfPayXDLate+ AmountOfPayment30DLate+ AmountOfPayment60DLate+ AmountOfPayment90DLate+ 
AmountOfPayment120DLate+ AmountOfPayment150DLate+ AmountOfPayment180DLate+ AmountOfPayment210DLate) PastDue, IntBilledNotPaid, RevolvingBSFC, 
NewTransactionsBSFC, APR, InterestRate1, YTDtotalInt, AmtOfInterestCTD, AmtInterestCreditsCTD,
UserChargeOffStatus, SystemChargeOffStatus, ccinhparent125AID, CreditBalanceMovement, RevolvingBSFC
FROM StatementHeader WITH (NOLOCK)
WHERE acctId = @SrcBSAcctId AND StatementDate = @LastStatementDate

SELECT 'SummaryHeader==> ' [Table], SHCC.MaturityDate, SH.acctId, SHCC.PayOffDate, BeginningBalance, SHCC.LoanEndDate, SH.parent02AID, SH.StatementDate, APR, AccountGraceStatus, SHCC.CycleDueDTD, SHCC.DisputesAmtNS, SH.CurrentBalance, SRBWithInstallmentDue, AmountOfTotalDue, CurrentDue,
(AmtOfPayXDLate+ AmountOfPayment30DLate+ AmountOfPayment60DLate+ AmountOfPayment90DLate+ 
AmountOfPayment120DLate+ AmountOfPayment150DLate+ AmountOfPayment180DLate+ AmountOfPayment210DLate) PastDue, SHCC.PayOffDate, SHCC.LoanEndDate, CreditBalanceMovement, RevolvingBSFC
FROM SummaryHeader SH WITH (NOLOCK)
JOIN SummaryHeaderCreditCard SHCC WITH (NOLOCK) ON (SH.acctId = SHCC.acctId AND SH.StatementID = SHCC.StatementID)
WHERE SH.parent02AID = @SrcBSAcctId AND SH.StatementDate = @LastStatementDate


SELECT 'MergeAccountJob===> ' [Table], * FROM MergeAccountJob WITH (NOLOCK) WHERE (destBSAcctId = @DestBSAcctId OR SrcBSAcctId = @SrcBSAcctId)

--SELECT 'APIQueue===> ' [Table], * FROM APIQueue WITH (NOLOCK) WHERE (parent02AID IN (@DestBSAcctId, @SrcBSAcctId))


SELECT TOP(1) 'TNP Time===> ' [Table], * FROM CommonTNP WITH(NOLOCK) WHERE ATID = 60 --AND InstitutionID = 6969

SELECT 'PendingJobs_TNP===> ' [Table], * FROM CommonTNP with(nolock) where /*TranId > 0 AND*/ acctId IN (@DestBSAcctId, @SrcBSAcctId)

SELECT 'PendingJobs_APJob===> ' [Table], * FROM CommonAP with(nolock) where TranId > 0 AND acctId IN (@DestBSAcctId, @SrcBSAcctId)

SELECT * FROM ErrorTNP with(nolock) where TranId > 0 AND acctId IN (@DestBSAcctId, @SrcBSAcctId)

SELECT 'PendingJobs_CCard===> ' [Table], CMTTRANTYPE, TransactionAmount, * 
FROM CCard_Primary with(nolock) 
where TranId IN (
SELECT TranId FROM CommonTNP with(nolock) where TranId > 0 AND acctId IN (@DestBSAcctId, @SrcBSAcctId)
UNION
SELECT TranId FROM CommonAP with(nolock) where TranId > 0 AND acctId IN (@DestBSAcctId, @SrcBSAcctId))

SELECT 'ErrorJobs_CCard===> ' [Table], CMTTRANTYPE, TransactionAmount, * 
FROM CCard_Primary with(nolock) 
where TranId IN (
SELECT TranId FROM ErrorTNP with(nolock) where TranId > 0 AND acctId IN (@DestBSAcctId, @SrcBSAcctId)
UNION
SELECT TranId FROM ErrorAP with(nolock) where TranId > 0 AND acctId IN (@DestBSAcctId, @SrcBSAcctId)

)

