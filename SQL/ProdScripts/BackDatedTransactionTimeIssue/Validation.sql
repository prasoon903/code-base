SELECT *
FROM sys.servers

SELECT * 
FROM sys.tables 
where name like '%CreateNewSingleTransactionData%'

DROP TABLE IF EXISTS #TempTxns
SELECT AccountNumber, TranID, TranTime, PostTime, Reason
INTO #TempTxns
FROM CCGS_CoreIssue.dbo.BKP_CreateNewSingleTransactionData_20240711 WITH (NOLOCK)
WHERE CMTTRanType = '49'
AND TranTime < PostTime

DROP TABLE IF EXISTS ##TempTxns
SELECT * INTO ##TempTxns FROM #TempTxns

DROP TABLE IF EXISTS #IssueTxns
SELECT T.*, CP.TranTime CCard_TranTime, CP.PostTime CCard_PostTime
INTO #IssueTxns
FROM CCard_Primary CP WITH (NOLOCK)
JOIN ##TempTxns T ON (CP.Accountnumber = T.AccountNumber AND CP.TranID = T.TranID)
WHERE T.TranTime <> CP.TranTime

SELECT I.*, BP.SystemStatus 
FROM #IssueTxns I
JOIN BSegment_Primary Bp WITH (NOLOCK) ON (I.AccountNumber = BP.AccountNumber)
WHERE BP.SystemStatus <> 14
ORDER BY CCard_PostTime

	
SELECT * FROM BKP_CreateNewSingleTransactionData_20240711 WITH (NOLOCK) WHERE AccountNumber = '1100011117235311' AND TranID = 97081383862

SELECT * FROM TransactionCreationTempData WITH (NOLOCK) WHERE AccountNumber = '1100011153218510'

