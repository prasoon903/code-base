select s.parent02aid,b.AmountOfPurchasesCC1,b.AmountOfDebitsCC1,b.AmountOfCreditsCC1 ,b.AmountOfPaymentsCC1,b.acctid from   LS_P1MARPRODDB01.ccgs_coreissue_secondary.dbo.Summaryheader  s  with(nolock) 
 join LS_P1MARPRODDB01.ccgs_coreissue.dbo.CPSgment_Balances  b with(nolock) 
  on (s.acctid  = b.acctid ) where s.parent02aid in (4286999,4523539) and s.statementdate  = '2020-03-31 23:59:57.000'


select  s.amountofpurchasesctd,b.acctid 
from   LS_P1MARPRODDB01.ccgs_coreissue_secondary.dbo.statementheader s  with(nolock) 
 join LS_P1MARPRODDB01.ccgs_coreissue.dbo.BSegment_Balances  b with(nolock) 
  on (s.acctid  = b.acctid ) where s.acctid in (12946127) and statementdate  = '2022-10-31 23:59:57.000'


  
select b.AmountOfPurchasesCC2,b.AmountOfDebitsCC2,b.AmountOfCreditsCC2 ,b.AmountOfPaymentsCC2,b.acctid 
from   LS_P1MARPRODDB01.ccgs_coreissue_secondary.dbo.AccountInfoForReport s  with(nolock) 
 join LS_P1MARPRODDB01.ccgs_coreissue.dbo.BSegment_Balances  b with(nolock) 
  on (s.bsacctid  = b.acctid ) where s.bsacctid in (1215171) and businessday  = '2020-10-31 23:59:57.000'


  
  
select b.AmountOfPurchasesCC2,b.AmountOfDebitsCC2,b.AmountOfCreditsCC2 ,b.AmountOfPaymentsCC2,b.acctid 
from   LS_P1MARPRODDB01.ccgs_coreissue.dbo.BSegment_Balances  b with(nolock) 
   where b.bsacctid in (1215171) --and businessday  = '2020-10-31 23:59:57.000'





-- scripts added by Deepak Jain

Begin  Tran 
	update statementheader set amountofpurchasesctd = 220.49, amountofdebitsctd = 220.49, amountofpaymentsctd = 310.67, amountofcreditsctd  = 310.67
	where acctid = 4286999 and  statementdate = '2020-03-31 23:59:57.000' 
	--1 row 
	update summaryheader set amountofpurchasesctd = 220.49, amountofdebitsctd = 220.49, amountofpaymentsctd = 310.67, amountofcreditsctd  = 310.67
	where acctid = 6423149 and  statementdate = '2020-03-31 23:59:57.000' 
	--1 row 
	update statementheader set amountofpurchasesctd = 108.03, amountofdebitsctd = 108.03 where acctid = 4523539 and  statementdate = '2020-03-31 23:59:57.000' 
	--1 row 
	update summaryheader set amountofpurchasesctd = 108.03, amountofdebitsctd = 108.03 where acctid  = 8341697 and  statementdate = '2020-03-31 23:59:57.000' 
	--1 row 
Commit 