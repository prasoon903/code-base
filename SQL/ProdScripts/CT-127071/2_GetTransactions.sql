
DROP TABLE IF EXISTS #cp_Auth
GO
select bp.acctid,bp.accountnumber,bp.universaluniqueid,cp.tranid,cp.trantime,cp.posttime,cp.cmttrantype,cp.transactionamount,ap.transactionuuid, CP.transactionlifecycleuniqueid, CP.RevTGT, CP.CaseID
into #cp_Auth
from bsegment_primary bp with(nolock) join
ccard_primary cp with(nolock) on cp.accountnumber = bp.accountnumber join
auth_primary ap with(nolock) on ap.accountnumber = cp.accountnumber and ap.TransactionLifeCycleUniqueID = cp.TransactionLifeCycleUniqueID
JOIN ##TempDisputes TT ON (TT.transactionuuid = AP.transactionuuid)
where 
cp.cmttrantype IN ('40', '43')
--and ap.cmttrantype = '93'



DROP TABLE IF EXISTS #cp1
GO
select bp.acctid,bp.accountnumber,bp.universaluniqueid,cp.tranid,cp.trantime,cp.posttime,cp.cmttrantype,cp.transactionamount,cp.UniversalUniqueID transactionuuid, 
CP.transactionlifecycleuniqueid, CP.RevTGT, CP.CaseID
into #cp1
from bsegment_primary bp with(nolock) join
ccard_primary cp with(nolock) on cp.accountnumber = bp.accountnumber 
JOIN ##TempDisputes TT ON (TT.transactionuuid = CP.UniversalUniqueID)
where 
cp.cmttrantype IN ('40', '43')


SELECT * FROM #CP_Auth UNION ALL 
SELECT * FROM #CP1

DROP TABLE IF EXISTS ##TempDataDisputes
SELECT * INTO ##TempDataDisputes FROM #CP_Auth

INSERT INTO ##TempDataDisputes
SELECT * FROM #CP1

--SELECT * INTO CP_Auth FROM #CP_Auth

--INSERT INTO CP_Auth
--SELECT * FROM #CP1

SELECT * FROM ##TempDataDisputes

SELECT * INTO ##TempDataDisputes FROM CP_Auth


SELECT * FROM #CP_Auth WITH (NOLOCK) WHERE TransactionUUID IN ('5c449531-4bae-471f-96bb-341ad153ada0')
SELECT * FROM #CP1 WITH (NOLOCK) WHERE TransactionUUID IN ('5c449531-4bae-471f-96bb-341ad153ada0')

SELECT * FROM ##TempDisputes WITH (NOLOCK) WHERE TransactionUUID IN ('5c449531-4bae-471f-96bb-341ad153ada0')



select bp.acctid,bp.accountnumber,bp.universaluniqueid,cp.tranid,cp.trantime,cp.posttime,cp.cmttrantype,cp.transactionamount,ap.transactionuuid, CP.transactionlifecycleuniqueid, CP.RevTGT, CP.CaseID
--into #cp_Auth
from bsegment_primary bp with(nolock) join
ccard_primary cp with(nolock) on cp.accountnumber = bp.accountnumber join
auth_primary ap with(nolock) on ap.accountnumber = cp.accountnumber and ap.TransactionLifeCycleUniqueID = cp.TransactionLifeCycleUniqueID
where CP.transactionlifecycleuniqueid = 9301525 and 
cp.cmttrantype IN ('40', '43')
--and ap.cmttrantype = '93'





