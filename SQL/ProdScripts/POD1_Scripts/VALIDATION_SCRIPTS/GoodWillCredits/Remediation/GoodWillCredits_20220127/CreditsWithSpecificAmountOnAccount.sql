SELECT * FROM #TempData

DROP TABLE IF EXISTS #TempRecords
SELECT BP.acctId, BP.AccountNumber, BS.ClientID, BP.MergeInProcessPH, T.* 
INTO #TempRecords
FROM #TempData T
JOIN BSegment_Primary BP WITH (NOLOCK) ON (BP.UniversalUniqueID = T.AccountUUID)
JOIN BSegment_Secondary BS WITH (NOLOCK) ON (BP.acctId = BS.acctID)

--GET POD2 accounts
SELECT T.* 
--INTO #TempRecords
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
SELECT RTRIM(AccountNumber) SourceAccountNumber, AccountUUID, ClientID SrcClientID, acctId, MergeInProcessPH, Amount TransactionAmount
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
T1.TransactionAmount Amount, MA.EndTime TranTime_ToPostOnDest, BP.DateAcctOpened DateAcctOpened_DEST, MA.SrcClientID, BS.ClientID DestClientID,
BP.UniversalUniqueID DestAccountUUID, SrcBSAccountUUID SrcAccountuuid,
MA.EndTime MergeTime
INTO #PostWithNoInterestCredit
FROM #MergedAccounts t1
LEFT JOIN LS_PRODDRGSDB01.ccgs_coreissue.dbo.MergeAccountJob MA WITH (NOLOCK) ON (T1.SourceAccountNumber = MA.SRCAccountNumber)
LEFT JOIN LS_PRODDRGSDB01.ccgs_coreissue.dbo.BSegment_Primary BP WITH (NOLOCK) ON (MA.DestAccountNumber = BP.AccountNumber )
LEFT JOIN LS_PRODDRGSDB01.ccgs_coreissue.dbo.BSegment_Secondary BS WITH (NOLOCK) ON (BS.acctId = BP.acctId)
WHERE  
--T1.SourceAccountNumber IN ('1100011127011249', '1100011139323376') AND 
T1.TranTime >= BP.DateAcctOpened
ORDER BY DestAccountNumber


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


-- CREATE INSERT SCRIPTS

SELECT 'INSERT INTO CreateNewSingleTransactionData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode) VALUES (' + TRY_CONVERT(VARCHAR, acctID) + ', '''+RTRIM(SourceAccountNumber)+''', ' + TRY_CONVERT(VARCHAR, TransactionAmount) + ', ''49''' + ', ''4913'')'
FROM #NonMergedAccounts


SELECT 'INSERT INTO CreateNewSingleTransactionData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode) VALUES (' + TRY_CONVERT(VARCHAR, DestBsacctID) + ', '''+RTRIM(AccountNumber)+''', ' + TRY_CONVERT(VARCHAR, Amount) + ', ''49''' + ', ''4913'')'
FROM #PostWithNoInterestCredit



--SELECT 'INSERT INTO CreateNewSingleTransactionData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) 
--VALUES (' + TRY_CONVERT(VARCHAR, DestBsacctID) + ', '''+RTRIM(AccountNumber)+''', ' + TRY_CONVERT(VARCHAR, Amount+FINAL_INT_CR_AMT) + ', ''49''' + ', ''4913''' + ', ''' + TRY_CONVERT(VARCHAR(20), DATEADD(MINUTE, 60, TranTime_ToPostOnDest), 20) + ''')'
--FROM ##PostWithInterestCredit
--ORDER BY TranTime_ToPostOnDest

SELECT RTRIM(SourceAccountNumber) AccountNumber, AccountUUID, SrcClientID ClientID, TransactionAmount
FROM #NonMergedAccounts

SELECT RTRIM(SrcAccountNumber) SrcAccountNumber, RTRIM(AccountNumber) DestAccountNumber, SrcAccountUUID, DestAccountUUID, SrcClientID, DestClientID, Amount TransactionAmount 
FROM #PostWithNoInterestCredit

--SELECT RTRIM(SrcAccountNumber) SrcAccountNumber, RTRIM(AccountNumber) DestAccountNumber, SrcAccountUUID, DestAccountUUID, SrcClientID, DestClientID, Amount TransactionAmount, 
--FINAL_INT_CR_AMT InterestCreditFromSource, Amount+FINAL_INT_CR_AMT TotalTransactionAmount
--FROM ##PostWithInterestCredit



/*
SELECT  C.*, ROW_NUMBER() OVER (PARTITION BY C.acctId ORDER BY C.TranTime) RowNumber
--INTO #TempCommonTNP
FROM LS_PRODDRGSDB01.ccgs_coreissue.dbo.CommonTNP C WITH (NOLOCK)
JOIN LS_PRODDRGSDB01.ccgs_coreissue.dbo.CreateNewSingleTransactionData CA WITH (NOLOCK) ON (C.TranID = CA.TranID)
WHERE CA.TranTime < GETDATE() AND CA.TransmissionDateTime > '2021-10-20 11:30:26.000' AND CA.TransactionStatus = 2
AND C.acctId IN (2801034, 2550083, 556395)
ORDER BY C.acctId

UPDATE #TempCommonTNP SET TranTime = DATEADD(MINUTE, RowNumber*2, GETDATE())

SELECT * FROM #TempCommonTNP ORDER BY trantime desc

UPDATE C SET TranTime = TC.TranTime
FROM CommonTNP C 
JOIN #TempCommonTNP TC ON (C.TranID = TC.TranID)


DROP TABLE IF EXISTS #TempCommonTNP
SELECT  C.*, ROW_NUMBER() OVER (PARTITION BY C.acctId ORDER BY C.TranTime) RowNumber
--INTO #TempCommonTNP
FROM LS_PRODDRGSDB01.ccgs_coreissue.dbo.CommonTNP C WITH (NOLOCK)
JOIN LS_PRODDRGSDB01.ccgs_coreissue.dbo.CreateNewSingleTransactionData CA WITH (NOLOCK) ON (C.TranID = CA.TranID)
WHERE CA.TranTime < GETDATE() AND CA.TransmissionDateTime > '2021-10-20 11:30:26.000' AND CA.TransactionStatus = 2
ORDER BY C.TranTime

UPDATE #TempCommonTNP SET TranTime = DATEADD(SECOND, RowNumber, GETDATE())

SELECT * FROM #TempCommonTNP ORDER BY TranTime

UPDATE C SET TranTime = TC.TranTime
FROM CommonTNP C 
JOIN #TempCommonTNP TC ON (C.TranID = TC.TranID)


SELECT * INTO #TempData FROM ##TempRecords

--SELECT 26529 - 26406


SELECT '(' + TRY_CONVERT(VARCHAR, LM40.acctID) + ', '''+RTRIM(LM40.AccountNumber)+''', ' + TRY_CONVERT(VARCHAR, TT.Amount) + ', ''49''' + ', ''4913''' + ', ''' + TRY_CONVERT(VARCHAR(20), LM40.TranTime, 20) + '''),'
FROM #TempData TT
JOIN #LM40 LM40 ON (TT.TransactionUUID = LM40.TransactionUUID)
WHERE AccountNumber IN ('1100011118460637', '1100011101354102')
ORDER BY LM40.acctID


SELECT '(' + TRY_CONVERT(VARCHAR, BP.acctID) + ', '''+RTRIM(BP.AccountNumber)+''', ' + TRY_CONVERT(VARCHAR, TT.Amount) + ', ''49''' + ', ''4913''' + ', ''' + TRY_CONVERT(VARCHAR(20), TT.TranTime, 20) + '''),'
FROM #TempData TT
JOIN BSegment_Primary BP ON (BP.UniversalUniqueID = TT.AccountUUID)
--WHERE AccountNumber IN ('1100011118460637', '1100011101354102')
ORDER BY TT.TranTime


SELECT '(' + TRY_CONVERT(VARCHAR, acctID) + ', '''+RTRIM(AccountNumber)+''', ' + TRY_CONVERT(VARCHAR, Amount) + ', ''49''' + ', ''4913''' + ', ''' + TRY_CONVERT(VARCHAR(20), DATEADD(MINUTE, RowCountData*2, TranTime), 20) + '''),'
FROM #TempJobsToPost
ORDER BY TranTime


SELECT '(' + TRY_CONVERT(VARCHAR, acctID) + ', '''+RTRIM(AccountNumber)+''', ' + TRY_CONVERT(VARCHAR, Amount) + ', ''49''' + ', ''4913''' + ', ''' + TRY_CONVERT(VARCHAR(20), DATEADD(MINUTE, RowCountData*2, DATEADD(DAY, 1, TranTime)), 20) + '''),'
FROM #TempJobsToPost
ORDER BY TranTime

SELECT * FROM #TempJobsToPost ORDER BY TranTime


DROP TABLE IF EXISTS #TempJobsToPost
SELECT SrcAccountNumber, DestAccountNumber AccountNumber, DestBSAcctId acctId, ST.TransactionAmount Amount, ST.TranTime TranTime, BP.DateAcctOpened DateAcctOpened_DEST, 
MA.EndTime MergeTime, ROW_NUMBER() OVER(PARTITION BY DestAccountNumber ORDER BY ST.TranTime) RowCountData
INTO #TempJobsToPost
FROM LS_PRODDRGSDB01.ccgs_coreissue.dbo.CreateNewSingleTransactionData ST WITH (NOLOCK)
LEFT JOIN LS_PRODDRGSDB01.ccgs_coreissue.dbo.MergeAccountJob MA WITH (NOLOCK) ON (ST.AccountNumber = MA.SRCAccountNumber)
LEFT JOIN LS_PRODDRGSDB01.ccgs_coreissue.dbo.BSegment_Primary BP WITH (NOLOCK) ON (MA.DestAccountNumber = BP.AccountNumber )
WHERE ST.TransactionStatus = -2
--AND ST.AccountNumber = '1100011120177807'
AND ST.TranTime >= BP.DateAcctOpened
ORDER BY DestAccountNumber

DROP TABLE IF EXISTS #TempJobsToPost
SELECT SrcAccountNumber, DestAccountNumber AccountNumber, DestBSAcctId acctId, ST.TransactionAmount Amount, MA.EndTime TranTime, BP.DateAcctOpened DateAcctOpened_DEST, 
MA.EndTime MergeTime, ROW_NUMBER() OVER(PARTITION BY DestAccountNumber ORDER BY ST.TranTime) RowCountData
INTO #TempJobsToPost
FROM LS_PRODDRGSDB01.ccgs_coreissue.dbo.CreateNewSingleTransactionData ST WITH (NOLOCK)
LEFT JOIN LS_PRODDRGSDB01.ccgs_coreissue.dbo.MergeAccountJob MA WITH (NOLOCK) ON (ST.AccountNumber = MA.SRCAccountNumber)
LEFT JOIN LS_PRODDRGSDB01.ccgs_coreissue.dbo.BSegment_Primary BP WITH (NOLOCK) ON (MA.DestAccountNumber = BP.AccountNumber )
WHERE ST.TransactionStatus = -2
--AND ST.AccountNumber = '1100011120177807'
AND ST.TranTime < BP.DateAcctOpened
ORDER BY DestAccountNumber


DROP TABLE IF EXISTS #TempJobsToPost
SELECT TxnAcctId acctId, AccountNumber, TranTime, TransactionAmount, ROW_NUMBER() OVER(PARTITION BY AccountNumber ORDER BY TranTime) RowCountData
INTO #TempJobsToPost
FROM LS_PRODDRGSDB01.ccgs_coreissue.dbo.CreateNewSingleTransactionData WITH (NOLOCK)
WHERE TransactionStatus = 0

DROP TABLE IF EXISTS #TempJobsToPost
SELECT acctId, AccountNumber, TranTime, TransactionAmount, ROW_NUMBER() OVER(PARTITION BY AccountNumber ORDER BY TranTime) RowCountData
INTO #TempJobsToPost
FROM #TempData

SELECT * FROM #TempJobsToPost ORDER by acctId

SELECT AccountNumber, RowCountData FROM #TempJobsToPost  ORDER BY RowCountData DESC

SELECT AccountNumber, MAX(RowCountData) FROM #TempJobsToPost  GROUP BY AccountNumber ORDER BY MAX(RowCountData) DESC

SELECT MAX(RowCountData) FROM #TempJobsToPost


SELECT acctId, AccountNumber, TranTime, Amount, ROW_NUMBER() OVER(PARTITION BY AccountNumber ORDER BY TranTime) RowCountData
INTO #TempJobsToPost
FROM #TempData TT
JOIN BSegment_Primary BP ON (BP.UniversalUniqueID = TT.AccountUUID)
--WHERE AccountNumber IN ('1100011118460637', '1100011101354102')
ORDER BY BP.acctID



SELECT 'INSERT INTO CreateNewSingleTransactionData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (' + TRY_CONVERT(VARCHAR, acctID) + ', '''+RTRIM(AccountNumber)+''', ' + TRY_CONVERT(VARCHAR, TransactionAmount) + ', ''49''' + ', ''4913''' + ', ''' + TRY_CONVERT(VARCHAR(20), TranTime, 20) + ''')'
FROM #TempJobsToPost
WHERE RowCountData > 1
ORDER BY TranTime

SELECT 'INSERT INTO CreateNewSingleTransactionData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (' + TRY_CONVERT(VARCHAR, acctID) + ', '''+RTRIM(AccountNumber)+''', ' + TRY_CONVERT(VARCHAR, TransactionAmount) + ', ''49''' + ', ''4913''' + ', ''' + TRY_CONVERT(VARCHAR(20), TranTime, 20) + ''')'
FROM #TempJobsToPost
WHERE 
(RowCountData = 1
AND acctId IN (2247889,470573,4254921,291852,2353047,2457310,1019312,5633388,2598401,359849,1367553,8525697,5028208,2025752,5685348,914717,2764544,
1050924,  1947374, 2385510, 1523960, 2162743, 120062, 1859845))
OR RowCountData > 1
ORDER BY TranTime

SELECT 'INSERT INTO CreateNewSingleTransactionData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (' + TRY_CONVERT(VARCHAR, TxnacctID) + ', '''+RTRIM(AccountNumber)+''', ' + TRY_CONVERT(VARCHAR, TransactionAmount) + ', ''49''' + ', ''4913''' + ', ''' + TRY_CONVERT(VARCHAR(20), TranTime, 20) + ''')'
FROM LS_PRODDRGSDB01.ccgs_coreissue.dbo.CreateNewSingleTransactionData WITH (NOLOCK)
WHERE TransactionStatus = -2
ORDER BY TranTime


SELECT '(' + TRY_CONVERT(VARCHAR, LM40.acctID) + ', '''+RTRIM(LM40.AccountNumber)+''', ' + TRY_CONVERT(VARCHAR, TT.Amount) + ', ''49''' + ', ''4913''' + ', ''' + TRY_CONVERT(VARCHAR(20), LM40.TranTime, 20) + '''),'
, ROW_NUMBER() OVER(PARTITION BY AccountNumber ORDER BY LM40.TranTime) RowCountData
FROM #TempData TT
JOIN #LM40 LM40 ON (TT.TransactionUUID = LM40.TransactionUUID)
ORDER BY LM40.acctID



SELECT *
FROM LS_PRODDRGSDB01.ccgs_coreissue.dbo.CreateNewSingleTransactionData WITH (NOLOCK)
WHERE TransactionStatus = -2 AND TranID IS NULL
ORDER BY TranTime




SELECT RTRIM(AccountNumber) AccountNumber, TT.TransactionUUID TransactionID, TT.Amount TransactionAmount, TranTime TransactionTime
FROM #TempData TT
JOIN #LM40 LM40 ON (TT.TransactionUUID = LM40.TransactionUUID)
WHERE AccountNumber IN ('1100011118460637', '1100011101354102')
ORDER BY LM40.acctID

SELECT RTRIM(BP.AccountNumber) AccountNumber, TT.TransactionUUID TransactionID, TT.Amount TransactionAmount, TranTime TransactionTime
FROM #TempData TT
JOIN BSegment_Primary BP ON (BP.UniversalUniqueID = TT.AccountUUID)
--WHERE AccountNumber IN ('1100011118460637', '1100011101354102')
ORDER BY BP.acctID



SELECT RTRIM(BP.AccountNumber) AccountNumber, MergeInProcessPH, TransactionLifeCycleUniqueID, TT.Amount TransactionAmount, TranTime TransactionTime
FROM #TempData TT
JOIN BSegment_Primary BP ON (BP.UniversalUniqueID = TT.AccountUUID)
WHERE MergeInProcessPH IS NOT NULL
ORDER BY BP.acctID

SELECT * FROM #TempData WHERE TranSactionUUID ='dc97d515-7c96-4a71-ab6f-fd859b05b92f'

SELECT * FROM ##TempData

SELECT * 
FROM ##TempData T1
JOIN #TempData T2 ON (T1.TransactionLifeCycleUniqueID = T2.TransactionLifeCycleUniqueID)
WHERE T1.TransactionAmount <> T2.Amount

DROP TABLE IF EXISTS #LM40
;WITH CTE AS (
SELECT *, ROW_NUMBER() OVER(PARTITION BY transactionuuid ORDER BY TranTime DESC) Ranking  
FROM ##TempData
WHERE CMTTRanType = '40')
SELECT * INTO #LM40 FROM CTE WHERE Ranking = 1

SELECT * FROM #LM40


SELECT TT.*  INTO #NotFindTxn
FROM #TempDAta TT
LEFT JOIN #LM40 LM40 ON (TT.TransactionUUID = LM40.TransactionUUID)
WHERE LM40.TransactionUUID IS NULL

SELECT * FROM #NotFindTxn

DROP TABLE IF EXISTS ##TempRecords
SELECT * INTO ##TempRecords FROM #TempData

SELECT * FROM #TempData WHERE AccountUUID = 'a0adc4b3-5c19-4bba-be6c-3b5be63d69b1'

SELECT * FROM #TempData WHERE TransactionLifeCycleUniqueID = 416247376

SELECT * FROM #TempData WHERE TransactionLifeCycleUniqueID IS NULL

SELECT * FROM ##TempDataAuth WHERE TransactionUUID = 'dc97d515-7c96-4a71-ab6f-fd859b05b92f'

SELECT DISTINCT TransactionLifeCycleUniqueID, AccountUUID FROM #TempData

WITH CTE AS (
SELECT *, ROW_NUMBER() OVER (PARTITION BY TransactionLifeCycleUniqueID ORDER BY TranTime ) RowCounter
FROM #TempData )
SELECT * FROM CTE WHERE RowCounter > 1

SELECT * 
FROM ##TempDataAccount TA
JOIN #TempData TD ON (TA.UniversalUniqueID = TD.AccountUUID)
WHERE TD.AccountUUID = '2884faa2-494e-4dfa-82df-5c5196e82450'
AND TA.TransactionUUID = '30ba23dc-4352-49b8-b175-1e7c1898443f'


SELECT * 
FROM ##TempDataAuth TA
JOIN #TempData TD ON (TA.UniversalUniqueID = TD.AccountUUID)
WHERE TD.AccountUUID = 'a0adc4b3-5c19-4bba-be6c-3b5be63d69b1'
AND TA.TransactionUUID = 'dc97d515-7c96-4a71-ab6f-fd859b05b92f'
--AND TransactionAmount = 1.22

--330486177

SELECT * FROM CCArd_Primary WITH (NOLOCK) WHERE TransactionLifeCycleUniqueID = 330486177



/*

DROP TABLE IF EXISTS #TempData
GO
CREATE TABLE  #TempData (AccountUUID VARCHAR(64), Amount MONEY)


INSERT INTO #TempData VALUES ('000aca1f-8638-40ef-a17f-05e62af69c9a', 30.00)
INSERT INTO #TempData VALUES ('00369456-300e-4f50-828a-6044758bdb50', 30.00)
INSERT INTO #TempData VALUES ('008c17b7-07d2-4eef-9ae7-8e36d20b4e72', 30.00)
INSERT INTO #TempData VALUES ('009dfcfa-4d34-466d-a97b-e47aa2d20fba', 30.00)
INSERT INTO #TempData VALUES ('00ac1ed0-38ab-4748-95da-fdbd36e18aec', 30.00)
INSERT INTO #TempData VALUES ('00acf9f2-a9b4-47ed-b5a3-ef2580d42b94', 30.00)
INSERT INTO #TempData VALUES ('00bab4a5-d4a8-45dd-baf7-0cdc98b58b6a', 32.80)
INSERT INTO #TempData VALUES ('00d0388e-b0b9-4fcf-9a5e-ab43d2727136', 30.00)
INSERT INTO #TempData VALUES ('00fe877c-f20e-430d-a11a-a68518a24ebe', 30.00)
INSERT INTO #TempData VALUES ('011b9f64-7e01-4a06-af00-ac5dd119a516', 30.00)
INSERT INTO #TempData VALUES ('01355dff-951b-4150-ba48-9aa29fdb1ac2', 30.00)
INSERT INTO #TempData VALUES ('01774645-71a4-4c97-ada1-886b951eb6cf', 30.00)
INSERT INTO #TempData VALUES ('01d3ed78-b2e7-4289-be86-cbf3dbc585a7', 30.00)
INSERT INTO #TempData VALUES ('0220fd67-3e00-4687-8b06-38382e9b81eb', 30.00)
INSERT INTO #TempData VALUES ('0242bc87-9ca9-4d70-aa4f-71bea9bb4fd3', 30.00)
INSERT INTO #TempData VALUES ('02614fa9-2fa6-4ac4-a801-75a93a1121ab', 30.00)
INSERT INTO #TempData VALUES ('03167b64-7386-4031-833f-945fe5c909aa', 56.50)
INSERT INTO #TempData VALUES ('0324815e-3992-4ae1-9ad0-c7554428d6c6', 30.00)
INSERT INTO #TempData VALUES ('034dd656-9a98-4a69-9e96-3f4193a8f29f', 53.55)
INSERT INTO #TempData VALUES ('035b448f-8aef-4a2c-99ab-ea6f44a77d58', 30.00)
INSERT INTO #TempData VALUES ('0382a2d5-328b-4d66-913a-9d3724e28071', 30.00)
INSERT INTO #TempData VALUES ('03a12938-a4c7-4102-b031-ab983a156446', 30.00)
INSERT INTO #TempData VALUES ('03dab7ec-58d4-4a8e-9142-d5f0a16d96c6', 30.00)
INSERT INTO #TempData VALUES ('040f2933-73d6-4079-8772-9f975ffe5d5f', 30.00)
INSERT INTO #TempData VALUES ('041850b5-1af2-4c19-b8dc-d374bb784102', 30.00)
INSERT INTO #TempData VALUES ('041d1bf7-6cb6-47a4-9199-f38fc1081019', 30.00)
INSERT INTO #TempData VALUES ('049a7a47-590a-426e-90dd-884f3bcf2dcb', 30.00)
INSERT INTO #TempData VALUES ('049ef406-2395-482c-b745-ad35f04fbccf', 30.00)
INSERT INTO #TempData VALUES ('04f31039-64fe-450a-b8ba-0747137399db', 51.39)
INSERT INTO #TempData VALUES ('05155a7b-936f-4d47-bee3-b0b71f6b6657', 30.00)
INSERT INTO #TempData VALUES ('052b276c-475d-4b66-a789-1c0201377043', 75.98)
INSERT INTO #TempData VALUES ('05e2eac1-3af6-47c9-81c2-b00be5c02ccb', 30.00)
INSERT INTO #TempData VALUES ('05ea8140-2d38-4c6c-8a0c-3481a4aaebb6', 30.00)
INSERT INTO #TempData VALUES ('0621cc31-6708-48e5-ad17-45fa4cefcc70', 30.00)
INSERT INTO #TempData VALUES ('06966deb-24ea-4d2e-9677-fe9f36e2f88e', 30.00)
INSERT INTO #TempData VALUES ('078ab8e6-7dd4-4b80-af41-5c579c68eb2a', 30.00)
INSERT INTO #TempData VALUES ('07b78a27-cd7e-40c8-849b-ca4b0da78825', 30.00)
INSERT INTO #TempData VALUES ('07e1d773-3a51-4b71-906a-0233d2353a64', 30.00)
INSERT INTO #TempData VALUES ('07e32915-e62b-42a0-a18f-8422be8b764b', 30.00)
INSERT INTO #TempData VALUES ('07ffc4da-8b2a-4f25-b0f2-fbff41f09e17', 30.00)
INSERT INTO #TempData VALUES ('088d8e54-225d-494b-8755-a0a80fcf9507', 30.00)
INSERT INTO #TempData VALUES ('08f20014-1004-480b-a9dc-81b8757dd4ff', 74.65)
INSERT INTO #TempData VALUES ('091062ec-4d8d-4886-a4b4-52efa3834a04', 30.00)
INSERT INTO #TempData VALUES ('09435bed-bf3f-4597-aa0e-b18a3cf6c793', 30.00)
INSERT INTO #TempData VALUES ('0962a7d7-75eb-434a-995f-7e5c1be59471', 30.00)
INSERT INTO #TempData VALUES ('09795b38-eea4-420a-9464-c5f5297967d6', 67.70)
INSERT INTO #TempData VALUES ('098e8da2-33a5-475a-bbef-95e40313843f', 30.00)
INSERT INTO #TempData VALUES ('0990c021-0836-43bb-90f0-5b5f8e39fb86', 30.00)
INSERT INTO #TempData VALUES ('099afcd8-e544-4bdb-a9a2-17e943fbd890', 30.00)
INSERT INTO #TempData VALUES ('09deff49-6437-40f9-b29b-562bbb292310', 287.90)
INSERT INTO #TempData VALUES ('09e3b39b-8a2c-4cba-ae5a-fc871d6b6d11', 33.00)
INSERT INTO #TempData VALUES ('0a0d9ff3-5477-4514-b819-a3cf7f64d779', 30.00)
INSERT INTO #TempData VALUES ('0a430eae-acf3-42ef-b9d7-208ff7d1bdad', 30.00)
INSERT INTO #TempData VALUES ('0a8ab533-ddbc-4271-aa1f-97a45a196764', 30.00)
INSERT INTO #TempData VALUES ('0a9a80fe-a6b6-4aef-97f9-208751a7472b', 32.59)
INSERT INTO #TempData VALUES ('0aa6466a-ef7d-4346-a8ee-c97c6cfa687c', 30.00)
INSERT INTO #TempData VALUES ('0ab3b8da-eed0-4c32-9303-067be4fbbd6c', 30.00)
INSERT INTO #TempData VALUES ('0ac215e8-b4b6-4adf-97d6-26531e4f1033', 30.00)
INSERT INTO #TempData VALUES ('0ad9e265-1bb5-4c82-804d-4af07afcf968', 111.23)
INSERT INTO #TempData VALUES ('0afd6398-9645-41f4-8007-d86d41e60d9e', 30.00)
INSERT INTO #TempData VALUES ('0b44a5d8-5842-4cc1-905b-de5248c076be', 30.00)
INSERT INTO #TempData VALUES ('0b88e541-975b-472e-ac89-b8a52d5e3b6d', 85.79)
INSERT INTO #TempData VALUES ('0ba04ba1-c188-45c3-9a8f-1794ea776c98', 30.00)
INSERT INTO #TempData VALUES ('0bcb9e77-435f-4ed1-997f-bbf2e45df024', 30.00)
INSERT INTO #TempData VALUES ('0c0d652e-de3b-467d-ae00-f48a762f45ed', 30.00)
INSERT INTO #TempData VALUES ('0c276b04-4dd6-45b6-aab5-2baf979cd166', 30.00)
INSERT INTO #TempData VALUES ('0c2bd573-7f51-48e0-8e51-fed0bbcc82b9', 30.00)
INSERT INTO #TempData VALUES ('0d25b998-99f3-43fe-8612-89ea301995db', 30.00)
INSERT INTO #TempData VALUES ('0d5de97f-2319-4dca-865f-83a5a0b26bd8', 30.00)
INSERT INTO #TempData VALUES ('0d867f4a-69bf-430c-ba92-b5d4ea988e55', 30.00)
INSERT INTO #TempData VALUES ('0d9647d6-3da4-45f8-8b8f-063d35fb50e6', 30.00)
INSERT INTO #TempData VALUES ('0df5679f-9a97-4d46-bed0-2ecafb188a2f', 30.00)
INSERT INTO #TempData VALUES ('0e06df15-f78a-4052-ad40-6428c386d09c', 30.00)
INSERT INTO #TempData VALUES ('0e257173-09bc-41cf-8846-30510c0569cb', 50.88)
INSERT INTO #TempData VALUES ('0e8a95d4-f154-4a0d-b37c-c551e23d8958', 30.00)
INSERT INTO #TempData VALUES ('0e977959-0679-4ca1-affd-18169bc4c0d2', 30.00)
INSERT INTO #TempData VALUES ('0ea434de-c5d5-432e-aad9-ca618113a6aa', 30.00)
INSERT INTO #TempData VALUES ('0ec29168-088c-43d3-a599-36b76ff22ea8', 30.00)
INSERT INTO #TempData VALUES ('0f11f4a0-04d6-47a1-90d4-adec3800a1e3', 30.00)
INSERT INTO #TempData VALUES ('0f36200f-d0ee-4ae4-91b6-18e902457ea6', 30.00)
INSERT INTO #TempData VALUES ('0f45c677-77c7-43d4-a655-c693dba33345', 30.00)
INSERT INTO #TempData VALUES ('0f7892a3-4250-453e-b3eb-3a6b875dce89', 30.00)
INSERT INTO #TempData VALUES ('1007719f-0cfd-41bf-96d3-a1ed9be3316c', 30.00)
INSERT INTO #TempData VALUES ('10492528-b929-449f-bc18-1e6d3897fc60', 30.00)
INSERT INTO #TempData VALUES ('10637599-610f-4673-b6e8-ace50f0559fa', 30.00)
INSERT INTO #TempData VALUES ('10abe587-aa50-4321-b3d7-d15e3796575d', 30.00)
INSERT INTO #TempData VALUES ('10b45fd0-b7a9-4e91-9397-9a9ad186aa04', 60.00)
INSERT INTO #TempData VALUES ('1121e8f8-6180-47e5-96ce-0349d3cc261c', 30.00)
INSERT INTO #TempData VALUES ('11265e35-c6dc-404c-b6de-68f7bf5b8acd', 30.00)
INSERT INTO #TempData VALUES ('1146d2eb-3d47-447b-9196-f72e0046d5d1', 30.07)
INSERT INTO #TempData VALUES ('1165b925-e334-4ce7-b485-61b4dc26eb8b', 30.00)
INSERT INTO #TempData VALUES ('11c73db7-b332-4c63-8ccc-c082aad251d3', 103.32)
INSERT INTO #TempData VALUES ('11f994cb-2f37-4ea5-a5e0-e7323f95cf37', 30.00)
INSERT INTO #TempData VALUES ('1249da03-78e7-4673-b3ce-470f45736fe6', 30.00)
INSERT INTO #TempData VALUES ('124a52db-b3c9-426c-b70b-890c39e7ca3f', 31.43)
INSERT INTO #TempData VALUES ('1260223f-7096-4309-9912-c4ce92451f1f', 30.00)
INSERT INTO #TempData VALUES ('12bce542-696a-4b1f-a37d-983af1d4a06a', 30.00)
INSERT INTO #TempData VALUES ('13091c2c-71a4-45c9-9d59-e354a6e76f87', 30.00)
INSERT INTO #TempData VALUES ('133085e9-4e5b-4fb4-8397-ed01b8320cbe', 30.00)
INSERT INTO #TempData VALUES ('13a8a10d-3b6e-4b16-a88a-a0c08d1eb94d', 30.00)
INSERT INTO #TempData VALUES ('13bbd551-6355-4301-990c-048ab6caddb4', 30.00)
INSERT INTO #TempData VALUES ('13be2afc-42a9-45a6-a4b2-52352bffa24d', 30.00)
INSERT INTO #TempData VALUES ('13d419c6-4904-4ee7-944c-44d0b5537d58', 30.00)
INSERT INTO #TempData VALUES ('143a729a-bc79-4b68-830d-c4af60704c2e', 30.00)
INSERT INTO #TempData VALUES ('144e064e-afcd-4989-a136-60a0a21ff1d8', 30.00)
INSERT INTO #TempData VALUES ('145fb034-93d7-4426-bfe2-b0e32dedc457', 33.38)
INSERT INTO #TempData VALUES ('148bd144-4dcb-4cb5-8314-20afd74f06d2', 30.00)
INSERT INTO #TempData VALUES ('14963e14-97f2-45ed-80d9-76571f122d81', 30.00)
INSERT INTO #TempData VALUES ('151e7617-57ed-49c0-9a25-79d565b21086', 30.00)
INSERT INTO #TempData VALUES ('152faee6-2a01-4da2-964d-e111ec1e9eb1', 30.00)
INSERT INTO #TempData VALUES ('15d02d1b-03de-4262-bfc7-040c18059771', 30.00)
INSERT INTO #TempData VALUES ('15ddb414-1c48-48b2-a9e8-c7a0858c4c06', 30.00)
INSERT INTO #TempData VALUES ('15e23d33-9521-4e6d-8251-e095e0000b36', 30.00)
INSERT INTO #TempData VALUES ('15ef99f8-d3b0-4ebb-88f8-525ef6a7c8c6', 129.21)
INSERT INTO #TempData VALUES ('160627ab-d554-4246-b8ad-5208550f0b03', 30.00)
INSERT INTO #TempData VALUES ('164446b8-3cb1-4bdc-8994-e17d7e513611', 81.26)
INSERT INTO #TempData VALUES ('169a96b7-07a7-4c4e-be1a-fb3c1af64a76', 30.00)
INSERT INTO #TempData VALUES ('16ceb76a-3848-491a-a593-43dbc596d14f', 30.00)
INSERT INTO #TempData VALUES ('171d7fd6-97cf-4481-9323-1475f4096094', 30.00)
INSERT INTO #TempData VALUES ('17252ee3-6f5f-4ec1-852a-882d42e97e65', 61.03)
INSERT INTO #TempData VALUES ('1765770f-452d-4d5d-91e7-6fb7df1c904e', 47.71)
INSERT INTO #TempData VALUES ('17b7e435-bcef-4cdf-8bd0-616966c0bae5', 60.00)
INSERT INTO #TempData VALUES ('17d20f4a-c056-4679-aaf9-797add9d4850', 30.00)
INSERT INTO #TempData VALUES ('17f8568f-e1f5-4d95-984d-30f057e443a3', 107.19)
INSERT INTO #TempData VALUES ('181e6923-eb60-400f-94f6-13f0bece132d', 30.00)
INSERT INTO #TempData VALUES ('184ede80-225e-4052-9820-ad10a62e5768', 30.00)
INSERT INTO #TempData VALUES ('18706694-640a-43b8-9db1-1afb24ef9a6f', 30.00)
INSERT INTO #TempData VALUES ('18aecc0c-882d-4c4b-876f-787a88965ad6', 30.00)
INSERT INTO #TempData VALUES ('18ec3289-7065-44a2-a628-6bcdcb72d0bb', 30.00)
INSERT INTO #TempData VALUES ('1917739c-27cf-436c-ac40-f213c826d910', 30.00)
INSERT INTO #TempData VALUES ('19239d1d-4515-4755-9042-f2d4fe89a38e', 30.00)
INSERT INTO #TempData VALUES ('1935f123-148f-4610-9bb9-07cd799963d4', 40.76)
INSERT INTO #TempData VALUES ('19fff472-fe25-44f6-9a97-343bc71b5e80', 30.00)
INSERT INTO #TempData VALUES ('1a12b029-eaad-4c32-8773-3f6d29a35a6a', 30.00)
INSERT INTO #TempData VALUES ('1a57932d-5538-41d0-89d5-61b7fb8a68aa', 30.00)
INSERT INTO #TempData VALUES ('1a59ff1e-f0c6-4518-b478-3a364d094308', 30.00)
INSERT INTO #TempData VALUES ('1a6c1181-4916-4273-aed3-f192fb68b253', 30.00)
INSERT INTO #TempData VALUES ('1a8a1c1b-7c1c-4f16-b7ae-b5e59dc3d391', 30.00)
INSERT INTO #TempData VALUES ('1ac993e1-ae70-4969-bf49-f65cce2612a2', 30.00)
INSERT INTO #TempData VALUES ('1aea249c-e215-4420-9ef4-3556db313a37', 30.00)
INSERT INTO #TempData VALUES ('1b3aa2aa-fc5d-41d4-86f5-53f08d4c198b', 30.00)
INSERT INTO #TempData VALUES ('1b49037e-16ca-4cfe-97cb-95892fd0b672', 30.00)
INSERT INTO #TempData VALUES ('1b5b8590-414f-4378-b302-385ef4dd854b', 30.00)
INSERT INTO #TempData VALUES ('1b712121-df3f-4580-ab78-ea52a49a23ad', 50.17)
INSERT INTO #TempData VALUES ('1c309ad3-dc8e-4bce-b4cc-41c397188a37', 30.00)
INSERT INTO #TempData VALUES ('1c3e6008-16ee-475d-bb4a-e4adc8296cf6', 30.00)
INSERT INTO #TempData VALUES ('1c5587fd-85f5-4b98-9f1b-34aa60f7857b', 30.00)
INSERT INTO #TempData VALUES ('1c9cd2dd-fe22-46b9-a912-c90eefb93d97', 30.00)
INSERT INTO #TempData VALUES ('1cbda318-a052-466f-b7dd-f9c99cc1a7ce', 943.72)
INSERT INTO #TempData VALUES ('1cda8c1c-2832-4cd4-a3c9-25ee6f7d7583', 30.00)
INSERT INTO #TempData VALUES ('1cf74815-93db-4e02-8dda-a90f6aa19997', 30.00)
INSERT INTO #TempData VALUES ('1d0c9d4b-f414-452d-82e7-84ea19a07be2', 60.00)
INSERT INTO #TempData VALUES ('1d0e4a70-7cf1-4e6d-9af3-4969c7aa908d', 30.00)
INSERT INTO #TempData VALUES ('1d442cb9-9d8d-4800-acee-9c9939098a10', 30.00)
INSERT INTO #TempData VALUES ('1d563721-9878-4222-841d-e93fbe446cf2', 30.00)
INSERT INTO #TempData VALUES ('1d5df5b7-64ea-46bc-bb54-df1d832b0cb8', 109.95)
INSERT INTO #TempData VALUES ('1d930034-0857-4871-825d-c77a7b2b986e', 30.00)
INSERT INTO #TempData VALUES ('1d94cb52-aee1-46ed-ae66-30ff6f802e43', 30.00)
INSERT INTO #TempData VALUES ('1dcbc77d-e584-491d-a835-4c9f365f0259', 30.00)
INSERT INTO #TempData VALUES ('1dcc0d2f-d39d-4c73-b881-eda539208ac6', 32.17)
INSERT INTO #TempData VALUES ('1e49467f-0ee6-44df-a47e-e20bb23d0e35', 30.00)
INSERT INTO #TempData VALUES ('1e56b12d-c47f-4d22-8798-bf4150e36771', 30.00)
INSERT INTO #TempData VALUES ('1e6537b2-1736-4c3c-b22a-7d5c4897a08c', 30.00)
INSERT INTO #TempData VALUES ('1f59435b-0bd2-49e4-bbf3-c700ae402f76', 30.00)
INSERT INTO #TempData VALUES ('1f9e5f8b-805f-4ee8-9a6a-d6c731f095cd', 30.00)
INSERT INTO #TempData VALUES ('1fd45212-4d68-4187-ab02-7755f2378b6b', 30.00)
INSERT INTO #TempData VALUES ('20e250fa-7741-4bca-965f-44d0a77b208a', 45.25)
INSERT INTO #TempData VALUES ('21299d27-239d-4b04-bbb3-59613221d53d', 30.00)
INSERT INTO #TempData VALUES ('2163e8fa-e142-4bf4-b27a-c567a88d50a4', 30.00)
INSERT INTO #TempData VALUES ('216d514a-c070-4db6-b38b-ca76b1875f36', 30.00)
INSERT INTO #TempData VALUES ('2174862b-d94e-49b2-b0c8-5aae428291e6', 102.41)
INSERT INTO #TempData VALUES ('21a78b39-f59e-49dd-a8ad-3078ae6b084a', 30.00)
INSERT INTO #TempData VALUES ('21fcb839-5fd1-47d0-a732-ad165eeb6b8e', 30.00)
INSERT INTO #TempData VALUES ('21ffed7e-6aae-4688-b2b5-8716fa3fc266', 54.99)
INSERT INTO #TempData VALUES ('227681dc-b05d-4bd5-beaa-50bc20d27be6', 30.00)
INSERT INTO #TempData VALUES ('22db767d-3701-4b17-a5e9-efcfe7da1ffe', 30.00)
INSERT INTO #TempData VALUES ('22e06426-c18e-43c1-a36f-05d564d2099f', 30.00)
INSERT INTO #TempData VALUES ('22e19efa-2541-4628-b9d2-5c61402ddf1d', 30.00)
INSERT INTO #TempData VALUES ('2314f65a-7a35-491e-a296-df0dc6020797', 30.00)
INSERT INTO #TempData VALUES ('238189dc-ae7e-48bc-ab87-476017c87e65', 30.00)
INSERT INTO #TempData VALUES ('23aa10c5-9804-4244-9d41-15dd42c7d4b0', 30.00)
INSERT INTO #TempData VALUES ('23e63502-8a62-4c1e-871f-87a57d2a184d', 101.63)
INSERT INTO #TempData VALUES ('23f71941-39d6-4bc6-9fdf-f7d4c88a71a9', 30.00)
INSERT INTO #TempData VALUES ('2431bbc2-7bac-4dc9-a799-f68e85a7e0d2', 91.79)
INSERT INTO #TempData VALUES ('24491983-c0d4-4d1d-a51f-2647a9dd7cc4', 30.00)
INSERT INTO #TempData VALUES ('2494a7e3-7406-4ac4-840a-547dcc3fb29d', 30.00)
INSERT INTO #TempData VALUES ('249832e5-0323-4819-a008-84d1427c8ede', 37.52)
INSERT INTO #TempData VALUES ('24a718f4-ad84-43cd-a47d-026335d88f9c', 30.00)
INSERT INTO #TempData VALUES ('24d78553-1940-44e1-b406-97e4dcdb67df', 60.00)
INSERT INTO #TempData VALUES ('253699aa-9a3f-4584-b666-ff3499088b1f', 30.00)
INSERT INTO #TempData VALUES ('25545e25-db76-480c-8fa9-30908781e4b3', 30.00)
INSERT INTO #TempData VALUES ('25718778-6e42-42c0-b484-50b3eea5e549', 30.00)
INSERT INTO #TempData VALUES ('25a0bc6d-e23e-47ce-bb4e-bb2d327770a1', 30.00)
INSERT INTO #TempData VALUES ('25d41211-adbf-459b-b849-a654cf20aac4', 30.00)
INSERT INTO #TempData VALUES ('263f3474-0164-4278-87b3-9826b8c46d7c', 30.00)
INSERT INTO #TempData VALUES ('26b89a0b-0486-479e-a628-dabdc15167fd', 30.00)
INSERT INTO #TempData VALUES ('26c792fd-1afb-4747-800c-605140b8bed2', 30.00)
INSERT INTO #TempData VALUES ('26cbad75-da5f-4a87-bc03-9126a43a2a19', 30.00)
INSERT INTO #TempData VALUES ('2734ac91-55e1-4360-aa7d-fbd7988cbb18', 30.00)
INSERT INTO #TempData VALUES ('2735f4f2-ff2b-4735-995b-b4d7a51ca215', 30.00)
INSERT INTO #TempData VALUES ('27409d4a-5f44-4ccb-bde8-d1ca8ac8e4ba', 30.00)
INSERT INTO #TempData VALUES ('2817f564-3e49-44b7-86b5-9b53f4104307', 30.00)
INSERT INTO #TempData VALUES ('283c7583-d141-48ac-a015-f6445e0b0921', 30.00)
INSERT INTO #TempData VALUES ('285b68c3-547a-436e-931e-974b4fa11ed9', 30.00)
INSERT INTO #TempData VALUES ('29134916-8b97-428e-8e85-5ad25d597405', 40.61)
INSERT INTO #TempData VALUES ('2913e0d9-231e-4948-aba2-1c777643d5bc', 30.00)
INSERT INTO #TempData VALUES ('2945c7a2-4a8a-4163-a6f8-5553c66ed12a', 30.00)
INSERT INTO #TempData VALUES ('29f2d03b-011c-48fd-bbb0-9d078280f3af', 60.00)
INSERT INTO #TempData VALUES ('2a6e06a7-a417-4c03-aac2-e580394dfd35', 385.24)
INSERT INTO #TempData VALUES ('2a882b64-153a-4c83-a2a5-ef6a07afed09', 30.00)
INSERT INTO #TempData VALUES ('2a9044ea-3f00-475a-88a4-4d6e86480502', 30.00)
INSERT INTO #TempData VALUES ('2b12c553-2e7f-4be1-b7be-d6897586786c', 30.00)
INSERT INTO #TempData VALUES ('2b22f45f-bf1a-4e85-a87f-10b197a694e6', 30.00)
INSERT INTO #TempData VALUES ('2b8810db-5d89-476b-9a34-0ee99d43af14', 30.00)
INSERT INTO #TempData VALUES ('2b9cd643-30f1-4574-a6d6-51e7b08e7811', 30.00)
INSERT INTO #TempData VALUES ('2bf6f8a8-f669-4838-a574-31c4aa7649cd', 30.00)
INSERT INTO #TempData VALUES ('2c17b42e-fcff-4fe5-989c-29d2e9751ca2', 30.00)
INSERT INTO #TempData VALUES ('2c4ba5e4-9ea9-4122-8d07-c27fd2f273e8', 30.00)
INSERT INTO #TempData VALUES ('2c9a6823-b59e-4ddf-989c-990d70f72846', 30.00)
INSERT INTO #TempData VALUES ('2d12b7cf-8c13-4270-aff6-9fb38cafcd68', 30.00)
INSERT INTO #TempData VALUES ('2d1773ef-9bef-4521-851e-141efaa2fadc', 30.00)
INSERT INTO #TempData VALUES ('2d44292d-d5fc-4e91-9496-14d8bb1df807', 30.00)
INSERT INTO #TempData VALUES ('2d653534-9e14-4f6e-9553-ee70a4662e63', 30.00)
INSERT INTO #TempData VALUES ('2d658b81-f761-4213-9c30-7786390c566f', 30.00)
INSERT INTO #TempData VALUES ('2d6c692d-bd53-437a-a8ff-fcc6f60f2e1d', 30.00)
INSERT INTO #TempData VALUES ('2d9b8e10-6858-413d-96bd-3a8e2aa0e083', 30.00)
INSERT INTO #TempData VALUES ('2dafb8de-a9fc-4d9b-983e-2481739b020a', 30.00)
INSERT INTO #TempData VALUES ('2dcbe982-2a3e-451e-ba50-9cde0943ef54', 30.00)
INSERT INTO #TempData VALUES ('2e01d4a2-69dd-49d4-bc78-9272a981c430', 30.00)
INSERT INTO #TempData VALUES ('2eaad2cd-11f8-4393-81e2-de3b4d32c563', 71.23)
INSERT INTO #TempData VALUES ('2efd2da3-48d0-43ae-ae2d-2394bef2df68', 30.00)
INSERT INTO #TempData VALUES ('2f03b354-ba44-416c-aaaa-e58c33195fb2', 30.00)
INSERT INTO #TempData VALUES ('2f3dd790-5ec3-42d7-85fa-4a19f46c4a10', 30.00)
INSERT INTO #TempData VALUES ('2f7d8045-90f0-48c9-95bc-7ccc02c1e039', 30.00)
INSERT INTO #TempData VALUES ('2f918f5a-da17-47c9-9217-c578398996e4', 30.00)
INSERT INTO #TempData VALUES ('300a3fbb-8302-4246-9acb-5bc12bc71046', 30.00)
INSERT INTO #TempData VALUES ('30433259-934c-4a06-b0de-c8256b4ec6e6', 30.00)
INSERT INTO #TempData VALUES ('307d540d-fb1b-47e5-b67e-bec4deffafab', 30.00)
INSERT INTO #TempData VALUES ('30bd2683-be81-41c8-9028-0a569d599e47', 30.00)
INSERT INTO #TempData VALUES ('30ea4126-2200-4609-9df8-b489c4726ade', 30.00)
INSERT INTO #TempData VALUES ('310e1c05-8bcb-455b-ab3e-f736246c5a6a', 30.00)
INSERT INTO #TempData VALUES ('314e958c-5473-43e8-ad11-13bf77ad2a09', 30.00)
INSERT INTO #TempData VALUES ('316cc683-1cc0-4609-9f4e-bfefde18659b', 30.00)
INSERT INTO #TempData VALUES ('31979fef-2c99-497c-96a8-0ffa741de31f', 30.00)
INSERT INTO #TempData VALUES ('31a0198b-496e-452c-a42f-0b4c732c8859', 30.00)
INSERT INTO #TempData VALUES ('31ae7c17-a530-4351-be0a-533a307b971d', 30.00)
INSERT INTO #TempData VALUES ('31b9a93d-18b1-41ea-822e-637ebbf4d989', 30.00)
INSERT INTO #TempData VALUES ('325d7edb-3adf-449d-81fa-6e2ee4ddda27', 30.00)
INSERT INTO #TempData VALUES ('326f86aa-6ceb-403d-a8d9-281d498290df', 82.41)
INSERT INTO #TempData VALUES ('32dbeb69-907a-48e1-9f8c-1375f46b5bb6', 92.46)
INSERT INTO #TempData VALUES ('32e59ea6-1091-44ec-9208-9941c565db67', 30.00)
INSERT INTO #TempData VALUES ('32ef758d-2ee0-4fe4-b182-ceb8cc77f4b1', 40.76)
INSERT INTO #TempData VALUES ('331fc399-50b9-4604-90cb-e6b33c033ed6', 30.00)
INSERT INTO #TempData VALUES ('334092a6-c5ec-400d-8b23-0c0cc1bd8b9c', 30.00)
INSERT INTO #TempData VALUES ('3377a0ab-d9f3-45d5-bcf2-dbbc4c8418a2', 30.00)
INSERT INTO #TempData VALUES ('33b2d244-82ba-4575-9bcb-5e4cf57d5912', 317.47)
INSERT INTO #TempData VALUES ('33fef974-a967-483b-be5f-bbcae2710024', 30.00)
INSERT INTO #TempData VALUES ('34206634-55f1-4207-89f5-b5e15e3b30c5', 50.52)
INSERT INTO #TempData VALUES ('34482cb9-e782-4d8d-aa38-c11eae4b03c6', 30.00)
INSERT INTO #TempData VALUES ('34ba7940-18ad-4ca0-9e76-05becc18eb1b', 30.00)
INSERT INTO #TempData VALUES ('34f05cda-667d-4e07-a30b-11bf2f77394c', 30.00)
INSERT INTO #TempData VALUES ('3515b803-5e27-4712-8543-b7a164b08282', 30.00)
INSERT INTO #TempData VALUES ('353e3a73-290b-4c0a-9b33-efce991f45dc', 30.00)
INSERT INTO #TempData VALUES ('354970bb-24c0-4614-8629-17ade6556163', 30.00)
INSERT INTO #TempData VALUES ('358046f4-02a5-464a-bf2f-e6731772c4b0', 30.00)
INSERT INTO #TempData VALUES ('359430c8-db19-4512-b2e6-f4d1c5df4a74', 30.00)
INSERT INTO #TempData VALUES ('35a14fc4-b365-4981-9fab-cabbd8a45cf0', 30.00)
INSERT INTO #TempData VALUES ('35aa47fb-570a-4eea-a2d9-3c52f5d20355', 30.00)
INSERT INTO #TempData VALUES ('36115176-7749-4436-99ac-013554d3737d', 30.00)
INSERT INTO #TempData VALUES ('3614fa04-e7ae-44f8-a0cb-4d19374e8274', 30.00)
INSERT INTO #TempData VALUES ('364a763e-03ef-47cf-8299-e9493a2cd846', 30.00)
INSERT INTO #TempData VALUES ('370730a0-3733-40ce-b66e-bc1b38449312', 30.00)
INSERT INTO #TempData VALUES ('37422da3-312d-404d-a924-4b8bc89ecb4c', 33.35)
INSERT INTO #TempData VALUES ('37658f13-9021-4d99-9c74-14d0e372403f', 30.00)
INSERT INTO #TempData VALUES ('37bcd339-f3a1-46f7-a93a-7daa441e8b5e', 30.00)
INSERT INTO #TempData VALUES ('37df7233-7209-4d7c-b894-ec9934071e8d', 30.00)
INSERT INTO #TempData VALUES ('37e3cc91-b830-4eaa-9e67-9421cabc6a52', 30.00)
INSERT INTO #TempData VALUES ('3803b5a7-b950-4366-ab7b-671660b8f721', 30.00)
INSERT INTO #TempData VALUES ('380f80bc-14ef-481e-81bf-a577c40530ee', 74.92)
INSERT INTO #TempData VALUES ('382187d0-245e-48be-9384-9e1c0f307211', 30.00)
INSERT INTO #TempData VALUES ('382bdec5-2d8c-45a8-8e5b-f8ce4f816b16', 30.00)
INSERT INTO #TempData VALUES ('383214ba-f0bd-489e-9a9b-631f0afb488e', 30.00)
INSERT INTO #TempData VALUES ('3843788c-ad2f-4fb3-b508-68dcd35a2e79', 30.00)
INSERT INTO #TempData VALUES ('38474fb9-ab86-49db-9abd-2a179b000054', 30.00)
INSERT INTO #TempData VALUES ('384fd2b0-9fe7-4573-8bee-40779ef070d0', 30.00)
INSERT INTO #TempData VALUES ('385d2c5a-5696-4984-ad88-c6725f883392', 30.00)
INSERT INTO #TempData VALUES ('38897e75-a4bf-45d8-add2-87db24d5e0ed', 30.00)
INSERT INTO #TempData VALUES ('38af646b-b85b-4f30-a0c9-6534fda3b45f', 30.00)
INSERT INTO #TempData VALUES ('38e5fdc3-da43-407b-bc24-2479da7cb594', 30.00)
INSERT INTO #TempData VALUES ('38ee6028-4744-4b23-84d9-dbca500004a8', 30.00)
INSERT INTO #TempData VALUES ('3919ca75-bfc0-45e8-9ea8-5351553b7698', 39.64)
INSERT INTO #TempData VALUES ('392137df-7585-48e9-b60e-540369b8c1c5', 30.00)
INSERT INTO #TempData VALUES ('39259c77-96d4-451e-b738-519ca6dc45f0', 48.01)
INSERT INTO #TempData VALUES ('39691142-8cf8-473e-a3ea-85f4c0229ad2', 30.00)
INSERT INTO #TempData VALUES ('39b17656-162c-4eb2-8552-361794ccdd8f', 30.00)
INSERT INTO #TempData VALUES ('39eba44d-9105-4c9e-9e9e-84060bca909a', 37.96)
INSERT INTO #TempData VALUES ('3a2b2284-a041-41d7-afc4-4cd923438c8d', 30.00)
INSERT INTO #TempData VALUES ('3a454b7d-bb73-4b2d-b2c0-32868db515ee', 30.00)
INSERT INTO #TempData VALUES ('3a61e9b7-6e96-4809-8e80-ebe393c9a3ff', 283.00)
INSERT INTO #TempData VALUES ('3af68a4c-ba4d-4240-95dd-fbe55350336b', 337.55)
INSERT INTO #TempData VALUES ('3b2da1b4-8e97-43ca-ad94-af45245e8510', 60.00)
INSERT INTO #TempData VALUES ('3b747e63-ee72-47f0-8ec9-74c4cd569eda', 30.00)
INSERT INTO #TempData VALUES ('3bfbf189-9a4a-4a3a-9fe2-f1fdb64b2c9d', 30.00)
INSERT INTO #TempData VALUES ('3cd88b3e-072e-451d-b097-82b7335a1751', 30.00)
INSERT INTO #TempData VALUES ('3ceeebd2-6072-44c8-8229-058c094fe125', 30.00)
INSERT INTO #TempData VALUES ('3d878bbb-5715-403d-b0c1-7dfbb64af33d', 147.36)
INSERT INTO #TempData VALUES ('3d9b893d-e448-4e19-89a2-702bba008ab2', 30.00)
INSERT INTO #TempData VALUES ('3da88189-a389-436b-bd6b-96cf48fb4516', 30.00)
INSERT INTO #TempData VALUES ('3dae3480-b9e5-4694-8b5e-4e3827a6f8bd', 102.90)
INSERT INTO #TempData VALUES ('3e0e75c1-6d2a-4f6a-af3f-abbe2a33f0aa', 30.00)
INSERT INTO #TempData VALUES ('3eba7f6d-e92a-4b57-b184-ad323da18f9e', 30.00)
INSERT INTO #TempData VALUES ('3ebdd329-b324-4f3f-8ccb-d07ca101587f', 30.00)
INSERT INTO #TempData VALUES ('3f2990f1-da1b-4ff2-b946-5c0fe6100ab2', 234.05)
INSERT INTO #TempData VALUES ('3f4b01b5-3182-4825-8edb-7b09459d77e8', 30.00)
INSERT INTO #TempData VALUES ('3f82133d-9e21-4aad-8f0b-f3a5be03aaae', 30.00)
INSERT INTO #TempData VALUES ('3fe37692-a9f9-46ec-a956-4b74fd581de3', 30.00)
INSERT INTO #TempData VALUES ('4023e238-6611-4797-9098-3818b401ddae', 30.00)
INSERT INTO #TempData VALUES ('4023e4d2-5c01-45e9-8320-71bb5efddefa', 30.00)
INSERT INTO #TempData VALUES ('405a8662-0014-490d-ad11-77ba8a3263a0', 67.75)
INSERT INTO #TempData VALUES ('4069ad39-237b-4365-9268-93ee71b78afb', 30.00)
INSERT INTO #TempData VALUES ('40ab1dc8-ed13-47bf-9a39-2a4e92cf4f48', 30.00)
INSERT INTO #TempData VALUES ('40b7303c-b328-4b04-a09e-5e80adcc8fcd', 30.00)
INSERT INTO #TempData VALUES ('40cfd7fe-3718-427b-9825-30311fb13e43', 30.00)
INSERT INTO #TempData VALUES ('40eb98ac-f7ed-4f28-a6a9-0f7a84e7b284', 30.00)
INSERT INTO #TempData VALUES ('413cb2a4-87db-450c-a5e5-4877702a7a4c', 30.00)
INSERT INTO #TempData VALUES ('41677ddd-1d0b-4067-b90c-69e3bcf31390', 30.00)
INSERT INTO #TempData VALUES ('417f7eb5-981e-4cd9-9033-287b3ed6f113', 30.00)
INSERT INTO #TempData VALUES ('41e6eaf6-2324-4b50-a5bc-351a42309601', 30.00)
INSERT INTO #TempData VALUES ('421eb786-f677-4403-b8c9-765de5448e04', 30.00)
INSERT INTO #TempData VALUES ('425350a4-8785-445b-b3b3-277edfecb3a4', 30.00)
INSERT INTO #TempData VALUES ('43349803-ea5c-4a02-81fe-3c16ab1b11f8', 30.00)
INSERT INTO #TempData VALUES ('43749fc1-7e54-46d0-9230-a19ed2429470', 30.00)
INSERT INTO #TempData VALUES ('4435d9c9-52db-49cf-83a9-38725e2d9edb', 30.00)
INSERT INTO #TempData VALUES ('454d0fc1-dedb-4c16-bbef-2e7b138c8bae', 107.55)
INSERT INTO #TempData VALUES ('45732e1f-7089-4bd1-8e52-fe4dba61708a', 36.82)
INSERT INTO #TempData VALUES ('45f65c64-b520-4611-88e1-fc1cea47f47e', 30.00)
INSERT INTO #TempData VALUES ('4609f496-fca6-43ef-bfab-9c8303d5ade7', 30.00)
INSERT INTO #TempData VALUES ('46b5b3a0-1833-459b-a0b3-9a2921833c9e', 30.00)
INSERT INTO #TempData VALUES ('46bd587a-12f0-4de1-a3a5-f059b4ab5728', 30.00)
INSERT INTO #TempData VALUES ('46c7a0f7-dc82-4d01-ac81-fb529b291565', 30.00)
INSERT INTO #TempData VALUES ('4719c429-1d50-4e4f-8134-c4da232e518d', 30.00)
INSERT INTO #TempData VALUES ('47284a4f-195f-4720-983b-8180e7bfd58b', 30.00)
INSERT INTO #TempData VALUES ('47c844bd-f71a-4bbd-adb9-422febccc8ca', 30.00)
INSERT INTO #TempData VALUES ('48d185e2-797e-4ad2-bd1f-27bca86ed825', 30.00)
INSERT INTO #TempData VALUES ('48f21ca6-abc0-4db8-9995-bbc2cd0a75fe', 30.00)
INSERT INTO #TempData VALUES ('495c8bb8-03d8-47aa-9515-8d6447f8df08', 30.00)
INSERT INTO #TempData VALUES ('496aa17d-fab8-4f88-8a13-3620cb63e8d1', 30.00)
INSERT INTO #TempData VALUES ('4992711b-6b6e-47dc-af4f-b07d97c1fef7', 30.00)
INSERT INTO #TempData VALUES ('4a2a9ff1-c55e-4f8c-8ccc-e6d7386979bc', 30.00)
INSERT INTO #TempData VALUES ('4a75c9b3-fa78-433e-8536-73ea46019cc0', 30.00)
INSERT INTO #TempData VALUES ('4b0ac18c-5c76-4912-bf90-4786c3a41a93', 30.00)
INSERT INTO #TempData VALUES ('4ba884ad-0abf-42f9-b860-4c751427a34a', 162.61)
INSERT INTO #TempData VALUES ('4bd05ffc-2926-4e33-9911-b42d94c29a0b', 30.00)
INSERT INTO #TempData VALUES ('4c95a08b-a680-489d-b331-75c1e67c2681', 30.00)
INSERT INTO #TempData VALUES ('4d125e97-2b84-44c6-b8ad-133e26cfebc1', 60.31)
INSERT INTO #TempData VALUES ('4d3621f6-23fa-4a2d-a019-d9748b9201cf', 30.00)
INSERT INTO #TempData VALUES ('4d4ebd58-c6fb-4f25-b7d4-d65a4eefed13', 30.00)
INSERT INTO #TempData VALUES ('4d7f3244-5ed3-4b56-94dd-3cd7a976c423', 50.67)
INSERT INTO #TempData VALUES ('4d8f6788-46d7-4f60-9977-ab274bed3c29', 123.35)
INSERT INTO #TempData VALUES ('4da029c8-6c0d-4edc-8245-157b4881e4c4', 30.00)
INSERT INTO #TempData VALUES ('4dd05795-cfd8-4a3e-876d-b0384c982996', 30.00)
INSERT INTO #TempData VALUES ('4df131d9-244a-4ecc-9ce2-89ae4b465eef', 30.00)
INSERT INTO #TempData VALUES ('4eb0ff1d-e2e4-4bf2-831c-0c855055600b', 30.00)
INSERT INTO #TempData VALUES ('4ec1aae4-ba70-43a3-b98e-caa788ad74c5', 30.00)
INSERT INTO #TempData VALUES ('4ed43d73-95b9-432b-81af-025a41660799', 30.00)
INSERT INTO #TempData VALUES ('4f26aeb9-9c08-46f6-9ab6-94d372dba4f7', 30.00)
INSERT INTO #TempData VALUES ('4fb8b3cc-62f8-4f36-ab75-8d5f55430576', 30.00)
INSERT INTO #TempData VALUES ('4fbec195-eb7a-4948-9a89-82bd27924203', 30.00)
INSERT INTO #TempData VALUES ('50540e2f-f9fd-4291-8c5b-bf8e5a434cf0', 30.00)
INSERT INTO #TempData VALUES ('505a689e-b885-4a1b-8740-17f00388982e', 30.00)
INSERT INTO #TempData VALUES ('507d77ce-6129-4751-9f5d-8dbe983bccb1', 30.00)
INSERT INTO #TempData VALUES ('5080ad23-07a4-4224-bf9c-ff1752934075', 30.00)
INSERT INTO #TempData VALUES ('50e89c43-50e0-4ca3-ae6a-d039930b00b0', 30.00)
INSERT INTO #TempData VALUES ('51194b8b-9c16-4e8f-9e99-db3ad97141d8', 30.00)
INSERT INTO #TempData VALUES ('515f27bf-6a49-474e-b7a9-cd514b4d49e5', 30.00)
INSERT INTO #TempData VALUES ('5203e49c-70b0-48da-93db-67dd285fc0ae', 30.00)
INSERT INTO #TempData VALUES ('524a5436-7fc5-4c89-97ee-2341d4a866d3', 30.00)
INSERT INTO #TempData VALUES ('52dd5a19-8ea0-452d-96d8-31357eef4648', 30.00)
INSERT INTO #TempData VALUES ('532d59ae-6357-45b9-813f-7f3ecf14ccdc', 30.00)
INSERT INTO #TempData VALUES ('5375bd68-775a-4b7a-b094-0622761525e6', 30.00)
INSERT INTO #TempData VALUES ('539abc17-d95f-4e5e-b1f2-4da613d573e6', 30.00)
INSERT INTO #TempData VALUES ('541f1d77-6592-484d-8be0-be4c880c69af', 30.00)
INSERT INTO #TempData VALUES ('54f32547-5416-41c1-b1b7-51a86eea2946', 30.00)
INSERT INTO #TempData VALUES ('55284d78-dcfd-4c24-8a78-344aba807cc7', 30.00)
INSERT INTO #TempData VALUES ('554fbf43-f271-4157-8d51-a371d5bb6920', 30.00)
INSERT INTO #TempData VALUES ('55933918-2058-4b3b-8e49-211fb9d01887', 128.55)
INSERT INTO #TempData VALUES ('55ca5188-a43f-4fdc-ad88-93fb2fc4b1b7', 30.00)
INSERT INTO #TempData VALUES ('562f0b88-b705-4f65-b267-ffa94d0b1b0a', 30.00)
INSERT INTO #TempData VALUES ('570fc648-5143-4331-bc34-987bf5726e56', 55.11)
INSERT INTO #TempData VALUES ('573b53b3-0d62-47d2-8051-c67732944a95', 30.00)
INSERT INTO #TempData VALUES ('5750a761-7942-4462-8fac-3a514b98770e', 30.00)
INSERT INTO #TempData VALUES ('57529bc8-c2f4-4856-a6af-b46794ab9f9c', 30.00)
INSERT INTO #TempData VALUES ('578219dc-8a67-4eb4-8da9-0fae20d3092d', 30.00)
INSERT INTO #TempData VALUES ('57b080d3-76b9-4c04-9159-1df097bfc78e', 30.00)
INSERT INTO #TempData VALUES ('5816d1ef-81df-4d59-9209-437bda1a8367', 30.00)
INSERT INTO #TempData VALUES ('5841a604-ff0e-4591-9a59-23b46381d3e4', 30.00)
INSERT INTO #TempData VALUES ('586cb896-4b07-4a4b-a62e-ed4381477764', 30.00)
INSERT INTO #TempData VALUES ('587b7e4a-2e5d-4719-ad26-5ac8cd140ac6', 68.77)
INSERT INTO #TempData VALUES ('58e3f263-e7c7-43fc-a9d6-729e0810b608', 30.00)
INSERT INTO #TempData VALUES ('58eac111-1a16-4783-9a66-cc6c5636fb20', 30.00)
INSERT INTO #TempData VALUES ('58fc38a4-4249-4a51-9187-bf0cb23fb3f2', 30.00)
INSERT INTO #TempData VALUES ('5925124d-8d82-491e-992f-02dba42fcb98', 88.66)
INSERT INTO #TempData VALUES ('595be602-6bbc-4f97-94b9-81075f0ca51d', 30.00)
INSERT INTO #TempData VALUES ('5969b618-caf4-4add-9320-6c7548184c68', 30.00)
INSERT INTO #TempData VALUES ('597fc673-f8c7-4eab-aafd-3eef62b54ae3', 178.71)
INSERT INTO #TempData VALUES ('598c3115-733e-41cf-8b39-e965a497d881', 59.35)
INSERT INTO #TempData VALUES ('59c725f5-3898-49e4-9933-e861f5fea176', 30.00)
INSERT INTO #TempData VALUES ('5a0094b5-f75b-40b6-a658-65dd501d4293', 30.00)
INSERT INTO #TempData VALUES ('5a04cfaa-bb4e-4cdd-896b-ef6066880ef5', 30.00)
INSERT INTO #TempData VALUES ('5a149daa-9164-4598-94c0-7bb8d8fbd9cf', 123.55)
INSERT INTO #TempData VALUES ('5a6da35a-9c2f-49db-b83f-29efcc75f21a', 30.00)
INSERT INTO #TempData VALUES ('5a9fdc10-1c1d-4d38-964a-537a314f986c', 107.14)
INSERT INTO #TempData VALUES ('5aefa992-12d5-44c3-a90a-545a7374a579', 30.00)
INSERT INTO #TempData VALUES ('5b039a6a-0dd8-429e-9830-d92d1afc1406', 30.00)
INSERT INTO #TempData VALUES ('5b233663-0e74-4230-866b-c3a3c6fba856', 267.46)
INSERT INTO #TempData VALUES ('5b479c54-cfbd-4073-be49-13aa8c94d638', 55.35)
INSERT INTO #TempData VALUES ('5b58762a-bcc5-4244-95c8-ec2c9148aae9', 30.00)
INSERT INTO #TempData VALUES ('5b8896db-8534-4b99-8113-7e3cbdd4afcc', 30.00)
INSERT INTO #TempData VALUES ('5bc0c6d4-0e61-45c2-a97f-155bfd89b8d5', 30.00)
INSERT INTO #TempData VALUES ('5bf8d42d-ed45-4c80-8580-c8a6c81aa4e5', 30.00)
INSERT INTO #TempData VALUES ('5c64a6a4-fabc-4eec-b4a6-c93b5a3770f4', 30.00)
INSERT INTO #TempData VALUES ('5ca07337-630d-4d27-9a16-bfdbe3c591d4', 30.00)
INSERT INTO #TempData VALUES ('5cb26391-64da-49fa-9eb1-4ce9ebd18de5', 30.00)
INSERT INTO #TempData VALUES ('5d1e9c1c-7cc0-42fc-a1d5-a82e7712b3c6', 30.00)
INSERT INTO #TempData VALUES ('5d385ac8-64ec-4a76-bf26-910bed63905c', 203.06)
INSERT INTO #TempData VALUES ('5d487d45-f4aa-4cfc-ab8e-4fafbb7e6f86', 30.00)
INSERT INTO #TempData VALUES ('5d568560-1b4f-4d88-8b0a-64f98964e19e', 30.00)
INSERT INTO #TempData VALUES ('5d8296a2-4b98-4da8-92b2-2d4a3b8c5e54', 30.00)
INSERT INTO #TempData VALUES ('5d9b7ee7-1747-4ecb-b875-bcd4df4b8d74', 30.00)
INSERT INTO #TempData VALUES ('5dd37ce0-ecb7-4873-a3ed-efc67271ffcf', 30.00)
INSERT INTO #TempData VALUES ('5e0c92af-eb35-4890-87c1-935e0aa2c0d5', 30.00)
INSERT INTO #TempData VALUES ('5e604a25-aa07-47c3-a4cb-f3e061d016e7', 30.00)
INSERT INTO #TempData VALUES ('5e759017-ed20-4675-806e-cb163cbe7b4e', 30.00)
INSERT INTO #TempData VALUES ('5ebec0e8-b082-4344-978b-3a5a67686179', 30.00)
INSERT INTO #TempData VALUES ('5ef29f93-e456-4f95-9aeb-3116f4a5cc72', 60.00)
INSERT INTO #TempData VALUES ('5f37c2c4-320d-4365-a988-d87c9b35570d', 30.00)
INSERT INTO #TempData VALUES ('5f4c8b15-8b56-4f6f-a885-ab52d91e73df', 30.00)
INSERT INTO #TempData VALUES ('5ff32029-f124-4a11-9742-b64101f63625', 30.00)
INSERT INTO #TempData VALUES ('5ff69861-57ce-4b10-880a-80e7e4941d0b', 30.00)
INSERT INTO #TempData VALUES ('602f5208-624f-4258-ba74-0c167a19cc4f', 30.00)
INSERT INTO #TempData VALUES ('60328015-384d-4e52-8422-bd739a6ee459', 30.00)
INSERT INTO #TempData VALUES ('61366ae4-2468-4e29-a829-832a39d094ee', 30.00)
INSERT INTO #TempData VALUES ('61a12ffa-a9e8-4914-beb0-9e9e062a6b1d', 30.00)
INSERT INTO #TempData VALUES ('61a652af-9cab-47b5-951a-5315e07a5e14', 30.00)
INSERT INTO #TempData VALUES ('61b5cf51-3570-41c8-aa71-21c9023648f8', 30.00)
INSERT INTO #TempData VALUES ('61bc780c-c048-4573-a309-7c254b2fdb61', 30.00)
INSERT INTO #TempData VALUES ('61e1704e-64da-4af3-8268-b72e38321f33', 63.05)
INSERT INTO #TempData VALUES ('6223baca-4d10-4753-8f76-5bc012f84ca1', 30.00)
INSERT INTO #TempData VALUES ('62352786-8a08-4cee-9b04-4b63dbd4feb2', 30.00)
INSERT INTO #TempData VALUES ('62532420-061b-4c2f-9b6d-fb147b22172a', 30.00)
INSERT INTO #TempData VALUES ('62c252a4-2628-43b3-98f6-229670bfb5a5', 30.00)
INSERT INTO #TempData VALUES ('62e0a3a2-e8ae-4746-a888-efb88982097f', 153.95)
INSERT INTO #TempData VALUES ('62fb251a-d155-4117-a4c6-08db27d2ecfd', 77.13)
INSERT INTO #TempData VALUES ('630d5819-cb20-42af-8c29-b7611d84a3f9', 30.00)
INSERT INTO #TempData VALUES ('630f2773-ce4b-4d5a-a494-81d2d1a12d8e', 31.47)
INSERT INTO #TempData VALUES ('63367d20-19b4-4b63-b000-1bdbff541ced', 30.00)
INSERT INTO #TempData VALUES ('639a445a-341f-45bc-b5ef-9ad229d6244b', 30.00)
INSERT INTO #TempData VALUES ('63a46d66-9480-4f6d-aca8-efba2c8a2336', 32.48)
INSERT INTO #TempData VALUES ('63caf5b8-794e-4a72-98e9-d3644719b8e4', 30.00)
INSERT INTO #TempData VALUES ('641e6ca7-a5c4-44a8-93dc-1412c7523564', 30.00)
INSERT INTO #TempData VALUES ('64469d86-164a-4777-be0b-8e59227173c8', 30.00)
INSERT INTO #TempData VALUES ('64e0d957-e2e8-4781-8def-6e91012d8192', 30.00)
INSERT INTO #TempData VALUES ('64fff220-2497-4250-bce7-2b471b001679', 30.00)
INSERT INTO #TempData VALUES ('65120c38-6cb0-4ec3-9a42-d12e18d868b1', 30.00)
INSERT INTO #TempData VALUES ('6514f7e5-383e-4285-b861-4908f47d01ee', 30.00)
INSERT INTO #TempData VALUES ('65e70f7c-4a36-438d-a43c-b8aa2a7255b1', 98.19)
INSERT INTO #TempData VALUES ('65fabffc-8975-4ebb-a056-bee5384774b4', 30.00)
INSERT INTO #TempData VALUES ('660bf177-ad4a-49d2-91ef-7e1c6a10ef48', 30.90)
INSERT INTO #TempData VALUES ('667f8b1c-fdc1-4d60-9a6e-7dc1a3b76f67', 204.33)
INSERT INTO #TempData VALUES ('66827d81-73a7-4620-bc50-ea90a8323841', 30.00)
INSERT INTO #TempData VALUES ('669cb6b0-8f9b-419d-a0e4-768f5a22176b', 61.57)
INSERT INTO #TempData VALUES ('66c09310-7fa1-408d-91bf-995efb39021f', 30.00)
INSERT INTO #TempData VALUES ('66e2368a-f79b-4b22-bd30-8c13cfe1dc87', 30.00)
INSERT INTO #TempData VALUES ('66f11cdc-ef19-4abe-95d8-956df0caaf9a', 212.70)
INSERT INTO #TempData VALUES ('670683a6-5a3c-4ae5-b0fb-edb98005eecf', 30.00)
INSERT INTO #TempData VALUES ('67077d88-801f-4991-97aa-e9b2eafe9d63', 30.00)
INSERT INTO #TempData VALUES ('67352f75-ab19-4688-9b7f-97774ebdd972', 30.00)
INSERT INTO #TempData VALUES ('6735f1e7-43a9-4997-9e50-7ad82bcd3581', 36.14)
INSERT INTO #TempData VALUES ('6778b6d9-7a8b-4c7a-8d8e-09c981959bf8', 37.56)
INSERT INTO #TempData VALUES ('678745e0-b96c-46ac-a18f-7c478880d805', 91.13)
INSERT INTO #TempData VALUES ('67b79fc0-11d1-48ad-bea1-21e395d1659d', 30.00)
INSERT INTO #TempData VALUES ('67e4fca1-6751-4440-801f-4941a4ba9c64', 30.00)
INSERT INTO #TempData VALUES ('67f9fa9a-170f-47c4-98df-18c16dfc7cee', 30.00)
INSERT INTO #TempData VALUES ('68328dd5-cb0d-447a-86bb-e3da00289b23', 30.00)
INSERT INTO #TempData VALUES ('68cd0f2d-f610-4279-a9b8-9f60e9a375f4', 47.95)
INSERT INTO #TempData VALUES ('68d016d8-b90f-479c-9484-df65a8b0d750', 30.00)
INSERT INTO #TempData VALUES ('68f86705-22f1-4ba0-b0ba-075ce60b9c03', 30.00)
INSERT INTO #TempData VALUES ('69242791-f710-4e3c-a177-7f6f637ca3fb', 30.00)
INSERT INTO #TempData VALUES ('69a055c4-1794-4204-a452-908bf86acd0b', 30.00)
INSERT INTO #TempData VALUES ('69c1e246-5315-4ebf-8ddb-4edae04caace', 30.00)
INSERT INTO #TempData VALUES ('69dd7f4c-5c2f-4994-8561-e337981d035a', 268.59)
INSERT INTO #TempData VALUES ('69fec40d-a211-48ca-a61b-8fdca49dfda0', 30.00)
INSERT INTO #TempData VALUES ('6a13ffb0-9b25-4ee3-a0ba-49f1ad562e06', 30.00)
INSERT INTO #TempData VALUES ('6a311552-7dd4-4b79-8f83-c8afd62be414', 30.00)
INSERT INTO #TempData VALUES ('6a60f74e-e291-4c84-b615-30c389de18b3', 30.00)
INSERT INTO #TempData VALUES ('6abec072-344e-407f-86a4-12cdc9d62d3c', 148.22)
INSERT INTO #TempData VALUES ('6ae78be7-ab7a-4c14-8ec7-fd109275f1a8', 30.00)
INSERT INTO #TempData VALUES ('6b341105-73fc-4ab8-9ae2-b87140c16b70', 30.00)
INSERT INTO #TempData VALUES ('6b7033de-97fa-43df-9619-8278c480cddc', 30.00)
INSERT INTO #TempData VALUES ('6b8f1910-9400-4492-9d96-3e362b74811b', 30.00)
INSERT INTO #TempData VALUES ('6ba5297f-b1f2-49ff-9fa9-a82367d62d01', 30.00)
INSERT INTO #TempData VALUES ('6c230d24-52f2-476c-91ef-18fba764fbfb', 30.00)
INSERT INTO #TempData VALUES ('6c2cf5a6-e781-4273-ac94-690681ae0f68', 30.00)
INSERT INTO #TempData VALUES ('6c341a4a-ca2c-45d3-9151-d60ed50edc1b', 30.00)
INSERT INTO #TempData VALUES ('6c5853ce-2b9b-462e-81de-297395c6fef1', 30.00)
INSERT INTO #TempData VALUES ('6c603441-915e-43f6-8a12-c625f9645642', 30.00)
INSERT INTO #TempData VALUES ('6d53f375-7f9e-4a58-83c1-6748ccef3a86', 30.00)
INSERT INTO #TempData VALUES ('6dcfb6b0-69af-4307-9ff1-9058c7621cb1', 90.00)
INSERT INTO #TempData VALUES ('6e231f59-71b7-4d20-8f63-6b329640ddaf', 65.77)
INSERT INTO #TempData VALUES ('6e29cd17-1f81-484d-93ba-fa357b166b6d', 30.00)
INSERT INTO #TempData VALUES ('6e2c5c50-34b2-4dab-87d8-8cf6acd4b7d1', 30.00)
INSERT INTO #TempData VALUES ('6e5649ec-31f0-4435-9e11-26a3d292b6a7', 30.00)
INSERT INTO #TempData VALUES ('6eb67ef2-fd9b-4479-a4a7-b673a59ef1d3', 30.00)
INSERT INTO #TempData VALUES ('6ef49c92-e2b9-4bf1-ad81-8ca4657452a3', 462.08)
INSERT INTO #TempData VALUES ('6efb66f2-0934-40b7-b2ef-f921dfc7cbc4', 30.00)
INSERT INTO #TempData VALUES ('6f20cb69-16b7-468d-a45b-862ce66e532c', 30.00)
INSERT INTO #TempData VALUES ('6f53e991-69df-40cd-9010-5fd5595bb03d', 30.00)
INSERT INTO #TempData VALUES ('6f5d429a-0014-41b8-8ae1-8211cad0f443', 30.00)
INSERT INTO #TempData VALUES ('6f6b529c-748c-430e-8bed-3aa3cb594757', 30.00)
INSERT INTO #TempData VALUES ('6f7a9de5-232a-49d8-9d23-a1383a31b831', 30.00)
INSERT INTO #TempData VALUES ('6f830072-f838-4b85-80c2-5fcee5373f58', 30.00)
INSERT INTO #TempData VALUES ('6ff46d1e-1544-46de-9873-14251bf5a2c0', 30.00)
INSERT INTO #TempData VALUES ('70999b56-335a-4e3d-a3d5-6f4df6f99c20', 30.00)
INSERT INTO #TempData VALUES ('70a83070-7de7-4d96-913c-a53c824df7ad', 30.00)
INSERT INTO #TempData VALUES ('70d74652-0684-437c-9f20-be2ed6339b39', 30.00)
INSERT INTO #TempData VALUES ('70f0d630-6889-4634-a390-e1d7c89f63da', 30.00)
INSERT INTO #TempData VALUES ('710ac845-bbf4-4452-ab0f-aa143b2639bc', 37.72)
INSERT INTO #TempData VALUES ('71130d1a-3a7c-4714-92fa-c0e94d89bcf8', 80.48)
INSERT INTO #TempData VALUES ('71435621-c70d-495f-816e-954c54617895', 30.00)
INSERT INTO #TempData VALUES ('71b6021f-1d5c-4cb8-a1b3-e4817a6fd977', 60.00)
INSERT INTO #TempData VALUES ('71df6733-f331-49dd-ae30-a577c4c3c232', 30.00)
INSERT INTO #TempData VALUES ('71f33f86-eee0-4907-9fe3-c7e14fe9f0e0', 96.03)
INSERT INTO #TempData VALUES ('726e2936-ef52-4730-a72c-fc66c84bbc1d', 30.00)
INSERT INTO #TempData VALUES ('727e81a7-d9ab-4327-8c47-b80efbffdd34', 30.00)
INSERT INTO #TempData VALUES ('7296bc6b-8b51-41b5-98e0-ac5116c36021', 30.00)
INSERT INTO #TempData VALUES ('72a30bb4-3fd9-40e5-b70f-a229290bdb7c', 30.00)
INSERT INTO #TempData VALUES ('72c446cc-7c4f-4f0a-aa35-2ba74eaff363', 30.00)
INSERT INTO #TempData VALUES ('72c6ba17-2ca1-4208-acbe-878c122e209d', 30.00)
INSERT INTO #TempData VALUES ('72e6abd3-d7b9-447e-8f1d-95b4f423ece1', 30.00)
INSERT INTO #TempData VALUES ('731b1807-c950-4686-8516-eece3aff6711', 30.00)
INSERT INTO #TempData VALUES ('738028ea-778d-4df9-932c-bb3aaf176878', 30.00)
INSERT INTO #TempData VALUES ('73c9bdfd-528b-4f27-ad25-f5a8ea53cbca', 30.00)
INSERT INTO #TempData VALUES ('73deb210-5bc0-4c3f-b4da-8043f08a0c62', 30.00)
INSERT INTO #TempData VALUES ('741a70d7-d024-4e1b-b6cc-cf1ceafb16a9', 107.22)
INSERT INTO #TempData VALUES ('74932eb9-10c6-4fd0-8eb0-65e7aced561d', 30.00)
INSERT INTO #TempData VALUES ('74ca177d-9d00-4d7d-98cf-0c66cbc03d6a', 841.98)
INSERT INTO #TempData VALUES ('74cacaa4-bf90-48ca-accd-983225b912c9', 45.55)
INSERT INTO #TempData VALUES ('74dfe4a2-ec6f-42a1-8065-9b26d95cabef', 151.11)
INSERT INTO #TempData VALUES ('7507c08c-0207-4252-b71b-e0e920177252', 30.00)
INSERT INTO #TempData VALUES ('751a863b-e9ee-40b9-9033-478737b2138a', 30.00)
INSERT INTO #TempData VALUES ('7541a922-295e-4e61-a411-7ce68b6d15b7', 30.00)
INSERT INTO #TempData VALUES ('758acab5-515e-4a95-8a4c-feb680719622', 124.79)
INSERT INTO #TempData VALUES ('75a71e29-4125-4bf7-bcfc-1275ede749c4', 30.00)
INSERT INTO #TempData VALUES ('75f840ea-460b-4cec-bbeb-6b1173b05913', 30.00)
INSERT INTO #TempData VALUES ('763946af-0157-48f5-9640-a893aa6d0993', 120.61)
INSERT INTO #TempData VALUES ('769d9a49-c3cc-488e-bab1-7ba7c226f333', 30.00)
INSERT INTO #TempData VALUES ('76dc6619-ad69-40c5-8e0d-3c0b7206550c', 30.00)
INSERT INTO #TempData VALUES ('77e602e9-1fbd-47c4-ac12-7c9a884304d6', 30.00)
INSERT INTO #TempData VALUES ('77f186b1-fb19-4d7e-bc14-2e2083e5fe1c', 57.12)
INSERT INTO #TempData VALUES ('77f5142f-7a53-4ac9-bc69-968c93efc3b4', 49.91)
INSERT INTO #TempData VALUES ('78028002-463c-4cea-a6c6-fbf993e349ca', 30.00)
INSERT INTO #TempData VALUES ('784f1886-0df1-4a2c-9b37-368fe0454c92', 30.00)
INSERT INTO #TempData VALUES ('786e0582-529f-4e80-9df4-08cae30b2b29', 30.00)
INSERT INTO #TempData VALUES ('78edfd00-d8f0-481b-8c94-6f7bc54fcf9e', 30.00)
INSERT INTO #TempData VALUES ('792ce5ab-2d38-4e94-a78e-b8a3a184b49d', 30.00)
INSERT INTO #TempData VALUES ('79b538ff-38a1-4b73-8f84-808514e59937', 30.00)
INSERT INTO #TempData VALUES ('7a2ea29b-5a17-415a-bcf2-504f4decf9f4', 30.00)
INSERT INTO #TempData VALUES ('7ab71a56-69e6-4762-adc2-8dd4e76edce5', 111.21)
INSERT INTO #TempData VALUES ('7aefea8c-7bb6-48e7-96bd-c0f5cc5d83d5', 30.00)
INSERT INTO #TempData VALUES ('7afbcd56-0189-4093-bd44-1cc26f42118a', 30.00)
INSERT INTO #TempData VALUES ('7b1cc8a8-4cf4-4de2-9fcb-bf9cbab871bb', 30.00)
INSERT INTO #TempData VALUES ('7b2fbc78-e5a0-4aa4-bd61-5371753833a8', 193.14)
INSERT INTO #TempData VALUES ('7ba056a8-be25-4d34-a039-234f7add8433', 54.34)
INSERT INTO #TempData VALUES ('7bfa91d4-4a61-466e-b32b-f8412eda5072', 30.00)
INSERT INTO #TempData VALUES ('7c026c38-5d62-43df-b9e3-8582247e5368', 30.00)
INSERT INTO #TempData VALUES ('7c91ec36-7d3f-48b9-9dec-4118970a2c8c', 30.00)
INSERT INTO #TempData VALUES ('7c986b34-39b0-443c-84f6-65d0cfab4c0d', 145.52)
INSERT INTO #TempData VALUES ('7d2f74dd-6416-4ed2-a8aa-0a50c8b64e1a', 30.00)
INSERT INTO #TempData VALUES ('7d8d08d9-5108-42c9-83e5-4d81ae560a31', 30.00)
INSERT INTO #TempData VALUES ('7db421f7-ddc8-43a6-9794-c181fceab117', 30.00)
INSERT INTO #TempData VALUES ('7df6647b-1247-4009-b664-9e2385d7d851', 36.40)
INSERT INTO #TempData VALUES ('7e053d9a-263b-4a62-b611-76ce60cb31f5', 30.00)
INSERT INTO #TempData VALUES ('7e6b7843-a64b-47ee-a9dd-6fe044047bd9', 30.00)
INSERT INTO #TempData VALUES ('7e9dc13c-546b-44ee-8f0d-13365da9e09f', 590.25)
INSERT INTO #TempData VALUES ('7ebe5217-53a1-4da1-9531-9a0dbf2819dd', 30.00)
INSERT INTO #TempData VALUES ('7ede5b13-6f61-4d34-b183-56741cd61f85', 30.00)
INSERT INTO #TempData VALUES ('7f164654-d6e8-4573-9854-e846747d801f', 35.33)
INSERT INTO #TempData VALUES ('7f3325c7-8062-4f73-93f5-7751a62c4cbc', 30.00)
INSERT INTO #TempData VALUES ('7f764247-5bd8-4aca-8910-563393753284', 30.00)
INSERT INTO #TempData VALUES ('7f7b822f-71f9-44b3-b756-4173d64de5a6', 30.00)
INSERT INTO #TempData VALUES ('7fa27819-8664-4970-b571-574fdfaa2a77', 157.45)
INSERT INTO #TempData VALUES ('7fbbc1fd-3fdd-4149-965b-d363187acf96', 49.20)
INSERT INTO #TempData VALUES ('7fcd54bb-8d3e-4c0a-9411-7f79719282aa', 30.00)
INSERT INTO #TempData VALUES ('7fde8df1-2168-427f-864f-2d4b8fe2b7ee', 30.00)
INSERT INTO #TempData VALUES ('7fe75609-5024-47f3-969c-8788303588e2', 44.54)
INSERT INTO #TempData VALUES ('7ff2b2f9-f1ec-469d-948b-234ad5398a9d', 30.00)
INSERT INTO #TempData VALUES ('801dd4c6-0f41-4574-b7af-1f54278b89c5', 30.00)
INSERT INTO #TempData VALUES ('80518ed2-6bf3-47cb-b76a-6f277430aaaa', 30.00)
INSERT INTO #TempData VALUES ('80538ac5-58d9-4808-b546-2a32677b9876', 30.00)
INSERT INTO #TempData VALUES ('806e129e-b1ee-4aec-b23d-ceeb49539485', 30.00)
INSERT INTO #TempData VALUES ('80960fea-6c8e-4b42-ac00-1feabe74b5c9', 51.74)
INSERT INTO #TempData VALUES ('80acf82f-3347-4f79-b4e9-b109dfba3ee5', 30.00)
INSERT INTO #TempData VALUES ('80b92d60-ff5b-47d8-ba07-e85521fb1c0e', 30.00)
INSERT INTO #TempData VALUES ('80cf716f-22f2-4778-ac19-dedb2ae573de', 30.00)
INSERT INTO #TempData VALUES ('81182a1d-bc48-4831-90a9-f3c4f7fbcb02', 30.00)
INSERT INTO #TempData VALUES ('8142a03d-9d7d-4407-93a8-ecd680fe9367', 30.00)
INSERT INTO #TempData VALUES ('814ccb15-5721-4d67-b679-685402c89755', 60.00)
INSERT INTO #TempData VALUES ('81516194-261f-454c-80b8-6d5e511a006c', 30.00)
INSERT INTO #TempData VALUES ('819a7c9c-bc33-4725-97a9-b769db0876e4', 30.00)
INSERT INTO #TempData VALUES ('81dfae00-7dab-4192-879f-3e942d21e3a5', 30.00)
INSERT INTO #TempData VALUES ('81ec4361-174d-476a-aee2-50fb5e28c6b3', 147.60)
INSERT INTO #TempData VALUES ('81ff86cb-aeb8-4e70-acf7-d63d305bc58c', 30.00)
INSERT INTO #TempData VALUES ('8204f3b2-a293-4731-b06a-b1a773858b67', 85.86)
INSERT INTO #TempData VALUES ('82420dd7-847b-4797-9c44-8b18f45b6501', 30.00)
INSERT INTO #TempData VALUES ('826865b3-cca2-4727-bdf2-991a60c02cad', 83.07)
INSERT INTO #TempData VALUES ('82992b5f-c77e-43d1-a28d-4d6d4c75d249', 30.00)
INSERT INTO #TempData VALUES ('829ae740-bcca-486f-9cc9-d1e0c22f7d40', 30.00)
INSERT INTO #TempData VALUES ('82aed3cd-9ca6-4fd4-b18e-a27f5d5c1ca8', 30.00)
INSERT INTO #TempData VALUES ('82d03675-e2d1-4a5f-8bed-c2cfea44f549', 30.00)
INSERT INTO #TempData VALUES ('82f22b50-cb65-4c6d-a86e-8e03d9720976', 231.70)
INSERT INTO #TempData VALUES ('83122f39-c0c3-4114-aa79-5de4c8a2a20c', 30.00)
INSERT INTO #TempData VALUES ('83188ce9-3617-452e-8b9f-508032c8f6b5', 30.00)
INSERT INTO #TempData VALUES ('8345f292-7b6e-4518-a502-562f7c7e6575', 30.00)
INSERT INTO #TempData VALUES ('838289bb-3634-4adf-9458-da1cb38443df', 116.41)
INSERT INTO #TempData VALUES ('83955bcb-d259-4650-bd4d-39b155bffd03', 30.00)
INSERT INTO #TempData VALUES ('83bebca3-363c-43e8-a19e-cfd51d6e6044', 30.00)
INSERT INTO #TempData VALUES ('84074707-9c7a-4205-90cd-c173f83174e1', 30.00)
INSERT INTO #TempData VALUES ('841a3170-decf-456a-8461-d7681a9fd40b', 30.00)
INSERT INTO #TempData VALUES ('846af7ce-fc07-4f5c-a345-273c17dc1fc5', 30.00)
INSERT INTO #TempData VALUES ('847e5256-4e40-41bc-962a-de8518bd8141', 30.00)
INSERT INTO #TempData VALUES ('848b6947-6bea-409a-bd8e-5960a20c50ff', 30.00)
INSERT INTO #TempData VALUES ('8494ad1b-c753-404b-8ee0-0c09a7b81435', 30.00)
INSERT INTO #TempData VALUES ('84c93343-3120-4986-8381-ae398cb01a05', 30.00)
INSERT INTO #TempData VALUES ('84d37ef2-d38c-4989-9296-741b4d6f0aeb', 30.00)
INSERT INTO #TempData VALUES ('85720391-9feb-4974-8888-8206d4f06f57', 30.00)
INSERT INTO #TempData VALUES ('85cf6693-5e0a-45a5-ab9a-55900388b205', 30.00)
INSERT INTO #TempData VALUES ('8610eec9-1cfd-4a58-af8c-1e8c809d48e3', 30.00)
INSERT INTO #TempData VALUES ('862ed70d-5a8e-4c9b-817b-4a62508eb6ab', 30.00)
INSERT INTO #TempData VALUES ('863a0407-10d6-47c9-ad0d-3f1bc182607f', 30.00)
INSERT INTO #TempData VALUES ('863cf93f-aedf-4f77-9f12-6ff8f79f322b', 30.00)
INSERT INTO #TempData VALUES ('8656782b-52a7-4883-b7a1-8adb27da6177', 60.00)
INSERT INTO #TempData VALUES ('86882170-2c68-42cd-a55f-cd92a53c7ed4', 30.00)
INSERT INTO #TempData VALUES ('8696e96c-8115-4a7f-878b-7cf7e1f76c1f', 30.00)
INSERT INTO #TempData VALUES ('86f89e83-67f5-47b5-ab68-70570b22a89c', 30.00)
INSERT INTO #TempData VALUES ('86f99e2a-1272-4e14-a024-250ee2b99d09', 30.00)
INSERT INTO #TempData VALUES ('8737c9a9-8fbe-49e6-905b-908a2a4d7a10', 30.00)
INSERT INTO #TempData VALUES ('87cbfb88-4efd-4dd4-bc2c-f428a95c0079', 30.00)
INSERT INTO #TempData VALUES ('87f71cf5-3eed-4d35-b4cf-48f93f7efd96', 30.00)
INSERT INTO #TempData VALUES ('8826904a-8ed8-4d00-a1b1-ebb07028aceb', 30.00)
INSERT INTO #TempData VALUES ('885eb971-ba52-4a67-8d0b-816b43998a4a', 30.00)
INSERT INTO #TempData VALUES ('8866ae09-b0cd-433e-b44f-f57f21563923', 30.00)
INSERT INTO #TempData VALUES ('8878893c-6c4e-4e99-83fb-db2ef68c41a4', 30.00)
INSERT INTO #TempData VALUES ('888f0c38-3f88-4073-9742-b8943b472aee', 30.00)
INSERT INTO #TempData VALUES ('89c19257-58ad-4711-8764-90131c6f690d', 30.00)
INSERT INTO #TempData VALUES ('89c35f9a-0323-4b88-9f4c-465651aeff81', 30.00)
INSERT INTO #TempData VALUES ('89c7a243-b881-4295-9117-c20416f56abc', 157.91)
INSERT INTO #TempData VALUES ('89c97914-e6ba-4dba-a2c3-2d54ce53d9fc', 30.00)
INSERT INTO #TempData VALUES ('89d75700-11e7-4d1b-ad5c-d1ae9ee67684', 30.00)
INSERT INTO #TempData VALUES ('89d91820-1fd7-4061-902d-416f4ed48523', 30.00)
INSERT INTO #TempData VALUES ('8a3852ae-f087-4da1-8adc-533e103731b9', 30.00)
INSERT INTO #TempData VALUES ('8a7a5e0b-aeff-4831-a39e-338d61f38df8', 30.00)
INSERT INTO #TempData VALUES ('8a823355-9fcb-43c1-bc63-376f9cca1221', 52.82)
INSERT INTO #TempData VALUES ('8ab63d25-2ddd-4204-a498-6f6aa7d3238a', 30.00)
INSERT INTO #TempData VALUES ('8ad9ecd4-ffd5-41ce-abfd-d4b9486ba22e', 30.00)
INSERT INTO #TempData VALUES ('8b256d7e-e0c6-4c50-8591-f37ae851ee2f', 30.00)
INSERT INTO #TempData VALUES ('8b7370f4-ea7f-422b-ab4b-ac120ef4a2e1', 30.00)
INSERT INTO #TempData VALUES ('8b8f404a-957e-46c8-bdcb-754ff99cd039', 81.72)
INSERT INTO #TempData VALUES ('8ba97a82-5428-4e99-af57-ca7dacd04d00', 161.63)
INSERT INTO #TempData VALUES ('8bac92e4-636b-4b1d-85e2-e71701125362', 30.00)
INSERT INTO #TempData VALUES ('8bc3ae5e-cf4a-4d49-9c60-349156f042b9', 30.00)
INSERT INTO #TempData VALUES ('8c46531e-3c4e-4a87-85bb-18fd2e5867e9', 30.00)
INSERT INTO #TempData VALUES ('8c6a4f55-c600-418d-bb96-241229706151', 136.32)
INSERT INTO #TempData VALUES ('8c6eb70c-9d2c-4e0c-a1af-88014d023200', 30.00)
INSERT INTO #TempData VALUES ('8c6f017b-e2bd-4dfa-8866-a6ea5643de8b', 30.00)
INSERT INTO #TempData VALUES ('8c91fba3-18c3-4782-a8de-dd7916566572', 30.00)
INSERT INTO #TempData VALUES ('8c9ad58f-4383-462a-8020-47ddb400736f', 30.00)
INSERT INTO #TempData VALUES ('8cb57d81-15ee-4c4f-ae00-009332137302', 30.00)
INSERT INTO #TempData VALUES ('8cd55360-da35-414a-af81-f3acb31bac64', 30.00)
INSERT INTO #TempData VALUES ('8d5a6667-48f1-48ba-a88c-e505bf72ca7f', 30.00)
INSERT INTO #TempData VALUES ('8d787e56-8241-4793-b4f1-92a2f4ce97cd', 30.00)
INSERT INTO #TempData VALUES ('8da5acbe-923a-49bd-9814-ec7aaeaf5137', 69.92)
INSERT INTO #TempData VALUES ('8dcc8b8e-e90c-4389-9674-1b2761170384', 30.00)
INSERT INTO #TempData VALUES ('8e4c8dfa-f498-4683-83ba-2fa988d89697', 30.00)
INSERT INTO #TempData VALUES ('8e7c29eb-93d4-4674-9373-4fdbcb3f523e', 30.00)
INSERT INTO #TempData VALUES ('8e81428f-ca65-4836-a987-0b0eb1ba6904', 45.37)
INSERT INTO #TempData VALUES ('8eb08012-c133-4e64-8fd0-4100a034741a', 30.00)
INSERT INTO #TempData VALUES ('8f12cd74-8959-4cc0-95e8-95ed0c83b4c5', 30.00)
INSERT INTO #TempData VALUES ('8f556ad1-0e72-4644-8b31-345ea6908540', 30.00)
INSERT INTO #TempData VALUES ('8f8a2fa4-5f8f-4827-974a-072121cdc3e7', 60.51)
INSERT INTO #TempData VALUES ('8fa2049a-6850-4258-be0c-4369b62c0cad', 30.00)
INSERT INTO #TempData VALUES ('8fd0317e-afda-4889-9c5b-3380223a9ac1', 30.00)
INSERT INTO #TempData VALUES ('902c4bcb-815e-4de4-9ba2-b4fefa0646e5', 60.00)
INSERT INTO #TempData VALUES ('903815cc-5096-46b3-8478-f5928c297c4f', 30.00)
INSERT INTO #TempData VALUES ('903bc0f4-d89f-45a1-98a4-99224eb86364', 30.00)
INSERT INTO #TempData VALUES ('904d1fc7-d07f-419c-ad05-366b928a16d7', 30.00)
INSERT INTO #TempData VALUES ('90798fe2-edae-4eec-af29-2c1a955fa9f7', 30.00)
INSERT INTO #TempData VALUES ('90937732-c381-48bd-8a3c-5cb9c8d16a31', 36.40)
INSERT INTO #TempData VALUES ('90e095d1-766d-4c91-9e7e-55fe238afdb9', 30.00)
INSERT INTO #TempData VALUES ('91115029-4668-4f0c-b999-59c063ea1138', 30.00)
INSERT INTO #TempData VALUES ('911cc6f4-1163-4adb-b274-8c11b842b540', 30.00)
INSERT INTO #TempData VALUES ('91371df8-4238-4f63-a89a-32f6556cd09c', 30.00)
INSERT INTO #TempData VALUES ('9176ee9e-3853-4042-9ab7-a3c88e89f5cb', 30.00)
INSERT INTO #TempData VALUES ('91936838-8971-4efb-beca-2d0141017dec', 30.00)
INSERT INTO #TempData VALUES ('91b0952a-c33f-4dc3-9383-11cd4544f82c', 30.00)
INSERT INTO #TempData VALUES ('91b49801-38b7-495c-a3b9-d7ddb6abc471', 30.00)
INSERT INTO #TempData VALUES ('91cbea49-60ad-441a-a16b-af1903d1a8df', 30.00)
INSERT INTO #TempData VALUES ('9252d5ea-ee55-466e-b924-5fec97040010', 30.00)
INSERT INTO #TempData VALUES ('925aeeb6-f736-4ee7-8170-c9f52e23857e', 30.00)
INSERT INTO #TempData VALUES ('928bc73f-42bb-4084-b567-37eced093e62', 30.00)
INSERT INTO #TempData VALUES ('92d7669e-655b-41c0-8cfb-5da35c96ca51', 30.00)
INSERT INTO #TempData VALUES ('92f5d4c2-d44c-4435-a87f-98968137f710', 30.00)
INSERT INTO #TempData VALUES ('9328c985-caa2-45eb-bbea-38e527dcfce5', 30.00)
INSERT INTO #TempData VALUES ('932d2468-3ee6-49a0-a0be-10b1f80272ad', 30.00)
INSERT INTO #TempData VALUES ('93bac0a8-3bec-4fd7-9617-abd16986682a', 30.00)
INSERT INTO #TempData VALUES ('93e4dcc4-5859-407f-820f-27f05f40bd9a', 30.00)
INSERT INTO #TempData VALUES ('93ed46e3-25ec-4b54-9367-7c9f100081fb', 30.00)
INSERT INTO #TempData VALUES ('9455d5f9-0e74-4e54-9aa0-c50a8c5feeb6', 30.00)
INSERT INTO #TempData VALUES ('94cb1261-88f2-4390-bf86-206801af9175', 30.00)
INSERT INTO #TempData VALUES ('94e3594c-fd75-4b40-9208-dd728ae45883', 30.00)
INSERT INTO #TempData VALUES ('94e3647d-ea9f-42aa-be67-d8615806d33d', 184.05)
INSERT INTO #TempData VALUES ('94fa7eea-4b08-49bf-b766-d10f10f9084a', 30.00)
INSERT INTO #TempData VALUES ('95323575-a0b1-4c8b-b5d4-69d6feb0d8c9', 61.68)
INSERT INTO #TempData VALUES ('95c8ad73-1c14-4317-bc4e-37f465cf860a', 44.61)
INSERT INTO #TempData VALUES ('95cfcc22-0c3a-4521-88da-98a36b9e7db9', 30.00)
INSERT INTO #TempData VALUES ('95e4c9b0-0a45-4706-a13b-0749cdf0b3ed', 30.00)
INSERT INTO #TempData VALUES ('95ff410d-5b0e-46b7-bb15-18d489aaf614', 30.00)
INSERT INTO #TempData VALUES ('96309082-ecfb-4039-8068-64aee98383ec', 30.00)
INSERT INTO #TempData VALUES ('9682e68e-712c-4553-a055-5a82d9a2e394', 71.85)
INSERT INTO #TempData VALUES ('969cbdad-3f8c-45ee-8d52-b813c8c47a3e', 30.00)
INSERT INTO #TempData VALUES ('96aa30c2-443e-440d-beed-d71cb7a22295', 60.00)
INSERT INTO #TempData VALUES ('96ba1032-798a-4313-87cb-b00480afd42f', 30.00)
INSERT INTO #TempData VALUES ('972b329b-e85f-47e1-86bc-d544c06e80de', 60.00)
INSERT INTO #TempData VALUES ('972f020b-6344-48e4-a1a1-b2a410413f25', 30.00)
INSERT INTO #TempData VALUES ('975e1a55-8b02-4506-b94a-cf793ef2a3d4', 30.00)
INSERT INTO #TempData VALUES ('98198091-e733-4293-8e3f-33ba218f6f73', 30.00)
INSERT INTO #TempData VALUES ('9847da02-eb9a-45f8-a897-c9e42fe299f7', 42.97)
INSERT INTO #TempData VALUES ('98ab4686-166a-41dc-a5fa-593e7e19c540', 30.00)
INSERT INTO #TempData VALUES ('98bf382a-2178-4bc7-8dcd-be60952e8ac5', 30.00)
INSERT INTO #TempData VALUES ('990cdbd2-b987-420d-9c72-f0fddd81b2c0', 30.00)
INSERT INTO #TempData VALUES ('9942df6b-7c23-4469-b3b7-d4636aacbc18', 30.00)
INSERT INTO #TempData VALUES ('99714829-3882-480d-b098-acdcb1540af6', 30.00)
INSERT INTO #TempData VALUES ('997e8835-850b-4643-9439-6f61f79f3902', 30.00)
INSERT INTO #TempData VALUES ('9991aa13-7f02-4e32-8448-4b85444f714a', 30.00)
INSERT INTO #TempData VALUES ('99c1e45b-1aa8-4572-b732-edf66b453153', 30.00)
INSERT INTO #TempData VALUES ('99c8fe05-78f1-432e-a89d-d0ea91603145', 30.00)
INSERT INTO #TempData VALUES ('99d159a3-cb95-44aa-91f5-8ef21973357f', 63.48)
INSERT INTO #TempData VALUES ('99eb12cd-cd6e-460a-924c-e24eb3eebb49', 30.00)
INSERT INTO #TempData VALUES ('9a0135e3-5c29-4b0f-b4bb-8910166e270f', 30.00)
INSERT INTO #TempData VALUES ('9a0f3933-90aa-4434-9749-9559a2878b03', 30.00)
INSERT INTO #TempData VALUES ('9a75a0e3-2468-4b10-ac3b-6ae4b2d8e90b', 115.79)
INSERT INTO #TempData VALUES ('9a83b56e-73a1-48cd-af1b-28afb29a18f2', 30.00)
INSERT INTO #TempData VALUES ('9aa68b37-2e05-4534-a79a-aa416b11c865', 30.00)
INSERT INTO #TempData VALUES ('9ad0b5b5-d228-4d55-b055-0ee5c35b7fdc', 30.00)
INSERT INTO #TempData VALUES ('9b0db5fc-049a-4373-badb-64c2f5510c1a', 30.00)
INSERT INTO #TempData VALUES ('9b1d58dd-cf58-4e1b-954e-0d643cb1afff', 30.00)
INSERT INTO #TempData VALUES ('9b222d8f-f7ca-492e-8dce-646906e54682', 30.00)
INSERT INTO #TempData VALUES ('9b2a1fa1-af7d-48c6-97c8-fe2c9a3babef', 115.13)
INSERT INTO #TempData VALUES ('9b7e7461-3e3f-4460-a740-a18ef04fbe45', 30.00)
INSERT INTO #TempData VALUES ('9b99a7ba-6e2c-4c2a-a34d-9704014bf96b', 30.00)
INSERT INTO #TempData VALUES ('9bb491f1-af40-4742-8e2b-995c5b7df01c', 30.00)
INSERT INTO #TempData VALUES ('9bc780d9-e2eb-4c09-8f9c-041acdad488c', 593.03)
INSERT INTO #TempData VALUES ('9bded85f-e912-443f-bfc3-ca0e76d2a0e2', 30.00)
INSERT INTO #TempData VALUES ('9beb6f81-1cf2-495f-bbab-7c15776b6116', 30.00)
INSERT INTO #TempData VALUES ('9d0feaf4-09a4-4842-a36e-3b4cf2f8c7d9', 862.33)
INSERT INTO #TempData VALUES ('9d86cb90-974b-4f76-bdd9-1c6135585ac2', 30.00)
INSERT INTO #TempData VALUES ('9da43303-e462-436c-bd86-a3313f5e000d', 30.00)
INSERT INTO #TempData VALUES ('9dd3a031-6a58-4f05-a219-f37f5ef683c1', 30.00)
INSERT INTO #TempData VALUES ('9e07b45d-efcb-49c4-99fc-ae3cc5b0599b', 218.93)
INSERT INTO #TempData VALUES ('9e16cf1f-f11c-4910-b8c8-bbc440d3938b', 52.38)
INSERT INTO #TempData VALUES ('9e507d31-0646-4ebd-b09a-fc30b8b9eb89', 30.00)
INSERT INTO #TempData VALUES ('9ed6777d-098c-409a-9e62-6f9c26c17b28', 30.00)
INSERT INTO #TempData VALUES ('9f1d92be-8f10-4169-92a5-5d426f581da2', 30.00)
INSERT INTO #TempData VALUES ('9fceb39c-3101-4d5b-b9a1-08e136570592', 30.00)
INSERT INTO #TempData VALUES ('9fdbc2dc-505d-46af-8e73-75e9d9bb1aa2', 30.00)
INSERT INTO #TempData VALUES ('9ffa5662-de45-4474-8613-fe04fb33c241', 30.00)
INSERT INTO #TempData VALUES ('a03c618e-f1e8-40d8-9570-3319a1b0511f', 30.00)
INSERT INTO #TempData VALUES ('a0678bef-532e-4c70-886d-9c2ca1dbf410', 30.00)
INSERT INTO #TempData VALUES ('a06a8984-6d61-4f42-830a-02090245d0f0', 30.00)
INSERT INTO #TempData VALUES ('a0a0b8c5-0cb0-4be4-ac16-84f0a513295c', 56.18)
INSERT INTO #TempData VALUES ('a0fce217-0bd0-40aa-a006-b76dacc51963', 30.00)
INSERT INTO #TempData VALUES ('a175b880-a4e9-44af-bf67-f07cb677e4bc', 30.00)
INSERT INTO #TempData VALUES ('a17626d4-ec7e-45b9-abee-13ac4f1d3517', 30.00)
INSERT INTO #TempData VALUES ('a1921309-def4-4190-9554-20d8da2c34bc', 30.00)
INSERT INTO #TempData VALUES ('a1edcaec-bd3c-473f-af3a-7a5739ed29d9', 30.00)
INSERT INTO #TempData VALUES ('a22b23cf-7e7b-4c6d-90ac-8d977d6211dd', 31.06)
INSERT INTO #TempData VALUES ('a2473486-7bc7-4429-b6d8-9633f65338ee', 30.00)
INSERT INTO #TempData VALUES ('a25b853b-6be6-45cf-ac03-dc717723ef42', 30.00)
INSERT INTO #TempData VALUES ('a2640b97-b1b9-4341-930b-2d2cad2d39d8', 118.64)
INSERT INTO #TempData VALUES ('a2ae1306-270e-492b-86ec-02970e5b684d', 30.00)
INSERT INTO #TempData VALUES ('a2cc94ae-6c44-4914-bada-14681aa302ec', 30.00)
INSERT INTO #TempData VALUES ('a2ecb5df-b479-4e6c-b4e1-84312bcbe31a', 30.00)
INSERT INTO #TempData VALUES ('a3172098-12ef-4011-b567-b171f442d37b', 30.00)
INSERT INTO #TempData VALUES ('a31b2f43-a7b1-4d81-93b7-11f344a9e734', 30.00)
INSERT INTO #TempData VALUES ('a383b8f2-d3ea-42a2-959f-feb8baa7cfaa', 30.00)
INSERT INTO #TempData VALUES ('a3925f03-934a-4381-a134-131bacb6aa54', 30.00)
INSERT INTO #TempData VALUES ('a3aadd7f-b035-48d0-8a43-3ed68e47e9c3', 30.00)
INSERT INTO #TempData VALUES ('a414c392-751c-40fe-987d-cc3dadc1aad7', 405.87)
INSERT INTO #TempData VALUES ('a4774728-dc33-4b3f-a681-5b87c1594b58', 30.00)
INSERT INTO #TempData VALUES ('a4879b10-fbd5-491a-aa3b-78f45823ec9c', 30.00)
INSERT INTO #TempData VALUES ('a4a3b9a8-a872-42c0-b86f-0cb1becf0679', 30.00)
INSERT INTO #TempData VALUES ('a4b73dc8-0f0a-4851-90d6-3cb53104e03b', 30.00)
INSERT INTO #TempData VALUES ('a4d5280b-0a5f-4d87-aa2f-beb30514581a', 54.92)
INSERT INTO #TempData VALUES ('a51f817b-5542-4bc9-9ed6-24a60fe8b79b', 30.00)
INSERT INTO #TempData VALUES ('a5254acf-2a4b-41e7-a9c7-b94a50fb0dbe', 30.00)
INSERT INTO #TempData VALUES ('a54fc438-9bb1-4f78-944e-503f39547d78', 30.00)
INSERT INTO #TempData VALUES ('a552070e-0811-4033-a01c-85b4d2763faa', 30.00)
INSERT INTO #TempData VALUES ('a5900f06-1341-40d3-921c-90663448e5aa', 90.00)
INSERT INTO #TempData VALUES ('a5ad66d9-f593-47d0-9ecd-23504874efb0', 30.00)
INSERT INTO #TempData VALUES ('a6020c6b-cd96-45ce-a248-0a4a95e95b90', 30.00)
INSERT INTO #TempData VALUES ('a629f5c0-c363-4ba3-b599-106212223062', 30.00)
INSERT INTO #TempData VALUES ('a6742cef-e0d6-4a63-96d2-5b8ea3c1f4bc', 30.00)
INSERT INTO #TempData VALUES ('a6b5657f-bb4e-46f5-9179-5e07c425bc7a', 30.00)
INSERT INTO #TempData VALUES ('a7126b08-819a-4aab-8e2a-c1d603054ebf', 30.00)
INSERT INTO #TempData VALUES ('a7383973-e4ff-4625-bab1-ea0085e4b941', 30.00)
INSERT INTO #TempData VALUES ('a7675b48-86d3-47fe-8706-b5d4bdf2f06a', 44.39)
INSERT INTO #TempData VALUES ('a7769dd1-d7d9-4d9e-b88c-f281d17ddaf4', 118.08)
INSERT INTO #TempData VALUES ('a77a5ea8-138f-4177-af3d-0f847cb7329a', 30.00)
INSERT INTO #TempData VALUES ('a77d69af-3b3a-4a56-975c-4f77852b44c6', 30.00)
INSERT INTO #TempData VALUES ('a8328a45-1664-4899-81b3-34b395cf66bb', 49.62)
INSERT INTO #TempData VALUES ('a8a49445-0867-48d4-8f1f-beb4f9a07c09', 30.00)
INSERT INTO #TempData VALUES ('a8f75c10-6b76-465e-adcc-21c13abe29b1', 30.00)
INSERT INTO #TempData VALUES ('a9324a4f-e865-4c44-be98-a0159fb0d966', 30.00)
INSERT INTO #TempData VALUES ('a93382a0-5447-4124-947c-26d0a51023a3', 32.23)
INSERT INTO #TempData VALUES ('a9497851-dc89-4272-ac5f-389294804469', 39.84)
INSERT INTO #TempData VALUES ('a96bea86-4375-4552-9267-a3bf0ea9f3c9', 30.00)
INSERT INTO #TempData VALUES ('a9fccba9-46ab-413a-9a23-a338fbd826ea', 30.00)
INSERT INTO #TempData VALUES ('aa1044ef-ac5e-4777-82e0-d4ea8ddd04fd', 30.00)
INSERT INTO #TempData VALUES ('aa1ec655-8aa0-47d8-b735-2996a169c246', 30.00)
INSERT INTO #TempData VALUES ('aa4dfa1e-72a4-4940-a249-f55fac4d05a2', 30.00)
INSERT INTO #TempData VALUES ('aa5d13f2-2a98-4fa5-9e91-466e4c0c374b', 30.00)
INSERT INTO #TempData VALUES ('aae89c4d-fc8f-4754-8a2d-d03d4ff46c64', 30.00)
INSERT INTO #TempData VALUES ('ab661001-7a17-4e49-a57c-0252c85eb705', 30.00)
INSERT INTO #TempData VALUES ('ab82b14e-1221-4cef-9796-af33a9f3ed3b', 30.00)
INSERT INTO #TempData VALUES ('abaca1e7-f2cb-4ea4-982d-68b688475e94', 30.00)
INSERT INTO #TempData VALUES ('abd0118c-bc59-4a01-9340-74b9f70e9033', 30.00)
INSERT INTO #TempData VALUES ('ac0cc1aa-fb3f-4a18-86f0-d553cf087a7f', 744.38)
INSERT INTO #TempData VALUES ('ac22b3f0-7f66-43d7-ae2c-f8678afebe48', 30.00)
INSERT INTO #TempData VALUES ('ac5b2868-b60c-4c1a-82e1-d7d6932f28ad', 30.00)
INSERT INTO #TempData VALUES ('ac82b7e5-7677-484b-b892-f46eff39a03e', 30.00)
INSERT INTO #TempData VALUES ('ac93ab3e-9405-4849-bb49-341c4c62038f', 30.00)
INSERT INTO #TempData VALUES ('acc0d680-52dc-4609-ad9d-06f16ac52cd4', 30.00)
INSERT INTO #TempData VALUES ('acc6bfc5-2949-4f4a-bb32-d9dca834b397', 247.04)
INSERT INTO #TempData VALUES ('ad7b645d-40df-4a5f-ba70-6a0078706755', 65.50)
INSERT INTO #TempData VALUES ('ad8f3c05-42fa-41ea-a7ea-c63501355a35', 30.00)
INSERT INTO #TempData VALUES ('ad932c22-c915-4b62-917f-abf6aa154d19', 60.00)
INSERT INTO #TempData VALUES ('ad9d3a9a-556b-477c-8988-42bef8b797a0', 30.00)
INSERT INTO #TempData VALUES ('adb3c3ef-0a08-44ca-8891-ea14626f2488', 127.83)
INSERT INTO #TempData VALUES ('adc14924-b307-4b39-963f-2ce9f6f69a3e', 30.00)
INSERT INTO #TempData VALUES ('ae01726c-158e-401a-b53f-8377fb601482', 30.00)
INSERT INTO #TempData VALUES ('ae3df7f0-7fb5-4342-9d8c-c220d0328d86', 30.00)
INSERT INTO #TempData VALUES ('aead7b27-9dcd-49ff-a99d-2add65c79649', 30.00)
INSERT INTO #TempData VALUES ('aeb74912-3f1a-4f1a-9e14-7a2685314776', 30.00)
INSERT INTO #TempData VALUES ('aecd7e35-0e9f-44fe-bce8-51215b55f064', 30.00)
INSERT INTO #TempData VALUES ('aeeaeb65-c0c2-402f-aeec-99e3cd47dcbd', 30.00)
INSERT INTO #TempData VALUES ('af046ee0-5fb8-4fe3-9e54-eb33b25c2416', 30.00)
INSERT INTO #TempData VALUES ('af04f665-ec65-4fe0-967e-0bdbc7f2feb2', 30.00)
INSERT INTO #TempData VALUES ('af30cfe3-fb17-4e2b-b1b2-7ca288e55541', 30.00)
INSERT INTO #TempData VALUES ('af30d431-d987-435c-9d53-9e7db1f25a51', 30.00)
INSERT INTO #TempData VALUES ('af378589-cf77-4c14-9bd3-a8bbee0ca648', 30.00)
INSERT INTO #TempData VALUES ('af54a8fc-eb64-4296-b055-0f19871a793e', 30.00)
INSERT INTO #TempData VALUES ('af76dedd-63a8-4774-82f3-a4c1dec7484c', 30.00)
INSERT INTO #TempData VALUES ('aff5defe-5e30-4842-82af-6f2b605884c7', 30.00)
INSERT INTO #TempData VALUES ('b02dc2c0-909b-4f0c-b52e-09548a6cc46d', 115.60)
INSERT INTO #TempData VALUES ('b061e0a3-2cdc-46b9-a9d2-9995b4e2bb7c', 30.00)
INSERT INTO #TempData VALUES ('b090baa5-f3ce-4a76-91f3-b8348525f1e4', 30.00)
INSERT INTO #TempData VALUES ('b0cdc5bd-04ea-47e0-b287-3c6d4ee56160', 30.00)
INSERT INTO #TempData VALUES ('b0d67a31-66ab-42b4-996c-8617db267814', 30.00)
INSERT INTO #TempData VALUES ('b17d362e-9a7f-4e12-b0da-372e7667ab6e', 30.00)
INSERT INTO #TempData VALUES ('b1a7792a-c772-48f4-a995-42ed830f76f2', 30.00)
INSERT INTO #TempData VALUES ('b244f505-aa41-4b8f-bb3b-a2a4aca6f9cc', 30.00)
INSERT INTO #TempData VALUES ('b2990e54-5809-4a4d-a8c2-ad24286e79c5', 30.00)
INSERT INTO #TempData VALUES ('b2c6074b-7a8f-45d2-949a-61d2740e7f48', 30.00)
INSERT INTO #TempData VALUES ('b3afe672-9f5c-4408-b374-f2cda87c9775', 30.00)
INSERT INTO #TempData VALUES ('b3c38025-05de-44b9-9b25-165f02119379', 30.00)
INSERT INTO #TempData VALUES ('b3d54ca9-5c33-4049-aadd-c8173a617bc9', 30.00)
INSERT INTO #TempData VALUES ('b3e992ae-b16c-44a5-944d-b0018d941c30', 30.00)
INSERT INTO #TempData VALUES ('b3ecdb87-9dde-470b-8520-13cd8069ba02', 49.77)
INSERT INTO #TempData VALUES ('b44ece04-1c1f-4abf-9d24-86ee8a5a758d', 30.00)
INSERT INTO #TempData VALUES ('b46f3ab2-47f2-4bd4-8ccd-6fc1c219ecb8', 30.00)
INSERT INTO #TempData VALUES ('b4d15410-4b8c-40fa-b037-06c40725cd5a', 30.00)
INSERT INTO #TempData VALUES ('b4d158b5-dd23-41e1-9db0-453dc687c0be', 30.00)
INSERT INTO #TempData VALUES ('b4fbafeb-0580-4d5c-9858-485d149b1b62', 30.00)
INSERT INTO #TempData VALUES ('b506808d-3c0b-42b1-9e1f-e026e4272cd2', 30.00)
INSERT INTO #TempData VALUES ('b537dc6f-8ee4-4a2a-9f85-f3a56bbd2e69', 30.00)
INSERT INTO #TempData VALUES ('b55a91fc-e545-4328-8139-f64b826bc8a8', 30.00)
INSERT INTO #TempData VALUES ('b55ee7d6-332a-4e0c-9544-bffd35506822', 30.00)
INSERT INTO #TempData VALUES ('b56beb82-ccd3-48d8-b014-f9812391fa89', 30.00)
INSERT INTO #TempData VALUES ('b5b36a1c-632e-470a-8e7d-a705d043fb48', 30.00)
INSERT INTO #TempData VALUES ('b5df2a25-d318-4a23-8a15-3b41e823b913', 30.00)
INSERT INTO #TempData VALUES ('b615665e-1b70-4c1d-a430-5647560b88d7', 30.00)
INSERT INTO #TempData VALUES ('b6181ad6-62fd-41d0-8164-46aec5ee4fc1', 30.00)
INSERT INTO #TempData VALUES ('b673410b-cc47-4876-b961-8fac984e063a', 70.33)
INSERT INTO #TempData VALUES ('b68d6360-b46b-445f-86c1-0a60740a0d54', 30.00)
INSERT INTO #TempData VALUES ('b7011773-2450-4e4f-8441-bd32099bfda2', 30.00)
INSERT INTO #TempData VALUES ('b729e922-7754-4e3a-b717-9c696ef20483', 30.00)
INSERT INTO #TempData VALUES ('b73e1ad8-e26e-497f-9058-7e2869c5ee6d', 30.00)
INSERT INTO #TempData VALUES ('b7443e3e-a11a-433d-ac6c-889f21d10ab1', 30.00)
INSERT INTO #TempData VALUES ('b75c8ab2-e049-4158-b62c-d30c7c96c468', 30.00)
INSERT INTO #TempData VALUES ('b8106d3c-b6f7-498f-ad95-b9d31c99c0bd', 84.55)
INSERT INTO #TempData VALUES ('b8170dec-dd21-4a65-be8b-95d6193daa86', 30.00)
INSERT INTO #TempData VALUES ('b82650dc-4e31-438d-870c-3bc6ae1947dd', 896.61)
INSERT INTO #TempData VALUES ('b8282503-a87d-47b9-b507-2f5b61413ba8', 30.00)
INSERT INTO #TempData VALUES ('b8548af9-d855-4857-8957-3323d9bf605d', 263.44)
INSERT INTO #TempData VALUES ('b8bfc7e9-9df5-445d-92e9-29bb6bd1c4ee', 30.00)
INSERT INTO #TempData VALUES ('b91a658e-3c45-4021-916d-bd3f5d53d5a6', 30.00)
INSERT INTO #TempData VALUES ('b93a7c48-115b-4f9a-bf74-d88281274b37', 30.00)
INSERT INTO #TempData VALUES ('b94b0eba-81a0-4d79-9595-ed724b9dd66c', 266.47)
INSERT INTO #TempData VALUES ('b9b5f27c-9270-44e5-ad7c-47ff7e3b1b05', 90.00)
INSERT INTO #TempData VALUES ('b9b8b307-3613-468c-86e5-359a991e8080', 30.00)
INSERT INTO #TempData VALUES ('b9c7af7a-6e0e-4e03-9a84-b45a9a697876', 30.00)
INSERT INTO #TempData VALUES ('ba5dfe1d-b71d-4324-8571-a401cd8e4552', 30.00)
INSERT INTO #TempData VALUES ('ba82e7ba-4218-445d-9811-b8a8a5e9b9fb', 30.00)
INSERT INTO #TempData VALUES ('babd051f-311e-45b4-8598-e33fa4a46516', 30.00)
INSERT INTO #TempData VALUES ('bac0520a-3693-4468-a889-06113dd6945f', 30.00)
INSERT INTO #TempData VALUES ('baf24637-3733-4608-b03b-b8480a8e9ebe', 33.77)
INSERT INTO #TempData VALUES ('baf8a5d9-20ef-43ec-ad5f-572360a5c847', 30.00)
INSERT INTO #TempData VALUES ('bafd97ec-aad7-4020-b345-cf6233a53c52', 30.00)
INSERT INTO #TempData VALUES ('bc43705c-4e30-4bc1-ace0-87d67b17f04a', 30.00)
INSERT INTO #TempData VALUES ('bd422d2c-3c1b-4e31-9f0a-1f49257ab7f0', 155.55)
INSERT INTO #TempData VALUES ('bd69c54a-9230-4e64-8ff8-be0d8c375eb0', 51.53)
INSERT INTO #TempData VALUES ('bdae99d5-3104-470a-94bd-1d946e8cc2c8', 30.00)
INSERT INTO #TempData VALUES ('bdb4cb04-f76e-4173-a701-fa4cd1dc8d1e', 36.65)
INSERT INTO #TempData VALUES ('bdbb2285-f808-4e37-84f4-deef8a01b7bf', 30.00)
INSERT INTO #TempData VALUES ('bdc7c712-138f-4ca5-8be5-916786e6db79', 30.00)
INSERT INTO #TempData VALUES ('bdd38685-8ab8-4035-9ef5-ef3345b48a68', 30.00)
INSERT INTO #TempData VALUES ('bde28bbe-e56f-4d49-8b4d-90cd9ec7bf04', 30.00)
INSERT INTO #TempData VALUES ('bde8f8cc-adab-4909-ab2a-1014739ddcbc', 30.00)
INSERT INTO #TempData VALUES ('be1c6921-a690-4ed7-be97-b5d786454816', 30.00)
INSERT INTO #TempData VALUES ('be26f97e-8910-4158-9349-35c14e1801e8', 30.00)
INSERT INTO #TempData VALUES ('be29723d-e43c-4d03-b544-658fa1ee5e67', 30.00)
INSERT INTO #TempData VALUES ('be2d59e8-1238-4daf-bdea-77f0802b41c2', 30.00)
INSERT INTO #TempData VALUES ('be6e77ac-9fb6-4dcd-9145-6b5f9a847d59', 30.00)
INSERT INTO #TempData VALUES ('bead70c3-5592-4487-a64c-f1a61774e177', 30.00)
INSERT INTO #TempData VALUES ('bf1c9cb2-d02a-49a2-a252-f75337b29bfd', 30.00)
INSERT INTO #TempData VALUES ('bf4f642c-816a-4caf-82f8-6f04fb883876', 30.00)
INSERT INTO #TempData VALUES ('bf5ed2fa-62ac-47d1-a98f-ec3762992eea', 30.00)
INSERT INTO #TempData VALUES ('bf6bd738-53ca-4f00-9b42-e38cbceb2eb6', 76.64)
INSERT INTO #TempData VALUES ('bf8ef66e-227f-4ea8-8fe3-4d50ca4b2d19', 30.00)
INSERT INTO #TempData VALUES ('c00225bc-fbde-42b2-9d8c-4e3d2e99ee3e', 30.00)
INSERT INTO #TempData VALUES ('c04ed889-fc25-4407-8666-b7c90c544e6f', 30.00)
INSERT INTO #TempData VALUES ('c0912f16-178a-4a00-a698-c272d3338ecc', 30.00)
INSERT INTO #TempData VALUES ('c0b4be4d-6ba5-4a2f-adfa-a9ed4d1ad389', 30.00)
INSERT INTO #TempData VALUES ('c0d5bcf6-abc2-4ac9-865e-2d6bae41fcd9', 30.00)
INSERT INTO #TempData VALUES ('c0f06872-4571-43cb-b570-71f80a191230', 30.00)
INSERT INTO #TempData VALUES ('c1312f37-77bc-4d95-904b-ed78980475ff', 60.00)
INSERT INTO #TempData VALUES ('c18cc23e-c48d-4ef8-a24c-122f3784ec64', 30.00)
INSERT INTO #TempData VALUES ('c19cf85f-2399-4447-b121-31e6a125eff0', 30.00)
INSERT INTO #TempData VALUES ('c1b8686f-20e9-4da2-b369-be36d2dee15b', 30.00)
INSERT INTO #TempData VALUES ('c24a5899-7e08-4dd8-9f4e-b3577605ed48', 30.00)
INSERT INTO #TempData VALUES ('c28770b5-2487-4d26-9bb2-25cb3834c7cb', 30.00)
INSERT INTO #TempData VALUES ('c2c3cd68-bf23-47c6-82ea-ac17f4e0ec20', 30.00)
INSERT INTO #TempData VALUES ('c2c4ff8c-cca1-40ca-b424-da32d3289f2c', 161.36)
INSERT INTO #TempData VALUES ('c2ec3539-72d5-49df-8092-363d32bc6dca', 162.85)
INSERT INTO #TempData VALUES ('c33985ce-bea1-4392-af08-83e65b22255e', 30.00)
INSERT INTO #TempData VALUES ('c36df994-cbab-4bbf-ac0f-a3dd08fd60b5', 30.00)
INSERT INTO #TempData VALUES ('c3794608-0e31-42e1-a2a4-428b92caeb7d', 30.00)
INSERT INTO #TempData VALUES ('c43eda7f-29a9-4e79-b9f4-002321b7094e', 30.00)
INSERT INTO #TempData VALUES ('c4c1d6be-2415-4ea4-844f-e27cf3378fe4', 30.00)
INSERT INTO #TempData VALUES ('c4f66267-50f4-422c-ad49-469afe433149', 30.00)
INSERT INTO #TempData VALUES ('c550aed5-19d9-416b-beb4-4ca95b209e28', 30.00)
INSERT INTO #TempData VALUES ('c56db1e4-6ec5-4189-b22c-db63947fe750', 79.50)
INSERT INTO #TempData VALUES ('c616ff03-5c37-4a9b-8b6e-f34be2af93de', 30.00)
INSERT INTO #TempData VALUES ('c6b41ace-270e-4f3d-a29a-47da6588b084', 30.00)
INSERT INTO #TempData VALUES ('c6c65c6c-3861-4bb5-a9d7-aeb6c894ab9d', 30.00)
INSERT INTO #TempData VALUES ('c6e39f25-cb8d-4ff8-a464-a7a25aa7b3a5', 30.00)
INSERT INTO #TempData VALUES ('c71ec597-9c1d-443b-a5e5-1b0643a9d05e', 30.00)
INSERT INTO #TempData VALUES ('c7263860-2a9f-411e-a2f4-418212be10c3', 30.00)
INSERT INTO #TempData VALUES ('c7632bd1-e727-47a6-a38f-ea29001fd812', 68.12)
INSERT INTO #TempData VALUES ('c7b9d170-c590-4e3c-9cd7-0dae36ecccbc', 30.00)
INSERT INTO #TempData VALUES ('c8134ac8-1786-427c-8513-eaa8757e2901', 30.00)
INSERT INTO #TempData VALUES ('c820c84a-cbb4-4076-9dd6-965d11cda993', 30.00)
INSERT INTO #TempData VALUES ('c8572554-129b-444d-bbaf-c1153d9b23bb', 229.22)
INSERT INTO #TempData VALUES ('c8622e1b-99ed-4a45-94b4-c12f6863d0c5', 30.00)
INSERT INTO #TempData VALUES ('c88a92ba-bd9b-4649-80b2-ffd73d25411a', 30.00)
INSERT INTO #TempData VALUES ('c8b3add6-afe4-4452-b15f-56d89accec38', 348.86)
INSERT INTO #TempData VALUES ('c8c7c8cc-b392-43bd-9999-b10aae4ba5c7', 30.00)
INSERT INTO #TempData VALUES ('c92a208b-f895-4f40-a9aa-2efaa1aef6d4', 30.00)
INSERT INTO #TempData VALUES ('c92f1518-6e6c-445b-9487-fae9930f4336', 30.00)
INSERT INTO #TempData VALUES ('c9596fb4-9ca1-46d2-9d9e-0cca27e24f8f', 30.00)
INSERT INTO #TempData VALUES ('c97bdf16-1be9-4deb-be0f-19c5ca8dd7de', 30.00)
INSERT INTO #TempData VALUES ('c98c49a8-cd0b-4566-b1b2-7079a5bf1047', 30.00)
INSERT INTO #TempData VALUES ('c99ea942-c4e6-4c36-8101-32635bd09353', 30.00)
INSERT INTO #TempData VALUES ('c9af4dd7-9d19-4a8b-9e4e-20de78c08a3c', 31.10)
INSERT INTO #TempData VALUES ('c9f055f0-4380-4358-9696-54b31d8076db', 30.00)
INSERT INTO #TempData VALUES ('ca0d91fb-4eee-406e-9209-80d1adddda88', 30.00)
INSERT INTO #TempData VALUES ('ca89eb2b-032e-44c2-b0a9-0d9e366ee942', 30.00)
INSERT INTO #TempData VALUES ('cacebfe0-2b75-4046-b1b4-41c4f9352fd1', 30.00)
INSERT INTO #TempData VALUES ('cb1971fa-6622-4b5b-be59-2ea9a6c4e324', 30.00)
INSERT INTO #TempData VALUES ('cb1e0439-e959-45d8-9326-486a3f6e2aa0', 30.00)
INSERT INTO #TempData VALUES ('cb3d8a59-50dd-4b9f-bda8-6b893f559ee9', 279.58)
INSERT INTO #TempData VALUES ('cbf55dfa-89d4-4df3-abb1-47a3028769aa', 30.00)
INSERT INTO #TempData VALUES ('cd553c64-2955-45c9-8a0a-b652a9ab3ecf', 30.00)
INSERT INTO #TempData VALUES ('cd74a623-cb97-4fa8-b680-f11f0fc342fa', 30.00)
INSERT INTO #TempData VALUES ('cd7f9c54-5f47-491a-916c-f14ae7733e6f', 30.00)
INSERT INTO #TempData VALUES ('cdd000c0-6bb7-451a-94c7-31c864b120d2', 30.00)
INSERT INTO #TempData VALUES ('ce4ea612-604c-446b-a38c-83ae498a2088', 30.00)
INSERT INTO #TempData VALUES ('ce89d29c-a371-467b-9e4c-df519b3efb33', 146.20)
INSERT INTO #TempData VALUES ('ce8e0c04-bf4f-4118-8da0-9bf1efd5ad55', 54.02)
INSERT INTO #TempData VALUES ('cead649c-255a-4b08-a24f-d77a80d99753', 30.00)
INSERT INTO #TempData VALUES ('cecfa6b4-2405-42d8-9e2e-d270fb18d013', 30.00)
INSERT INTO #TempData VALUES ('cedf1305-53aa-4271-a281-73fb58f15499', 30.00)
INSERT INTO #TempData VALUES ('cf441a0c-fc58-4130-9698-644e8eccd670', 30.00)
INSERT INTO #TempData VALUES ('cf68c687-72a1-45be-9dab-63ce40fc8a14', 30.00)
INSERT INTO #TempData VALUES ('cf69e680-0027-4e8e-8860-dda97bd074aa', 30.00)
INSERT INTO #TempData VALUES ('cfeb068c-1db1-4f01-b66a-94c46caaca12', 30.00)
INSERT INTO #TempData VALUES ('d05380d5-2938-4b13-9b52-2785fc03b591', 30.00)
INSERT INTO #TempData VALUES ('d083bada-0cf7-40a2-87be-791de4ff31d2', 30.00)
INSERT INTO #TempData VALUES ('d0b0d03c-597e-459f-bc4a-736f2c417581', 30.00)
INSERT INTO #TempData VALUES ('d159398d-4d5d-4871-8872-944afa2b725a', 30.00)
INSERT INTO #TempData VALUES ('d15a3e6a-9a58-4951-80bc-6d3d16622204', 30.00)
INSERT INTO #TempData VALUES ('d16e8941-33fc-4721-ac48-aaa6a40e31c3', 50.27)
INSERT INTO #TempData VALUES ('d180fe69-e923-435b-9136-4acaf143d663', 30.00)
INSERT INTO #TempData VALUES ('d1c6a2b1-7a3e-4f49-8b8b-94446d0162c4', 30.00)
INSERT INTO #TempData VALUES ('d2000075-a4cc-47c6-b832-8ecb7542779e', 30.00)
INSERT INTO #TempData VALUES ('d20595a0-a09f-4167-9732-594cd6ed3cea', 30.00)
INSERT INTO #TempData VALUES ('d2083ca8-561a-4ba2-932c-5a648ee14e69', 30.00)
INSERT INTO #TempData VALUES ('d228ac39-b6eb-4897-a2e2-11d178e19046', 30.00)
INSERT INTO #TempData VALUES ('d232bfe6-42ee-47cf-a80d-0dec2426a9c6', 30.00)
INSERT INTO #TempData VALUES ('d254f983-1219-493a-90dc-2fe482fdc3a3', 30.00)
INSERT INTO #TempData VALUES ('d29f3301-70a3-499a-aa06-3cda63c2d906', 30.00)
INSERT INTO #TempData VALUES ('d2d16904-91b7-4ac7-bd01-0329741a2f9b', 30.00)
INSERT INTO #TempData VALUES ('d2f37acd-17be-4f9f-8560-47a138facc84', 60.00)
INSERT INTO #TempData VALUES ('d304d251-418b-4b12-a3b0-3e8b79ea8b6f', 30.00)
INSERT INTO #TempData VALUES ('d3205e09-1ded-40fd-888b-4f4dcca20f3e', 30.00)
INSERT INTO #TempData VALUES ('d356ee02-c78c-4d75-a7b7-a1c0758ed1a5', 30.00)
INSERT INTO #TempData VALUES ('d363002e-0708-48b3-956f-36df4a21471f', 30.00)
INSERT INTO #TempData VALUES ('d3eae135-d882-4241-ac34-647f3948ba80', 30.00)
INSERT INTO #TempData VALUES ('d423fc58-9a98-4d20-820f-947ae222772c', 30.00)
INSERT INTO #TempData VALUES ('d43b0348-7d42-4b31-8e5d-27cb041798b3', 30.00)
INSERT INTO #TempData VALUES ('d446698d-432d-49b9-8244-b0a2044428b7', 30.00)
INSERT INTO #TempData VALUES ('d497e191-1f9a-42a7-8b3f-12e9a6e38527', 30.00)
INSERT INTO #TempData VALUES ('d4db4bbc-81f9-494d-be73-07d355e7e184', 60.00)
INSERT INTO #TempData VALUES ('d4ea879e-36a9-4ab0-b9ed-d4cd46cd912d', 30.00)
INSERT INTO #TempData VALUES ('d5169f9a-6f1a-422a-aa87-a7693e8d7ae5', 60.00)
INSERT INTO #TempData VALUES ('d532f994-28a7-4016-833f-cf889159f3be', 30.00)
INSERT INTO #TempData VALUES ('d53943ab-3a47-45a2-b501-264e017eb6a6', 30.00)
INSERT INTO #TempData VALUES ('d552bf34-ea48-4719-a1e9-4445e4408027', 30.00)
INSERT INTO #TempData VALUES ('d559d83c-b38a-49a6-b870-ef89aa4693d8', 30.00)
INSERT INTO #TempData VALUES ('d55ce5e0-7463-4504-96cc-f289a496479d', 30.00)
INSERT INTO #TempData VALUES ('d575dd1b-5f4f-4906-9e6f-329babab6e49', 30.00)
INSERT INTO #TempData VALUES ('d57f8309-2521-4d8f-a52a-f8977c1428bd', 30.00)
INSERT INTO #TempData VALUES ('d5f266ea-7187-4019-a4c5-375b1a5bc858', 30.00)
INSERT INTO #TempData VALUES ('d5f418c6-3c3b-4439-a2cb-f0fbc10fb552', 30.00)
INSERT INTO #TempData VALUES ('d6256064-dadb-4fc4-941d-604f47493e35', 30.00)
INSERT INTO #TempData VALUES ('d6790a98-ae05-4895-9a60-a49a85e7822d', 30.00)
INSERT INTO #TempData VALUES ('d6cb3c2b-4d88-46e5-9491-4f4d683a229b', 30.00)
INSERT INTO #TempData VALUES ('d6cf6a55-0431-49ed-9183-c49483945a66', 30.00)
INSERT INTO #TempData VALUES ('d6da5c92-5160-454e-a95d-5b2c010d551f', 30.00)
INSERT INTO #TempData VALUES ('d76c8a9c-083e-43a5-90b6-44662bc488e4', 30.00)
INSERT INTO #TempData VALUES ('d772f314-db22-42b3-9b69-b17123784d03', 30.00)
INSERT INTO #TempData VALUES ('d7c2f24f-aa2c-4e36-853a-5051ad700e13', 30.00)
INSERT INTO #TempData VALUES ('d7d0db9b-5ae9-410a-ae43-6b5da969183a', 84.45)
INSERT INTO #TempData VALUES ('d7f48b00-ab1b-44fe-9d19-e17bee392451', 51.54)
INSERT INTO #TempData VALUES ('d867cb3b-c24d-4e7c-8d24-f163957c9e48', 30.00)
INSERT INTO #TempData VALUES ('d87ace37-0581-40b1-823f-7e6117e24cc5', 187.73)
INSERT INTO #TempData VALUES ('d89ba538-91aa-43d2-b265-729bf48c422f', 40.37)
INSERT INTO #TempData VALUES ('d8d8922e-2eb1-4c2e-b751-b016fa4e4a0f', 30.00)
INSERT INTO #TempData VALUES ('d93c97cf-3088-46fb-bf11-9fd8eee9408a', 30.00)
INSERT INTO #TempData VALUES ('d94577e5-cc2c-4304-9c8c-dc58c27ad993', 30.00)
INSERT INTO #TempData VALUES ('d99cc208-bb96-45fa-9974-852e1da9f14b', 30.00)
INSERT INTO #TempData VALUES ('d9d1a527-cfdd-4a20-9cc6-27b677b31f75', 97.87)
INSERT INTO #TempData VALUES ('dabb2a27-642b-40e4-96d8-ef7fc13511b2', 30.00)
INSERT INTO #TempData VALUES ('db125c45-56b5-4f98-8f98-2d680e4d2102', 30.00)
INSERT INTO #TempData VALUES ('db24f7b8-ebe0-4040-9771-a506af186aae', 30.00)
INSERT INTO #TempData VALUES ('db4926b1-d7df-4062-91bc-fceda13e747d', 30.00)
INSERT INTO #TempData VALUES ('dbbc3820-bb93-4d23-b94f-4a1ceea8b52d', 274.22)
INSERT INTO #TempData VALUES ('dc0c4000-c619-4c24-8a91-6508e0b48fa5', 30.00)
INSERT INTO #TempData VALUES ('dc0e0b71-f48f-493a-91e3-186dd4f3d287', 30.00)
INSERT INTO #TempData VALUES ('dc28f56f-4413-4700-9692-956d243a3305', 30.00)
INSERT INTO #TempData VALUES ('dc7a8aa7-0169-46b6-96be-22dabc792048', 80.29)
INSERT INTO #TempData VALUES ('dcb1d624-df12-46b8-8249-452630b90be5', 109.66)
INSERT INTO #TempData VALUES ('dcd3efdd-d35a-40b2-a185-379218c11953', 30.00)
INSERT INTO #TempData VALUES ('dcd7ec9e-7f23-45f3-9d98-089f96d27905', 30.00)
INSERT INTO #TempData VALUES ('dd5046e7-4f8f-453a-a984-c89d7d1a5d3a', 30.00)
INSERT INTO #TempData VALUES ('dd9e8c69-8c5e-4c2a-883b-fa1437001ed0', 30.00)
INSERT INTO #TempData VALUES ('ddb9309b-452d-4fc7-a9e2-a0c45117f6a1', 30.00)
INSERT INTO #TempData VALUES ('dde9cdf7-7064-4256-9440-860b1eeebd53', 30.00)
INSERT INTO #TempData VALUES ('de2342f1-f4f7-41dc-9775-1c3d88db66ff', 30.00)
INSERT INTO #TempData VALUES ('de3bfe90-ce98-4f99-a223-7407d9fc7295', 37.34)
INSERT INTO #TempData VALUES ('de3cf10c-e4d7-4a88-b9fc-a380e9ea560f', 30.00)
INSERT INTO #TempData VALUES ('df50bc6f-ad97-481c-b4cf-1cfea91c2388', 30.00)
INSERT INTO #TempData VALUES ('e001bd7b-2c00-4974-b08f-ab1b6c3e96aa', 30.00)
INSERT INTO #TempData VALUES ('e0269370-cde8-4f86-90ba-11935ad80b16', 30.00)
INSERT INTO #TempData VALUES ('e0780584-2ca5-483e-9e5c-0f2f09f0f567', 30.00)
INSERT INTO #TempData VALUES ('e08262b8-4213-455b-9c42-5a27a9a92f9a', 30.00)
INSERT INTO #TempData VALUES ('e0a22e56-73ea-4622-b3ac-3ac2d98f656f', 30.00)
INSERT INTO #TempData VALUES ('e0ec415a-ca6f-4dd7-84e1-209b50931dc3', 30.00)
INSERT INTO #TempData VALUES ('e10b7eb7-431c-4360-9109-9808bdd0e855', 30.00)
INSERT INTO #TempData VALUES ('e1290d36-0902-4acb-acbb-63d47f196302', 30.61)
INSERT INTO #TempData VALUES ('e1a98b0a-b86f-49ab-9ac0-be4c1e231562', 66.58)
INSERT INTO #TempData VALUES ('e1ae4553-10e8-49f0-a2c5-6967c5d431f6', 30.00)
INSERT INTO #TempData VALUES ('e1c92983-9ee8-4439-b1b3-4ce14316f8ff', 30.00)
INSERT INTO #TempData VALUES ('e1f66662-c512-4e45-baaf-3e6171bffce2', 30.00)
INSERT INTO #TempData VALUES ('e21a117b-2fb1-453b-984f-efeb23ddd55a', 30.00)
INSERT INTO #TempData VALUES ('e240d7f0-fb73-4e33-b06f-752f12aafa31', 30.00)
INSERT INTO #TempData VALUES ('e24b0622-86d4-4a6a-84ae-f7aea9c27967', 30.00)
INSERT INTO #TempData VALUES ('e29b4e8c-1c02-4101-93aa-999be8b24bac', 30.00)
INSERT INTO #TempData VALUES ('e2cea7a4-9ccf-4ba1-866c-6d7a4d775ca4', 30.00)
INSERT INTO #TempData VALUES ('e2effffd-83d0-44b8-bca7-ef9bd60d4ce8', 30.00)
INSERT INTO #TempData VALUES ('e307c47e-e547-4a2d-9c02-64edf88f2de8', 30.00)
INSERT INTO #TempData VALUES ('e37fe2e9-03f9-47f9-93a4-af4d93ac84b3', 30.00)
INSERT INTO #TempData VALUES ('e3817c71-57a7-465b-88a6-f6028403e3b1', 30.00)
INSERT INTO #TempData VALUES ('e393a30a-ba61-4813-aa93-e36dc96a85c4', 30.00)
INSERT INTO #TempData VALUES ('e3d2a37e-db18-4b18-85bf-a4b6b227c33c', 30.00)
INSERT INTO #TempData VALUES ('e3e83a60-ce1d-459b-b5cf-2664e1b17c9e', 30.00)
INSERT INTO #TempData VALUES ('e3f45b3f-30a2-4dea-938c-8fac9d9ae229', 30.00)
INSERT INTO #TempData VALUES ('e40ed86b-e8f4-4f9a-bb3a-f32b656dcc80', 30.00)
INSERT INTO #TempData VALUES ('e479acc2-707b-46ba-b378-d63c897f4fd5', 30.00)
INSERT INTO #TempData VALUES ('e4860849-62cd-4e9e-9b31-2a90c65ed26a', 30.00)
INSERT INTO #TempData VALUES ('e4879ee9-23e8-4d96-ba54-0429c9df6034', 30.00)
INSERT INTO #TempData VALUES ('e49a923e-1147-4935-a28a-2b5ab096fc1a', 30.00)
INSERT INTO #TempData VALUES ('e4b9ebda-1610-438b-9e53-090c7b369361', 30.00)
INSERT INTO #TempData VALUES ('e4faeafb-7d96-436d-b41a-afb54d3d52b1', 30.64)
INSERT INTO #TempData VALUES ('e516bb78-5d68-4964-ad29-a1bf1bdbcf13', 30.00)
INSERT INTO #TempData VALUES ('e52094eb-5710-4331-91c5-841977f7e58a', 30.00)
INSERT INTO #TempData VALUES ('e53cc43d-f710-4bad-8a38-065595c59fbf', 30.00)
INSERT INTO #TempData VALUES ('e58a2b09-9216-4ba6-8fed-48ec2e7c2d0f', 30.00)
INSERT INTO #TempData VALUES ('e58b6eb6-130b-4bcf-a588-dac636020e2f', 30.00)
INSERT INTO #TempData VALUES ('e5a2fb27-3493-415e-9885-574d0cd90416', 30.00)
INSERT INTO #TempData VALUES ('e5abd6dc-2fb5-4c69-a7a4-ba4ec4352384', 30.00)
INSERT INTO #TempData VALUES ('e5b96aec-98be-4cb9-9928-120dde7ae57a', 197.93)
INSERT INTO #TempData VALUES ('e5f328ef-4539-4749-936d-e8e2f927e0f1', 30.00)
INSERT INTO #TempData VALUES ('e66ef230-0ff7-4ac3-b89a-7e0fb4bb999a', 30.00)
INSERT INTO #TempData VALUES ('e6a6505a-2000-406a-9438-7af3860955c6', 47.37)
INSERT INTO #TempData VALUES ('e72ecf4c-f221-428f-af03-1f6691a87119', 30.00)
INSERT INTO #TempData VALUES ('e739f616-93e2-4071-8e5a-f2b60ec47ae9', 60.00)
INSERT INTO #TempData VALUES ('e74381c7-7286-4b7d-b0e1-fac8d45a32b1', 30.00)
INSERT INTO #TempData VALUES ('e7a33ae6-41d0-465e-84f2-a0df672c66dd', 30.00)
INSERT INTO #TempData VALUES ('e7ca0b4c-4e57-4ee0-abad-54123e7af4ad', 30.00)
INSERT INTO #TempData VALUES ('e8447d87-72e3-41d4-95c8-0f932feb6ed1', 30.00)
INSERT INTO #TempData VALUES ('e873180b-fb3f-405b-a34d-ecf9ab5b35b5', 30.00)
INSERT INTO #TempData VALUES ('e8849d9f-9f5d-4128-a090-1ffb29f862d8', 30.00)
INSERT INTO #TempData VALUES ('e8d095db-a58b-4610-9953-cd04b9356eaf', 30.00)
INSERT INTO #TempData VALUES ('e8f4a36c-a5c1-440a-8bfa-e14737182ef1', 30.00)
INSERT INTO #TempData VALUES ('e9562c9f-f09e-462c-87a5-df2ba9d35102', 30.00)
INSERT INTO #TempData VALUES ('e9f29262-52f0-4ca3-aed8-e6e10c14da94', 30.00)
INSERT INTO #TempData VALUES ('ea2e8e5e-da0d-47bb-9150-6e0667fd2f6f', 30.00)
INSERT INTO #TempData VALUES ('ea40050c-474e-4d41-a88f-f872b2e9c891', 30.00)
INSERT INTO #TempData VALUES ('ea938f28-2283-4532-9c4e-04d3b8c86b67', 30.00)
INSERT INTO #TempData VALUES ('eaf7c452-22d6-4077-b38f-3f46d2262499', 30.00)
INSERT INTO #TempData VALUES ('eb0e27c8-bf5e-4b76-a856-2667d1ceec5c', 30.00)
INSERT INTO #TempData VALUES ('ebc4530f-3545-497f-a97a-5377a61a8508', 30.00)
INSERT INTO #TempData VALUES ('ec533c2c-9599-49a2-899a-f09722f4100b', 30.00)
INSERT INTO #TempData VALUES ('ecfbc3b5-f0d7-4e98-919f-656fe84c7dfd', 30.00)
INSERT INTO #TempData VALUES ('ed11a142-ed0b-4030-a368-ba9cabe6a643', 30.00)
INSERT INTO #TempData VALUES ('ed14d682-2dcb-4d6e-a25e-34e357a37a91', 30.00)
INSERT INTO #TempData VALUES ('ed2c582b-d086-4552-9f31-211858b225d1', 30.00)
INSERT INTO #TempData VALUES ('ed7a31bf-057a-414b-b12c-63eb8732193d', 30.00)
INSERT INTO #TempData VALUES ('edb716d1-0f3c-4240-8a9e-f8ba88f0c74f', 30.00)
INSERT INTO #TempData VALUES ('ee1440f7-15ce-45d2-a243-88a3d4bea8cd', 30.00)
INSERT INTO #TempData VALUES ('ee3b3cde-1890-4d5f-b78a-6ee8034160bb', 30.00)
INSERT INTO #TempData VALUES ('ee5df362-d05a-4314-bb44-eb3151148d52', 30.00)
INSERT INTO #TempData VALUES ('ee9d0c44-40cb-49eb-a3f3-a3b565050f63', 30.00)
INSERT INTO #TempData VALUES ('eedabd57-b7b5-48f7-abbe-24cdd9617b37', 30.00)
INSERT INTO #TempData VALUES ('eef34174-8234-4d68-97bb-5c26a04cb96c', 30.00)
INSERT INTO #TempData VALUES ('eff4e4e2-b7de-4f04-869c-11638caac85b', 30.00)
INSERT INTO #TempData VALUES ('f02efaa2-1127-4808-9b97-d39bc0713372', 30.00)
INSERT INTO #TempData VALUES ('f03a49b6-ee74-43d8-b565-689bdebd7d74', 30.00)
INSERT INTO #TempData VALUES ('f0428e9f-19d7-4b23-a87f-f3cc7e378eed', 30.00)
INSERT INTO #TempData VALUES ('f07799dc-4926-4594-a290-78843e8370df', 30.00)
INSERT INTO #TempData VALUES ('f07d6b73-a4bb-48b3-be21-39350e404b12', 30.00)
INSERT INTO #TempData VALUES ('f0a560f1-349b-48e7-9526-19377d03e78b', 30.00)
INSERT INTO #TempData VALUES ('f0cef856-3f5e-4553-84ea-1395e47612cf', 30.00)
INSERT INTO #TempData VALUES ('f0d62f5b-d77c-4eca-a7ac-3a8b4f81bda3', 35.75)
INSERT INTO #TempData VALUES ('f13e6554-017b-434c-af28-21098ac802a9', 30.00)
INSERT INTO #TempData VALUES ('f14d90c7-172a-4cea-b6a6-368f79c48ce7', 30.00)
INSERT INTO #TempData VALUES ('f163969c-8ba3-4463-8b3e-2ed9656c9000', 30.00)
INSERT INTO #TempData VALUES ('f1b3276d-d178-45e5-9267-e15bc0edbf42', 30.00)
INSERT INTO #TempData VALUES ('f20eff94-86ec-4f20-9266-8c069088cd19', 30.00)
INSERT INTO #TempData VALUES ('f2281d68-f239-4b74-b051-c1c424af3de5', 70.66)
INSERT INTO #TempData VALUES ('f22b58dd-9a06-4b02-87ee-d7e34fe9f919', 30.00)
INSERT INTO #TempData VALUES ('f240e239-cf2f-4146-88cb-b2e6d82c0ac3', 30.00)
INSERT INTO #TempData VALUES ('f2a6f44b-97ce-4bbd-93b5-3db04fe2154e', 376.93)
INSERT INTO #TempData VALUES ('f301a08b-b258-4ec8-92c6-510e880fec4b', 30.00)
INSERT INTO #TempData VALUES ('f3b459c2-e5f2-448b-ace5-a9c237bdd999', 146.15)
INSERT INTO #TempData VALUES ('f3c07666-68d0-4896-97d6-0ec6dae3b38e', 30.00)
INSERT INTO #TempData VALUES ('f3d9beca-6a55-4815-956e-c4f78cb93179', 30.00)
INSERT INTO #TempData VALUES ('f3e27730-21ec-46ea-bc34-823f93af9d50', 30.00)
INSERT INTO #TempData VALUES ('f421d6ad-66b8-462b-be59-25e733eaa17f', 30.00)
INSERT INTO #TempData VALUES ('f4554490-e19f-4c01-84de-41fd517cfeeb', 30.00)
INSERT INTO #TempData VALUES ('f47ef9f1-b1cb-470e-94b3-a58494841a03', 75.62)
INSERT INTO #TempData VALUES ('f4ab4da6-8bea-4cdb-81d3-04a5ff79b099', 30.00)
INSERT INTO #TempData VALUES ('f4b5bc16-4bde-4092-9753-9eef6ec4f150', 30.00)
INSERT INTO #TempData VALUES ('f519a10b-aeab-4535-ae90-d99e09e00400', 201.17)
INSERT INTO #TempData VALUES ('f534953d-d76d-47e3-bb95-26637ab78a8a', 30.00)
INSERT INTO #TempData VALUES ('f5430158-4d9f-4a4d-bba3-26a14cb7bf34', 30.00)
INSERT INTO #TempData VALUES ('f559bdd5-435e-453e-ac8b-5d98245fac36', 60.00)
INSERT INTO #TempData VALUES ('f5a36dc1-c58f-426e-b2df-b88451435513', 30.00)
INSERT INTO #TempData VALUES ('f5d33b3a-71bf-4448-8678-bd1d034c18ad', 30.00)
INSERT INTO #TempData VALUES ('f637e289-83be-432b-aed0-25f0ca6cede2', 30.00)
INSERT INTO #TempData VALUES ('f643b866-9fa1-409f-b1cd-4ae55c6c1777', 30.00)
INSERT INTO #TempData VALUES ('f66fb604-bff7-4c28-8a4c-e79f22ebbe2b', 201.50)
INSERT INTO #TempData VALUES ('f6b18b73-1850-4fc5-b2eb-89420de98365', 30.00)
INSERT INTO #TempData VALUES ('f6cc5efe-f815-4bc0-a8e0-3f18a8c417d7', 30.00)
INSERT INTO #TempData VALUES ('f76e1f53-73e0-4ab4-8242-2e1428a3c22d', 30.00)
INSERT INTO #TempData VALUES ('f7f3108b-9145-47a0-ad66-b6833f6fa479', 116.81)
INSERT INTO #TempData VALUES ('f8883d7c-6426-451d-93fd-37b2c6b5b781', 30.00)
INSERT INTO #TempData VALUES ('f8b991b3-981c-41e1-b97b-b2b17e0b8815', 30.00)
INSERT INTO #TempData VALUES ('f91bbd1b-959e-4711-9058-eb1197bd5f39', 30.00)
INSERT INTO #TempData VALUES ('f925d453-787d-44dc-865b-9c465c757298', 30.00)
INSERT INTO #TempData VALUES ('f9a4a291-c7b7-41bd-a88d-d1016d86b1ef', 30.00)
INSERT INTO #TempData VALUES ('f9abd1be-bba3-46fe-ac14-b32ac55de378', 30.00)
INSERT INTO #TempData VALUES ('f9acca5a-61dc-4292-a864-e296f75752bf', 30.00)
INSERT INTO #TempData VALUES ('f9cc7eaa-d58a-4806-a596-e2c5b00880e5', 30.00)
INSERT INTO #TempData VALUES ('fa12611f-a745-4a26-9864-b0f6547379bd', 30.00)
INSERT INTO #TempData VALUES ('fa7bade6-9049-4b7e-8d49-f8e268e1014f', 30.00)
INSERT INTO #TempData VALUES ('fabcf559-9bab-48dd-972e-eca0eaacd18b', 30.00)
INSERT INTO #TempData VALUES ('fac154aa-6bb4-42b5-853d-0b3da7150561', 30.00)
INSERT INTO #TempData VALUES ('fae33bc6-2a42-41c9-9211-60d75594c855', 30.00)
INSERT INTO #TempData VALUES ('faf2a9c7-6af6-416e-b4ec-690a5fa26997', 112.34)
INSERT INTO #TempData VALUES ('fb06607c-6826-4e93-84fe-92165fee1b01', 30.00)
INSERT INTO #TempData VALUES ('fb363cd5-9c56-4822-b2b2-6b5e61107215', 30.00)
INSERT INTO #TempData VALUES ('fb38fdd3-ae4b-4cd0-a974-9676e94b1748', 542.38)
INSERT INTO #TempData VALUES ('fb4e7176-0478-4eb4-b3db-9a22f893c99a', 30.00)
INSERT INTO #TempData VALUES ('fb9bd9e3-5353-42f9-9c27-ef79370929e0', 30.00)
INSERT INTO #TempData VALUES ('fbc9ae67-229c-46e2-ae12-5889b6a318ea', 30.00)
INSERT INTO #TempData VALUES ('fbd19d63-7576-420c-b962-f04f1bc1a348', 30.00)
INSERT INTO #TempData VALUES ('fc0cb26f-4aec-4c5a-9baf-4fca44e25b91', 30.00)
INSERT INTO #TempData VALUES ('fc0cc770-6c5b-4400-83d1-6bcbd89b0958', 30.00)
INSERT INTO #TempData VALUES ('fc9c1b07-05fe-4243-bfca-50b8bd62fcb7', 100.05)
INSERT INTO #TempData VALUES ('fccf5b56-c263-4d5c-b8e4-1f6b94538e2c', 30.00)
INSERT INTO #TempData VALUES ('fce47e45-56eb-4530-8972-06cf94a9e0a5', 93.40)
INSERT INTO #TempData VALUES ('fd89b3f9-eb4a-4da5-ad7b-5d6be8682fd7', 30.00)
INSERT INTO #TempData VALUES ('fdbdcfc4-b8e9-4b88-8c1b-8a56a14579be', 30.00)
INSERT INTO #TempData VALUES ('fe039067-e880-413a-bdff-74eaab5c86ea', 30.00)
INSERT INTO #TempData VALUES ('fe334d1d-7085-4271-a5e9-eeece33cb81d', 30.00)
INSERT INTO #TempData VALUES ('fec309be-cab4-402f-9c5a-449ca5bd8401', 340.78)
INSERT INTO #TempData VALUES ('ff0b2254-1b14-4e8d-9fdf-66f1acf39e02', 60.29)
INSERT INTO #TempData VALUES ('ff3c4575-9267-43d7-a436-d7853caf01a2', 30.00)
INSERT INTO #TempData VALUES ('ffddbeac-7351-458b-b72e-c81128d09e9e', 30.00)


*/