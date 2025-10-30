select 

'update    top(1)  statementheader   set   srbwithinstallmentdue  = 0 , sbwithinstallmentdue = 0 ,amountoftotaldue = 0   , amtofpaycurrdue= 0   ,  amtofpayxdlate =0 
, AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,
 AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,
 AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,cycleduedtd = 0  ,DateOfOriginalPaymentDUeDTD =  null  , minimumpaymentdue = 0  , AmtOfPayPastDue = 0   where   acctid  = ' +  cast(acctid  as varchar)  + ' and statementid  = ' +  cast(statementid as varchar)  as  statementheader,



 'update    top(1)  accountinfoforreport   set   srbwithinstallmentdue  = 0 , sbwithinstallmentdue = 0 , runningminimumdue = 0 , remainingminimumdue = 0 ,
 amountoftotaldue = 0   , amtofpaycurrdue= 0   ,  amtofpayxdlate =0 
, AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,
 AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,
 AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,cycleduedtd = 0  ,DateOfOriginalPaymentDUeDTD =  null ,
  daysdelinquent  = 0 , Totaldaysdelinquent = 0 , dateofdelinquency = null   where   bsacctid  = ' +  cast(acctid  as varchar)  + ' and businessday  = ' + '''2022-09-30 23:59:57'''   as accountinfoforreport,


 
'update    top(1)  bsegmentcreditcard    set   srbwithinstallmentdue  = 0 , sbwithinstallmentdue = 0 , runningminimumdue = 0 , remainingminimumdue = 0 
 ,amountoftotaldue = 0   ,   amtofpayxdlate =0 
, AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,
 AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,
 AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,DateOfOriginalPaymentDUeDTD =  null
  , daysdelinquent  = 0 , nopaydaysdelinquent = 0 , DtOfLastDelinqCTD = null   where   acctid  = ' +  cast(acctid  as varchar)  as bsegmentcreditcard,


  
 'update    top(1)  bsegment_primary     set   cycleduedtd= 0  , amtofpaycurrdue =0   where   acctid  = ' +  cast(acctid  as varchar )   as bsegment_primary,
 'update    top(1)  ccgs_coreauth..bsegment_primary     set    DateOfLastDelinquent = null    where   acctid  = ' +  cast(acctid  as varchar) as ccgs_coreauthbsegment_primary

,acctid ,CurrentBalance,currentbalanceco, amountoftotaldue, CycleDueDTD,amtofpaycurrdue,amtofpayxdlate,systemstatus ,ccinhparent125aid ,currentbalance 
from  statementheader s  with(nolock) 
where    statementdate = '2022-09-30 23:59:57' 
and  systemstatus = 14   
and   amountoftotaldue > 0   and  CurrentBalance+ CurrentBalanceco   <= 0  
--and CurrentBalance+CurrentBalanceCO > AmountOfTotalDue AND AmountOfTotalDue > 0
--and CurrentBalance+CurrentBalanceCO < AmountOfTotalDue AND AmountOfTotalDue > 0 and  CurrentBalance+ CurrentBalanceco  > 0 
--and CycleDueDTD = 0
--and  acctid  in (select  acctid   from StatementValidation  with(nolock) where  statementdate = '2022-09-30 23:59:57' )
--and  acctid  not  in (3466950)
and acctId IN (
SELECT DISTINCT BS.acctId
FROM StatementValidation SV WITH (NOLOCK) 
JOIN bSegment_Primary BS WITH (NOLOCK)  ON (SV.acctId = BS.acctId AND SV.StatementDate = '2022-09-30 23:59:57.000')
JOIN StatementJobs SJ WITH (NOLOCK)  ON (SJ.acctId = BS.acctId AND SJ.StatementDate = SV.StatementDate)
WHERE SV.StatementDate = '2022-09-30 23:59:57.000' --AND ValidationFail = 'Q23'
AND BS.SystemStatus = 14 --and  BS.acctid  not  in (3466950)
)


select 

'update    top(1)  statementheader   set  amountoftotaldue = ' + TRY_CAST(CurrentBalanceco AS VARCHAR) + '   , amtofpaycurrdue= ' + TRY_CAST(CurrentBalanceco AS VARCHAR) +  ' ,  amtofpayxdlate =0 
, AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,
 AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,
 AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,cycleduedtd = 1 , minimumpaymentdue = ' + TRY_CAST(CurrentBalanceco AS VARCHAR) + '  , AmtOfPayPastDue = 0   where   acctid  = ' +  cast(acctid  as varchar)  + ' and statementid  = ' +  cast(statementid as varchar)  as  statementheader,



 'update    top(1)  accountinfoforreport   set   
 amountoftotaldue = ' + TRY_CAST(CurrentBalanceco AS VARCHAR) + '   , amtofpaycurrdue= ' + TRY_CAST(CurrentBalanceco AS VARCHAR) +  '   ,  amtofpayxdlate =0 
, AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,
 AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,
 AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,cycleduedtd = 1  where   bsacctid  = ' +  cast(acctid  as varchar)  + ' and businessday  = ' + '''2022-09-30 23:59:57'''   as accountinfoforreport,


 
'update    top(1)  bsegmentcreditcard    set    runningminimumdue = ' + TRY_CAST(CurrentBalanceco AS VARCHAR) + ' , remainingminimumdue = ' + TRY_CAST(CurrentBalanceco AS VARCHAR) + '
 ,amountoftotaldue = ' + TRY_CAST(CurrentBalanceco AS VARCHAR) + '   ,   amtofpayxdlate =0 
, AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,
 AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,
 AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0   where   acctid  = ' +  cast(acctid  as varchar)  as bsegmentcreditcard,


  
 'update    top(1)  bsegment_primary     set   cycleduedtd= 1  , amtofpaycurrdue= ' + TRY_CAST(CurrentBalanceco AS VARCHAR) +  '   where   acctid  = ' +  cast(acctid  as varchar )   as bsegment_primary

,acctid ,CurrentBalance,currentbalanceco, amountoftotaldue, CycleDueDTD,amtofpaycurrdue,amtofpayxdlate,systemstatus ,ccinhparent125aid ,currentbalance ,
amountoftotaldue-currentbalanceco AD_DIFF, amtofpaycurrdue-currentbalanceco CD_DIFF,
amountoftotaldue-(amountoftotaldue-currentbalanceco) NEW_AD, amtofpaycurrdue-(amountoftotaldue-currentbalanceco) New_CD,
amtofpaycurrdue,AmtOfPayXDLate,AmountOfPayment30DLate, AmountOfPayment60DLate, 
	AmountOfPayment90DLate, AmountOfPayment120DLate, AmountOfPayment150DLate, AmountOfPayment180DLate,AmountOfPayment210DLate,
((amtofpaycurrdue-(amountoftotaldue-currentbalanceco))+AmtOfPayXDLate+AmountOfPayment30DLate+ AmountOfPayment60DLate+ AmountOfPayment90DLate+ AmountOfPayment120DLate+ AmountOfPayment150DLate+ AmountOfPayment180DLate+ AmountOfPayment210DLate) AS CalculatedAD 
from  statementheader s  with(nolock) 
where    statementdate = '2022-09-30 23:59:57' 
and  systemstatus = 14   
--and   amountoftotaldue > 0   and  CurrentBalance+ CurrentBalanceco   <= 0  
--and CurrentBalance+CurrentBalanceCO > AmountOfTotalDue AND AmountOfTotalDue > 0
and CurrentBalance+CurrentBalanceCO < AmountOfTotalDue AND AmountOfTotalDue > 0 and  CurrentBalance+ CurrentBalanceco  > 0 
--and CycleDueDTD = 0
--and  acctid  in (select  acctid   from StatementValidation  with(nolock) where  statementdate = '2022-09-30 23:59:57' )
--and  acctid  not  in (3466950)
and acctId IN (
SELECT DISTINCT BS.acctId
FROM StatementValidation SV WITH (NOLOCK) 
JOIN bSegment_Primary BS WITH (NOLOCK)  ON (SV.acctId = BS.acctId AND SV.StatementDate = '2022-09-30 23:59:57.000')
JOIN StatementJobs SJ WITH (NOLOCK)  ON (SJ.acctId = BS.acctId AND SJ.StatementDate = SV.StatementDate)
WHERE SV.StatementDate = '2022-09-30 23:59:57.000' --AND ValidationFail = 'Q23'
AND BS.SystemStatus = 14 --and  BS.acctid  not  in (3466950)
)



select 
'update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = ' +  cast(acctid  as varchar)  + ' and statementid  = ' +  cast(statementid as varchar)  as  statementheader,
'update    top(1)  accountinfoforreport   set   CycleDueDTD = 1  where   bsacctid  = ' +  cast(acctid  as varchar)  + ' and businessday  = ' + '''2022-09-30 23:59:57'''   as accountinfoforreport,  
'update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = ' +  cast(acctid  as varchar )   as bsegment_primary
,acctid ,currentbalanceco, amountoftotaldue, CycleDueDTD,amtofpaycurrdue,amtofpayxdlate,systemstatus ,ccinhparent125aid ,currentbalance 
from  statementheader s  with(nolock) 
where    statementdate = '2022-09-30 23:59:57' 
and  systemstatus = 14   
--and  (( amountoftotaldue > 0   and  CurrentBalance+ CurrentBalanceco   <= 0 ) OR CurrentBalance+CurrentBalanceCO > AmountOfTotalDue AND AmountOfTotalDue > 0)
and CycleDueDTD = 0
--and  acctid  in (select  acctid   from StatementValidation  with(nolock) where  statementdate = '2022-09-30 23:59:57' )
--and  acctid  not  in (3466950)
and acctId IN (
SELECT DISTINCT BS.acctId
FROM StatementValidation SV WITH (NOLOCK) 
JOIN bSegment_Primary BS WITH (NOLOCK)  ON (SV.acctId = BS.acctId AND SV.StatementDate = '2022-09-30 23:59:57.000')
JOIN StatementJobs SJ WITH (NOLOCK)  ON (SJ.acctId = BS.acctId AND SJ.StatementDate = SV.StatementDate)
WHERE SV.StatementDate = '2022-09-30 23:59:57.000' --AND ValidationFail = 'Q23'
AND BS.SystemStatus = 14 --and  BS.acctid  not  in (3466950)
)

--------------------------------------------------------- PLAN LEVEL ---------------------------------------------


select  s.parent02aid,

'update      top(1) summaryheadercreditcard    set   srbwithinstallmentdue  = 0 , sbwithinstallmentdue = 0 , currentdue= 0   ,  amtofpayxdlate =0 
, AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,
 AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,
 AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,cycleduedtd = 0  
     where   acctId  = ' +  cast(s.acctid  as varchar)  + ' and statementid  = ' +  cast(s.statementid as varchar)  as summaryheadercreditcard ,

'update     top(1)   summaryheader    set   amountoftotaldue  = 0 
  where   acctId  = ' +  cast(s.acctid  as varchar)  + ' and statementid  = ' +  cast(s.statementid as varchar) as summaryheader ,

 'update   top(1)   planinfoforreport   set   srbwithinstallmentdue  = 0 , sbwithinstallmentdue = 0  ,amountoftotaldue = 0   , amtofpaycurrdue= 0   ,  amtofpayxdlate =0 
, AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,
 AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,
 AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,cycleduedtd = 0    where   cpsacctid  = ' +  cast(sh.acctid  as varchar)  + ' and businessday  = ' + '''2022-09-30 23:59:57'''   as planinfoforreport,

 'update   top(1)   CPSgmentCreditcard   set   srbwithinstallmentdue  = 0 , sbwithinstallmentdue = 0  ,amountoftotaldue = 0   , amtofpaycurrdue= 0   ,  amtofpayxdlate =0 
, AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,
 AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,
 AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,cycleduedtd = 0    where   acctid  = ' +  cast(sh.acctid  as varchar)

 from  summaryheader s  with(nolock) 
join   summaryheadercreditcard  sh  with(nolock) on (s.acctid  = sh.acctid  and  s.statementid = sh.statementid )
join   statementheader   st  with(nolock) on (s.parent02aid  = st.acctid  and  s.statementid = st.statementid )
where  s.parent02aid   in (
SELECT DISTINCT BS.acctId
FROM StatementValidation SV WITH (NOLOCK) 
JOIN bSegment_Primary BS WITH (NOLOCK)  ON (SV.acctId = BS.acctId AND SV.StatementDate = '2022-09-30 23:59:57.000')
JOIN StatementJobs SJ WITH (NOLOCK)  ON (SJ.acctId = BS.acctId AND SJ.StatementDate = SV.StatementDate)
WHERE SV.StatementDate = '2022-09-30 23:59:57.000' --AND ValidationFail = 'Q23'
AND BS.SystemStatus = 14 --and  BS.acctid  not  in (3466950)
)
and  s.statementdate = '2022-09-30 23:59:57' 
and st.systemstatus = 14    
and   st.amountoftotaldue > 0   and  st.CurrentBalance+ st.CurrentBalanceco   <= 0 
--and  st.acctid  not  in (3466950) 



select  

'update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = ' +  cast(s.acctid  as varchar)  + ' and statementid  = ' +  cast(s.statementid as varchar)  as summaryheadercreditcard  ,
 'update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = ' +  cast(sh.acctid  as varchar)  + ' and businessday  = ' + '''2022-09-30 23:59:57'''   as planinfoforreport,
 'update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = ' +  cast(sh.acctid  as varchar)
 from  summaryheader s  with(nolock) 
join   summaryheadercreditcard  sh  with(nolock) on (s.acctid  = sh.acctid  and  s.statementid = sh.statementid )
join   statementheader   st  with(nolock) on (s.parent02aid  = st.acctid  and  s.statementid = st.statementid )
where  s.parent02aid   in (
SELECT DISTINCT BS.acctId
FROM StatementValidation SV WITH (NOLOCK) 
JOIN bSegment_Primary BS WITH (NOLOCK)  ON (SV.acctId = BS.acctId AND SV.StatementDate = '2022-09-30 23:59:57.000')
JOIN StatementJobs SJ WITH (NOLOCK)  ON (SJ.acctId = BS.acctId AND SJ.StatementDate = SV.StatementDate)
WHERE SV.StatementDate = '2022-09-30 23:59:57.000' --AND ValidationFail = 'Q23'
AND BS.SystemStatus = 14 --and  BS.acctid  not  in (3466950)
)
and  s.statementdate = '2022-09-30 23:59:57' 
and st.systemstatus = 14    
and   s.amountoftotaldue > 0   and  sh.CycleDueDTD = 0  and st.cycleduedtd = 0 and s.currentbalance+sh.currentbalanceco > 0
--and  st.acctid  not  in (3466950)



select  s.parent02aid, s.acctid,

'update      top(1) summaryheadercreditcard    set   srbwithinstallmentdue  = ' + TRY_CAST(SH.CurrentBalanceco AS VARCHAR) + ' , sbwithinstallmentdue = ' + TRY_CAST(SH.CurrentBalanceco AS VARCHAR) + ' , currentdue= ' + TRY_CAST(SH.CurrentBalanceco AS VARCHAR) + '   ,  amtofpayxdlate =0 
, AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,
 AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,
 AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,cycleduedtd = 1  
     where   acctId  = ' +  cast(s.acctid  as varchar)  + ' and statementid  = ' +  cast(s.statementid as varchar)  as summaryheadercreditcard ,

'update     top(1)   summaryheader    set   amountoftotaldue  = ' + TRY_CAST(SH.CurrentBalanceco AS VARCHAR) + ' 
  where   acctId  = ' +  cast(s.acctid  as varchar)  + ' and statementid  = ' +  cast(s.statementid as varchar) as summaryheader ,

 'update   top(1)   planinfoforreport   set   srbwithinstallmentdue  = ' + TRY_CAST(SH.CurrentBalanceco AS VARCHAR) + ' , sbwithinstallmentdue = ' + TRY_CAST(SH.CurrentBalanceco AS VARCHAR) + '
   ,amountoftotaldue = ' + TRY_CAST(SH.CurrentBalanceco AS VARCHAR) + '   , amtofpaycurrdue= ' + TRY_CAST(SH.CurrentBalanceco AS VARCHAR) + '   ,  amtofpayxdlate =0 
, AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,
 AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,
 AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,cycleduedtd = 1    where   cpsacctid  = ' +  cast(sh.acctid  as varchar)  + ' and businessday  = ' + '''2022-09-30 23:59:57'''   as planinfoforreport,

 'update   top(1)   CPSgmentCreditcard   set   srbwithinstallmentdue  = ' + TRY_CAST(SH.CurrentBalanceco AS VARCHAR) + ' , sbwithinstallmentdue = ' + TRY_CAST(SH.CurrentBalanceco AS VARCHAR) + '  ,amountoftotaldue = ' + TRY_CAST(SH.CurrentBalanceco AS VARCHAR) + '
    , amtofpaycurrdue= ' + TRY_CAST(SH.CurrentBalanceco AS VARCHAR) + '   ,  amtofpayxdlate =0 
, AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,
 AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,
 AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,cycleduedtd = 1    where   acctid  = ' +  cast(sh.acctid  as varchar)

 from  summaryheader s  with(nolock) 
join   summaryheadercreditcard  sh  with(nolock) on (s.acctid  = sh.acctid  and  s.statementid = sh.statementid )
join   statementheader   st  with(nolock) on (s.parent02aid  = st.acctid  and  s.statementid = st.statementid )
where  s.parent02aid   in (
SELECT DISTINCT BS.acctId
FROM StatementValidation SV WITH (NOLOCK) 
JOIN bSegment_Primary BS WITH (NOLOCK)  ON (SV.acctId = BS.acctId AND SV.StatementDate = '2022-09-30 23:59:57.000')
JOIN StatementJobs SJ WITH (NOLOCK)  ON (SJ.acctId = BS.acctId AND SJ.StatementDate = SV.StatementDate)
WHERE SV.StatementDate = '2022-09-30 23:59:57.000' --AND ValidationFail = 'Q23'
AND BS.SystemStatus = 14 --and  BS.acctid  not  in (3466950)
)
and  s.statementdate = '2022-09-30 23:59:57' 
and st.systemstatus = 14    
--and   st.amountoftotaldue > 0   and  st.CurrentBalance+ st.CurrentBalanceco   <= 0 
and s.CurrentBalance+sh.CurrentBalanceCO < s.AmountOfTotalDue AND s.AmountOfTotalDue > 0 and  s.CurrentBalance+ sh.CurrentBalanceco  > 0 
--and  st.acctid  not  in (3466950) 
 


--select  sh.currentbalanceco + s.currentbalance, s.creditplantype,s.amountoftotaldue,currentdue ,st.amountoftotaldue,st.acctid ,* from  summaryheader s  with(nolock) 
--join   summaryheadercreditcard  sh  with(nolock) on (s.acctid  = sh.acctid  and  s.statementid = sh.statementid )
--join   statementheader   st  with(nolock) on (s.parent02aid  = st.acctid  and  s.statementid = st.statementid )
--where  s.parent02aid   in (  select  acctid   from StatementValidation  with(nolock) where  statementdate = '2022-09-30 23:59:57')
--and  s.statementdate = '2022-09-30 23:59:57' and st.systemstatus = 14    and   st.amountoftotaldue > 0   and  st.CurrentBalance+ st.CurrentBalanceco   <= 0  and s.creditplantype = '16'

--update currentbalanceaudit  set  newvalue = '0'  where aid = 1255358  and dename  = '115' and identityfield = 2212823476 and atid =51
--select       * from  currentbalanceaudit with(nolock)  where  aid   in (1255358) and  dename in ('115','200','114') order by businessday  desc

/*
select  top 1 srbwithinstallmentdue  , sbwithinstallmentdue , runningminimumdue , remainingminimumdue ,amountoftotaldue  ,amountoftotaldue ,   
  amtofpayxdlate  
, AmountOfPayment30DLate  ,  AmountOfPayment60DLate ,  
 AmountOfPayment90DLate ,     AmountOfPayment120DLate  ,
 AmountOfPayment150DLate ,    AmountOfPayment180DLate  ,  AmountOfPayment210DLate   ,DateOfOriginalPaymentDUeDTD  ,
      daysdelinquent  , nopaydaysdelinquent , DtOfLastDelinqCTD  from  bsegmentcreditcard  with(nolock)
select  top 1  systemstatus,amtofpaycurrdue,cycleduedtd   from  bsegment_primary   with(nolock)
select  top 1  systemstatus ,DateOfLastDelinquent,*  from  ccgs_rpt_coreauth..bsegment_primary   with(nolock)





Select AmtOfPayPastDue,amountoftotaldue,minimumpaymentdue,statementid ,acctid ,amtofpaycurrdue,amtofpayxdlate,systemstatus ,ccinhparent125aid ,currentbalance from  statementheader s  with(nolock) 
where  (amountoftotaldue < 0   or amtofpaycurrdue< 0   or  amtofpayxdlate <0 
or AmountOfPayment30DLate <  0  or  AmountOfPayment60DLate < 0  or
 AmountOfPayment90DLate < 0   or  AmountOfPayment120DLate  < 0 or
 AmountOfPayment150DLate < 0  or  AmountOfPayment180DLate  < 0  or AmountOfPayment210DLate < 0 )
and (statementdate = '2022-09-30 23:59:57'  and ccinhparent125aid = 16324 ) and currentbalance <=0 



Select AmtOfPayPastDue,amountoftotaldue,minimumpaymentdue,statementid ,acctid ,amtofpaycurrdue,amtofpayxdlate,systemstatus ,ccinhparent125aid ,currentbalance from  statementheader s  with(nolock) 
where  (amountoftotaldue > 0   or amtofpaycurrdue> 0   or  amtofpayxdlate >0 
or AmountOfPayment30DLate >  0  or  AmountOfPayment60DLate > 0  or
 AmountOfPayment90DLate > 0   or  AmountOfPayment120DLate  > 0 or
 AmountOfPayment150DLate > 0  or  AmountOfPayment180DLate  > 0  or AmountOfPayment210DLate > 0 )
and (statementdate = '2022-09-30 23:59:57'  and ccinhparent125aid = 16324 ) and currentbalance <=0 





Select amountoftotaldue,s.statementid ,s.acctid ,currentdue,amtofpayxdlate,systemstatus 
,ccinhparent125aid ,currentbalance from  summaryheader  s  with(nolock) 
join summaryheadercreditcard sh   on (s.acctid = sh.acctid  and  s.statementid = sh.statementid )
where  (amountoftotaldue > 0   or currentdue> 0   or  amtofpayxdlate >0 
or AmountOfPayment30DLate >  0  or  AmountOfPayment60DLate > 0  or
 AmountOfPayment90DLate > 0   or  AmountOfPayment120DLate  > 0 or
 AmountOfPayment150DLate > 0  or  AmountOfPayment180DLate  > 0  or AmountOfPayment210DLate > 0 )
 and  s.acctid   in 
 
 (13371,4275371,256318,20590875,34554099,34554100,348968,14385702,424949,2800025,591772,14249843,600501,4970734,33691424,671644,5220745,21924960,21934920,66215965,66810225,69368003,676720,22498564,853759,4097356,876524,10624640,885688,6283830,958151,6518020,1026121,16227625,1081685,41812990,45771389,1169992,67956207,1267778,44752305,45639852,45639853,1368698,8350272,52876922,52876923,1521063,41925982,41925983,67986893,1565888,6082060,1680182,69422623,1737940,13449029,53804903,53804904,1860302,68046873,1860785,16149698,23421774,23421775,1899419,16747123,1987914,54724678,2027962,16193523,2108734,21293965,2176395,61613036,2324033,44362104,46544824,2416776,5313455,2630467,67482381,2782841,9414524,3484803,48657111,6003809,23628362,7977564,19854507,8163537,42856837,43816481,8320339,40682869,66130235,10201143,47017217,66189031,10237255,58529326,68010598,10437393,46197516,10439088,40127439,60816471,10619390,16743110,22585788,44398146,25055228,32126811,31482883,34454826,31519229,58869951,33093229,36716598,36143442,69372832,36823394,53507300,39147947,66211583,45394384,51581150,50485171,66188739,51632458,54686019,53038626,53510162,54760825,66010225,54895556,65685449,55028908,65770422,56076733,62440812,56154899,68056720,57756838,59001092,61111576,68018732,63051200,66074302,63072458,64411749,67987107,65104680,66947094,65115561,67960856,66737167,67986235,67261798,68582748


,256318,20590875,34554099,34554100,600501,4970734,33691424,671644,5220745,21924960,21934920,66215965,66810225,69368003,1267778,44752305,45639852,45639853,1368698,8350272,52876922,52876923,1521063,41925982,41925983,67986893,1737940,13449029,53804903,53804904,1860785,16149698,23421774,23421775)


 and statementdate = '2022-09-30 23:59:57'
   and ccinhparent125aid = 16324 ) and currentbalance <=0 


*/