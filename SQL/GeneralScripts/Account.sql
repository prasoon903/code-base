
USE PP_CI 
USE PARASHAR_TEST
USE PRASOON_CB_CI
USE PP_CAuth
 USE vishalsh_cb_ci
 USE PRASOON_CB_CAuth

SELECT OBJECT_NAME(OBJECT_ID),
definition
FROM sys.sql_modules
WHERE definition LIKE '%' + 'CoreCredit_details' + '%'
GO

-- Search in Stored Procedure Only
SELECT DISTINCT OBJECT_NAME(OBJECT_ID),
object_definition(OBJECT_ID)
FROM sys.Procedures
WHERE object_definition(OBJECT_ID) LIKE '%' + 'CollateralID_Bulk' + '%'
AND OBJECT_NAME(OBJECT_ID) NOT LIKE ('%ins' or '%insupd') '%qsel','%qslk','%sel','upd','%selq','%upd')
GO
 SELECT OBJECT_NAME(OBJECT_ID),* FROM  SYS.COLUMNS WITH(NOLOCK) WHERE NAME LIKE 'AmountOf%' AND OBJECT_NAME(OBJECT_ID) LIKE 'CPSgment%'

 SELECT DISTINCT Name
FROM sys.Procedures
WHERE object_definition(OBJECT_ID) LIKE '%PostingRef%'

select AccountNumber,parent02AID,DateAcctOpened,MTCGrpName,InstitutionID,BillingCycle,ccinhparent127aid,* from BSegment_Primary with(nolock) where accountnumber= '9000000500000014'
select AccountNumber,UniversalUniqueID,MTCGrpName,BillingCycle,ccinhparent127aid,* from BSegment_Primary with(nolock) where institutionid=3235
select AccountNumber,MTCGrpName,LastStatementDate,DateOfNextStmt,BillingCycle,CreatedTime,tpyNAD,tpyLAD,tpyBlob,LAD,LAPD,NAD,* from BSegment_Primary with(nolock) where acctid = 167413
--UPDATE BSegment_Primary SET NAD = '2017-08-16 23:59:57.000' where acctid = 167413
--UPDATE BSegment_Primary SET LAPD = '2018-02-01 23:59:59.000' where acctid = 5004
SELECT * from EmbossingAccounts WHERE parent01aid = 167413
SELECT * FROM BSegmentAccounts_sec WHERE acctid = 167413

SELECT MPLMerchantNumber,MPLMerchantLevel,MPLMerchantNumber,MPLRegisterNumber,* FROM MerchantPLAccounts WHERE parent02AID = 3235

 select systemstatus,paymentlevel,ccinhparent125aid,cycleduedtd,intereststartdate,BP.SystemStatus,BC.ChargeOffDateParam,NewTransactionsBSFC,currentbalance,BeginningBalance,bp.acctid,dateoftotaldue,Amountoftotaldue,
 amtofpaycurrdue,AmtOfPayXDLate,AmountOfPayment30DLate,AmountOfPayment60DLate,AmountOfPayment90DLate,AmountOfPayment120DLate,
 AmountOfPayment150DLate,AmountOfPayment180DLate,AmountOfPayment210DLate,LastStatementDate,AmountOfDebitsCTD,AmountofPurchasesCTD
 ,billingcycle,Accountnumber,currentbalance,principal,servicefeesbnp,latefeesbnp
  from BSegment_Primary BP  with(nolock) join bsegmentcreditcard  BC  with(nolock) on BP.acctid =BC.acctid join bsegment_secondary BS with(nolock) on BP.acctid =BS.acctid  
 JOIN BSegment_Balances bb WITH(NOLOCK) ON bp.ACCTID =BB.ACCTID where BP.acctid in (5032)

 select bp.acctId,bp.CurrentBalance,bp.Principal,bcc.IntBilledNotPaid,NewTransactionsAccrued,RevolvingAccrued
From CPSgmentAccounts bp with(nolock) join
CPSgmentCreditCard bcc with(nolock) on bp.acctId = bcc.acctId
where bp.parent02AID in (5000) order by bp.parent02AID

 SELECT acctid,acctid,BeginningBalance,CurrentBalance,AmountOfDebitsCTD,AmountOfCreditsCTD,AmountOfPurchasesCTD,AmountOfPaymentsCTD,
AmountOfCreditsRevCTD,AmountOfDebitsRevCTD
FROM BSegment_Primary WITH(NOLOCK)
WHERE acctId IN (5000)

 SELECT acctid,BeginningBalance,CurrentBalance,AmountOfDebitsCTD,AmountOfCreditsCTD,AmountOfPurchasesCTD,AmountOfPaymentsCTD,
AmountOfCreditsRevCTD,AmountOfDebitsRevCTD
FROM CPSgmentAccounts WITH(NOLOCK)
WHERE parent02AID IN (5000)

SELECT * from CurrentBalanceAudit WHERE aid = 5003 and dename = 114
use PP_CI
use PARASHAR_test

select bp.acctId,bp.SystemStatus,CustomerId,bp.CurrentBalance,bp.BeginningBalance,bp.Principal,bs.latefeesbnp,bcc.IntBilledNotPaid,bp.DateOfDelinquency
bs.servicefeesbnp,bs.membershipfeesbnp,bp.CycleDueDTD,bcc.AmountOfTotalDue,
bp.AmtOfPayCurrDue,bcc.AmtOfPayXDLate,bcc.AmountOfPayment30DLate,bcc.AmountOfPayment60DLate,
bcc.AmountOfPayment90DLate,bcc.AmountOfPayment120DLate,bcc.AmountOfPayment150DLate,
bcc.AmountOfPayment180DLate,bcc.AmountOfPayment210DLate,bp.SystemStatus,bp.accountnumber
From BSegment_Primary bp with(nolock) join
BSegment_Secondary bs with(nolock) on bp.acctId = bs.acctId join
BSegmentCreditCard bcc with(nolock) on bp.acctId = bcc.acctId  join
BSegment_Balances bsb with(nolock) on bp.acctId = bsb.acctId
where bp.acctId in (167413)

select MerchantAID,StatusDescription,Priority,* from AStatusAccounts where parent01AID= 16028


select * from CCardLookUp where lutid = 'TranType'
select * from CCardLookUp where lutid like '%trantype%' and lutcode = '30005'

--select column_name,TABLE_NAME,* from INFORMATION_SCHEMA.columns where column_name like '%Collateral%'

select  bcc.GraceDaysStatus,bp.parent01aid,LAPD,bcc.AccountGraceStatus,bp.acctId,bp.CurrentBalance,bcc.BeginningBalance_TranTime,bp.Principal,bp.latefeesbnp,bcc.IntBilledNotPaid,
bp.servicefeesbnp,bp.membershipfeesbnp,bcc.CycleDueDTD,bcc.AmountOfTotalDue,
bcc.AmtOfPayCurrDue,bcc.AmtOfPayXDLate,bcc.AmountOfPayment30DLate,bcc.AmountOfPayment60DLate,
bcc.AmountOfPayment90DLate,bcc.AmountOfPayment120DLate,bcc.AmountOfPayment150DLate,
bcc.AmountOfPayment180DLate,bcc.AmountOfPayment210DLate,bp.SystemStatus
From CPSgmentAccounts bp with(nolock) join
CPSgmentCreditCard bcc with(nolock) on bp.acctId = bcc.acctId
where bp.parent02AID in (5000) 
order by bp.parent02AID

SELECT CP.AcctID,CP.Parent02AID,CP.BeginningBalance,CP.CurrentBalance,CP.Principal,CPC.NewTransactionsBSFC,CPC.NewTransactionsAgg,CPC.RevolvingBSFC,
CPC.RevolvingAgg,CPC.AfterCycleRevolvBSFC,CPC.IntBilledNotPaid,CP.LateFeesBNP,cpc.RevolvingAccrued,cpc.NewTransactionsAccrued
 FROM CPSgmentAccounts CP WITH(NOLOCK) JOIN CPSgmentCreditCard CPC WITH(NOLOCK) ON CP.AcctID = CPC.AcctID
WHERE CP.Parent02AID in (167413)

select TransactionAmount,CMTTRANTYPE,TransactionDescription,DateTimeLocalTransaction,TransmissionDateTime,* From ccard_primary with(nolock) 
where AccountNumber in (select accountnumber from bsegment_primary with(nolock) where acctid = 167417)
order by PostTime desc

select * From commontnp with(nolock) where atid = 60
select * From commontnp with(nolock) where acctid = 35269

select accountnumber,institutionid,* From ccard_primary with(nolock) where tranid in (123372036854777812,123372036854785876,123372036854785883)

select bp.StatementDate,bp.APR,bp.ccinhparent125AID,bp.SystemStatus,bp.acctId,bp.CurrentBalance,bp.Principal,bp.CycleDueDTD,bp.AmountOfTotalDue,
bp.AmtOfPayCurrDue,bp.AmtOfPayXDLate,bp.AmountOfPayment30DLate,bp.AmountOfPayment60DLate,
bp.AmountOfPayment90DLate,bp.AmountOfPayment120DLate,bp.AmountOfPayment150DLate,
bp.AmountOfPayment180DLate,bp.AmountOfPayment210DLate
From StatementHeader bp with(nolock)
where bp.acctId in (5000) order by bp.StatementDate desc

select bp.StatementDate,bp.APR,bp.acctId,bcc.AccountGraceStatus,bp.CurrentBalance,bp.Principal,bcc.CycleDueDTD,bp.AmountOfTotalDue,
bcc.CurrentDue,bcc.AmtOfPayXDLate,bcc.AmountOfPayment30DLate,bcc.AmountOfPayment60DLate,
bcc.AmountOfPayment90DLate,bcc.AmountOfPayment120DLate,bcc.AmountOfPayment150DLate,
bcc.AmountOfPayment180DLate,bcc.AmountOfPayment210DLate
From SummaryHeader bp with(nolock) join
SummaryHeaderCreditCard bcc with(nolock) on bp.acctId = bcc.acctId and bp.StatementID = bcc.StatementID
where bp.parent02AID in (5000) order by bp.StatementDate desc

select * From delinquencyrecord with(nolock) where acctid = 167423

select * From ccard_primary with(nolock) where tranid in (select tranid From delinquencyrecord with(nolock))


use PARASHAR_TEST

 select NoBlobIndicatorGEN,TransactionAmount,cp.TransactionDescription,cmttrantype,cp.TxnAcctId,txnsource,creditplanmaster,cp.TranTime,cp.PostTime PT,*  from CCard_primary cp with (nolock) 
left join ccard_secondary cs with(nolock) on cp.tranid = cs.tranid 
where accountnumber='8000000000000011' --and txnacctid in (101251,167423)
order by posttime desc

 select  cp.FleetRepricing,cp.creditplanmaster,cmttrantype,cp.TransactionDescription,TxnSource,TransactionAmount,cp.TxnAcctId,*  from CCard_primary cp with (nolock) 
join ccard_secondary cs with(nolock) on cp.tranid = cs.tranid
where accountnumber='9000000500000022'   --and txnacctid=101260
order by posttime desc

select TransactionAmount,CMTTRANTYPE,TxnAcctId,filmlocator,DecimalPositionsIndicator,* 
From CCard_Primary cp with(nolock) left join ccard_secondary cs with(nolock) on cp.tranid = cs.tranid
where cp.AccountNumber = '1100000100000014'
order by cp.PostTime desc

select * from currentbalanceaudit with(nolock) where aid =5003

select * from ccardlookup where lutid ='indexrateparent'


SELECT * from MonetaryTxnControl WHERE LogicModule = 22 and GroupId =53
--UPDATE MonetaryTxnControl SET LogicModuleType = '11' WHERE ActualTranCode = '37240'

select LastStatementDate,DateofNextStmt,acctid,* from bsegment_primary with(nolock)  where accountNumber='1100000100000121'

select transactionAmount,AccountNumber,AvailableBalanceAccount,statementdate,* from ccard_primary with(nolock)
order by posttime desc

 --update logo_primary set tpyblob = NULL, tpynad = NULL , tpylad = NULL

select bp.AccountNumber,bp.InstitutionID,bp.acctId,bp.LastStatementDate,bcc.DateOfTotalDue From BSegment_Primary bp with(nolock) join
BSegmentCreditCard bcc with(nolock) on bp.acctId = bcc.acctId
where bp.acctId  IN (167413,167414)

select DateOfTotalDue,amountoftotaldue,BeginningBalance,* From StatementHeader with(nolock) where acctid in  (167413) order by StatementDate desc

select * From CommonTNP with(nolock)  order by TranTime 
use PARASHAR_TEST 
use PP_CI

SELECT DefIntNumDays,DefIntNumCycles,CpmDescription,InterestDeferPeriod,* from CPMAccounts where acctId=6051
SELECT PenaltyPricingActive,* from CPSgmentCreditCard where acctId IN (101240)
SELECT cpsinterestplan,* from CPSgmentAccounts where acctId IN (101240)

select BillingTableName,* from BillingTableAccounts

USE master
searchcolumn status

  SELECT DAYSINCYCLE,CP.AcctID,CP.Parent02AID,CP.BeginningBalance,CP.CurrentBalance,CP.Principal,CPC.NewTransactionsBSFC,CPC.NewTransactionsAgg,CPC.RevolvingBSFC,
CPC.RevolvingAgg,AggBalanceCTD,CPC.AfterCycleRevolvBSFC,CPC.IntBilledNotPaid,CP.LateFeesBNP,cpc.RevolvingAccrued,cpc.NewTransactionsAccrued
 FROM CPSgmentAccounts CP WITH(NOLOCK) JOIN CPSgmentCreditCard CPC WITH(NOLOCK) ON CP.AcctID = CPC.AcctID
WHERE CP.Parent02AID in (167413)

select * From HoldPayment with(nolock)

--delete from HoldPayment

select MTCGrpName, * From Logo_Primary with(NOLOCK)

SELECT * from CCardLookUp with (nolock) WHERE LUTid = 'FeeRevReason'




/*WEB DIRECTOR QUERY


Select BG_BUG_ID,BG_USER_14,BG_STATUS,BG_RESPONSIBLE,BG_SUMMARY, BG_SEVERITY,BG_PRIORITY,BG_DETECTION_DATE 
from Bug with(nolock) 
where (BG_USER_06 like '%atiwari%' or BG_USER_06 like '%djain%')
and BG_STATUS IN ('New', 'Open', 'Re-Open')
and BG_PROJECT = 'CP_Plat_CI'
and (BG_USER_14 LIKE ('16.00.%') OR BG_USER_14 LIKE ('15.00.26.%') OR BG_USER_14 LIKE ('15.00.25.%'))
order by BG_BUG_ID desc


Select BG_BUG_ID,BG_USER_14,BG_STATUS,BG_RESPONSIBLE,BG_SUMMARY, BG_SEVERITY,BG_PRIORITY,BG_DETECTION_DATE 
from Bug with(nolock) 
where (BG_USER_06 like '%atiwari%' or BG_USER_06 like '%djain%')
and BG_STATUS IN ('New', 'Open', 'Re-Open')
order by BG_BUG_ID desc


Select BG_BUG_ID,BG_USER_14,BG_STATUS,BG_RESPONSIBLE,BG_SUMMARY 
from Bug with(nolock) where BG_DETECTED_BY like '%gunjan.gupta%' 
and (BG_USER_06 like '%atiwari%' or BG_USER_06 like '%djain%')
and BG_STATUS IN ('New', 'Open', 'Re-Open')
order by BG_BUG_ID desc


*/


USE tempdb;  
GO  
SELECT SUM(total_page_count) AS [Total pages],SUM(allocated_extent_page_count) AS [Allocated pages],SUM(unallocated_extent_page_count) AS [free pages],   
(SUM(total_page_count)*1.0/128) AS [total space in MB],(SUM(allocated_extent_page_count)*1.0/128) AS [Allocated space in MB],(SUM(unallocated_extent_page_count)*1.0/128) AS [free space in MB]  
FROM sys.dm_db_file_space_usage;  

SELECT SUM(user_object_reserved_page_count) AS [user object pages used],  
(SUM(user_object_reserved_page_count)*1.0/128) AS [user object space in MB]  
FROM sys.dm_db_file_space_usage;

SELECT * FROM sys.dm_db_file_space_usage;  


ALTER INDEX Auth_Primary_posttime_txnsource_reconInd ON Auth_primary REBUILD
ALTER INDEX Auth_Primary_ReconDetails ON Auth_primary REBUILD
ALTER INDEX dbbidx_IX_Auth_Primary_DateLocalTransaction ON Auth_primary REBUILD
ALTER INDEX IDX_Auth_Primary_CoreAuthTranId ON Auth_primary REBUILD
ALTER INDEX idx_GetPreAuthToMatchCoreAuth ON Auth_primary REBUILD
ALTER INDEX idxpk_Auth_Primary ON Auth_primary REBUILD
ALTER INDEX ix1_unique ON Auth_primary REBUILD

UPDATE STATISTICS Auth_Primary


select *from Commontnp with(nolock) where trantime < getdate() order by trantime
select * from Errortnp with(nolock)

select avg(cast(apitooktime as money)) AvgTime, convert(varchar,ResponseDate,101) Date, count(1) Count from AutoRedemMMSResponseLog with(nolock)
Where ResponseDate > '08/01/2019'
group by convert(varchar,ResponseDate,101)
order by convert(varchar,ResponseDate,101) desc

select convert(varchar,PostTIme,101), count(1) from ccard_primary with(nolock)
Where PostTIme > '08/01/2019' and cmttrantype = '40' and artxnType = '91'
group by convert(varchar,PostTIme,101)
order by convert(varchar,PostTIme,101) desc


select convert(varchar,PostTIme,101) , count(1) from ccgs_coreauth..coreauthtransactions with(nolock)
Where PostTIme > '08/01/2019' --and cmttrantype = '40' and artxnType = '91'
group by convert(varchar,PostTIme,101)
order by convert(varchar,PostTIme,101) desc