select count(distinct accountuuid)  from  ##CBRPHPUpdate_COOKIE_321478 with(nolock) --22

select distinct accountuuid into #dis  from  ##CBRPHPUpdate_COOKIE_321478 with(nolock) --22

select cbrindicator,bp.UniversalUniqueid,bp.AccountNumber,bp.acctid from bsegment_Primary bp with(nolock ) 
join #dis  CBR on BP.UniversalUniqueid = CBR.AccountUUID
JOIn BSCBRIndicatorDetail bs with(nolock) on bs.acctid = bp.acctid --14

select cbrindicator,count(1) from bsegment_Primary bp with(nolock ) 
join #dis  CBR on BP.UniversalUniqueid = CBR.AccountUUID
JOIn BSCBRIndicatorDetail bs with(nolock) on bs.acctid = bp.acctid 
group by cbrindicator
--1 	14

------------------
drop table #cbr
select cbrindicator,bp.UniversalUniqueid,bp.AccountNumber,bp.acctid , bp.ccinhparent125aid ManualStateus,bp.systemstatus SysStatus
into #cbr
from bsegment_Primary bp with(nolock ) 
join #dis  CBR on BP.UniversalUniqueid = CBR.AccountUUID
JOIn BSCBRIndicatorDetail bs with(nolock) on bs.acctid = bp.acctid --14

 ;with cte
 as
 (
 select row_number() over (partition by cbr.acctid order by cbr.skey desc) RN,ManualStateus,SysStatus,cbr.*
 from CBReportingDetail cbr with(nolock) 
 join #cbr c with(nolock) on c.acctid = cbr.acctid
 where cbr.processedstatus = 1
 )
select * into #final from cte where rn = 1

select 
case when (f.accountstatus IN('13', '64','DA','DF') or f.ecoacode = 'X' or consumerinfoindicator IN ('E','F','G','H') or SpecialComment = 'DE') THEN 'FINAL REPORTED' WHEN c.cbrindicator = 2 THEN 'CBRI2' 
ELSE 'Reporting Normally' END CBRReporting,c.cbrindicator,
c.UniversalUniqueid,f.accountnumber,f.acctid,statementdate,accountstatus,ecoacode,ecoacode_j2,consumerinfoindicator,consumerinformationindicator_j2,paymenthistprofile,
specialcomment,processedstatus,f.ManualStateus,f.SysStatus
From #final f with(nolock) 
join  #cbr c with(nolock) on c.acctid = f.acctid
--where c.UniversalUniqueid = '3ae77b7d-0cea-4c67-a879-ce60e6fc274c'
order by f.statementdate desc

/* Impacted bits are already E
18519280,1100011185042839   
4269593, 1100011134727480   
16416897 ,1100011170710457  
 	
--MFJDNOSAJJMAMFJDNOSAJJMA

select c.accountuuid ,c.statementdate,* from  ##CBRPHPUpdate_COOKIE_321478 c  with(nolock) 
join #cbr d with(nolock) on d.UniversalUniqueid = c.accountuuid 
order by c.accountuuid
--22