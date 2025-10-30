--- CCGS_RPT_CoreIssue   script  need to run on replication  databse 
use CCGS_RPT_CoreIssue
Begin Tran
--commit Tran 
--rollback 
	update   s
	set s.AmountOfPurchasesCTD = s.AmountOfPurchasesCTD + b.AmountOfPurchasesCC2
	,s.AmountOfCreditsCTD =s.AmountOfCreditsCTD+b.AmountOfCreditsCC2
	,s.AmountOfPaymentsCTD = s.AmountOfPaymentsCTD+b.AmountOfPaymentsCC2
	,s.AmountOfDebitsCTD = s.AmountOfDebitsCTD+b.AmountOfDebitsCC2
	 from  statementheader s  join BSegment_Balances  b with(nolock)   on (s.acctid  = b.acctid )
	 where b.acctid in(538391,
515098,
254395,
1331485,
2441118,
9580193,
12479783,
17708829,
2187713,
2206644,
1984467,
4090858) and s.statementdate  = '2021-05-31 23:59:57.000'
	

	update   s
	set s.AmountOfPurchasesCTD = s.AmountOfPurchasesCTD + b.AmountOfPurchasesCC2
	,s.AmountOfCreditsCTD =s.AmountOfCreditsCTD+b.AmountOfCreditsCC2
	,s.AmountOfPaymentsCTD = s.AmountOfPaymentsCTD+b.AmountOfPaymentsCC2
	,s.AmountOfDebitsCTD = s.AmountOfDebitsCTD+b.AmountOfDebitsCC2
	 from   Summaryheader  s  		join CPSgment_Balances  b with(nolock) 
	on (s.acctid  = b.acctid ) where s.parent02aid in(538391,
515098,
254395,
1331485,
2441118,
9580193,
12479783,
17708829,
2187713,
2206644,
1984467,
4090858) and s.statementdate  = '2021-05-31 23:59:57.000'
	

