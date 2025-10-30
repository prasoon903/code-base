use PP_TEST 
USE PP_CI
USE Rohit_CI
USE AJayswal_CI
USE NIKHILS_CC_CI
USE NishantV_CI
USE ARUN_CB_CI
USE vishalsh_cb_ci
USE Ayansh_CI
USE kk_CI

--USE master
--:CONNECT XEON-S9

SELECT * FROM SYS.Servers

select TransactionDescription,* from  monetarytxncontrol     where  LogicModule  in ('02','04','06','08','10','12','14','16','18','20')

/********************************************* IMPORTANT QUERIES ************************************************************/

--GenerateStmt_Card_NEW

SELECT * FROM Version with (NOLOCK) ORDER BY 1 DESC

SELECT * FROM PostValues WITH (NOLOCK) WHERE Name = 'ORG6969'

SELECT * FROM CCardLookUp WHERE LUTid = 'EPPReasonCode' ORDER BY DisplayOrdr

SELECT * FROM CCardLookUp WHERE LUTid like '%MrgActivityFlag%' ORDER BY DisplayOrdr

SELECT * FROM CCardLookUp WHERE LUTid like '%PymtMinDue%' ORDER BY DisplayOrdr

SELECT * FROM CCardLookUp WHERE LUTid like '%LgRetCredBhvr%' ORDER BY DisplayOrdr


SELECT * FROM CCardLookUp WHERE LUTid like '%payment%' ORDER BY DisplayOrdr

SELECT * FROM CCardLookUp WHERE LUTid like '%Merge%' ORDER BY DisplayOrdr

SELECT * FROM CCardLookUp WHERE LUTid = 'WaiveForMonths' ORDER BY DisplayOrdr

SELECT * FROM CCardLookUp with (NOLOCK) WHERE lutid like '%Reage%' 

SELECT * FROM TranCodeLookUp WHERE LUTid = 'TranCode' AND LutCode = '17158' ORDER BY DisplayOrdr

SELECT AC.defPurchasePlan, PaymentLevel, BP.ccinhparent127AID, BTA.ccinhparent108AID
FROM BSegment_Primary BP WITH (NOLOCK)
JOIN BillingTableAccounts BTA ON (BP.ccinhparent127AID = BTA.acctId)
JOIN AControlAccounts AC ON (BTA.ccinhparent108AID = AC.acctId)
WHERE BP.acctId = 2830360

SELECT *
FROM periodtable WITH (NOLOCK)
WHERE period_name = 'CTD.31'
AND period_time > '2018-08-01 00:00:00' AND period_time < '2018-10-31 23:59:59'

SELECT dbo.UDF_GetPeriodCount ('CTD.31', '2018-08-01 00:00:00', '2018-10-31 23:59:59')

SELECT TransactionDescription, ActualTranCode, ChargeOffReason, PlanType,* FROM MonetaryTxnControl WITH (NOLOCK) WHERE LogicModule = '43'

SELECT * FROM MonetaryTxnControl WITH (NOLOCK) WHERE LogicModule % 2 = 1 AND LogicModule < 30 ORDER BY LogicModule
0

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
WHERE CPM.CreditPlanType = '0' --AND ISNULL(IT.VarInterestRate+IT.Variance1+IT.Variance2+IT.Variance3, 0) > 0
ORDER BY CPM.acctId

Select distinct acctId,Parent01AID,MultipleSales,SingleSaleTranID,CurrentBalance  
 from  CPSgmentAccounts with (nolock) join XrefTable with (nolock) on   
ChildAID = acctId where  
ChildATID = 52 and parentaid = 2830360 and ParentATID = 51 and EndDate is null and parent01AID = 13776 and parent02AID = 2830360 order by CurrentBalance desc  

--------------------------------------------------------------- TNP ----------------------------------------------------------------

SELECT * FROM CommonTNP WITH(NOLOCK) WHERE ATID = 60

select * from statementjobs with (nolock)

--EXEC USP_CreateStatementJOBReportSchedule 2830360, 2830360, 0

--DELETE FROM StatementJobs WHERE JobID = 308280

SELECT * FROM PlanInfoForReport WITH (NOLOCK) WHERE BSAcctid = 2830360 ORDER BY BusinessDay DESC

select * from CommonTNP with(nolock) where TranId > 0

SELECT * FROM ErrorTNP et WITH (NOLOCK)

SELECT * FROM PostValues WITH (NOLOCK) WHERE Name = 'MergeStatementHeader'
SELECT * FROM PostValues WITH (NOLOCK) WHERE Name = 'MergeSummaryHeader'
SELECT * FROM PP_CAuth..PostValues WITH (NOLOCK) WHERE Name LIKE '%Retail%'

--UPDATE PP_CAuth..PostValues SET Seq = 1000 WHERE Name = 'RetailAPILineItems'
--UPDATE PP_CAuth..PostValues SET Seq = 1000 WHERE Name = 'RetailAPILog'

--EXEC USP_PDF_ReprocessErrorTnpJobs 2830360,51,NULL
--DELETE FROM CommonTNP WHERE ATID NOT IN (60, 110)
--update  PP_CL..apicallsetup SET host='Xeon-web1', url='/PrasoonP/PrasoonPAddManualStatusToAccount.aspx' 
--WHERE APINAME = 'svcAddManualStatusToAccount'
--UPDATE Logo_Secondary SET RetailLog = 1 WHERE acctId <> 1

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

----------------------------------------------------------------------- AUTH-----------------------------------------------------
SELECT TxnSource,TransactionAmount,MonthlyPaymentAmount, AuthStatus,CoreAuthTranId,planuuid,retailtranid,MessageTypeIdentifier,ProcCode,
* FROM Auth_Primary with (nolock) WHERE AccountNumber = '1100001000000013'
ORDER BY posttime DESC

SELECT AuthStatus,CreditPlanNumber,AP.creditplanmaster,MessageTypeIdentifier, FileName,MonthlyPaymentAmount,RetailFlag,A.CardholderBillingAmount, a.* 
FROM Auth_Primary AP WITH (NOLOCK)
LEFT JOIN Auth_Secondary A WITH (NOLOCK) ON (AP.TranId = A.TranId)
LEFT JOIN Auth_Frys AF WITH (NOLOCK) ON (AF.TranId = A.TranId)
WHERE AP.AccountNumber = '1100001000000013' 
--AND AP.PlanUUID = 'a2a153fc-3639-489d-ab68-de6801de28fc'
AND AP.MessageTypeIdentifier = '0100' AND AP.RetailFlag = 1 AND AP.AuthStatus = 0

SELECT A.MTI,a.* FROM SYN_CoreAuth_RetailAPILineItems A WITH (NOLOCK)
JOIN SYN_CoreAuth_RetailAPILog B WITH (NOLOCK) ON (A.request_id = B.request_id)
WHERE 
--A.request_id = '20d5731e-d669-405c-acbf-d7ef502effc4' AND
B.AccountNumber = '1100001000000021' AND 
uuid = 'e1c07ka2-f490-4575-83k5-78f8bbk6adA1'


select  JobStatus,transactionamount,* from PP_cauth..CoreissueAuthMessage with(nolock) 

select  JobStatus,transactionamount,* from PP_cauth..RetailAuthJobs with(nolock) where JobStatus = 'NEW'

select  COUNT(1) from PP_cauth..CoreissueAuthMessage with(nolock) where JobStatus = 'NEW'
select  COUNT(1) from PP_cauth..CoreissueAuthMessage with(nolock) where JobStatus = 'Error'

select  COUNT(1) from PP_cauth..RetailAuthJobs with(nolock) where JobStatus = 'NEW'
select  COUNT(1) from PP_cauth..RetailAuthJobs with(nolock) where JobStatus = 'ERROR'

SELECT * FROM sys.tables where name like '%retail%'

--UPDATE PP_cauth..RetailAuthJobs SET JobStatus = 'New' where TranID = 1025008

-------------------------------------------------------------------- CCard-------------------------------------------------------------

use PARASHAR_TEST 
USE PP_CI

select * from monetarytxncontrol  with(nolock)   where  transactioncode  = 17245   

SELECT insurancefeesbnp, IntBilledNotPaid,CurrentBalance,* FROM CurrentSummaryHeader WITH (NOLOCK) WHERE acctId IN (40755607, 40755608, 40755609)
ORDER BY StatementDate

SELECT insurancefeesbnp,CurrentBalance,* FROM PARASHAR_TEST..CurrentSummaryHeader WITH (NOLOCK) WHERE acctId = 40755608
SELECT insurancefeesbnp,CurrentBalance,* FROM PP_CoreApp..CurrentSummaryHeader WITH (NOLOCK) WHERE acctId = 40755608

SELECT insurancefeesbnp,CurrentBalance,* FROM SummaryHeader WITH (NOLOCK) WHERE acctId = 40755608


select * from DisputeLog D  join  DisputeStatusLog  DL  on  (D.DisputeID = DL.DisputeID)
where  DL.ClaimID ='1a10ad57-19ae-4cd4-93a6-f880ea0acdf6'

select * from DisputestatusLog where ClaimID ='10159513109397505'
select  * from  CurrentBalanceAudit  with(nolock)  where aid = 2830360 order by businessday   desc


select  * from  CurrentBalanceAuditps  with(nolock)  where  aid  in  (40755632,40755634,40755637)
and businessday > '2018-09-30 23:59:57.000'order by businessday   desc ,aid


SELECT BSAcctid, CP.CMTTRANTYPE, CP.ARTxnType, CS.FeeProcessingCode, CP.TxnSource,CP.TxnAcctId, CP.creditplanmaster, CP.TransactionAmount, CP.PaymentCreditFlag,
CP.TranId,CP.TranRef,CP.tranorig,CP.TransmissionDateTime,CP.atid,Trantime,CP.PostTime,CP.RevTgt,
CP.PostingRef,CS.CardAcceptorNameLocation,CP.MemoIndicator, Transactionidentifier,
CP.TxnCode_Internal,CP.NoBlobIndicator,CP.CaseID, CP.RMATranUUID, CP.TransactionDescription, 
CP.MergeActivityFlag, CP.HostMachineName, CP.ClaimID, CP.EmbAcctID, CP.ClientId, CP.PartnerId, CS.ProfileIDatAutoReage, CS.ReageTrigger
--,CP.*
FROM CCard_Primary CP WITH (NOLOCK)
LEFT JOIN CCard_Secondary CS WITH (NOLOCK) ON (CP.TranId = CS.TranId)
WHERE CP.AccountNumber IN (SELECT AccountNumber FROM BSegment_Primary WITH(NOLOCK) WHERE acctId = 2830360) 
--AND CP.TxnAcctId = 5088 --AND CP.MemoIndicator IS NULL
--AND CP.TranID IN (9877921888337920, 9596445650452480)
ORDER BY CP.PostTime DESC

SELECT * FROm ILPScheduleDetailsBAD_Archive

SELECT DutyAmount, MessageTypeIdentifier, ActionDate, JulianProSubDate, TheFinancialNetworkCode, POSDiscountAmount, CP.EmbAcctID,CP.UniversalUniqueID,
PhysicalSource, BSAcctid, CP.CMTTRANTYPE,CP.TxnAcctId, CS.InvoiceNumber, txnsource, 
CP.creditplanmaster, CP.TransactionAmount, CP.RMATranUUID,
CP.TranId,CP.TranRef,CP.tranorig,CP.TransmissionDateTime,CP.atid,Trantime,CP.PostTime,CP.RevTgt,
CP.PostingRef,CS.CardAcceptorNameLocation,CP.MemoIndicator, Transactionidentifier,
CP.TxnCode_Internal,CP.ARTxnType,CP.NoBlobIndicator,CP.CaseID, CP.RMATranUUID, CP.CardAcceptorIdCode, CP.TransactionDescription, 
CP.ClientId, Transactionidentifier, NetFeeAmount, WarehouseTxnDate, CP.FleetRepricing, InterchangeFeeAmount, PaymentScheduleUUID,
FeesAcctID, CP.CPMgroup, CP.MessageIdentifier, CP.MergeActivityFlag, CP.ClaimID,CentSiteProcDateOMess, CS.BillingMethodCT,
CS.ReconciliationDate, CS.AdditionalResponseData
--,CP.*
FROM CCard_Primary CP WITH (NOLOCK)
LEFT JOIN CCard_Secondary CS WITH (NOLOCK) ON (CP.TranId = CS.TranId)
LEFT JOIN CCardTransactionMC CM WITH (NOLOCK) ON (CM.TranId = CS.TranId)
WHERE CP.AccountNumber IN (SELECT AccountNumber FROM BSegment_Primary WITH(NOLOCK) WHERE acctId = 2830360) 
--AND CP.TxnAcctId = 5098 --AND CP.MemoIndicator IS NULL
ORDER BY CP.PostTime DESC
--SBWithInstallmentDue  =985.67
--StatementRemainingBalance =550.00 
--StatementRunningBalance =550.00
--SRBWithInstallmentDue =985.67

--select  StatementBalance   from  logo_secondary

--1085.67	2085.67	2085.67	1085.67

select CMTTRANTYPE, TranId, TranRef, tranorig, RevTgt, TransactionAmount, creditplanmaster,PaymentScheduleUUID, PaymentReferenceId, 
MessageIdentifier, Transactionidentifier, ClientId, CustomerId, MergeActivityFlag, * 
from CCard_Primary with(nolock)  
where TxnacctId = 5110
--WHERE CMTTRANTYPE IN ('110', '43')
ORDER BY PostTime DESC

SELECT * FROM CCard_Primary WITH (NOLOCK) WHERE TranId IN (81091)
SELECT * FROM CCard_Primary WITH (NOLOCK) WHERE TranRef IN (81091)

SELECT OLNo, PDNoInteger, S.RetrunCr_InterestGrace, S.InterestGraceDecisionOn, S.CreditsTreatAsPayment, P.ReturnsCreditsBehavior, S.* 
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

SELECT COUNT(1) from BSegment_Primary WITH (NOLOCK) --2830360, 2830360

SELECT * FROM DelinquencyFreezeCycle

SELECT AccountNumber, * from BSegment_Primary WITH (NOLOCK) WHERE AccountNumber = '1100001000001698'

SELECT       bp.FamilyAccount, bp.GraceDayCutoffDate, bs.ClientId, bsb.DPDFreezeDays, bs.IsAcctMLA,bp.SystemStatus,ccinhparent125aid, bcc.AccountGraceStatus, bp.GraceDaysStatus, bcc.RevolvingBSFC, AmtofInterestCTD, bs.CTDtotalInt,bcc.AmountOfTotalDue, bp.acctId,bcc.DtOfLastDelinqCTD,bcc.AmountOfTotalDue, bcc.RemainingMinimumDue,SystemStatus,bcc.AmtOfInterestYTD,
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
WHERE        (bp.acctId IN (2830360))

SELECT * FROM BSegment_Primary WITH (NOLOCK)
SELECT ManualInitialChargeOffReason,* FROM BSegmentCreditCard

SELECT        BP.acctId,BS.ClientId, BP.CustomerId,RTRIM(BP.AccountNumber), BP.UniversalUniqueID, BP.SystemStatus, BP.ccinhparent125AID, ccinhparent125ATID, BP.CycleDueDTD, BP.CurrentBalance, BC.FirstDueDate, BC.DateOfOriginalPaymentDueDTD, BC.DtofLastDelinqCTD, BC.DaysDelinquent, BC.NoPayDaysDelinquent,
                         BP.BeginningBalance, BP.acctId, BC.DateOfTotalDue, BC.AmountOfTotalDue, BP.AmtOfPayCurrDue, BC.AmtOfPayXDLate, BC.AmountOfPayment30DLate, BC.AmountOfPayment60DLate, BC.AmountOfPayment90DLate, 
                         BC.AmountOfPayment120DLate, BC.AmountOfPayment150DLate, BC.AmountOfPayment180DLate, BC.AmountOfPayment210DLate, BP.LastStatementDate, BP.AmountOfDebitsCTD, BP.AmountOfPurchasesCTD, BP.BillingCycle, 
                         BP.AccountNumber, BP.CurrentBalance AS Expr2, BP.Principal, BS.servicefeesbnp, BS.latefeesbnp, AccountProperty, LAD, NAD, LAPD, DeAcctActivityDate, BP.DateOfNextStmt
FROM            BSegment_Primary AS BP WITH (nolock) INNER JOIN
                         BSegmentCreditCard AS BC WITH (nolock) ON BP.acctId = BC.acctId INNER JOIN
                         BSegment_Secondary AS BS WITH (nolock) ON BP.acctId = BS.acctId INNER JOIN
                         BSegment_Balances AS bb WITH (NOLOCK) ON BP.acctId = bb.acctId
WHERE        (BP.acctId IN (2830360))

SELECT		
	BP.acctId, BP.SystemStatus, BP.CreditLimit, BP.ccinhparent125AID, BC.SystemChargeOffStatus, BC.ManualInitialChargeOffStartDate, BC.AutoInitialChargeOffStartDate,
	BC.ManualInitialChargeOffStartDate, BC.AutoInitialChargeOffReason, BC.ManualInitialChargeOffReason, BC.ChargeOffDateParam, BC.ChargeOffDate
FROM            BSegment_Primary AS BP WITH (nolock) INNER JOIN
                BSegmentCreditCard AS BC WITH (nolock) ON BP.acctId = BC.acctId INNER JOIN
                BSegment_Secondary AS BS WITH (nolock) ON BP.acctId = BS.acctId INNER JOIN
                BSegment_Balances AS bb WITH (NOLOCK) ON BP.acctId = bb.acctId
WHERE        (BP.acctId IN (2830360))

SELECT     BC.ReageStatus, BC.ReageDate1, BC.ReageDate2, BC.ReageDate3, BC.ReageDate4, BC.ReageDate5, BC.ReageDate6
FROM        BSegment_Primary AS BP WITH (nolock) INNER JOIN
            BSegmentCreditCard AS BC WITH (nolock) ON BP.acctId = BC.acctId INNER JOIN
            BSegment_Secondary AS BS WITH (nolock) ON BP.acctId = BS.acctId INNER JOIN
            BSegment_Balances AS bb WITH (NOLOCK) ON BP.acctId = bb.acctId
WHERE     (BP.acctId IN (2830360))

SELECT * FROM ReagedAccounts WITH (NOLOCK)

SELECT * FROM ManualAgeOffLog

SELECT * FROM LoanModificationLog WITH (NOLOCK) WHERE acctId = 2830360 --AND ProgramName = 1 AND ProgramAction = 3

--BEGIN TRAN
--	UPDATE BSegmentCreditCard SET ReageStatus = 4 WHERE acctId = 2830360
--	DELETE FROM LoanModificationLog WHERE acctId = 2830360 AND ProgramName = 1 AND ProgramAction = 3
--COMMIT TRAN
--ROLLBACK TRAN

SELECT * FROM CurrentBalanceAudit WITH (NOLOCK) WHERE AID = 2830360 ORDER BY businessday DESC

SELECT * FROM CurrentBalanceAuditPS WITH (NOLOCK) WHERE AID = 40755609 ORDER BY businessday DESC


--UPDATE BSegmentCreditCard SET FirstDueDate = '2018-03-31 23:59:57.000' WHERE acctId = 2830360

SELECT
	BP.acctId, FirstDueDate, NoPayDaysDelinquent, DaysDelinquent, DtOfLastDelinqCTD, 
	DateOfOriginalPaymentDueDTD, LAD, DeAcctActivityDate, ccinhparent125AID, ActualDRPStartDate, CycleDueDTD, SystemStatus, DaysDelinquent
FROM BsegmentCreditCard BCC WITH (NOLOCK)
INNER JOIN BSegment_Primary BP WITH (NOLOCK) ON (BP.acctId = BCC.acctId)
--WHERE BCC.DaysDelinquent > BCC.NoPayDaysDelinquent
AND BP.SystemStatus <> 14 And BillingCycle <>'LTD'

PR_DestinationMergeAccount

SELECT * FROM MrgBilledRetailTxnLog

select * from NonMonetaryLog WHERE AccountNumber = '1100001000001698' ORDER BY Skey DESC

SELECT * FROM DelinquencyRecord
SELECT * FROM PlanDelinquencyRecord


SELECT * FROM BSegment_MStatuses WITH (NOLOCK) WHERE acctId = 2830360
--------------------------------------------------------------------------------MergeAccount-------------------------------------------------------------------------
--sp_mergeaccounts_sel

--update  PP_CL..apicallsetup SET host='Xeon-web1', url='/PrasoonP/PrasoonPAddManualStatusToAccount.aspx' WHERE APINAME = 'svcAddManualStatusToAccount'

SELECT * FROM PP_CL..APICallSetup WITH (NOLOCK) 

SELECT * FROM MergeAccountJob WITH (NOLOCK) WHERE SrcBSAcctId = 14551547

SELECT * FROM MergeAccountJob WITH (NOLOCK) WHERE JobID = 1381224383483543649

--UPDATE MergeAccountJob SET RetryFlag = 1 WHERE JobID = 1379535410506956863
--UPDATE MergeAccountJob SET RetryFlag = 1, MergeStartTime = '2018-03-12 17:35:05.000' WHERE JobID = 2152581042
--UPDATE MergeAccountJob SET RetryFlag = 1, MergeStartTime = '2018-03-12 17:35:24.000' WHERE JobID = 2152581043
--UPDATE MergeAccountJob SET RetryFlag = 1, MergeStartTime = '2018-03-12 17:35:40.000' WHERE JobID = 2152581044

--SELECT ActionFlag,* FROM MrgActCCardLog WITH (NOLOCK)

SELECT ActionFlag, SrcPriority, DestPriority, PostTime, MergeStatus, SrcTxnAcctID, DestTxnAcctID, creditplantype, SrcCMTTranType, DestCMTTranType, SrcCCardAction, DestCCardAction, PlanUUID, 
SrcTransactionAmount, DestTransactionAmount, InvoiceNumber, CardAcceptorNameLocation, * 
FROM MrgActCCardLog WITH (NOLOCK) 
WHERE JobID = 1382631829309554688

SELECT * FROM MergeAccounts WITH (NOLOCK)

SELECT * FROM MrgActProcessLog WITH (NOLOCK) WHERE JobID = 2152591041

--UPDATE MergeAccountJob SET JobStatus = 'OLD' WHERE JobID <> 71031

--TRUNCATE TABLE MrgActCCardLog

--SELECT * INTO PARASHAR_TEST..TEMP_MergeLog FROM MrgActCCardLog

SELECT dbo.PR_ISOGetBusinessTime()

-- PR_MergeAccountFPTxnDecision '1100001000000013', '02/28/2018 23:59:57:000', 2830360, 3000, 2830360
--SP_HELPTEXT PR_MergeAccountFPTxnDecision
--SP_HELPTEXT PR_MrgActWFSource
--SP_HELPTEXT PR_ISOGetBusinessTime

select * from Rohit_CI..MergeAccountJob with (NOLOCK )
select * from Rohit_CI..MrgActCCardLog

SELECT * FROM Rohit_CI..MergeAccounts WITH (NOLOCK)

select sKey, JobID, MergeStep, MergeStatus, StartTime, EndTime, TotalTimeTaken, AlertRequestID, Requestid, SrcCCardAcctID, DestCCardAcctID, SrcCCardTranid, DestCCardTranid, SrcAuthTranID, DestAuthTranID, SrcCCardLCID, DestCCardLCID, SrcTransactionAmount, DestTransactionAmount, SrcCurrentBalance, DestCurrentBalance, SrcCCardAction, DestCCardAction, CCardTransactionType, SrcCMTTranType, DestCMTTranType, TxnSource, SrcTxnAcctID, DestTxnAcctID, RMATranUUID, InvoiceNumber, TranTime, SrcPriority, DestPriority, ActionFlag, TransactionStatus, PostingRef, SrcBTID, DestBTID, creditplanmaster, creditplantype, ClaimID, MergeOrigTranUUID, MergeOrigTranID, PostTime
from PP_CI..MrgActCCardLog with ( nolock )
where
((PP_CI..MrgActCCardLog.JobID = 3000) 
AND ((PP_CI..MrgActCCardLog.ActionFlag = 2) OR (PP_CI..MrgActCCardLog.ActionFlag = 1)) 
AND (PP_CI..MrgActCCardLog.sKey > 0))
order by PP_CI..MrgActCCardLog.DestPriority, PP_CI..MrgActCCardLog.PostTime

--DECLARE @ProcessTime DATETIME = '2018-03-10 15:18:07.000', @CurrentTime DATETIME
--SELECT @CurrentTime = CAST(CONVERT(VARCHAR, CAST(@ProcessTime AS DATE), 23) + ' ' + CONVERT(VARCHAR, GETDATE(), 14) AS DATETIME)
----PRINT @CurrentTime
--UPDATE MergeAccountJob SET TransmissionTime = @CurrentTime WHERE Skey = 1

SELECT * FROM MergeStatementHeader WITH (NOLOCK) ORDER BY acctId, StatementDate
SELECT * FROM MergeSummaryHeader WITH (NOLOCK) ORDER BY acctId, StatementDate

SELECT * FROM PostValues WITH (NOLOCK) WHERE Name LIKE '%Merge%'

--UPDATE MergeSummaryHeader 
--SET 
--	acctId = 5021,
--	parent02AID = 2830360
--WHERE acctId = 5013

select PP_CI..CPSgmentAccounts.acctId, PP_CI..CPSgmentAccounts.parent02AID, PP_CI..CPSgmentCreditCard.AuthTranId, PP_CI..CPSgmentCreditCard.CoreAuthTranID, PP_CI..CPSgmentCreditCard.PlanUUID, PP_CI..CPSgmentCreditCard.RetailInvoiceNumber, PP_CI..CPSgmentCreditCard.RetailOrderNumber, PP_CI..CPSgmentCreditCard.CardAcceptorNameLocation, PP_CI..CPSgmentCreditCard.ClientId, PP_CI..CPSgmentAccounts.CustomerId
from  PP_CI..CPSgmentAccounts  with ( nolock ) LEFT OUTER JOIN PP_CI..CPSgmentCreditCard  with ( nolock ) ON ( PP_CI..CPSgmentAccounts.acctId = PP_CI..CPSgmentCreditCard.acctId ) 
where
((PP_CI..CPSgmentAccounts.parent02AID = 2830360) AND (PP_CI..CPSgmentAccounts.creditplantype = '16'))

SELECT * FROM CommonTNP WITH (NOLOCK) WHERE ATID = 60

--------------------------------------------------------------------------------CPSgment CoreAuth-------------------------------------------------------------------------

SELECT * FROM PP_CAuth..CPSgmentAccounts WITH (NOLOCK)

SELECT * FROM ARUN_CB_CAuth..CPSgmentAccounts WITH (NOLOCK)

select acctId, ATID, parent01AID, parent01ATID, parent02AID, parent02ATID, CurrentBalance, ActivePlan, PlanExpiryDate, tpyNAD, tpyLAD, tpyBlob, MergeDate, MergeIndicator, MergeSourceAccountID, MergeSourcePlanID, PlanUUID, SingleSaleTranID, creditplantype, plansegcreatedate
from PP_CAuth..CPSgmentAccounts with ( nolock )
where
(PP_CAuth..CPSgmentAccounts.parent02AID = 2830360)

--------------------------------------------------------------------------------CPSgment CoreIssue-------------------------------------------------------------------------

SELECT       bcc.InterestRate1, bp.AmountOfDebitsLTD, bp.AmountOfCreditsLTD, bp.parent01AID, bcc.PayOffDate,bcc.FirstDueDate, bcc.AuthTranId, bcc.OriginalPurchaseAmount,bp.acctId,bp.parent01AID, bp.parent02AID,PaymentStartDate, InterestStartDate,CounterForEqualPayment, bp.AmountOfCreditsCTD, bp.AmountOfCreditsRevCTD,bcc.OrigEqualPmtAmt, bp.AmountOfReturnsLTD, bp.AmountOfReturnsCTD, bp.AmountOfPaymentsCTD,BeginningBalance, bp.CurrentBalance, CurrentBalanceCO, bp.Principal,bcc.principalco,bcc.SRBWithInstallmentDue, bcc.AmountOfTotalDue, bp.AmountOfCreditsLTD, bcc.AmountOfCreditsRevLTD,bcc.CardAcceptorNameLocation,
              bcc.AmtOfPayCurrDue, bcc.CoreAuthTranID, bcc.AmountOfCreditsAsPmtCTD,bp.AmountOfPaymentsCTD, bp.AmountOfDebitsRevCTD, bcc.IntBilledNotPaid, bcc.PlanUUID, bcc.CPSUniversalUniqueID, bp.InvoiceNumber, bcc.DateOfTotalDue, 
              bcc.InterestRate4, bp.parent01AID AS Expr2, bp.cpsinterestplan, bcc.AuthTranId AS Expr3, bp.CurrentBalance AS Expr4, bp.Principal, bp.latefeesbnp, bcc.IntBilledNotPaid AS Expr5, bp.recoveryfeesbnp, 
              bp.NSFFeesBilledNotPaid, bcc.CycleDueDTD, bp.MembershipFeesBNP, bp.creditplantype, bcc.PurchaseRevCTD_InCycle, bp.AmountOfDebitsRevCTD AS Expr6, bp.AmountOfCreditsRevCTD, bp.CounterForEqualPayment, 
              bcc.SRBWithInstallmentDue AS Expr7, bcc.SBWithInstallmentDue AS Expr8
FROM            CPSgmentAccounts AS bp WITH (nolock) INNER JOIN
                         CPSgmentCreditCard AS bcc WITH (nolock) ON bp.acctId = bcc.acctId
WHERE        (bp.parent02AID IN (2830360)) --and bcc.acctId = 5100
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
WHERE CPA.parent02AID = 2830360


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
WHERE CPA.parent02AID = 2830360


SELECT * FROM CommonTNP WITH (NOLOCK) WHERE ATID = 60 

SELECT * FROM CommonTNP WITH (NOLOCK) WHERE TranID > 0

--18031209253295278

--UPDATE CPSgmentAccounts SET CurrentBalance = CurrentBalance - 1 WHERE acctId = 5088

--UPDATE CPSgmentCreditCard SET FirstDueDate = '2018-02-10 23:59:57.000' WHERE acctId = 5078

SELECT * FROM PurchaseReversalRecord WITH (NOLOCK)

SELECT ChangeStatusFor,* FROM NonMonetaryLog WITH (NOLOCK) ORDER BY Skey DESC

SELECT * FROM CCardLookUp with (NOLOCK) WHERE lutid like '%reage%' 

SELECT TransactionAmount,* FROM LoyaltyTransactionMessage WITH (NOLOCK) WHERE AccountNumber IN (
SELECT AccountNumber FROM BSegment_Primary WITH(NOLOCK) WHERE acctId = 2830360) 
ORDER BY PostTime DESC

---------------------------------------------------------------------------------RETAIL-----------------------------------------------------

SELECT        ILPS.ActivityOrder, bp.UniversalUniqueID, ILPS.JobStatus, ILPS.ScheduleType,bp.AccountNumber,ILPS.LoanTerm, ILPS.RevisedLoanTerm,ILPS.ActivityAmount,CL.LutDescription AS ActivityDescription,  ILPS.PlanID, ILPS.ScheduleID, ILPS.TranId, ILPS.TotalPrincipal, ILPS.Principal, ILPS.CurrentBalance, 
                         ILPS.OriginalLoanAmount, ILPS.LoanDate, ILPS.OriginalLoanEndDate, ILPS.parent02AID, ILPS.LoanEndDate, ILPS.EqualPaymentAmountCalc, ILPS.EqualPaymentAmountPassed, ILPS.FirstMonthPayment, 
                         ILPS.LastMonthPayment, ILPS.ScheduleIndicator, ILPS.ScheduleDate, ILPS.PlanUUID, ILPS.ClaimID, ILPS.Activity, ILPS.LoanReversedDate, ILPS.ActivityAmount, ILPS.LastStatementDate,
                         ILPS.DrCrIndicator_MTC,ILPS.TransactionUniqueID,ILPS.PaidOffDate, ILPS.MaturityDate, ILPS.ActivityOrder, ILPS.WaiveMinDueCycle, ILPS.Skey, ILPS.JobStatus
						, ILPS.ActualLoanEndDate, ILPS.LoanEndDate, ILPS.LastTermDate, ILPS.CardAcceptorNameLocation,ILPS.ScheduleType,ILPS.CorrectionDate, ILPS.FileDueToError
						, DRPApplied, ClientID, ILPS.DeferCycle, ReageReversed, ReageReversalGenerated, LoanStartDate, MergeDate, MergeIndicator, MergeSourceAccountID, MergeSourcePlanID, MergeDestinationPlanID
FROM            ILPScheduleDetailSummary AS ILPS WITH (NOLOCK) INNER JOIN
                         BSegment_Primary AS bp WITH (nolock) ON ILPS.parent02AID = bp.acctId LEFT OUTER JOIN
                         CCardLookUp AS CL WITH (NOLOCK) ON (TRY_CONVERT(VARCHAR, ILPS.Activity) = CL.LutCode)
WHERE        (CL.LUTid = 'EPPReasonCode') 
AND (ILPS.parent02AID = 2830360) 
--AND ILPS.PlanID IN (40755628)
--AND ILPS.PlanUUID = ''
--AND BP.AccountNumber = '1100001000000039'
--AND ILPS.Activity = 1
ORDER BY ILPS.ActivityOrder


SELECT        ILPS.ActivityOrder, ILPS.MergeIndicator, ILPS.JobStatus, ILPS.ScheduleType,bp.AccountNumber,ILPS.LoanTerm, ILPS.RevisedLoanTerm,ILPS.ActivityAmount,CL.LutDescription AS ActivityDescription,  ILPS.PlanID, ILPS.ScheduleID, ILPS.TranId, ILPS.TotalPrincipal, ILPS.Principal, ILPS.CurrentBalance, 
                         ILPS.OriginalLoanAmount, ILPS.LoanDate, ILPS.OriginalLoanEndDate, ILPS.parent02AID, ILPS.LoanEndDate, ILPS.EqualPaymentAmountCalc, ILPS.EqualPaymentAmountPassed, ILPS.FirstMonthPayment, 
                         ILPS.LastMonthPayment, ILPS.ScheduleIndicator, ILPS.ScheduleDate, ILPS.PlanUUID, ILPS.ClaimID, ILPS.Activity, ILPS.LoanReversedDate, ILPS.ActivityAmount, ILPS.LastStatementDate,
                         ILPS.DrCrIndicator_MTC,ILPS.TransactionUniqueID,ILPS.PaidOffDate, ILPS.MaturityDate, ILPS.ActivityOrder, ILPS.WaiveMinDueCycle, ILPS.Skey, ILPS.JobStatus
						, ILPS.ActualLoanEndDate, ILPS.LoanEndDate, ILPS.LastTermDate, ILPS.CardAcceptorNameLocation,ILPS.ScheduleType,ILPS.CorrectionDate, ILPS.FileDueToError
						, DRPApplied, ClientID, ILPS.DeferCycle, ReageReversed, ReageReversalGenerated, LoanStartDate, MergeDate, MergeIndicator, MergeSourceAccountID, MergeSourcePlanID, MergeDestinationPlanID
FROM            ILPScheduleDetailSummary AS ILPS WITH (NOLOCK) INNER JOIN
                         BSegment_Primary AS bp WITH (nolock) ON ILPS.parent02AID = bp.acctId LEFT OUTER JOIN
                         CCardLookUp AS CL WITH (NOLOCK) ON (TRY_CONVERT(VARCHAR, ILPS.Activity) = CL.LutCode)
WHERE        (CL.LUTid = 'EPPReasonCode') 
AND (ILPS.parent02AID = 2830360) 
--AND ILPS.PlanID IN (40755601)
--AND ILPS.PlanUUID = 'Nov30cnba3-bb9-Source--9eh9-1b7f8SC46'
--AND BP.AccountNumber = '1100001000000039'
--AND ILPS.Activity = 1
ORDER BY ILPS.ActivityOrder



SELECT        ILPS.ActivityOrder,bp.AccountNumber, ILPS.ScheduleID,ILPS.LoanTerm, ILPS.RevisedLoanTerm,ILPS.ActivityAmount,CL.LutDescription AS ActivityDescription,  ILPS.PlanID, ILPS.TranId, ILPS.Principal, ILPS.CurrentBalance, 
                         ILPS.OriginalLoanAmount, ILPS.LoanDate, ILPS.OriginalLoanEndDate, ILPS.LoanEndDate, ILPS.EqualPaymentAmountCalc, ILPS.EqualPaymentAmountPassed, ILPS.FirstMonthPayment, 
                         ILPS.LastMonthPayment, ILPS.ScheduleIndicator, ILPS.ScheduleDate, ILPS.PlanUUID, ILPS.ClaimID, ILPS.Activity, ILPS.LoanReversedDate, ILPS.ActivityAmount, ILPS.LastStatementDate,
                         ILPS.DrCrIndicator_MTC,ILPS.TransactionUniqueID,ILPS.PaidOffDate, ILPS.MaturityDate, ILPS.ActivityOrder, ILPS.WaiveMinDueCycle, ILPS.Skey, ILPS.JobStatus
						, ILPS.ActualLoanEndDate, ILPS.LoanEndDate, ILPS.LastTermDate, ILPS.CardAcceptorNameLocation,ILPS.ScheduleType,ILPS.CorrectionDate, ILPS.FileDueToError
						, DRPApplied, ClientID, ILPS.DeferCycle, ReageReversed, ReageReversalGenerated, LoanStartDate, MergeDate, MergeIndicator, MergeSourceAccountID, MergeSourcePlanID, MergeDestinationPlanID
FROM            ILPScheduleDetailSummary AS ILPS WITH (NOLOCK) INNER JOIN
                         BSegment_Primary AS bp WITH (nolock) ON ILPS.parent02AID = bp.acctId LEFT OUTER JOIN
                         CCardLookUp AS CL WITH (NOLOCK) ON (TRY_CONVERT(VARCHAR, ILPS.Activity) = CL.LutCode)
WHERE        (CL.LUTid = 'EPPReasonCode') 
AND (ILPS.parent02AID = 14551570) 
--AND ILPS.MergeSourcePlanID IN (5078)
--AND ILPS.PlanUUID = ''
--AND BP.AccountNumber = '1100001000000005'
ORDER BY ILPS.LoanDate


EXEC USP_GetPSDData_Plans 14551538
EXEC USP_GetPSDData_Terms 40755612

SELECT 1
FROM ILPScheduleDetailSummary ILPS WITH (NOLOCK)  
WHERE ILPS.parent02AID = 2830360 AND ILPS.PlanID = 40755602  
AND ISNULL(ILPS.ReageReversed, 0) = 0 AND ILPS.Activity = 28 


SELECT * FROM CommonTNP WITH (NOLOCK) WHERE ATID = 60 

SELECT * FROM [XEONS8toS9].PP_POD2_CI.dbo.CommonTNP WITH (NOLOCK) WHERE ATID = 60 

SELECT * FROM CommonTNP WITH (NOLOCK) WHERE TranID > 0

SELECT * from ILPScheduleDetails where scheduleid = 4653515 ORDER BY LoanTerm

SELECT * from ILPScheduleDetailsRevised with(nolock) where scheduleid = 4653397 ORDER BY LoanTerm

SELECT * from ILPScheduleDetailSummary with(nolock) where planid = 40755620

SELECT * FROM RetailSchedulesCorrected WITH (NOLOCK)


DECLARE @AccountID	int,@PlanID	int,@CurrentTime	datetime,@LastStatementDate	datetime,@ScheduleID	decimal,@ScheduleIndicator	int
SELECT TOP 1
	@AccountID = BP.acctId, @PlanID = ILPS.PlanID, @CurrentTime = dbo.PR_ISOGetBusinessTime(), 
	@LastStatementDate = BP.LastStatementDate, @ScheduleID = ILPS.ScheduleID, @ScheduleIndicator = ILPS.ScheduleIndicator
FROM ILPScheduleDetailSummary ILPS WITH (NOLOCK)
JOIN BSegment_Primary BP WITH (NOLOCK) ON (ILPS.parent02AID = BP.acctId)
JOIN BSegment_Secondary BS WITH (NOLOCK) ON (BS.acctId = BP.acctId)
JOIN BSegmentCreditCard BCC WITH (NOLOCK) ON (BCC.acctId = BP.acctId)
WHERE ILPS.PlanID = 5080
ORDER BY ILPS.ActivityOrder DESC
EXEC dbo.USP_GetPaymentTerms @AccountID, @PlanID, @CurrentTime, @LastStatementDate, @ScheduleID, @ScheduleIndicator


EXEC dbo.USP_GetPlanDetails 5047, 0, '2018-05-31 23:59:57.000', NULL, NULL

EXEC dbo.USP_GetPaymentTerms 2830360, 40755598, '2018-04-06 17:08:47.000', '2018-03-31 23:59:57.000', 4404, 0

SELECT TOP 1
	BP.acctId, ILPS.PlanID, dbo.PR_ISOGetBusinessTime() AS CurrentTime, 
	BP.LastStatementDate, ILPS.ScheduleID, ILPS.ScheduleIndicator, BCC.DateOfTotalDue,
	BS.ClientId, BP.CustomerId
FROM ILPScheduleDetailSummary ILPS WITH (NOLOCK)
JOIN BSegment_Primary BP WITH (NOLOCK) ON (ILPS.parent02AID = BP.acctId)
JOIN BSegment_Secondary BS WITH (NOLOCK) ON (BS.acctId = BP.acctId)
JOIN BSegmentCreditCard BCC WITH (NOLOCK) ON (BCC.acctId = BP.acctId)
WHERE ILPS.PlanID = 40755597
ORDER BY ILPS.ActivityOrder DESC



SELECT parent02AID, MergeSourcePlanID, MergeDestinationPlanID, * 
FROM ILPScheduleDetailSummary ILPS WITH (NOLOCK)
WHERE ILPS.parent02AID = 2830360

--UPDATE ILPScheduleDetailsRevised SET IsDeferCycle = 1 WHERE Skey = 30025


--UPDATE ILPScheduleDetailSummary SET JobStatus = 0 WHERE Skey = 30025
--UPDATE ILPScheduleDetailSummary SET ReageReversed = 0 WHERE Skey = 30000

--DECLARE @ReageActivityOrder INT
--UPDATE ILPS
--SET
--	ReageReversed = 1,
--	@ReageActivityOrder = ILPS.ActivityOrder
--FROM ILPScheduleDetailSummary ILPS WITH (NOLOCK)
--WHERE ILPS.parent02AID = 2830360 AND ILPS.PlanID = 2830360
--AND ISNULL(ILPS.ReageReversed, 0) = 0 AND ILPS.Activity = 28 

--PRINT @ReageActivityOrder

--SELECT TOP 1 ILPS.LoanEndDate, ILPS.LastTermDate
--FROM ILPScheduleDetailSummary ILPS WITH (NOLOCK)
--WHERE ILPS.parent02AID = 2830360 AND ILPS.PlanID = 2830360
--AND ISNULL(ILPS.ReageReversed, 0) = 0 AND ILPS.ActivityOrder < @ReageActivityOrder

--SP_HelpText USP_UpdateILPDetailSummary_PaidOffDate

--USP_UpdateILPScheduleDetailSummaryForMerge

select  top 2 parent02AID, PlanID, ActivityOrder, LastTermDate, PaidOffDate, ScheduleType, FileDueToError, LoanEndDate, DRPApplied, OriginalLoanEndDate, DeferCycle, LoanStartDate
from PP_CI..ILPScheduleDetailSummary with ( nolock )
where
((PP_CI..ILPScheduleDetailSummary.parent02AID = 2830360) AND (PP_CI..ILPScheduleDetailSummary.PlanID = 5021))
order by PP_CI..ILPScheduleDetailSummary.ActivityOrder desc

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
((PP_CI..DisputeLog.BSAcctid = 2830360) 
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
WHERE        (bp.parent02AID IN (2830360)) --AND bcc.acctId = 2830360
ORDER BY bp.StatementDate DESC

SELECT        StatementDate, ccinhparent125AID, bp.AccountGraceStatus, bp.SRBWithInstallmentDue, bp.AmountOfCreditsCTD
, ActualDRPStartDate, 
bp.StatementID,bp.WaiveMinDue, bp.Principal,SystemStatus,bp.ccinhparent125AID,bp.StatementDate,bp.ccinhparent125AID, SRBWithInstallmentDue,bp.SRBwithInstallmentDueCC1,bp.DateOfTotalDue,CTDtotalFees, acctId, CreditLimit, CurrentBalance, Principal, CycleDueDTD, AmountOfTotalDue, NewTransactionsBSFC, RevolvingBSFC, TotalBSFC, IntBilledNotPaid, AmtOfPayCurrDue, SRBWithInstallmentDue, 
                         SBWithInstallmentDue,*
FROM            StatementHeader AS bp WITH (nolock)
WHERE        (acctId IN (2830360))
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
WHERE BSacctId = 2830360
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

SELECT MinimumInterestRate,* FROM InterestAccounts WITH (NOLOCK) WHERE acctId = 9311

SELECT defPurchasePlan,* FROM AControlAccounts WITH (NOLOCK) WHERE acctId = 9966

SELECT * FROM CPSgmentAccounts WITH (NOLOCK) WHERE parent02AID = 2830360

SELECT underpmtpriority,interestplan,* FROM CPMAccounts WITH (NOLOCK) WHERE acctId = 13776


SELECT AC.PaymentLevel,AC.defPurchasePlan, BP.ccinhparent127AID, BTA.ccinhparent108AID
FROM BSegment_Primary BP WITH (NOLOCK)
JOIN BillingTableAccounts BTA ON (BP.ccinhparent127AID = BTA.acctId)
JOIN AControlAccounts AC ON (BTA.ccinhparent108AID = AC.acctId)
WHERE BP.acctId = 2830360


SELECT * FROM CCardLookUp WITH (NOLOCK) WHERE LUTid LIKE '%BillingTableType%'


SELECT * FROM CCardLookUp WITH (NOLOCK) WHERE LUTid LIKE '%CpmCrPlanGroup%'


/************************************************************************/



/*
Across:Merchant:1100001000001581 -- 7626222451097602 -- c8dc60dd-cc39-46f4-8d14-ee8795b81e78
Across:Customer:1100001000001599 -- 7626222451097617 -- db0a714a-f53f-445a-8f43-04e168fce92f	
Same  :Merchant:1100001000002589 -- 8189172686913540 -- 1a10ad57-19ae-4cd4-93a6-f880ea0acdf6
Same  :Customer:1100001000002597 -- 8189172686913555 -- 312cefa7-3320-478f-a655-c4cd4e61c776

1100001000001607
1100001000001615
1100001000002605
1100001000002613
*/


SELECT 'POD1' AS SERVER,
	BP.AccountNumber, ILPS.TranId, ILPS.ScheduleID, ILPS.PlanID, ILPS.PlanUUID, ILPS.ActivityAmount, ILPS.ActivityOrder, RTRIM(CL.LutDescription) AS ActivityDescription, ILPS.OriginalLoanAmount,
	ILPS.CurrentBalance, ILPS.LoanTerm, ILPS.LoanDate, ILPS.LoanEndDate, ILPS.ScheduleType, ILPS.Activity, ILPS.parent02AID, ILPS.PaidOffDate
FROM ILPScheduleDetailSummary AS ILPS WITH (NOLOCK) 
INNER JOIN BSegment_Primary AS bp WITH (nolock) ON ILPS.parent02AID = bp.acctId 
LEFT OUTER JOIN CCardLookUp AS CL WITH (NOLOCK) ON (TRY_CONVERT(VARCHAR, ILPS.Activity) = CL.LutCode)
WHERE (CL.LUTid = 'EPPReasonCode') 
--AND (ILPS.parent02AID = 2830360) 
AND ILPS.PlanID IN (40755655)
--AND ILPS.PlanUUID LIKE '%SC37%'
AND BP.AccountNumber = '1100001000002639'
--AND ILPS.Activity = 1
ORDER BY ILPS.ActivityOrder




SELECT 'POD2' AS SERVER,
	BP.AccountNumber, ILPS.TranId, ILPS.ScheduleID, ILPS.PlanID, ILPS.PlanUUID, ILPS.ActivityAmount, ILPS.ActivityOrder, RTRIM(CL.LutDescription) AS ActivityDescription, ILPS.OriginalLoanAmount,
	ILPS.CurrentBalance, ILPS.LoanTerm, ILPS.LoanDate, ILPS.LoanEndDate, ILPS.ScheduleType, ILPS.Activity, ILPS.parent02AID, 
	ILPS.ScheduleDate, ILPS.PaidOffDate
FROM ILPScheduleDetailSummary AS ILPS WITH (NOLOCK) 
INNER JOIN BSegment_Primary AS bp WITH (nolock) ON ILPS.parent02AID = bp.acctId 
LEFT OUTER JOIN CCardLookUp AS CL WITH (NOLOCK) ON (TRY_CONVERT(VARCHAR, ILPS.Activity) = CL.LutCode)
WHERE (CL.LUTid = 'EPPReasonCode') 
--AND (ILPS.parent02AID = 2830360) 
--AND ILPS.PlanID IN (5078)
AND ILPS.PlanUUID = '4a5ed006-fa1b-497b-8eba-6a455b785bcb'
--AND BP.AccountNumber = '1100001000002613'
--AND ILPS.Activity = 1
ORDER BY ILPS.ActivityOrder


SELECT * FROM StatementHeaderEX WITH (NOLOCK)




SELECT ccinhparent108AID, ccinhparent111AID, BillingTableName, CL.LutDescription,* 
FROM BillingTableAccounts BT WITH (NOLOCK)
LEFT OUTER JOIN CCardLookUp CL ON (BT.BTType = CL.LutCode AND CL.LUTid = 'BillingTableType')
WHERE BT.BTType = 1

SELECT MinimumInterestRate,* FROM InterestAccounts WITH (NOLOCK) WHERE acctId = 9311

SELECT defPurchasePlan,* FROM AControlAccounts WITH (NOLOCK) WHERE acctId = 9966

SELECT * FROM CPSgmentAccounts WITH (NOLOCK) WHERE parent02AID = 2830360

SELECT underpmtpriority,interestplan,* FROM CPMAccounts WITH (NOLOCK) WHERE acctId = 13776


SELECT AC.PaymentLevel,AC.defPurchasePlan, BP.ccinhparent127AID, BTA.ccinhparent108AID
FROM BSegment_Primary BP WITH (NOLOCK)
JOIN BillingTableAccounts BTA ON (BP.ccinhparent127AID = BTA.acctId)
JOIN AControlAccounts AC ON (BTA.ccinhparent108AID = AC.acctId)
WHERE BP.acctId = 14551537


SELECT * FROM CCardLookUp WITH (NOLOCK) WHERE LUTid LIKE '%BillingTableType%'



DECLARE @AccountID INT, @CPM INT, @BillingTable INT, @InterestPlan INT, @PlanOccurance INT

SET @AccountID = 14551537
SET @CPM = 13776
--SET @BillingTable = 10384



SELECT @BillingTable = ccinhparent127AID FROM BSegment_Primary BP WITH (NOLOCK) WHERE acctId = @AccountID

SELECT 'BillingTable===> ', @BillingTable

SELECT @PlanOccurance = intplanoccurr FROM CPMAccounts CPM WITH (NOLOCK) WHERE CPM.acctId = @CPM

SELECT 'PlanOccurance===> ', @PlanOccurance

SELECT @InterestPlan =	CASE
							WHEN @PlanOccurance = 1 THEN ccinhparent111AID
							WHEN @PlanOccurance = 2 THEN ccinhparent112AID
							WHEN @PlanOccurance = 3 THEN ccinhparent113AID
							WHEN @PlanOccurance = 4 THEN ccinhparent114AID
							ELSE 0
						END
FROM BillingTableAccounts WITH (NOLOCK) WHERE acctId = @BillingTable

SELECT 'InterestPlan===> ', @InterestPlan


SELECT CL.LutDescription InterestType, IA.FixedRate1, Variance1, VarInterestRate, 
CASE WHEN IA.IntRateType = 0 THEN IA.FixedRate1 ELSE Variance1 + VarInterestRate END TotalInterest 
FROM InterestAccounts IA WITH (NOLOCK) 
LEFT OUTER JOIN CCardLookUp CL WITH (NOLOCK) ON (CL.lutid = 'IntRateType' AND IA.IntRateType = TRY_CONVERT(INT, CL.LutCode))
WHERE IA.acctId = @InterestPlan







SELECT CP.BSAcctid, CP.CMTTRANTYPE, CP.ARTxnType, CS.FeeProcessingCode, CP.TxnSource,CP.TxnAcctId, CP.creditplanmaster, CP.TransactionAmount, CP.PaymentCreditFlag, REV.PaymentCreditFlag,
CP.TranId,CP.TranRef,CP.tranorig,CP.TransmissionDateTime,CP.atid,CP.Trantime,CP.PostTime,CP.RevTgt,
CP.PostingRef,CS.CardAcceptorNameLocation,CP.MemoIndicator, CP.Transactionidentifier,
CP.TxnCode_Internal,CP.NoBlobIndicator,CP.CaseID, CP.RMATranUUID, CP.TransactionDescription, 
CP.MergeActivityFlag, CP.HostMachineName, CP.ClaimID, CP.EmbAcctID, CP.ClientId, CP.PartnerId, CS.ProfileIDatAutoReage, CS.ReageTrigger
FROM CCard_Primary CP WITH(NOLOCK)
LEFT OUTER JOIN CCard_Secondary CS WITH(NOLOCK) ON (CP.TranId = CS.TranId)
LEFT OUTER JOIN CCard_Primary REV WITH(NOLOCK) ON (CP.TranId = REV.RevTgt)
WHERE CP.Accountnumber = '1100001000001698' AND
CP.CMTTRANTYPE IN ('121', '123', '125', '127', '129', '131','133','135','137','139')
--AND CP.TranTime >  '02/07/2018 23:59:57:000'
--AND CP.TranTime <= @GraceCutOffDate
--AND (CS.feeprocessingcode = '0' OR CS.feeprocessingcode IS NULL) AND CP.NoBlobIndicator = '6'
AND ISNULL(CS.feeprocessingcode,'0') = '0' AND CP.NoBlobIndicator = '6'
--AND REV.TranId IS NULL 
AND REV.PaymentCreditFlag IN ('03', '09', '07', '17')
AND CP.TxnAcctId IN (SELECT AcctId FROM CPSgmentAccounts WITH(NOLOCK) WHERE parent02AID = 2830360)




SELECT ISNULL(SUM(CP.TransactionAmount), 0)
FROM CCard_Primary CP WITH(NOLOCK)
LEFT OUTER JOIN CCard_Secondary CS WITH(NOLOCK) ON (CP.TranId = CS.TranId)
LEFT OUTER JOIN CCard_Primary REV WITH(NOLOCK) ON (CP.TranId = REV.RevTgt)
WHERE CP.Accountnumber = '1100001000001698' AND
CP.CMTTRANTYPE IN ('121', '123', '125', '127', '129', '131','133','135','137','139')
AND CP.TranTime >  '02/07/2018 23:59:57:000'
--AND CP.TranTime <= @GraceCutOffDate
--AND (CS.feeprocessingcode = '0' OR CS.feeprocessingcode IS NULL) AND CP.NoBlobIndicator = '6'
AND ISNULL(CS.feeprocessingcode,'0') = '0' AND CP.NoBlobIndicator = '6'
--AND REV.TranId IS NULL 
AND REV.PaymentCreditFlag IN ('03', '09', '07', '17')
AND CP.TxnAcctId IN (SELECT AcctId FROM CPSgmentAccounts WITH(NOLOCK) WHERE parent02AID = 2830360)
