/********************************************* RETAIL QUERIES ***********************************************************/

SELECT * FROM sys.servers

/********************************************* CONTROL QUERIES ********************************************************/

SELECT intplanoccurr,interestplan,CpmDescription,paymenttype,RevisedSchedule,creditplantype,EqualPayments,GraceDaysApp,creditplantype,* from CPMAccounts WITH(NOLOCK)

SELECT * from InterestAccounts WITH(NOLOCK)

SELECT * FROM APIMaster with (NOLOCK) WHERE APIName = 'svcManualReage'

SELECT a.APIName, T.* FROM TCIVRRequest T with (NOLOCK) 
JOIN APIMaster a WITH (NOLOCK) ON (T.RequestName = a.APICode)
WHERE T.AccountNumber = '1100001000000005'
ORDER BY T.RequestDate DESC


/********************************************* LOOKUP QUERIES *********************************************************/

SELECT * FROM CCardLookUp WITH (NOLOCK) WHERE LUTid Like '%TxnStage%' --and LutDescription ='Retail' 

SELECT * FROM CCardLookUp WHERE LUTid = 'TxnStage' ORDER BY DisplayOrdr

SELECT A.CBRStatusGroup,C.LutDescription AS StatusGroup,A.WaiveMinDue,A.WaiveMinDueFor,A.* 
FROM AStatusAccounts A WITH (NOLOCK)

JOIN CCardLookUp C WITH (NOLOCK) ON (A.parent01AID = C.LutCode)
WHERE C.LUTid = 'AsstPlan' AND C.LutLanguage = 'dbb' AND A.acctId = 11
ORDER BY StatusGroup

SELECT A.CBRStatusGroup, parent01AID,C.LutDescription AS StatusGroup, A.StatusDescription,A.WaiveMinDue,A.WaiveMinDueFor,A.Priority, A.COReasonCode,A.* 
FROM AStatusAccounts A WITH (NOLOCK)
JOIN CCardLookUp C WITH (NOLOCK) ON (A.parent01AID = C.LutCode)
WHERE C.LUTid = 'AsstPlan' AND C.LutLanguage = 'dbb' AND A.MerchantAID = 14992 AND A.CBRStatusGroup = 5
ORDER BY A.Priority

SELECT ChargeOffReason, * FROM MonetaryTxnControl WITH (NOLOCK) WHERE GroupId = 53 and LogicModule = 43

SELECT ChargeOffReason, * FROM MonetaryTxnControl WITH (NOLOCK) WHERE GroupId = 53 and TransactionCode = '17177'

SELECT * FROM Version WITH (NOLOCK) ORDER BY 1 DESC


SELECT CPM.acctId, CPM.CpmDescription, CL.LutDescription AS InterestPlanDesc, CPM.CreditPlanType, EqualPayments, CPM.InterestPlan, IT.IntRateType, CLI.LutDescription AS InterestType,
ISNULL(IT.VarInterestRate+IT.Variance1+IT.Variance2+IT.Variance3, 0) AS TotalInterest, IT.VarInterestRate, IT.Variance1, IT.Variance2, IT.Variance3, CPM.multiplesales
FROM CPMAccounts CPM WITH (NOLOCK)
JOIN InterestAccounts IT WITH (NOLOCK) ON (CPM.interestplan = IT.acctId)
LEFT OUTER JOIN CCardLookUp CL WITH (NOLOCK) ON (TRY_CONVERT(VARCHAR, IT.acctId) = CL.LUTCode AND CL.Lutid = 'InterestPlan')
LEFT OUTER JOIN CCardLookUp CLI WITH (NOLOCK) ON (TRY_CONVERT(VARCHAR, IT.IntRateType) = CLI.LUTCode AND CLI.Lutid = 'IntRateType')
WHERE CPM.CreditPlanType = '16' --AND ISNULL(IT.VarInterestRate+IT.Variance1+IT.Variance2+IT.Variance3, 0) > 0


SELECT CPM.acctId, CPM.CpmDescription, CL.LutDescription AS InterestPlanDesc, CPM.CreditPlanType, EqualPayments, CPM.InterestPlan, IT.IntRateType, CLI.LutDescription AS InterestType,
ISNULL(IT.VarInterestRate+IT.Variance1+IT.Variance2+IT.Variance3, 0) AS TotalInterest, IT.VarInterestRate, IT.Variance1, IT.Variance2, IT.Variance3, CPM.multiplesales
FROM CPMAccounts CPM WITH (NOLOCK)
JOIN InterestAccounts IT WITH (NOLOCK) ON (CPM.interestplan = IT.acctId)
LEFT OUTER JOIN CCardLookUp CL WITH (NOLOCK) ON (TRY_CONVERT(VARCHAR, IT.acctId) = CL.LUTCode AND CL.Lutid = 'InterestPlan')
LEFT OUTER JOIN CCardLookUp CLI WITH (NOLOCK) ON (TRY_CONVERT(VARCHAR, IT.IntRateType) = CLI.LUTCode AND CLI.Lutid = 'IntRateType')
WHERE CPM.acctId = 13792



SELECT CpmDescription,* FROM dbo.CPMAccounts WITH (NOLOCK) WHERE acctId = 14536



SELECT * FROM CPMAccounts WITH (NOLOCK) WHERE acctId = 13752


/********************************************* AUTH QUERIES ***********************************************************/

-- USE CCGS_CoreAuth DB

--9000 (INITITATE)
--9100 (CREATE)
--9200 (ACTIVATE )
--9220 (REFUND)

SELECT  BillingCycle,DateOfNextStmt,* FROM BSegment_Primary WITH(NOLOCK) WHERE AccountNumber = '1100001000000005'

SELECT request_id,* FROM RetailAPILog WITH(NOLOCK) WHERE AccountNumber = '1100001000000005' ORDER BY Skey DESC

SELECT A.MTI, TransactionDescription,* FROM ccgs_RPT_coreauth..RetailAPILog A WITH (NOLOCK)
JOIN RetailAPILog B WITH (NOLOCK) ON (A.request_id = B.request_id)
WHERE B.AccountNumber = '1100011111632661' AND A.uuid = 'efc42f2f-3f1a-4d32-8cd4-3663432f8d27' AND A.MTI = 9200

SELECT TOP 100 TransactionDescription,* FROM RetailAPILineItems WITH (NOLOCK) WHERE TransactionDescription IS NOT NULL ORDER BY Skey DESC



SELECT count(1) as COUNT, a.accountnumber,universaluniqueid  FROM LS_P1MARPRODDB01.CCGS_Coreauth.dbo.RetailAPILog A WITH (NOLOCK)
JOIN  LS_P1MARPRODDB01.CCGS_Coreauth.dbo.RetailAPILineItems  B WITH (NOLOCK) ON (A.request_id = B.request_id) 
join  LS_P1MARPRODDB01.CCGS_Coreissue.dbo.bsegment_primary BP with(nolock) on (a.accountnumber=BP.accountnumber)
where a.MTI in ('9100','9420')
group by a.accountnumber ,universaluniqueid
order  by count(1) desc  
 

SELECT TOP 10 * FROM RetailAPILog WITH (NOLOCK) ORDER BY Skey DESC

SELECT MessageTypeIdentifier,ProcCode,AccountNumber,EffectiveDate_ForAgeOff,TransactionAmount,MsgIndicator,TransactionLifeCycleUniqueID,* FROM CoreAuthTransactions WITH(NOLOCK)
WHERE AccountNumber= '1100001276328312' AND RetailUUID = 'efc42f2f-3f1a-4d32-8cd4-3663432f8d27'

SELECT * FROM ServiceCallResponseData WITH(NOLOCK) WHERE AccountNumber = '1100001276328312'

SELECT TOP 1 JobStatus,* FROM coreissueauthmessage WITH(NOLOCK) WHERE TranId IN (184294377)

/********************************************* COREISSUE QUERIES ********************************************************/

-- USE CCGS_CoreIssue DB

-- Transaction tables 32040884617

SELECT * FROM Auth_Primary WITH (NOLOCK) 
WHERE AccountNumber = '1100001276328312' AND  PlanUUID= 'efc42f2f-3f1a-4d32-8cd4-3663432f8d27'
ORDER BY PostTime DESC

SELECT TOP 10 RetailTransactionDescription, * FROM Auth_Secondary WITH (NOLOCK) WHERE RetailTransactionDescription IS NOT NULL

SELECT TOP 10
AP.TranID, AP.MessageTypeIdentifier, AP1.RetailTransactionDescription, TransactionAmount, TxnSource, RMAMerchantName, RMAMerchantCity, RMAMerchantState, TransmissionDateTime, PlanUUID
FROM Auth_Primary AP WITH (NOLOCK)
JOIN Auth_Secondary AP1 WITH (NOLOCK) ON (AP.TranID = AP1.TranId)
WHERE AP.RetailFlag = 1 AND AP.MessageTypeIdentifier = 9200
--ORDER BY DateLocalTransaction DESC

SELECT BSAcctid,C.TxnAcctId,C.CaseID,C.DisputeIndicator,C.TranId,C.TranRef,HostMachineName,C.PostingRef,C.CardAcceptNameLocation,CMTTRANTYPE,C.TxnCode_Internal,
C.TransactionAmount,txnsource,C.ARTxnType,C.atid,Trantime,C.PostTime,noblobindicator,C.TranRef,C.TranId,txnacctid,C.tranorig,C.TransactionDescription,
C.TxnCode_Internal,C.GroupId,PaymentReferenceId,C.creditplanmaster,MessageReasonCode,TransactionAmount,FeesAcctID,accountnumber,TranId,
UniversalUniqueID,CaseID,PaymentCreditFlag,MessageIdentifier,TranRef,txnacctid,* 
FROM CCard_Primary C WITH (NOLOCK)  --where C.CMTTRANTYPE = '43'
WHERE AccountNumber in (SELECT AccountNumber FROM BSegment_Primary WITH(NOLOCK) WHERE acctid = 5595) 
AND TxnAcctId = 6545814
ORDER BY C.PostTime DESC

SELECT TransactionAmount,MonthlyPaymentAmount, AuthStatus,CoreAuthTranId,planuuid,retailtranid,MessageTypeIdentifier,ProcCode,
* FROM Auth_Primary with (nolock) WHERE AccountNumber = '1100001000000005'
ORDER BY posttime DESC

SELECT MessageTypeIdentifier, FileName,MonthlyPaymentAmount,RetailFlag,A.CardholderBillingAmount, a.* FROM Auth_Primary AP WITH (NOLOCK)
JOIN Auth_Secondary A WITH (NOLOCK) ON (AP.TranId = A.TranId)
WHERE AP.AccountNumber = '1100001000000005' AND AP.MessageTypeIdentifier = '0100' AND AP.RetailFlag = 1 AND AP.AuthStatus = 0

-- BaseSegment

SELECT BP.acctId, BP.UniversalUniqueID, BP.AccountNumber,BS.ClientId,BS.DebitWriteOffDate,BCC.DateOfTotalDue,BP.ccinhparent125AID,BP.SystemStatus, createdTime, DateAcctOpened,
BP.CurrentBalance, BCC.AmountOfTotalDue, BCC.ChargeOffDate, BCC.SystemChargeOffStatus, BP.LastStatementDate, BP.BeginningBalance, 
BP.ccinhparent125AID, BP.SystemStatus, BP.Principal, BS.latefeesbnp, BCC.ChargeOffDateParam, BCC.ManualInitialChargeOffReason, BCC.IntBilledNotPaid, 
BP.CycleDueDTD, BP.AmtOfPayCurrDue, BP.LastPaymentRevDate, BP.BillingCycle, BCC.currentbalanceco, BCC.principalco, 
BS.NearestEffectiveEndDate, BCC.SBWithInstallmentDue, BCC.SRBWithInstallmentDue, BP.UniversalUniqueID, FamilyAccount, MergeCycle
FROM BSegment_Primary AS BP WITH (NOLOCK) INNER JOIN
BSegment_Secondary AS BS WITH (NOLOCK) ON (BP.acctId = BS.acctId) INNER JOIN
BSegmentCreditCard AS BCC WITH (NOLOCK) ON (BP.acctId = BCC.acctId) INNER JOIN
BSegment_Balances AS BSB WITH (NOLOCK) ON (BP.acctId = BSB.acctId)
WHERE BP.acctId IN (17720831)

SELECT acctId, BeginningBalance, CurrentBalance, AmountOfDebitsCTD, AmountOfCreditsCTD, AmountOfPurchasesCTD, AmountOfPaymentsCTD, AmountOfCreditsRevCTD, AmountOfDebitsRevCTD
FROM BSegment_Primary WITH (NOLOCK)
WHERE acctId IN (17720831)

SELECT acctId, BeginningBalance, AmountOfDebitsCTD, AmountOfCreditsCTD, AmountOfPurchasesCTD, AmountOfPaymentsCTD, AmountOfCreditsRevCTD, AmountOfDebitsRevCTD, 
BeginningBalance + AmountOfDebitsCTD - AmountOfCreditsCTD AS SummaryBS, CurrentBalance
FROM BSegment_Primary WITH (NOLOCK)
WHERE acctId IN (17720831)


-- CPSgment
select count(1) from LS_P1MARPRODDB01.CCGS_CoreIssue.dbo.commontnp with(nolock) where trantime<getdate() 
SELECT count(1) as plancount,CPA.parent02aid,UniversalUniqueID
--CASE WHEN CPCC.CycleDueDTD < 2 THEN 'Current' ELSE 'Delinquent' END AS Delinquency,
--CASE WHEN CPA.creditplantype = '16' THEN 'RETAIL'  ELSE 'Normal Plan' END AS PlanType
FROM ccgs_RPT_coreissue..CPSgmentAccounts CPA WITH (NOLOCK)
join ccgs_RPT_coreissue..Bsegment_primary BS with(nolock)   ON (BS.acctId = CPA.parent02aid)
JOIN ccgs_RPT_coreissue..CPSgmentCreditCard CPCC WITH (NOLOCK) ON (CPA.acctId = CPCC.acctId)
--WHERE CPA.acctId = 5015
WHERE BS.currentbalance =0 and CPCC.OriginalpurchaseAmount != CPCC.AmountofReturnsLtd_Summary

group by CPA.parent02aid,UniversalUniqueID
order by count(1) desc


1537964 --normal  
1538221 row(s) affected --file save 
(1537888 row(s) affected)
select top 1  AmountofReturnsLtd_Summary,* from ccgs_RPT_coreissue..CPSgmentCreditCard with(nolock) 
SELECT CA.acctId, CA.parent02AID, CA.CurrentBalance, CC.AmountOfTotalDue, CA.AmountOfCreditsCTD, CC.AmountOfCreditsAsPmtCTD, CA.AmountOfCreditsRevCTD, CA.AmountOfDebitsCTD, CA.AmountOfPaymentsCTD
FROM CPSgmentAccounts AS CA WITH (NOLOCK) INNER JOIN
CPSgmentCreditCard AS CC WITH (NOLOCK) ON (CA.acctId = CC.acctId)
WHERE CA.parent02AID IN (17720831)
ORDER BY CA.parent02AID

SELECT CA.acctId, CA.parent02AID, CA.CurrentBalance,DisputesAmtNS,CC.DateOfTotalDue, CC.PayOffDate,CC.OrigEqualPmtAmt, CC.SRBWithInstallmentDue, 
CC.SRBWithInstallmentDueCC1,CA.SingleSaleTranID,CC.CardAcceptorNameLocation,CC.LoanEndDate,CC.MaturityDate, CC.AuthTranId, CA.DisputesAmtNS, 
CC.RetailInvoiceNumber, CC.RetailOrderNumber, CA.parent01AID, CC.PlanUUID, CC.currentbalanceco, CC.AmountOfTotalDue, CC.AmtOfPayCurrDue, 
CC.CoreAuthTranID, CC.AmountOfCreditsAsPmtCTD, CA.AmountOfDebitsRevCTD, CC.IntBilledNotPaid, CC.CPSUniversalUniqueID, CA.InvoiceNumber, 
CC.DateOfTotalDue, CC.InterestRate4, CA.cpsinterestplan, CC.FirstDueDate, PlanSegCreateDate, ClientID
FROM CPSgmentAccounts AS CA WITH (NOLOCK) INNER JOIN
CPSgmentCreditCard AS CC WITH (NOLOCK) ON (CA.acctId = CC.acctId)
WHERE CA.parent02AID IN (903333)
ORDER BY CA.parent02AID

-- StatementHeader

SELECT SystemStatus,StatementDate,bp.ccinhparent125AID, SRBWithInstallmentDue,bp.SRBwithInstallmentDueCC1,bp.DateOfTotalDue,CTDtotalFees, 
acctId, CreditLimit, CurrentBalance, Principal, CycleDueDTD, AmountOfTotalDue, NewTransactionsBSFC, RevolvingBSFC, TotalBSFC, IntBilledNotPaid, AmtOfPayCurrDue, SRBWithInstallmentDue, SBWithInstallmentDue
FROM StatementHeader AS bp WITH (nolock)
WHERE acctId IN (17720831)
ORDER BY StatementDate DESC

-- SummaryHeader

SELECT SH.acctId,SH.StatementDate, SH.CurrentBalance, SCC.currentbalanceco, SCC.PayOffDate, SCC.OriginalPurchaseAmount,SRBWithInstallmentDueCC1,
SCC.SingleSaleTranID,CardAcceptorNameLocation,SCC.LoanEndDate,MaturityDate,SCC.PlanUUID, SCC.DailyCashPercent, SCC.DailyCashAmount,SH.AmountOfTotalDue,
SCC.JobID,SCC.DateOfTotalDue, SCC.SRBWithInstallmentDue, SH.plansegcreatedate, SCC.RetailAniversaryDate, SCC.SBWithInstallmentDue, SCC.AmountOfCreditsAsPmtCTD,
AmountOfCreditsRevCTD, SH.AmountOfDebitsCTD, SH.AmountOfDebitsRevCTD, SH.APR, SH.acctId, SCC.AccountGraceStatus, 
SH.Principal, SCC.CycleDueDTD, SCC.CurrentDue, SCC.AmtOfPayXDLate, SCC.AmountOfPayment30DLate, SCC.AmountOfPayment60DLate, 
SCC.AmountOfPayment90DLate, SCC.AmountOfPayment120DLate, SCC.AmountOfPayment150DLate, SCC.AmountOfPayment180DLate, SCC.AmountOfPayment210DLate, SH.IntBilledNotPaid
FROM SummaryHeader AS SH WITH (NOLOCK) INNER JOIN
SummaryHeaderCreditCard AS SCC WITH (NOLOCK) ON (SH.acctId = SCC.acctId AND SH.StatementID = SCC.StatementID)
WHERE SH.parent02AID IN (17720831) --AND SCC.acctId = 5015
ORDER BY SH.StatementDate DESC

--4878392, 4878393, 6419949, 

-- ILP Queries

--9401936f-fbe4-412a-ba22-c21f64f31a64

--6825c2ac-a06a-458b-a782-18a8bc0629d4

SELECT ILPS.ActivityOrder,ILPS.ClientId, MergeIndicator, ILPS.LoanDate, ILPS.OriginalLoanEndDate, ILPS.LoanEndDate, ILPS.LoanTerm, ILPS.RevisedLoanTerm, LoanStartDate, ILPS.LasttermDate, ILPS.PlanUUID, BP.AccountNumber, JobStatus,ILPS.ActivityAmount,
CL.LutDescription AS ActivityDescription, ILPS.parent02AID, ILPS.CreditPlanMaster, ILPS.PlanID, ILPS.ScheduleID, ILPS.TranId, ILPS.AuthTranId, ILPS.TotalPrincipal, ILPS.Principal, ILPS.CurrentBalance, 
ILPS.OriginalLoanAmount, ILPS.LoanTerm, ILPS.RevisedLoanTerm, ILPS.EqualPaymentAmountCalc, ILPS.EqualPaymentAmountPassed, ILPS.FirstMonthPayment, 
ILPS.LastMonthPayment, ILPS.ScheduleIndicator, ILPS.ScheduleDate, ILPS.PlanUUID, ILPS.CaseID, ILPS.Activity, ILPS.LoanReversedDate, ILPS.ActivityAmount, ILPS.LastStatementDate,
ILPS.DrCrIndicator_MTC,ILPS.TransactionUniqueID,ILPS.PaidOffDate, ILPS.MaturityDate, ILPS.ActivityOrder, FileDueToError, LoanStartDate, LastTermDate, waiveminduecycle, CorrectionDate, ILPS.PaidOffDate,
 MergeSourceAccountID, MergeSourcePlanID, MergeDestinationPlanID, MergeDate
FROM ILPScheduleDetailSummary AS ILPS WITH (NOLOCK) INNER JOIN
BSegment_Primary AS BP WITH (nolock) ON (ILPS.parent02AID = BP.acctId) LEFT OUTER JOIN
CCardLookUp AS CL WITH (NOLOCK) ON (ILPS.Activity = CL.LutCode)
WHERE CL.LUTid = 'EPPReasonCode' 
--AND BP.AccountNumber = '1100011189227527'
--AND ILPS.parent02AID = 1678239  -- 4351385
--AND BP.UniversalUniqueID = '9ee4459b-1d4c-4018-ac7d-32471c771ab2'
AND ILPS.PlanID IN (77776306) -- 31067224
--AND ILPS.PlanUUID = '9401936f-fbe4-412a-ba22-c21f64f31a64'
--AND ActivityOrder = 1
--AND Activity = 24
ORDER BY ILPS.LoanDate

SELECT * FROM ILPScheduleDetails WITH(NOLOCK) WHERE ScheduleID = 9220756 ORDER BY LoanTerm

SELECT * FROM ILPScheduleDetailsRevised WITH(NOLOCK) WHERE ScheduleID = 16765335 ORDER BY LoanTerm

SELECT * FROM ILPScheduleDetailSummary WITH(NOLOCK) WHERE ScheduleID = 15641141

SELECT COUNT(1) FROM ILPScheduleDetailSummary WITH(NOLOCK) WHERE ClientID IS NULL AND Activity = 1


WITH CTE AS (
SELECT Parent02AID, PlanID, RANK() OVER (PARTITION BY PlanID ORDER BY ActivityOrder) AS Ranking, Activity
FROM ILPScheduleDetailSummary WITH (NOLOCK)
WHERE LastMonthPayment > EqualPaymentAmountCalc AND LastMonthPayment - EqualPaymentAmountCalc > 1
AND PlanID > 0)
SELECT * FROM CTE WHERE Ranking = 1 AND Activity = 21

WITH CTE AS (
SELECT Parent02AID, PlanID, RANK() OVER (PARTITION BY PlanID ORDER BY ActivityOrder) AS Ranking, Activity
FROM ILPScheduleDetailSummary WITH (NOLOCK)
WHERE LastMonthPayment > EqualPaymentAmountCalc AND LastMonthPayment - EqualPaymentAmountCalc > 1
AND PlanID > 0)
SELECT ILPB.* 
FROM CTE C 
JOIN ILPScheduleDetailsBAD ILPB WITH (NOLOCK) ON (ILPB.acctId = C.PlanID)
WHERE 
C.Ranking = 1 AND C.Activity = 21


/********************************************* GENERAL QUERIES ********************************************************/

SELECT ProcessName,TranID,* FROM AlertNotificationLog WITH (NOLOCK) WHERE AccountNumber = '1100001000000005' 

SELECT * FROM ServiceCallResponseDataCI WITH (NOLOCK) WHERE TranId = 5009

SELECT * FROM trans_In_acct WHERE tran_id_index = 221160

SELECT COUNT(1) from CommonTNP WITH(NOLOCK) WHERE TranId <> 0 AND TranTime < GETDATE()

select * from AmortizationScheduleEOMDF with (NOLOCK)
where FileTypeFlag='DA' and Acctid = 17720831 AND CPSAcctid = 5020
order by cpsacctid,scheduleid--Daily

select * from AmortizationScheduleEOMDF where FileTypeFlag='DA' and ScheduleID = 4307 order by cpsacctid,scheduleid,monthnumber

SELECT * FROM CurrentBalanceAuditPS WITH (NOLOCK) WHERE aid = 5276 and dename IN (111)

select * from currentbalanceaudit with (nolock) where aid = 5003




; WITH MaxLastTermDate
AS
(SELECT MAX(LastTermDate) LastTermDate, PlanID FROM ILPScheduleDetailSummary WITH (NOLOCK) GROUP BY PlanID)
, LatestLastTermDate
AS
(SELECT RANK() OVER (PARTITION BY PlanID ORDER BY ActivityOrder DESC) RankSchedule, PlanID, LastTermDate, LoanDate, Activity FROM ILPScheduleDetailSummary WITH (NOLOCK))
SELECT *
FROM LatestLastTermDate C1
JOIN MaxLastTermDate C2 ON (C1.PlanID = C2.PlanID AND C1.RankSchedule = 1)
WHERE C1.LastTermDate < C2.LastTermDate
ORDER BY LoanDate DESC



; WITH MaxLastTermDate
AS
(SELECT MAX(LastTermDate) LastTermDate, PlanID FROM ILPScheduleDetailSummary WITH (NOLOCK) GROUP BY PlanID)
, LatestLastTermDate
AS
(SELECT RANK() OVER (PARTITION BY PlanID ORDER BY ActivityOrder DESC) RankSchedule, PlanID, LastTermDate, LoanDate, Activity FROM ILPScheduleDetailSummary WITH (NOLOCK))
SELECT *
FROM LatestLastTermDate C1
JOIN MaxLastTermDate C2 ON (C1.PlanID = C2.PlanID AND C1.RankSchedule = 1)
WHERE C1.LastTermDate < C2.LastTermDate
ORDER BY LoanDate DESC





SELECT * FROM APIJSONRequestLog WITH (NOLOCK)


SELECT * FROM BulkRequestResposeSetup WITH (NOLOCK)

SELECT TOP(100)* FROM BulkRequestResposeRecords WITH (NOLOCK) ORDER BY Skey DESC


SELECT APIResponse, COUNT(1) FROM BulkRequestResposeRecords WITH (NOLOCK) WHERE FileID IN (87,88) GROUP BY APIResponse

SELECT * FROM TCIVRRequest WITH (NOLOCK) WHERE Accountnumber = '11100227393' ORDER by Skey DESC
SP_help BulkRequestResposeRecords