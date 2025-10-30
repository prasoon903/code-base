DROP TABLE IF EXISTS #CCardTxns

SELECT CP.AccountNumber, BSAcctid, CP.ARTxnType, CP.TxnSource, RTRIM(CP.CMTTRANTYPE) AS CMTTRANTYPE,CP.TxnAcctId, CP.creditplanmaster, 
CP.TransactionAmount,CP.TranId,CP.TranRef,CP.tranorig,CP.TransmissionDateTime,CP.atid,Trantime,CP.PostTime,
CP.MemoIndicator,CP.RevTgt
INTO #CCardTxns
FROM CCard_Primary CP WITH (NOLOCK)
WHERE CP.AccountNumber IN 
(SELECT AccountNumber FROM BSegment_Primary BP WITH(NOLOCK)
JOIN ##BSRecordsDue T1 ON (BP.acctId = T1.acctId) ) 
AND CP.CMTTRANTYPE NOT IN ('HPOTB','PPR','MMR')
AND (LEN(CP.CMTTRANTYPE) = 2 OR TRY_CAST(CP.CMTTRANTYPE AS INT) < 120 OR TRY_CAST(CP.CMTTRANTYPE AS INT) > 1000 OR CP.CMTTRANTYPE IN ('QNA', '*SCR'))
AND CP.TxnSource NOT IN ('4','10')
AND CP.MemoIndicator IS NULL
AND (CP.ArTxnType <> 93 OR CP.ArTxnType IS NULL)
AND CP.PostTime >= '2021-11-30 23:59:57.000'
--AND CMTTranType in ('21','22')
ORDER BY CP.POSTTIME DESC

SELECT * FROM #CCardTxns

SELECT BSAcctid, CMTTRANTYPE, COUNT(1) [Count]
FROM #CCardTxns
GROUP BY BSAcctid, CMTTRANTYPE
--HAVING CMTTRANTYPE <> '21'
ORDER BY BSAcctid