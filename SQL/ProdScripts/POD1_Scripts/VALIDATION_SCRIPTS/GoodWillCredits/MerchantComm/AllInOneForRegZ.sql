SELECT * FROM #TempData

SELECT UniversalUniqueID 
FROM BSegment_Primary BP WITH (NOLOCK)
JOIN BSegment_Secondary BS WITH (NOLOCK) ON (BP.acctId = BS.acctId)
WHERE ClientID = 'e32d583a-89d5-40c3-94f3-417e36d53184'

--UPDATE #TempData SET AccountUUID = 'ad8125ae-2e38-4f02-a484-abfbeda0c1e8' WHERE SN = 14



SELECT CP.PostingRef, CP.CMTTranType, CP.TransactionAmount, CP.TranTime, CP.PostTime 
FROM LS_PRODDRGSDB01.ccgs_coreissue.dbo.CreateNewSingleTransactionData C WITH (NOLOCK)
JOIN CCard_Primary CP WITH (NOLOCK)  ON (C.TranID = CP.TranID)
WHERE C.PostTime > TRY_CAST(GETDATE() AS DATE)


SELECT * FROM #TempData WHERE AccountUUID = 'd36b58d1-8dad-4741-9fc1-8baf626fc6d4'

;WITH CTE 
AS
(
SELECT *, ROW_NUMBER() OVER(PARTITION BY ClientID, AccountUUID, TransactionUUID ORDER BY SN)  [Rank]
FROM #TempData
)
SELECT * FROM CTE WHERE [Rank] > 1

DROP TABLE IF EXISTS ##TempData
SELECT * INTO ##TempData FROM #TempData

DROP TABLE IF EXISTS #TempRecords
SELECT BP.acctId, BP.AccountNumber, BS.ClientID, T.AccountUUID, BP.MergeInProcessPH, T.TransactionUUID, T.Amount--, T.TransactionTime 
INTO #TempRecords
FROM #TempData T
JOIN BSegment_Primary BP WITH (NOLOCK) ON (BP.UniversalUniqueID = T.AccountUUID)
JOIN BSegment_Secondary BS WITH (NOLOCK) ON (BP.acctId = BS.acctID)
--WHERE MergeInProcessPH IS NOT NULL

DROP TABLE IF EXISTS ##TempRecords
SELECT * INTO ##TempRecords FROM #TempRecords

--GET POD2 accounts
DROP TABLE IF EXISTS #POD2
SELECT T.*
INTO #POD2
FROM #TempData T
LEFT JOIN BSegment_Primary BP WITH (NOLOCK) ON (BP.UniversalUniqueID = T.AccountUUID)
WHERE BP.UniversalUniqueID IS NULL

SELECT * FROM #TempRecords
WHERE MergeInProcessPH IS NOT NULL


DROP TABLE IF EXISTS #TempJobsToPost
SELECT acctId, AccountNumber, Amount TransactionAmount, ROW_NUMBER() OVER(PARTITION BY AccountNumber ORDER BY acctId) RowCountData
INTO #TempJobsToPost
FROM #TempRecords

SELECT * FROM #TempJobsToPost ORDER by acctId

SELECT AccountNumber, RowCountData FROM #TempJobsToPost  ORDER BY RowCountData DESC

SELECT AccountNumber, MAX(RowCountData) FROM #TempJobsToPost  GROUP BY AccountNumber ORDER BY MAX(RowCountData) DESC

SELECT MAX(RowCountData) FROM #TempJobsToPost

-- Merge Accounts

DROP TABLE IF EXISTS #NonMergedAccounts
SELECT RTRIM(AccountNumber) SourceAccountNumber, AccountUUID, ClientID SrcClientID, acctId, MergeInProcessPH, TransactionUUID, Amount TransactionAmount, TT.TransactionTime 
INTO #NonMergedAccounts
FROM #TempRecords TT
WHERE MergeInProcessPH IS NULL
ORDER BY acctID

DROP TABLE IF EXISTS #MergedAccounts
SELECT RTRIM(AccountNumber) SourceAccountNumber, AccountUUID, ClientID SrcClientID, MergeInProcessPH, Amount TransactionAmount
INTO #MergedAccounts
FROM #TempRecords TT
WHERE MergeInProcessPH IS NOT NULL
ORDER BY acctID

SELECT * FROM #NonMergedAccounts

SELECT * FROM #MergedAccounts



SELECT DestAccountNumber, AcrossPODMerge, * 
FROM LS_PRODDRGSDB01.ccgs_coreissue.dbo.MergeAccountJob MA WITH (NOLOCK) 
WHERE SrcAccountNumber = '1100011126022395'

DROP TABLE IF EXISTS #PostWithNoInterestCredit
SELECT SrcAccountNumber, DestAccountNumber AccountNumber, SrcBsAcctId, DestBSAcctId,
T1.TransactionAmount Amount, 
--MA.EndTime TranTime_ToPostOnDest, BP.DateAcctOpened DateAcctOpened_DEST, 
MA.SrcClientID, BS.ClientID DestClientID,
BP.UniversalUniqueID DestAccountUUID, SrcBSAccountUUID SrcAccountuuid--,
--MA.EndTime MergeTime
INTO #PostWithNoInterestCredit
FROM #MergedAccounts t1
LEFT JOIN LS_PRODDRGSDB01.ccgs_coreissue.dbo.MergeAccountJob MA WITH (NOLOCK) ON (T1.SourceAccountNumber = MA.SRCAccountNumber)
LEFT JOIN LS_PRODDRGSDB01.ccgs_coreissue.dbo.BSegment_Primary BP WITH (NOLOCK) ON (MA.DestAccountNumber = BP.AccountNumber )
LEFT JOIN LS_PRODDRGSDB01.ccgs_coreissue.dbo.BSegment_Secondary BS WITH (NOLOCK) ON (BS.acctId = BP.acctId)
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
LEFT JOIN LS_PRODDRGSDB01.ccgs_coreissue.dbo.MergeAccountJob MA WITH (NOLOCK) ON (T1.SourceAccountNumber = MA.SRCAccountNumber)
LEFT JOIN LS_PRODDRGSDB01.ccgs_coreissue.dbo.BSegment_Primary BP WITH (NOLOCK) ON (MA.DestAccountNumber = BP.AccountNumber )
LEFT JOIN LS_PRODDRGSDB01.ccgs_coreissue.dbo.BSegment_Secondary BS WITH (NOLOCK) ON (BS.acctId = BP.acctId)
WHERE  
--T1.SourceAccountNumber IN ('1100011127011249', '1100011139323376') AND 
T1.TranTime < BP.DateAcctOpened
ORDER BY DestAccountNumber


SELECT * FROm #PostWithNoInterestCredit

SELECT * FROm #PostWithInterestCredit


DROP TABLE IF EXISTS ##PostWithInterestCredit
SELECT * INTO ##PostWithInterestCredit FROm #PostWithInterestCredit


SELECT * FROM ##PostWithInterestCredit

/*
1100011123267431   
1100011126278526   
1100011111922096   
*/


-- CREATE INSERT SCRIPTS

SELECT 'INSERT INTO CreateNewSingleTransactionData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (' + TRY_CONVERT(VARCHAR, acctID) + ', '''+RTRIM(SourceAccountNumber)+''', ' + TRY_CONVERT(VARCHAR, TransactionAmount) + ', ''49''' + ', ''4907''' + ', ''' + TRY_CONVERT(VARCHAR(20), TransactionTime, 20) + ''')'
FROM #NonMergedAccounts
--WHERE SourceAccountNumber NOT IN ('1100011123267431', '1100011126278526', '1100011111922096')
WHERE SourceAccountNumber IN ('1100011111922096')
ORDER BY TransactionTime


SELECT 'INSERT INTO CreateNewSingleTransactionData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (' + TRY_CONVERT(VARCHAR, DestBsacctID) + ', '''+RTRIM(AccountNumber)+''', ' + TRY_CONVERT(VARCHAR, Amount) + ', ''49''' + ', ''4907'')'
FROM #PostWithNoInterestCredit



--SELECT 'INSERT INTO CreateNewSingleTransactionData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) 
--VALUES (' + TRY_CONVERT(VARCHAR, DestBsacctID) + ', '''+RTRIM(AccountNumber)+''', ' + TRY_CONVERT(VARCHAR, Amount+FINAL_INT_CR_AMT) + ', ''49''' + ', ''4913''' + ', ''' + TRY_CONVERT(VARCHAR(20), DATEADD(MINUTE, 60, TranTime_ToPostOnDest), 20) + ''')'
--FROM ##PostWithInterestCredit
--ORDER BY TranTime_ToPostOnDest

SELECT *--ClientID, AccountUUID, Amount
FROM #POD2

SELECT ClientID, AccountUUID, Amount
FROM #TempRecords

SELECT RTRIM(SourceAccountNumber) AccountNumber, AccountUUID, SrcClientID ClientID, TransactionUUID, TransactionAmount, TransactionTime
FROM #NonMergedAccounts

SELECT RTRIM(SrcAccountNumber) SrcAccountNumber, RTRIM(AccountNumber) DestAccountNumber, SrcAccountUUID, DestAccountUUID, SrcClientID, DestClientID, Amount TransactionAmount 
FROM #PostWithNoInterestCredit

--SELECT RTRIM(SrcAccountNumber) SrcAccountNumber, RTRIM(AccountNumber) DestAccountNumber, SrcAccountUUID, DestAccountUUID, SrcClientID, DestClientID, Amount TransactionAmount, 
--FINAL_INT_CR_AMT InterestCreditFromSource, Amount+FINAL_INT_CR_AMT TotalTransactionAmount
--FROM ##PostWithInterestCredit





/*

--DROP TABLE IF EXISTS #TempData
--GO
--CREATE TABLE  #TempData (SN DECIMAL(19, 0) IDENTITY(1, 1), ClientID VARCHAR(64), AccountUUID VARCHAR(64), Amount MONEY)



DROP TABLE IF EXISTS #TempData
GO
--CREATE TABLE  #TempData (SN DECIMAL(19, 0) IDENTITY(1, 1), AccountUUID VARCHAR(64), ClientID VARCHAR(64), TransactionUUID VARCHAR(64), TransactionTime DATETIME, Amount MONEY)
CREATE TABLE  #TempData (SN DECIMAL(19, 0) IDENTITY(1, 1), AccountUUID VARCHAR(64), TransactionUUID VARCHAR(64), ClientID VARCHAR(64), Amount MONEY)




INSERT INTO #TempData VALUES 
('00003a24-2d8f-4b9d-bdf8-0f284ef0e7e1', '53d44c6d-b35c-4555-b8c4-f7a3465e396f', '9304f92e-bbd7-4ccf-8e49-e7949800f8e4', 19.95),
('000cbc94-a72a-4a66-8644-aa38e5d090b2', '10160619-7d88-4235-97cb-afec588f52c5', '13d72be7-5aaa-4ca9-af75-f409c014103e', 52.99),
('000cbc94-a72a-4a66-8644-aa38e5d090b2', '32cc219f-5af0-4fbc-bf3e-bd3cd310b196', '13d72be7-5aaa-4ca9-af75-f409c014103e', 20.98),
('00112f68-4bc8-4a38-8012-d8bb5c141e10', 'b55a20f2-4a2d-44fc-9b7a-574b5066cacc', '8233269c-55e1-4ef5-b68f-5d7f2b791299', 66.71),
('0011ba5b-bd64-4e63-b234-6b2253830ac4', '31289daa-ef7f-41dc-b45a-c5d3e57f57b5', 'adeb73f7-3966-4a34-9160-cc862abcfde2', 85.46)



*/