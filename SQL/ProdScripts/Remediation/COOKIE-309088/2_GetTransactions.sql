
DROP TABLE IF EXISTS #cp_Auth
GO
select bp.acctid,bp.accountnumber,bp.universaluniqueid,cp.tranid,ap.clientid,cp.trantime,cp.posttime,cp.cmttrantype,cp.transactionamount,ap.transactionuuid, CP.transactionlifecycleuniqueid, CP.RevTGT,
 CP.CaseID,tt.disputeid
into #cp_Auth
from bsegment_primary bp with(nolock) join
ccard_primary cp with(nolock) on cp.accountnumber = bp.accountnumber join
auth_primary ap with(nolock) on ap.accountnumber = cp.accountnumber and ap.TransactionLifeCycleUniqueID = cp.TransactionLifeCycleUniqueID
JOIN ##TempDCA TT ON (TT.TransactionID = AP.transactionuuid)
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
JOIN ##TempDCA TT ON (TT.TransactionID = CP.UniversalUniqueID)
where 
cp.cmttrantype IN ('40', '43')


SELECT * FROM #CP_Auth UNION ALL 
SELECT * FROM #CP1

DROP TABLE IF EXISTS ##TempData
SELECT * INTO ##TempData FROM #CP_Auth

INSERT INTO ##TempData
SELECT * FROM #CP1

--SELECT * INTO CP_Auth FROM #CP_Auth

--INSERT INTO CP_Auth
--SELECT * FROM #CP1

select top 1 Clientid Client_ID,TranId Tran_ID,universaluniqueid Account_UUID,TransactionUUID Txn_UUId,TransactionLifeCycleUniqueID
from ##TempData t
Join bsegment_secondary bs with(nolock)  on t.acctid = bs.acctid

SELECT * from #cp_auth 


SELECT * FROM #CP_Auth WITH (NOLOCK) WHERE TransactionUUID IN ('6091ce62-943b-4130-84de-69540c414927')
SELECT * FROM #CP1 WITH (NOLOCK) WHERE TransactionUUID IN ('6091ce62-943b-4130-84de-69540c414927')

SELECT universaluniqueid Account_ID,Transactionuuid Transaction_ID,Accountnumber,Clientid Client_ID FROM #CP_Auth
Account_ID,Transaction_ID,Accountnumber,Client_ID




