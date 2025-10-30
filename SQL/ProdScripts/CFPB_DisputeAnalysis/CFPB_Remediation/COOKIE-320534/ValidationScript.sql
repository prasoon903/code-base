select count(distinct accountuuid)  from  ##CBRTradelineDelete_COOKIE_320534 with(nolock) --289

select cbrindicator,bp.UniversalUniqueid,bp.AccountNumber,bp.acctid from bsegment_Primary bp with(nolock ) 
join ##CBRTradelineDelete_COOKIE_320534  CBR on BP.UniversalUniqueid = CBR.AccountUUID
JOIn BSCBRIndicatorDetail bs with(nolock) on bs.acctid = bp.acctid --257

select cbrindicator,count(1) from bsegment_Primary bp with(nolock ) 
join ##CBRTradelineDelete_COOKIE_320534  CBR on BP.UniversalUniqueid = CBR.AccountUUID
JOIn BSCBRIndicatorDetail bs with(nolock) on bs.acctid = bp.acctid 
group by cbrindicator
--1 	250
--2 	7



select cbrindicator,bp.UniversalUniqueid,bp.AccountNumber,bp.acctid 
into #cbr
from bsegment_Primary bp with(nolock ) 
join ##CBRTradelineDelete_COOKIE_320534  CBR on BP.UniversalUniqueid = CBR.AccountUUID
JOIn BSCBRIndicatorDetail bs with(nolock) on bs.acctid = bp.acctid --257
--where bp.systemstatus <> 14

DROP TABLE IF EXISTS #final
 ;with cte
 as
 (
 select row_number() over (partition by cbr.acctid order by cbr.skey desc) RN,cbr.*
 from CBReportingDetail cbr with(nolock) 
 join #cbr c with(nolock) on c.acctid = cbr.acctid
 where cbr.processedstatus = 1
 )
select * into #final from cte where rn = 1

DROP TABLE IF EXISTS #Temp
select 
case when (f.accountstatus = 64 or f.ecoacode = 'X' or consumerinfoindicator IN ('E','F','G','H') or SpecialComment = 'DE') THEN 'FINAL REPORTED' WHEN c.cbrindicator = 2 THEN 'CBRI2' 
ELSE 'Reporting Normally' END CBRReporting,c.cbrindicator,
c.UniversalUniqueid,f.accountnumber,f.acctid,statementdate,accountstatus,ecoacode,ecoacode_j2,consumerinfoindicator,consumerinformationindicator_j2,paymenthistprofile,
specialcomment,processedstatus,systemstatus,ccinhparent125aid
INTO #Temp
From #final f with(nolock) 
join  #cbr c with(nolock) on c.acctid = f.acctid
--order by f.statementdate desc

--SELECT CBRReporting, COUNT(1) FROM #Temp GROUP BY CBRReporting

select accountstatus,count(1)
From #final f with(nolock) 
group by accountstatus
order by f.statementdate desc

 select * from cbrremediation with(nolock) where acctid = 4000564

 select * From nonmonetarylog with(nolock) where accountnumber = '1100011133147920' order by requestdatetime desc



 /*
4000564
4958082
1053168
431585
1083875
1224303
12286707
 */