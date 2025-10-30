use PP_CI
use PP_CAuth
use PARASHAR_TEST


SELECT * FROM CommonTNP with (NOLOCK) where ATID = 60
SELECT * FROM ErrorTNP 
SELECT * FROM Version ORDER BY EntryId DESC

SELECT * FROM DelinquencyRecord where acctid = 167413
SELECT * FROM PlanDelinquencyRecord where parent02AID = 167413


select bsacctid,CP.TxnSource,TransactionAmount,MessageIdentifier,CP.RevTgt,MemberMessageText,FeeReversalReason,CMTTRANTYPE,txnacctid,TransactionDescription,CP.AccountNumber,memoindicator,* From ccard_primary CP with(nolock) 
join CCard_Secondary cs on (CP.TranId = CS.TranId)
where AccountNumber in (select accountnumber from bsegment_primary with(nolock) where acctid = 167413) --and cmttrantype in ('301','302')
order by PostTime desc

SELECT ManualReversalFlag,* from LateFeeDeterminant where acctId = 167413

select TxnSource,* from ccard_primary with (nolock) where TranId = 123372036855179808

select bsacctid,Revtgt,TransactionAmount,MessageIdentifier,CMTTRANTYPE,NoBlobIndicator,memoindicator,txnacctid,TransactionDescription,* From ccard_primary with(nolock) 
where AccountNumber in (select accountnumber from bsegment_primary with(nolock) where acctid = 167447) --and cmttrantype in ('301','302')
order by PostTime desc

use vishalsh_cb_ci

select NewNSFFeesCountCTD,NewNSFFeesCountCTD,NewNSFFeesCountCC1,NewNSFFeesCountCC2
,NewNSFFeesCountCC3,NewNSFFeesCountCC4,NewNSFFeesCountCC5,NewNSFFeesCountCC6,* from 
BSegmentFees with(nolock) where acctid = 167463

SELECT * FROM MonetaryTxnControl WITH(NOLOCK)
WHERE GroupId = (SELECT MTCGrpName FROM BSegment_Primary WITH(NOLOCK) WHERE AccountNumber = '8110000000000018')
AND LogicModule = 21

SELECT * FROM CommonTNP WITH (NOLOCK) --where  tranid = 123372036855179839
WHERE ATID = 60

SELECT * FROM  SChargesAccounts WHERE ChargePenaltyFeeOnNegativeRewardBalance = 1

select top 100 * From purchasereversalrecord with(nolock) where parent02AID = 167413

SELECT amount,TransactionAmount,* FROM LoyaltyTransactionMessage WHERE AccountNumber = '8110000000000356' order by PostTime desc

select dateoftotaldue,daysdelinquent,NoPayDaysDelinquent,DateOfOriginalPaymentDueDTD,DtOfLastDelinqCTD,FirstDueDate,* 
From BSegmentCreditCard with(nolock) where acctid = 167423

SELECT SHX.daysdelinquent, SHX.DtOfLastDelinqCTD, SH.CycleDueDTD,SH.StatementDate,SH.DateOfTotalDue
FROM StatementHeader SH
JOIN StatementHeaderEx SHX ON (SH.acctId = SHX.acctId AND SH.StatementDate = SHX.StatementDate)
where SH.acctid = 167423

select DtOfLastDelinqCTD, daysdelinquent,* From statementheaderex with(nolock) where acctid = 5000
select DateOfOriginalPaymentDueDTD,DateOfTotalDue,CycleDueDTD,* From statementheader with(nolock) where acctid = 5000

select bp.acctId,CurrentBalance,bp.BeginningBalance,bp.Principal,bs.latefeesbnp,bcc.IntBilledNotPaid,bp.CycleDueDTD,bcc.AmountOfTotalDue,bp.AmtOfPayCurrDue,bp.accountnumber,bp.LastPaymentRevDate
From BSegment_Primary bp with(nolock) join
BSegment_Secondary bs with(nolock) on bp.acctId = bs.acctId join
BSegmentCreditCard bcc with(nolock) on bp.acctId = bcc.acctId  join
BSegment_Balances bsb with(nolock) on bp.acctId = bsb.acctId
where bp.acctId in (167423)

--22 ,26  (Revtgt  actual trancode is 2115 than do not update reversal date)

select * from MonetaryTxnControl with(nolock) where ActualTranCode ='2115'

select * from MonetaryTxnControl with(nolock) where TransactionCode ='17508'


select * from BSegmentCreditCard

select  bp.acctId,bp.CurrentBalance,bp.Principal,bp.latefeesbnp,bcc.IntBilledNotPaid,recoveryfeesbnp,bp.NSFFeesBilledNotPaid,bcc.CycleDueDTD,bcc.AmountOfTotalDue,bcc.AmtOfPayCurrDue
From CPSgmentAccounts bp with(nolock) join
CPSgmentCreditCard bcc with(nolock) on bp.acctId = bcc.acctId
where bp.parent02AID in (167413) 
order by bp.parent02AID

select bp.StatementDate,bp.MPWCalculation,bp.acctId,bp.CreditLimit,bp.CurrentBalance,bp.Principal,bp.CycleDueDTD,bp.AmountOfTotalDue,bp.NewTransactionsBSFC,bp.RevolvingBSFC,bp.TotalBSFC,IntBilledNotPaid,
bp.AmtOfPayCurrDue
From StatementHeader bp with(nolock)
where bp.acctId in (167413) order by bp.StatementDate desc

select bp.StatementDate,bp.acctId,bp.CurrentBalance,bp.Principal,bcc.CycleDueDTD,bp.AmountOfTotalDue,
bcc.CurrentDue,bcc.NewTransactionsBSFC,bcc.RevolvingBSFC,bcc.TotalBSFC
From SummaryHeader bp with(nolock) join
SummaryHeaderCreditCard bcc with(nolock) on bp.acctId = bcc.acctId and bp.StatementID = bcc.StatementID
where bp.parent02AID in (167413) order by bp.StatementDate desc

 SELECT acctid,BeginningBalance,AmountOfDebitsCTD,AmountOfCreditsCTD,AmountOfPurchasesCTD,AmountOfPaymentsCTD,
AmountOfCreditsRevCTD,AmountOfDebitsRevCTD, (BeginningBalance+AmountOfDebitsCTD-AmountOfCreditsCTD) AS SummaryBS,CurrentBalance
FROM BSegment_Primary WITH(NOLOCK)
WHERE acctId IN (167413)

 SELECT acctid,BeginningBalance,AmountOfDebitsCTD,AmountOfCreditsCTD,AmountOfPurchasesCTD,AmountOfPaymentsCTD,AmountOfPaymentsLTD,
AmountOfCreditsRevCTD,AmountOfDebitsRevCTD, (BeginningBalance+AmountOfDebitsCTD-AmountOfCreditsCTD) AS SummaryPS,CurrentBalance
FROM CPSgmentAccounts WITH(NOLOCK)
WHERE parent02AID IN (5000)

select TransactionAmount,* from LoyaltyTransactionMessage where AccountNumber = '1100000100000030' order by PostTime DESC

select artxntype,cmttrantype,embacctid,* from logartxnaddl where institutionid = 3235 and cmttrantype in (301,302) order by artxnbusinessdate desc

select * FROM TCIVRRequest where institutionid = 3235 and accountnumber = '8110000000000356'

Exec  [GenerateProductTransferActivityDetailReport] '3235','3399','3405','','06/09/2017','10/08/2017'

select * from AControlAccounts with (nolock)

select * FROM commontnp where atid = 60

select * from  producttransferlog  where accountnumber = '8000000000000029 '

select * from ProductTransferJobs

select * from MonetaryTxnControl where GroupId =53 and LogicModule = 22

select AccountNumber,acctId,MTCGrpName,parent02AID,DateOfTotalDueNew,DateAcctOpened,SystemStatus,MTCGrpName,InstitutionID,BillingCycle,ccinhparent127aid,* from 
BSegment_Primary with(nolock) where accountnumber= '8110000000000018'

select AccountNumber,acctId,MTCGrpName,parent02AID,DateAcctOpened,SystemStatus,MTCGrpName,InstitutionID,BillingCycle,ccinhparent127aid,* from 
BSegment_Primary with(nolock) where acctId = 5010

select AccountNumber,parent02AID,DateAcctOpened,SystemStatus,MTCGrpName,InstitutionID,BillingCycle,ccinhparent127aid,* from 
BSegment_Primary with(nolock) where accountnumber IN ('8000000000000128','8000000000000037','8000000000000094','8000000000000078','8000000000000029')

select AccountNumber,LastStatementDate,CreditLimit,DateOfNextStmt,BillingCycle,tpyNAD,tpyLAD,tpyBlob,LAD,LAPD,NAD from BSegment_Primary with(nolock) where acctid = 5000

--UPDATE LPSegmentAccounts SET BillingCycle = 16 WHERE parent02AID IN (167413)

SELECT MessageDate,* FROM BSegment_Secondary where acctid = 167413
--UPDATE BSegment_Secondary SET MessageDate = Null where acctid = 167413

select OwningPartner,* FROM logo_secondary where OwningPartner IN (11607,11623)

select * from logo_primary where parent02aid = 3235



select * from CCardLookUp where lutcode = '11624'
select  mplmerchantlevel,* from MerchantPLAccounts where parent02aid = 3235

select MPLStoreNumber,OwningPartner,* from MerchantPLAccounts where parent02AID = 3235

select * from CreditLimitAuditLog where acctId = 5000

SELECT * from MonetaryTxnControl WHERE GroupId = 37 and LogicModule in ( 40)
--UPDATE MonetaryTxnControl SET LogicModuleType = 11 WHERE ActualTranCode = '37240'



select daysdelinquent,systemstatus,* from StatementHeaderEx se 
join StatementHeader bp on (bp.acctId = se.acctid and bp.statementid = se.statementid)
where bp.acctId in (167414) order by bp.StatementDate desc

where acctid = 167431 order by StatementDate desc

select * FROM StatementJobs where acctid = 5000 order by StatementDate desc



SELECT AdditionalLetterText,* FROM LetterInterface WITH(NOLOCK) 

select * from embossingaccounts where parent01aid = 167436


select * from ccardlookup where lutid= 'status'

select intplanoccurr,interestplan,* from CPMAccounts where acctId IN (6113,5925)

select artxntype,cmttrantype,embacctid,* from logartxnaddl where institutionid = 3235 order by artxnbusinessdate desc


SELECT LP.acctId,LP.parent02AID,OLCbCreditLineL,OLCbNoReturnPayment,OLCbCreditLineG,OlcbDPDLastCycle,OLNo,OLNoReturnPayment,OLDPDLastCycle,OLCreditLineL,OLNoOfSuceesfulPayment,
OLNoOfExcessPayment,OLCreditLineG,LgOLSucessfulPayment2,LgOLStatus,OLMaxOverlimitCap,OLOTBG,OLOverlimitAllowed,OLPartnerOnline,OLPartnerPos,OLCashEquivalents,OLOthers,OLNonPartnerPos,
LgOLEligiblesuccessfulpmt,PDStatus,chPDNoReturnPayment,PDNoReturnPayment,chLgPDNoDPD,PDNoInteger,PDDaysPastDue,chLgPDCreditLineL,PDCreditLineL,PDNoSuccessfulPayment,PDNoExcessPayment,PDEligibleSuccPayment,
PDPastDueDaysFail,PDPastDueDaysPass
FROM PP_CI..Logo_Primary LP WITH (NOLOCK)
JOIN PP_CI..Logo_Secondary LS WITH (NOLOCK)
ON (LP.acctId = LS.acctId)

SELECT LP.acctId,LP.parent02AID,OLCbCreditLineL,OLCbNoReturnPayment,OLCbCreditLineG,OlcbDPDLastCycle,OLNo,OLNoReturnPayment,OLDPDLastCycle,OLCreditLineL,OLNoOfSuceesfulPayment,
OLNoOfExcessPayment,OLCreditLineG,LgOLSucessfulPayment2,LgOLStatus,OLMaxOverlimitCap,OLOTBG,OLOverlimitAllowed,OLPartnerOnline,OLPartnerPos,OLCashEquivalents,OLOthers,OLNonPartnerPos,
LgOLEligiblesuccessfulpmt,PDStatus,chPDNoReturnPayment,PDNoReturnPayment,chLgPDNoDPD,PDNoInteger,PDDaysPastDue,chLgPDCreditLineL,PDCreditLineL,PDNoSuccessfulPayment,PDNoExcessPayment,PDEligibleSuccPayment,
PDPastDueDaysFail,PDPastDueDaysPass
FROM PP_CAuth..Logo_Primary LP WITH (NOLOCK)