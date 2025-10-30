--select * from version with (nolock) order by entryid desc

select * from sys.servers

SELECT BP.acctId, DeAcctActivityDate, BP.SystemStatus, runningminimumdue,remainingminimumdue,ltrim(rtrim(accountnumber)) AS accountnumber,chargeoffdate, DateAcctClosed, CurrentBalance, CurrentBalanceCO, Principal, PrincipalCO,
cycleduedtd, amountofpaymentsctd,amountoftotaldue,amtofpaycurrdue,AmtOfPayXDLate,AmountOfPayment30DLate, AmountOfPayment60DLate, 
AmountOfPayment90DLate, AmountOfPayment120DLate, AmountOfPayment150DLate, AmountOfPayment180DLate, AmountOfPayment210DLate,
(amtofpaycurrdue+AmtOfPayXDLate+AmountOfPayment30DLate+ AmountOfPayment60DLate+ AmountOfPayment90DLate+ AmountOfPayment120DLate+ AmountOfPayment150DLate+ AmountOfPayment180DLate + AmountOfPayment210DLate) AS CalculatedAD,
daysdelinquent,nopaydaysdelinquent,BS.firstduedate,dateoforiginalpaymentduedtd, BS.DtOfLastDelinqCTD, BeginningBalance
,Statementremainingbalance, sbwithinstallmentdue, srbwithinstallmentdue,amountofcreditsctd,BP.SYSTEMSTATUS,CCINHPARENT125AID,accountnumber,BP.ACCTID,amtofpaycurrdue,
amountoftotaldue,BP.CURRENTBALANCE,CURRENTBALANCECO,BP.PRINCIPAL,NEWTRANSACTIONSBSFC,NEWTRANSACTIONSAGG,
	NEWTRANSACTIONSACCRUED,REVOLVINGBSFC,REVOLVINGAGG,REVOLVINGACCRUED,AfterCycleRevolvBSFC, ManualInitialChargeOffReason, AutoInitialChargeOffReason
FROM BSEGMENT_PRIMARY BP WITH(NOLOCK)
	JOIN BSEGMENTCREDITCARD BS WITH(NOLOCK) ON (BP.ACCTID = BS.ACCTID)
WHERE  bp.acctid = 14551527 

SELECT CPS.ACCTID,creditplantype, CPC.OriginalPurchaseAmount,CPC.cycleduedtd,CPC.amountoftotaldue, CurrentBalance, CurrentBalanceCO, CPS.Principal, PrincipalCO, EqualPaymentAmt, intbillednotpaid, amountofpaymentsctd,
CPC.amtofpaycurrdue,AmtOfPayXDLate,AmountOfPayment30DLate, CPC.AmountOfPayment60DLate, 
AmountOfPayment90DLate, AmountOfPayment120DLate, AmountOfPayment150DLate, AmountOfPayment180DLate,
(amtofpaycurrdue+AmtOfPayXDLate+AmountOfPayment30DLate+ AmountOfPayment60DLate+ AmountOfPayment90DLate+ AmountOfPayment120DLate+ AmountOfPayment150DLate+ AmountOfPayment180DLate + AmountOfPayment210DLate) AS CalculatedAD,
daysdelinquent,nopaydaysdelinquent,sbwithinstallmentdue,srbwithinstallmentdue,AMOUNTOFCREDITSCTD,
gracedaysstatus,accountgracestatus,INTERESTRATE1,BEGINNINGBALANCE,CURRENTBALANCE,CURRENTBALANCECO,PRINCIPAL,NEWTRANSACTIONSBSFC,NEWTRANSACTIONSAGG,
NEWTRANSACTIONSACCRUED,REVOLVINGBSFC,REVOLVINGAGG,REVOLVINGACCRUED,AfterCycleRevolvBSFC,PRINCIPAL + PRINCIPALCO,NEWTRANSACTIONSBSFC + REVOLVINGBSFC + AfterCycleRevolvBSFC, CPC.PlanUUID
FROM CPSGMENTACCOUNTS CPS WITH(NOLOCK)
	JOIN CPSGMENTCREDITCARD CPC WITH(NOLOCK) ON (CPS.ACCTID = CPC.ACCTID)
WHERE cps.PARENT02AID = 14551527 	

SELECT * FROM BSegment_Primary WHERE AccountNumber = '1100001000000047'

SELECT * FROM CPSgmentAccounts WITH (NOLOCK) WHERE acctId = 28226604

SELECT DaysDelinquent, DateOfLastDelinquent, SystemStatus, * FROM PROD1GSDB01.ccgs_coreauth.dbo.BSegment_Primary WITH (NOLOCK) WHERE acctId = 14551527 

SELECT acctId, RTRIM(AccountNumber) AS AccountNumber, UniversalUniqueID AS AccountUUID, '15991' AS OldSystemStatus,SystemStatus AS NewSystemStatus 
FROM BSegment_Primary WITH (NOLOCK) 
WHERE acctId IN (14551527, 2651783, 9452918, 8980362, 2331990, 9749132, 9407183, 9596679, 4617276, 4191664)

select * from plandelinquencyrecord with (nolock) where acctId = 14551527  AND TranID = 31039921540

select * from plandelinquencyrecord with (nolock) where tranref = 8189240474009639

select * from delinquencyrecord with (nolock) where tranid = 8189240474009639



select   * from purchasereversalrecord with(nolock) where parent02aid= 14551527 

SELECT * FROM CCard_Primary WITH (NOLOCK) WHERE TranID = 14551527


SELECT  bsacctid,CREDITPLANTYPE,accountnumber,CP.CMTTRANTYPE,CP.TRANSACTIONAMOUNT,revtgt,CP.POSTTIME,CP.TRANTIME,CP.TRANID,CASEID,CP.TxnAcctId, txnsource,
	memoindicator,transactiondescription,CP.TRANORIG,CP.TRANREF,noblobindicator
	,T.* FROM CCARD_PRIMARY CP WITH(NOLOCK) 
	LEFT OUTER JOIN NoBlobTransactionBSFC T WITH(NOLOCK) ON (CP.TRANID = T.TRANID)
	LEFT OUTER JOIN CPSGMENTACCOUNTS CPS WITH(NOLOCK) ON (CP.BSACCTID = CPS.PARENT02AID AND CP.TXNACCTID = CPS.ACCTID)
WHERE ACCOUNTNUMBER = (SELECT AccountNumber FROM BSEGMENT_PRIMARY BP WITH(NOLOCK) WHERE acctId = 14551527 ) 
AND CMTTRANTYPE NOT IN ('PPR','MRR', 'HPOTB') 
--AND txnacctid = 34446562
--AND CP.TranID = 33256638245
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
WHERE PARENT02AID = 14551527  ORDER BY SH.StatementDate DESC


select TOP 10 S.StatementID,s.statementdate,lad,systemstatus,currentbalance, currentbalanceco,pschpaymentamount,principal,IntBilledNotPaid,recoveryfeesbnp,DisputesAmtNS,
SRBWithInstallmentDue,CYCLEDUEDTD,amountoftotaldue,AmtOfPayCurrDue,AmtOfPayXDLate,AmountOfPayment30DLate,AmountOfPayment60DLate,
AmountOfPayment90DLate,AmountOfPayment120DLate, 
AmountOfPayment150DLate,AmountOfPayment180DLate,AmountOfPayment210DLate,AmountOfDebitsCTD,AmountofPurchasesCTD,AmountOfcreditsCTD,amountofpaymentsctd,accountnumber
from statementheader s with(nolock) 
join statementheaderex st on (s.statementid = st.statementid)
where s.parent02aid = 14551527   --and s.statementdate  =@Statementdate  
order by s.statementdate desc

SELECT SH.acctId, SH.StatementID, StatementDate, SHCC.CycleDueDTD, SH.AmountOfCreditsLTD, SH.AmountOfCreditsCTD,Principal, PrincipalCO, srbwithinstallmentdue, SHCC.sbwithinstallmentdue,
SH.AmountOfTotalDue, shcc.CurrentDue,SHCC.AmtOfPayXDLate,SHCC.AmountOfPayment30DLate, SHCC.AmountOfPayment60DLate, SHCC.AmountOfPayment90DLate, AmountOfPayment120DLate, AmountOfPayment150DLate, AmountOfPayment180DLate, AmountOfPayment210DLate,
(CurrentDue+AmtOfPayXDLate+AmountOfPayment30DLate+ AmountOfPayment60DLate+ AmountOfPayment90DLate+ AmountOfPayment120DLate+ AmountOfPayment150DLate+ AmountOfPayment180DLate + AmountOfPayment210DLate) AS CalculatedAD, CreditBalanceMovement
FROM SummaryHeader SH WITH (NOLOCK)
JOIN SummaryHeaderCreditCard SHCC WITH (NOLOCK) ON (SH.acctId = SHCC.acctId AND SH.StatementID = SHCC.StatementID)
WHERE SH.parent02AID = 14551527 --AND SH.acctId = 33706671
ORDER BY StatementDate DESC

SELECT TOP 10 acctId, SystemStatus, CycleDueDTD, SH.StatementID, StatementDate, Principal, MinimumPaymentDue, AmountOFPaymentsCTD, SBWithInstallmentDue, SRBWithInstallmentDue, SH.AmountOfTotalDue,amtofpaycurrdue,AmtOfPayXDLate,AmountOfPayment30DLate, AmountOfPayment60DLate, 
AmountOfPayment90DLate, AmountOfPayment120DLate, AmountOfPayment150DLate, AmountOfPayment180DLate,AmountOfPayment210DLate,
(amtofpaycurrdue+AmtOfPayXDLate+AmountOfPayment30DLate+ AmountOfPayment60DLate+ AmountOfPayment90DLate+ AmountOfPayment120DLate+ AmountOfPayment150DLate+ AmountOfPayment180DLate+ AmountOfPayment210DLate) AS CalculatedAD,
SH.CycleDueDTD, DateOfOriginalPaymentDUeDTD, SystemStatus, CCInhParent125AID, CurrentBalance, CurrentBalanceCO, ManualInitialChargeOffReason, AutoInitialChargeOffReason
FROM StatementHeader SH WITH (NOLOCK)
WHERE SH.acctID = 14551527 
ORDER BY StatementDate DESC

SELECT SH1.StatementDate, SH1.AmountOfTotalDue,SH1.amtofpaycurrdue,SH1.AmtOfPayXDLate,SH1.AmountOfPayment30DLate, SH1.AmountOfPayment60DLate, SH1.AmountOfPayment90DLate, SH1.AmountOfPayment120DLate,SH1.CycleDueDTD, 
SH2.StatementDate, SH2.AmountOfTotalDue,SH2.amtofpaycurrdue,SH2.AmtOfPayXDLate,SH2.AmountOfPayment30DLate, SH2.AmountOfPayment60DLate, SH2.AmountOfPayment90DLate, SH2.AmountOfPayment120DLate,SH2.CycleDueDTD
FROM StatementHeader SH1 WITH (NOLOCK)
JOIN StatementHeader SH2 WITH (NOLOCK) ON (SH1.acctId = SH2.acctId AND SH1.StatementDate = '2020-05-31 23:59:57.000' AND SH2.StatementDate = '2020-04-30 23:59:57.000')
WHERE SH1.acctID = 14551527 


SELECT Principal,currentbalance,amountoftotaldue,cycleduedtd,amtofpaycurrdue,srbwithinstallmentdue,* FROM PlanInfoForReport WITH(NOLOCK) WHERE CPSAcctid = 3453140 and businessday >'2019-12-31' ORDER BY BusinessDay DESC

SELECT Principal,currentbalance,amountoftotaldue,cycleduedtd,amtofpaycurrdue,srbwithinstallmentdue,* FROM AccountInfoForReport WITH(NOLOCK) WHERE BSAcctid = 487266 and businessday >'2019-12-01' ORDER BY BusinessDay DESC

SELECT ACCOUNTNUMBER,REJECTBATCHACCTID,batchacctid,* FROM CCARD_PRIMARY WITH(NOLOCK) WHERE TRANID = 23309609083
SELECT * FROM LOGARTXNADDL WITH(NOLOCK) WHERE TRANID = 23309609083
select * from trans_in_acct tia with(nolock) where tran_id_index = 23309609083
select * from batchaccounts with(nolock) where acctid = 1354958

select * from statementjobs with(nolock) where acctid = 341192 order by statementdate desc

select CP.ACCOUNTNUMBER,CP.NOBLOBINDICATOR,CP.CMTTRANTYPE,cp.transactionamount, D.* from plandelinquencyrecord D with(nolock) 
	JOIN CCARD_PRIMARY CP WITH(NOLOCK) ON (D.TRANID = CP.TRANID)
where cp.accountnumber = (SELECT AccountNumber FROM BSEGMENT_PRIMARY BP WITH(NOLOCK) WHERE acctId = 14551527 ) order by posttime desc   

select  CP.CMTTRANTYPE,CP.TRANSACTIONAMOUNT,CP.POSTTIME,CP.TRANTIME,D.* from delinquencyrecord D with(nolock) 
	JOIN CCARD_PRIMARY CP WITH(NOLOCK) ON (D.TRANID = CP.TRANID)
where CP.ACCOUNTNUMBER = (SELECT AccountNumber FROM BSEGMENT_PRIMARY BP WITH(NOLOCK) WHERE acctId = 14551527 ) ORDER BY CP.TRANTIME DESC

SELECT  bsacctid,CREDITPLANTYPE,accountnumber,CP.CMTTRANTYPE,CP.TRANSACTIONAMOUNT,revtgt,CP.POSTTIME,CP.TRANTIME,CP.TRANID,CASEID,
	memoindicator,transactiondescription,CP.TRANORIG,CP.TRANREF,noblobindicator
	,T.* FROM CCARD_PRIMARY CP WITH(NOLOCK) 
	LEFT OUTER JOIN NoBlobTransactionBSFC T WITH(NOLOCK) ON (CP.TRANID = T.TRANID)
	LEFT OUTER JOIN CPSGMENTACCOUNTS CPS WITH(NOLOCK) ON (CP.BSACCTID = CPS.PARENT02AID AND CP.TXNACCTID = CPS.ACCTID)
WHERE ACCOUNTNUMBER = (SELECT AccountNumber FROM BSEGMENT_PRIMARY BP WITH(NOLOCK) WHERE acctId = 14551527 ) 
--AND CMTTRANTYPE NOT IN ('PPR','MRR', 'HPOTB','<REV>','40') AND MemoIndicator IS NULL
--AND CMTTRANTYPE IN ('22', '21', '26')
AND CP.POSTTIME >= '2021-01-31 23:59:57.000'
ORDER BY CP.POSTTIME DESC

select * from plandelinquencyrecord with(nolock) where tranref= 29459320369

select * from delinquencyrecord with(nolock) where tranid= 29459320369

SELECT * FROM PlanDelinquencyRecord WITH (NOLOCK) WHERE acctId = 624827 AND TranId = 28551827229

SELECT * FROM DelinquencyRecord WITH (NOLOCK) WHERE acctId = 14551527  AND TranId = 29459320369


select * from planinfoforreport with(nolock) where bsacctid =14551527   order by businessday desc 

select * from currentbalanceaudit with(nolock) where aid = 14551527  /*AND dename IN (200, 115, 111)*/ order by businessday desc, IdentityField desc
select * from currentbalanceauditPS with(nolock) where aid in(10279455) AND dename IN (115, 200, 111) order by businessday desc
select * from currentbalanceauditPS with(nolock) where aid in(4540162) /*AND dename = 200*/ order by businessday desc
select * from currentbalanceauditPS with(nolock) where aid in(10770902) /*AND dename = 200*/ order by businessday desc

select * from currentbalanceaudit with(nolock) where aid = 14551527  AND tid = 24846150868 order by businessday desc
select * from currentbalanceaudit with(nolock) where aid = 14551527  AND tid = 24871899804 order by businessday desc
select * from currentbalanceaudit with(nolock) where aid = 14551527  AND tid = 24858883418 order by businessday desc

select * from currentbalanceauditPS with(nolock) where aid = 4884283 AND tid = 24858887226 order by businessday desc

select * from currentbalanceauditPS with(nolock) where tid = 24858887226 order by businessday desc

SELECT A.BusinessDay,SystemStatus, CycleDueDTD,CurrentBalance,DateAcctClosed, CurrentbalanceCO,CycleDueDTD, AmountOfTotalDue, AmtOfPayCurrDue, AmtOfPayXDLate, RunningMinimumDue, RemainingMinimumDue, 
AmountOfPayment30DLate, AmountOfPayment60DLate, DaysDelinquent, TotalDaysDelinquent, ManualInitialChargeOffReason, AutoInitialChargeOffReason,
DateOfDelinquency, DateOfOriginalPaymentDueDTD, SystemStatus, CCInhParent125AID,AmtOfPayXDLate,* 
FROM AccountInfoForReport A WITH (NOLOCK) 
WHERE BSAcctid = 14551527  AND A.BusinessDay >= '2021-01-31 23:59:57.000'
order by A.businessday desc

SELECT CycleDueDTD, AmountOfTotalDue, AmtOfPayCurrDue, AmtOfPayXDLate, AmountOfPayment60DLate, * 
FROM PlanInfoForReport WITH (NOLOCK) 
WHERE CPSAcctID = 13108258 AND BusinessDay >= '2021-01-31 23:59:57.000'
order by businessday desc

SELECT CycleDueDTD, AmountOfTotalDue, AmtOfPayCurrDue, AmtOfPayXDLate, AmountOfPayment60DLate, * 
FROM PlanInfoForReport WITH (NOLOCK) 
WHERE BSAcctID = 14551527 AND BusinessDay = '2021-01-31 23:59:57.000'
order by businessday desc

SELECT ChangeStatusFor,* FROM NonMonetaryLog WITH (NOLOCK) WHERE AccountNumber = (
SELECT AccountNumber FROM Bsegment_Primary WITH (NOLOCK) WHERE acctId = 14551527 )
--AND ChangeStatusFor = 'Disaster Recovery'
ORDER BY RequestDateTime DESC

SELECT a.APIName, T.* FROM TCIVRRequest T with (NOLOCK) 
JOIN APIMaster a WITH (NOLOCK) ON (T.RequestName = a.APICode)
WHERE T.AccountNumber = (
SELECT AccountNumber FROM Bsegment_Primary WITH (NOLOCK) WHERE acctId = 14551527 )
ORDER BY T.RequestDate DESC

SELECT * FROM TCIVRRequest T with (NOLOCK) WHERE AccountNumber = '1100011115872818' ORDER BY RequestDate DESC

SELECT SystemStatus,* FROM PROD1GSDB01.ccgs_coreauth.dbo.Bsegment_Primary WITH (NOLOCK) WHERE acctId = 14551527 

SELECT * FROM CurrentBalanceAuditPS WITH (NOLOCK)
WHERE AID IN (SELECT acctId FROM CPSgmentAccounts WITH (NOLOCK) WHERE Parent02AID = 14551527)
--AND DENAME IN (200, 115)
AND Businessday = '2018-04-30 23:59:57.000'
AND AID = 14551527

SELECT * FROM CurrentBalanceAuditPS WITH (NOLOCK)
WHERE AID IN (SELECT acctId FROM CPSgmentAccounts WITH (NOLOCK) WHERE Parent02AID = 14551527)
--AND DENAME IN (200)
AND Businessday > '2018-04-30 23:59:57.000'
--AND AID = 40235978
AND TID = 34932829063

SELECT * FROM CurrentBalanceAudit WITH (NOLOCK)
WHERE AID IN (14551527)
--AND DENAME IN (115)
AND Businessday = '2018-04-30 23:59:57.000'

SELECT * FROM CurrentBalanceAudit WITH (NOLOCK)
WHERE AID IN (14551527)
--AND DENAME IN (115, 200)
AND Businessday > '2018-04-30 23:59:57.000'
--AND TID =  8189240474009640-- 34709682650
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
WHERE BP.acctId = 14551527


---------------------------------------------------------------------------------------
DECLARE @BSAcctId INT, @CPSAcctID INT, @BusinessDay DATETIME

SET @BSAcctId = 14551527 
SET @BusinessDay = '2018-04-30 23:59:57.000'

SELECT 'AIR====>', 
BSAcctId, AmtOfPayCurrDue, AmtOfPayXDLate, AmountOfTotalDue, CycleDueDTD, SRBWithInstallmentDue, SBWithInstallmentDue, AccountGraceStatus, RunningMinimumDue, SystemStatus,
RemainingMinimumDue, ManualInitialChargeOffReason, AutoInitialChargeOffReason, DateOfDelinquency, DateOfOriginalPaymentDueDTD, currentbalanceco,currentbalance
FROM AccountInfoForReport WITH (NOLOCK) 
WHERE BusinessDay = @BusinessDay
AND BSAcctId = @BSAcctId

DECLARE db_Cursor CURSOR FOR
SELECT acctId FROM CPSgmentAccounts WITH (NOLOCK) WHERE Parent02AID = @BSAcctId

OPEN db_Cursor
FETCH NEXT FROM db_cursor INTO @CPSAcctID


WHILE @@FETCH_STATUS = 0 
BEGIN
	SELECT 'PIR====>',
	BSAcctId, CPSAcctId, CreditPlanType, CurrentBalance, AmtOfPayCurrDue, AmtOfPayXDLate, AmountOfTotalDue, CycleDueDTD, SRBWithInstallmentDue, SBWithInstallmentDue, IntBilledNotPaid
	FROM PlanInfoForReport WITH (NOLOCK) 
	WHERE BusinessDay = @BusinessDay
	AND CPSAcctId = @CPSAcctID

	FETCH NEXT FROM db_cursor INTO @CPSAcctID
END


CLOSE db_Cursor
DEALLOCATE db_Cursor

---------------------------------------------------------------------------------------

