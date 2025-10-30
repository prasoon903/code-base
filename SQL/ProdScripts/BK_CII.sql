
DROP TABLE IF EXISTS #bk
select bp.acctid,bp.accountnumber,bp.universaluniqueid,bs.clientid,rtrim(ltrim(cc.lutdescription)) StatusDescription,
bp.ccinhparent125aid,bp.systemstatus,ad.ConsumerInfoIndicator,
ad.customerid,ad.addresstype,c.customertype
into #bk
from bsegment_primary bp with(nolock) 
join bsegment_secondary bs with(nolock) on bs.acctid = bp.acctid
join address ad with(nolock) on ad.parent02aid = bp.acctid and ad.customerid = bp.customerid
join customer c with(nolock) on c.customerid = ad.customerid
join ccardlookup cc with(nolock) on cc.lutcode = bp.ccinhparent125aid
where bp.ccinhparent125aid in (5202) 
--where bp.ccinhparent125aid in (5202,16010) 
--and ad.ConsumerInfoIndicator is not null
and ad.ConsumerInfoIndicator IN ('E','F','G','H')
and cc.lutid = 'asstplan'
order by bp.acctid

--to set 16010

SELECT * FROM #bk

SELECT RTRIM(AccountNumber) AccountNumber, 16010 Status FROM #bk