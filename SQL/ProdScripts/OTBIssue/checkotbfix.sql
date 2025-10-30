select  * from paymentholddetails with(nolock)  where  bsacctid =12300976 and posttime >'2023-12-07 02:34:00'  order by posttime  desc

DROP TABLE IF EXISTS #tranid1
select tranid into #tranid1 from CCArd_Primary (nolock)  where cmttrantype = '21' and txnsource IN ('26', '14')

SELECT COUNT(1) FROm #tranid1

DROP TABLE IF EXISTS #Payments
SELECT accountnumber, C.TranId, RevTgt, TranTime, PostTime, CMTTRanType, originalamount_, TxnSrcAmt 
INTO #Payments
from  ccard_primary c  (nolock) join  ccard_secondary cs (nolock)  on c.tranid  =cs.tranid 
where  c.tranid in (select tranid  from #tranid1 )  and (originalamount_ <= 0  or originalamount_ is null)

SELECT * FROM #Payments

DROP TABLE IF EXISTS #Rev
select  accountnumber, TranId, RevTgt, TranTime, PostTime
INTO #Rev 
from   ccard_primary c  (nolock)  where 
CMTTRanType IN ('22', '26') AND
revtgt in (
SELECT TranID FROM #Payments)

SELECT * FROM #Payments
SELECT * FROM #Rev

SELECT C1.accountnumber, C1.TranId, C1.RevTgt, C1.TranTime, C1.PostTime, CMTTRanType, originalamount_, TxnSrcAmt
INTO #ReversedPayments
FROM #Rev R
JOIN CCArd_Primary C1 (NOLOCK)  ON (R.RevTgt = C1.TranID)
JOIN CCard_Secondary C2 (NOLOCK) ON (C1.TranID = C2.TranID)

SELECT T1.AccountNumber, PaymentTranID, RevTgt, T2.PostTime PaymentTime, T1.PostTime RevTime, BSAcctID, HoldAmount, HPOTBTranId, HoldReleaseDate, Status, PymtHoldDays, CurrentBalance CBAtHold 
INTO #IssueAccounts
FROM #Rev T1
JOIN PaymentHoldDetails T2 WITH (NOLOCK) ON (T1.RevTgt = T2.PaymentTranID)
WHERE T1.PostTime < T2.HoldReleaseDate

DROP TABLE IF EXISTS #PendingOnBS_CI
SELECT T.*, BP.PendingOTB 
INTO #PendingOnBS_CI
FROM #IssueAccounts T
JOIN LS_P1MARPRODDB01.CCGS_CoreIssue.DBO.BSegment_primary BP WITH (NOLOCK) ON (T.BSAcctID = BP.acctID)


DROP TABLE IF EXISTS #PendingOnBS_CA
SELECT T.*, BP.PendingOTB 
INTO #PendingOnBS_CA
FROM #IssueAccounts T
JOIN CCGS_RPT_CoreAuth..BSegment_primary BP WITH (NOLOCK) ON (T.BSAcctID = BP.acctID)

DROP TABLE IF EXISTS #BS_CI
SELECT AccountNumber, BSacctID, SUM(HoldAmount) HoldAmount, SUM(PendingOTB) PendingOTB,
CASE WHEN SUM(PendingOTB) >= SUM(HoldAmount) THEN SUM(HoldAmount) ELSE SUM(PendingOTB) END AmountToRelease
INTO #BS_CI 
FROM #PendingOnBS_CI 
GROUP BY AccountNumber, BSacctID 
HAVING SUM(PendingOTB) > 0

DROP TABLE IF EXISTS #BS_CA
SELECT AccountNumber, BSacctID, SUM(HoldAmount) HoldAmount, SUM(PendingOTB) PendingOTB,
CASE WHEN SUM(PendingOTB) >= SUM(HoldAmount) THEN SUM(HoldAmount) ELSE SUM(PendingOTB) END AmountToRelease
INTO #BS_CA 
FROM #PendingOnBS_CA 
GROUP BY AccountNumber, BSacctID 
HAVING SUM(PendingOTB) > 0


SELECT *,
'UPDATE TOP(1) BSegment_Primary SET PendingOTB = PendingOTB - ' + TRY_CAST(AmountToRelease AS VARCHAR) + ' WHERE acctID = ' + TRY_CAST(BSacctID AS VARCHAR) DATA
FROM #BS_CI

SELECT *,
'UPDATE TOP(1) BSegment_Primary SET PendingOTB = PendingOTB - ' + TRY_CAST(AmountToRelease AS VARCHAR) + ' WHERE acctID = ' + TRY_CAST(BSacctID AS VARCHAR) DATA
FROM #BS_CA


/*


SELECT COUNT(1) FROM #tranid1


select revtgt,accountnumber,bsacctid,transactionamount,originalamount_,batchacctid, rejectbatchacctid, * 
from  ccard_primary c  (nolock) join  ccard_secondary cs (nolock)  on c.tranid  =cs.tranid 
 where  c.tranid in (select tranid  from #tranid1 )  and (originalamount_ <= 0  or originalamount_ is null)

order by posttime desc

DROP TABLE IF EXISTS #Rev
select  accountnumber, TranId, RevTgt, TranTime, PostTime
INTO #Rev 
from   ccard_primary c  (nolock)  where revtgt in (
select c.tranid from  ccard_primary c  (nolock) join  ccard_secondary cs (nolock)  on c.tranid  =cs.tranid 
 where  c.tranid in (select tranid  from #tranid1 )  and (originalamount_ <= 0  or originalamount_ is null))
 order by posttime desc









 SELECT * FROM #ReversedPayments

 SELECT * 
 FROM #ReversedPayments T1
 JOIN PaymentHoldDetails T2 WITH (NOLOCK) ON (T1.TranID = T2.PaymentTranID)

 


SELECT * FROM #IssueAccounts WHERE BSacctID = 1888562

SELECT RejectBatchAcctId, BatchAcctID,* FROM CCard_Primary WITH (NOLOCK) WHERE TranID = 102007754044

SELECT BatchDescription, * FROM BatchAccounts WHERE acctID = 3791090


--PaymentTranID	RevTgt
--102007752863	102007752863


SELECT BatchAcctid, RejectBatchAcctID, TransactionDescription, * FROM CCard_Primary WITH (NOLOCK) WHERE AccountNumber = '1100011100903289' AND TranID IN (102007752863, 102007752863) ORDER BY PostTime DESC

SELECT BatchDescription,* FROM BatchAccounts WITH (NOLOCK) WHERE acctID = 3784450

SELECT BatchAcctid, RejectBatchAcctID, TransactionDescription, OriginalAmount_, TxnSrcAmt, * 
FROM CCard_Primary C WITH (NOLOCK)
JOIN CCard_Secondary S WITH (NOLOCK) ON (C.TranID = S.TranID)
WHERE AccountNumber = '1100011100903289' 
ORDER BY PostTime DESC



SELECT B1.acctID, B1.AccountNumber, B1.PendingOTB PendingOTB_CI, B2.PendingOTB PendingOTB_CA
INTO #TempMismatchOTB
FROM BSegment_Primary B1 WITH (NOLOCK)
JOIN CCGS_RPT_CoreAuth..BSegment_Primary B2 WITH (NOLOCK) ON (B1.acctID = B2.acctID)
WHERE B1.PendingOTB <> B2.PendingOTB

SELECT * FROM #TempMismatchOTB

DROP TABLE IF EXISTS #temp2
select sum(isnull(p.holdamount,0.00)) holdamount , p.accountnumber 
into #Temp2 from paymentholddetails p with(nolock) 
join #TempMismatchOTB t on t.accountnumber = p.accountnumber 
--where p.holdreleasedate > '2023-11-27 23:59:57' 
group by p.accountnumber 

SELECT *
FROM #temp2 T1
JOIN #TempMismatchOTB T2 ON (T1.AccountNumber = T2.AccountNumber)

UPDATE TOP(1) BSegment_Primary SET PendingOTB = PendingOTB - 30 WHERE AccountNumber = '1100011116969191'
UPDATE TOP(1) BSegment_Primary SET PendingOTB = PendingOTB - 50 WHERE AccountNumber = '1100011136309923'
UPDATE TOP(1) BSegment_Primary SET PendingOTB = PendingOTB - 4494.94 WHERE AccountNumber = '1100011148072881'

*/