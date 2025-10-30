

select transactionamount,txnsource,transactiondescription,transactionidentifier,claimid,revtgt,txncode_internal,creditplanmaster,* from ccard_primary with(nolock) 
where tranid = 30400269610
select transactionamount,txnsource,transactiondescription,transactionidentifier,claimid,revtgt,txncode_internal,creditplanmaster,* from ccard_primary with(nolock) 
where tranid = 30395854602

select * from ccardlookup where lutcode   = '13754'
select * from MonetaryTxnControl  with(nolock)  where  transactioncode = '18961   ' 
select * from sys.tables where name like '%monetary%'


-- Query to get account which are   going  to chargeoff but  NAD is  greater than '2020-06-30 23:59:55.000'
 select    c.trantime, b.CurrentBalance,b.acctid ,b.nad,autoinitialchargeoffstartdate,systemchargeoffstatus,userchargeoffstatus,cycleduedtd,ccinhparent125aid,chargeoffdateparam,accountnumber
    from  LINK_PROD1GSDB01.ccgs_coreissue.dbo.bsegment_primary b with(nolock) join   LINK_PROD1GSDB01.ccgs_coreissue.dbo.bsegmentcreditcard  bs  with(nolock)  on (b.acctid = bs.acctid )
	join LINK_PROD1GSDB01.ccgs_coreissue.dbo.commontnp c with(nolock)  on (c.acctid  = b.acctid  and c.tranid =0 and c.atid =51  )
	--join astatusaccounts as1 with(nolock) on (as1.parent01aid = b.ccinhparent125aid   and as1.merchantaid = b.parent05aid)
  where  chargeoffdateparam  = '2020-09-30 23:59:55.000' and (trantime >='2020-09-30 23:59:57.000' or nad > '2020-09-30 23:59:55.000')
   

   select c.trantime,accountopendate,* from LINK_PROD1GSDB01.ccgs_coreissue.dbo.bsegment_primary b  with(nolock)  join  LINK_PROD1GSDB01.ccgs_coreissue.dbo.bsegmentcreditcard bcc with(nolock) on (b.acctid = bcc.acctid) 
   join LINK_PROD1GSDB01.ccgs_coreissue.dbo.commontnp c  with(nolock)  on (bcc.acctid = c.acctid  and c.atid =51 and c.tranid = 0 )
   where billingcycle = '31'and nad > '2020-09-30 23:59:57.000' 
   --- and currentbalance > 0 
   select * from  LINK_PROD1GSDB01.ccgs_coreissue.dbo.commontnp c with(nolock) where acctid = 309572 

---NAD job verificatio
select * from accountinfoforreport with(nolock)  where bsacctid =880088  order by businessday desc

	select   ccinhparent125aid,b.tpyblob,b.tpynad,b.tpylad,accountnumber,parent05aid, systemstatus,chargeoffdate,currentbalanceco,b.acctid ,b.nad,
	autoinitialchargeoffreason, bs.manualinitialchargeoffreason,autoinitialchargeoffstartdate,manualinitialchargeoffstartdate,systemchargeoffstatus,userchargeoffstatus,cycleduedtd,ccinhparent125aid,chargeoffdateparam,accountnumber
    from LINK_PROD1GSDB01.ccgs_coreissue.dbo.bsegment_primary b with(nolock) join  LINK_PROD1GSDB01.ccgs_coreissue.dbo.bsegmentcreditcard  bs  with(nolock)  on (b.acctid = bs.acctid )
where  accountnumber in (select Accountnumber  from LINK_PROD1GSDB01.ccgs_coreissue.dbo.ccard_primary cc with(nolock) join LINK_PROD1GSDB01.ccgs_coreissue.dbo.trans_in_acct t  with(nolock) on (cc.tranid = t.tran_id_index  and t.atid =51)  
where cmttrantype = 'RCLS')
	--update  bsegmentcreditcard   set manualinitialchargeoffreason ='3'  where acctid in (880088,1322765,1390447,2954843,1562984)
	--update  bsegment_primary    set tpyblob =null,tpynad = null , tpylad= null   where acctid in (880088,1322765,1390447,2954843,1562984)
	select * from  LINK_PROD1GSDB01.ccgs_coreissue.dbo.version  order by entryid desc

	select  manualinitialchargeoffreason from bsegmentcreditcard  with(nolock) where  acctid in (880088,1322765,1390447,2954843,1562984)
	select tpyblob,tpynad,tpylad from LINK_PROD1GSDB01.ccgs_coreissue.dbo.bsegment_primary  with(nolock) where  acctid in (880088,1322765,1390447,2954843,1562984)
	select tpyblob,typnad,tpylad from LINK_PROD1GSDB01.ccgs_coreissue.dbo.bsegmentcreditcard  with(nolock) where  acctid in (880088,1322765,1390447,2954843,1562984)
	select tpyblob,typnad,tpylad from LINK_PROD1GSDB01.ccgs_coreissue.dbo.bsegment_primary  with(nolock) where  acctid in (880088,1322765,1390447,2954843,1562984)










	COReasonCode
3
	select * from ccardlookup  with(nolock)  where lutcode = '16022'
	select   tpyblob,accountnumber,parent05aid, systemstatus,chargeoffdate,currentbalanceco,b.acctid ,b.nad,autoinitialchargeoffreason, manualinitialchargeoffreason,autoinitialchargeoffstartdate,manualinitialchargeoffstartdate,systemchargeoffstatus,userchargeoffstatus,cycleduedtd,ccinhparent125aid,chargeoffdateparam,accountnumber
    from LINK_PROD1GSDB01.ccgs_coreissue.dbo.bsegment_primary b with(nolock) join  LINK_PROD1GSDB01.ccgs_coreissue.dbo.bsegmentcreditcard  bs  with(nolock)  on (b.acctid = bs.acctid )
where B.accountnumber  in (select accountnumber from LINK_PROD1GSDB01.ccgs_coreissue.dbo.ccard_primary with(nolock) where cmttrantype = 'RCLS') and  manualinitialchargeoffreason = '0'

select * from astatusaccounts with(nolock) where  parent01aid = 16010  and merchantaid =14994
select * from  currentbalanceaudit with(nolock) where aid =880088  and dename in ('111','222')  order by businessday desc,identityfield  desc

select * from ccard_primary with(nolock) where accountnumber = '1100011129388017'  order by posttime  desc
select * from ccard_primary with(nolock) where accountnumber = '1100011106647740'  order by posttime  desc
	--select * from LINK_PROD1GSDB01.ccgs_coreissue.dbo.commontnp with(nolock)  where tranid  =30731938447


   --- Query  account whihc  are cycledue >6  with  disaster staus  but  NAd  is  greater than '2020-06-30 23:59:55.000'

   --- Account 
   select  c.trantime,b.acctid ,nad,autoinitialchargeoffstartdate,systemchargeoffstatus,userchargeoffstatus,cycleduedtd,ccinhparent125aid,chargeoffdateparam,accountnumber
    from bsegment_primary b with(nolock) join  bsegmentcreditcard  bs  with(nolock)  on (b.acctid = bs.acctid )
	join LINK_PROD1GSDB01.ccgs_coreissue.dbo.commontnp c with(nolock)  on (c.acctid  = b.acctid  and c.tranid =0 and c.atid =51  )
  where  chargeoffdateparam <='2020-09-30 23:59:55.000'  and
   (ccinhparent125aid  in(15996,16000)  and cycleduedtd > 6)  and b.institutionid = 6981 and systemstatus  <>14   and trantime >'2020-06-30 23:59:55.000'
    
	
	 
	--- Validation 
	   select  c.trantime,b.acctid ,TT.nad,bs.autoinitialchargeoffstartdate,bs.systemchargeoffstatus,bs.userchargeoffstatus,b.cycleduedtd,
	   TT.ccinhparent125aid,bs.chargeoffdateparam,b.accountnumber
    from bsegment_primary b with(nolock) join  bsegmentcreditcard  bs  with(nolock)  on (b.acctid = bs.acctid )
	join LINK_PROD1GSDB01.ccgs_coreissue.dbo.commontnp c with(nolock)  on (c.acctid  = b.acctid  and c.tranid =0 and c.atid =51  )
	--join   LINK_PROD1GSDB01.ccgs_coreissue.dbo.c  TT with(nolock)  on (TT.acctid = b.acctid) where TT.jobstatus =1

	select * from LINK_PROD1GSDB01.ccgs_coreissue.dbo.Temp_TNP_NAD with(nolock)  where jobstatus =1 



  --where  chargeoffdateparam <='2020-06-30 23:59:55.000'  and
  -- (ccinhparent125aid  in(15996,16000)  and cycleduedtd > 6)  and b.institutionid = 6981 and systemstatus  <>14   and trantime >'2020-06-30 23:59:55.000'



	/*
	
	select    chargeoffdate,b.currentbalance,b.acctid ,b.nad,autoinitialchargeoffstartdate,systemchargeoffstatus,userchargeoffstatus,cycleduedtd,ccinhparent125aid,chargeoffdateparam,accountnumber
    from bsegment_primary b with(nolock) join  bsegmentcreditcard  bs  with(nolock)  on (b.acctid = bs.acctid )  where  systemchargeoffstatus  ='1' and systemstatus  <>14


	
	select   manualinitialchargeoffstartdate,chargeoffdate, b.currentbalance,b.acctid ,b.nad,autoinitialchargeoffstartdate,systemchargeoffstatus,userchargeoffstatus,cycleduedtd,ccinhparent125aid,chargeoffdateparam,accountnumber
    from bsegment_primary b with(nolock) join  bsegmentcreditcard  bs  with(nolock)  on (b.acctid = bs.acctid ) 
	 where  userchargeoffstatus  ='1' and systemstatus  <>14


	
	select    chargeoffdate,b.currentbalance,b.acctid ,b.nad,autoinitialchargeoffstartdate,manualinitialchargeoffstartdate,systemchargeoffstatus,userchargeoffstatus,cycleduedtd,ccinhparent125aid,chargeoffdateparam,accountnumber
    from bsegment_primary b with(nolock) join  bsegmentcreditcard  bs  with(nolock)  on (b.acctid = bs.acctid ) 
	 where  userchargeoffstatus  ='1' and systemchargeoffstatus  ='1' and systemstatus  <>14




	 
	  where billingcycle = '31'


	*/