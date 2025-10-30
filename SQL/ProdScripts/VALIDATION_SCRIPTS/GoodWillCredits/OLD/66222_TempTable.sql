-- Script will take around 10 minutes irrespective of number of records. So execute this on the replication server.
DROP TABLE IF EXISTS #cp
GO
select bp.acctid,bp.accountnumber,bp.universaluniqueid,cp.tranid,cp.trantime,cp.posttime,cp.cmttrantype,cp.transactionamount,ap.transactionuuid, CP.transactionlifecycleuniqueid, CP.RevTGT
into #cp
from bsegment_primary bp with(nolock) join
ccard_primary cp with(nolock) on cp.accountnumber = bp.accountnumber join
auth_primary ap with(nolock) on ap.accountnumber = cp.accountnumber and ap.TransactionLifeCycleUniqueID = cp.TransactionLifeCycleUniqueID
where 
cp.cmttrantype IN ('40', '43')
--and ap.cmttrantype = '93'
and ap.transactionuuid in
(
'586e23b6-80f8-4f50-8ad7-938099fc01cc',
'60580359-51a9-4383-adad-b4be5585f529',
'64ab57b1-d6d1-4327-b0bd-19cb1fcca880',
'a148deca-3d64-4f12-bf94-0a3351f81d66'
)


DROP TABLE IF EXISTS #cp1
GO
select bp.acctid,bp.accountnumber,bp.universaluniqueid,cp.tranid,cp.trantime,cp.posttime,cp.cmttrantype,cp.transactionamount,cp.UniversalUniqueID transactionuuid, CP.transactionlifecycleuniqueid, CP.RevTGT
into #cp1
from bsegment_primary bp with(nolock) join
ccard_primary cp with(nolock) on cp.accountnumber = bp.accountnumber 
where 
cp.cmttrantype IN ('40', '43')
AND CP.UniversalUniqueID IN 
('bac88a71-79e1-4d74-ad09-924e4bd8357b', 'f2146358-0caf-4be6-bff1-ef60a97b9181')






/*

DROP TABLE IF EXISTS ##TempData
SELECT * INTO ##TempData FROM #cp

DROP TABLE IF EXISTS ##TempDataAccount
SELECT * INTO ##TempDataAccount FROM #cpAccount

DROP TABLE IF EXISTS ##TempDataAuth
SELECT * INTO ##TempDataAuth FROM #AP

*/
/*

-- Script will take around 10 minutes irrespective of number of records. So execute this on the replication server.
DROP TABLE IF EXISTS #cp
GO
select bp.acctid,bp.accountnumber,bp.universaluniqueid,cp.tranid,cp.trantime,cp.posttime,cp.cmttrantype,cp.transactionamount,ap.transactionuuid, CP.transactionlifecycleuniqueid, CP.RevTGT
into #cp
from bsegment_primary bp with(nolock) join
ccard_primary cp with(nolock) on cp.accountnumber = bp.accountnumber join
auth_primary ap with(nolock) on ap.accountnumber = cp.accountnumber and ap.TransactionLifeCycleUniqueID = cp.TransactionLifeCycleUniqueID
JOIN ##TempRecords TT ON (TT.TransactionUUID = AP.TransactionUUID)
where 
cp.cmttrantype IN ('40', '43')
--and ap.cmttrantype = '93'


DROP TABLE IF EXISTS #cp
GO
select bp.acctid,bp.accountnumber,bp.universaluniqueid,cp.tranid,cp.trantime,cp.posttime,cp.cmttrantype,cp.transactionamount,ap.transactionuuid, CP.transactionlifecycleuniqueid, CP.RevTGT
into #cp
from bsegment_primary bp with(nolock) join
ccard_primary cp with(nolock) on cp.accountnumber = bp.accountnumber join
auth_primary ap with(nolock) on ap.accountnumber = cp.accountnumber and ap.TransactionLifeCycleUniqueID = cp.TransactionLifeCycleUniqueID
JOIN ##TempRecords TT ON (TT.transactionlifecycleuniqueid = AP.transactionlifecycleuniqueid)
where 
cp.cmttrantype IN ('40', '43')
--and ap.cmttrantype = '93'



DROP TABLE IF EXISTS #cp
GO
select bp.acctid,bp.accountnumber,bp.universaluniqueid,cp.tranid,cp.trantime,cp.posttime,cp.cmttrantype,cp.transactionamount,Cp.transactionlifecycleuuid transactionuuid, CP.transactionlifecycleuniqueid, CP.RevTGT
into #cp
from bsegment_primary bp with(nolock) join
ccard_primary cp with(nolock) on cp.accountnumber = bp.accountnumber 
JOIN ##TempRecords TT ON (TT.transactionlifecycleuniqueid = CP.transactionlifecycleuniqueid)
where 
cp.cmttrantype IN ('40', '43')
--and ap.cmttrantype = '93'




DROP TABLE IF EXISTS #cpAccount
GO
select bp.acctid,bp.accountnumber,bp.universaluniqueid,cp.tranid,cp.trantime,cp.posttime,cp.cmttrantype,cp.transactionamount,ap.transactionuuid, CP.transactionlifecycleuniqueid, CP.RevTGT
into #cpAccount
from bsegment_primary bp with(nolock) 
JOIN ##TempRecords TT ON (TT.AccountUUID = BP.UniversalUniqueID) join
ccard_primary cp with(nolock) on cp.accountnumber = bp.accountnumber join
auth_primary ap with(nolock) on ap.accountnumber = cp.accountnumber and ap.TransactionLifeCycleUniqueID = cp.TransactionLifeCycleUniqueID
where 
cp.cmttrantype IN ('40', '43')
--and ap.cmttrantype = '93'


DROP TABLE IF EXISTS #AP
GO
SELECT bp.acctid,bp.accountnumber,bp.universaluniqueid, ap.TransactionLifeCycleUniqueID, ap.transactionuuid, ap.MessageTypeIdentifier, ap.Transactionamount, ap.AuthStatus, EffectiveDate_ForAgeOff
into #AP
from bsegment_primary bp with(nolock) 
join auth_primary ap with(nolock) on ap.accountnumber = bp.accountnumber
JOIN ##TempRecords TT ON (TT.AccountUUID = BP.UniversalUniqueID) 



DROP TABLE IF EXISTS #cp_Auth
GO
select bp.acctid,bp.accountnumber,bp.universaluniqueid,cp.tranid,cp.trantime,cp.posttime,cp.cmttrantype,cp.transactionamount,ap.transactionuuid, CP.transactionlifecycleuniqueid, CP.RevTGT
into #cp_Auth
from bsegment_primary bp with(nolock) join
ccard_primary cp with(nolock) on cp.accountnumber = bp.accountnumber join
auth_primary ap with(nolock) on ap.accountnumber = cp.accountnumber and ap.TransactionLifeCycleUniqueID = cp.TransactionLifeCycleUniqueID
JOIN ##TempRecords TT ON (TT.transactionuuid = AP.transactionuuid)
where 
cp.cmttrantype IN ('40', '43')
--and ap.cmttrantype = '93'

DROP TABLE IF EXISTS #cp1
GO
select bp.acctid,bp.accountnumber,bp.universaluniqueid,cp.tranid,cp.trantime,cp.posttime,cp.cmttrantype,cp.transactionamount,cp.UniversalUniqueID transactionuuid, CP.transactionlifecycleuniqueid, CP.RevTGT
into #cp1
from bsegment_primary bp with(nolock) join
ccard_primary cp with(nolock) on cp.accountnumber = bp.accountnumber 
JOIN ##TempRecords TT ON (TT.transactionuuid = CP.UniversalUniqueID)
where 
cp.cmttrantype IN ('40', '43')


SELECT * FROM #CP_Auth UNION ALL 
SELECT * FROM #CP1

DROP TABLE IF EXISTS ##TempData
SELECT * INTO ##TempData FROM #CP_Auth

INSERT INTO ##TempData
SELECT * FROM #CP1


SELECT * FROM CCard_Primary WITH (NOLOCK) WHERE UniversalUniqueID = '4efdc6dc-5295-43f6-86db-f6eede8ad51c'
--16fa4d08-8744-41b1-a207-adef597700de

SELECT * FROM #CP_Auth WHERE transactionuuid = '16fa4d08-8744-41b1-a207-adef597700de'
SELECT * FROM ##tempRecords WHERE transactionuuid = '16fa4d08-8744-41b1-a207-adef597700de'




*/