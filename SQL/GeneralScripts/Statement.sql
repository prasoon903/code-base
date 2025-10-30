 use PARASHAR_CB_CI
 USE PARASHAR_TEST
 
 select bp.StatementDate,bp.ManualInitialChargeOffReason,bp.acctId,bp.BeginningBalance,bp.AmountOfCreditsCTD,bp.CurrentBalance,bp.Principal,bp.CycleDueDTD,bp.AmountOfTotalDue,
bp.AmtOfPayCurrDue,bp.AmtOfPayXDLate,bp.AmountOfPayment30DLate,bp.AmountOfPayment60DLate,
bp.AmountOfPayment90DLate,bp.AmountOfPayment120DLate,bp.AmountOfPayment150DLate,
bp.AmountOfPayment180DLate,bp.AmountOfPayment210DLate
From StatementHeader bp with(nolock)
where bp.acctId in (167425) order by bp.StatementDate desc

select  * from currentStatementHeader with(nolock) where acctid IN (167413)

SELECT AmountOfCreditsCTD,* from SummaryHeader WITH (nolock) WHERE parent02AID  IN (167413,167414)

select cp.DaysInCycle,cp.APR,cp.statementdate,cp.acctid,cp.parent02aid,cp.BeginningBalance,cp.currentbalance,cp.principal,cpc.newtransactionsbsfc,cpc.NewTransactionsAgg,cpc.revolvingbsfc,AggBalanceCTD,
cpc.RevolvingAgg,cpc.AfterCycleRevolvBSFC,cp.IntBilledNotPaid,cp.latefeesbnp,cp.InterestStartDate From SummaryHeader cp with(nolock) join 
SummaryHeaderCreditCard cpc with(nolock) on cp.acctid = cpc.acctid and cp.statementid = cpc.StatementID
where cp.parent02aid in (167413) order by cp.StatementDate desc

 select DtOfLastDelinqCTD, * from StatementHeaderex with(nolock) where acctid = 167413

 --update logo_primary set tpyblob = NULL, tpynad = NULL , tpylad = NULL

 select bp.StatementDate,bp.acctId,bp.CurrentBalance,bp.Principal,bp.CycleDueDTD,bp.AmountOfTotalDue,
bp.AmtOfPayCurrDue,bp.AmtOfPayXDLate,bp.AmountOfPayment30DLate,bp.AmountOfPayment60DLate,
bp.AmountOfPayment90DLate,bp.AmountOfPayment120DLate,bp.AmountOfPayment150DLate,
bp.AmountOfPayment180DLate,bp.AmountOfPayment210DLate
From StatementHeader bp with(nolock)
where bp.acctId in (167425) order by bp.StatementDate desc

select bp.StatementDate,bp.acctId,bp.CurrentBalance,bp.Principal,bcc.CycleDueDTD,bp.AmountOfTotalDue,
bcc.CurrentDue,bcc.AmtOfPayXDLate,bcc.AmountOfPayment30DLate,bcc.AmountOfPayment60DLate,
bcc.AmountOfPayment90DLate,bcc.AmountOfPayment120DLate,bcc.AmountOfPayment150DLate,
bcc.AmountOfPayment180DLate,bcc.AmountOfPayment210DLate
From SummaryHeader bp with(nolock) join
SummaryHeaderCreditCard bcc with(nolock) on bp.acctId = bcc.acctId and bp.StatementID = bcc.StatementID
where bp.parent02AID in (167425) order by bp.StatementDate desc