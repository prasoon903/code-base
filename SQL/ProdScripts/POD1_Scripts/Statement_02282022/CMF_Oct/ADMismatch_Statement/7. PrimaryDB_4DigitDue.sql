
--select s.currentdue ,round(currentdue,2),sh.acctid, sh.Parent02AID  from LS_PRODDRGSDB01.ccgs_coreissue.dbo.Summaryheadercreditcard s  with(nolock)
--	 join  LS_PRODDRGSDB01.ccgs_coreissue_secondary.dbo.Summaryheader  sh with(nolock) 
--	 on (s.acctid = sh.acctid and s.statementid = sh.statementid )
--	  where statementdate = '2021-08-31 23:59:57.000'   and   (((abs(currentdue)*100) - CONVERT(INT,(abs(currentdue)*100))) <> 0) 


--select s.AmtOfPayCurrDue , round(AmtOfPayCurrDue,2) from PROD1GSDB01.ccgs_coreissue.dbo.planinfoforreport s with(nolock)
--	  where businessday = '2021-08-31 23:59:57.000' 	  and   (((abs(AmtOfPayCurrDue)*100) - CONVERT(INT,(abs(AmtOfPayCurrDue)*100))) <> 0)

USE CCGS_CoreIssue
GO

 Begin Tran

	 update  s  set s.currentdue = round(currentdue,2)  from dbo.Summaryheadercreditcard s 
	 join  dbo.Summaryheader  sh with(nolock) 
	 on (s.acctid = sh.acctid and s.statementid = sh.statementid )
	  where statementdate = '2021-08-31 23:59:57.000' 
	  and   (((abs(currentdue)*100) - CONVERT(INT,(abs(currentdue)*100))) <> 0)
	  --and sh.parent02aid in ( select bsacctid from datavalidationrecords  with(nolock) where businessday = '2020-08-31 23:59:57.000' )

	  ---11052 rows 

commit Tran 
	  

Begin  Tran 

	   update  s  set s.AmtOfPayCurrDue = round(AmtOfPayCurrDue,2)  from dbo.planinfoforreport s
	  where businessday = '2021-08-31 23:59:57.000' 	  and   (((abs(AmtOfPayCurrDue)*100) - CONVERT(INT,(abs(AmtOfPayCurrDue)*100))) <> 0)
	
		---11052 rows 	  
commit Tran 


