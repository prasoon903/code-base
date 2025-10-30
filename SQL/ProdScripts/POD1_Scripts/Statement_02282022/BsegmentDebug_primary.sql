--select  * from ccardlookup with(nolock)  where  lutid  = 'asstplan'  and lutcode in (16022,16014)
--select * from bsegment_primary with(nolock) where accountnumber = '5210'
   
   --select * from  currentbalanceaudit  with(nolock) where aid =638646  and atid =51 
   --order by businessday desc
   
   --select * from accountinfoforreport   with(nolock) where bsacctid  =638646 --  and atid =51 
   --order by businessday desc
   --select   * from LINK_PROD1GSDB01.ccgs_coreissue.dbo.creditlimitauditlog with(nolock)  where  acctid  =6657992
   
   --select * from planinfoforreport   with(nolock) where cpsacctid  =651056 --  and atid =51 
   --order by businessday desc
   ----Begin  Tran 

   --Update  cpsgmentaccounts  set currentbalance =  principal +IntBilledNotpaid ,decurrentbalance_trantime_ps = principal +IntBilledNotpaid  where acctid  = 651056
   --Update  statementheader   set currentbalance =  principal +IntBilledNotpaid    where acctid  = 638646 and statementdate = '2020-05-31 23:59:57.000'
   --Update  Summaryheader    set currentbalance =  principal +IntBilledNotpaid    where acctid  = 651056 and statementdate = '2020-05-31 23:59:57.000'
   --Update  planinfoforreport    set currentbalance =  principal +IntBilledNotpaid    where acctid  = 651056 and Businessday  = '2020-05-31 23:59:57.000'

   --Commit 
   --select systemstatus,currentbalance,AmtOfPayCurrDue,AmtOfPayXDLate,cycleduedtd,s.statementdate,* from  statementheader s   with(nolock) where acctid =999095  and atid =51 
   --order by s.statementdate  desc

   ---1100011140510102


 Declare @Bsacctid  int =0 ,@Accountnumber varchar(19) = '1100011139763977               ',
		@ccard  int = 1,  -- 1 == all ,2 = maxis
		@instid int = 6981 ,
		@supporttable int =1, -- 0/1
		@Aggregate  int = 1,-- 0/1
		@StatementSummary tinyint = 1-- 0/1
 

if (@Bsacctid <=0  and @Accountnumber is not null )
Begin select @Bsacctid =acctid,@instid = institutionid from LINK_PROD1GSDB01.ccgs_coreissue.dbo.bsegment_primary with(nolock) where Accountnumber = @Accountnumber End
else Begin  select @Accountnumber = accountnumber,@instid = institutionid from LINK_PROD1GSDB01.ccgs_coreissue.dbo.bsegment_primary with(nolock) where acctid  = @BSacctid ENd


--select * from LINK_PROD1GSDB01.ccgs_coreissue.dbo.createnewsingletransactiondata  with(nolock)  where Accountnumber  =@Accountnumber
if (@supporttable = 1)
begin
 --SUM(ISNULL(AmountOfCreditsLTD,0) - isnull(AmountOfCreditsRevLTD,0) + isnull(DisputesAmtNS,0) + isnull (DispRCHFavororWriteoff,0) ) 
 select 'Bsegment' as tablename,nad,chargeoffdateparam,coinitiatesource,ccinhparent125aid,systemstatus,AutoInitialChargeoffReason,bc.manualinitialchargeoffreason,ccinhparent125aid,parent02aid,chargeoffdate,activitycode,systemstatus,dateoftotaldue
 ,bp.acctid,laststatementdate,lad,currentbalance + currentbalanceco ,principal,
 IntBilledNotPaid,recoveryfeesbnp,DisputesAmtNS,SRBWithInstallmentDue,CYCLEDUEDTD,amountoftotaldue,AmtOfPayCurrDue,AmtOfPayXDLate,AmountOfPayment30DLate,AmountOfPayment60DLate,
 AmountOfPayment90DLate,AmountOfPayment120DLate, 
 AmountOfPayment150DLate,AmountOfPayment180DLate,AmountOfPayment210DLate,AmountOfDebitsCTD,AmountofPurchasesCTD,AmountOfcreditsCTD,amountofpaymentsctd,AmountOfCreditsAsPmtCTD,accountnumber,billingcycle
 ,SRBWithInstallmentDue,systemstatus,CYCLEDUEDTD,DisputesAmtNS,billingcycle,SBWithInstallmentDue,DateOfNextStmt,accountnumber
 ,systemstatus,CYCLEDUEDTD,dateoforiginalpaymentduedtd,DtOfLastDelinqCTD,daysdelinquent,NoPayDaysDelinquent,dateoftotaldue,bp.acctid,Accountnumber
 ,currentbalance,principal,servicefeesbnp,latefeesbnp
 ,AmtOfPayCurrDue,currentdue,LastStatementDate,AmountOfDebitsCTD,AmountofPurchasesCTD
 ,billingcycle,daysdelinquent,daysdelinquent,DtOfLastDelinqCTD
  from LINK_PROD1GSDB01.ccgs_coreissue.dbo.BSegment_Primary BP  with(nolock) join LINK_PROD1GSDB01.ccgs_coreissue.dbo.bsegmentcreditcard  BC  with(nolock) on BP.acctid =BC.acctid join bsegment_secondary BS with(nolock) on BP.acctid =BS.acctid  
 JOIN LINK_PROD1GSDB01.ccgs_coreissue.dbo.BSegment_Balances bb WITH(NOLOCK) ON bp.ACCTID =BB.ACCTID --where BP.acctid =5033 --bp.accountnumber  = '1100001000016019'
 where bp.acctid =@Bsacctid   -- //bp.currentbalance <=0  

   select  payoffdate,decurrentbalance_trantime_ps, originalpurchaseamount,AmountOfCreditsCTD,AmountOfCreditsLTD, AmountOfCreditsRevCTD,  DisputesAmtNS, DispRCHFavororWriteoff,
   case when  creditplantype = '16' then 'CPSRetail'  when creditplantype = '10' then 'RRC' else 'CPSRevolving' End  as CPSegment,sh.acctid,lad,currentbalance,principal,IntBilledNotPaid
   ,recoveryfeesbnp,DisputesAmtNS,SRBWithInstallmentDue,CYCLEDUEDTD,amountoftotaldue,AmtOfPayCurrDue,AmtOfPayXDLate,AmountOfPayment30DLate,AmountOfPayment60DLate,
 AmountOfPayment90DLate,AmountOfPayment120DLate, 
 AmountOfPayment150DLate,AmountOfPayment180DLate,AmountOfPayment210DLate,AmountOfDebitsCTD,AmountofPurchasesCTD,AmountOfcreditsCTD,amountofpaymentsctd,AmountOfCreditsAsPmtCTD,plansegcreatedate,
 newtransactionsbsfc,revolvingbsfc,aftercyclerevolvbsfc

 from LINK_PROD1GSDB01.ccgs_coreissue.dbo.cpsgmentaccounts  sh with(nolock) join LINK_PROD1GSDB01.ccgs_coreissue.dbo.cpsgmentcreditcard shcc with(nolock) on sh.acctid =shcc.acctid
 where sh.parent02aid in (@Bsacctid) --order by plansegcreatedate asc
 --Union
 -- select   sum(originalpurchaseamount),sum(amountOfCreditsCTD),sum(AmountOfCreditsLTD),     sum(AmountOfCreditsRevLTD),sum(DisputesAmtNS), sum(DispRCHFavororWriteoff), 'z_CPSAggr'   as CPSegment,sh.parent02aid,max(lad),sum(currentbalance),sum(principal),sum(IntBilledNotPaid),sum(recoveryfeesbnp),sum(DisputesAmtNS),sum(SRBWithInstallmentDue),
 -- max(CYCLEDUEDTD),sum(amountoftotaldue),sum(AmtOfPayCurrDue),sum(AmtOfPayXDLate),sum(AmountOfPayment30DLate),sum(AmountOfPayment60DLate),
 --sum(AmountOfPayment90DLate),sum(AmountOfPayment120DLate), 
 --sum(AmountOfPayment150DLate),sum(AmountOfPayment180DLate),sum(AmountOfPayment210DLate),sum(AmountOfDebitsCTD),sum(AmountofPurchasesCTD),sum(AmountOfcreditsCTD),sum(amountofpaymentsctd),
 --sum(AmountOfCreditsAsPmtCTD),max(plansegcreatedate),sum(newtransactionsbsfc),sum(revolvingbsfc),sum(aftercyclerevolvbsfc)
 --   from cpsgmentaccounts  sh with(nolock) join cpsgmentcreditcard shcc with(nolock) on sh.acctid =shcc.acctid
 -- where sh.parent02aid in (@Bsacctid) and @Aggregate =1
 -- group by parent02aid
 -- order by CPSegment asc

  End
  Declare @Statementdate datetime  
  select @Statementdate= max(statementdate) from LINK_PROD1GSDB01.ccgs_coreissue_Secondary.dbo.statementheader with(nolock) where acctid = @bsacctid 
    ---------statement  --------------

if (@StatementSummary = 1)
begin 
 select 'statementheader' as tablename,creditlimit,ccinhparent125aid,systemstatus,s.statementid,s.statementdate,lad,currentbalance,principal,IntBilledNotPaid,recoveryfeesbnp,DisputesAmtNS,SRBWithInstallmentDue,CYCLEDUEDTD,amountoftotaldue,AmtOfPayCurrDue,AmtOfPayXDLate,AmountOfPayment30DLate,AmountOfPayment60DLate,
 AmountOfPayment90DLate,AmountOfPayment120DLate, 
 AmountOfPayment150DLate,AmountOfPayment180DLate,AmountOfPayment210DLate,AmountOfDebitsCTD,AmountofPurchasesCTD,AmountOfcreditsCTD,amountofpaymentsctd,accountnumber
 from LINK_PROD1GSDB01.ccgs_coreissue_secondary.dbo.statementheader s with(nolock) join LINK_PROD1GSDB01.ccgs_coreissue.dbo.statementheaderex st on (s.statementid = st.statementid)
 where s.acctid =@Bsacctid -- and s.statementdate  =@Statementdate  
 order by s.statementdate desc



   --------- summary --------------
 select    sh.statementid,payoffdate,AmountOfCreditsCTD,AmountOfCreditsLTD,DisputesAmtNS, DispRCHFavororWriteoff, case when  creditplantype = '16' then 'SummaryRetail'  when creditplantype = '10' then 'RRC' else 'summaryRevolving' End  as summary,sh.acctid,lad,currentbalance,principal,IntBilledNotPaid,recoveryfeesbnp,DisputesAmtNS,SRBWithInstallmentDue,CYCLEDUEDTD,amountoftotaldue,currentdue,AmtOfPayXDLate,AmountOfPayment30DLate,AmountOfPayment60DLate,
 AmountOfPayment90DLate,AmountOfPayment120DLate, 
 AmountOfPayment150DLate,AmountOfPayment180DLate,AmountOfPayment210DLate,AmountOfDebitsCTD,AmountofPurchasesCTD,AmountOfcreditsCTD,amountofpaymentsctd,AmountOfCreditsAsPmtCTD,plansegcreatedate
 from LINK_PROD1GSDB01.ccgs_coreissue_secondary.dbo.Summaryheader sh with(nolock) join LINK_PROD1GSDB01.ccgs_coreissue.dbo.Summaryheadercreditcard shcc with(nolock) on sh.acctid =shcc.acctid and sh.statementID =shcc.StatementID 
where sh.parent02aid in (@Bsacctid) and sh.statementdate  =@Statementdate
--Union
--  select  sum(AmountOfCreditsCTD), sum(AmountOfCreditsLTD),sum(DisputesAmtNS), sum(DispRCHFavororWriteoff), 'z_Summaryaggr'   as summary,sh.parent02aid,max(lad),sum(currentbalance),sum(principal),sum(IntBilledNotPaid),sum(recoveryfeesbnp),sum(DisputesAmtNS),sum(SRBWithInstallmentDue),
--  max(CYCLEDUEDTD),sum(amountoftotaldue),sum(currentdue),sum(AmtOfPayXDLate),sum(AmountOfPayment30DLate),sum(AmountOfPayment60DLate),
-- sum(AmountOfPayment90DLate),sum(AmountOfPayment120DLate), 
-- sum(AmountOfPayment150DLate),sum(AmountOfPayment180DLate),sum(AmountOfPayment210DLate),sum(AmountOfDebitsCTD),sum(AmountofPurchasesCTD),sum(AmountOfcreditsCTD),sum(amountofpaymentsctd),
-- sum(AmountOfCreditsAsPmtCTD),max(plansegcreatedate)
-- from Summaryheader sh with(nolock) join Summaryheadercreditcard shcc with(nolock) on sh.acctid =shcc.acctid and sh.statementID =shcc.StatementID 
--  where sh.parent02aid in (@Bsacctid) and sh.statementdate  =@Statementdate and @Aggregate =1
--  group by parent02aid
--  order by summary asc

End

if(@ccard = 2 or @ccard = 1)  
Begin
  if (@ccard =1 )
  begin 
	 select transactiondescription,cpmgroup,creditplanmaster,hostmachinename,paymentcreditflag,totalrewardpoints,cmttrantype,transactionamount,bsacctid,posttime,trantime,accountnumber,bsacctid,txnacctid,noblobindicator,txnsource,cp.tranid,tranref,tranorig,revtgt,memoindicator,
	 transactiondescription,txncode_internal,invoicenumber,caseid,rmatranuuid,MessageIdentifier,paymentcreditflag from LINK_PROD1GSDB01.ccgs_coreissue.dbo.ccard_primary cp with(nolock)
	   left join LINK_PROD1GSDB01.ccgs_coreissue.dbo.ccard_secondary Cs with(nolock) on (cp.tranid = cs.tranid)
	  where accountnumber =@Accountnumber  and cmttrantype  not in ('HPOTB','PPR')--,'MMR') -- and tranref = 39067 and noblobindicator = 6--and cp.txnacctid in (5051) and cmttrantype in ('110','115','116','40')
		order by cp.posttime desc,cp.tranid asc
		--print  'Rohit Soni'
	End
	else
	Begin 
		 select paymentcreditflag,cmttrantype,transactionamount,bsacctid,posttime,accountnumber,bsacctid,txnacctid,noblobindicator,txnsource,cp.tranid,tranref,tranorig,revtgt,
		 memoindicator,transactiondescription,txncode_internal,invoicenumber from LINK_PROD1GSDB01.ccgs_coreissue.dbo.ccard_primary cp with(nolock)
	   left join LINK_PROD1GSDB01.ccgs_coreissue.dbo.ccard_secondary Cs with(nolock) on (cp.tranid = cs.tranid)
	  where accountnumber  =@Accountnumber  and cmttrantype  not in ('HPOTB','PPR','MMR')
	  and  (len(cmttrantype) = 2  or  try_cast(cmttrantype as int ) < 120 or try_cast(cmttrantype as int ) > 1000 or cmttrantype in ('p9001'))-- and cmttrantype = '41'
		order by cp.posttime desc,cp.tranid asc
		--print  'Rohit Soni'
	End


End

if (@supporttable = 9)
Begin 
	select 'commontnp',* from LINK_PROD1GSDB01.ccgs_coreissue.dbo.commontnp with(nolock) where acctid = @bsacctid  and atid not in (53) or  (atid = 60 and institutionid =@instid )
	order by trantime,priority 
select 'purchasereversalrecord' as tablename ,* from  LINK_PROD1GSDB01.ccgs_coreissue.dbo.purchasereversalrecord with(nolock) where parent02aid = @bsacctid
Select 'ilpscheduledetailsummary'as tablename ,lp.parent02aid,lp.loandate,lp.paidoffdate,lp.loanenddate,lp.planuuid,lp.scheduleid,cl.LutDescription,* from ilpscheduledetailsummary LP with (nolock)
join ccardlookup cl with(nolock) on ( cl.LUTid = 'EPPReasonCode' and cl.LutCode = lp.Activity)
--where lutdescription like '%plan%'
--scheduleid=4996 
where parent02aid=@bsacctid 
order by lp.loandate;

select 'errortnp'as tablename  ,* from LINK_PROD1GSDB01.ccgs_coreissue.dbo.errortnp  with(nolock)  where acctid = @bsacctid
End


--print  'Rohit Soni'


--select * from currentbalanceauditps  with(nolock)  where tid in (25943555758,26007849462) and aid =575735and dename = '200'
--select * from currentbalanceauditps  with(nolock)  where tid in (25943555758,26007849462) and aid =5285516 and dename = '200'
--select cycleduedtd,AmtOfPayCurrDue,DateOfOriginalPaymentDueDTD,* from bsegment_primary  with(nolock) where acctid = 563515 
--select DateOfOriginalPaymentDueDTD,* from bsegmentcreditcard  with(nolock) where acctid = 563515 



--select * from currentbalanceauditps  with(nolock)  where  tid in (26081376941,26125338750) and  dename = '200' and aid in(6150876,14387829)
--select * from currentbalanceauditps  with(nolock)  where tid in (25943555758,26007849462) and aid =5285516 and dename = '200'
--select cycleduedtd,AmtOfPayCurrDue,DateOfOriginalPaymentDueDTD,* from bsegment_primary  with(nolock) where acctid = 563515 
--select DateOfOriginalPaymentDueDTD,* from bsegmentcreditcard  with(nolock) where acctid = 4232726 
--select * from currentbalanceaudit with(nolock)  where  tid in (28628820620) and aid =6077653 --  and tid = 28615086102
--  order by identityfield desc
--select * from currentbalanceaudit  with(nolock)  where   aid =4271726  order by identityfield desc
--select * from  LINK_PROD1GSDB01.ccgs_coreissue.dbo.plandelinquencyrecord with(nolock) where tranref  in (28628820620)
--select * from  LINK_PROD1GSDB01.ccgs_coreissue.dbo.delinquencyrecord with(nolock) where tranid = 28628820620
--select * from  LINK_PROD1GSDB01.ccgs_coreauth.dbo.bsegment_primary with(nolock) where acctid = 4232726
--select * from  LINK_PROD1GSDB01.ccgs_coreissue.dbo.commontnp with(nolock) where  acctid  in (1569863,2439409)
--5 Account Data fix 

---select * from  LINK_PROD1GSDB01.ccgs_coreissue.dbo.clearingfiles  with(nolock)  order by date_received desc
---select * from  LINK_PROD1GSDB01.ccgs_coreissue.dbo.clearingfiles  with(nolock)  order by date_received desc



--select * from  LINK_PROD1GSDB01.ccgs_coreissue.dbo.clearingfiles  with(nolock)  order by date_received  desc

--select * from currentbalanceauditps  with(nolock) where aid = 376393  and dename = '200' and identityfield = 544384769
--select amountoftotaldue,AmtofPayCurrDue,* from cpsgmentcreditcard  with(nolock) where Acctid = 376393
--select currentdue,* from summaryHeaderCreditCard  with(nolock) where Acctid = 376393  and statementid =17658352
--select amountoftotaldue,* from summaryheader   with(nolock) where Acctid = 376393 and statementid =17658352


--update  cpsgmentcreditcard  set  amountoftotaldue = amountoftotaldue - .01  , AmtofPayCurrDue  = AmtofPayCurrDue - .01  where Acctid = 376393
--	update  summaryheader   set  amountoftotaldue = amountoftotaldue - .01   where Acctid = 376393  and statementid =17658352
--	update  summaryHeaderCreditCard   set   currentdue  = currentdue - .01  where Acctid = 376393  and statementid =17658352
--update  currentbalanceauditps  set newvalue = '19.42' where aid = 376393  and dename = '200' and identityfield = 550983159



--select  count(1),trantime,priority,atid from LINK_PROD1GSDB01.ccgs_coreissue.dbo.commontnp with(nolock)
--	group  by trantime,priority,atid
--	order by trantime,priority,atid 

--	select * from LINK_PROD1GSDB01.ccgs_coreissue.dbo.ccard_primary with(nolock) where tranid  = 28328131217
--	select * from LINK_PROD1GSDB01.ccgs_coreissue.dbo.Temp_TNP_NAD with(nolock)  where jobstatus = 1
--	select * from LINK_PROD1GSDB01.ccgs_coreissue.dbo.Temp_TNP_NAD with(nolock)  where jobstatus = 0
--select * from LINK_PROD1GSDB01.ccgs_coreissue.dbo.commontnp with(nolock) 
-- where  trantime < '2020-06-27 07:26:23.000'

-- select * from LINK_PROD1GSDB01.ccgs_coreissue.dbo.Errortnp with(nolock) 
-- where  trantime < '2020-06-27 07:26:23.000'