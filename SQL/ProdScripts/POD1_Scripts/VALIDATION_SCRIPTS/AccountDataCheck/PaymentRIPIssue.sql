DROP TABLE IF EXISTS #Rev1
SELECT AccountNumber, TranID, TransactionAmount, RevTGT
INTO #Rev1
FROM CCArd_Primary WITH (NOLOCK)
WHERE 
PostTime > '2022-02-28 23:59:57'
AND ArTxnType <> '93'
AND CMTTranType IN ('22', '26')
AND AccountNumber IN (SELECT AccountNumber FROM BSegment_Primary WITH (NOLOCK) WHERE acctId = 2298633)

DROP TABLE IF EXISTS #Mini
SELECT CP.AccountNumber, CP.TransactionAmount, CP.TranRef
INTO #Mini
FROM CCard_Primary CP WITH (NOLOCK) 
JOIN #Rev1 R On (R.RevTGT = CP.TranRef)
WHERE NoblobIndicator = '6'
AND ISNUMERIC(CP.CMTTRanType) = 1
AND CP.AccountNumber IN (SELECT AccountNumber FROM BSegment_Primary WITH (NOLOCK) WHERE acctId = 2298633)

DROP TABLE IF EXISTS #mini1
SELECT SUM(TransactionAmount) TransactionAmount, AccountNumber, TranRef
INTO #mini1
FROM #Mini
GROUP BY AccountNumber, TranRef

SELECT *
FROM #Rev1 R
JOIN #mini1 M ON (M.TranRef = R.RevTGT)
WHERE R.TransactionAmount <> M.TransactionAmount


SELECT AccountNumber, NoblobIndicator, TranID, TransactionAmount, RevTGT, *
FROM CCArd_Primary WITH (NOLOCK)
WHERE TranID = 54578626468

SELECT AccountNumber, NoblobIndicator, TranID, TransactionAmount, RevTGT, *
FROM CCArd_Primary WITH (NOLOCK)
WHERE TranRef = 54578626468