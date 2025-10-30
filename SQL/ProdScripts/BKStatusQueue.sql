SELECT acctID, AccountNumber, UniversalUniqueID AccountUUID, ccinhParent125AID, SystemStatus
INTO #TempAccounts
FROM BSegment_Primary WITH (NOLOCK)
WHERE BillingCycle = '31'
AND ccinhParent125AID = '16010'

DROP TABLE IF EXISTS #TempAccountsQueue
SELECT T1.*, BM.MStatusCode StatusInQueue, StartDate, UserID
INTO #TempAccountsQueue
FROM #TempAccounts T1
JOIN BSegment_MStatuses BM WITH (NOLOCK) ON (T1.acctId = BM.acctID)
WHERE MStatusCode = '5202'
AND IsDeleted = '0'


DROP TABLE IF EXISTS #bk
select BP.*,ad.ConsumerInfoIndicator,
C.ClientID CustomerID,ad.addresstype,c.customertype
into #bk
from #TempAccountsQueue bp with(nolock)
join address ad with(nolock) on ad.parent02aid = bp.acctid-- and ad.customerid = bp.customerid
join customer c with(nolock) on c.customerid = ad.customerid
join ccardlookup cc with(nolock) on cc.lutcode = bp.ccinhparent125aid
where cc.lutid = 'asstplan'
order by bp.acctid

--to set 16010

SELECT * FROM #bk WHERE ConsumerInfoIndicator IS NOT NULL ORDER BY AcctID

--10251

SELECT * FROM #TempAccountsQueue 
WHERE SystemStatus <> 14
--WHERE acctID = 10798

SELECT ccinhParent125AID, SystemStatus,* FROM BSegment_Primary WHERE acctID = 10798
SELECT * FROM BSegment_MStatuses WHERE acctID = 10798