	--select * from sys.servers 
	-- Query To  create Update  statement 
	
	
	SELECT 	 'update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + ' +  cast (OriginalPurchaseAmount - 
(CurrentBalance + CurrentBalanceCO +  (  
ISNULL(AmountOfCreditsLTD,0)

  - isnull(AmountOfCreditsRevLTD,0)) + isnull(DisputesAmtNS,0) + isnull (DispRCHFavororWriteoff,0) + isnull(ManualPurchaseReversal_LTD,0) )   as varchar) +  ' where  acctid  =  ' +  cast (s.acctid  as varchar ), 
   OriginalPurchaseAmount - 
(CurrentBalance + CurrentBalanceCO +  (  
ISNULL(AmountOfCreditsLTD,0)

  - isnull(AmountOfCreditsRevLTD,0)) + isnull(DisputesAmtNS,0) + isnull (DispRCHFavororWriteoff,0) + isnull(ManualPurchaseReversal_LTD,0) ) 
as  diff ,
(ISNULL(AmountOfCreditsLTD,0) + (OriginalPurchaseAmount - 
(CurrentBalance + CurrentBalanceCO +  (ISNULL(AmountOfCreditsLTD,0) - isnull(AmountOfCreditsRevLTD,0)) + isnull(DisputesAmtNS,0) + isnull (DispRCHFavororWriteoff,0) + isnull(ManualPurchaseReversal_LTD,0) )) )
as AmountOfCreditsLTDderived 
, OriginalPurchaseAmount,CurrentBalance,CurrentBalanceCO,AmountOfCreditsLTD,AmountOfCreditsRevLTD,DisputesAmtNS,DispRCHFavororWriteoff,ManualPurchaseReversal_LTD ,s.acctid ,s.parent02aid
 FROM  LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.cpsgmentaccounts   s  with(nolock)  
 join LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.cpsgmentcreditcard  shcc with(nolock) on (s.acctid = shcc.acctid   )
WHERE CreditPlanType = '16'
	AND OriginalPurchaseAmount <> 
	(CurrentBalance + CurrentBalanceCO + (
	ISNULL(AmountOfCreditsLTD,0) 
	 - isnull(AmountOfCreditsRevLTD,0)) + isnull(DisputesAmtNS,0) + isnull (DispRCHFavororWriteoff,0) + isnull(ManualPurchaseReversal_LTD,0) )
	 	--and  s.acctid     in (38795836)
		--and s.parent02aid    in (14011746)
	--order by parent02aid 

 /*

 SELECT 	 'update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + ' +  cast (OriginalPurchaseAmount - 
(CurrentBalance + CurrentBalanceCO +  (  
ISNULL(AmountOfCreditsLTD,0)

  - isnull(AmountOfCreditsRevLTD,0)) + isnull(DisputesAmtNS,0) + isnull (DispRCHFavororWriteoff,0) + isnull(ManualPurchaseReversal_LTD,0) )   as varchar) +  ' where  acctid  =  ' +  cast (s.acctid  as varchar ), 
   OriginalPurchaseAmount - 
(CurrentBalance + CurrentBalanceCO +  (  
ISNULL(AmountOfCreditsLTD,0)

  - isnull(AmountOfCreditsRevLTD,0)) + isnull(DisputesAmtNS,0) + isnull (DispRCHFavororWriteoff,0) + isnull(ManualPurchaseReversal_LTD,0) ) 
as  diff ,CreditPlanType,
(ISNULL(AmountOfCreditsLTD,0) + (OriginalPurchaseAmount - 
(CurrentBalance + CurrentBalanceCO +  (ISNULL(AmountOfCreditsLTD,0) - isnull(AmountOfCreditsRevLTD,0)) + isnull(DisputesAmtNS,0) + isnull (DispRCHFavororWriteoff,0) + isnull(ManualPurchaseReversal_LTD,0) )) )
as AmountOfCreditsLTDderived 
, OriginalPurchaseAmount,CurrentBalance,CurrentBalanceCO,AmountOfCreditsLTD,AmountOfCreditsRevLTD,DisputesAmtNS,DispRCHFavororWriteoff,ManualPurchaseReversal_LTD ,s.acctid ,s.parent02aid
 FROM  LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.cpsgmentaccounts   s  with(nolock)  
 join LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.cpsgmentcreditcard  shcc with(nolock) on (s.acctid = shcc.acctid   )
 WHERE s.acctId = 50342580


begin   Tran  
--Commit  
--rollback
--update  top(1) ccard_primary   set noblobindicator  = 6   where tranid  = 34973189244   and   accountnumber = '1100011148208303'



	--- Normal Query

	SELECT 	plansegcreatedate,s.statementdate, OriginalPurchaseAmount - 
(CurrentBalance + CurrentBalanceCO +  (ISNULL(AmountOfCreditsLTD,0) - isnull(AmountOfCreditsRevLTD,0)) + isnull(DisputesAmtNS,0) + isnull (DispRCHFavororWriteoff,0) + isnull(ManualPurchaseReversal_LTD,0) ) 
as  diff , OriginalPurchaseAmount,CurrentBalance,CurrentBalanceCO,AmountOfCreditsLTD,AmountOfCreditsRevLTD,DisputesAmtNS,DispRCHFavororWriteoff,ManualPurchaseReversal_LTD ,s.acctid ,s.parent02aid
 FROM  dbo.cpsgmentaccounts   s  with(nolock)  join dbo.cpsgmentcreditcard  shcc with(nolock) on (s.acctid = shcc.acctid   )
WHERE CreditPlanType = '16'
	AND OriginalPurchaseAmount <> 
	(CurrentBalance + CurrentBalanceCO + (ISNULL(AmountOfCreditsLTD,0) - isnull(AmountOfCreditsRevLTD,0)) + isnull(DisputesAmtNS,0) + isnull (DispRCHFavororWriteoff,0) + isnull(ManualPurchaseReversal_LTD,0) ) 
	order by parent02aid




	--- Query To find beekman plan maually reversed 
	;with cte as
	(
	SELECT 	  singlesaletranid 
 FROM  dbo.cpsgmentaccounts   s  with(nolock)  join dbo.cpsgmentcreditcard  shcc with(nolock) on (s.acctid = shcc.acctid   )
WHERE CreditPlanType = '16'
	AND OriginalPurchaseAmount <> 
	(CurrentBalance + CurrentBalanceCO + (ISNULL(AmountOfCreditsLTD,0) - isnull(AmountOfCreditsRevLTD,0)) + isnull(DisputesAmtNS,0) + isnull (DispRCHFavororWriteoff,0) + isnull(ManualPurchaseReversal_LTD,0) )
	)
	select memoindicator,* from ccard_primary c  with(nolock) join cte  ct on (c.revtgt = ct.singlesaletranid)
	where cmttrantype = '43'  and memoindicator  is null order by posttime  desc



	/*
	
	SELECT 	 OriginalPurchaseAmount - 
(CurrentBalance + CurrentBalanceCO +  (  
ISNULL(AmountOfCreditsLTD,0)

  - isnull(AmountOfCreditsRevLTD,0)) + isnull(DisputesAmtNS,0) + isnull (DispRCHFavororWriteoff,0) + isnull(ManualPurchaseReversal_LTD,0) ) 
as  diff ,
(ISNULL(AmountOfCreditsLTD,0) + (OriginalPurchaseAmount - 
(CurrentBalance + CurrentBalanceCO +  (ISNULL(AmountOfCreditsLTD,0) - isnull(AmountOfCreditsRevLTD,0)) + isnull(DisputesAmtNS,0) + isnull (DispRCHFavororWriteoff,0) + isnull(ManualPurchaseReversal_LTD,0) )) )
as AmountOfCreditsLTDderived 
, OriginalPurchaseAmount,CurrentBalance,CurrentBalanceCO,AmountOfCreditsLTD,AmountOfCreditsRevLTD,DisputesAmtNS,DispRCHFavororWriteoff,ManualPurchaseReversal_LTD ,s.acctid ,s.parent02aid
 FROM  dbo.cpsgmentaccounts   s  with(nolock)  join dbo.cpsgmentcreditcard  shcc with(nolock) on (s.acctid = shcc.acctid   )
WHERE CreditPlanType = '16'
	AND OriginalPurchaseAmount <> 
	(CurrentBalance + CurrentBalanceCO + (
	ISNULL(AmountOfCreditsLTD,0) 
	 - isnull(AmountOfCreditsRevLTD,0)) + isnull(DisputesAmtNS,0) + isnull (DispRCHFavororWriteoff,0) + isnull(ManualPurchaseReversal_LTD,0) )
	 	and  s.acctid not    in (6485815,13106664,13591509,11888981,11888982 ,10721730,10793979,10782221)
	order by parent02aid 








	and  s.statementdate =  '2020-05-31 23:59:57.000'

	

SELECT 	 distinct s.parent02aid
 FROM  dbo.summaryheader  s  with(nolock)  join dbo.summaryheadercreditcard shcc with(nolock) on (s.acctid = shcc.acctid  and s.statementid   = shcc.statementid )
WHERE CreditPlanType = '16'
	AND OriginalPurchaseAmount <> (CurrentBalance + CurrentBalanceCO + (ISNULL(AmountOfCreditsLTD,0) - isnull(AmountOfCreditsRevLTD,0)) + isnull(DisputesAmtNS,0) + isnull (DispRCHFavororWriteoff,0) + isnull(ManualPurchaseReversal_LTD,0) )
	and  s.statementdate =  '2020-05-31 23:59:57.000'

	select pendingotb,* from bsegment_primary with(nolock) where pendingotb <0  and billingcycle <>'LTD'
	select pendingotb,* from ccgs_rpt_coreauth..bsegment_primary with(nolock) where pendingotb <0  and billingcycle <>'LTD'

	select * from paymentholddetails with(nolock) where bsacctid in ( 414368,1054320,1111892,1149047,1192869,1195302,1215504,2559992,5543865)
	order by posttime desc


select settlementdate,accountnumber ,* from ccard_primary c with(nolock) join ccard_secondary cs  on (c.tranid = cs.tranid ) where c.tranid = 27507392698
select settlementdate,* from ccard_primary c with(nolock) join ccard_secondary cs  on (c.tranid = cs.tranid ) where c.tranid = 27207928980

select settlementdate,accountnumber ,claimid,caseid,txnsource,fileid,preparedby,* from ccard_primary c with(nolock) join ccard_secondary cs  on (c.tranid = cs.tranid ) 
where c.accountnumber = '1100011129840538   '
order by posttime desc


select settlementdate,accountnumber ,claimid,caseid,txnsource,fileid,preparedby,* from ccard_primary c with(nolock) join ccard_secondary cs  on (c.tranid = cs.tranid )
 where c.accountnumber = '1100011101511909      '
order by posttime desc


*/*/