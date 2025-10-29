SELECT COUNT(1) FROM RemediationData WITH (NOLOCK)

DROP TABLE IF EXISTS #TempRecords
SELECT BP.acctId, BP.AccountNumber, BS.ClientID, T.AccountUUID, BP.MergeInProcessPH, T.Amount, T.TranTime 
INTO #TempRecords
FROM RemediationData T
JOIN BSegment_Primary BP WITH (NOLOCK) ON (BP.UniversalUniqueID = T.AccountUUID)
JOIN BSegment_Secondary BS WITH (NOLOCK) ON (BP.acctId = BS.acctID)
WHERE MergeInProcessPH IS NOT NULL

DROP TABLE IF EXISTS #TempDataALL
SELECT AccountNumber, acctId, Amount TransactionAmount, TranTime TransactionTime INTO #TempDataALL FROM #TempRecords


DROP TABLE IF EXISTS #TempDataCombined
SELECT AccountNumber, acctID, SUM(TransactionAmount) TransactionAmount, MIN(TransactionTime) TransactionTime, COUNT(1) [COUNT]
INTO #TempDataCombined
FROM #TempDataALL
GROUP BY AccountNumber, acctID

SELECT 'INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (' + TRY_CONVERT(VARCHAR, acctID) + ', '''+RTRIM(AccountNumber)+''', ' + TRY_CONVERT(VARCHAR, TransactionAmount) + ', ''49''' + ', ''4907''' + ', ''' + TRY_CONVERT(VARCHAR(20), TransactionTime, 20) + ''')'
FROM #TempDataCombined
ORDER BY TransactionTime



--SELECT * FROM sys.servers

SELECT CP.PostingRef, CP.CMTTranType, CP.TransactionAmount, CP.TranTime, CP.PostTime 
FROM LS_P1MARPRODDB01.ccgs_coreissue.dbo.CreateNewSingleTransactionData C WITH (NOLOCK)
JOIN CCard_Primary CP WITH (NOLOCK)  ON (C.TranID = CP.TranID)
WHERE C.PostTime > TRY_CAST(GETDATE() AS DATE)

SELECT JobStatus, COUNT(1)
FROM LS_P1MARPRODDB01.ccgs_coreissue.dbo.TransactionCreationTempData WITH (NOLOCK)
GROUP BY JobStatus 


SELECT * FROM #TempData WHERE AccountUUID = 'd36b58d1-8dad-4741-9fc1-8baf626fc6d4'

;WITH CTE 
AS
(
SELECT *, ROW_NUMBER() OVER(PARTITION BY AccountUUID ORDER BY SN)  [Rank]
FROM #TempData
)
SELECT * FROM CTE WHERE [Rank] > 1

DROP TABLE IF EXISTS ##TempData
SELECT * INTO ##TempData FROM #TempData

DROP TABLE IF EXISTS #TempRecords
SELECT BP.acctId, BP.AccountNumber, BS.ClientID, T.AccountUUID, BP.MergeInProcessPH, T.Amount, T.TransactionTime 
INTO #TempRecords
FROM #TempData T
JOIN BSegment_Primary BP WITH (NOLOCK) ON (BP.UniversalUniqueID = T.AccountUUID)
JOIN BSegment_Secondary BS WITH (NOLOCK) ON (BP.acctId = BS.acctID)
--WHERE MergeInProcessPH IS NOT NULL

DROP TABLE IF EXISTS ##TempRecords
SELECT * INTO ##TempRecords FROM #TempRecords


SELECT * FROM #TempRecords WHERE MergeInProcessPH IS NOT NULL

--GET POD2 accounts
DROP TABLE IF EXISTS #POD2
SELECT /*T.ClientID,*/ T.AccountUUID, T.TransactionTime, T.Amount 
INTO #POD2
FROM #TempData T
LEFT JOIN BSegment_Primary BP WITH (NOLOCK) ON (BP.UniversalUniqueID = T.AccountUUID)
WHERE BP.UniversalUniqueID IS NULL

SELECT * FROM #POD2 WHERE AccountUUID = '9d927fcb-8837-47b2-8e24-cbc122c5bdef'

SELECT * 
FROM MergeAccountJob  M WITH (NOLOCK)
--WHERE DestBSAccountUUID = ''
JOIN #POD2 P ON (M.SrcBSAccountUUID = P.AccountUUID)


SELECT AccountUUID, SUM(Amount) Amount, MIN(TransactionTime) TransactionTime FROM #POD2 GROUP BY AccountUUID


SELECT AccountUUID, SUM(Amount) Amount, MIN(TransactionTime) TransactionTime FROM #TempRecords WHERE MergeInProcessPH IS NOT NULL GROUP BY AccountUUID


SELECT * FROM #TempRecords
WHERE MergeInProcessPH IS NOT NULL


DROP TABLE IF EXISTS #TempJobsToPost
SELECT acctId, AccountNumber, Amount TransactionAmount, ROW_NUMBER() OVER(PARTITION BY AccountNumber ORDER BY acctId) RowCountData
INTO #TempJobsToPost
FROM #TempRecords
WHERE MergeInProcessPH IS NOT NULL

SELECT * FROM #TempJobsToPost ORDER by acctId

SELECT AccountNumber, RowCountData FROM #TempJobsToPost  ORDER BY RowCountData DESC

SELECT AccountNumber, MAX(RowCountData) FROM #TempJobsToPost  GROUP BY AccountNumber ORDER BY MAX(RowCountData) DESC

SELECT MAX(RowCountData) FROM #TempJobsToPost

SELECT * FROM #TempRecords WHERE AccountNumber = '1100011122772027' ORDER BY TransactionTime



-- Merge Accounts

DROP TABLE IF EXISTS #NonMergedAccounts
SELECT RTRIM(AccountNumber) SourceAccountNumber, AccountUUID, ClientID SrcClientID, acctId, MergeInProcessPH, Amount TransactionAmount, TT.TransactionTime 
INTO #NonMergedAccounts
FROM #TempRecords TT
WHERE MergeInProcessPH IS NULL
ORDER BY acctID

DROP TABLE IF EXISTS #MergedAccounts
SELECT RTRIM(AccountNumber) SourceAccountNumber, AccountUUID, ClientID SrcClientID, MergeInProcessPH, Amount TransactionAmount, TT.TransactionTime
INTO #MergedAccounts
FROM #TempRecords TT
WHERE MergeInProcessPH IS NOT NULL
ORDER BY acctID

SELECT * FROM #NonMergedAccounts

SELECT * FROM #MergedAccounts



SELECT DestAccountNumber, AcrossPODMerge, * 
FROM LS_P1MARPRODDB01.ccgs_coreissue.dbo.MergeAccountJob MA WITH (NOLOCK) 
WHERE SrcAccountNumber = '1100011126022395'

DROP TABLE IF EXISTS #PostWithNoInterestCredit
SELECT T1.MergeInProcessPH, SrcAccountNumber, DestAccountNumber AccountNumber, SrcBsAcctId, DestBSAcctId,
T1.TransactionAmount Amount, T1.TransactionTime, 
MA.EndTime TranTime_ToPostOnDest, BP.DateAcctOpened DateAcctOpened_DEST, 
MA.SrcClientID, BS.ClientID DestClientID,
BP.UniversalUniqueID DestAccountUUID, SrcBSAccountUUID SrcAccountuuid--,
--MA.EndTime MergeTime
INTO #PostWithNoInterestCredit
FROM #MergedAccounts t1
LEFT JOIN LS_P1MARPRODDB01.ccgs_coreissue.dbo.MergeAccountJob MA WITH (NOLOCK) ON (T1.SourceAccountNumber = MA.SRCAccountNumber)
LEFT JOIN LS_P1MARPRODDB01.ccgs_coreissue.dbo.BSegment_Primary BP WITH (NOLOCK) ON (MA.DestAccountNumber = BP.AccountNumber )
LEFT JOIN LS_P1MARPRODDB01.ccgs_coreissue.dbo.BSegment_Secondary BS WITH (NOLOCK) ON (BS.acctId = BP.acctId)
--WHERE  
--T1.SourceAccountNumber IN ('1100011127011249', '1100011139323376') AND 
--T1.TranTime >= BP.DateAcctOpened
--ORDER BY DestAccountNumber


DROP TABLE IF EXISTS #PostWithInterestCredit
SELECT SrcAccountNumber, DestAccountNumber AccountNumber, T1.TransactionLifeCycleUniqueID, SrcBsAcctId, DestBSAcctId, T1.TranTime TranTime_Src,
T1.TransactionAmount Amount, MA.EndTime TranTime_ToPostOnDest, BP.DateAcctOpened DateAcctOpened_DEST, MA.SrcClientID, BS.ClientID DestClientID,
BP.UniversalUniqueID DestAccountUUID, SrcBSAccountUUID SrcAccountuuid,
MA.EndTime MergeTime, ROW_NUMBER() OVER(PARTITION BY DestAccountNumber ORDER BY T1.TranTime) RowCountData, CAST(0 AS MONEY) FINAL_INT_CR_AMT
INTO #PostWithInterestCredit
FROM #MergedAccounts t1
LEFT JOIN LS_P1MARPRODDB01.ccgs_coreissue.dbo.MergeAccountJob MA WITH (NOLOCK) ON (T1.SourceAccountNumber = MA.SRCAccountNumber)
LEFT JOIN LS_P1MARPRODDB01.ccgs_coreissue.dbo.BSegment_Primary BP WITH (NOLOCK) ON (MA.DestAccountNumber = BP.AccountNumber )
LEFT JOIN LS_P1MARPRODDB01.ccgs_coreissue.dbo.BSegment_Secondary BS WITH (NOLOCK) ON (BS.acctId = BP.acctId)
WHERE  
--T1.SourceAccountNumber IN ('1100011127011249', '1100011139323376') AND 
T1.TranTime < BP.DateAcctOpened
ORDER BY DestAccountNumber


SELECT * FROm #PostWithNoInterestCredit

SELECT * FROm #PostWithInterestCredit

DROP TABLE IF EXISTS #TempDataALL
SELECT SourceAccountNumber AccountNumber, acctId, TransactionAmount, TransactionTime INTO #TempDataALL FROM #NonMergedAccounts
INSERT INTO #TempDataALL
SELECT AccountNumber, DestBSacctId acctId, Amount TransactionAmount, TransactionTime FROM #PostWithNoInterestCredit WHERE MergeInProcessPH = 4


DROP TABLE IF EXISTS #TempDataCombined
SELECT AccountNumber, acctID, SUM(TransactionAmount) TransactionAmount, MIN(TransactionTime) TransactionTime, COUNT(1) [COUNT]
INTO #TempDataCombined
FROM #TempDataALL
GROUP BY AccountNumber, acctID

SELECT * FROM #tempDataALL WHERE acctId = 201779
--1927.37	2021-02-11 00:00:00.000


DROP TABLE IF EXISTS ##PostWithInterestCredit
SELECT * INTO ##PostWithInterestCredit FROm #PostWithInterestCredit


SELECT * FROM ##PostWithInterestCredit

DROP TABLE IF EXISTS #FinalDataNonMerged
SELECT *, ROW_NUMBER() OVER(PARTITION BY SourceAccountNumber ORDER BY TransactionTime) [Row] INTO #FinalDataNonMerged FROM #NonMergedAccounts

SELECT * FROM #FinalDataNonMerged
WHERE SourceAccountNumber IN ('1100011122772027', '1100011117197248', '1100011172300349', '1100011163443736', '1100011136478611', '1100011115480695') 
ORDER BY [Row], TransactionTime

SELECT AccountNumber, MAX(RowCountData) FROM #TempJobsToPost  GROUP BY AccountNumber ORDER BY MAX(RowCountData) DESC




-- CREATE INSERT SCRIPTS

SELECT 'INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (' + TRY_CONVERT(VARCHAR, acctID) + ', '''+RTRIM(AccountNumber)+''', ' + TRY_CONVERT(VARCHAR, TransactionAmount) + ', ''49''' + ', ''4907''' + ', ''' + TRY_CONVERT(VARCHAR(20), TransactionTime, 20) + ''')'
FROM #TempDataCombined
ORDER BY TransactionTime

SELECT 'INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (' + TRY_CONVERT(VARCHAR, acctID) + ', '''+RTRIM(SourceAccountNumber)+''', ' + TRY_CONVERT(VARCHAR, TransactionAmount) + ', ''49''' + ', ''4907''' + ', ''' + TRY_CONVERT(VARCHAR(20), TransactionTime, 20) + ''')'
FROM #NonMergedAccounts
WHERE SourceAccountNumber NOT IN ('1100011122772027', '1100011117197248', '1100011172300349', '1100011163443736', '1100011136478611', '1100011115480695')
ORDER BY TransactionTime

SELECT '--' + TRY_CAST([Row] AS VARCHAR) + ' 
' + 'INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (' + TRY_CONVERT(VARCHAR, acctID) + ', '''+RTRIM(SourceAccountNumber)+''', ' + TRY_CONVERT(VARCHAR, TransactionAmount) + ', ''49''' + ', ''4907''' + ', ''' + TRY_CONVERT(VARCHAR(20), TransactionTime, 20) + ''')'
FROM #FinalDataNonMerged
WHERE SourceAccountNumber IN ('1100011122772027', '1100011117197248', '1100011172300349', '1100011163443736', '1100011136478611', '1100011115480695')
ORDER BY [Row], TransactionTime


SELECT '--' + TRY_CAST([Row] AS VARCHAR) + ' 
' + 'INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (' + TRY_CONVERT(VARCHAR, acctID) + ', '''+RTRIM(SourceAccountNumber)+''', ' + TRY_CONVERT(VARCHAR, TransactionAmount) + ', ''49''' + ', ''4907''' + ', ''' + TRY_CONVERT(VARCHAR(20), TransactionTime, 20) + ''')'
FROM #FinalDataNonMerged
WHERE SourceAccountNumber IN ('1100011122772027', '1100011117197248', '1100011172300349', '1100011163443736', '1100011136478611', '1100011115480695')
AND [Row] BETWEEN 81 AND 500
ORDER BY [Row], TransactionTime


SELECT [Row], 'INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (' + TRY_CONVERT(VARCHAR, acctID) + ', '''+RTRIM(SourceAccountNumber)+''', ' + TRY_CONVERT(VARCHAR, TransactionAmount) + ', ''49''' + ', ''4907''' + ', ''' + TRY_CONVERT(VARCHAR(20), TransactionTime, 20) + ''')'
FROM #FinalDataNonMerged
WHERE [Row] > 20
ORDER BY [Row], TransactionTime


SELECT 'INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (' + TRY_CONVERT(VARCHAR, DestBsacctID) + ', '''+RTRIM(AccountNumber)+''', ' + TRY_CONVERT(VARCHAR, Amount) + ', ''49''' + ', ''4907''' + ', ''' + TRY_CONVERT(VARCHAR(20), TransactionTime, 20) + ''')'
FROM #PostWithNoInterestCredit
WHERE MergeInProcessPH = 4


--SELECT 'INSERT INTO CreateNewSingleTransactionData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) 
--VALUES (' + TRY_CONVERT(VARCHAR, DestBsacctID) + ', '''+RTRIM(AccountNumber)+''', ' + TRY_CONVERT(VARCHAR, Amount+FINAL_INT_CR_AMT) + ', ''49''' + ', ''4913''' + ', ''' + TRY_CONVERT(VARCHAR(20), DATEADD(MINUTE, 60, TranTime_ToPostOnDest), 20) + ''')'
--FROM ##PostWithInterestCredit
--ORDER BY TranTime_ToPostOnDest

SELECT *--ClientID, AccountUUID, Amount
FROM #POD2

SELECT ClientID, AccountUUID, Amount
FROM #TempRecords

SELECT RTRIM(SourceAccountNumber) AccountNumber, AccountUUID/*, SrcClientID ClientID*/, TransactionAmount, TransactionTime
FROM #NonMergedAccounts

SELECT RTRIM(SrcAccountNumber) SrcAccountNumber, RTRIM(AccountNumber) DestAccountNumber, SrcAccountUUID, DestAccountUUID, SrcClientID, DestClientID, Amount TransactionAmount 
FROM #PostWithNoInterestCredit

--SELECT RTRIM(SrcAccountNumber) SrcAccountNumber, RTRIM(AccountNumber) DestAccountNumber, SrcAccountUUID, DestAccountUUID, SrcClientID, DestClientID, Amount TransactionAmount, 
--FINAL_INT_CR_AMT InterestCreditFromSource, Amount+FINAL_INT_CR_AMT TotalTransactionAmount
--FROM ##PostWithInterestCredit



