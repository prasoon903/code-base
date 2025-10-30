SELECT TRY_CAST(PostTime AS DATE) PostTime, CMTTranType, COUNT(1) [Count]
FROM LS_P1MARPRODDB01.CCGS_CoreIssue.dbo.CreateNewSingleTransactionData WITH (NOLOCK)
WHERE PostTime > '2022-03-31 23:59:57'
AND TransactionStatus = 2
AND CMTTranType NOT IN ('RCINT')
GROUP BY TRY_CAST(PostTime AS DATE), CMTTranType


--SELECT txnprocesstime,* FROM LS_P1MARPRODDB01.CCGS_CoreIssue.dbo.CCard_Primary WITH (NOLOCK) WHERE TranID IN (71000070704)
