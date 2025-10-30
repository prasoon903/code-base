USE PP_JAZZ_CI
use PARASHAR_TEST 
USE PP_CI
USE Abhishek_CI
USE Rohit_CI
USE AMANM_CI
USE AJayswal_CI
USE NIKHILS_CC_CI
USE NishantV_CI
USE ARUN_CB_CI
USE vishalsh_cb_ci
USE Ayansh_CI
USE Krunalk_CI

--USE master
--:CONNECT XEON-S9

SELECT * FROM SYS.Servers

select TransactionDescription,* from  monetarytxncontrol     where  LogicModule  in ('02','04','06','08','10','12','14','16','18','20')

/********************************************* IMPORTANT QUERIES ************************************************************/

--GenerateStmt_Card_NEW

SELECT * FROM Version with (NOLOCK) ORDER BY 1 DESC

SELECT * FROM PostValues WITH (NOLOCK) WHERE Name = 'ORG6969'

SELECT * FROM CCardLookUp WHERE LUTid = 'IncludeExclude' ORDER BY DisplayOrdr

SELECT * FROM CCardLookUp WHERE LUTid like '%IntRateType%' ORDER BY DisplayOrdr

SELECT * FROM CCardLookUp WHERE LUTid like '%PymtMinDue%' ORDER BY DisplayOrdr

SELECT * FROM CCardLookUp WHERE LUTid like '%validation%' ORDER BY DisplayOrdr


SELECT * FROM CCardLookUp WHERE LUTid like '%mergeinprocessph%' ORDER BY DisplayOrdr

SELECT * FROM CCardLookUp WHERE LUTid like '%Merge%' ORDER BY DisplayOrdr

SELECT * FROM CCardLookUp WHERE LUTid = 'WaiveForMonths' ORDER BY DisplayOrdr

SELECT * FROM CCardLookUp with (NOLOCK) WHERE lutid like '%Reage%' 

SELECT * FROM TranCodeLookUp WHERE LUTid = 'TranCode' AND LutCode = '17158' ORDER BY DisplayOrdr

SELECT AC.defPurchasePlan, PaymentLevel, BP.ccinhparent127AID, BTA.ccinhparent108AID
FROM BSegment_Primary BP WITH (NOLOCK)
JOIN BillingTableAccounts BTA ON (BP.ccinhparent127AID = BTA.acctId)
JOIN AControlAccounts AC ON (BTA.ccinhparent108AID = AC.acctId)
WHERE BP.acctId = 2812265

SELECT *
FROM periodtable WITH (NOLOCK)
WHERE period_name = 'CTD.31'
AND period_time > '2018-08-01 00:00:00' AND period_time < '2018-10-31 23:59:59'

SELECT dbo.UDF_GetPeriodCount ('CTD.31', '2018-08-01 00:00:00', '2018-10-31 23:59:59')

SELECT TransactionDescription, ActualTranCode, ChargeOffReason,* FROM MonetaryTxnControl WITH (NOLOCK) WHERE LogicModule = '49'

SELECT * FROM MonetaryTxnControl WITH (NOLOCK) WHERE LogicModule % 2 = 1 AND LogicModule < 30 ORDER BY LogicModule

SELECT A.CBRStatusGroup, COReasonCode, A.parent01AID,C.LutDescription AS StatusGroup, A.StatusDescription,A.WaiveMinDue,A.WaiveMinDueFor,A.Priority,A.* 
FROM AStatusAccounts A WITH (NOLOCK)
JOIN CCardLookUp C WITH (NOLOCK) ON (A.parent01AID = C.LutCode)
WHERE C.LUTid = 'AsstPlan' AND C.LutLanguage = 'dbb' 
--AND A.MerchantAID = 14992 
AND A.parent01AID = 15996
ORDER BY A.Priority

SELECT CPM.acctId, CPM.CpmDescription, CL.LutDescription AS InterestPlanDesc, CPM.multiplesales, CPM.CreditPlanType, EqualPayments, CPM.InterestPlan, IT.IntRateType, CLI.LutDescription AS InterestType,
ISNULL(IT.VarInterestRate+IT.Variance1+IT.Variance2+IT.Variance3, 0) AS TotalInterest, IT.VarInterestRate, IT.Variance1, IT.Variance2, IT.Variance3, CPM.multiplesales
FROM CPMAccounts CPM WITH (NOLOCK)
JOIN InterestAccounts IT WITH (NOLOCK) ON (CPM.interestplan = IT.acctId)
LEFT OUTER JOIN CCardLookUp CL WITH (NOLOCK) ON (TRY_CONVERT(VARCHAR, IT.acctId) = CL.LUTCode AND CL.Lutid = 'InterestPlan')
LEFT OUTER JOIN CCardLookUp CLI WITH (NOLOCK) ON (TRY_CONVERT(VARCHAR, IT.IntRateType) = CLI.LUTCode AND CLI.Lutid = 'IntRateType')
WHERE CPM.CreditPlanType = '16' --AND ISNULL(IT.VarInterestRate+IT.Variance1+IT.Variance2+IT.Variance3, 0) > 0

SELECT CPM.acctId, CPM.CpmDescription, CL.LutDescription AS InterestPlanDesc, CPM.CreditPlanType, EqualPayments, CPM.InterestPlan, CPM.multiplesales
FROM CPMAccounts CPM WITH (NOLOCK)
LEFT OUTER JOIN CCardLookUp CL WITH (NOLOCK) ON (TRY_CONVERT(VARCHAR, CPM.acctId) = CL.LUTCode AND CL.Lutid = 'CpmCrPlanName')
WHERE CPM.CreditPlanType = '2' --AND ISNULL(IT.VarInterestRate+IT.Variance1+IT.Variance2+IT.Variance3, 0) > 0
ORDER BY CPM.acctId

Select distinct acctId,Parent01AID,MultipleSales,SingleSaleTranID,CurrentBalance  
 from  CPSgmentAccounts with (nolock) join XrefTable with (nolock) on   
ChildAID = acctId where  
ChildATID = 52 and parentaid = 2812265 and ParentATID = 51 and EndDate is null and parent01AID = 13776 and parent02AID = 2812265 order by CurrentBalance desc  

--------------------------------------------------------------- TNP ----------------------------------------------------------------

SELECT * FROM CommonTNP WITH(NOLOCK) WHERE ATID = 60

--DELETE FROM CommonTNP WHERE ATID NOT IN (60, 110)

select * from statementjobs with (nolock)

--EXEC USP_CreateStatementJOBReportSchedule 2812265, 2812265, 0

--DELETE FROM StatementJobs WHERE JobID = 308280

SELECT * FROM PlanInfoForReport WITH (NOLOCK) WHERE BSAcctid = 2812265 ORDER BY BusinessDay DESC

select * from CommonTNP with(nolock) where TranId > 0

SELECT * FROM ErrorTNP et WITH (NOLOCK)

SELECT * FROM PostValues WITH (NOLOCK) WHERE Name = 'MergeStatementHeader'
SELECT * FROM PostValues WITH (NOLOCK) WHERE Name = 'MergeSummaryHeader'
SELECT * FROM PP_CAuth..PostValues WITH (NOLOCK) WHERE Name LIKE '%Retail%'

SELECT * FROM sys.synonyms where name = 'SYN_CORELIBRARY_USERINFORMATION'

SELECT '[PP_CL]'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)), * FROM sys.synonyms  WHERE base_object_name like '%CL].%'
SELECT '[PP_CL]'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)), * FROM sys.synonyms  WHERE name = 'SYN_CORELIBRARY_USERINFORMATION' AND base_object_name like '%CL].%'

SELECT * FROM [PP_CL].[dbo].[userinformation]
SELECT * FROM SYN_CORELIBRARY_userinformation

------------------------------------------------------------------ ARSystem----------------------------------------------------------
SELECT * FROM ARSystemHSAccounts WITH (NOLOCK)
SELECT * FROM ARSystemAccounts WITH (NOLOCK)
--UPDATE ARSystemHSAccounts SET InstitutionID = NULL

SELECT A.* 
FROM ARSystemAccounts A WITH (NOLOCK)
JOIN Org_Balances O WITH (NOLOCK) ON (A.acctId = O.ARSystemAcctId)
WHERE O.acctId = 6969

-------------------------------------------------------------------- CCard-------------------------------------------------------------


SELECT BSAcctid, CP.PrimaryCurrencyCode, CP.TransactionCurrencyCode, CP.CMTTRANTYPE, CP.ARTxnType, CP.TxnSource,CP.TxnAcctId, CP.creditplanmaster, CP.TransactionAmount, CP.PaymentCreditFlag,
CP.TranId,CP.TranRef,CP.tranorig,CP.TransmissionDateTime,CP.atid,Trantime,CP.PostTime,CP.RevTgt,
CP.PostingRef,CS.CardAcceptorNameLocation,CP.MemoIndicator, Transactionidentifier,
CP.TxnCode_Internal,CP.NoBlobIndicator,CP.CaseID, CP.RMATranUUID, CP.TransactionDescription, 
CP.MergeActivityFlag, CP.HostMachineName, CP.ClaimID, CP.EmbAcctID, CP.ClientId, CP.PartnerId, CS.ProfileIDatAutoReage, CS.ReageTrigger
--,CP.*
FROM CCard_Primary CP WITH (NOLOCK)
LEFT JOIN CCard_Secondary CS WITH (NOLOCK) ON (CP.TranId = CS.TranId)
WHERE CP.AccountNumber IN (SELECT AccountNumber FROM BSegment_Primary WITH(NOLOCK) WHERE acctId = 2812265) 
--AND CP.TxnAcctId = 5088 --AND CP.MemoIndicator IS NULL
--AND CP.TranID IN (9877921888337920, 9596445650452480)
ORDER BY CP.PostTime DESC

SELECT OLNo, PDNoInteger, S.* 
FROM Logo_Primary P with (nolock)
JOIN Logo_Secondary S with (nolock) on (P.acctId = S.acctId)

select * from CommonTNP with(nolock) where TranId > 0

select * from ErrorTNP with(nolock)

SELECT * FROM CommonTNP WITH(NOLOCK) WHERE ATID = 60

SELECT COUNT(1), TranTime, ATID, priority
FROM CommonTNP WITH(NOLOCK)
GROUP BY TranTime, ATID, priority
ORDER BY TranTime, priority, ATID DESC

SELECT AllowCreditBalanceOnDispute, HoldCreditBalance, * FROM CPMAccounts WITH (NOLOCK) where creditplantype <> 0 and Acctid <>1

SELECT * FROM Logo_Secondary WITH (NOLOCK)
SELECT * FROM AutoReageDelinquencyRecord WITH (NOLOCK)
SELECT * from LoanModificationLog with (nolock)

SELECT * FROM sys.tables where name like '%merge%'

-------------------------------------------------------------------------- BSegment----------------------------------------------------------------------

SELECT COUNT(1) from BSegment_Primary WITH (NOLOCK) --2812265, 2812265

SELECT AccountNumber, * from BSegment_Primary WITH (NOLOCK) WHERE AccountNumber = '1100001000001581'

SELECT       bp.SystemStatus,ccinhparent125aid, bcc.AccountGraceStatus, bp.GraceDaysStatus, bcc.RevolvingBSFC, AmtofInterestCTD, bs.CTDtotalInt,bcc.AmountOfTotalDue, bp.acctId,bcc.DtOfLastDelinqCTD,bcc.AmountOfTotalDue, bcc.RemainingMinimumDue,SystemStatus,bcc.AmtOfInterestYTD,
				bcc.ReageStatus, bcc.ReageNoOfPymts,bcc.ReageDate1,bp.BillingCycle,bp.LastStatementDate,bcc.AccountOpenDate,CreatedTime,
				bp.AmountOfReturnsLTD,bp.AmountOfCreditsLTD, bp.AmountOfCreditsRevCTD,CurrentBalance, CurrentBalanceCO, bp.BeginningBalance,bp.CycleDueDTD, DRPSkipDate, 
				bp.CurrentBalance,bcc.SRBWithInstallmentDue,AmountofTotalDue, bp.AccountNumber,bs.ClientId,PaymentLevel, bcc.ChargeOffDate,bcc.ChargeOffDateParam,bs.DebitWriteOffDate,
				bcc.DateOfTotalDue,bcc.DateOfOriginalPaymentDueDTD,bs.EffectiveEndDate_Acct,bcc.FirstDueDate,bp.DateOfNextStmt,
				bp.ccinhparent125AID,bp.SystemStatus, bp.CurrentBalance, bcc.AmountOfTotalDue, bcc.ChargeOffDate, bcc.SystemChargeOffStatus, bp.LastStatementDate, bp.BeginningBalance, bp.ccinhparent125AID, bp.SystemStatus, bp.Principal, 
					bs.latefeesbnp, bcc.ChargeOffDateParam, bcc.ManualInitialChargeOffReason, bcc.IntBilledNotPaid, bp.CycleDueDTD, bp.AmtOfPayCurrDue, bp.LastPaymentRevDate, bp.BillingCycle, bcc.currentbalanceco, bcc.principalco, 
					bs.NearestEffectiveEndDate, bcc.SBWithInstallmentDue, bcc.SRBWithInstallmentDue, bp.UniversalUniqueID,bcc.AmtOfPayXDLate, ActualDRPStartDate, bcc.daysdelinquent
FROM            BSegment_Primary AS bp WITH (nolock) INNER JOIN
					BSegment_Secondary AS bs WITH (nolock) ON bp.acctId = bs.acctId INNER JOIN
					BSegmentCreditCard AS bcc WITH (nolock) ON bp.acctId = bcc.acctId INNER JOIN
					BSegment_Balances AS bsb WITH (nolock) ON bp.acctId = bsb.acctId
WHERE        (bp.acctId IN (2812265))

SELECT * FROM BSegment_Primary WITH (NOLOCK)
SELECT ManualInitialChargeOffReason,* FROM BSegmentCreditCard

SELECT        BP.acctId,BS.ClientId, BP.CustomerId,RTRIM(BP.AccountNumber) AccountNumber, BP.UniversalUniqueID, BP.SystemStatus, BP.ccinhparent125AID, ccinhparent125ATID, BP.CycleDueDTD, BP.CurrentBalance, BC.FirstDueDate, BC.DateOfOriginalPaymentDueDTD, BC.DtofLastDelinqCTD, BC.DaysDelinquent, BC.NoPayDaysDelinquent,
                         BP.BeginningBalance, BP.acctId, BC.DateOfTotalDue, BC.AmountOfTotalDue, BP.AmtOfPayCurrDue, BC.AmtOfPayXDLate, BC.AmountOfPayment30DLate, BC.AmountOfPayment60DLate, BC.AmountOfPayment90DLate, 
                         BC.AmountOfPayment120DLate, BC.AmountOfPayment150DLate, BC.AmountOfPayment180DLate, BC.AmountOfPayment210DLate, BP.LastStatementDate, BP.AmountOfDebitsCTD, BP.AmountOfPurchasesCTD, BP.BillingCycle, 
                         BP.AccountNumber, BP.CurrentBalance AS Expr2, BP.Principal, BS.servicefeesbnp, BS.latefeesbnp, AccountProperty, LAD, NAD, LAPD, DeAcctActivityDate, BP.DateOfNextStmt, PendingPrincipal
FROM            BSegment_Primary AS BP WITH (nolock) INNER JOIN
                         BSegmentCreditCard AS BC WITH (nolock) ON BP.acctId = BC.acctId INNER JOIN
                         BSegment_Secondary AS BS WITH (nolock) ON BP.acctId = BS.acctId INNER JOIN
                         BSegment_Balances AS bb WITH (NOLOCK) ON BP.acctId = bb.acctId
WHERE        (BP.acctId IN (2812265))

SELECT		
	BP.acctId, BP.SystemStatus, BP.CreditLimit, BP.ccinhparent125AID, BC.SystemChargeOffStatus, BC.ManualInitialChargeOffStartDate, BC.AutoInitialChargeOffStartDate,
	BC.ManualInitialChargeOffStartDate, BC.AutoInitialChargeOffReason, BC.ManualInitialChargeOffReason, BC.ChargeOffDateParam, BC.ChargeOffDate
FROM            BSegment_Primary AS BP WITH (nolock) INNER JOIN
                BSegmentCreditCard AS BC WITH (nolock) ON BP.acctId = BC.acctId INNER JOIN
                BSegment_Secondary AS BS WITH (nolock) ON BP.acctId = BS.acctId INNER JOIN
                BSegment_Balances AS bb WITH (NOLOCK) ON BP.acctId = bb.acctId
WHERE        (BP.acctId IN (2812265))

SELECT     BC.ReageStatus, BC.ReageDate1, BC.ReageDate2, BC.ReageDate3, BC.ReageDate4, BC.ReageDate5, BC.ReageDate6
FROM        BSegment_Primary AS BP WITH (nolock) INNER JOIN
            BSegmentCreditCard AS BC WITH (nolock) ON BP.acctId = BC.acctId INNER JOIN
            BSegment_Secondary AS BS WITH (nolock) ON BP.acctId = BS.acctId INNER JOIN
            BSegment_Balances AS bb WITH (NOLOCK) ON BP.acctId = bb.acctId
WHERE     (BP.acctId IN (2812265))

SELECT
	BP.acctId, FirstDueDate, NoPayDaysDelinquent, DaysDelinquent, DtOfLastDelinqCTD, 
	DateOfOriginalPaymentDueDTD, LAD, DeAcctActivityDate, ccinhparent125AID, ActualDRPStartDate, CycleDueDTD, SystemStatus, DaysDelinquent
FROM BsegmentCreditCard BCC WITH (NOLOCK)
INNER JOIN BSegment_Primary BP WITH (NOLOCK) ON (BP.acctId = BCC.acctId)
--WHERE BCC.DaysDelinquent > BCC.NoPayDaysDelinquent
AND BP.SystemStatus <> 14 And BillingCycle <>'LTD'

--------------------------------------------------------------------------------CPSgment CoreAuth-------------------------------------------------------------------------

SELECT * FROM PP_CAuth..CPSgmentAccounts WITH (NOLOCK)

SELECT * FROM ARUN_CB_CAuth..CPSgmentAccounts WITH (NOLOCK)

select acctId, ATID, parent01AID, parent01ATID, parent02AID, parent02ATID, CurrentBalance, ActivePlan, PlanExpiryDate, tpyNAD, tpyLAD, tpyBlob, MergeDate, MergeIndicator, MergeSourceAccountID, MergeSourcePlanID, PlanUUID, SingleSaleTranID, creditplantype, plansegcreatedate
from PP_CAuth..CPSgmentAccounts with ( nolock )
where
(PP_CAuth..CPSgmentAccounts.parent02AID = 2812265)

--------------------------------------------------------------------------------CPSgment CoreIssue-------------------------------------------------------------------------

SELECT       bcc.InterestRate1, bp.AmountOfDebitsLTD, bp.AmountOfCreditsLTD, bp.parent01AID, bcc.PayOffDate,bcc.FirstDueDate, bcc.AuthTranId, bcc.OriginalPurchaseAmount,bp.acctId,bp.parent01AID, bp.parent02AID,PaymentStartDate, InterestStartDate,CounterForEqualPayment, bp.AmountOfCreditsCTD, bp.AmountOfCreditsRevCTD,bcc.OrigEqualPmtAmt, bp.AmountOfReturnsLTD, bp.AmountOfReturnsCTD, bp.AmountOfPaymentsCTD,BeginningBalance, bp.CurrentBalance, CurrentBalanceCO, bp.Principal,bcc.principalco,bcc.SRBWithInstallmentDue, bcc.AmountOfTotalDue, bp.AmountOfCreditsLTD, bcc.AmountOfCreditsRevLTD,bcc.CardAcceptorNameLocation,
              bcc.AmtOfPayCurrDue, bcc.CoreAuthTranID, bcc.AmountOfCreditsAsPmtCTD,bp.AmountOfPaymentsCTD, bp.AmountOfDebitsRevCTD, bcc.IntBilledNotPaid, bcc.PlanUUID, bcc.CPSUniversalUniqueID, bp.InvoiceNumber, bcc.DateOfTotalDue, 
              bcc.InterestRate4, bp.parent01AID AS Expr2, bp.cpsinterestplan, bcc.AuthTranId AS Expr3, bp.CurrentBalance AS Expr4, bp.Principal, bp.latefeesbnp, bcc.IntBilledNotPaid AS Expr5, bp.recoveryfeesbnp, 
              bp.NSFFeesBilledNotPaid, bcc.CycleDueDTD, bp.MembershipFeesBNP, bp.creditplantype, bcc.PurchaseRevCTD_InCycle, bp.AmountOfDebitsRevCTD AS Expr6, bp.AmountOfCreditsRevCTD, bp.CounterForEqualPayment, 
              bcc.SRBWithInstallmentDue AS Expr7, bcc.SBWithInstallmentDue AS Expr8
FROM            CPSgmentAccounts AS bp WITH (nolock) INNER JOIN
                         CPSgmentCreditCard AS bcc WITH (nolock) ON bp.acctId = bcc.acctId
WHERE        (bp.parent02AID IN (2812265)) --and bcc.acctId = 5100
ORDER BY bp.parent02AID

SELECT * FROM CPSgmentCreditCard WITH (NOLOCK)

SELECT CPA.acctId, CPCC.PlanUUID, CPA.CurrentBalance, CPCC.IntBilledNotPaid,
CPCC.MergeIndicator, CPCC.MergeDate, CPCC.OriginalPurchaseAmount,
CPA.parent02AID, CPA.parent01AID,CPA.CurrentBalance AS [Total balance outstanding],
amountofpaymentsctd,AmountOfCreditsAsPmtCTD,AmountOfCreditsCTD,CPCC.SBWithInstallmentDue,
CPCC.SRBWithInstallmentDue AS [Current Statement balance min due @ cycle end],
CPCC.FirstDueDate,
CPCC.AmountOfTotalDue AS [Payment due],
CPCC.CycleDueDTD,
CPCC.AmtOfPayCurrDue,
CPA.AmountOfPaymentsCTD, CPCC.AmtOfInterestLTD,
CASE WHEN ISNULL(CPCC.CycleDueDTD, 0) < 2 THEN 'Current' ELSE 'Delinquent' END AS Delinquency,
CASE 
	WHEN CPA.creditplantype = '16' THEN 'RETAIL'
	WHEN CPA.creditplantype = '10' THEN 'RRC'
	ELSE 'Normal Plan' END AS PlanType
FROM CPSgmentAccounts CPA WITH (NOLOCK)
JOIN CPSgmentCreditCard CPCC WITH (NOLOCK) ON (CPA.acctId = CPCC.acctId)
--WHERE CPA.acctId = 5040
WHERE CPA.parent02AID = 2812265


SELECT CPA.acctId,
CASE 
	WHEN CPA.creditplantype = '16' THEN 'RETAIL'
	WHEN CPA.creditplantype = '10' THEN 'RRC'
	ELSE 'Normal Plan' END AS PlanType, 
CPCC.PlanUUID, CPA.CurrentBalance, CPCC.EqualPaymentAmt, CPCC.OrigEqualPmtAmt, CPCC.AmountOfTotalDue, --EstimatedDue, RolloverDue,
CPCC.MergeIndicator, CPA.CounterForEqualPayment, EqualPayments, 
TermCmplDate, CPA.DisputesAmtNS, CPA.InvoiceNumber, CPA.SingleSaleTranID, CPCC.OriginalPurchaseAmount,
CPA.parent02AID, CPA.parent01AID,
CPCC.FirstDueDate,
CPCC.AmountOfTotalDue AS [Payment due],
CPCC.CycleDueDTD,
CPCC.AmtOfPayCurrDue,
CPA.AmountOfPaymentsCTD, CPCC.AmtOfInterestLTD,
CASE WHEN ISNULL(CPCC.CycleDueDTD, 0) < 2 THEN 'Current' ELSE 'Delinquent' END AS Delinquency,
CPCC.RetailAniversaryDate, CPA.plansegcreatedate, CPCC.MergeDate
FROM CPSgmentAccounts CPA WITH (NOLOCK)
JOIN CPSgmentCreditCard CPCC WITH (NOLOCK) ON (CPA.acctId = CPCC.acctId)
--WHERE CPA.acctId = 5040
WHERE CPA.parent02AID = 2812265


SELECT * FROM CommonTNP WITH (NOLOCK) WHERE ATID = 60 

SELECT * FROM CommonTNP WITH (NOLOCK) WHERE TranID > 0

--18031209253295278

--UPDATE CPSgmentAccounts SET CurrentBalance = CurrentBalance - 1 WHERE acctId = 5088

--UPDATE CPSgmentCreditCard SET FirstDueDate = '2018-02-10 23:59:57.000' WHERE acctId = 5078

SELECT * FROM PurchaseReversalRecord WITH (NOLOCK)

SELECT ChangeStatusFor,* FROM NonMonetaryLog WITH (NOLOCK) ORDER BY Skey DESC

SELECT * FROM CCardLookUp with (NOLOCK) WHERE lutid like '%reage%' 

SELECT TransactionAmount,* FROM LoyaltyTransactionMessage WITH (NOLOCK) WHERE AccountNumber IN (
SELECT AccountNumber FROM BSegment_Primary WITH(NOLOCK) WHERE acctId = 2812265) 
ORDER BY PostTime DESC

---------------------------------------------------------------------------------DISPUTE------------------------------------------------

select * from disputestatuslog WHERE DisputeID = 1994  and DisputeStage = '0'

select disputeid,* from disputestatuslog with(nolock) WHERE disputestage <> 0 and DisputeResolveReverse <> 1

select * from disputestatuslog with (nolock) where caseid = 10724 and  disputestage <> 0 and DisputeResolveReverse <> 1

select DisputeID,* FROM disputestatuslog with (nolock) where caseid = 10726 and  disputestage IN (0,17)

select * from disputelog with (nolock) where DisputeID = 1994

SELECT * FROM DisputeStatusLog WITH (NOLOCK) WHERE ClaimID = '117'

select  top 1 DisputeID, DisputeTranID, DisputeTranCode, InitiationSource, DisputePlanSegment, DisputeAmount, PrimaryCurrencyCode, DisputeInitiated, InitiateUsrID, DisputeStage, DisputeResolved, DisputeReason, ResolveUserID, Notes, CreditPlanMaster1, TransactionAmount1, CreditPlanMaster2, TransactionAmount2, CreditPlanMaster3, TransactionAmount3, CreditPlanMaster4, TransactionAmount4, SKey, DispResolveStatus, CaseID, DisputeWriteoffAmount, DisputeWriteoffTrancode, DisputeWriteoffTranID, TransactionLifeCycleUniqueID, PurchaseTranId, DisputePurchaseTranID, DisputeResolveReverse, DisputeMerchantChangeback, Partialdisputestage, PartialDispTotalResolveAmt, ClaimID, ExtraPrincipleTranid, ExtraPrincipleAmount
from PP_CI..DisputeStatusLog with ( nolock )
where
PP_CI..DisputeStatusLog.ClaimID = '65286662-bc6b-4dbf-88e9-fd5397892ffb' AND PP_CI..DisputeStatusLog.DisputeTranCode = '110'

select  top 1 
PP_CI..DisputeStatusLog.DisputePurchaseTranID, 
PP_CI..DisputeLog.PurchaseTranId, 
PP_CI..DisputeLog.PurchaseTxnCode_Internal, 
PP_CI..DisputeLog.TransactionLifeCycleUniqueID,
DisputeInitiated
from PP_CI..DisputeStatusLog with ( nolock ), PP_CI..DisputeLog with ( nolock )
where
((PP_CI..DisputeLog.BSAcctid = 2812265) 
AND (PP_CI..DisputeLog.DisputeID = PP_CI..DisputeStatusLog.DisputeID) 
AND (PP_CI..DisputeStatusLog.ClaimID = '06dc67ed-f2f7-412e-bf7a-0bfa36bfc7d2') 
AND (PP_CI..DisputeStatusLog.DisputeStage = '0'))

--------------------------------------------------------------------------STATEMENT------------------------------------------------------

SELECT        bp.acctId, bp.StatementID, bcc.DisputesAmtNS, bcc.CreditBalanceMovement, bcc.PayOffDate, bcc.AccountGraceStatus,bcc.DateOfTotalDue,CounterForEqualPayment, bp.AmountOfReturnsLTD, InterestStartDate, bp.StatementDate, bp.CurrentBalance, bcc.currentbalanceco, bcc.EqualPaymentAmt, bcc.SRBWithInstallmentDue,/*ManualPurchaseReversal_CTD, ManualPurchaseReversal_LTD ,*/bcc.PayOffDate, bcc.OriginalPurchaseAmount,
			bp.AmountOfReturnsCTD,SRBWithInstallmentDueCC1,bcc.SingleSaleTranID,CardAcceptorNameLocation,bcc.LoanEndDate,MaturityDate,bcc.PlanUUID, bcc.DailyCashPercent, bcc.DailyCashAmount,
						bp.AmountOfTotalDue, bcc.CurrentDue,bcc.JobID,bcc.DateOfTotalDue, bcc.SRBWithInstallmentDue, bp.plansegcreatedate, bcc.RetailAniversaryDate, bcc.SBWithInstallmentDue, bcc.AmountOfCreditsAsPmtCTD,AmountOfCreditsRevCTD, bp.AmountOfDebitsCTD, bp.AmountOfDebitsRevCTD, bp.APR, bp.acctId, bcc.AccountGraceStatus, 
                         bp.Principal, bcc.CycleDueDTD, bcc.CurrentDue, bcc.AmtOfPayXDLate, bcc.AmountOfPayment30DLate, bcc.AmountOfPayment60DLate, 
                         bcc.AmountOfPayment90DLate, bcc.AmountOfPayment120DLate, bcc.AmountOfPayment150DLate, bcc.AmountOfPayment180DLate, bcc.AmountOfPayment210DLate, bp.IntBilledNotPaid
						 --,ClientID
FROM            SummaryHeader AS bp WITH (nolock) INNER JOIN
                         SummaryHeaderCreditCard AS bcc WITH (nolock) ON bp.acctId = bcc.acctId AND bp.StatementID = bcc.StatementID
WHERE        (bp.parent02AID IN (2812265)) --AND bcc.acctId = 2812265
ORDER BY bp.StatementDate DESC

SELECT        StatementDate, ccinhparent125AID, bp.AccountGraceStatus, bp.SRBWithInstallmentDue, bp.AmountOfCreditsCTD
, ActualDRPStartDate, 
bp.StatementID,bp.WaiveMinDue, bp.Principal,SystemStatus,bp.ccinhparent125AID,bp.StatementDate,bp.ccinhparent125AID, SRBWithInstallmentDue,bp.SRBwithInstallmentDueCC1,bp.DateOfTotalDue,CTDtotalFees, acctId, CreditLimit, CurrentBalance, Principal, CycleDueDTD, AmountOfTotalDue, NewTransactionsBSFC, RevolvingBSFC, TotalBSFC, IntBilledNotPaid, AmtOfPayCurrDue, SRBWithInstallmentDue, 
                         SBWithInstallmentDue,*
FROM            StatementHeader AS bp WITH (nolock)
WHERE        (acctId IN (2812265))
ORDER BY bp.StatementDate DESC

SELECT PastDueSucessfulPaymentCounterCTD, PastDueExcessPaymentCounterCTD, * FROM StatementHeaderEX WITH (NOLOCK)

SELECT * FROM CurrentBalanceAuditPS WITH (NOLOCK) WHERE TID = 3278 AND DENAME = 111

SELECT * FROM CurrentBalanceAuditPS WITH (NOLOCK) WHERE AID = 5088 AND DENAME = 111


SELECT * FROM LogPastDuePayment WITH (NOLOCK)

--UPDATE SH
--SET SH.ActualDRPStartDate = AIR.ActualDRPStartDate
--FROM StatementHeader SH
--JOIN AccountInfoForReport AIR WITH (NOLOCK) ON (SH.acctId = AIR.BSAcctid AND SH.StatementDate = AIR.BusinessDay)


/****************************************************************************************************************************/

SELECT AccountGraceStatus, ccinhparent125AID, AccountGraceStatus,*
FROM AccountInfoForReport WITH (NOLOCK)
WHERE BSacctId = 2812265
ORDER BY BusinessDay DESC


SELECT * FROM PaymentHoldDetails WITH (NOLOCK)
SELECT * FROM IntradayAccountOTBRule_Internal WITH (NOLOCK)
SELECT * FROM IntraDayAccountOTBRule_External WITH (NOLOCK)

select * from CurrentBalanceAuditPS
where aid = 5087 and dename = 111




SELECT ccinhparent108AID, ccinhparent111AID, BillingTableName, CL.LutDescription,* 
FROM BillingTableAccounts BT WITH (NOLOCK)
LEFT OUTER JOIN CCardLookUp CL ON (BT.BTType = CL.LutCode AND CL.LUTid = 'BillingTableType')
WHERE BT.BTType = 2

SELECT IntRateType,MinimumInterestRate, Variance1, VarInterestRate, FixedRate1,* 
FROM InterestAccounts WITH (NOLOCK) 
WHERE acctId = 9516

SELECT defPurchasePlan,* FROM AControlAccounts WITH (NOLOCK) WHERE acctId = 9966

SELECT * FROM CPSgmentAccounts WITH (NOLOCK) WHERE parent02AID = 2812265

SELECT underpmtpriority,interestplan,* FROM CPMAccounts WITH (NOLOCK) WHERE acctId = 13750


SELECT AC.PaymentLevel,AC.defPurchasePlan, BP.ccinhparent127AID, BTA.ccinhparent108AID
FROM BSegment_Primary BP WITH (NOLOCK)
JOIN BillingTableAccounts BTA ON (BP.ccinhparent127AID = BTA.acctId)
JOIN AControlAccounts AC ON (BTA.ccinhparent108AID = AC.acctId)
WHERE BP.acctId = 2812265


SELECT * FROM CCardLookUp WITH (NOLOCK) WHERE LUTid LIKE '%BillingTableType%'


SELECT intplanoccurr,* FROM CPMAccounts WITH (NOLOCK) WHERE acctId = 13772

SELECT * FROM BillingTableAccounts WITH (NOLOCK) WHERE acctId = 10563


SELECT AC.PaymentLevel,AC.defPurchasePlan, BP.ccinhparent127AID BillingTable, BTA.ccinhparent108AID
FROM BSegment_Primary BP WITH (NOLOCK)
JOIN BillingTableAccounts BTA ON (BP.ccinhparent127AID = BTA.acctId)
JOIN AControlAccounts AC ON (BTA.ccinhparent108AID = AC.acctId)
WHERE BP.acctId = 2812265

SELECT * FROM BillingGroup where billinggroup =9935


SELECT BTA.acctId BillingTable, BTA.BillingTableName, IA.acctId, CL.LutDescription InterestType, IA.FixedRate1, Variance1, VarInterestRate, 
CASE WHEN IA.IntRateType = 0 THEN IA.FixedRate1 ELSE Variance1 + VarInterestRate END TotalInterest 
FROM InterestAccounts IA WITH (NOLOCK) 
LEFT OUTER JOIN CCardLookUp CL WITH (NOLOCK) ON (CL.lutid = 'IntRateType' AND IA.IntRateType = TRY_CONVERT(INT, CL.LutCode))
JOIN BillingTableAccounts BTA WITH (NOLOCK) ON (BTA.ccinhparent111AID = IA.acctId)


SELECT IA.acctId, CL.LutDescription InterestType, IA.FixedRate1, Variance1, VarInterestRate, 
CASE WHEN IA.IntRateType = 0 THEN IA.FixedRate1 ELSE Variance1 + VarInterestRate END TotalInterest 
FROM InterestAccounts IA WITH (NOLOCK) 
LEFT OUTER JOIN CCardLookUp CL WITH (NOLOCK) ON (CL.lutid = 'IntRateType' AND IA.IntRateType = TRY_CONVERT(INT, CL.LutCode))





DECLARE @AccountID INT, @CPM INT, @BillingTable INT, @InterestPlan INT, @PlanOccurance INT

SET @AccountID = 2812265
SET @CPM = 13750
--SET @BillingTable = 10557



SELECT @BillingTable = ccinhparent127AID FROM BSegment_Primary BP WITH (NOLOCK) WHERE acctId = @AccountID

SELECT @PlanOccurance = intplanoccurr FROM CPMAccounts CPM WITH (NOLOCK) WHERE CPM.acctId = @CPM

SELECT @InterestPlan =	CASE
							WHEN @PlanOccurance = 1 THEN ccinhparent111AID
							WHEN @PlanOccurance = 2 THEN ccinhparent112AID
							WHEN @PlanOccurance = 3 THEN ccinhparent113AID
							WHEN @PlanOccurance = 4 THEN ccinhparent114AID
							ELSE 0
						END
FROM BillingTableAccounts WITH (NOLOCK) WHERE acctId = @BillingTable


SELECT CL.LutDescription InterestType, IA.FixedRate1, Variance1, VarInterestRate, 
CASE WHEN IA.IntRateType = 0 THEN IA.FixedRate1 ELSE Variance1 + VarInterestRate END TotalInterest 
FROM InterestAccounts IA WITH (NOLOCK) 
LEFT OUTER JOIN CCardLookUp CL WITH (NOLOCK) ON (CL.lutid = 'IntRateType' AND IA.IntRateType = TRY_CONVERT(INT, CL.LutCode))
WHERE IA.acctId = @InterestPlan


