SELECT *
FROM  #TempData

--UPDATE T1
--SET AccountNumber = BP.AccountNumber
--FROM #TempData T1
--JOIn BSegment_Primary BP WITH (NOLOCK) ON (T1.AccountUUID = BP.UniversalUniqueID)


SELECT DISTINCT BSAcctid, UniversalUniqueID, CP.ARTxnType, CP.TxnSource, RTRIM(CP.CMTTRANTYPE) AS CMTTRANTYPE, CP.TransactionDescription,CP.TxnAcctId, CP.creditplanmaster, CPM.CPMDescription,
CP.TransactionAmount,CP.TranId,CP.TranRef,CP.tranorig,CP.TransmissionDateTime,CP.atid,Trantime,CP.PostTime,
CP.MemoIndicator,CP.RevTgt--, CP.TransactionLifeCycleUniqueID
FROM CCArd_Primary CP WITH (NOLOCK)
LEFT JOIN CPMAccounts CPM WITH (NOLOCK) ON (CP.CreditPlanMaster = CPM.acctId)
JOIN #TempData T1 ON (CP.AccountNumber = T1.AccountNumber AND CP.TransactionAmount = T1.TransactionAmount /*AND CP.TransactionUUID = T1.TransactionUUID*/)
WHERE CP.CMTTRanType = '110'


SELECT RTRIM(CP.AccountNumber) AccountNumber, AccountUUID, RTRIM(CP.CMTTRANTYPE) AS CMTTRANTYPE, RMATranUUID, TranID,
CP.CreditPlanMaster, RTRIM(CPM.CPMDescription) CPMDescription, CP.TransactionAmount, TranTime TransactionTime
FROM CCArd_Primary CP WITH (NOLOCK)
LEFT JOIN CPMAccounts CPM WITH (NOLOCK) ON (CP.CreditPlanMaster = CPM.acctId)
JOIN #TempData T1 ON (CP.AccountNumber = T1.AccountNumber AND CP.TransactionAmount = T1.TransactionAmount /*AND CP.TransactionUUID = T1.TransactionUUID*/)
WHERE CP.CMTTRanType IN ('40', '110')
ORDER BY CP.TransactionLifeCycleUniqueID, CP.CMTTRanType DESC

SELECT BSAcctid, CP.ARTxnType, CP.TxnSource, RTRIM(CP.CMTTRANTYPE) AS CMTTRANTYPE, CP.TransactionDescription,CP.TxnAcctId, txnsource, CP.creditplanmaster, EqualPayments, 
CP.TransactionAmount,CP.TranId,CP.TranRef,CP.tranorig,CP.TransmissionDateTime,CP.atid,Trantime,CP.PostTime,
CP.MemoIndicator,CP.RevTgt
FROM CCard_Primary CP WITH (NOLOCK)
LEFT JOIN CCard_Secondary CS WITH (NOLOCK) ON (CP.TranId = CS.TranId)
LEFT JOIN CPMAccounts CPM WITH (NOLOCK) ON (CP.CreditPlanMaster = CPM.acctId AND CP.TxnSource = 29 AND CP.CMTTRANTYPE = '40')
JOIN #TempData T1 ON (CP.AccountNumber = T1.AccountNumber AND CP.TransactionAmount = T1.TransactionAmount)
WHERE /*CP.AccountNumber IN (SELECT AccountNumber FROM BSegment_Primary WITH(NOLOCK) WHERE acctId = @AccountID) 
AND*/ CP.CMTTRANTYPE NOT IN ('HPOTB','PPR','MMR')
AND (LEN(CP.CMTTRANTYPE) = 2 OR TRY_CAST(CP.CMTTRANTYPE AS INT) < 120 OR TRY_CAST(CP.CMTTRANTYPE AS INT) > 1000 OR CP.CMTTRANTYPE IN ('QNA', '*SCR'))
AND CP.TxnSource NOT IN ('4','10')
AND CP.MemoIndicator IS NULL
AND (CP.ArTxnType <> 93 OR CP.ArTxnType IS NULL)
--AND CP.PostTime BETWEEN '2021-10-31 23:59:57.000' AND '2021-11-30 23:59:57.000'
--AND CMTTranType NOT in ('40')
--AND CP.TxnAcctId = 25496592
ORDER BY CP.POSTTIME DESC



DROP TABLE IF EXISTS #cp
GO
select bp.acctid,bp.accountnumber,bp.universaluniqueid,cp.tranid,cp.trantime,cp.posttime,cp.cmttrantype,cp.transactionamount,
ap.transactionuuid, CP.transactionlifecycleuniqueid, CP.RevTGT, CP.CreditPlanMaster
into #cp
from bsegment_primary bp with(nolock) join
ccard_primary cp with(nolock) on cp.accountnumber = bp.accountnumber join
auth_primary ap with(nolock) on ap.accountnumber = cp.accountnumber and ap.TransactionLifeCycleUniqueID = cp.TransactionLifeCycleUniqueID
JOIN #TempData T1 ON (T1.TransactionUUID = AP.TransactionUUID AND T1.AccountNumber = AP.AccountNumber)
where 
cp.cmttrantype IN ('40')
----and ap.cmttrantype = '93'
--and ap.transactionuuid in
--(
--'586e23b6-80f8-4f50-8ad7-938099fc01cc',
--'60580359-51a9-4383-adad-b4be5585f529',
--'64ab57b1-d6d1-4327-b0bd-19cb1fcca880',
--'a148deca-3d64-4f12-bf94-0a3351f81d66'
--)

--DROP TABLE IF EXISTS #TempData
--CREATE TABLE #TempData (AccountUUID VARCHAR(64), TransactionUUID VARCHAR(64), TransactionAmount MONEY, AccountNumber VARCHAR(19))

--INSERT INTO #TempData (AccountUUID, TransactionUUID, TransactionAmount) VALUES
--('00ff304e-5c12-4f4d-9cb5-edab951e78c5','3b5e91ea-bbb0-498e-b353-195be1770ce9', 269), 
--('00ff304e-5c12-4f4d-9cb5-edab951e78c5','6a4c0ae2-6838-4aba-a7a6-8e16499ca308', 1399),	
--('01294d94-fea9-40cf-a5e4-fd9a7a7d5c20','a683ecd4-62b0-4825-90e6-1fb429c2df53', 879),	
--('059fc0b8-d187-480c-9017-8aa95b59ab31','621fd234-c291-494d-ae59-91ee1917c238', 219),	
--('0c1dfc62-378d-4408-afc1-1bd418ad4513','caaa114c-9123-48aa-a1b1-797f45c89550', 159)
