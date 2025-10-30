--select * from LS_P1MARPRODDB01.ccgs_coreissue.dbo.version with (nolock) order by entryid desc
--2583842
select * from sys.servers
select * from sys.tables where name like 'CCard_%'

--1249986, 15471482

SELECT TOP 100 TotalTxnReceivedInFile, LastParsedMessageNumber, FileStatus, FileExtension, * 
FROM LS_P1MARPRODDB01.ccgs_coreissue.dbo.ClearingFiles WITH (NOLOCK) 
ORDER BY Date_Received DESC

SELECT COUNT(1) FROM LS_P1MARPRODDB01.ccgs_coreissue.dbo.CommonTNP with (nolock) WHERE TranTime < GETDATE()

;WITH CTE
AS
(
SELECT TranID FROM LS_P1MARPRODDB01.ccgs_coreissue.dbo.CommonTNP with (nolock) WHERE TranTime < GETDATE()
)
SELECT CMTTranType, COUNT(1) [COUNT]
FROM CTE C
JOIN LS_P1MARPRODDB01.ccgs_coreissue.dbo.CCard_Primary CP WITH (NOLOCK) ON (C.TranID = CP.TranID)
--WHERE CMTTranType = '110'
GROUP BY CMTTranType


SELECT TOP 100 * FROM LS_P1MARPRODDB01.ccgs_coreissue.dbo.CommonTNP with (nolock) WHERE TranTime < GETDATE() ORDER BY TranTime

SELECT acctID, COUNT(1) [COUNT]
FROM LS_P1MARPRODDB01.ccgs_coreissue.dbo.CommonTNP with (nolock) 
WHERE TranTime < GETDATE()
GROUP BY acctID
ORDER BY COUNT(1) DESC


SELECT CMTTranType, TransactionAmount, * FROM LS_P1MARPRODDB01.ccgs_coreissue.dbo.CCard_Primary with (nolock) WHERE TranID = 64230065363


SELECT * FROM LS_P1MARPRODDB01.ccgs_coreissue.dbo.CommonTNP with (nolock) WHERE acctId = 2300126

SELECT COUNT(1) FROM LS_P1MARPRODDB01.ccgs_coreissue.dbo.CommonTNP with (nolock) WHERE TranTime < '2022-04-05 06:17:17.000'

SELECT * FROM LS_P1MARPRODDB01.ccgs_coreissue.dbo.ErrorTNP ET with (nolock)
WHERE ET.ATID = 51 and ET.TranID IN (67738321799,67738335819,67738360936)


SELECT * FROM LS_P1MARPRODDB01.ccgs_coreissue.dbo.CCard_Primary ET with (nolock)
WHERE ET.TranID IN (67738321799,67738335819,67738360936)

SELECT * FROM LS_P1MARPRODDB01.CCGS_CoreIssue.dbo.SPExecutionLog WITH (NOLOCK) WHERE BusinessDay = '2022-12-28 23:59:57.000'

SELECT TOP 10 * FROM LS_P1MARPRODDB01.CCGS_CoreIssue.dbo.EODControlData WITH (NOLOCK) ORDER BY Skey DESC

SELECT TOP 10 * FROM LS_P1MARPRODDB01.CCGS_CoreIssue.dbo.EODControlData WITH (NOLOCK)
WHERE BusinessDay IN ('2022-03-31 23:59:57.000', '2022-02-28 23:59:57.000')

SELECT TOP 10 * FROM EODControlData WITH (NOLOCK) ORDER BY Skey DESC

SELECT * FROM LS_P1MARPRODDB01.CCGS_CoreIssue.dbo.ArSystemAccounts WITH (NOLOCK)

SELECT * FROM ArSystemAccounts WITH (NOLOCK)

SELECT * FROM LS_P1MARPRODDB01.CCGS_CoreIssue.dbo.ArSystemHSAccounts WITH (NOLOCK)

SELECT TOP 10 * FROM LS_P1MARPRODDB01.CCGS_CoreIssue.dbo.ErrorTNPJobs_Processed_Log WITH (NOLOCK) WHERE acctId = 19366594

SELECT * FROM LS_P1MARPRODDB01.CCGS_CoreIssue.dbo.StatementJobs WITH (NOLOCK) WHERE StatementDate = '2021-12-31 23:59:57.000' AND acctId = 2827406

SELECT COUNT(1) FROM LS_P1MARPRODDB01.CCGS_CoreIssue.dbo.BSegment_Primary WITH (NOLOCK) WHERE BillingCycle <> 'LTD'

SELECT BP.acctId, nad, lad, lapd, DeAcctActivityDate, BP.SystemStatus, runningminimumdue,remainingminimumdue,ltrim(rtrim(accountnumber)) AS accountnumber,chargeoffdate, DateAcctClosed, 
CurrentBalance, CurrentBalanceCO, Principal, PrincipalCO,cycleduedtd, amountofpaymentsctd,
amountoftotaldue,amtofpaycurrdue,AmtOfPayXDLate,AmountOfPayment30DLate, AmountOfPayment60DLate, 
--AmountOfPayment90DLate, AmountOfPayment120DLate, AmountOfPayment150DLate, AmountOfPayment180DLate, AmountOfPayment210DLate,
(amtofpaycurrdue+AmtOfPayXDLate+AmountOfPayment30DLate+ AmountOfPayment60DLate+ AmountOfPayment90DLate+ AmountOfPayment120DLate+ AmountOfPayment150DLate+ AmountOfPayment180DLate + AmountOfPayment210DLate) AS CalculatedAD,
daysdelinquent,nopaydaysdelinquent,BS.firstduedate,dateoforiginalpaymentduedtd, BS.DtOfLastDelinqCTD, BeginningBalance
,Statementremainingbalance, sbwithinstallmentdue, srbwithinstallmentdue,amountofcreditsctd, AmountOfPaymentsCTD,BP.SYSTEMSTATUS,BP.CCINHPARENT125AID,accountnumber,BP.ACCTID,amtofpaycurrdue,
amountoftotaldue,BP.CURRENTBALANCE,CURRENTBALANCECO,BP.PRINCIPAL,NEWTRANSACTIONSBSFC,NEWTRANSACTIONSAGG,
	NEWTRANSACTIONSACCRUED,REVOLVINGBSFC,REVOLVINGAGG,REVOLVINGACCRUED,AfterCycleRevolvBSFC, ManualInitialChargeOffReason, AutoInitialChargeOffReason, LastStatementDate
FROM LS_P1MARPRODDB01.ccgs_coreissue.dbo.BSEGMENT_PRIMARY BP WITH(NOLOCK)
	JOIN LS_P1MARPRODDB01.ccgs_coreissue.dbo.BSEGMENTCREDITCARD BS WITH(NOLOCK) ON (BP.ACCTID = BS.ACCTID)
WHERE  bp.acctid = 19366594 

SELECT parent02aid,Mergedate, nad, lad, lapd, CPS.ACCTID,creditplantype, LoanEndDate, CPC.OriginalPurchaseAmount,CPC.cycleduedtd,CPC.amountoftotaldue, CurrentBalance, CurrentBalanceCO, CPS.Principal, PrincipalCO, EqualPaymentAmt, intbillednotpaid, amountofpaymentsctd,
CPC.amtofpaycurrdue,AmtOfPayXDLate,AmountOfPayment30DLate, CPC.AmountOfPayment60DLate, 
--AmountOfPayment90DLate, AmountOfPayment120DLate, AmountOfPayment150DLate, AmountOfPayment180DLate, AmountOfPayment210DLate,
(amtofpaycurrdue+AmtOfPayXDLate+AmountOfPayment30DLate+ AmountOfPayment60DLate+ AmountOfPayment90DLate+ AmountOfPayment120DLate+ AmountOfPayment150DLate+ AmountOfPayment180DLate + AmountOfPayment210DLate) AS CalculatedAD,
daysdelinquent,nopaydaysdelinquent,sbwithinstallmentdue,srbwithinstallmentdue,AMOUNTOFCREDITSCTD,
gracedaysstatus,accountgracestatus,INTERESTRATE1,BEGINNINGBALANCE,CURRENTBALANCE,CURRENTBALANCECO,PRINCIPAL,NEWTRANSACTIONSBSFC,NEWTRANSACTIONSAGG,
NEWTRANSACTIONSACCRUED,REVOLVINGBSFC,REVOLVINGAGG,REVOLVINGACCRUED,AfterCycleRevolvBSFC,PRINCIPAL + PRINCIPALCO,NEWTRANSACTIONSBSFC + REVOLVINGBSFC + AfterCycleRevolvBSFC, CPC.PlanUUID
FROM LS_P1MARPRODDB01.ccgs_coreissue.dbo.CPSGMENTACCOUNTS CPS WITH(NOLOCK)
	JOIN LS_P1MARPRODDB01.ccgs_coreissue.dbo.CPSGMENTCREDITCARD CPC WITH(NOLOCK) ON (CPS.ACCTID = CPC.ACCTID)
WHERE cps.parent02AID = 19366594 	

SELECT * FROM BSegment_Primary WITH (NOLOCK) WHERE AccountNumber = '1100011153569151'
SELECT * FROM BSegment_Primary WITH (NOLOCK) WHERE UniversaluniqueID = '2671ce5f-dabb-46d0-9195-2926542c0d5b'

SELECT * FROM BSegment_Secondary WITH (NOLOCK) WHERE ClientID = '2671ce5f-dabb-46d0-9195-2926542c0d5b'

SELECT Parent02AID, * 
FROM CPSgmentAccounts WITH (NOLOCK) 
WHERE acctId = 52033388

SELECT DaysDelinquent, DateOfLastDelinquent, SystemStatus, CCINHPARENT125AID, * FROM LS_P1MARPRODDB01.ccgs_coreauth.dbo.BSegment_Primary WITH (NOLOCK) WHERE acctId = 19366594 

SELECT acctId, RTRIM(AccountNumber) AS AccountNumber, UniversalUniqueID AS AccountUUID, '15991' AS OldSystemStatus,SystemStatus AS NewSystemStatus 
FROM BSegment_Primary WITH (NOLOCK) 
WHERE acctId IN (19366594, 2651783, 9452918, 8980362, 2331990, 9749132, 9407183, 9596679, 4617276, 4191664)

select * from LS_P1MARPRODDB01.ccgs_coreissue.dbo.plandelinquencyrecord with (nolock) where acctId = 19366594  AND TranID = 31039921540

select * from LS_P1MARPRODDB01.ccgs_coreissue.dbo.plandelinquencyrecord with (nolock) where tranref IN (48496166292)

select * from LS_P1MARPRODDB01.ccgs_coreissue.dbo.delinquencyrecord with (nolock) where tranid IN (48496166292)


select   * from LS_P1MARPRODDB01.ccgs_coreissue.dbo.purchasereversalrecord with(nolock) where parent02aid= 19366594 

SELECT transactionamount, ClientID, EmbAcctId,* FROM CCard_Primary WITH (NOLOCK) WHERE accountnumber  = '1100011145708065'  AND CMTTranType = '21' order by posttime  desc
SELECT * FROm LS_P1MARPRODDB01.ccgs_coreissue.dbo.Version with (nolock) order by 1 desc

SELECT * FROm LS_P1MARPRODDB01.ccgs_coreissue.dbo.PaymentHoldFileProcessing with (nolock) order by 1 desc
--53522147129
--046a6769-ec25-42d7-97e1-0edf6c931d9b

SELECT mergeactivityflag, PreparedBy,BSAcctid,  CP.CMTTRANTYPE, CP.TransactionDescription, 
CP.TxnSource,CP.TxnAcctId,Trantime,CP.PostTime, CP.creditplanmaster, CP.TransactionAmount, CP.PaymentCreditFlag,
CP.TranId,CP.TranRef,CP.tranorig,CP.TransmissionDateTime,CP.atid,CP.RevTgt,CP.MemoIndicator, NoblobIndicator, InvoiceNumber,
CP.PostingRef,CS.CardAcceptorNameLocation, Transactionidentifier,
CP.TxnCode_Internal,CP.ARTxnType,CP.NoBlobIndicator,CP.CaseID, CP.RMATranUUID, CP.TransactionDescription, 
CP.MergeActivityFlag, CP.HostMachineName, CP.ClaimID, CP.EmbAcctID, CP.ClientId, CP.PartnerId, DisputeIndicator, TransactionLifeCycleUUID
--,CP.*
FROM LS_P1MARPRODDB01.ccgs_coreissue.dbo.CCard_Primary CP WITH (NOLOCK)
LEFT JOIN LS_P1MARPRODDB01.ccgs_coreissue.dbo.CCard_Secondary CS WITH (NOLOCK) ON (CP.TranId = CS.TranId)
WHERE CP.AccountNumber IN (SELECT AccountNumber FROM LS_P1MARPRODDB01.ccgs_coreissue.dbo.BSegment_Primary WITH(NOLOCK) WHERE acctId = 19366594) 
--AND CP.TxnAcctId = 47245123 --AND CP.MemoIndicator IS NULL
--AND CP.TranID IN (59114920431)
--and tranref =54453974818
--AND CMTTranType IN ('40', '49')
--AND TransactionLifeCycleUniqueID = 9617327
--AND RMATranUUID = '3bab2bfb-c584-4764-9ee8-f450fdd59588'
ORDER BY CP.PostTime DESC

SELECT TransactionLifeCycleUUID, *
FROM Auth_Primary WITH (NOLOCK)
WHERE AccountNumber IN (SELECT AccountNumber FROM LS_P1MARPRODDB01.ccgs_coreissue.dbo.BSegment_Primary WITH(NOLOCK) WHERE acctId = 19366594) 
--AND TransactionLifeCycleUniqueID = 9617327
AND TransactionLifeCycleUUID = '16fa4d08-8744-41b1-a207-adef597700de'


SELECT CA.* 
FROM  CCARD_Primary CP WITH (NOLOCK)
JOIN CurrentBalanceAudit CA WITH (NOLOCK) ON (CP.TranID = CA.TID AND CA.ATID = 51 AND CP.BSAcctId = CA.AID)
WHERE CP.CMTTranType = 'P9001' AND Dename = 115 AND Posttime > '2021-12-01'


;WITH CTE AS (
SELECT BSAcctId, TranID FROM  CCARD_Primary CP WITH (NOLOCK) WHERE CMTTranType = 'P9001' AND Posttime > '2021-01-01'
)
SELECT * 
FROM CTE CP
JOIN CurrentBalanceAudit CA WITH (NOLOCK) ON (CP.TranID = CA.TID AND CA.ATID = 51 AND CP.BSAcctId = CA.AID)
WHERE Dename = 115 AND TRY_CAST(NewValue AS INT) > TRY_CAST(Oldvalue AS INT)


SELECT  bsacctid, CPMGroup,CREDITPLANTYPE,accountnumber,CP.CMTTRANTYPE,CP.TRANSACTIONAMOUNT,revtgt,CP.POSTTIME,CP.TRANTIME,CP.TRANID,CP.TxnAcctId, txnsource, CP.ArTxnType,
	memoindicator,transactiondescription,CP.TRANORIG,CP.TRANREF,noblobindicator, TxnCode_Internal
	FROM LS_P1MARPRODDB01.ccgs_coreissue.dbo.CCARD_PRIMARY CP WITH(NOLOCK) 
	LEFT OUTER JOIN LS_P1MARPRODDB01.ccgs_coreissue.dbo.NoBlobTransactionBSFC T WITH(NOLOCK) ON (CP.TRANID = T.TRANID)
	LEFT OUTER JOIN LS_P1MARPRODDB01.ccgs_coreissue.dbo.CPSGMENTACCOUNTS CPS WITH(NOLOCK) ON (CP.BSACCTID = CPS.PARENT02AID AND CP.TXNACCTID = CPS.ACCTID)
WHERE ACCOUNTNUMBER = (SELECT AccountNumber FROM LS_P1MARPRODDB01.ccgs_coreissue.dbo.BSEGMENT_PRIMARY BP WITH(NOLOCK) WHERE acctId = 19366594 ) 
AND CMTTRANTYPE NOT IN ('PPR','MRR', 'HPOTB') 
--AND txnacctid = 34446562
--AND CP.TranID = 39108607533
ORDER BY CP.POSTTIME DESC


SELECT TOP 16 sh.statementdate,sh.amountoftotaldue,srbwithinstallmentdue,creditplantype,sh.amountoftotaldue,sh.acctid,APR,amountofcreditsaspmtctd,SH.CURRENTBALANCE,SH.PRINCIPAL,SH.BEGINNINGBALANCE
	,SH.CurrentBalance - CSH.CurrentBalance AS UPD_CurrentBalance
	,SH.Principal - CSH.Principal AS UPD_Principal
	,SH.BeginningBalance - CSH.BeginningBalance AS UPD_BeginningBalance
	,SC.NEWTRANSACTIONSBSFC,SC.REVOLVINGBSFC,SC.AFTERCYCLEREVOLVBSFC,SH.STATEMENTDATE,AmountOfCreditsAsPmtCTD,AmountOfReturnsCTD
	,SC.NEWTRANSACTIONSBSFC+SC.REVOLVINGBSFC,
	SH.amountoftotaldue,SC.currentdue,SC.AmtOfPayXDLate,SC.AmountOfPayment30DLate,SC.AmountOfPayment60DLate,
 SC.AmountOfPayment90DLate,SC.AmountOfPayment120DLate ,
 SC.AmountOfPayment150DLate,SC.AmountOfPayment180DLate,SC.AmountOfPayment210DLate
FROM SummaryHeader SH WITH(NOLOCK)
	JOIN SummaryHeaderCreditCard SC WITH(NOLOCK) ON (SH.AcctId = SC.AcctId AND SH.StatementId = SC.StatementId)
	JOIN CurrentSummaryHeader CSH WITH(NOLOCK) ON (SH.AcctId = CSH.AcctId AND SH.StatementDate = CSH.StatementDate)
WHERE PARENT02AID = 19366594  ORDER BY SH.StatementDate DESC


select TOP 100 S.StatementID,s.statementdate,lad,systemstatus,currentbalance, currentbalanceco,pschpaymentamount,principal,IntBilledNotPaid,recoveryfeesbnp,DisputesAmtNS,
SRBWithInstallmentDue,CYCLEDUEDTD,amountoftotaldue,AmtOfPayCurrDue,AmtOfPayXDLate,AmountOfPayment30DLate,AmountOfPayment60DLate,
AmountOfPayment90DLate,AmountOfPayment120DLate, 
AmountOfPayment150DLate,AmountOfPayment180DLate,AmountOfPayment210DLate,AmountOfDebitsCTD,AmountofPurchasesCTD,AmountOfcreditsCTD,amountofpaymentsctd,accountnumber
from LS_P1MARPRODDB01.ccgs_coreissue_secondary.dbo.statementheader s with(nolock) 
join LS_P1MARPRODDB01.ccgs_coreissue.dbo.statementheaderex st on (s.statementid = st.statementid)
where s.parent02aid = 19366594   --and s.statementdate  =@Statementdate  
order by s.statementdate desc

SELECT SH.acctId, SH.StatementID,StatementHID, SH.StatementDate, CreditPlanType, DisputesAmtNS,SH.AmountOfTotalDue, SHCC.CycleDueDTD, AmountOFPaymentsCTD, CurrentBalance, 
CurrentBalanceCO,Principal, PrincipalCO, OriginalPurchaseAmount, AmountOfCreditsLTD, AmountOfCreditsRevLTD,
srbwithinstallmentdue, SHCC.sbwithinstallmentdue,
 shcc.CurrentDue,SHCC.AmtOfPayXDLate,SHCC.AmountOfPayment30DLate, SHCC.AmountOfPayment60DLate, SHCC.AmountOfPayment90DLate, AmountOfPayment120DLate, AmountOfPayment150DLate, AmountOfPayment180DLate, AmountOfPayment210DLate,
(CurrentDue+AmtOfPayXDLate+AmountOfPayment30DLate+ AmountOfPayment60DLate+ AmountOfPayment90DLate+ AmountOfPayment120DLate+ AmountOfPayment150DLate+ AmountOfPayment180DLate + AmountOfPayment210DLate) AS CalculatedAD, 
CreditBalanceMovement, EqualPaymentAmt
FROM LS_P1MARPRODDB01.ccgs_coreissue_secondary.dbo.SummaryHeader SH WITH (NOLOCK)
JOIN LS_P1MARPRODDB01.ccgs_coreissue.dbo.SummaryHeaderCreditCard SHCC WITH (NOLOCK) ON (SH.acctId = SHCC.acctId AND SH.StatementID = SHCC.StatementID)
WHERE SH.parent02AID = 19366594 
AND SH.acctId = 76971341
--AND SH.StatementDate = '2022-09-30 23:59:57.000'
ORDER BY StatementDate DESC

SELECT TOP 100 acctId,accountnumber, beginningbalance,CurrentBalance,ccinhParent125AID, SystemStatus, CycleDueDTD, SH.StatementID, SH.StatementDate, Principal, MinimumPaymentDue, AmountOFPaymentsCTD,  
SBWithInstallmentDue, SRBWithInstallmentDue, SH.AmountOfTotalDue,amtofpaycurrdue,AmtOfPayXDLate,AmountOfPayment30DLate, AmountOfPayment60DLate, 
AmountOfPayment90DLate, AmountOfPayment120DLate, AmountOfPayment150DLate, AmountOfPayment180DLate,AmountOfPayment210DLate,
(amtofpaycurrdue+AmtOfPayXDLate+AmountOfPayment30DLate+ AmountOfPayment60DLate+ AmountOfPayment90DLate+ AmountOfPayment120DLate+ AmountOfPayment150DLate+ AmountOfPayment180DLate+ AmountOfPayment210DLate) AS CalculatedAD,
SH.CycleDueDTD, DateOfOriginalPaymentDueDTD, SystemStatus, CCInhParent125AID, CurrentBalance, CurrentBalanceCO, ManualInitialChargeOffReason, AutoInitialChargeOffReason, WaiveMinDue,AmtOfPaymentRevCTD,AmtOfNSFPayRevCTD
FROM LS_P1MARPRODDB01.ccgs_coreissue_secondary.dbo.StatementHeader SH WITH (NOLOCK)
WHERE SH.acctID = 19366594 
AND SH.StatementDate = '2022-08-31 23:59:57.000'
ORDER BY StatementDate DESC

select   * from LS_P1MARPRODDB01.ccgs_coreissue.dbo.DelinquencyFreezeCycle with(nolock) where acctId = 19366594 ORDER BY StatementDate


SELECT *
FROM LS_P1MARPRODDB01.ccgs_coreissue.dbo.MergeStatementHeader WITH (NOLOCK)
WHERE acctId = 19366594



SELECT SH1.StatementDate, SH1.AmountOfTotalDue,SH1.amtofpaycurrdue,SH1.AmtOfPayXDLate,SH1.AmountOfPayment30DLate, SH1.AmountOfPayment60DLate, SH1.AmountOfPayment90DLate, SH1.AmountOfPayment120DLate,SH1.CycleDueDTD, 
SH2.StatementDate, SH2.AmountOfTotalDue,SH2.amtofpaycurrdue,SH2.AmtOfPayXDLate,SH2.AmountOfPayment30DLate, SH2.AmountOfPayment60DLate, SH2.AmountOfPayment90DLate, SH2.AmountOfPayment120DLate,SH2.CycleDueDTD
FROM LS_P1MARPRODDB01.ccgs_coreissue_secondary.dbo.StatementHeader SH1 WITH (NOLOCK)
JOIN LS_P1MARPRODDB01.ccgs_coreissue_secondary.dbo.StatementHeader SH2 WITH (NOLOCK) ON (SH1.acctId = SH2.acctId AND SH1.StatementDate = '2020-05-31 23:59:57.000' AND SH2.StatementDate = '2020-05-31 23:59:57.000')
WHERE SH1.acctID = 19366594 


SELECT Principal,currentbalance,amountoftotaldue,cycleduedtd,amtofpaycurrdue,srbwithinstallmentdue,* FROM PlanInfoForReport WITH(NOLOCK) WHERE CPSAcctid = 3453140 and businessday >'2019-12-31' ORDER BY BusinessDay DESC

SELECT Principal,currentbalance,amountoftotaldue,cycleduedtd,amtofpaycurrdue,srbwithinstallmentdue,* FROM AccountInfoForReport WITH(NOLOCK) WHERE BSAcctid = 487266 and businessday >'2019-12-01' ORDER BY BusinessDay DESC

SELECT ACCOUNTNUMBER,REJECTBATCHACCTID,batchacctid,* FROM CCARD_PRIMARY WITH(NOLOCK) WHERE TRANID = 23309609083
SELECT * FROM LOGARTXNADDL WITH(NOLOCK) WHERE TRANID = 23309609083
select * from trans_in_acct tia with(nolock) where tran_id_index = 23309609083
select * from batchaccounts with(nolock) where acctid = 1354958

select * from LS_P1MARPRODDB01.ccgs_coreissue.dbo.statementjobs with(nolock) where acctid = 341192 order by statementdate desc

select CP.ACCOUNTNUMBER,CP.NOBLOBINDICATOR,CP.CMTTRANTYPE,cp.transactionamount, D.* from LS_P1MARPRODDB01.ccgs_coreissue.dbo.plandelinquencyrecord D with(nolock) 
	JOIN CCARD_PRIMARY CP WITH(NOLOCK) ON (D.TRANID = CP.TRANID)
where cp.accountnumber = (SELECT AccountNumber FROM LS_P1MARPRODDB01.ccgs_coreissue.dbo.BSEGMENT_PRIMARY BP WITH(NOLOCK) WHERE acctId = 19366594 ) order by posttime desc   

select  CP.CMTTRANTYPE,CP.TRANSACTIONAMOUNT,CP.POSTTIME,CP.TRANTIME,D.* from LS_P1MARPRODDB01.ccgs_coreissue.dbo.delinquencyrecord D with(nolock) 
	JOIN CCARD_PRIMARY CP WITH(NOLOCK) ON (D.TRANID = CP.TRANID)
where CP.ACCOUNTNUMBER = (SELECT AccountNumber FROM LS_P1MARPRODDB01.ccgs_coreissue.dbo.BSEGMENT_PRIMARY BP WITH(NOLOCK) WHERE acctId = 19366594 ) ORDER BY CP.TRANTIME DESC

SELECT  bsacctid,CREDITPLANTYPE,accountnumber,CP.CMTTRANTYPE,CP.TRANSACTIONAMOUNT,revtgt,CP.POSTTIME,CP.TRANTIME,CP.TRANID,CASEID,
	memoindicator,transactiondescription,CP.TRANORIG,CP.TRANREF,noblobindicator
	,T.* FROM LS_P1MARPRODDB01.ccgs_coreissue.dbo.CCARD_PRIMARY CP WITH(NOLOCK) 
	LEFT OUTER JOIN LS_P1MARPRODDB01.ccgs_coreissue.dbo.NoBlobTransactionBSFC T WITH(NOLOCK) ON (CP.TRANID = T.TRANID)
	LEFT OUTER JOIN LS_P1MARPRODDB01.ccgs_coreissue.dbo.CPSGMENTACCOUNTS CPS WITH(NOLOCK) ON (CP.BSACCTID = CPS.PARENT02AID AND CP.TXNACCTID = CPS.ACCTID)
WHERE ACCOUNTNUMBER = (SELECT AccountNumber FROM LS_P1MARPRODDB01.ccgs_coreissue.dbo.BSEGMENT_PRIMARY BP WITH(NOLOCK) WHERE acctId = 19366594 ) 
--AND CMTTRANTYPE NOT IN ('PPR','MRR', 'HPOTB','<REV>','40') AND MemoIndicator IS NULL
--AND CMTTRANTYPE IN ('22', '21', '26')
AND CP.POSTTIME >= '2021-05-31 23:59:57.000'
ORDER BY CP.POSTTIME DESC

select * from LS_P1MARPRODDB01.ccgs_coreissue.dbo.plandelinquencyrecord with(nolock) where tranref= 29459320369

select * from LS_P1MARPRODDB01.ccgs_coreissue.dbo.delinquencyrecord with(nolock) where tranid= 29459320369

SELECT * FROM LS_P1MARPRODDB01.ccgs_coreissue.dbo.PlanDelinquencyRecord WITH (NOLOCK) WHERE acctId = 624827 AND TranId = 28551827229

SELECT * FROM LS_P1MARPRODDB01.ccgs_coreissue.dbo.DelinquencyRecord WITH (NOLOCK) WHERE acctId = 19366594  AND TranId = 29459320369


select * from planinfoforreport with(nolock) where bsacctid =19366594   order by businessday desc 

select * from LS_P1MARPRODDB01.ccgs_coreissue.dbo.currentbalanceaudit with(nolock) where aid = 19366594  /*AND dename IN (200, 115, 111)*/ order by businessday desc, IdentityField desc
select * from LS_P1MARPRODDB01.ccgs_coreissue.dbo.currentbalanceauditPS with(nolock) where aid in(10279455) AND dename IN (115, 200, 111) order by businessday desc
select * from LS_P1MARPRODDB01.ccgs_coreissue.dbo.currentbalanceauditPS with(nolock) where aid in(4540162) /*AND dename = 200*/ order by businessday desc
select * from LS_P1MARPRODDB01.ccgs_coreissue.dbo.currentbalanceauditPS with(nolock) where aid in(10770902) /*AND dename = 200*/ order by businessday desc

select * from currentbalanceaudit with(nolock) where aid = 19366594  AND tid = 24846150868 order by businessday desc
select * from currentbalanceaudit with(nolock) where aid = 19366594  AND tid = 24871899804 order by businessday desc
select * from currentbalanceaudit with(nolock) where aid = 19366594  AND tid = 24858883418 order by businessday desc

select * from currentbalanceauditPS with(nolock) where aid = 4884283 AND tid = 24858887226 order by businessday desc

select * from currentbalanceauditPS with(nolock) where tid = 24858887226 order by businessday desc

SELECT A.BusinessDay,SystemStatus, CycleDueDTD,CurrentBalance,DateAcctClosed, CurrentbalanceCO,CycleDueDTD, AmountOfTotalDue, AmtOfPayCurrDue, AmtOfPayXDLate, RunningMinimumDue, RemainingMinimumDue, 
AmountOfPayment30DLate, AmountOfPayment60DLate, DaysDelinquent, TotalDaysDelinquent, ManualInitialChargeOffReason, AutoInitialChargeOffReason,
DateOfDelinquency, DateOfOriginalPaymentDueDTD, SystemStatus, CCInhParent125AID,AmtOfPayXDLate,* 
FROM LS_P1MARPRODDB01.ccgs_coreissue.dbo.AccountInfoForReport A WITH (NOLOCK) 
WHERE BSAcctid = 19366594  AND A.BusinessDay >= '2021-03-01 23:59:57.000'
order by A.businessday desc

SELECT CycleDueDTD, AmountOfTotalDue, AmtOfPayCurrDue, AmtOfPayXDLate, AmountOfPayment60DLate, * 
FROM PlanInfoForReport WITH (NOLOCK) 
WHERE CPSAcctID = 13108258 AND BusinessDay >= '2021-03-01 23:59:57.000'
order by businessday desc

SELECT CycleDueDTD, AmountOfTotalDue, AmtOfPayCurrDue, AmtOfPayXDLate, AmountOfPayment60DLate, * 
FROM PlanInfoForReport WITH (NOLOCK) 
WHERE BSAcctID = 19366594 AND BusinessDay = '2021-03-01 23:59:57.000'
order by businessday desc

SELECT ChangeStatusFor,* FROM NonMonetaryLog WITH (NOLOCK) WHERE AccountNumber = (
SELECT AccountNumber FROM Bsegment_Primary WITH (NOLOCK) WHERE acctId = 19366594 )
--AND ChangeStatusFor = 'Disaster Recovery'
ORDER BY RequestDateTime DESC

SELECT a.APIName, T.* FROM TCIVRRequest T with (NOLOCK) 
JOIN APIMaster a WITH (NOLOCK) ON (T.RequestName = a.APICode)
WHERE T.AccountNumber = (
SELECT AccountNumber FROM Bsegment_Primary WITH (NOLOCK) WHERE acctId = 19366594 )
ORDER BY T.RequestDate DESC

SELECT * FROM TCIVRRequest T with (NOLOCK) WHERE AccountNumber = '1100011105818854' ORDER BY RequestDate DESC

SELECT SystemStatus,* FROM LS_P1MARPRODDB01.ccgs_coreauth.dbo.Bsegment_Primary WITH (NOLOCK) WHERE acctId = 19366594 

SELECT * 
FROM LS_P1MARPRODDB01.ccgs_coreissue.dbo.CurrentBalanceAuditPS WITH (NOLOCK)
WHERE AID IN (SELECT acctId FROM CPSgmentAccounts WITH (NOLOCK) WHERE Parent02AID = 19366594)
--AND DENAME IN ( 115)
AND Businessday = '2021-05-31 23:59:57.000'
AND AID = 10013449

SELECT * 
FROM LS_P1MARPRODDB01.ccgs_coreissue.dbo.CurrentBalanceAuditPS WITH (NOLOCK)
WHERE AID IN (SELECT acctId FROM CPSgmentAccounts WITH (NOLOCK) WHERE Parent02AID = 19366594)
--AND DENAME IN (200)
AND Businessday > '2021-05-31 23:59:57.000'
AND AID = 47566268
--AND TID = 41482589841
ORDER BY Businessday DESC

SELECT * 
FROM LS_P1MARPRODDB01.ccgs_coreissue.dbo.CurrentBalanceAudit WITH (NOLOCK)
WHERE AID IN (19366594)
--AND DENAME IN (115)
AND Businessday = '2021-08-31 23:59:57.000'

SELECT * 
FROM LS_P1MARPRODDB01.ccgs_coreissue.dbo.CurrentBalanceAudit WITH (NOLOCK)
WHERE AID IN (19366594)
--AND DENAME IN (115)
AND Businessday > '2021-08-31 23:59:57.000'
--AND TID =  38713367776-- 34709682650
ORDER BY Businessday DESC


--SELECT BP.acctId, DaysDelinquent, CycleDueDTD, SystemStatus, ChargeOffDate AS VARCHAR,
--'UPDATE BSegmentCreditCard SET DtOfLastDelinqCTD = ''' + CONVERT(VARCHAR(50), ChargeOffDate, 20) + '''' + ', DateOfOriginalPaymentDueDTD = ''' + CONVERT(VARCHAR(50), ChargeOffDate, 20) + '''' + ', FirstDueDate = ''' + CONVERT(VARCHAR(50), ChargeOffDate, 20) + '''' + ', DaysDelinquent = 0, NoPayDaysDelinquent = 0 WHERE acctId = ' + TRY_CAST(bp.acctId AS VARCHAR),
--'UPDATE AccountInfoForReport SET DateOfDelinquency = ''' + CONVERT(VARCHAR(50), ChargeOffDate, 20) + '''' + ', DateOfOriginalPaymentDueDTD = ''' + CONVERT(VARCHAR(50), ChargeOffDate, 20) + '''' + ', FirstDueDate = ''' + CONVERT(VARCHAR(50), ChargeOffDate, 20) + '''' + ', DaysDelinquent = 0, TotalDaysDelinquent = 0 WHERE BSacctId = ' + TRY_CAST(bp.acctId AS VARCHAR)
--FROM BSegment_Primary BP WITH (NOLOCK)
--JOIN BSegmentCreditCard BCC WITH (NOLOCK) ON (BP.acctId = BCC.acctId)
--WHERE CycleDueDTD <= 1 AND DaysDelinquent > 0 AND SystemStatus = 14

SELECT
	BP.acctId, TRY_CONVERT(DATETIME, CONVERT(VARCHAR, CAST(DateOfOriginalPaymentDueDTD AS DATE)) + ' 23:59:57'), NoPayDaysDelinquent, DaysDelinquent, DtOfLastDelinqCTD, 
	TRY_CONVERT(DATETIME, CONVERT(VARCHAR, CAST(DateOfOriginalPaymentDueDTD AS DATE)) + ' 23:59:57'), LAD, DeAcctActivityDate, ccinhparent125AID, 
	ActualDRPStartDate, CycleDueDTD, SystemStatus, DaysDelinquent, NoPayDaysDelinquent
FROM BsegmentCreditCard BCC WITH (NOLOCK)
INNER JOIN BSegment_Primary BP WITH (NOLOCK) ON (BP.acctId = BCC.acctId)
WHERE BP.acctId = 19366594


---------------------------------------------------------------------------------------
DECLARE @BSAcctId INT, @CPSAcctID INT, @BusinessDay DATETIME

SET @BSAcctId = 19366594 
SET @BusinessDay = '2021-08-06 23:59:57'

SELECT 'AIR====>', 
BusinessDay, BSAcctId, AmtOfPayCurrDue, AmtOfPayXDLate, AmountOfTotalDue, CycleDueDTD, SRBWithInstallmentDue, SBWithInstallmentDue, AccountGraceStatus, RunningMinimumDue, SystemStatus,
RemainingMinimumDue, ManualInitialChargeOffReason, AutoInitialChargeOffReason, DateOfDelinquency, DateOfOriginalPaymentDueDTD, currentbalanceco,currentbalance, ccinhparent125aid
FROM LS_P1MARPRODDB01.ccgs_coreissue_secondary.dbo.AccountInfoForReport WITH (NOLOCK) 
WHERE BusinessDay = @BusinessDay
AND BSAcctId = @BSAcctId

DECLARE db_Cursor CURSOR FOR
SELECT acctId FROM CPSgmentAccounts WITH (NOLOCK) WHERE Parent02AID = @BSAcctId

OPEN db_Cursor
FETCH NEXT FROM db_cursor INTO @CPSAcctID


WHILE @@FETCH_STATUS = 0 
BEGIN
	SELECT 'PIR====>',
	BusinessDay, BSAcctId, CPSAcctId, CreditPlanType, CurrentBalance, AmtOfPayCurrDue, AmtOfPayXDLate, AmountOfTotalDue, CycleDueDTD, SRBWithInstallmentDue, SBWithInstallmentDue, IntBilledNotPaid
	FROM LS_P1MARPRODDB01.ccgs_coreissue_secondary.dbo.PlanInfoForReport WITH (NOLOCK) 
	WHERE BusinessDay = @BusinessDay
	AND CPSAcctId = @CPSAcctID

	FETCH NEXT FROM db_cursor INTO @CPSAcctID
END


CLOSE db_Cursor
DEALLOCATE db_Cursor

---------------------------------------------------------------------------------------



SELECT BSAcctID, CycleDueDTD, AmountOfTotalDue, CurrentBalance, TotalDaysDelinquent, DaysDelinquent, DateOfOriginalPaymentDueDTD, DateOfDelinquency, 
'UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 1, DaysDelinquent = 1, DateOfOriginalPaymentDueDTD = ''2021-09-30 23:59:57.000'' WHERE BSAcctID = ' + TRY_CAST(BSAcctID AS VARCHAR) + ' AND BusinessDay = ''2021-09-30 23:59:57.000'''
FROM LS_P1MARPRODDB01.ccgs_coreissue_secondary.dbo.AccountInfoForReport AIR WITH (NOLOCK) 
WHERE AIR.BusinessDay = '2021-09-30 23:59:57.000'
--AND CycleDueDTD > 1 AND DateOfOriginalPaymentDueDTD IS NULL
AND BSAcctId In (11945315)

SELECT AcctID, CurrentBalance, CycleDueDTD, DateOfOriginalPaymentDueDTD
FROM LS_P1MARPRODDB01.ccgs_coreissue_secondary.dbo.StatementHeader AIR WITH (NOLOCK) 
WHERE AIR.StatementDate = '2021-09-30 23:59:57.000'
--AND CurrentBalance <= 0 
AND AcctId IN (1075129,1860208,4620669,4725201,15129357,241303,442759,9591604,13382512)
AND SystemStatus <> 14



