
select bsacctid,* From ls_proddrgsdb01.ccgs_coreissue.dbo.ccard_primary pr with(nolock) 
where tranid in (select tranid From ls_proddrgsdb01.ccgs_coreissue.dbo.purchasereversalrecord pr with(nolock) 
where parent02aid = 2298633)

select * From ls_proddrgsdb01.ccgs_coreissue.dbo.purchasereversalrecord pr with(nolock) 
where parent02aid = 2298633

select sum(transactionamount),cmttrantype,originaltranref,reversalflag 
From ls_proddrgsdb01.ccgs_coreissue.dbo.purchasereversalrecord pr with(nolock) 
where parent02aid = 2298633
group by cmttrantype,originaltranref,reversalflag 
order by originaltranref,reversalflag

select sum(transactionamount),tranref,reversalflag 
From ls_proddrgsdb01.ccgs_coreissue.dbo.purchasereversalrecord pr with(nolock) 
where parent02aid = 2298633 and originaltranref in (54453974818) --and tranref = 33635767783
group by tranref,reversalflag order by tranref

;WITH CTE
AS
(
select sum(transactionamount)*CASE WHEN reversalflag = 0 THEN 1 ELSE -1 END transactionamount,tranref,reversalflag 
From ls_proddrgsdb01.ccgs_coreissue.dbo.purchasereversalrecord pr with(nolock) 
where parent02aid = 2298633 and originaltranref in (54453974818) --and tranref = 33635767783
group by tranref,reversalflag --order by tranref
)
SELECT SUM(transactionamount), tranref
FROM CTE 
GROUP BY tranref
HAVING SUM(transactionamount) <> 0

select pr.* From ls_proddrgsdb01.ccgs_coreissue.dbo.purchasereversalrecord pr with(nolock) 
where parent02aid = 2298633 and originaltranref in (54453974818)  and tranref in (58326805998) 
order by pr.originaltranref,pr.tranref


select pr.* From ls_proddrgsdb01.ccgs_coreissue.dbo.purchasereversalrecord pr with(nolock) 
where parent02aid = 2298633 and originaltranref in (54453974818)  --and tranref in (55728679885) 
order by pr.originaltranref,pr.tranref

--INSERT INTO purchasereversalrecord (acctid,parent02aid,tranid,tranref,transactionamount,reversalflag,cmttrantype,tranorig,originaltranref,referencetranid) 
--VALUES
--(2345933,		2298633,	58326806008,	58326805998,	37.67,	'0',	'121',     	58327347663,	58327347663,		58326805997)

select transactionamount,cmttrantype,txnacctid,noblobindicator,transactiondescription,* From ccard_primary with(nolock) 
where tranid = 54453974818

select transactionamount,cmttrantype,txnacctid,noblobindicator,transactiondescription,* From ccard_primary with(nolock) 
where accountnumber in (select accountnumber from bsegment_primary with(nolock) where acctid = 2298633)
and tranref = 54453974818 and noblobindicator = '6'
order by posttime desc

-----------

select sum(transactionamount) as transactionamount,originaltranref,reversalflag into #r0
From ls_proddrgsdb01.ccgs_coreissue.dbo.purchasereversalrecord pr with(nolock) 
where parent02aid = 2298633 and reversalflag = 0 group by originaltranref,reversalflag 
order by originaltranref,reversalflag


select sum(transactionamount) as transactionamount,originaltranref,reversalflag into #r1
From ls_proddrgsdb01.ccgs_coreissue.dbo.purchasereversalrecord pr with(nolock) 
where parent02aid = 2298633 and reversalflag = 1 group by originaltranref,reversalflag 
order by originaltranref,reversalflag

select * From #r0 r0 with(nolock) 
join #r1 r1 with(nolock) on r0.originaltranref = r1.originaltranref
where r0.transactionamount <> r1.transactionamount

select * From #r0 r0 with(nolock) 
left join #r1 r1 with(nolock) on r0.originaltranref = r1.originaltranref
where r1.transactionamount is null

select * From #r0 r0 with(nolock) 
right join #r1 r1 with(nolock) on r0.originaltranref = r1.originaltranref
where r0.transactionamount is null

--

select sum(transactionamount) as transactionamount,tranref,originaltranref,reversalflag into #tr0
From ls_proddrgsdb01.ccgs_coreissue.dbo.purchasereversalrecord pr with(nolock) 
where parent02aid = 2298633 and reversalflag = 0 group by originaltranref,tranref,reversalflag 
order by originaltranref,reversalflag

select sum(transactionamount) as transactionamount,tranref,originaltranref,reversalflag into #tr1
From ls_proddrgsdb01.ccgs_coreissue.dbo.purchasereversalrecord pr with(nolock) 
where parent02aid = 2298633 and reversalflag = 1 group by originaltranref,tranref,reversalflag 
order by originaltranref,reversalflag

select * From #tr0 r0 with(nolock) 
join #tr1 r1 with(nolock) on r0.originaltranref = r1.originaltranref and r0.tranref = r1.tranref 
where r0.transactionamount <> r1.transactionamount order by r0.tranref

select * From #tr0 r0 with(nolock) 
left join #tr1 r1 with(nolock) on r0.originaltranref = r1.originaltranref and r0.tranref = r1.tranref 
where r1.originaltranref is null

select * From #tr0 r0 with(nolock) 
right join #tr1 r1 with(nolock) on r0.originaltranref = r1.originaltranref and r0.tranref = r1.tranref 
where r0.originaltranref is null



--2298633	7
--637027	2
--845437	1
--854249	1
--1956653	3
--2304563	1
--2589279	3
--2298633	5
--2813679	1
--2298633	14
--4531705	6
--9607467	1
--11404218	6
--11516314	2
--12960990	1
--2298633	6


select * From ls_proddrgsdb01.ccgs_coreissue.dbo.ccard_primary cp with(nolock) 
join ls_proddrgsdb01.ccgs_coreissue.dbo.purchasereversalrecord pr with(nolock) on pr.tranid = cp.tranid
where pr.parent02aid = 399463
--and cp.txnacctid <> pr.acctid
--and cp.transactionamount <> pr.transactionamount
--and cp.cmttrantype <> pr.cmttrantype