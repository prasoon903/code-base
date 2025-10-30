SELECT parent02AID,* FROM CPSgmentAccounts WITH (NOLOCK) WHERE acctId = 77014538

DROP TABLE IF EXISTS #Credits
SELECT CMTTranType, TxnAcctID, TranID, TranRef, TranOrig, TransactionAmount, TranTime, PostTime, RevTgt, NoblobIndicator, MemoIndicator 
INTO #Credits
FROM CCArd_Primary WITH (NOLOCK)
WHERE AccountNumber = '1100011111257303'
AND CMTTRanType IN ('21', '41')
ORDER BY PostTime DESC

DELETE FROM #Credits WHERE TranID IN (
SELECT C.TranID
FROM #Credits C
JOIN CCArd_Primary CP WITH (NOLOCK) ON (C.TranID = CP.RevTgt)
WHERE AccountNumber = '1100011111257303')

DROP TABLE IF EXISTS #ActiveCredits
SELECT ROW_NUMBER() OVER(ORDER BY TranID) SN, * 
INTO #ActiveCredits
FROM #Credits

DROP TABLE IF EXISTS #Minis
SELECT C.SN, CP.CMTTranType, CP.TxnAcctID, CP.TranID, CP.TranRef, CP.TranOrig, CP.TransactionAmount, CP.TranTime, CP.PostTime, CP.RevTgt, CP.NoblobIndicator, CP.MemoIndicator, CP.TransactionDescription
INTO #Minis
FROM #ActiveCredits C
JOIN CCArd_Primary CP WITH (NOLOCK) ON (C.TranID = CP.TranRef)
WHERE AccountNumber = '1100011111257303'

SELECT * FROM #ActiveCredits WHERE SN = 22

--SELECT * FROM #Minis WHERE SN = 14 ORDER BY PostTime DESC 

SELECT * FROM #Minis WHERE SN = 14 --AND NoblobIndicator = '6' 
order by posttime

SELECT TXNAcctID, SUM(TransactionAmount) TransactionAmount FROM #Minis WHERE NoblobIndicator = '6' GROUP BY TXNAcctID

SELECT TXNAcctID, NoblobIndicator, TransactionDescription, SUM(TransactionAmount) TransactionAmount FROM #Minis GROUP BY TXNAcctID, NoblobIndicator, TransactionDescription

SELECT * FROM #Minis WHERE NoblobIndicator = '6' AND TxnAcctID = 77014538

SELECT * FROM #Minis WHERE TxnAcctID = 1142017

SELECT CMTTranType, TxnAcctID, TranID, TranRef, TranOrig, TransactionAmount, TranTime, PostTime, RevTgt, NoblobIndicator, MemoIndicator 
FROM CCArd_Primary WITH (NOLOCK)
WHERE AccountNumber = '1100011111257303'
AND TranRef = 79151569045
ORDER BY PostTime DESC

81356744577
80406404274
NULL
79128681325

81356744634
80406404290
79151569045
79128681428

SELECT CMTTranType, COUNT(1)
FROM CCArd_Primary WITH (NOLOCK)
WHERE AccountNumber = '1100011111257303'
GROUP BY CMTTranType

SELECT CMTTranType, TxnAcctID, TranID, TranRef, TranOrig, TransactionAmount, TranTime, PostTime, RevTgt, NoblobIndicator, MemoIndicator 
FROM CCArd_Primary WITH (NOLOCK)
WHERE AccountNumber = '1100011111257303'
--AND TxnAcctID = 77014538
ORDER BY PostTime DESC




SELECT sum(transactionamount),cmttrantype
FROM CCArd_Primary WITH (NOLOCK)
WHERE AccountNumber = '1100011111257303'
AND txnacctid = 1142017 and cmttrantype in ('40','48','02','43')
group by cmttrantype

--select 550.57 - 359.00
--select 2418.76 - 2161.06 


SELECT sum(transactionamount),cmttrantype
FROM CCArd_Primary WITH (NOLOCK)
WHERE AccountNumber = '1100011111257303'
AND txnacctid = 77014538 and transactiondescription = 'NoBlob Adjustment'
group by cmttrantype


SELECT sum(transactionamount),cmttrantype
FROM CCArd_Primary WITH (NOLOCK)
WHERE AccountNumber = '1100011111257303'
AND txnacctid = 40448332 and noblobindicator = '6' --and memoindicator is null
group by cmttrantype