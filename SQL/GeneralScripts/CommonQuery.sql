--DATABASES
USE PARASHAR_CB_CI
USE PARASHAR_CB_CAuth
USE PARASHAR_CB_CC
USE PARASHAR_CB_CL
------------------------------------------------------------------------------Finding Columns------------------------------------------------------------------------------------------------------

 select object_name(object_id),* from  sys.columns with(nolock) where name like  '%daysdelinquent%' and object_name(object_id) like 'bsegment%'

--------------------------------------------------------------------------------BSegment----------------------------------------------------------------------------------------------------------------

select AccountNumber,parent02AID,DateAcctOpened,MTCGrpName,InstitutionID,BillingCycle,ccinhparent127aid,* from BSegment_Primary with(nolock) where accountnumber= '8110000000000026'

select systemstatus,ccinhparent125aid,cycleduedtd,intereststartdate,BP.SystemStatus,BC.ChargeOffDateParam,NewTransactionsBSFC,currentbalance,BeginningBalance,bp.acctid,dateoftotaldue,Amountoftotaldue,
amtofpaycurrdue,AmtOfPayXDLate,AmountOfPayment30DLate,AmountOfPayment60DLate,AmountOfPayment90DLate,AmountOfPayment120DLate,
AmountOfPayment150DLate,AmountOfPayment180DLate,AmountOfPayment210DLate,LastStatementDate,AmountOfDebitsCTD,AmountofPurchasesCTD
,billingcycle,Accountnumber,currentbalance,principal,servicefeesbnp,latefeesbnp
from BSegment_Primary BP  with(nolock) join bsegmentcreditcard  BC  with(nolock) on BP.acctid =BC.acctid join bsegment_secondary BS with(nolock) on BP.acctid =BS.acctid  
JOIN BSegment_Balances bb WITH(NOLOCK) ON bp.ACCTID =BB.ACCTID where BP.acctid in (5000)

SELECT acctid,acctid,BeginningBalance,CurrentBalance,AmountOfDebitsCTD,AmountOfCreditsCTD,AmountOfPurchasesCTD,AmountOfPaymentsCTD,
AmountOfCreditsRevCTD,AmountOfDebitsRevCTD
FROM BSegment_Primary WITH(NOLOCK)
WHERE acctId IN (5000)

select bp.acctId,bp.SystemStatus,CustomerId,bp.CurrentBalance,bp.BeginningBalance,bp.Principal,bs.latefeesbnp,bcc.IntBilledNotPaid,
bs.servicefeesbnp,bs.membershipfeesbnp,bp.CycleDueDTD,bcc.AmountOfTotalDue,
bp.AmtOfPayCurrDue,bcc.AmtOfPayXDLate,bcc.AmountOfPayment30DLate,bcc.AmountOfPayment60DLate,
bcc.AmountOfPayment90DLate,bcc.AmountOfPayment120DLate,bcc.AmountOfPayment150DLate,
bcc.AmountOfPayment180DLate,bcc.AmountOfPayment210DLate,bp.SystemStatus,bp.accountnumber
From BSegment_Primary bp with(nolock) join
BSegment_Secondary bs with(nolock) on bp.acctId = bs.acctId join
BSegmentCreditCard bcc with(nolock) on bp.acctId = bcc.acctId  join
BSegment_Balances bsb with(nolock) on bp.acctId = bsb.acctId
where bp.acctId in (167413)

 SELECT acctid,BeginningBalance,AmountOfDebitsCTD,AmountOfCreditsCTD,AmountOfPurchasesCTD,AmountOfPaymentsCTD,
AmountOfCreditsRevCTD,AmountOfDebitsRevCTD, (BeginningBalance+AmountOfDebitsCTD-AmountOfCreditsCTD) AS SummaryBS,CurrentBalance
FROM BSegment_Primary WITH(NOLOCK)
WHERE acctId IN (5000)

--------------------------------------------------------------------------------------CPSegment------------------------------------------------------------------------------------------------------------------------------------------

  SELECT DAYSINCYCLE,CP.AcctID,CP.Parent02AID,CP.BeginningBalance,CP.CurrentBalance,CP.Principal,CPC.NewTransactionsBSFC,CPC.NewTransactionsAgg,CPC.RevolvingBSFC,
CPC.RevolvingAgg,AggBalanceCTD,CPC.AfterCycleRevolvBSFC,CPC.IntBilledNotPaid,CP.LateFeesBNP,cpc.RevolvingAccrued,cpc.NewTransactionsAccrued
 FROM CPSgmentAccounts CP WITH(NOLOCK) JOIN CPSgmentCreditCard CPC WITH(NOLOCK) ON CP.AcctID = CPC.AcctID
WHERE CP.Parent02AID in (167413)

SELECT CP.AcctID,CP.Parent02AID,CP.BeginningBalance,CP.CurrentBalance,CP.Principal,CPC.NewTransactionsBSFC,CPC.NewTransactionsAgg,CPC.RevolvingBSFC,
CPC.RevolvingAgg,CPC.AfterCycleRevolvBSFC,CPC.IntBilledNotPaid,CP.LateFeesBNP,cpc.RevolvingAccrued,cpc.NewTransactionsAccrued
 FROM CPSgmentAccounts CP WITH(NOLOCK) JOIN CPSgmentCreditCard CPC WITH(NOLOCK) ON CP.AcctID = CPC.AcctID
WHERE CP.Parent02AID in (167413)

select  bcc.GraceDaysStatus,bp.parent01aid,LAPD,bcc.AccountGraceStatus,bp.acctId,bp.CurrentBalance,bcc.BeginningBalance_TranTime,bp.Principal,bp.latefeesbnp,bcc.IntBilledNotPaid,
bp.servicefeesbnp,bp.membershipfeesbnp,bcc.CycleDueDTD,bcc.AmountOfTotalDue,
bcc.AmtOfPayCurrDue,bcc.AmtOfPayXDLate,bcc.AmountOfPayment30DLate,bcc.AmountOfPayment60DLate,
bcc.AmountOfPayment90DLate,bcc.AmountOfPayment120DLate,bcc.AmountOfPayment150DLate,
bcc.AmountOfPayment180DLate,bcc.AmountOfPayment210DLate,bp.SystemStatus
From CPSgmentAccounts bp with(nolock) join
CPSgmentCreditCard bcc with(nolock) on bp.acctId = bcc.acctId
where bp.parent02AID in (167413) 
order by bp.parent02AID

 SELECT acctid,BeginningBalance,AmountOfDebitsCTD,AmountOfCreditsCTD,AmountOfPurchasesCTD,AmountOfPaymentsCTD,
AmountOfCreditsRevCTD,AmountOfDebitsRevCTD, (BeginningBalance+AmountOfDebitsCTD-AmountOfCreditsCTD) AS SummaryPS,CurrentBalance
FROM CPSgmentAccounts WITH(NOLOCK)
WHERE parent02AID IN (5000)

--------------------------------------------------------------------------------------------------CCard-----------------------------------------------------------------------------------------------------------------------------------------------

select TransactionAmount,artxntype,CMTTRANTYPE,atid,memoindicator,txnacctid,TransactionDescription,* From ccard_primary with(nolock) 
where AccountNumber in (select accountnumber from bsegment_primary with(nolock) where acctid = 167415) --and cmttrantype in ('301','302')
order by PostTime desc

 select NoBlobIndicatorGEN,TransactionAmount,cp.TransactionDescription,cmttrantype,cp.TxnAcctId,txnsource,creditplanmaster,cp.TranTime,cp.PostTime PT,*  from CCard_primary cp with (nolock) 
left join ccard_secondary cs with(nolock) on cp.tranid = cs.tranid 
where accountnumber='8000000000000011' --and txnacctid in (101251,167423)
order by posttime desc

-------------------------------------------------------------------------------------------StatementHeader------------------------------------------------------------------------------------------------------------------------------------------

select bp.StatementDate,bp.acctId,daysdeliquent,bp.CurrentBalance,bp.Principal,bp.CycleDueDTD,bp.AmountOfTotalDue,
bp.AmtOfPayCurrDue,*
From StatementHeader bp with(nolock)
where bp.acctId in (5000) order by bp.StatementDate desc

select bp.StatementDate,bp.APR,bp.ccinhparent125AID,bp.SystemStatus,bp.acctId,bp.CurrentBalance,bp.Principal,bp.CycleDueDTD,bp.AmountOfTotalDue,
bp.AmtOfPayCurrDue,bp.AmtOfPayXDLate,bp.AmountOfPayment30DLate,bp.AmountOfPayment60DLate,
bp.AmountOfPayment90DLate,bp.AmountOfPayment120DLate,bp.AmountOfPayment150DLate,
bp.AmountOfPayment180DLate,bp.AmountOfPayment210DLate
From StatementHeader bp with(nolock)
where bp.acctId in (5000) order by bp.StatementDate desc

-----------------------------------------------------------------------------------------------SummaryHeader-------------------------------------------------------------------------------------------------------------------------------------

select bp.StatementDate,bp.acctId,bp.CurrentBalance,bp.Principal,bcc.CycleDueDTD,bp.AmountOfTotalDue,
bcc.CurrentDue
From SummaryHeader bp with(nolock) join
SummaryHeaderCreditCard bcc with(nolock) on bp.acctId = bcc.acctId and bp.StatementID = bcc.StatementID
where bp.parent02AID in (5000) order by bp.StatementDate desc

select bp.StatementDate,bp.APR,bp.acctId,bcc.AccountGraceStatus,bp.CurrentBalance,bp.Principal,bcc.CycleDueDTD,bp.AmountOfTotalDue,
bcc.CurrentDue,bcc.AmtOfPayXDLate,bcc.AmountOfPayment30DLate,bcc.AmountOfPayment60DLate,
bcc.AmountOfPayment90DLate,bcc.AmountOfPayment120DLate,bcc.AmountOfPayment150DLate,
bcc.AmountOfPayment180DLate,bcc.AmountOfPayment210DLate
From SummaryHeader bp with(nolock) join
SummaryHeaderCreditCard bcc with(nolock) on bp.acctId = bcc.acctId and bp.StatementID = bcc.StatementID
where bp.parent02AID in (5000) order by bp.StatementDate desc

------------------------------------------------------------------------------------------------------MonetaryTxn------------------------------------------------------------------------------------------------------------------------------------

SELECT * from MonetaryTxnControl WHERE LogicModule = 40 and GroupId =78
--UPDATE MonetaryTxnControl SET LogicModuleType = '11' WHERE ActualTranCode = '37240'

--CPM

--Astatus

select MerchantAID,StatusDescription,Priority,* from AStatusAccounts where parent01AID= 16028

--CCardLookup

select * from CCardLookUp where lutid = 'TranType'
select * from CCardLookUp where lutid like '%trantype%' and lutcode = '30005'

--CommonQueries

