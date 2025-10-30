
select * from  astatusaccounts  with(nolock)  where acctid = 5202 
select transactionamount,txnsource,transactiondescription,transactionidentifier,claimid,revtgt,txncode_internal,
creditplanmaster,* from ccard_primary with(nolock) 
where tranid = 30400269610
select transactionamount,txnsource,transactiondescription,transactionidentifier,claimid,revtgt,
txncode_internal,creditplanmaster,* from ccard_primary with(nolock) 
where accountnumber = '1100011125223754   ' order by posttime  desc

select * from ccardlookup where lutcode   = '13754'
select * from MonetaryTxnControl  with(nolock)  where  transactioncode = '18961   ' 
select * from sys.tables where name like '%monetary%'


-- Query to get account which are   going  to chargeoff but  NAD is  greater than '2020-06-30 23:59:55.000'
 select    c.trantime, b.CurrentBalance,b.acctid ,b.nad,autoinitialchargeoffstartdate,systemchargeoffstatus,userchargeoffstatus,cycleduedtd,ccinhparent125aid,chargeoffdateparam,accountnumber
    from  LS_PRODDRGSDB01.ccgs_coreissue.dbo.bsegment_primary b with(nolock) join   LS_PRODDRGSDB01.ccgs_coreissue.dbo.bsegmentcreditcard  bs  with(nolock) 
	 on (b.acctid = bs.acctid )
	join LS_PRODDRGSDB01.ccgs_coreissue.dbo.commontnp c with(nolock)  on (c.acctid  = b.acctid  and c.tranid =0 and c.atid =51  )
	--join astatusaccounts as1 with(nolock) on (as1.parent01aid = b.ccinhparent125aid   and as1.merchantaid = b.parent05aid)
  where  chargeoffdateparam  = '2021-11-30 23:59:55.000' and (c.trantime >='2021-11-30 23:59:57.000' or b.nad > '2021-11-30 23:59:55.000')
   

   select c.trantime,accountopendate,* from LS_PRODDRGSDB01.ccgs_coreissue.dbo.bsegment_primary b  with(nolock)  join  LS_PRODDRGSDB01.ccgs_coreissue.dbo.bsegmentcreditcard bcc with(nolock) on (b.acctid = bcc.acctid) 
   join LS_PRODDRGSDB01.ccgs_coreissue.dbo.commontnp c  with(nolock)  on (bcc.acctid = c.acctid  and c.atid =51 and c.tranid = 0 )
   where billingcycle = '31'and nad > '2021-07-31 23:59:57.000' 
   --- and currentbalance > 0 


   select  statusdescription,coReasoncode,*  from astatusaccounts   with(nolock)   where acctid  = 5211
   select * from  LS_PRODDRGSDB01.ccgs_coreissue.dbo.commontnp c with(nolock) where acctid = 11498079 

---NAD job verificatio
select * from accountinfoforreport with(nolock)  where bsacctid =880088  order by businessday desc

	select   ccinhparent125aid,b.tpyblob,b.tpynad,b.tpylad,accountnumber,parent05aid, systemstatus,chargeoffdate,currentbalanceco,b.acctid ,b.lad,
	autoinitialchargeoffreason, bs.manualinitialchargeoffreason,autoinitialchargeoffstartdate,manualinitialchargeoffstartdate,systemchargeoffstatus,userchargeoffstatus,cycleduedtd,ccinhparent125aid,chargeoffdateparam,accountnumber
    from LS_PRODDRGSDB01.ccgs_coreissue.dbo.bsegment_primary b with(nolock) join 
	 LS_PRODDRGSDB01.ccgs_coreissue.dbo.bsegmentcreditcard  bs  with(nolock)  on (b.acctid = bs.acctid )
where  accountnumber in (select Accountnumber  from LS_PRODDRGSDB01.ccgs_coreissue.dbo.ccard_primary cc with(nolock) 
join LS_PRODDRGSDB01.ccgs_coreissue.dbo.trans_in_acct t  with(nolock) on (cc.tranid = t.tran_id_index  and t.atid =51)  
where cmttrantype = 'RCLS')  and  systemstatus <>14  
	--update  bsegmentcreditcard   set manualinitialchargeoffreason ='3'  where acctid in (880088,1322765,1390447,2954843,1562984)
	--update  bsegment_primary    set tpyblob =null,tpynad = null , tpylad= null   where acctid in (880088,1322765,1390447,2954843,1562984)
	select * from  LS_PRODDRGSDB01.ccgs_coreissue.dbo.version  order by entryid desc



	
	select  'update  top(1) bsegmentcreditcard  set  manualinitialchargeoffreason  =  ''' + coreasoncode + ''' where    acctid  ='  +   cast  (bp.acctid  as varchar ),
	'update  top(1) bsegment_primary  set  tpyblob  =  null  ,tpynad = null , tpylad = null   where    acctid  ='  +  
	 cast  (bp.acctid  as varchar ),
	 autoinitialchargeoffreason,manualinitialchargeoffreason,b.acctid,ccinhparent125aid,coreasoncode,statusdescription  
	 from LS_PRODDRGSDB01.ccgs_coreissue.dbo.bsegmentcreditcard  b  with(nolock)  join   LS_PRODDRGSDB01.ccgs_coreissue.dbo.bsegment_primary  bp  with(nolock)
	 on (b.acctid = bp.acctid )
	 join  LS_PRODDRGSDB01.ccgs_coreissue.dbo.astatusaccounts a with(nolock)  on 
	  (a.merchantaid =  bp.parent05aid  and   a.parent01aid  = bp.ccinhparent125aid )
	  where  bp.systemstatus  =14 and (autoinitialchargeoffreason = '0'   and manualinitialchargeoffreason  = '0')

	    

		
	select  'update  top(1) bsegmentcreditcard  set  manualinitialchargeoffreason  =  ''' + coreasoncode + ''' where    acctid  ='  +   cast  (bp.acctid  as varchar ),
	'update  top(1) bsegment_primary  set  tpyblob  =  null  ,tpynad = null , tpylad = null   where    acctid  ='  +  
	 cast  (bp.acctid  as varchar ),
	 autoinitialchargeoffreason,manualinitialchargeoffreason,b.acctid,ccinhparent125aid,coreasoncode,statusdescription  
	 from LS_PRODDRGSDB01.ccgs_coreissue.dbo.bsegmentcreditcard  b  with(nolock)  join   LS_PRODDRGSDB01.ccgs_coreissue.dbo.bsegment_primary  bp  with(nolock)
	 on (b.acctid = bp.acctid )
	 join  LS_PRODDRGSDB01.ccgs_coreissue.dbo.astatusaccounts a with(nolock)  on 
	  (a.merchantaid =  bp.parent05aid  and   a.parent01aid  = bp.ccinhparent125aid )
	  where  bp.systemstatus  =14 and (  manualinitialchargeoffreason  <> coreasoncode  and coreasoncode  is not null)


	  
select  'update  top(1) bsegmentcreditcard  set  manualinitialchargeoffreason  =  ''' + coreasoncode + ''' where    acctid  ='  +   cast  (bp.acctid  as varchar ),
'update  top(1) bsegment_primary  set  tpyblob  =  null  ,tpynad = null , tpylad = null   where    acctid  ='  +  
cast  (bp.acctid  as varchar ),
'UPDATE TOP(1) AccountInfoForReport SET ManualInitialChargeOffReason = ''' + coreasoncode + ''' where    BSAcctId  ='  +   cast  (bp.acctid  as varchar ) + ' AND BusinessDay = ''2021-12-02 23:59:57''' AIR,
autoinitialchargeoffreason,manualinitialchargeoffreason,b.acctid,ccinhparent125aid,coreasoncode,statusdescription  
from LS_PRODDRGSDB01.ccgs_coreissue.dbo.bsegmentcreditcard  b  with(nolock)  join   LS_PRODDRGSDB01.ccgs_coreissue.dbo.bsegment_primary  bp  with(nolock)
on (b.acctid = bp.acctid )
join  LS_PRODDRGSDB01.ccgs_coreissue.dbo.astatusaccounts a with(nolock)  on 
(a.merchantaid =  bp.parent05aid  and   a.parent01aid  = bp.ccinhparent125aid )
where  bp.systemstatus  =14 
and ((ISNULL(ManualInitialChargeOffReason, '0') = '0' OR ManualInitialChargeOffReason = '')
AND (ISNULL(AutoInitialChargeOffReason, '0') = '0' OR AutoInitialChargeOffReason = ''))



;WITH CTE
AS
(
	SELECT BSAcctID, BusinessDay, ManualInitialChargeOffReason, AutoInitialChargeOffReason
	FROM AccountInfoForReport WITH (NOLOCK)
	WHERE SystemStatus = 14
	and ((ISNULL(ManualInitialChargeOffReason, '0') = '0' OR ManualInitialChargeOffReason = '')
	AND (ISNULL(AutoInitialChargeOffReason, '0') = '0' OR AutoInitialChargeOffReason = ''))
	--AND BusinessDay > '2022-02-01 23:59:57'
	AND BusinessDay BETWEEN '2022-02-01 23:59:57' AND '2022-02-27 23:59:57'
)
SELECT BusinessDay, COUNT(1) [Frequency]
FROM CTE 
GROUP BY BusinessDay 
ORDER BY BusinessDay DESC

;WITH CTE
AS
(
	SELECT BSAcctID, BusinessDay, ManualInitialChargeOffReason, AutoInitialChargeOffReason
	FROM AccountInfoForReport WITH (NOLOCK)
	WHERE SystemStatus = 14
	and ((ISNULL(ManualInitialChargeOffReason, '0') = '0' OR ManualInitialChargeOffReason = '')
	AND (ISNULL(AutoInitialChargeOffReason, '0') = '0' OR AutoInitialChargeOffReason = ''))
	--AND BusinessDay > '2022-02-01 23:59:57'
	AND BusinessDay BETWEEN '2022-02-24 23:59:57' AND '2022-02-27 23:59:57'
)
, AIR_0224 AS
(
	SELECT * 
	FROM CTE
	WHERE BusinessDay = '2022-02-24 23:59:57'
)
, AIR_AFTER_0224 AS
(
	SELECT * 
	FROM CTE
	WHERE BusinessDay > '2022-02-24 23:59:57'
)
SELECT BSAcctID
FROM AIR_AFTER_0224
EXCEPT
SELECT BSAcctID
FROM AIR_0224

	    




	  select * from mergeaccountjob  with(nolock) where jobstatus <>'DONE'
	 
	select  autoinitialchargeoffreason,manualinitialchargeoffreason,b.acctid,ccinhparent125aid  from bsegmentcreditcard  b  with(nolock)  join   bsegment_primary  bp  with(nolock)
	 on (b.acctid = bp.acctid ) where  bp.systemstatus  =14 
	 and (autoinitialchargeoffreason = ''   or  manualinitialchargeoffreason  = '')
	 | Underprocess Jobstatus: READY AND ProcessID: 8568 AND ComputerName: PRODDRWF51 | Found JobID: 0| Going to check manual retry, Found JobID: 0| MERGE_IN_PROCESS JobStatus : NULL AND ProcessID: 8568 AND ComputerName: PRODDRWF51| Auto-Retry check, found JobID :0| with JobStatus(READY,LOCKED) AND @CompletedStepTime= NULLAND DATEDIFF(MINUTE,CompletedStepTime,GetDate()) = NULL| JobStatus = NEW AND TransmissionTime <= Oct 31 2021 11:29PM AND ProcessID IS NULL AND ComputerName IS NULL | MrgSrcActProcDayEndMin: Oct 31 2021 11:59PM| ProcDayEnd update Check, MrgSrcActProcDayEndMin: 2021-10-31 | @MrgTransmissionTime: 2021-10-31 | @MrgSrcActProcDayEndMax :NULL| ProcDayEnd near check, MrgSrcActProcDayEndMin: 2021-10-31| MrgSrcActProcDayEndMax: 23:49:55:000| MrgTransmissionTime: 23:29:29:000| Validating under process Job, @UnderProcJobCount: 0 | @MsmqHoldCheckDisable: 0 | Going to Check MSMQ Pending Jobs, PendingMsmqJobcount: 1 | Found MSMQ Pending Jobs and updated TransmissionTime by 1 minute, PendingMsmqJobcount: 1
	select  manualinitialchargeoffreason from bsegmentcreditcard  with(nolock) where  acctid in (880088,1322765,1390447,2954843,1562984)
	select tpyblob,tpynad,tpylad from LS_PRODDRGSDB01.ccgs_coreissue.dbo.bsegment_primary  with(nolock) where  acctid in (880088,1322765,1390447,2954843,1562984)
	select tpyblob,typnad,tpylad from LS_PRODDRGSDB01.ccgs_coreissue.dbo.bsegmentcreditcard  with(nolock) where  acctid in (880088,1322765,1390447,2954843,1562984)
	select tpyblob,typnad,tpylad from LS_PRODDRGSDB01.ccgs_coreissue.dbo.bsegment_primary  with(nolock) where  acctid in (880088,1322765,1390447,2954843,1562984)


select transactionamount,txnsource,transactiondescription,transactionidentifier,claimid,revtgt,txncode_internal,creditplanmaster,* from ccard_primary with(nolock)  where cmttrantype = 'RCLS'
order by posttime  desc











	COReasonCode
3
	select * from ccardlookup  with(nolock)  where lutcode = '5202'
	select   tpyblob,accountnumber,parent05aid, systemstatus,chargeoffdate,currentbalanceco,b.acctid ,b.nad,autoinitialchargeoffreason, manualinitialchargeoffreason,autoinitialchargeoffstartdate,manualinitialchargeoffstartdate,systemchargeoffstatus,userchargeoffstatus,cycleduedtd,ccinhparent125aid,chargeoffdateparam,accountnumber
    from LS_PRODDRGSDB01.ccgs_coreissue.dbo.bsegment_primary b with(nolock) join  LS_PRODDRGSDB01.ccgs_coreissue.dbo.bsegmentcreditcard  bs  with(nolock)  on (b.acctid = bs.acctid )
where B.accountnumber  in (select accountnumber from LS_PRODDRGSDB01.ccgs_coreissue.dbo.ccard_primary with(nolock) where cmttrantype = 'RCLS') and  manualinitialchargeoffreason = '0'

select * from astatusaccounts with(nolock) where  parent01aid = 5211  and merchantaid =14994
select * from  currentbalanceaudit with(nolock) where aid =880088  and dename in ('111','222')  order by businessday desc,identityfield  desc

select * from ccard_primary with(nolock) where accountnumber = '1100011129388017'  order by posttime  desc
select * from ccard_primary with(nolock) where accountnumber = '1100011106647740'  order by posttime  desc
	--select * from LS_PRODDRGSDB01.ccgs_coreissue.dbo.commontnp with(nolock)  where tranid  =30731938447


   --- Query  account whihc  are cycledue >6  with  disaster staus  but  NAd  is  greater than '2020-06-30 23:59:55.000'

   --- Account 
   select  c.trantime,b.acctid ,nad,autoinitialchargeoffstartdate,systemchargeoffstatus,userchargeoffstatus,cycleduedtd,ccinhparent125aid,chargeoffdateparam,accountnumber
    from bsegment_primary b with(nolock) join  bsegmentcreditcard  bs  with(nolock)  on (b.acctid = bs.acctid )
	join LS_PRODDRGSDB01.ccgs_coreissue.dbo.commontnp c with(nolock)  on (c.acctid  = b.acctid  and c.tranid =0 and c.atid =51  )
  where  chargeoffdateparam <='2020-09-30 23:59:55.000'  and
   (ccinhparent125aid  in(15996,16000)  and cycleduedtd > 6)  and b.institutionid = 6981 and systemstatus  <>14   and trantime >'2020-06-30 23:59:55.000'
    

	select  bp.acctid ,c.currentbalance,cp.cycleduedtd,cp.amountoftotaldue,bp.ccinhparent125aid  from LS_PRODDRGSDB01.ccgs_coreissue.dbo.cpsgmentaccounts c with(nolock)
	 join LS_PRODDRGSDB01.ccgs_coreissue.dbo.cpsgmentcreditcard  cp with(nolock)
	on (c.acctid = cp.acctid )
	join LS_PRODDRGSDB01.ccgs_coreissue.dbo.bsegment_primary bp with(nolock) on   (c.parent02aid = bp.acctid )
	   where  c.currentbalance  <= 0 and cp.amountoftotaldue > 0 and bp.systemstatus <>14  and bp.acctid  in (2067873,
11116119,
1367256,
1987138,
11086142,
20135000)

	select * from summaryheader  with(nolock)   where  parent02aid  < 0    order by statementdate  desc
	select beginningbalance,currentbalance,* from statementheader   with(nolock)   where acctid  in  (4514677,14102968)  order by statementdate  desc
	select beginningbalance,parent02aid,currentbalance,* from summaryheader   with(nolock)   where statementid  = 53442195  order by statementdate  desc

	 (4514677,14102968)
	update  top(2)	cpsgmentaccounts   set  beginningbalance   =  0    where  acctid  in (39135058,41006009)
	update  top(1)	bsegment_primary   set  beginningbalance   =  0    where  acctid  in (14102968)
	select beginningbalance,parent02aid,creditplantype,currentbalance,amountofdebitsctd,amountofcreditsctd,decurrentbalance_trantime_ps,* from cpsgmentaccounts     with(nolock)   where parent02aid    in (4514677,14102968)order by statementdate  desc
	
	select beginningbalance,currentbalance,parent02aid,creditplantype,amountofdebitsctd,amountofcreditsctd,decurrentbalance_trantime_ps,* from bsegment_primary      with(nolock)   where acctid  in (4514677,14102968)

	53442195




--	UPDATE  top(1)   BSegmentCreditCard SET ManualInitialChargeOffReason = '3' WHERE acctId = 2000108
--UPDATE  top(1)   BSegmentCreditCard SET ManualInitialChargeOffReason = '3' WHERE acctId = 2095875
--UPDATE  top(1)   BSegmentCreditCard SET ManualInitialChargeOffReason = '3' WHERE acctId = 2556494
--UPDATE  top(1)   BSegmentCreditCard SET ManualInitialChargeOffReason = '3' WHERE acctId = 4230374
--UPDATE  top(1)   BSegmentCreditCard SET ManualInitialChargeOffReason = '3' WHERE acctId = 4407269

--UPDATE  top(1)   BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 2000108
--UPDATE  top(1)   BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 2095875
--UPDATE  top(1)   BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 2556494
--UPDATE  top(1)   BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 4230374
--UPDATE  top(1)   BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 4407269

	 
	--- Validation 
	   select  b.acctid  ,manualinitialchargeoffreason,autoinitialchargeoffreason,bs.systemchargeoffstatus,bs.userchargeoffstatus,b.cycleduedtd,
	   ccinhparent125aid,bs.chargeoffdateparam,b.accountnumber
    from bsegment_primary b with(nolock) join  bsegmentcreditcard  bs  with(nolock)  on (b.acctid = bs.acctid )
	 where   systemstatus  = 14 --and  ccinhparent125aid = '16022' 
	   and manualinitialchargeoffreason  ='0' and 	 autoinitialchargeoffreason  ='0'
	join LS_PRODDRGSDB01.ccgs_coreissue.dbo.commontnp c with(nolock)  on (c.acctid  = b.acctid  and c.tranid =0 and c.atid =51  )
	--join   LS_PRODDRGSDB01.ccgs_coreissue.dbo.c  TT with(nolock)  on (TT.acctid = b.acctid) where TT.jobstatus =1

	select * from LS_PRODDRGSDB01.ccgs_coreissue.dbo.statementvalidation  with(nolock) order by skey  desc
	ValidationDescription
Beginning Balance+Transaction Activity=Ending Balance based on AmountOfDebitsCTD field
	Skey
1


select  accountnumber from LS_PRODDRGSDB01.ccgs_coreissue.dbo.bsegment_primary with (nolock) where acctid = 52402
	select count(1),validationfail,ValidationDescription  from LS_PRODDRGSDB01.ccgs_coreissue.dbo.statementvalidation sl  with(nolock) 
	left  join  LS_PRODDRGSDB01.ccgs_coreissue.dbo.statementvalidationlookup  s  with(nolock)
	on (s.validationnumber =  sl.validationfail)
	where  statementdate = '2021-08-31 23:59:57.000'
	group  by validationfail,ValidationDescription  
	order by skey  desc
	--52402,201817 202484
	select * from LS_PRODDRGSDB01.ccgs_coreissue.dbo.statementvalidation with (nolock) where  acctid = 201817
	--validationfail in ('q8') 
	and statementdate = '2021-08-31 23:59:57.000'
	
	select  * from  LS_PRODDRGSDB01.ccgs_coreissue.dbo.statementvalidationlookup  sl  with(nolock)
	   select  c.trantime,b.acctid ,TT.nad,bs.autoinitialchargeoffstartdate,bs.systemchargeoffstatus,bs.userchargeoffstatus,b.cycleduedtd,
	   TT.ccinhparent125aid,bs.chargeoffdateparam,b.accountnumber
    from bsegment_primary b with(nolock) join  bsegmentcreditcard  bs  with(nolock)  on (b.acctid = bs.acctid 

  where  chargeoffdateparam <='2021-11-30 23:59:55.000'  and
   ( cycleduedtd > 6)  and b.institutionid = 6981 and systemstatus  <>14   and trantime >'2020-06-30 23:59:55.000'



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