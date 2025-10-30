DROP TABLE IF EXISTS #TempCCard
SELECT BSAcctId, AccountNumber, TranID, CMTTranType, TxnSource
INTO #TempCCard
FROM CCard_Primary WITH (NOLOCK)
WHERE PostTime > '2022-12-31 23:59:57'
AND ArTxnType = '91'
AND CMTTranType = '21'

SELECT CMTTranType, COUNT(1) [COUNT]
FROM #TempCCard
GROUP BY CMTTranType

DROP TABLE IF EXISTS #Mismatch
SELECT T1.*, BP.AccountNumber AccountNumber_BS, BS.ClientID
INTO #Mismatch
FROM #TempCCard T1
JOIN BSegment_Primary BP ON (BP.acctId = T1.BSAcctId)
JOIN BSegment_Secondary BS ON (BP.acctId = BS.acctId)
WHERE BP.AccountNumber <> T1.AccountNumber

SELECT *,
'UPDATE TOP(1) CCard_Primary SET AccountNumber = ''' + RTRIM(AccountNumber_BS) + ''', ClientID = ''' + RTRIM(ClientID) + ''', TxnAcctID = ' + TRY_CAST(BSAcctID AS VARCHAR) + ' WHERE TranID = ' + TRY_CAST(TranID AS VARCHAR) [UPDATE_BS]
FROM #Mismatch

--UPDATE TOP(1) CCard_Primary SET AccountNumber = '1100011101752016', ClientID = '505e8cff-0355-44fd-b763-a4c2dcbe5385', TxnAcctID = 179368, EmbAcctId = 421957 WHERE TranID = 65708329449

SELECT AccountNumber, BSAcctID, ClientID, EmbAcctId,* FROM CCard_Primary WITH (NOLOCK) WHERE TranID = 72960975823


---sp_helptext usp_extractdataforfutureprojection


SELECT AccountNumber, BSAcctID, ClientID, EmbAcctId,* FROM CCard_Primary WITH (NOLOCK) WHERE TranRef = 72960975823

SELECT * FROM LogArTxnAddl WITH (NOLOCK) WHERE TranID = 70872068373


--Transaction Posted Successfully

--UPDATE TOP(1) CCard_Primary SET 
--	PostingRef = 'Transaction Posted Successfully',
--	ArTxnType = 91,
--	AccountNumber = '1100011203982511',
--	BSAcctID = 21674093,
--	ClientID = '00b0bb88-0bf7-4647-a56f-715ff120cc3a',
--	EmbAcctId = 29704587
--WHERE TranID = 70872068373




SELECT AccountNumber, BSAcctID, ClientID, EmbAcctId,* FROM CCard_Primary WITH (NOLOCK) WHERE AccountNumber = '1100011173823067' AND TranRef = 59375432334

SELECT AccountNumber, BSAcctID, ClientID, EmbAcctId,* 
FROM CCard_Primary WITH (NOLOCK) 
WHERE (AccountNumber = '1100011128015801' /*OR BSAcctID = 179368*/)
AND CMTTRanType = '21'
AND PostTime > '2022-03-31 23:59:57' 
ORDER BY PostTime DESC

SELECT AccountNumber, acctId,* FROM BSegment_Primary WITH (NOLOCK) WHERE acctId = 2283104