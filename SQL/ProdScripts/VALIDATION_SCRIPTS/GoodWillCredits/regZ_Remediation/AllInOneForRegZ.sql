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
SELECT BP.acctId, BP.AccountNumber, BS.ClientID, T.AccountUUID, BP.MergeInProcessPH, T.TransactionUUID, T.Amount, T.TransactionTime 
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
CREATE TABLE  #TempData (SN DECIMAL(19, 0) IDENTITY(1, 1), AccountUUID VARCHAR(64), ClientID VARCHAR(64), TransactionUUID VARCHAR(64), TransactionTime DATETIME, Amount MONEY)



INSERT INTO #TempData VALUES 
('99c7281d-e4dc-4bd4-894c-7d3a6ee48782', '3a71ec7c-c1c5-4aeb-a75c-0e120b9ab4f6', 'b6b171eb-71a0-41cb-92da-4463bc189e37', '12/06/2019', 308.1),
('c01ff280-10a9-4a18-bdf4-3bfe9f7c7692', 'a56508ca-9fe6-412a-bf87-0d469ee3d9b5', '301c873d-0ca8-41ce-945d-0b7090d962ee', '11/28/2019', 6.13),
('ad8125ae-2e38-4f02-a484-abfbeda0c1e8', 'e32d583a-89d5-40c3-94f3-417e36d53184', '854e09b5-c4a6-4bf8-8807-eb938ff5ce37', '11/11/2019', 25.15),
('e6020d6f-80fd-42d2-90e9-d5a25bd49c16', '278a73be-0227-412e-bd5c-664ca9bcf821', 'b16a39df-4231-4a58-9e4a-632578e41834', '12/07/2019', 2.99),
('02f3fbdb-a1d2-44d1-a895-c4fe5444e6d6', 'dedf28aa-0d15-48be-938e-ffcf964b7f19', '2b93c29e-0b2d-49b4-933d-cd2b154cedc8', '05/11/2019', 86.44),
('63a8c865-f9b9-4434-840b-b5a6e6ad70b2', 'aa0501ca-04d0-475f-b248-6b7fedeb74d0', '72f99862-8792-4ee9-9a2b-9b2a06adc153', '10/08/2019', 202),
('1378541f-21be-4881-95d4-0098e0e8fbe0', 'dd997251-67bb-4a51-a3e2-49783bc487b0', '8d478851-3103-4793-bcbe-324c893434a7', '03/12/2021', 80.89),
('01a13731-f597-48ba-a786-48f754f00405', 'cebbb5ad-4394-4483-9cba-fa627ac4970c', 'c6b92825-a2f7-45df-bef4-ca481d1ce2c9', '11/01/2019', 229.95),
('ad8125ae-2e38-4f02-a484-abfbeda0c1e8', 'e32d583a-89d5-40c3-94f3-417e36d53184', 'e9b4de8b-8c06-4470-b5cb-f0352879f85e', '10/05/2019', 113.37),
('03fc5286-a4b9-4387-8704-d8969358d034', 'e80285d8-ae64-4e80-b7c5-d90b90c0cee8', 'b872eb10-2de3-42ec-a203-feac17447875', '02/09/2020', 54.55),
('39ade0f5-90f2-482c-85e0-80817659a95c', 'bea6853c-0fe9-44a0-bdbc-e317965ccb42', '5e4cfc9f-931b-4c4a-b7b7-31bc98cc7ee7', '01/11/2020', 128.03),
('ad8125ae-2e38-4f02-a484-abfbeda0c1e8', 'e32d583a-89d5-40c3-94f3-417e36d53184', '0634475d-a1ad-4645-949c-8b4eb5666374', '09/23/2019', 36.38),
('ad8125ae-2e38-4f02-a484-abfbeda0c1e8', 'e32d583a-89d5-40c3-94f3-417e36d53184', '5add8080-986f-4568-ba82-e6d99a553368', '10/17/2019', 24.36),
('N/A', 'e32d583a-89d5-40c3-94f3-417e36d53184', 'f7f57ced-1f87-459c-aea3-81d202ad3ee5', '10/31/2019', 11.12),
('78510647-2c19-4cab-a137-ae3d46662d89', '818815b2-0d71-4a73-bf98-6afa06872db3', '85e0be5f-62eb-4697-9c02-e846523cd903', '01/13/2020', 17),
('b06b6ab8-2d61-4a7f-a84b-78fbe8fa4c66', '11038d59-70c6-4e7e-b4b0-b9c302297cff', '6548befb-ab54-4257-b941-802d2ab2bc39', '12/11/2019', 11.41),
('b06b6ab8-2d61-4a7f-a84b-78fbe8fa4c66', '11038d59-70c6-4e7e-b4b0-b9c302297cff', 'c468f45f-bbf6-4afe-bc46-f23278b18421', '01/17/2020', 21.53),
('bfd1fed2-5410-46ab-aa21-f647b1bf6b4c', '1fc20e61-66c5-40a3-b0fa-225022cfe280', '07711a29-c666-4118-86d2-4f3c05f8be9d', '07/17/2020', 47.62),
('0f2aea36-da1a-4558-86cb-806631be1333', '1a0f7b04-ded5-4014-859e-7f654be4819d', 'faaf3243-47d2-40d7-872f-f3637d92c9ab', '03/27/2021', 75.68),
('ad8125ae-2e38-4f02-a484-abfbeda0c1e8', 'e32d583a-89d5-40c3-94f3-417e36d53184', '54e15a5e-d89f-4ecd-9570-f68cd1d3ec7b', '09/23/2019', 236.91),
('21e01426-77e4-4e93-98bb-845878da8220', '9d273165-7a30-4693-916e-ca73f814da65', '7812d2b5-d26c-4d81-8897-e4adbf4fd252', '01/09/2020', 3.48),
('bc25e67a-0ef3-4a55-84b0-3049e10dbe56', '6be99363-15a8-4a94-b5cf-11b595404fcd', '8e6fec24-54a8-479d-a09c-f202aa362c5d', '03/18/2021', 364.15),
('c01ff280-10a9-4a18-bdf4-3bfe9f7c7692', 'a56508ca-9fe6-412a-bf87-0d469ee3d9b5', 'bbb9c25f-467b-4048-a704-60d0e42a5d01', '11/17/2019', 3),
('21e01426-77e4-4e93-98bb-845878da8220', '9d273165-7a30-4693-916e-ca73f814da65', '55fcf15c-6d25-4449-8700-069262083a36', '01/07/2020', 3.98),
('897a59b9-b4ba-42d0-a15f-d0cfd81c3014', '85125fff-092c-4280-9594-cb781ec35242', '961c9cba-7344-4e5a-acf7-b17b217173b1', '11/28/2019', 16.84),
('348d8e8b-e281-403a-bf6d-49c64b814ab6', '5e13dc3e-56b5-49f1-9537-616bc003b8f4', '8ab8eb38-76fb-42f3-8afa-cb90ea77a8b6', '10/19/2020', 58),
('ad8125ae-2e38-4f02-a484-abfbeda0c1e8', 'e32d583a-89d5-40c3-94f3-417e36d53184', '80269022-e1cc-4d02-9cbf-af919b1bcace', '10/24/2019', 46.17),
('ad8125ae-2e38-4f02-a484-abfbeda0c1e8', 'e32d583a-89d5-40c3-94f3-417e36d53184', '35af9a3c-4da4-4f5b-ae7e-303b594d1468', '09/29/2019', 300),
('0e91ea1e-914f-43f9-8bcf-9a3ac551f205', '47fead99-c4cd-426f-bd23-055a6d8c1fc5', '0922cc48-e65c-467a-b4ed-9fb19a623a1d', '10/28/2019', 83.6),
('b06b6ab8-2d61-4a7f-a84b-78fbe8fa4c66', '11038d59-70c6-4e7e-b4b0-b9c302297cff', '3f0feac6-21ec-495e-a16c-d1f5b1b28ee8', '02/05/2020', 15.69),
('ad8125ae-2e38-4f02-a484-abfbeda0c1e8', 'e32d583a-89d5-40c3-94f3-417e36d53184', '6f5eaff3-6c42-47e0-bded-8c0b5159e8ac', '10/15/2019', 53.49),
('c4e44dfc-cb01-4326-be34-204330c3877e', '91f71afc-f1d1-4a17-bce1-23c315020f17', '41fb805b-354d-462a-a4bc-99b8ecdb3631', '12/01/2019', 63.15),
('b06b6ab8-2d61-4a7f-a84b-78fbe8fa4c66', '11038d59-70c6-4e7e-b4b0-b9c302297cff', '2e503a02-ab25-4731-9cf8-635bac70c2c9', '12/06/2019', 24.49),
('bf3fcf3f-3921-4b1c-b461-7277d76e0932', '13a487e3-a256-4906-90e8-a9808850e7d8', 'c077400a-2f62-43a9-bb4d-58d40f5dd237', '02/14/2020', 24),
('ad8125ae-2e38-4f02-a484-abfbeda0c1e8', 'e32d583a-89d5-40c3-94f3-417e36d53184', '49087012-9645-4018-a761-cd610d7514c5', '10/04/2019', 27.98),
('85413343-d8b9-4690-8274-630c29c90984', '7af2f62b-939d-4a2d-b2bb-ce72d4d6cb8c', 'd0e09351-cc48-4992-a375-a55b6964c964', '12/08/2019', 350),
('fc66f20a-d264-4ce0-8e00-8d6dadaa2912', 'fbd62355-b3ca-4a3c-ab86-68d2bcc5a156', '55bc169c-9211-4c98-8106-2c87df15ebe5', '11/11/2021', 456.81),
('4076d809-48cb-46f9-9830-1a83f5270d5c', '23c2107f-dc22-4b56-9c67-8fe3916101dd', '5279f482-7a7a-4b4c-8692-14dcfa22b579', '11/14/2019', 424.41),
('1901e5a0-3cc0-49e8-812a-3d5e4931529d', '04c946c4-45cf-4846-ad2e-e537129544b0', '17b6187b-aade-4abc-bf64-726f05f9b925', '01/13/2020', 794.16),
('b06b6ab8-2d61-4a7f-a84b-78fbe8fa4c66', '11038d59-70c6-4e7e-b4b0-b9c302297cff', 'fa8b606b-f25c-4ef3-9c07-06eac243bc4d', '12/20/2019', 24.06),
('a6a8c724-b178-4d11-bcb0-0625fbbc4b17', '8dde1f06-0d20-47d1-a130-f77493e99859', '1091e468-11dc-459a-aa60-ba5c739bbeb8', '11/05/2021', 199.99),
('ad8125ae-2e38-4f02-a484-abfbeda0c1e8', 'e32d583a-89d5-40c3-94f3-417e36d53184', '78a6d09b-b5d5-40b9-8d00-ef4061213a70', '10/14/2019', 130),
('b721dac0-94e5-48b5-8c21-1f1fb0477c1a', '043c20c3-c63a-4d2c-982c-39696d6c9d14', 'a599d83b-1d06-4572-b3cd-d752a5d881d6', '10/16/2019', 4),
('b06b6ab8-2d61-4a7f-a84b-78fbe8fa4c66', '11038d59-70c6-4e7e-b4b0-b9c302297cff', '398b12a6-d794-433c-8170-084ec2851bed', '01/15/2020', 23.41),
('3e5bd79e-946f-4e07-8ab8-e2720b698310', '4b8ff89b-5bf4-41fb-b12f-3134750470fd', '3a9e8208-50cf-441a-809e-022dbcddf1b0', '12/09/2019', 8.03),
('9304a178-a27b-4515-a935-a6630b534ae7', 'a6045a7b-9c9f-46c2-8eca-94fcc7e36935', '5a919026-c451-4617-818f-7e1246313cb2', '02/08/2020', 320.68),
('ad8125ae-2e38-4f02-a484-abfbeda0c1e8', 'e32d583a-89d5-40c3-94f3-417e36d53184', '62a861a8-3974-4650-930a-ab818e530105', '10/04/2019', 2.12),
('961a13a9-6e79-4469-a07b-4c635a46198d', '33a75503-79e7-448b-96d9-bd12174a179a', '141176eb-dc5a-4a64-aeb9-afa587475c7c', '12/25/2019', 249),
('18776a49-5162-4c31-a636-cf59d1e363fc', '8b59d0ea-9804-49bf-87bf-18c6b28412d4', '01f6872c-1c78-4193-9062-5b4ad20d2129', '11/21/2019', 30),
('21e01426-77e4-4e93-98bb-845878da8220', '9d273165-7a30-4693-916e-ca73f814da65', '5b291b47-6a1c-4e75-897a-02a4265249e9', '02/05/2020', 1.25),
('21e01426-77e4-4e93-98bb-845878da8220', '9d273165-7a30-4693-916e-ca73f814da65', '80d8c9dd-2123-4bcf-8181-457540e1ae5e', '01/08/2020', 0.99),
('ad8125ae-2e38-4f02-a484-abfbeda0c1e8', 'e32d583a-89d5-40c3-94f3-417e36d53184', 'f18aab48-84a1-4656-bf7c-1c4d3ec9baf1', '11/21/2019', 33.81),
('2da057d5-abf7-49ff-a8db-1deb262cd6cf', '1b0d5098-938f-4f4f-886d-b02226bb7f36', '2157910c-22f2-46bd-9ff9-2045f606cdee', '04/27/2020', 362.06),
('025c5d30-3183-4455-bc8e-29d75562a94d', '9394a4c4-40b4-414d-849a-6893a21491eb', '5d1107f2-ef7b-42f3-a151-f5a31d79a44e', '12/23/2021', 12.06),
('62ece2a9-9658-41a9-afb3-3a0f07289326', 'f3f3375f-b959-4fa0-87f6-b0f38d3d5af8', '8179c6c5-b6be-49ca-a132-f3fdaf00a3f9', '12/16/2019', 180),
('b06b6ab8-2d61-4a7f-a84b-78fbe8fa4c66', '11038d59-70c6-4e7e-b4b0-b9c302297cff', '88fb12aa-f363-49de-b058-de276873f6be', '01/05/2020', 15.11),
('f0beb52e-1a22-42d8-9645-bf9f81e3b606', '7d3150ff-7a6a-4a99-ac69-f15eaa8916b1', '5556ac57-6864-4c6a-b75e-f0fe1d92e920', '12/02/2019', 226.4),
('c01ff280-10a9-4a18-bdf4-3bfe9f7c7692', 'a56508ca-9fe6-412a-bf87-0d469ee3d9b5', '3a1c5859-33b2-4f2b-81e4-093cae66d06c', '11/24/2019', 8.2),
('99c7281d-e4dc-4bd4-894c-7d3a6ee48782', '3a71ec7c-c1c5-4aeb-a75c-0e120b9ab4f6', '18a1f8d2-d33b-4744-86c4-9d5d29d10183', '12/02/2019', 300),
('b06b6ab8-2d61-4a7f-a84b-78fbe8fa4c66', '11038d59-70c6-4e7e-b4b0-b9c302297cff', '1b1e6b0c-e653-44a9-85e2-68c33cf62197', '01/05/2020', 11.83),
('16ea7817-1151-4dbc-b22b-98027cbfd1cd', 'e010f630-db3a-4db9-935c-1cd6ad16da1e', '8c8783b0-c59f-4b62-99ed-c85ec33175b9', '02/27/2022', 65.98),
('195672d9-85de-44d8-acc5-fa1ce861e00a', '7b7f7de7-0058-4883-ae06-18145edf5f7b', '87df4617-40bc-4479-8e91-fda91ad53aa7', '10/08/2019', 154.63),
('21e01426-77e4-4e93-98bb-845878da8220', '9d273165-7a30-4693-916e-ca73f814da65', 'bbd4d15f-be07-482e-8dfd-422e76cd6b1c', '02/01/2020', 4.73),
('06333758-a7c6-4729-9dca-6fb7c151d5b1', '81b783c0-5fdc-42f0-a2e9-ded47b4ac853', '6a364bef-9e47-484e-b4a5-440c5666c258', '02/12/2020', 3.24),
('cab47ec5-9193-41e5-9766-d48bde4bdb02', 'a6ad3216-dffc-4647-990a-2e421d3e9325', 'cc4dd416-3123-49da-af07-d563d0651463', '01/08/2020', 500),
('606d09dd-ffe7-4961-8022-ae122f64a09d', 'c4aa352f-b4ea-4a2e-a963-29770ce41d04', '279e4940-235f-42e0-aa64-ff6cd76da178', '10/13/2019', 1352.04),
('f7bc81f2-b23f-4fb9-b948-cf74a2a3f251', 'd565b328-7425-4dd7-a658-6a9d5ee2bca3', 'e74705d1-1baa-49e8-9200-aaec3fcfb261', '02/24/2020', 149.95),
('54526340-f40b-4de7-b74a-96329288e542', 'f27ac239-cbd7-4f14-a78e-6e30700c3a3e', 'fd018b2a-7bbf-41f4-91fd-11bc765f3365', '11/16/2019', 54.45),
('ad8125ae-2e38-4f02-a484-abfbeda0c1e8', 'e32d583a-89d5-40c3-94f3-417e36d53184', 'd0e86b28-ad4e-4775-81f8-90e1d0d9d603', '10/15/2019', 36.07),
('b06b6ab8-2d61-4a7f-a84b-78fbe8fa4c66', '11038d59-70c6-4e7e-b4b0-b9c302297cff', '241ff2c2-8a76-4460-8303-f47dbfb89107', '02/11/2020', 6.98),
('4dd9239f-85aa-4b12-a9f4-2f1d789b51d5', '6ea9228c-06f2-4eb4-92f0-6bf3d469181b', '05e9cd37-ead7-4b3f-ac9b-bbf31e6b68e1', '10/26/2019', 28),
('e67792db-0a4f-4a35-bc62-be237bd64f57', 'f00d8cd4-a79a-4be6-90c1-370d7f2c4540', '048dd998-676d-48fe-a72e-7bc7ee79ab12', '02/04/2022', 28.04),
('1a25c2ed-1139-44ed-9877-dd2df97c9f3c', 'f64ca44a-1917-49db-84ae-29341ba8aef8', '911284c6-e527-461f-b1cc-73dc59a95328', '10/16/2019', 120),
('b06b6ab8-2d61-4a7f-a84b-78fbe8fa4c66', '11038d59-70c6-4e7e-b4b0-b9c302297cff', '66006854-8f8c-4355-848d-46204d8f6fc7', '12/10/2019', 9.55),
('ad8125ae-2e38-4f02-a484-abfbeda0c1e8', 'e32d583a-89d5-40c3-94f3-417e36d53184', '2d589072-901d-4e33-8378-ef85b53d13f4', '11/21/2019', 27),
('e5490ba8-a7e2-4d31-8fc7-c3251d133b82', '59746ad2-8c97-4c81-b9df-bc2d1692d552', 'f54a76dd-2412-4f8f-8346-09b61f84a4ef', '09/05/2019', 746.86),
('731a3549-9c26-4cfd-b0c2-d54beaad5112', 'a7116854-8d0f-47e9-a1a1-e1e61d299c01', 'cd0ffe05-2539-450a-b7c6-38a32cd3ceff', '02/28/2022', 125),
('203ed241-f595-453e-85ef-481344b03ead', '53e7501d-a921-4db2-a2a9-986d84a307ca', '2a8352d5-fe93-432c-ba3c-d7e429e45d7b', '02/03/2022', 83.49),
('6028919e-c343-4640-bc3c-a4021efeacb6', 'a7349c16-da14-4573-905d-c3f0d262aa40', '501ccc06-6853-46c3-b2dc-44721a879eba', '03/08/2021', 70.84),
('21e01426-77e4-4e93-98bb-845878da8220', '9d273165-7a30-4693-916e-ca73f814da65', '3de50efb-7338-4283-b117-2b296a65aac3', '02/11/2020', 10.38),
('ad8125ae-2e38-4f02-a484-abfbeda0c1e8', 'e32d583a-89d5-40c3-94f3-417e36d53184', '822cea8f-15d0-4a89-863d-4e43a86c3ea8', '10/02/2019', 75.94),
('ad8125ae-2e38-4f02-a484-abfbeda0c1e8', 'e32d583a-89d5-40c3-94f3-417e36d53184', '070471d4-730d-4760-a821-2e8de77fda9b', '10/16/2019', 10),
('ad8125ae-2e38-4f02-a484-abfbeda0c1e8', 'e32d583a-89d5-40c3-94f3-417e36d53184', '74c6bee8-ae28-4d0e-ab8c-e4d7b4e18418', '11/15/2019', 7.3),
('b06b6ab8-2d61-4a7f-a84b-78fbe8fa4c66', '11038d59-70c6-4e7e-b4b0-b9c302297cff', 'ff9af496-579f-4b10-80f1-11ca5fbdaea5', '01/16/2020', 22.61),
('ad8125ae-2e38-4f02-a484-abfbeda0c1e8', 'e32d583a-89d5-40c3-94f3-417e36d53184', 'ba4bd61b-1053-4780-b7a9-77cd39e17012', '02/05/2020', 12.14),
('b06b6ab8-2d61-4a7f-a84b-78fbe8fa4c66', '11038d59-70c6-4e7e-b4b0-b9c302297cff', '57bb7233-3ee2-4e19-a463-09b8d20119ef', '12/19/2019', 19.67),
('54526340-f40b-4de7-b74a-96329288e542', 'f27ac239-cbd7-4f14-a78e-6e30700c3a3e', '835a2a8b-16b8-4f79-878d-0c3ca7e34a22', '11/06/2019', 50.85),
('a47ad935-6f5d-422d-8135-06ad9f2931f1', 'e67a5d28-d9ce-45b0-8588-0125504198e7', '6cfbfe25-82b9-4860-92eb-22b77f51c671', '01/17/2020', 42.63),
('e6020d6f-80fd-42d2-90e9-d5a25bd49c16', '278a73be-0227-412e-bd5c-664ca9bcf821', 'ad0905bf-f063-4017-8e1c-bafd38c3d87e', '11/08/2019', 2.99),
('21e01426-77e4-4e93-98bb-845878da8220', '9d273165-7a30-4693-916e-ca73f814da65', 'c9878de7-3348-4c48-a986-5ffa28b7be29', '01/08/2020', 9.93),
('b06b6ab8-2d61-4a7f-a84b-78fbe8fa4c66', '11038d59-70c6-4e7e-b4b0-b9c302297cff', '74ad61f4-14e5-4f0f-ab78-011e21682c8d', '01/18/2020', 24.96),
('b965ebc9-6171-45a1-a518-6910d1509e99', 'bd092441-2b42-4d40-b4f0-0d60020d84c2', 'b65f795d-778c-4f1e-84ac-d47bb210a212', '02/18/2020', 128.85),
('9304a178-a27b-4515-a935-a6630b534ae7', 'a6045a7b-9c9f-46c2-8eca-94fcc7e36935', 'c58c11da-96da-4210-841b-11ccf9c7fa87', '02/08/2020', 685.28),
('12823856-2162-47e0-827b-d2af9a5698de', 'ea4da4ce-7bd9-4271-b838-68a5a17a1715', '7b97d468-7c42-4525-b0fb-dcdb121273a4', '11/12/2021', 115.6),
('1f7137a3-6fa8-4195-9bf3-d8ed21527c7b', '69d9cfab-d151-451d-9421-4f83705833c0', '54b87287-033a-4120-be57-45a0635dc8ad', '02/11/2020', 234),
('ad8125ae-2e38-4f02-a484-abfbeda0c1e8', 'e32d583a-89d5-40c3-94f3-417e36d53184', '2565a93a-2f3e-4143-bfce-4d60c44da93b', '10/08/2019', 100),
('54526340-f40b-4de7-b74a-96329288e542', 'f27ac239-cbd7-4f14-a78e-6e30700c3a3e', 'faddb831-22e6-4f55-8664-c3e42e8ca41c', '11/05/2019', 15.26),
('0e91ea1e-914f-43f9-8bcf-9a3ac551f205', '47fead99-c4cd-426f-bd23-055a6d8c1fc5', '3beee5b7-9d0a-4122-b22c-c2e34c58f8e2', '10/27/2019', 65),
('b06b6ab8-2d61-4a7f-a84b-78fbe8fa4c66', '11038d59-70c6-4e7e-b4b0-b9c302297cff', '4c55b3b9-76fc-40f6-bc9a-208106ef1945', '12/22/2019', 19.61),
('b06b6ab8-2d61-4a7f-a84b-78fbe8fa4c66', '11038d59-70c6-4e7e-b4b0-b9c302297cff', '0a6aaa11-0212-4276-83bc-9353f3ddfc82', '01/07/2020', 28.86),
('a23c60e7-a2c7-4bb6-8555-9b4e187dc8ca', 'a8a1ba6b-befe-454c-b405-d9f35b2fda97', 'f2d1c92b-6fe8-4bc6-8c2a-78fc904a13ef', '02/27/2022', 314.35),
('8e6cc47e-96ab-4dd9-84fc-51ede171bf57', '4adbe4b0-ee99-4fde-8958-c28f9b0efcd5', '1b337410-4d64-475a-92c1-7eab50ff21b8', '01/11/2020', 195.72),
('3e5bd79e-946f-4e07-8ab8-e2720b698310', '4b8ff89b-5bf4-41fb-b12f-3134750470fd', '349a600a-cf5d-4d3f-b288-c06ff13f7cff', '12/04/2019', 14.77),
('63789c90-a131-4146-bd4b-31b7468efaff', '84a9f95c-d4b7-4755-8772-01cf007a615e', '4145581f-89ef-407a-9a99-b77e0a481357', '11/29/2019', 1213.27),
('ab8e1788-b59e-45dd-a43f-57d028a74c25', 'f8362e5e-f561-4f1f-9a67-74c706343505', '6dcfcb7d-4a06-485f-aacf-b789f62bd7e8', '10/02/2021', 550),
('aa73eceb-b099-49e8-be3e-91efa8116eff', '0d59452c-37bb-4163-bcd7-e6d330f1dad6', '575165d8-34e4-41a1-a4e9-100898dfc19b', '06/04/2021', 286.8),
('4e0a28c7-fa40-46df-b234-6035952e1779', 'e9bac3dc-8895-4585-b422-9cf7e6c98842', 'c41fbe9b-7e2e-482d-a62e-e5ca6ababc26', '08/15/2021', 1095),
('b06b6ab8-2d61-4a7f-a84b-78fbe8fa4c66', '11038d59-70c6-4e7e-b4b0-b9c302297cff', '0c6f7bef-7ab5-4cfd-b99f-f2ae25a12641', '12/13/2019', 6.5),
('6b5eb3a3-a5b4-4ec4-911a-ab49a5a349fb', '6e8ab5f2-7989-4094-bd7a-dd183ad05543', 'b0ff2784-e706-4f6f-88be-ec9360fa3cad', '01/21/2022', 105.93),
('ad8125ae-2e38-4f02-a484-abfbeda0c1e8', 'e32d583a-89d5-40c3-94f3-417e36d53184', 'f8241873-4d94-451d-b921-66c720cdac35', '11/01/2019', 30),
('67d15702-4eb2-44bc-bf86-0b79a216b3b1', 'ffdf9881-9514-47ed-99db-3c2357c5d52b', 'dc840825-bb4b-4502-97a0-2b4a6a329218', '01/24/2020', 398),
('cbe6c48a-17f7-4bc6-95c4-b3601131aecd', '83e71761-011b-48de-b2b7-5a4df493ac5a', '455b26c8-4852-4bea-8109-6d43193d6cd2', '10/04/2021', 14.19),
('b721dac0-94e5-48b5-8c21-1f1fb0477c1a', '043c20c3-c63a-4d2c-982c-39696d6c9d14', '3b033a59-d495-4940-ba14-8a6ce2aceba7', '01/06/2020', 4),
('21e01426-77e4-4e93-98bb-845878da8220', '9d273165-7a30-4693-916e-ca73f814da65', '7306f3e3-2fc1-4080-806b-6f0d1f3ea5f4', '01/07/2020', 4.41),
('e33606f5-4a65-4920-84df-a81b3b77d90b', '03004370-e12b-4bbf-88be-d5b3e29c17b6', '384e7740-3c72-461a-82ab-5ed4c85304ae', '12/15/2021', 616.37),
('b721dac0-94e5-48b5-8c21-1f1fb0477c1a', '043c20c3-c63a-4d2c-982c-39696d6c9d14', '7ab63b00-1c32-4c43-b648-c18d4e20f9a4', '02/03/2020', 4),
('ad8125ae-2e38-4f02-a484-abfbeda0c1e8', 'e32d583a-89d5-40c3-94f3-417e36d53184', '0b8ff22f-9f70-41ed-8a3c-a308a2026101', '09/30/2019', 60.65),
('21e01426-77e4-4e93-98bb-845878da8220', '9d273165-7a30-4693-916e-ca73f814da65', 'b5cd4514-62be-45c7-b376-1d8fdc5f0b18', '01/21/2020', 5),
('97a00d7a-8703-4a9d-8299-7dcdb3da91ea', 'c847dc42-14e4-4e76-99f8-6013d21370e6', 'f2e0aaab-ea46-4867-a9e2-dc3d37f1d545', '04/13/2021', 643.5),
('c01ff280-10a9-4a18-bdf4-3bfe9f7c7692', 'a56508ca-9fe6-412a-bf87-0d469ee3d9b5', '441b85e7-b035-438f-a033-a58719b27e32', '11/29/2019', 16.44),
('ad8125ae-2e38-4f02-a484-abfbeda0c1e8', 'e32d583a-89d5-40c3-94f3-417e36d53184', 'bea31161-5b0b-4361-bcba-98fac66bb902', '11/19/2019', 4.18),
('cbe6c48a-17f7-4bc6-95c4-b3601131aecd', '83e71761-011b-48de-b2b7-5a4df493ac5a', 'fffbb93e-be7f-4e5b-a727-29e4ca500951', '12/04/2021', 14.19),
('c01ff280-10a9-4a18-bdf4-3bfe9f7c7692', 'a56508ca-9fe6-412a-bf87-0d469ee3d9b5', '4639e328-71de-4a38-9dba-70a8138ca0ec', '11/17/2019', 23.7),
('7ce9ab85-09b1-4d4c-9f7a-9c7821f66fb7', '2fde5228-11f1-40cb-b999-2476cc8e6f49', '31c4bc43-96c4-4562-a1d0-dd666916c09b', '12/12/2021', 72.66),
('ad8125ae-2e38-4f02-a484-abfbeda0c1e8', 'e32d583a-89d5-40c3-94f3-417e36d53184', '07f15fb1-caa4-4de5-9395-cdc7a1d87a44', '09/25/2019', 4.06),
('21e01426-77e4-4e93-98bb-845878da8220', '9d273165-7a30-4693-916e-ca73f814da65', '11d2904c-4809-4008-ab39-dc047e1620b7', '02/01/2020', 2.2),
('805c0726-31b2-46e8-8806-3383cccce292', 'f4ff3235-9470-4fad-9ab8-693fc5cfbd52', '513eb428-51f2-4a32-9ab0-6f635c18f1e4', '10/05/2019', 139),
('ad8125ae-2e38-4f02-a484-abfbeda0c1e8', 'e32d583a-89d5-40c3-94f3-417e36d53184', '0f53ea43-309d-4bb2-99dd-b88535ca33c4', '09/23/2019', 87.72),
('ad8125ae-2e38-4f02-a484-abfbeda0c1e8', 'e32d583a-89d5-40c3-94f3-417e36d53184', '7c484cea-0b7c-4910-b096-082d513ed632', '02/06/2020', 10),
('ad8125ae-2e38-4f02-a484-abfbeda0c1e8', 'e32d583a-89d5-40c3-94f3-417e36d53184', 'd81b270c-76b5-445d-9a7e-605266431ff8', '12/05/2019', 10),
('05ae86dd-1a11-4f51-a7cf-02cee2257163', '8ca54c67-7e37-4a06-8b01-51fba773b7e8', '8abe8d93-bd2b-46d2-9e8e-8c53ebacbcf7', '10/17/2019', 18),
('790d6b82-e407-4976-912b-82849b0613e0', 'd14ec340-1665-42b3-8435-216fa0bc7789', '81e3604b-b8f4-41e4-a706-f421d6f6c313', '12/01/2019', 222),
('ad8125ae-2e38-4f02-a484-abfbeda0c1e8', 'e32d583a-89d5-40c3-94f3-417e36d53184', '7ec9e49f-829d-4ca1-9883-5ef8ee58f552', '10/18/2019', 210.54),
('b06b6ab8-2d61-4a7f-a84b-78fbe8fa4c66', '11038d59-70c6-4e7e-b4b0-b9c302297cff', '945d7f2a-9411-495e-bb94-47ca177786f9', '12/05/2019', 16.45),
('99c7281d-e4dc-4bd4-894c-7d3a6ee48782', '3a71ec7c-c1c5-4aeb-a75c-0e120b9ab4f6', '02649de7-cb16-40b1-bf8b-88348ed16b0c', '11/04/2019', 25),
('0e91ea1e-914f-43f9-8bcf-9a3ac551f205', '47fead99-c4cd-426f-bd23-055a6d8c1fc5', '35e5a814-ac74-4774-ae2f-c341aa02af4b', '10/27/2019', 77.08),
('b06b6ab8-2d61-4a7f-a84b-78fbe8fa4c66', '11038d59-70c6-4e7e-b4b0-b9c302297cff', 'fce45253-dd0f-4957-a97c-6fddc8d35004', '12/10/2019', 7.77),
('bf53f795-0c95-457e-bb9e-db2516773aee', '8d152cbe-e314-456e-a10a-24334882c626', 'aa98cde2-30e5-414c-ae23-a83a84bd3e49', '11/14/2021', 347.76),
('e8556582-769b-4a85-a929-c731472f0657', 'c72a6041-77ce-4de8-9381-5044f32f754b', '921657ba-0a5a-4bbe-b558-b2c915746e45', '11/08/2021', 523.2),
('30724998-4c42-45d7-bba0-65b6006c0954', '07ffb844-3471-4870-b354-20e50570a806', '13d99030-0687-4afd-8245-637b089ab879', '07/03/2020', 85),
('0804e1de-b6ea-45ed-a538-71dee5ed50e8', '9f4fec3b-d356-4580-91db-e2ae904f0c5f', '49148ee2-0fb6-4eff-9992-4d4859b94119', '01/30/2020', 20.3),
('8d9bfcc3-f12e-4ae5-b708-df266439cef3', 'f642b86a-4b11-45f0-96f9-8904a0ac50be', '628df5c7-c502-4a5f-bfd8-4034c1d0181b', '01/22/2020', 217.64),
('c751fba5-16ff-4f27-9d71-637b600caf51', '63f3b82c-9786-43b4-bd46-6f9a6c24829f', 'ed2f27d4-8fef-42f8-9c5a-4c21ed9463e7', '01/02/2020', 76.29),
('a47ad935-6f5d-422d-8135-06ad9f2931f1', 'e67a5d28-d9ce-45b0-8588-0125504198e7', '5c5bd064-2226-49e0-93ae-5190127d1451', '12/17/2019', 39.99),
('f2519ff0-661b-46ba-ba50-64f7aea0190d', 'a926f85e-2a01-4c29-b4d0-cc664b47aa81', '20332f40-a9ec-4908-9132-5d2ed20cf64f', '05/12/2021', 338.23),
('e43d8c9c-1ee0-4ff9-931d-e3b30a08c35f', '0a0f73f8-37cd-4897-a75a-3f4bd4c3a07d', '4919d91d-f063-49c6-a4d9-d39c0dc02726', '07/11/2020', 249.95),
('12594fa8-03bf-4851-a0bb-62be3f76a7b6', '991e7ff8-f8ad-41e8-a365-487d69f9c39b', '40fecb4c-2b0d-433f-b4ae-fd06d2ad7895', '01/30/2020', 326.61),
('b06b6ab8-2d61-4a7f-a84b-78fbe8fa4c66', '11038d59-70c6-4e7e-b4b0-b9c302297cff', 'c5669d12-1a4d-4254-bc8a-01a367b360aa', '02/11/2020', 4),
('21e01426-77e4-4e93-98bb-845878da8220', '9d273165-7a30-4693-916e-ca73f814da65', '96609f01-4baa-407b-8924-17e622e27748', '02/11/2020', 9.36),
('34597f48-b346-4bd9-aef9-a632dd9d9032', '748370c7-2c78-4fd8-bf2e-4dcbcc226058', 'b9b993cf-1694-4185-ae98-b3b877c42de3', '06/15/2021', 1768.7),
('43cb7522-228f-4cad-a8bf-36c3bd60ef15', '35ad4e68-6392-4d55-a69e-fba3a0cdd0c3', '08a23956-b4cf-4875-b34f-9b72d680a47c', '11/24/2021', 44),
('b06b6ab8-2d61-4a7f-a84b-78fbe8fa4c66', '11038d59-70c6-4e7e-b4b0-b9c302297cff', '626c0c75-a1bb-49a3-b0b3-e1197e667c14', '12/10/2019', 16.88),
('78510647-2c19-4cab-a137-ae3d46662d89', '818815b2-0d71-4a73-bf98-6afa06872db3', '6879dbdc-3fd3-4099-8480-85e3765a40d7', '01/07/2020', 60),
('b06b6ab8-2d61-4a7f-a84b-78fbe8fa4c66', '11038d59-70c6-4e7e-b4b0-b9c302297cff', '5848c464-bb73-41a6-bdce-cd3850c53e1e', '12/15/2019', 17.47),
('769057cf-c14f-4e20-bf9b-4ef8ea1dfdc2', '68ad9095-1844-46b3-be23-d45882bbaa9b', '835dc866-b1fe-4097-be49-4b0cdfba056b', '12/22/2019', 26.87),
('70ac2758-f924-4d24-8d71-4891c612a7c8', 'befcaa3d-1b24-46ea-911c-9e151d3eea56', '1f72b9f2-4821-4987-beaa-5546c39bda0b', '11/15/2019', 80),
('337c02d8-4cae-47da-a447-0ed15a6d534a', 'cba75215-4680-4893-9ca5-4190f9e106b3', '7004779a-4e91-41c5-9e8b-6160bc427c84', '10/11/2019', 500),
('b06b6ab8-2d61-4a7f-a84b-78fbe8fa4c66', '11038d59-70c6-4e7e-b4b0-b9c302297cff', 'f93438ba-1745-48fb-bf72-49699ad04314', '02/06/2020', 16.26),
('2dad243e-bc77-45d0-bf5d-ea3c475ec247', '38bd12df-11c9-4751-80ce-2781496c4799', '290d6a8c-7195-4fb2-b66a-0c63efdee1b1', '12/22/2019', 17.32),
('2d038e28-59d2-423d-b84d-ce5b47f58b57', '9de29926-6620-4096-9534-fdfbf8a91efe', 'e1087a6b-bf10-4187-b2cf-f809747adead', '11/25/2021', 173.53),
('b7f1f21c-45e3-4a71-a5ce-ff7c14a868e5', '8c680bf5-80bb-4a0e-9caf-c7219082e6ca', '468d96a2-0546-414b-9d5f-ed9d1ca473c5', '12/27/2021', 67.54),
('b06b6ab8-2d61-4a7f-a84b-78fbe8fa4c66', '11038d59-70c6-4e7e-b4b0-b9c302297cff', '88c05413-842a-4e00-83c9-0d1c3fbb0a39', '01/18/2020', 8.97),
('ad8125ae-2e38-4f02-a484-abfbeda0c1e8', 'e32d583a-89d5-40c3-94f3-417e36d53184', 'da94c748-8351-483b-931f-7b395ee2927d', '11/13/2019', 10.47),
('21e01426-77e4-4e93-98bb-845878da8220', '9d273165-7a30-4693-916e-ca73f814da65', '51b2cddd-7bc9-494d-a8b5-99bfbca209e2', '01/08/2020', 13.8),
('ad8125ae-2e38-4f02-a484-abfbeda0c1e8', 'e32d583a-89d5-40c3-94f3-417e36d53184', 'be79e3f5-4cac-4143-83b1-dec358beeb27', '09/30/2019', 47.32),
('b721dac0-94e5-48b5-8c21-1f1fb0477c1a', '043c20c3-c63a-4d2c-982c-39696d6c9d14', '35df9676-64de-4607-b2d1-688e8ec87d73', '11/11/2019', 4),
('992a1a31-ca4c-4788-853d-cf55371a8112', '524229e5-6b81-4616-bc47-4da1d32aef9a', 'ab9792d2-ac93-4003-95eb-88d19be90d25', '01/07/2020', 454),
('ad8125ae-2e38-4f02-a484-abfbeda0c1e8', 'e32d583a-89d5-40c3-94f3-417e36d53184', 'fde79ff2-b00b-422f-a738-bf4d5dbfc033', '10/04/2019', 144.99),
('08c76e3e-fec0-4eae-a741-ee74cdb995d5', '6c6b4c16-7690-44f5-835e-4ec43aa45ef9', 'cad97119-f9a5-42a5-b040-f59def116271', '01/15/2020', 3729.5),
('c01ff280-10a9-4a18-bdf4-3bfe9f7c7692', 'a56508ca-9fe6-412a-bf87-0d469ee3d9b5', '83c08a93-e30f-4742-8e30-ac970a3f07eb', '11/22/2019', 6.49),
('b06b6ab8-2d61-4a7f-a84b-78fbe8fa4c66', '11038d59-70c6-4e7e-b4b0-b9c302297cff', '2bfdda4c-cc8f-4522-bbc8-50dcf4f7d695', '12/22/2019', 28.28),
('b06b6ab8-2d61-4a7f-a84b-78fbe8fa4c66', '11038d59-70c6-4e7e-b4b0-b9c302297cff', 'e57f6bad-95c1-4b8d-b1b6-a6f23da44b96', '01/05/2020', 14.6),
('54526340-f40b-4de7-b74a-96329288e542', 'f27ac239-cbd7-4f14-a78e-6e30700c3a3e', '5e653cb7-a377-4308-808a-552c8408ccf6', '11/08/2019', 11.47),
('b06b6ab8-2d61-4a7f-a84b-78fbe8fa4c66', '11038d59-70c6-4e7e-b4b0-b9c302297cff', '5d358959-6bfc-4a71-88cd-fe9f20320404', '01/07/2020', 23.9),
('b06b6ab8-2d61-4a7f-a84b-78fbe8fa4c66', '11038d59-70c6-4e7e-b4b0-b9c302297cff', '390e37ec-f941-48a8-b586-e8084dc8d03d', '02/08/2020', 16.39),
('483f2a8e-d101-4e85-9747-8ae86b8eceee', '2893d30b-cc07-4970-bbb1-b5a213288655', 'ad0c2f2b-c7f2-4cf0-9ac1-2f4309166803', '02/18/2022', 198.7),
('e851235e-bb84-45bf-bbad-f4da06b52980', 'e1a1bbd3-fdc0-4d47-8c54-1b0442a0117a', 'c474946b-5556-4e49-9df4-72a58e1e0328', '03/18/2021', 50),
('b721dac0-94e5-48b5-8c21-1f1fb0477c1a', '043c20c3-c63a-4d2c-982c-39696d6c9d14', '8404eafc-56ac-4634-9e57-871cf9114ab7', '12/09/2019', 4),
('ad8125ae-2e38-4f02-a484-abfbeda0c1e8', 'e32d583a-89d5-40c3-94f3-417e36d53184', '4a320132-7290-43ee-8353-8897364d5276', '10/01/2019', 75.97),
('ad8125ae-2e38-4f02-a484-abfbeda0c1e8', 'e32d583a-89d5-40c3-94f3-417e36d53184', 'b2dd8530-c50c-4188-a38b-d8594d4f3084', '11/20/2019', 35),
('54526340-f40b-4de7-b74a-96329288e542', 'f27ac239-cbd7-4f14-a78e-6e30700c3a3e', '5379fb19-dfd5-4d8e-b6f7-22eead85d552', '11/14/2019', 13.21),
('e0419d64-56c0-4073-a713-fb0ee4ca00cc', 'ab160ede-227b-47b4-ab74-80fc233bf6f8', '4e1850d7-a0ee-415c-b542-96574266637a', '02/07/2020', 89.66),
('a74234a8-71d3-4a5f-a595-cad9d3511f60', '690ca43d-d885-4d8c-864b-051d5586f9dd', '5f21f091-eb06-47da-a1d2-8688df751665', '11/21/2021', 119.23),
('b06b6ab8-2d61-4a7f-a84b-78fbe8fa4c66', '11038d59-70c6-4e7e-b4b0-b9c302297cff', '6d1275f9-f948-4786-b1ad-9fd6b3b3be36', '12/08/2019', 10.72),
('a47ad935-6f5d-422d-8135-06ad9f2931f1', 'e67a5d28-d9ce-45b0-8588-0125504198e7', '1af10830-4ced-417e-9431-476c7b950f0a', '02/17/2020', 42.63),
('ad8125ae-2e38-4f02-a484-abfbeda0c1e8', 'e32d583a-89d5-40c3-94f3-417e36d53184', '78408816-70a1-4790-b104-86068ab5d855', '11/05/2019', 62.41),
('482d551f-7bf7-4a6b-b5ed-6035a9404e5e', 'a5f67011-a6a0-4c2a-836f-bab46d852933', '6727137c-5370-41cd-82ae-47bf2e74c4d3', '09/01/2019', 10),
('cbec9037-7d71-4fbb-adc7-b9043ad5e36b', 'a5d468d8-bb6e-483a-8c6a-d1b781653a30', '12595ed3-2884-47f8-a29e-ba42e8eb85fa', '11/09/2020', 131.64),
('c01ff280-10a9-4a18-bdf4-3bfe9f7c7692', 'a56508ca-9fe6-412a-bf87-0d469ee3d9b5', '1e4cbb20-67f8-4c01-97a0-581bd523200f', '11/08/2019', 29.99),
('ad8125ae-2e38-4f02-a484-abfbeda0c1e8', 'e32d583a-89d5-40c3-94f3-417e36d53184', '1bdee32b-665f-42fb-83cb-ac3e5e71eae0', '11/01/2019', 92.02),
('c01ff280-10a9-4a18-bdf4-3bfe9f7c7692', 'a56508ca-9fe6-412a-bf87-0d469ee3d9b5', 'a17a947f-8510-4fa1-9110-92ed27d46243', '11/29/2019', 3.25),
('ad8125ae-2e38-4f02-a484-abfbeda0c1e8', 'e32d583a-89d5-40c3-94f3-417e36d53184', 'de88f63c-b804-451d-aff0-e311f5abeeeb', '11/03/2019', 37),
('5923b022-405a-4a92-a9f0-b410da70dc26', 'eea981c8-a268-4911-8075-6dd70a7c1474', 'c02841f9-9486-4cab-a8ff-d25f1a265182', '12/30/2021', 314.83),
('54526340-f40b-4de7-b74a-96329288e542', 'f27ac239-cbd7-4f14-a78e-6e30700c3a3e', '31fdc050-cdbb-4c64-8553-03b816843942', '11/04/2019', 71.25),
('a711f61c-cfc2-4c00-a12a-3885dee00287', 'be0a638a-bc2e-4704-acaa-634c35f2cee7', '074af01f-fc6e-4b26-bb5a-dcc2ffc77f65', '06/16/2021', 65.65),
('c01ff280-10a9-4a18-bdf4-3bfe9f7c7692', 'a56508ca-9fe6-412a-bf87-0d469ee3d9b5', '63ed9da8-4dcd-4b1b-9848-9838b0c23cf0', '11/29/2019', 100),
('21e01426-77e4-4e93-98bb-845878da8220', '9d273165-7a30-4693-916e-ca73f814da65', '6d9a6292-72df-4b2c-9cca-2bebd15dcd8e', '02/01/2020', 2.53),
('ad8125ae-2e38-4f02-a484-abfbeda0c1e8', 'e32d583a-89d5-40c3-94f3-417e36d53184', '8bbaf58a-db00-4951-9fb4-b018e081e89b', '11/21/2019', 1.04),
('c01ff280-10a9-4a18-bdf4-3bfe9f7c7692', 'a56508ca-9fe6-412a-bf87-0d469ee3d9b5', 'c89dce38-a563-4138-b3ef-7bcee0ef7adf', '11/29/2019', 4.21),
('ad8125ae-2e38-4f02-a484-abfbeda0c1e8', 'e32d583a-89d5-40c3-94f3-417e36d53184', '73b8012b-f053-4a0a-be87-347d8a3b3537', '12/24/2019', 84.31),
('b06b6ab8-2d61-4a7f-a84b-78fbe8fa4c66', '11038d59-70c6-4e7e-b4b0-b9c302297cff', '1683b4ae-e176-42f3-9bb5-dd0d0567fb31', '02/06/2020', 12.91),
('6980137d-c5c4-46f1-887e-b35871d29785', '8a920658-fd40-4732-964a-0eeb995cb278', '582d4c75-e5ed-4d06-a44f-202083beac72', '08/30/2019', 1683.01),
('ad8125ae-2e38-4f02-a484-abfbeda0c1e8', 'e32d583a-89d5-40c3-94f3-417e36d53184', '60c6327c-36d7-4b54-a167-3f3566174a18', '10/17/2019', 12.67),
('a3dff533-b532-4d6b-96a6-b5422df63bed', 'db94d2ea-e92c-4121-861d-50df6a5d1e9b', 'c1042179-0e74-4dd0-99a8-d89715ac756b', '10/23/2019', 350),
('05c60f82-be0d-41a5-955d-055976da73b2', '4c2dabaf-5454-447f-9d63-dc7536a3bb51', 'cc07bb19-c8c9-4b6e-bf12-c9f7de1b4a2f', '02/03/2020', 65.45),
('c01ff280-10a9-4a18-bdf4-3bfe9f7c7692', 'a56508ca-9fe6-412a-bf87-0d469ee3d9b5', '5878dde6-2ed8-4258-999f-9a5b72b147e6', '10/27/2019', 30.78),
('d9ee9a3f-6224-498b-b93f-7b39e50174a6', 'f8a0ee1a-fe9b-465d-986e-5c08b1290435', '44d5f4a2-ad5e-4580-98a0-d48210b18e51', '02/18/2022', 79.92),
('c2929903-bda8-4020-8a5d-08de3dba1ff8', '9c4ef619-a63a-4e00-a9b5-4d60335ce506', '4921cd18-2e91-48e7-9de8-8ea979a7f0bf', '07/09/2021', 323.43),
('54e6d428-a2fa-4500-a223-527847d25b1f', 'f32a77f9-4277-4528-b54e-0a48bf008d05', 'eaf1308c-bb49-4515-a2bf-9d208133c6e1', '11/01/2021', 478.27),
('ee0ecbbf-9a0f-4777-9fe9-f3eb48cb0e41', '245265f9-4619-4b23-a14a-4bde0ffcb77d', '9b78a7a4-98d0-4578-82e9-8f23b93ce6bb', '02/28/2022', 250),
('8ab585a9-3708-455b-8351-4f10e930bb95', '46ebf4a1-52bd-428f-8fef-ad260dbd8d4b', '4bada79b-de94-4116-811f-83e077397ae7', '12/20/2019', 194.68),
('6ed4f5c0-41a1-4051-9804-9da2d3c8265c', '5c1d2a68-8ea5-4168-b6c3-f7eb84429084', '0acb1bda-b3b0-41a2-889a-0d28a437e83b', '01/28/2020', 5.99),
('d153b4dd-7d4f-4b68-9ffd-1213bf97be49', '389b7144-c918-4ad4-9d8d-39547b362e20', 'd25bb9fb-2eda-4a12-b6b5-bed1e502b1b9', '12/26/2021', 611.28),
('d2829eb0-fe14-465d-b9f2-fbab43d7de1d', 'a0ae858f-5212-4ce3-9fdf-9f8b07b5daa9', '34146ecf-92f4-4182-9af6-595db56d08e3', '11/19/2021', 408.59),
('ad8125ae-2e38-4f02-a484-abfbeda0c1e8', 'e32d583a-89d5-40c3-94f3-417e36d53184', '829df0d3-5f32-483c-b9bf-6568b917f03d', '10/20/2019', 149.97),
('0e91ea1e-914f-43f9-8bcf-9a3ac551f205', '47fead99-c4cd-426f-bd23-055a6d8c1fc5', '4426be8c-68af-4409-8a03-0021894a4619', '10/28/2019', 38.75),
('0e91ea1e-914f-43f9-8bcf-9a3ac551f205', '47fead99-c4cd-426f-bd23-055a6d8c1fc5', '1b58d880-8f61-46ea-85f5-b02b7627be7d', '10/25/2019', 40),
('0e91ea1e-914f-43f9-8bcf-9a3ac551f205', '47fead99-c4cd-426f-bd23-055a6d8c1fc5', '4ec4ab8c-256c-4aaa-990a-8383ef6d7a0d', '10/26/2019', 30),
('c01ff280-10a9-4a18-bdf4-3bfe9f7c7692', 'a56508ca-9fe6-412a-bf87-0d469ee3d9b5', '28bafe0d-aed2-4408-b1de-c9196eaab770', '11/22/2019', 58.88),
('c6a66749-6dd8-4989-8870-5955dd9a76f0', 'e481cb56-1a0a-4fb5-ac00-eb117575b19d', 'a3a93b25-1f49-4cf6-872a-01153b73f6cd', '03/21/2021', 100.3),
('ad8125ae-2e38-4f02-a484-abfbeda0c1e8', 'e32d583a-89d5-40c3-94f3-417e36d53184', '1b0dc818-73e5-418e-804b-6cf40bd77aa1', '10/06/2019', 6.35),
('ad8125ae-2e38-4f02-a484-abfbeda0c1e8', 'e32d583a-89d5-40c3-94f3-417e36d53184', 'da5794d7-e312-4dc7-bd26-39ddca9a4b65', '09/25/2019', 78.12),
('ad8125ae-2e38-4f02-a484-abfbeda0c1e8', 'e32d583a-89d5-40c3-94f3-417e36d53184', '0ad86075-c9af-4264-b88b-a0e5e534c8fb', '11/30/2019', 3.07),
('cbe6c48a-17f7-4bc6-95c4-b3601131aecd', '83e71761-011b-48de-b2b7-5a4df493ac5a', '101d1811-18b0-46c9-8e9e-1d214fb2214a', '09/04/2021', 14.19),
('ad8125ae-2e38-4f02-a484-abfbeda0c1e8', 'e32d583a-89d5-40c3-94f3-417e36d53184', 'd198d9bb-219d-46ce-8dc1-3bc71a29e6c6', '10/04/2019', 43.49),
('d9ef0993-bb2c-4c74-b315-74e41ecc90e6', '6a345467-b15b-4258-a8cb-0b8d9da7e4f2', 'ef34b41c-c263-44f7-a5c4-0a4689748c8b', '10/03/2019', 69.06),
('51ff66bb-09b6-411e-990b-ab73112d8432', 'ce83ff2a-4714-4aa9-9914-e2448efb4b97', '9028f80f-b46c-40da-b9d5-79c831560f59', '02/14/2020', 130),
('21e01426-77e4-4e93-98bb-845878da8220', '9d273165-7a30-4693-916e-ca73f814da65', '1f6eb90a-3cd5-447e-b5d5-cd92838156cb', '01/13/2020', 2.46),
('a46b49ef-9bb8-4a3d-9af2-fc7db23bdff7', '5daff0c2-73b1-4447-b61b-acb591909891', '00df6fe3-2ea9-4140-af14-36b094fd0d88', '12/19/2021', 118.5),
('96ba9ae7-2b06-43ab-8386-e98dbdd5c322', '2788a9b7-00e2-44d1-9b48-a56491ff5a52', 'f12d8bbd-b11e-4561-b1bf-adc88217b260', '06/19/2021', 57.85),
('11401c32-a2b6-49aa-b642-619b4c826c88', 'bdc4729e-6dd0-4cf3-82f3-12c2ee210b5d', '078dac04-1c91-40b5-be33-92e2718ac01e', '09/22/2019', 175.04),
('dbee2884-d073-4252-a00c-1197bed12984', '065e3ac9-8d4c-46fe-bd3e-fd8a80bd039a', '6fec3bda-74fe-4d03-906c-053b64868319', '11/02/2019', 1.09),
('a6effd05-c5cc-4e01-9235-d347a56f7f47', 'e51ebc88-4cec-4267-8f9a-4c297e16dc6f', '7dcac5fd-2096-48af-a407-9f3be7a26519', '09/23/2021', 969.57),
('97aac5f0-1439-4150-897a-f69a6bb331af', '5de6680f-8ded-4387-9ae9-6731485753e3', 'f33daa5d-24a5-477f-92d1-cc4dcf415c3e', '01/10/2020', 199),
('7ed7eb72-266d-4360-ab37-f6771ff21023', '2ac78076-eee7-4ab3-9265-d839fdd5aa0a', '68a307c5-38c3-46f0-bc6c-1f9f9fe00ac6', '12/19/2019', 99),
('37eb5cbc-4d86-47af-854d-821cf2b45c4a', '4d67af2d-5e43-4361-90f2-5a6a2213089f', 'be2cee1c-ce1f-43a0-9d03-1fb815263da5', '01/06/2020', 48.2),
('02f3fbdb-a1d2-44d1-a895-c4fe5444e6d6', 'dedf28aa-0d15-48be-938e-ffcf964b7f19', '42fd7b33-1b2f-4042-80e3-0120fc04760a', '04/16/2019', 7),
('b06b6ab8-2d61-4a7f-a84b-78fbe8fa4c66', '11038d59-70c6-4e7e-b4b0-b9c302297cff', 'dca0b2dc-86a0-461b-82e3-b26b67be2081', '01/07/2020', 18.86),
('ad8125ae-2e38-4f02-a484-abfbeda0c1e8', 'e32d583a-89d5-40c3-94f3-417e36d53184', '41afd459-920e-479e-b2c4-b349e0382cee', '11/11/2019', 85.83),
('107ff5ea-616f-46d7-80d9-b7daf8701e30', '567108a0-0cba-4444-87c5-772479a147f0', 'fc81d34e-fb73-45f8-a8fb-8011aa2f3091', '02/09/2022', 98.11),
('9ce543d4-9445-4c78-b843-99f762f86007', '4311c721-120b-45ee-9842-18bc3aca55ee', '2e2ef656-91b2-460b-818c-57ab31d28e5c', '02/27/2022', 266.84),
('b06b6ab8-2d61-4a7f-a84b-78fbe8fa4c66', '11038d59-70c6-4e7e-b4b0-b9c302297cff', '57971952-d430-43a3-8633-69d8e9163502', '01/06/2020', 14.64),
('ad8125ae-2e38-4f02-a484-abfbeda0c1e8', 'e32d583a-89d5-40c3-94f3-417e36d53184', '2087a1a9-bcb3-4637-ba3b-c7d72f670ad8', '11/15/2019', 30),
('ad8125ae-2e38-4f02-a484-abfbeda0c1e8', 'e32d583a-89d5-40c3-94f3-417e36d53184', '96117866-9897-41d7-8f34-d05a0a76d5e1', '10/14/2019', 215.24),
('b06b6ab8-2d61-4a7f-a84b-78fbe8fa4c66', '11038d59-70c6-4e7e-b4b0-b9c302297cff', '79f2a53c-0e02-4f63-aeaf-6c0de283dca3', '12/21/2019', 14.49),
('cf9dd957-0657-43cb-9ad8-3d8a6f4f3b51', 'a38f2f38-a3cc-47e1-8b65-00b9cab4526d', '76b8c414-4f2b-4e7c-8eb6-1714ad63e6ee', '12/23/2019', 299),
('ad8125ae-2e38-4f02-a484-abfbeda0c1e8', 'e32d583a-89d5-40c3-94f3-417e36d53184', '8de7d364-493e-43d2-9bc1-d07b0b36dbcb', '10/17/2019', 30),
('b06b6ab8-2d61-4a7f-a84b-78fbe8fa4c66', '11038d59-70c6-4e7e-b4b0-b9c302297cff', '286a60fe-1639-41fd-9f49-9811c9cd8285', '01/22/2020', 6.99),
('ad8125ae-2e38-4f02-a484-abfbeda0c1e8', 'e32d583a-89d5-40c3-94f3-417e36d53184', '40659f7c-aca4-42fb-8123-11754c93ae47', '09/25/2019', 71.26),
('ad8125ae-2e38-4f02-a484-abfbeda0c1e8', 'e32d583a-89d5-40c3-94f3-417e36d53184', '5f6e2d65-d84e-43e5-ba92-6c5b39395b78', '11/21/2019', 4.23),
('ad8125ae-2e38-4f02-a484-abfbeda0c1e8', 'e32d583a-89d5-40c3-94f3-417e36d53184', '2de24f11-62c4-4bfb-bf37-c9f0aabc6f7c', '09/25/2019', 0.03),
('0949a21b-8b41-4675-9900-157efd32f438', '4c7983f9-ca58-42c7-8bca-38fc15ba4acc', '03330425-fee7-436b-9b38-8dad0a48f68e', '12/20/2021', 185.45),
('21e01426-77e4-4e93-98bb-845878da8220', '9d273165-7a30-4693-916e-ca73f814da65', '5f61a654-618a-4865-a43a-6e7c4382316f', '02/03/2020', 1.5),
('3e5bd79e-946f-4e07-8ab8-e2720b698310', '4b8ff89b-5bf4-41fb-b12f-3134750470fd', '26995321-5423-4a9e-8a93-5087d565ac2d', '11/29/2019', 11.33),
('ad8125ae-2e38-4f02-a484-abfbeda0c1e8', 'e32d583a-89d5-40c3-94f3-417e36d53184', '9e330ccd-8290-4f97-a392-c0246f913b35', '10/05/2019', 23.5),
('bc1fdf3e-16b2-4887-8519-f1b57c34d458', 'f5c2c738-b6a6-4632-a669-5a925bcd7493', '297ac3b8-5ea8-4050-a4b7-c15fe5c33074', '12/21/2021', 105.33),
('336a7684-15ab-4f41-bff1-8f5701c33e26', '4c6737a6-5897-4202-bd90-4da8a5ce8848', 'cc1f4a95-ae32-4b38-b400-58abde99adde', '02/08/2020', 5.5),
('482d551f-7bf7-4a6b-b5ed-6035a9404e5e', 'a5f67011-a6a0-4c2a-836f-bab46d852933', 'ac869132-fe0d-4629-81eb-7f84416e3613', '09/01/2019', 147.7),
('21e01426-77e4-4e93-98bb-845878da8220', '9d273165-7a30-4693-916e-ca73f814da65', '14590e01-9048-4c13-8441-1d926883bf8b', '01/08/2020', 2.88),
('02f3fbdb-a1d2-44d1-a895-c4fe5444e6d6', 'dedf28aa-0d15-48be-938e-ffcf964b7f19', '8b28df4a-8b52-4d7e-8e2d-5510410df7d3', '04/20/2019', 7),
('af07431b-bd17-4121-aa3c-4379d19bd319', '9d37336c-3733-4fb3-adfb-7113b2ecada3', '05a0791c-a498-4973-a698-3fcb91f0940a', '02/12/2022', 10.08),
('82615880-cf59-487f-bf52-acc98b8568a7', '36a960fc-c90e-44ff-b3a1-52dc696c49c9', 'd2d33b20-e4eb-4722-9d8a-e0b90449ea23', '10/15/2021', 340),
('b06b6ab8-2d61-4a7f-a84b-78fbe8fa4c66', '11038d59-70c6-4e7e-b4b0-b9c302297cff', '0dbcc59d-0efd-46a2-8c56-2df60bd950c8', '01/16/2020', 22.2),
('b06b6ab8-2d61-4a7f-a84b-78fbe8fa4c66', '11038d59-70c6-4e7e-b4b0-b9c302297cff', '8c5288f2-92d5-4be4-b2b6-30372bbeebe7', '12/07/2019', 6.5),
('845a75fe-d07b-4652-af1d-2e05dec5693a', '2579513e-566d-4e57-af23-32760905bc84', '61637526-a9de-463b-851d-134f5f222f53', '06/21/2021', 100),
('02ec80d1-a46f-4633-b08a-4f1cbddbe3ef', 'd67aad14-192e-4e32-8387-eb354ebedb15', '983a2255-8bf5-4b0a-837b-4d9025bb2365', '02/08/2020', 144),
('5f9ed7a5-2f87-4421-b48c-376f3981cf45', 'b6dac43b-d2df-4265-b2b2-edc1cacd844c', '44d6fabe-4a61-40d9-b8cc-e05459196d83', '06/17/2021', 60.1),
('10684a01-aee9-46ad-b42c-67890f8c3d0a', 'bf7fa5dc-db7c-45c5-8581-4662bd9cf6e0', '9159ee6c-468b-4310-865a-47566cbc49b2', '02/07/2020', 34.99),
('ad8125ae-2e38-4f02-a484-abfbeda0c1e8', 'e32d583a-89d5-40c3-94f3-417e36d53184', '71b1f376-b5c3-4732-9166-01e4483fd1d2', '10/05/2019', 8.71),
('eca5641a-1abf-4c1b-8527-dee21a600ad2', '6a3930bc-f853-4dc1-85e8-a15b45262665', '4ed095ad-0477-43e3-89ea-7ebdf3b8f7e3', '03/07/2020', 109.71),
('9984dad4-f867-4933-acce-5a25cd609a4a', '36b1782e-12d9-403b-b7ad-3d7744e4048f', '3aac3499-f203-4090-8ef8-8976e2dffb2a', '10/13/2021', 687.2),
('ad8125ae-2e38-4f02-a484-abfbeda0c1e8', 'e32d583a-89d5-40c3-94f3-417e36d53184', 'b6d9bea4-d2b4-4d55-a07a-097ddc479a0b', '10/04/2019', 106.8),
('21e01426-77e4-4e93-98bb-845878da8220', '9d273165-7a30-4693-916e-ca73f814da65', '2b38a3e5-1346-45cc-b39d-5896c683dfaa', '02/01/2020', 2.53),
('ad8125ae-2e38-4f02-a484-abfbeda0c1e8', 'e32d583a-89d5-40c3-94f3-417e36d53184', '39476c03-d3b5-4935-9057-859dc4d7804b', '11/30/2019', 24.69),
('21e01426-77e4-4e93-98bb-845878da8220', '9d273165-7a30-4693-916e-ca73f814da65', '6dedf93f-f5c1-4f43-8210-1f0c1e91edf5', '02/09/2020', 0.99),
('59f4e461-b69f-4dad-bbd8-7cd751ba1795', '1ba461e3-a73a-4f6f-be6f-1609386bd01a', '79f1690e-0516-47aa-9aca-4bbdf7d06a48', '12/04/2019', 793.94),
('b06b6ab8-2d61-4a7f-a84b-78fbe8fa4c66', '11038d59-70c6-4e7e-b4b0-b9c302297cff', '82c53ca1-bf50-4e1c-bc05-50bd5e08e3f4', '01/22/2020', 6.5),
('ed0b1ee2-f7bc-43ab-b347-11feef098b44', 'ac325b3d-ad89-43a4-b5cc-a671ef334e52', '367b24a2-94eb-417e-9a2a-3cb1cd59419e', '02/24/2022', 944.32),
('54526340-f40b-4de7-b74a-96329288e542', 'f27ac239-cbd7-4f14-a78e-6e30700c3a3e', '53917ed1-2fb0-460c-9bff-17ea9bffffda', '11/06/2019', 11.38),
('ea96d546-2d41-4c9a-ac3e-8eed58fd9c25', '80ed3909-f6c6-43ef-9152-54e4f0da0be3', 'fec7183b-e5e5-424d-94ff-751c24899a6f', '01/08/2020', 140.75),
('f727288d-f647-4de4-8455-4f672e67fd56', 'a68f4365-8b42-44d1-bdb5-0d9067085571', 'aa17fce3-fc41-4d8a-886d-6c18f1fdaca4', '09/02/2019', 21.87),
('78510647-2c19-4cab-a137-ae3d46662d89', '818815b2-0d71-4a73-bf98-6afa06872db3', '5925ed2f-f1f1-44f8-852d-beb59a1bacbb', '01/07/2020', 60),
('b06b6ab8-2d61-4a7f-a84b-78fbe8fa4c66', '11038d59-70c6-4e7e-b4b0-b9c302297cff', 'a0a52c96-87ac-4ec5-bc8f-be3d96d7d474', '01/21/2020', 15.57),
('54526340-f40b-4de7-b74a-96329288e542', 'f27ac239-cbd7-4f14-a78e-6e30700c3a3e', '824bd4e0-c0a7-4137-a457-94ef5651ce39', '11/15/2019', 12.46)



*/