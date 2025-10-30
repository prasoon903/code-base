use ccgs_RPT_Coreissue


select universaluniqueid, Accountnumber,bp.acctid,chargeoffdateparam,chargeoffdate,currentbalance,cycledueDTD,systemstatus,ccinhparent125aid,billingcycle,accountopendate
from Bsegment_primary bp with(nolock)
JOIN Bsegmentcreditcard bc with(nolock) on(bp.acctid = bc.acctid)
where universaluniqueid in (
'38b51ae2-76e0-40d8-8b87-85d1f18032e4',
'11703f7c-66df-45b7-855c-8da2dfdbb30d',
'04f892a3-8f62-4230-ace9-5bb7c406860c',
'cbb3566f-4269-46b8-8ee5-226e81597cb8',
'ee392298-07ea-4210-9f13-4aafd267b39a',
'23ee8271-9355-4f28-a702-12f5e8df1d8f',
'bacc527c-156c-4919-a674-482421d7e704',
'fb2f9807-02d9-4881-b507-8713ae49ca5d',
'f6e74be6-45dd-48da-851e-8523ec4617b4',
'33e18a60-619d-4084-a850-8aeaece48c14',
'7343bab7-53d6-4366-a53e-580d1a0a1ee7',
'20b59068-5b40-45f2-8b97-f907c995d5d5',
'0963b3f1-8817-413f-b2be-f9fa41d6c4e5',
'63340dd1-192b-49f2-8c9c-18b49dadefa7',
'69185896-e0d4-4f74-a785-a58b163b1f88',
'fca762e2-d668-44f4-b114-0d1dd539afa2')

/*
04f892a3-8f62-4230-ace9-5bb7c406860c	1100011111070490   	1111006
0963b3f1-8817-413f-b2be-f9fa41d6c4e5	1100011120125095   	2020271
11703f7c-66df-45b7-855c-8da2dfdbb30d	1100011121552404   	2160822
20b59068-5b40-45f2-8b97-f907c995d5d5	1100011120762350   	2083547
23ee8271-9355-4f28-a702-12f5e8df1d8f	1100011121052736   	2112125
33e18a60-619d-4084-a850-8aeaece48c14	1100011115638102   	1567427
38b51ae2-76e0-40d8-8b87-85d1f18032e4	1100011148728870   	11311371
63340dd1-192b-49f2-8c9c-18b49dadefa7	1100011107433074   	747434
69185896-e0d4-4f74-a785-a58b163b1f88	1100011122895216   	2294363
7343bab7-53d6-4366-a53e-580d1a0a1ee7	1100011123515052   	2351087
bacc527c-156c-4919-a674-482421d7e704	1100011119414245   	1948016
cbb3566f-4269-46b8-8ee5-226e81597cb8	1100011106440260   	648153
ee392298-07ea-4210-9f13-4aafd267b39a	1100011106364882   	640615
f6e74be6-45dd-48da-851e-8523ec4617b4	1100011115605762   	1564193
fb2f9807-02d9-4881-b507-8713ae49ca5d	1100011107748448   	778971
fca762e2-d668-44f4-b114-0d1dd539afa2	1100011103605618   	364738
*/



select chargeoffdateparam,chargeoffdate,cycleduedtd,systemstatus,ccinhparent125aid,currentbalance,*
from Accountinfoforreport with(nolock)
--where accountnumber = '1100011120125095'
WHERE BSAcctID = 648153
order by businessday desc

select chargeoffdateparam,chargeoffdate,cycleduedtd,systemstatus,ccinhparent125aid,currentbalance,*
from Accountinfoforreport_switchout with(nolock)
--where accountnumber = '1100011120125095'
WHERE BSAcctID = 648153
AND businessday = '2019-09-09 23:59:57.000'
order by businessday desc


select chargeoffdateparam,chargeoffdate,cycleduedtd,systemstatus,ccinhparent125aid,currentbalance,*
from Accountinfoforreport_NCPartitioned with(nolock)
--where accountnumber = '1100011120125095'
WHERE BSAcctID = 648153
AND businessday = '2019-09-09 23:59:57.000'
order by businessday desc



--16022			ID-Theft Fraud

SELECT StatusDescription, COReasonCode, Priority, *
FROM AStatusAccounts WITH (NOLOCK)
WHERE parent01AID IN (16022,16018,16014,16028,16100,16312)
AND MerchantAID = 14992


SELECT StatusDescription, COReasonCode, Priority, *
FROM AStatusAccountsVirtual WITH (NOLOCK)
WHERE parent01AID IN (16022,16018,16014,16028,16100,16312)
AND MerchantAID = 14992

SELECT * FROM sys.tables where name like '%ccard%'



select creditplanmaster,feesacctid,cpmgroup,cp.transactionamount,cp.transactiondescription,cp.posttime,cp.trantime,cp.tranid,bsacctid,cp.*
from Ccard_Primary_PruneData cp with(nolock)
--LEFT JOIN ccard_secondary cs with(nolock) on(cp.tranid = cs.tranid)
where accountnumber = '1100011121052736'
and cmttrantype in ('*SCR','RCL','RCLS','51','52','54')
order by cp.posttime desc

SELECT * FROM CurrentBalanceAudit WITH (NOLOCK) WHERE AID = 2112125 AND DENAME = 114 ORDER BY IdentityField DESC

SELECT * FROM BSegment_MStatuses WITH (NOLOCK) WHERE acctID = 2112125 ORDER BY Skey DESC


select creditplanmaster,feesacctid,cpmgroup,cp.transactionamount,cp.transactiondescription,cp.posttime,cp.trantime,cp.tranid,bsacctid,cp.*
from LS_P1MARProddb01.CCGS_CoreIssue.DBO.ccard_primary cp with(nolock)
--LEFT JOIN ccard_secondary cs with(nolock) on(cp.tranid = cs.tranid)
where accountnumber = '1100011121052736'
and cmttrantype in ('*SCR','RCL','RCLS','51','52','54')
order by cp.posttime desc


select universaluniqueid,Accountnumber,bp.acctid,chargeoffdateparam,chargeoffdate,currentbalance,cycledueDTD,systemstatus,ccinhparent125aid,systemchargeoffstatus,userchargeoffstatus,billingcycle,accountopendate,daysdelinquent,daysdelinquentnew,*
from Bsegment_primary bp with(nolock)
JOIN Bsegmentcreditcard bc with(nolock) on(bp.acctid = bc.acctid)
where bp. acctid = 364738



select requesttype,loginuser,ipaddress,* 
from nonmonetarylog with(nolock)
where accountnumber = '1100011106440260 '
--and requesttype in ('113474,113473')
order by skey desc



select * 
from TCIVRRequest T with(nolock)
where Accountnumber = '1100011121052736'
and (requestname in ('113474') or requestname in ('113473'))
--and requestdate = '2019-09-21 00:15:40.000'
order by skey desc

select requesttype,loginuser,ipaddress,* 
from nonmonetarylog with(nolock)
where accountnumber = '1100011121052736'
--and requesttype in ('113474,113473')
--and (requesttype in ('113474') or requesttype in ('113473'))
order by skey desc

select * 
from Attributeupdatelog with(nolock)
where accountnumber = '1100011121052736'





