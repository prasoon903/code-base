DROP TABLE IF EXISTS #tempRecords
SELECT C.AccountNumber, BSAcctId, TranID, T.AccountUUID, C.CMTTRANTYPE, TxnCode_Internal, TransactionAmount, TransactionDescription, TranTime, PostTime, ClientID
INTO #tempRecords
FROM CCard_Primary C WITH (NOLOCK)
JOIN ##TempAccounts T ON (C.AccountNumber = T.AccountNumber)
WHERE CMTTRANTYPE = '16'
AND PostTime > '2025-06-06'

SELECT C.AccountNumber, BSAcctId, TranID, T.AccountUUID, C.CMTTRANTYPE, TxnCode_Internal, TransactionAmount, TransactionDescription, TranTime, PostTime, ClientID
--INTO #tempRecords
FROM CCard_Primary C WITH (NOLOCK)
JOIN ##TempAccounts T ON (C.AccountNumber = T.AccountNumber)
--WHERE CMTTRANTYPE = '16'
AND PostTime > '2025-06-06'

SELECT * FROM CommonTNP WITH (NOLOCK) WHERE TranTime < GETDATE()

SELECT * FROM CommonAP WITH (NOLOCK) WHERE TranTime < GETDATE()

SELECT * FROM ##TempAccounts


SELECT AccountNumber, AccountUUID
FROM ##TempAccounts
EXCEPT
SELECT AccountNumber, AccountUUID
FROM #tempRecords




DECLARE @JIRAID VARCHAR(20) = 'COOKIE-324414'
DECLARE @TranCode VARCHAR(20) = '1701'
DECLARE @TranType VARCHAR(5) = '17'
DECLARE @PostOnSpecificCustomer INT = 1

SELECT 'INSERT INTO TransactionCreationTempData (JiraID, TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, ClientID, RevTgt) 
	VALUES (''' + @JIRAID + ''', ' + TRY_CONVERT(VARCHAR, BSAcctId) + ', '''+RTRIM(AccountNumber)+''', ' + TRY_CONVERT(VARCHAR, TransactionAmount) + ', ''' + @TranType + '''' + ', ''' + @TranCode + '''' + ', ''' + ClientID + '''' + ', ' + TRY_CAST(TranID AS VARCHAR(50)) + ')'
	FROM #tempRecords

SELECT *
FROM MonetaryTxnControl WITH (NOLOCK)
WHERE TransactionCode = '17152'

SELECT *
FROM MonetaryTxnControl WITH (NOLOCK)
WHERE TransactionCode = '17151'

SELECT *
FROM MonetaryTxnControl WITH (NOLOCK)
WHERE ActualTranCode = '1701'

SELECT * FROM ##TempAccounts --WHERE MergeInProcessPH IS NOT NULL

DROP TABLE IF EXISTS ##TempAccounts
SELECT DISTINCT BP.AccountNumber, UniversalUniqueID AccountUUID, MergeInProcessPH, BP.acctID
INTO ##TempAccounts
FROM BSegment_Primary BP WITH (NOLOCK)
JOIN #Temp T ON (BP.AccountNumber = T.AccountNumber)


SELECT * FROM #Temp

DROP TABLE IF exists #Temp
SELECT '1100011132648597' AccountNumber INTO #Temp
UNION ALL SELECT '1100011153904481'
UNION ALL SELECT '1100011144972852'
UNION ALL SELECT '1100011212036614'


