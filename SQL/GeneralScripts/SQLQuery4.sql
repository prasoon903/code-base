select bp.acctId,bp.AccountNumber,bp.CreditLimit,bp.TempCreditLimit,bp.ccinhparent125AID,bcc.ConfirmedBankruptcyDate,bs.TestAccount,bp.CurrentBalance,bp.BeginningBalance,bp.Principal,bs.latefeesbnp,bcc.IntBilledNotPaid,
bs.servicefeesbnp,bs.membershipfeesbnp,bp.CycleDueDTD,bcc.AmountOfTotalDue,
bp.AmtOfPayCurrDue,bcc.AmtOfPayXDLate,bcc.AmountOfPayment30DLate,bcc.AmountOfPayment60DLate,
bcc.AmountOfPayment90DLate,bcc.AmountOfPayment120DLate,bcc.AmountOfPayment150DLate,
bcc.AmountOfPayment180DLate,bcc.AmountOfPayment210DLate,bp.SystemStatus,bp.accountnumber
From BSegment_Primary bp with(nolock) join
BSegment_Secondary bs with(nolock) on bp.acctId = bs.acctId join
BSegmentCreditCard bcc with(nolock) on bp.acctId = bcc.acctId
where bp.acctId in (5000)

use PARASHAR_CB_CAuth

SELECT CreditLimit,* from PARASHAR_CB_CAuth..BSegment_Primary

UPDATE PARASHAR_CB_CAuth..BSegment_Primary SET CreditLimit = 5000

select * from EmbossingAccounts
use PARASHAR_CB_CI
use PARASHAR_TEST

select TransactionAmount,CMTTRANTYPE,TransactionDescription,DateTimeLocalTransaction,TransmissionDateTime,* From ccard_primary with(nolock) 
where AccountNumber in (select accountnumber from bsegment_primary with(nolock) where acctid = 5000)
order by PostTime desc

select * from NonMonetaryLog

select * FROM CCardLookUp WHERE LUTid like '%ASCBRStatusGroup%'

SELECT RetainGraceStatus,StatusDescription,CBRStatusGroup,* from AStatusAccounts WHERE parent01AID = 15996 OR parent01AID = 16000

--INSERT Into CCardLookUp (LUTid,LutCode,LutDescription,LutLanguage,DisplayOrdr,Module) values ('ASCBRStatusGroup',10,'Disaster Recovery','dbb',0,'BC')

--UPDATE AStatusAccounts SET CBRStatusGroup = 10 WHERE parent01AID = 15996 OR parent01AID = 16000

select  RetainGraceStatus,StatusDescription,Priority,CBRStatusGroup,tpyBlob,tpyNAD,* from AStatusAccounts WHERE (parent01AID = 16000 OR parent01AID = 2) AND MerchantAID= 14992

15996|2|14992|

UPDATE AStatusAccounts SET LAD= '2018-02-05 23:59:58.000' where acctid= 30012
