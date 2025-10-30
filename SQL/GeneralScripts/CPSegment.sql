   select CC.GraceDaysStatus,CC.InterestDefermentStatus,CC.InterestStartDate,CC.GraceDayCutoffDate,multiplesales,RevolvingAccrued,DaysInCycle,BeginningBalance,cycleduedtd,currentbalance,parent02AID,dateoftotaldue,principal,currentbalance,IntBilledNotPaid,NSFFeesBilledNotPaid,latefeesbnp,servicefeesbnp
  --Amountoftotaldue,AmtOfAcctHighBalLTD,amtofpaycurrdue,AmtOfPayXDLate,AmountOfPayment30DLate,AmountOfPayment60DLate,AmountOfPayment90DLate,AmountOfPayment120DLate, AmountOfPayment150DLate,AmountOfPayment180DLate,AmountOfPayment210DLate,
   plansegcreatedate,intereststartdate,NewTransactionsAccrued,RevolvingAccrued, NewTransactionsBSFC,RevolvingBSFC ,NewTransactionsAccrued+RevolvingAccrued,NewTransactionsBSFC+RevolvingBSFC ,DeAcctActivityDate,
  daysincycle,NewTransactionsBSFC,NewTransactionsAccrued,RevolvingBSFC,ca.invoiceNumber,CC.acctid,currentbalance,principal,servicefeesbnp,latefeesbnp,Amountoftotaldue ,
  AmountOfDebitsCTD,AmountofPurchasesCTD ,CounterForEqualPayment
  from CPSgmentCreditCard CC with(nolock) 
 join CPSgmentAccounts  CA with(nolock)  on cc.acctid = CA.acctid left join CPSgment_Balances cb with(nolock) on cc.acctid = Cb.acctid
  where parent02AID in(167415) 

  use PARASHAR_TEST

  SELECT DAYSINCYCLE,CP.AcctID,CP.Parent02AID,CP.BeginningBalance,CP.CurrentBalance,CP.Principal,CPC.NewTransactionsBSFC,CPC.NewTransactionsAgg,CPC.RevolvingBSFC,
CPC.RevolvingAgg,AggBalanceCTD,CPC.AfterCycleRevolvBSFC,CPC.IntBilledNotPaid,CP.LateFeesBNP,cpc.RevolvingAccrued,cpc.NewTransactionsAccrued
 FROM CPSgmentAccounts CP WITH(NOLOCK) JOIN CPSgmentCreditCard CPC WITH(NOLOCK) ON CP.AcctID = CPC.AcctID
WHERE CP.Parent02AID in (167413,167414)

select cpmdescription,* from cpmaccounts where acctid =5879

USE PARASHAR_CB_CI