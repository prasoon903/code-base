SELECT * FROM #TempData

;WITH CTE AS
(
SELECT *, ROW_NUMBER() OVER(PARTITION BY AccountUUID ORDER BY SN) [Rank]
FROM #TempData
)
SELECT * FROM CTE WHERE [Rank] > 1


DROP TABLE IF EXISTS ##TempData
SELECT * INTO ##TempData FROM #TempData

DROP TABLE IF EXISTS #TempRecords
SELECT BP.acctId, BP.AccountNumber, T.AccountUUID, T.ClientID, BP.MergeInProcessPH, T.Amount--, T.* 
INTO #TempRecords
FROM #TempData T
JOIN BSegment_Primary BP WITH (NOLOCK) ON (BP.UniversalUniqueID = T.AccountUUID)
JOIN BSegment_Secondary BS WITH (NOLOCK) ON (BP.acctId = BS.acctID)

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
--WHERE  
--T1.SourceAccountNumber IN ('1100011127011249', '1100011139323376') AND 
--T1.TranTime >= BP.DateAcctOpened
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

SELECT ClientID, AccountUUID, Amount FROM #POD2


/*

DROP TABLE IF EXISTS #TempData
GO
CREATE TABLE  #TempData (SN INT IDENTITY(1, 1), ClientID VARCHAR(64), AccountUUID VARCHAR(64), Amount MONEY)

INSERT INTO #TempData VALUES
('fc074af7-780e-4c02-b93c-3ecc02e07c87', '64469d86-164a-4777-be0b-8e59227173c8', 47.43),
('cba328e5-8bfb-4086-b8b3-b73ed0da22cb', '2bf0982e-bfdf-4517-a1c0-9dbc0fc4d428', 50.25),
('4a765c16-5bb0-444f-8f8a-235bb0dd2bf8', '384fd2b0-9fe7-4573-8bee-40779ef070d0', 6.16),
('a1be377c-dd18-4a31-98e9-ef1917e51ab7', 'd20595a0-a09f-4167-9732-594cd6ed3cea', 56.48),
('63bf389b-00a8-4bdf-a17d-1d34baa98610', 'd89ba538-91aa-43d2-b265-729bf48c422f', 194.02),
('de45999d-a738-42b8-8362-2bea1179d90e', '398c7084-4ed0-4a44-9a75-13178b34bb18', 30.00),
('5bd44787-ae06-4ae0-9085-910f53223642', 'd4ee00e5-2420-464e-bc92-d1ca45c07c92', 30.00),
('d323ec2c-a011-43ea-9ef7-9bca9f65f4ef', '4f522b1b-2776-40e3-a691-0d4703456dac', 69.61),
('024d0126-66d2-43e0-a505-7c3c3271fd88', 'cdb80017-20bc-48ae-bf08-0635aea74f5e', 53.38),
('6985703f-7f09-4d17-a27e-32ab9e234a36', 'ee3b3cde-1890-4d5f-b78a-6ee8034160bb', 492.73),
('8fb263ed-4a03-47d4-8774-4286185e1da7', 'f0d62f5b-d77c-4eca-a7ac-3a8b4f81bda3', 117.56),
('648fa117-0f5c-47b7-a853-ccc1ddfb0db0', '7e9dc13c-546b-44ee-8f0d-13365da9e09f', 115.74),
('9a530bef-1907-463a-81fe-779335858c80', 'a7675b48-86d3-47fe-8706-b5d4bdf2f06a', 85.57),
('2a0cfb70-40bd-4f4e-be32-9ea5fc115086', '338d65e4-c019-4473-820b-f25c56e09490', 132.86),
('ac004c83-1422-4b6f-9f00-06e307019082', '33b2d244-82ba-4575-9bcb-5e4cf57d5912', 149.04),
('6e3d2bb8-cef1-43e5-8550-fb208b534e0b', 'bcd951c1-b1fd-4804-990c-f790db1cbe8c', 115.86),
('43520f03-a2d8-46ae-b7e7-45e3d898d18f', '91115029-4668-4f0c-b999-59c063ea1138', 144.90),
('00e0c95a-aed0-443a-abf2-af68fec54134', '78660122-763d-4556-8c80-bb11ff46d63b', 655.74),
('835187ec-e286-4c3d-b30b-1c0525e37f34', 'a20ab93c-484b-40df-94f1-db55f0913bf5', 30.00),
('cbb72217-da5f-4d23-b0e4-3c8a982079a2', 'fb06607c-6826-4e93-84fe-92165fee1b01', 13.68),
('ee9ca480-2e48-4c2f-87d2-136fec82452f', '32ef758d-2ee0-4fe4-b182-ceb8cc77f4b1', 32.02),
('b011be58-5bde-433a-aa1b-3d57c7c985b5', '8f8a2fa4-5f8f-4827-974a-072121cdc3e7', 19.76),
('fadf9de3-8bbe-48d6-9761-19d11a144a02', '3f2990f1-da1b-4ff2-b946-5c0fe6100ab2', 195.01),
('dee7ad59-a315-433f-8154-d6edec09e93f', 'e1290d36-0902-4acb-acbb-63d47f196302', 29.97),
('4b09975d-5624-4ea0-a309-d0692a7cabc2', 'd304d251-418b-4b12-a3b0-3e8b79ea8b6f', 17.11),
('05f85fa2-d97e-43e4-9b4d-06e0ebab55e4', '678745e0-b96c-46ac-a18f-7c478880d805', 81.51),
('352dfe9b-cfef-4176-82e7-4077f1bc3310', '249832e5-0323-4819-a008-84d1427c8ede', 100.04),
('4c3d4fc9-e3d3-45ce-814c-40d5c6ec0342', '0aa6466a-ef7d-4346-a8ee-c97c6cfa687c', 78.27),
('12db6b28-0b9c-47d5-9157-64decbf32a89', '58fa11b8-6bf0-4322-a425-841c44944dd1', 30.00),
('dd5ab32b-f3b8-497e-8901-95c837939989', 'd2083ca8-561a-4ba2-932c-5a648ee14e69', 12.61),
('64f293b8-9fe7-43f8-8d8f-5eb44060f742', '55933918-2058-4b3b-8e49-211fb9d01887', 89.90),
('8e16fbc2-3e0c-4116-a210-20f6c0b46bc7', 'e3817c71-57a7-465b-88a6-f6028403e3b1', 25.57),
('ee8b6269-930d-40b5-baa2-6e58400f1a9f', '7ba056a8-be25-4d34-a039-234f7add8433', 44.31),
('5981176c-3ef8-4bfa-a882-7ed51b6283f8', '5d385ac8-64ec-4a76-bf26-910bed63905c', 55.66),
('bae158f6-6e03-408d-8bf8-fe990023c399', '9bc780d9-e2eb-4c09-8f9c-041acdad488c', 136.45),
('c7136cc4-9de3-4a1c-b200-19a40ff7132d', '4ab7da8f-f20d-462d-bffd-8216c83786eb', 30.00),
('a937c13c-cefe-4154-8512-b87708d9d2cb', 'bf4f4a7a-b063-4c27-8e08-187721cefd42', 30.00),
('df46a5db-d24e-4cd0-8799-570d6fca0cd5', '9b1d58dd-cf58-4e1b-954e-0d643cb1afff', 12.98),
('5bc58110-2e88-44be-b6de-d263e9e3a5de', '0ad9e265-1bb5-4c82-804d-4af07afcf968', 89.31),
('51117fd3-b33e-4d82-bac5-9effabdc002e', '8d787e56-8241-4793-b4f1-92a2f4ce97cd', 10.37),
('0380a821-9add-4b93-a381-52f179bcc5d7', '83214689-edba-43c1-a5e1-de66e90b281c', 33.85),
('97094d82-1713-4521-b004-cd6f81bc9346', '81986990-9bd8-457e-9586-4dda4a252800', 30.00),
('4cec637f-517b-4a89-bc1c-1d7fedfb14ca', '21ffed7e-6aae-4688-b2b5-8716fa3fc266', 29.50),
('c74d5352-e483-43a3-92cc-428c0ed83a29', '76d0c17c-3b63-4a77-955f-2d3f21936836', 30.00),
('6c10bb56-e971-45a8-8691-69fa7a7462c2', '9b2a1fa1-af7d-48c6-97c8-fe2c9a3babef', 47.76),
('8e0a286b-b518-42a5-b8ee-27172093d55f', 'd16e8941-33fc-4721-ac48-aaa6a40e31c3', 88.28),
('06bdf5e6-79f1-4945-b8cc-02fd3f8cd428', 'd3eae135-d882-4241-ac34-647f3948ba80', 3.56),
('862dbba2-9509-40bb-82cd-fca7bd5aace9', '010aec84-a4d9-4e39-afaa-1b8ac92f7262', 30.00),
('2d9f3309-0eda-4830-9956-9107a3a989c3', '36634dee-52a2-43c3-a5d5-9ed0f5a10736', 30.00),
('7b08a190-cd9a-42b8-9474-a198803b5b87', 'f5d33b3a-71bf-4448-8678-bd1d034c18ad', 7.70),
('2335c127-aa4b-4b75-835a-34e5db2444a0', '99d159a3-cb95-44aa-91f5-8ef21973357f', 30.40),
('4d300d30-2038-45b9-86c7-08a3ae98b5fd', 'a7626ea2-42bf-499d-ba92-573687a1b04f', 98.30),
('4a3792ad-c00e-4e8d-b048-8b87ccf4188b', '752ea657-364e-4f1f-a443-016b88d28b52', 95.22),
('f7dbbeef-1fb3-401c-9148-613fd79d38ec', '79847607-13e7-4390-be6c-6a816f9bfd81', 30.00),
('204aa321-9a74-4bbf-97b7-041779955cbb', 'bf6bd738-53ca-4f00-9b42-e38cbceb2eb6', 113.65),
('2291e3de-17cc-4874-8697-f8d545c3f663', '377c7865-70f6-4f7e-841a-41e375958c80', 30.00),
('c61e5d0a-6bad-41a3-9985-5f2eb8be7396', '89c7a243-b881-4295-9117-c20416f56abc', 161.31),
('b621a757-6b95-48f5-8bb5-ebc1fc4685b6', 'ed17e184-fd50-4b28-a97e-41507bb14d7c', 30.00),
('e676f50e-1235-4157-8dcc-8d69c2e5363c', 'baf24637-3733-4608-b03b-b8480a8e9ebe', 16.31),
('914294ad-30e8-45d4-b348-3c2bfcb666ee', '7eb46898-c405-4b16-9fdc-f7f3eecb9510', 30.00),
('81b81680-ab31-4e71-a32e-ace111afc606', '15ef99f8-d3b0-4ebb-88f8-525ef6a7c8c6', 54.09),
('d9562474-0bb6-474a-92a4-cfe4c809f0db', '078ab8e6-7dd4-4b80-af41-5c579c68eb2a', 7.67),
('84d426b5-dd96-4d26-8cfc-3aca89cdecd2', '633b5545-6c5d-44a0-b7b9-8981f38e13a5', 30.00),
('4bebbe15-461c-4748-8bdf-2eb8253a78ec', 'dbbc3820-bb93-4d23-b94f-4a1ceea8b52d', 107.08),
('b286344a-4401-44ea-8a1f-f767fb1476c6', '9e507d31-0646-4ebd-b09a-fc30b8b9eb89', 30.00),
('ef2f75e1-7653-4258-8b97-a4f12dbbd9cb', '763946af-0157-48f5-9640-a893aa6d0993', 27.98),
('9180f595-89dd-4d01-af4d-6005853ffe91', '758acab5-515e-4a95-8a4c-feb680719622', 85.55),
('e1771344-875a-42eb-a9d3-7408b7177d8f', '667f8b1c-fdc1-4d60-9a6e-7dc1a3b76f67', 94.86),
('bf1eebca-a8cc-4677-9491-9ed0599060dd', '58e01289-16d0-46bc-98de-b26364fcb6d1', 30.00),
('a6d51a73-3406-4bfc-8f29-25542464a8cb', '2a6e06a7-a417-4c03-aac2-e580394dfd35', 116.94),
('a92c193c-21be-4111-8682-d5647b05ad9c', '7f164654-d6e8-4573-9854-e846747d801f', 27.07),
('d0534f8f-521c-4569-916d-ae877f0510d6', '55284d78-dcfd-4c24-8a78-344aba807cc7', 113.67),
('e761d38d-07ef-4a35-b82d-bb7b6725ec84', '164446b8-3cb1-4bdc-8994-e17d7e513611', 41.25),
('c1734451-3783-40eb-a277-f342502c826f', '07e32915-e62b-42a0-a18f-8422be8b764b', 5.88),
('199bde83-a6d1-4ec8-ac1c-d10e6675c3ca', 'e24b0622-86d4-4a6a-84ae-f7aea9c27967', 1.79),
('51e7c91f-13df-4cdb-8f07-b7cc2bf6a03b', 'a31b2f43-a7b1-4d81-93b7-11f344a9e734', 15.34),
('686c60da-4328-4ada-b3cf-61fc4c524981', '81ec4361-174d-476a-aee2-50fb5e28c6b3', 165.88),
('516766f8-b7d8-44dd-8a17-3710c76f2c64', '2eaad2cd-11f8-4393-81e2-de3b4d32c563', 578.69),
('34bd79b6-03e0-4dab-a5d3-dbf2db9957b0', '0b53316b-2f95-4988-97fa-de3cb17241a1', 30.00),
('357ba27d-7b31-47c5-92f1-b359b060d860', 'c0053780-0c92-490a-9e5b-89de95cd9b2f', 30.00),
('63b77faa-0f01-4ad2-bc45-c926cf46fd2a', 'a9497851-dc89-4272-ac5f-389294804469', 6.41),
('39adcbe7-70ef-4976-89b7-77fe9fac31e4', '8912f2c2-e1c1-462d-b11e-e8d7490d33eb', 427.90),
('e0436d6e-0495-4cff-abcb-35880ea3c668', 'ac0cc1aa-fb3f-4a18-86f0-d553cf087a7f', 400.66),
('61f35073-ef2b-4c15-bc62-c423965c6ffb', '10492528-b929-449f-bc18-1e6d3897fc60', 0.62),
('2f43fe90-609a-49e4-bff9-cb4ab2ec834e', '1b712121-df3f-4580-ab78-ea52a49a23ad', 25.65),
('ad99cb4b-3db9-4084-babd-147ec7fd9178', '11c73db7-b332-4c63-8ccc-c082aad251d3', 29.80),
('e070ed9f-7ac5-443a-bca4-026b1fd6bb2d', '9e16cf1f-f11c-4910-b8c8-bbc440d3938b', 36.04),
('67be227d-ae53-4c9f-8592-1bfa36e1c5a7', '181e6923-eb60-400f-94f6-13f0bece132d', 24.89),
('7c307ed3-3f73-4207-a89f-ee734bfff6a5', 'de3bfe90-ce98-4f99-a223-7407d9fc7295', 38.35),
('d6b82d7d-63e0-4521-9b64-44ea703029d5', 'f9288306-a91d-4d8a-b238-29183971cbdd', 351.93),
('8d9fe195-6de6-4d42-a436-33f1688f64cf', '1f8f8858-7bae-4cca-9e5e-6065265f2dd9', 30.00),
('f68f5a7e-0c48-4a51-8f73-c1b3386257e6', 'c550aed5-19d9-416b-beb4-4ca95b209e28', 26.76),
('990259a5-6149-48a4-95c1-989844a858d8', '72a30bb4-3fd9-40e5-b70f-a229290bdb7c', 19.41),
('f31b5703-87e2-4853-b426-15231bf5bc74', 'eaf3d52e-40fd-4c29-9cbc-72fd1ca39d84', 30.00),
('79cab33b-5989-49ba-9ea8-d2e18f1c5d4e', '5b479c54-cfbd-4073-be49-13aa8c94d638', 20.76),
('d7c271e2-5515-4a33-8676-48cc1ed9b24d', 'e0ec415a-ca6f-4dd7-84e1-209b50931dc3', 43.72),
('683d8fa4-2212-41a6-8c59-7e5ca8b86867', 'cb3d8a59-50dd-4b9f-bda8-6b893f559ee9', 456.52),
('58652a6e-04c7-48ba-a604-44cc8da50f7f', '4992711b-6b6e-47dc-af4f-b07d97c1fef7', 120.73),
('b1ac4f49-6bb8-4a2d-913b-6efc1a2ecc51', 'b55ee7d6-332a-4e0c-9544-bffd35506822', 13.28),
('dc926d30-888a-48d8-ba4e-0854ea63acc5', 'a175b880-a4e9-44af-bf67-f07cb677e4bc', 66.90),
('9158bbd9-40ac-4a6d-8a34-9bea99ab4cdc', '752ad441-5b45-4328-960f-7333eb396b2f', 30.00),
('f7750114-3d0c-45ac-ba67-7b6dc06ba159', 'ce8e0c04-bf4f-4118-8da0-9bf1efd5ad55', 135.84),
('51c3ff86-b8b7-4197-ae9d-8bb434ec0574', 'c0b4be4d-6ba5-4a2f-adfa-a9ed4d1ad389', 18.28),
('a5662837-2512-4626-9d9b-64af85fc7183', '2cd1d4d0-0dc7-4307-8a05-5e87b8daa1cb', 30.00),
('9788add7-fa8a-4453-a5f0-1cfe15ce1acf', '2e31ce5f-ca5b-4468-b941-394eec780f42', 30.00),
('5576f95e-8689-4c92-856c-d75b8e640dcb', '69dd7f4c-5c2f-4994-8561-e337981d035a', 359.25),
('70f1c3f9-6dcd-4717-9fd3-35a324435153', 'bd422d2c-3c1b-4e31-9f0a-1f49257ab7f0', 32.87),
('8de7a8cc-888c-44a1-a059-136c28ac8b72', 'faf2a9c7-6af6-416e-b4ec-690a5fa26997', 41.35),
('77d1ff46-e84b-4bf3-8424-6d40418f4f9c', 'f22b58dd-9a06-4b02-87ee-d7e34fe9f919', 128.52),
('ab202b12-08e2-4da0-be3d-9d1422030269', '1917739c-27cf-436c-ac40-f213c826d910', 0.18),
('a31579d3-ccbd-4d56-8cf2-af2faa20888c', 'ce43cac5-43ca-4780-a475-7bb05e96bc96', 189.72),
('90851683-6c92-47f9-a0ac-682fad2e864c', '885eb971-ba52-4a67-8d0b-816b43998a4a', 261.15),
('ad564b2f-b8a3-4d0e-abc1-7d923ea8cd03', '3a61e9b7-6e96-4809-8e80-ebe393c9a3ff', 309.68),
('291e3a03-a259-480d-8b56-ebd5fd01a76d', '6735f1e7-43a9-4997-9e50-7ad82bcd3581', 7.02),
('a8ccab18-a390-454d-a4e4-f901520bdfd0', '34206634-55f1-4207-89f5-b5e15e3b30c5', 84.58),
('124a06c9-dc62-4b53-9426-fd10b720e99a', 'cead649c-255a-4b08-a24f-d77a80d99753', 50.73),
('615d5546-a50c-4511-b45d-853ffe03e28c', '4fb8b3cc-62f8-4f36-ab75-8d5f55430576', 22.39),
('ee4025a1-b277-4f32-a223-870893a4be29', '7cfb8072-a069-412b-adaf-a71ec9e8224f', 30.00),
('2f117501-3cc0-43ba-a6b1-81efd65bd7bb', 'b8106d3c-b6f7-498f-ad95-b9d31c99c0bd', 134.98),
('cc64eb60-2007-4ec2-b7fb-1250b7f44826', '82f22b50-cb65-4c6d-a86e-8e03d9720976', 106.22),
('3f27bb5f-f205-4959-82fc-d79b620ed977', 'e6a6505a-2000-406a-9438-7af3860955c6', 734.58),
('d30809a8-5027-4645-81b5-ea0166e47e11', 'c2c4ff8c-cca1-40ca-b424-da32d3289f2c', 191.28),
('5497ce5a-7355-48cc-9c02-9ddd68c70065', 'aa4dfa1e-72a4-4940-a249-f55fac4d05a2', 15.79),
('6dc6c140-e5f6-4c22-95f9-b4fe91dced13', 'f47ef9f1-b1cb-470e-94b3-a58494841a03', 42.64),
('3410009f-2c17-4f2e-8317-c93cca522834', '2e89660b-092c-4813-bc0d-c3db36efcbaf', 30.00),
('10d07fb8-1e6a-4d6f-b43a-7a88759025d8', 'ef17d454-a084-48bd-b89a-a220576ac883', 30.00),
('31696652-0c68-4187-905f-83324ce456e1', 'acc6bfc5-2949-4f4a-bb32-d9dca834b397', 190.26),
('761a0254-8dd2-49da-ab0c-67a188d21f31', '145fb034-93d7-4426-bfe2-b0e32dedc457', 13.67),
('ec566cac-a09b-44b9-9bcf-e92e415db349', '37422da3-312d-404d-a924-4b8bc89ecb4c', 32.52),
('88454671-81b3-44a4-8732-27cc2ae8a016', 'c04ed33a-b38e-49d8-95f9-b0a331a313b8', 184.74),
('3233c82a-6c1b-4deb-9d4c-65fbd7f0bf54', 'b12e3bc9-093d-47c6-8bde-8f58d517c93d', 357.17),
('b6afde4d-1e55-4606-8098-50432346f97e', '1cbda318-a052-466f-b7dd-f9c99cc1a7ce', 236.33),
('ecf31da6-17ad-44e4-8de3-2bdfe25566bf', '9a75a0e3-2468-4b10-ac3b-6ae4b2d8e90b', 573.20),
('44de6e31-8edd-4bcf-b5d1-998f2ebb4f1a', 'b94b0eba-81a0-4d79-9595-ed724b9dd66c', 54.93),
('fcfdc833-7bf2-4e07-a38d-12437b10619d', '437320f3-2a74-4ef1-a55b-5769117c68ed', 234.19),
('92b432f7-0069-4236-b7d2-1f06635f15ae', '775808c4-0a0b-46b6-a7be-d4f65f2449fb', 30.00),
('2e7e56e3-2f47-4c01-bd47-d1b088e21ecc', '04f31039-64fe-450a-b8ba-0747137399db', 26.84),
('39422a87-573c-43bc-8159-6f9bdc84d3bb', '19fff472-fe25-44f6-9a97-343bc71b5e80', 469.28),
('d0ba579d-ad4d-4599-8c58-2013c7c06210', '12a48512-fe21-4ef2-a3c9-87bad5b44624', 30.00),
('1e1bba2c-a094-4e82-8ee7-db05ec2dee91', 'e4faeafb-7d96-436d-b41a-afb54d3d52b1', 18.39),
('f43f4a6f-99b4-4903-bff0-fb693051b9e7', 'ce89d29c-a371-467b-9e4c-df519b3efb33', 106.80),
('cdbc5b71-5756-440a-9058-33411a5451ae', '7b2fbc78-e5a0-4aa4-bd61-5371753833a8', 148.60),
('8360fb20-1198-4471-a9ab-f82f64ed48d0', '71130d1a-3a7c-4714-92fa-c0e94d89bcf8', 527.44),
('3999353a-ad50-4a16-a66f-9b64c7117e50', '8878893c-6c4e-4e99-83fb-db2ef68c41a4', 11.81),
('d561f671-1588-4e21-be64-cd4110d48342', '405a8662-0014-490d-ad11-77ba8a3263a0', 50.00),
('5fe03872-e3de-4412-84d1-620a078e57b0', '09e3b39b-8a2c-4cba-ae5a-fc871d6b6d11', 5.12),
('44ffa7ef-8de7-434c-bf6a-ad02bc22017f', '972f020b-6344-48e4-a1a1-b2a410413f25', 7.52),
('2162d2c8-b104-42d5-92b6-a6baf9b2f654', 'd9d1a527-cfdd-4a20-9cc6-27b677b31f75', 47.06),
('2cd0096a-9858-4780-a154-14eade30300c', 'd228ac39-b6eb-4897-a2e2-11d178e19046', 114.79),
('52a1c5d2-33f1-4489-b8da-c2da79185071', '22e06426-c18e-43c1-a36f-05d564d2099f', 203.89),
('e7d09540-e527-458f-bdde-65ee7b4d4233', 'b02dc2c0-909b-4f0c-b52e-09548a6cc46d', 105.32),
('d4d488ff-85fb-4660-897e-9cbcf3ea8e2d', '316cc683-1cc0-4609-9f4e-bfefde18659b', 76.63),
('c6ba8a29-50ba-40e2-bcc0-0c476aa0f387', '2561d210-ff27-447c-a2e8-5aa59c6a21e7', 41.01),
('ce2d3817-5bf3-40e6-8603-4057c0f0103a', 'ea81d476-2d67-47a1-8792-4b546b134385', 96.31),
('4fb6bc8e-e2f4-4f23-b1b7-07375c6ac726', 'bd08fafb-25a5-48e0-929e-db883809976f', 30.00),
('136cb9c6-af5e-4ea2-9ac3-362062535e99', '7fbbc1fd-3fdd-4149-965b-d363187acf96', 26.40),
('aa238afa-5c83-427f-bf6f-9eb67c478bc0', '94e3647d-ea9f-42aa-be67-d8615806d33d', 446.65),
('c62e3365-f053-4cf3-a74f-18e6ff726fe2', '23e63502-8a62-4c1e-871f-87a57d2a184d', 108.46),
('87791d7c-daec-4de0-ae20-0bda1ef16f04', '710ac845-bbf4-4452-ab0f-aa143b2639bc', 199.73),
('837882b7-b22d-4fc3-aea1-0b842d9a28c4', '4d8f6788-46d7-4f60-9977-ab274bed3c29', 85.53),
('f07ac930-1a8c-4197-9c09-71c0069be625', '0df5679f-9a97-4d46-bed0-2ecafb188a2f', 379.66),
('c9d9d67a-56f3-4f30-832d-b1c246a36c24', 'b3e992ae-b16c-44a5-944d-b0018d941c30', 122.19),
('59942a1e-4625-4e6d-9769-7d5c69b2623b', '8239f2c9-913c-4ea9-b9df-6380c9954bc5', 30.00),
('786b5256-ac0d-4a41-adad-7c405a0c828b', '8866ae09-b0cd-433e-b44f-f57f21563923', 24.93),
('a945fb51-8c25-4925-bd42-88b9300ad834', '01512604-9354-416d-86d9-5f2772a2c3ce', 311.80),
('4379b07c-3bde-4c83-9fc6-c617b168a922', 'efb1dcab-9b5a-4e98-b45f-f719c03f5a0e', 30.00),
('8c1bc150-29fb-4fee-a0f9-11cb253772af', '741a70d7-d024-4e1b-b6cc-cf1ceafb16a9', 30.27),
('d602902e-5c2d-4d29-a337-968324b51a62', '00225642-24a4-42fd-b56b-3cb03869d789', 30.00),
('87371e3d-7c20-4e55-8feb-a997dd15cf82', 'b49c237d-1d19-42e3-9df5-87c1befc53c4', 129.40),
('b3b0c211-00d0-46a3-8053-041487f3a6a0', '5d1e9c1c-7cc0-42fc-a1d5-a82e7712b3c6', 56.60),
('7f598585-e51a-4c10-bb18-dac04f0aba4f', '811754c1-94b8-4bc4-adb2-6c118c6f1a05', 30.00),
('5d1f6248-0ba5-4915-9d6e-5abd2cdcf0bb', '903815cc-5096-46b3-8478-f5928c297c4f', 22.49),
('88541118-d941-4b9a-a581-3bc8572128fc', 'd4ea879e-36a9-4ab0-b9ed-d4cd46cd912d', 27.71),
('73f78a7c-d80d-419f-bbaa-355bc866d815', '8c6a4f55-c600-418d-bb96-241229706151', 28.14),
('e20d8d97-ca18-4a15-9644-76447adc64c1', '21116dea-55da-45d5-979a-3795b8243edd', 30.00),
('b455d010-e0d3-48f1-955b-5787004679c6', '1a57932d-5538-41d0-89d5-61b7fb8a68aa', 215.23),
('9e587d4b-740a-4822-ace6-5cead4249e74', 'a93382a0-5447-4124-947c-26d0a51023a3', 9.75),
('29d45104-7303-412e-bf19-a5028eb2b6b9', '7284c793-dbfb-4dae-9633-9b88fad77423', 35.96),
('5e333ba5-a273-4989-ae13-1297e5e5d788', 'aead7b27-9dcd-49ff-a99d-2add65c79649', 74.13),
('c394ea92-2ea4-4c16-ac03-d2c4d1a0f624', '7541a922-295e-4e61-a411-7ce68b6d15b7', 2.90),
('a1ec6079-fe3d-4c04-bc1a-37a8c4d9b186', 'b6c4afb6-ede5-4eeb-ac4a-3d3d8e8559fa', 30.00),
('91312581-34e4-47d3-a72f-3a255b63b52b', '386b6bb3-b377-4997-a048-f59c5a42447e', 131.95),
('f5e16070-531b-4325-a0b4-a169ce6eddc3', 'dca5321f-fece-4d6c-a584-53f55c35536d', 74.05),
('4563a4af-b777-4142-a8a0-d81810c66ad8', '9ae53cf6-0992-4d6a-8cd5-3cfa86c506bb', 30.00),
('58bfaf85-6167-4d09-97e5-cf24ed73116c', '44ff7551-e9a2-48fd-9242-7f8a1298e04d', 30.00),
('f8e62365-8a78-4527-9e2d-c04632bb0166', '1765770f-452d-4d5d-91e7-6fb7df1c904e', 55.55),
('268611cc-e672-41d0-aac6-8a3e5afc25d3', 'b6280b42-c9da-458b-99e0-4936009876ed', 30.00),
('d5750431-89ea-4c2c-aabc-e88b3661223b', 'a2640b97-b1b9-4341-930b-2d2cad2d39d8', 214.60),
('3066240f-ca96-48a6-8366-26877a5f49cf', '0a9a80fe-a6b6-4aef-97f9-208751a7472b', 17.23),
('3f4d2657-2f3c-441b-84aa-657810abd1c5', 'a22b23cf-7e7b-4c6d-90ac-8d977d6211dd', 29.96),
('b2f4b7c4-66f2-45bf-9c71-9fe67ed5e57c', '00bab4a5-d4a8-45dd-baf7-0cdc98b58b6a', 78.89),
('ef53a41f-9b51-42ae-8056-aa1280b81bf3', 'b7ffc438-9064-4ca2-854e-3daa2be8dc79', 100.43),
('ee116eca-4aba-462f-bc67-9b522d8a7810', '71f33f86-eee0-4907-9fe3-c7e14fe9f0e0', 51.90),
('1a50d36d-5916-42ab-8986-5a57896f8f22', 'd7f48b00-ab1b-44fe-9d19-e17bee392451', 714.27),
('5920b508-c0f0-45d1-a1e9-f7565995c2f8', 'ad7b645d-40df-4a5f-ba70-6a0078706755', 74.16),
('1877f44d-7378-4e7d-a150-d3ba66063de6', '4a2a9ff1-c55e-4f8c-8ccc-e6d7386979bc', 214.84),
('8b90510b-7d0e-4728-832b-4a27d02d2f6f', 'f0b49c12-51fa-4d87-b432-8b46dfef7c75', 80.90),
('46a5a191-16ed-46ee-be3e-c7d13272d8c2', '77f5142f-7a53-4ac9-bc69-968c93efc3b4', 107.01),
('d485ada4-b300-4aec-a219-c2a88ec765d4', 'e2b7df22-8c77-457a-bd4c-33bf82a98459', 351.27),
('0902af18-7d96-401b-b1a6-357b76aec642', 'ddc71958-3a28-462b-bfc3-52254820839d', 30.00),
('7d25df3d-11d0-4572-a08e-f1b9f1ffa4bc', '45732e1f-7089-4bd1-8e52-fe4dba61708a', 43.08),
('b28bc46c-dc5d-43ef-9d55-33e7cc7b2826', '5a149daa-9164-4598-94c0-7bb8d8fbd9cf', 167.19),
('f4ddf08b-769a-4950-bc1c-a0ee9c2d6989', '7df6647b-1247-4009-b664-9e2385d7d851', 8.55),
('e2eb213d-9d7e-4000-b6bc-b5e11deeccc2', 'c2ec3539-72d5-49df-8092-363d32bc6dca', 264.47),
('ceec2da0-f5be-45c2-add3-602bfd5941f8', 'f3d9beca-6a55-4815-956e-c4f78cb93179', 4.54),
('b5f0f5af-9840-4d53-b526-4119a9d7c0d3', '697bfb68-3912-48c1-b304-76c17b616db5', 30.00),
('4687f217-2232-45a8-98fe-21a3a4b49e1e', 'ab661001-7a17-4e49-a57c-0252c85eb705', 2.01),
('64c3bbb9-67c4-414a-a92b-5cc84c60ed80', '844e9b26-a1e5-4434-a137-0fbd885d7e28', 30.00),
('aa131406-0a54-4e70-9a09-a420f2197cf6', '3dae3480-b9e5-4694-8b5e-4e3827a6f8bd', 132.85),
('257efac5-e7bf-4732-bfff-69ac21c36c7e', '598c3115-733e-41cf-8b39-e965a497d881', 98.20),
('435ecae5-434d-4370-9bd1-2346d336c30e', 'a4d5280b-0a5f-4d87-aa2f-beb30514581a', 28.67),
('94c1de1d-b983-4f3c-b3f8-f66698c9477d', '5a9bd7aa-a3bd-45f0-b229-8a35388ff39e', 30.00),
('de925638-18be-4668-8e5e-d7e98305a423', '884ddaf6-6d2e-4a95-ae30-0619c024c869', 30.00),
('fd73d04d-9bad-4b5d-8170-b160f894bdfe', '5841a604-ff0e-4591-9a59-23b46381d3e4', 18.92),
('a99ae41b-2077-46f5-914c-cd6911aa881e', 'f7f3108b-9145-47a0-ad66-b6833f6fa479', 64.87),
('af69ee8c-5f46-48c5-9c47-17980edb6312', 'a0a0b8c5-0cb0-4be4-ac16-84f0a513295c', 21.47),
('6c4eb03d-713a-4410-bc3a-a95a488fcd24', 'e1ae4553-10e8-49f0-a2c5-6967c5d431f6', 18.01),
('65a07b80-b093-48b7-be02-8b2b0165d425', '14e86aec-c6e6-4ab5-9846-6264ce0b7e69', 30.00),
('4d88623f-b1d6-4ef9-911d-06df4ce731d1', 'a6020c6b-cd96-45ce-a248-0a4a95e95b90', 61.93),
('e9a3ed14-1560-46e6-a770-3775fca0d29e', '96309082-ecfb-4039-8068-64aee98383ec', 10.25),
('66c7e601-f98c-4388-b4df-564f24665af5', '67352f75-ab19-4688-9b7f-97774ebdd972', 73.83),
('5edb3690-0b85-424b-a8b5-97b3c1234185', 'b8548af9-d855-4857-8957-3323d9bf605d', 30.39),
('42d705cb-a29f-4d85-aa1f-b0c9515758b9', '58b6babc-71c3-4c25-a42e-f09102c3b499', 30.00),
('7f9343a2-c909-48ec-b956-680ace0fecf2', '8138eb4b-b716-4cf0-8d43-7abee07b7078', 33.06),
('601ae414-561c-438d-be0d-d1cece1c2532', 'a985ba15-601e-4b2a-b185-3c83ff905c7c', 30.00),
('e516193e-01bf-4315-81e4-f0122237a6fe', 'ae165539-fe66-4d6c-b228-02d6662ebde9', 216.55),
('0a692805-c17e-4fd5-8cd8-11371f7cc5ea', 'c33985ce-bea1-4392-af08-83e65b22255e', 60.42),
('1dd3cd7b-0989-4b0e-abab-2747e0c230e0', 'c9af4dd7-9d19-4a8b-9e4e-20de78c08a3c', 31.53),
('beade4fe-a160-4d0f-a877-f6d7c2e5863a', '07b78a27-cd7e-40c8-849b-ca4b0da78825', 5.73),
('00ad93df-adf6-4e6c-8877-049f9bb86102', '09deff49-6437-40f9-b29b-562bbb292310', 92.32),
('5ee200b1-2dd7-4416-a3b0-3c3902d8e4fa', '578219dc-8a67-4eb4-8da9-0fae20d3092d', 5.26),
('5fb8364e-ae7e-4283-b3ec-7e6e73cb9927', 'aaf76e90-0694-4161-9808-c46924996681', 631.05),
('9d5cde26-8630-4837-bb13-6b1d958d52b9', 'a5254acf-2a4b-41e7-a9c7-b94a50fb0dbe', 96.88),
('4176580f-88d8-4672-8fd6-7e802cb4dd00', '8fd8a551-d182-4d7c-8496-f4d96e1d216d', 30.00),
('07b2eb32-8630-4516-bc49-0fa9cbca030d', 'd3a4b58e-9c0e-428e-9731-51ec5dfeeaf8', 69.18),
('6facece7-8726-42f7-9a79-1d0b94b7b1b4', '20e250fa-7741-4bca-965f-44d0a77b208a', 16.95),
('932c580f-fa92-4be2-8e65-d0e23ddccc11', 'f9a4a291-c7b7-41bd-a88d-d1016d86b1ef', 72.51),
('456c8f72-b3a9-4597-9116-3f1988514f90', '570fc648-5143-4331-bc34-987bf5726e56', 47.67),
('63625fb2-1167-4439-a204-8ba1e687edbc', 'fc9c1b07-05fe-4243-bfca-50b8bd62fcb7', 106.07),
('a86efbb0-8fc4-4ca9-9b97-2472b6395baf', 'c8b62134-e428-4ba9-bbfd-304c66148453', 501.66),
('64a889cd-5310-4a71-a46d-fcc0a7ce6bf4', 'bdb4cb04-f76e-4173-a701-fa4cd1dc8d1e', 30.94),
('7de44aea-4652-4c35-97f8-d1a2ba7f6262', 'aae6b110-fafa-438d-8be3-f65e353d7813', 119.65),
('cdcba758-e52e-427b-ae39-a70b216671ee', '23872cd5-9cea-43db-84bc-3723055ffe1c', 30.00),
('6783cc95-7056-45d2-9b35-fafdc0c1a5a4', '07e1d773-3a51-4b71-906a-0233d2353a64', 86.30),
('eed21d57-3cfe-46ac-9e03-3d02a1583838', '9e3a1a9f-3aca-4793-bba4-3cfede07048c', 30.00),
('b7266abf-4ec4-4519-9ea7-df495918df45', '61e1704e-64da-4af3-8268-b72e38321f33', 68.10),
('c9e97412-1fdd-43e6-a5a2-280cebdd03d3', '6ef49c92-e2b9-4bf1-ad81-8ca4657452a3', 88.32),
('5f143c66-5e9f-466a-a802-734880f84f2c', 'f519a10b-aeab-4535-ae90-d99e09e00400', 672.08),
('45e4f157-ddcc-46b5-95cd-b4fedd218726', 'c20812c2-55b8-4ef8-99ef-d9a02a1f35a4', 30.00),
('23c2b1ed-026e-4065-824b-6e2f67a38ffb', '03167b64-7386-4031-833f-945fe5c909aa', 373.11),
('8070e566-c5de-43c9-80f2-d7bb17f681cd', '35ddce91-be15-421e-b820-2878a732f259', 30.00),
('7a53f7d4-efa1-4a2e-baa4-7984111957ce', 'a4774728-dc33-4b3f-a681-5b87c1594b58', 193.39),
('8e8e04a6-5991-48ec-b785-3466ac41b224', 'b673410b-cc47-4876-b961-8fac984e063a', 307.09),
('005d0a31-cb4d-49d3-aa6f-bc2e5691f146', 'aa1044ef-ac5e-4777-82e0-d4ea8ddd04fd', 19.35),
('55bd7c0f-7bb0-4720-9c7b-984e8b45a276', '8da5acbe-923a-49bd-9814-ec7aaeaf5137', 136.39),
('07bfbc27-86c9-43c2-abb4-3faf0d5bce2e', 'aa6446d0-a3c6-43a4-aeb8-4ba0d0c866d2', 88.76),
('e8206702-0bc4-4a82-8c28-268276468f73', '17f8568f-e1f5-4d95-984d-30f057e443a3', 107.49),
('9c135bd8-62cc-4e9e-b3ab-adc3242c6ffe', '6a311552-7dd4-4b79-8f83-c8afd62be414', 18.35),
('b5246e58-e860-4b4a-a8f0-4e322f49f617', '32c24b67-2c33-47f7-a802-856c8e79780e', 30.00),
('2f796016-f157-4d83-950d-ace179f5abe7', '3a0d9587-c86c-48f3-8795-c5f87bf0bd2b', 96.18),
('ccb08619-5e4d-466e-ba4f-18fe09debeb1', '1dcc0d2f-d39d-4c73-b881-eda539208ac6', 92.37),
('557099b5-0f1c-4c36-a8cc-7a715e899ce6', 'd7d0db9b-5ae9-410a-ae43-6b5da969183a', 110.58),
('95a85698-1398-4931-a8a0-abde465a67f0', '5b233663-0e74-4230-866b-c3a3c6fba856', 55.47),
('0560faf9-e346-4ed1-9b96-90e9e4ae7811', '0216ccb8-8787-4dc2-8bc4-05a9d1502d5a', 30.00),
('76daf22e-9476-4116-8d6c-57fc46c716d7', 'c1b8686f-20e9-4da2-b369-be36d2dee15b', 236.33),
('2a92cd69-89ed-4206-9aeb-d066838ec880', '326f86aa-6ceb-403d-a8d9-281d498290df', 22.11),
('decc6e02-055c-4a20-9835-708ed462560e', 'd445aea5-e1bc-402e-a565-397a0bfe6c5c', 58.03),
('0ec66612-a398-47c4-a4ee-467ac45c772d', 'c0912f16-178a-4a00-a698-c272d3338ecc', 217.03),
('4f27e18c-3ecd-42bd-983d-2595008f1abd', '2a73e062-3405-4ca8-b9e2-14982e1efa45', 30.00),
('a6c4d985-fa1f-4014-bcb2-678f8b16c41e', '13091c2c-71a4-45c9-9d59-e354a6e76f87', 181.43),
('93258620-6071-479a-80d5-61b72a9bd750', 'cf68c687-72a1-45be-9dab-63ce40fc8a14', 81.16),
('fa0b601c-304e-4c3b-b1b1-308ff5635b49', 'fce47e45-56eb-4530-8972-06cf94a9e0a5', 61.03),
('8d855734-bcac-4dc8-b0d4-44e3c675539d', 'c8572554-129b-444d-bbaf-c1153d9b23bb', 101.42),
('6b3f13e5-2d62-48bf-b4eb-fb52f2d01a23', 'a2004c87-1f96-40ec-ae45-26e209869803', 30.00),
('641a4b96-6b5f-4e94-b6fa-e8cb74a92227', 'fe2323e9-cd7e-4c89-8477-f9d3a50bee11', 30.00),
('d9d970ad-da19-499d-b109-49ca3544d46f', 'e1a98b0a-b86f-49ab-9ac0-be4c1e231562', 41.05),
('dffbf045-0186-4544-a610-1751123f7b64', 'e5abd6dc-2fb5-4c69-a7a4-ba4ec4352384', 96.32),
('51014167-97d3-40c7-a435-2f888bc053e5', '696bd04a-1b3d-496a-bb6c-370d1cbf557f', 30.00),
('0a33f085-3753-46eb-bf2c-3e8fddcc9a20', '1cda8c1c-2832-4cd4-a3c9-25ee6f7d7583', 24.63),
('7ce9f3d7-5b67-4ea9-a95d-947a583d98e2', '2202f862-613e-4f6b-9fc8-ef9d89ff099e', 30.00),
('a90e0b3e-4a4c-4c49-90d8-6a332b79550e', '63a46d66-9480-4f6d-aca8-efba2c8a2336', 31.21),
('0155ab7f-ad8a-4c97-b74c-76429c4b4443', '7f5ece48-95ac-4a8a-b707-b6355a75433f', 30.00),
('a97de9a0-3eb6-4d8d-a8c9-43c6af01b3be', '3919ca75-bfc0-45e8-9ea8-5351553b7698', 21.26),
('e0bd5a55-53ae-4bc3-bb3d-9d67394b83cf', '6c5a3996-50f4-42d8-9b82-9ed5c224d52d', 30.00),
('87a340e1-5102-4a0c-b90b-5f4c6e728ac8', '85ea0c0d-0e15-4634-b38c-f0e5a6947d09', 30.00),
('6fd351ac-e526-415f-884c-fbb4cfd9eb3b', '89c35f9a-0323-4b88-9f4c-465651aeff81', 226.33),
('ac1e7cad-2e1c-40cd-81a7-fb809011f9be', 'e5b96aec-98be-4cb9-9928-120dde7ae57a', 234.51),
('6fa90c60-0b85-4a44-b1bc-eba042d4cdac', '243fdfed-5102-40dd-a670-fc98dad2454a', 319.25),
('37b179f3-fba2-4d6b-a294-9fb1d4dcc1e7', 'd87ace37-0581-40b1-823f-7e6117e24cc5', 278.29),
('4bf5c479-6aa8-42a1-a176-b4446b489823', '1146d2eb-3d47-447b-9196-f72e0046d5d1', 18.80),
('67c938bf-d6e6-4ada-98e5-bee592040ac2', '32dbeb69-907a-48e1-9f8c-1375f46b5bb6', 23.83),
('95bd889d-4ed8-4fac-b27e-fff983db12c8', '5391b622-5c74-4761-823d-f83b198e5eea', 30.00),
('f6d33fc6-22e4-4ff5-99d6-17bc1112447a', '66bd2957-c129-4bc6-b46d-e31e360412e8', 30.00),
('149c8079-a31b-4abb-8f4b-924acbaf3b9f', 'eb081cee-34cd-4100-975a-46e1ddec5113', 60.88),
('a51c4390-0c01-42e7-b5cf-091076152fb3', '587b7e4a-2e5d-4719-ad26-5ac8cd140ac6', 55.88),
('5e0f5435-dc1d-4f9f-988d-158ceb29614f', '5925124d-8d82-491e-992f-02dba42fcb98', 69.79),
('d3f00d93-0385-451c-be5f-8bc6dd19fce4', 'b6cc4177-111e-4dd5-a12b-1a3a47967c90', 30.00),
('8a76a4fb-3561-4588-a192-b4026dd51ab2', '034dd656-9a98-4a69-9e96-3f4193a8f29f', 13.08),
('36aeff21-4472-4df5-b992-1e0273633bbd', 'fc86b899-4e94-4aa0-974b-1c63989f41a5', 30.00),
('3ab0a2be-cff8-488f-8e5d-36a72b014bd4', '57b080d3-76b9-4c04-9159-1df097bfc78e', 24.46),
('56b37da1-5798-43af-8ebd-3568717bee95', 'f80bc8bf-dae1-40b0-a5b3-d4b9b7425ff5', 127.43),
('fad70d75-5eea-4cb8-adc9-aabf5a7d4661', '310e1c05-8bcb-455b-ab3e-f736246c5a6a', 143.98),
('fc40abf9-6c85-4f04-9695-d566ebcf1056', '6abec072-344e-407f-86a4-12cdc9d62d3c', 87.91),
('f4ef4d17-d4af-497b-9b5b-b27585b61410', '61f6fe11-1e8b-42f1-8a34-0b8c8f3a04ca', 30.00),
('43834513-d0cd-4fdf-b403-29c26e759c7d', '48f21ca6-abc0-4db8-9995-bbc2cd0a75fe', 129.74),
('d28fe7c0-5c59-470a-900c-694976c74f0d', 'dcd3efdd-d35a-40b2-a185-379218c11953', 76.96),
('13c82834-4796-4c45-8152-6a90177e8b79', '6dcfb6b0-69af-4307-9ff1-9058c7621cb1', 376.71),
('a080bed4-ef42-4114-b683-0a46111c4617', '9847da02-eb9a-45f8-a897-c9e42fe299f7', 25.10),
('d50a4d75-0fd4-4ff1-911b-f00756cde44f', '9fdbc2dc-505d-46af-8e73-75e9d9bb1aa2', 38.06),
('1e417caa-fe65-477b-bda5-a2919c427ce5', '1958ea2d-c0cb-4c05-9f1e-73a1111161f0', 30.00),
('92f7dff6-3084-4062-92ee-811b75a7cd6e', 'e6e69b82-10e3-412a-a240-dbb18293f61e', 30.00),
('9e5378aa-1df0-4fe8-9213-d8bcbca19441', '4ac483ed-75a1-4cb9-aaf5-43521f21e672', 30.00),
('ff0446e2-af61-4779-a77d-88393d92799a', 'ccd120ba-0849-4370-918f-4f82baec033d', 693.02),
('b447ddc0-967e-4590-83ea-24df669445c2', 'b96bb9f9-dab1-43b4-a867-2196b83963c9', 49.13),
('c56531ec-d957-4d01-b0b6-9ee86157f90e', '421eb786-f677-4403-b8c9-765de5448e04', 29.08),
('dbbee350-42b9-41fe-9442-77e9f703971f', '1ac993e1-ae70-4969-bf49-f65cce2612a2', 39.12),
('70871d7e-9c51-4a9e-abda-452f55136ce2', '29134916-8b97-428e-8e85-5ad25d597405', 47.00),
('87eefa5a-2fbd-426b-9694-a048f7e6495b', '0e257173-09bc-41cf-8846-30510c0569cb', 27.31),
('ab09535f-f88b-4123-9a5c-b6168bfffd63', '2e4a51c2-29c2-4e3b-b605-c6666bb7ab27', 30.00),
('09b05f4f-c4f0-4a79-b115-835e3237ac73', '2ad06550-98c5-4e59-8099-e8533e70c454', 164.27),
('2424c00d-0371-467a-8955-a5772811cf08', '7eef293c-633b-49be-974a-1915aedc7045', 30.00),
('012c7e38-4696-411a-80b6-872d42f16f25', '3908c184-906f-4aef-b83f-aa7b2a392623', 30.00),
('36f51ac4-7318-42c1-9cf5-8d47b685b8f3', '358046f4-02a5-464a-bf2f-e6731772c4b0', 97.68),
('77fe8879-a78c-42bc-807b-89f96cbe333a', '90937732-c381-48bd-8a3c-5cb9c8d16a31', 13.95),
('b1caa80a-d574-48f7-a973-5b9d16b1a91f', '4f4355af-bae6-4a00-9941-e377084388b9', 30.00),
('c7f8bf85-6195-45fe-ad78-ebb32bff22ec', '9a53bd4b-91b7-4c84-8e76-a4de1d3cf0d2', 30.00),
('dbb9772f-2595-4a59-b2d7-5f688cad4604', '62fb251a-d155-4117-a4c6-08db27d2ecfd', 128.98),
('044b0cf3-a72a-42f2-b64f-ae2e4eff10ca', 'c7632bd1-e727-47a6-a38f-ea29001fd812', 32.80),
('9e87bf94-ac6c-4ab9-93ee-3a4f934af390', 'd363002e-0708-48b3-956f-36df4a21471f', 14.43),
('87a90745-e453-4138-b88c-73ad6c778ee9', 'f39e1d81-dd60-4444-95c5-39f383010858', 30.00),
('aa0e5962-f538-4252-b3a7-c5cfa19dd667', 'd76c8a9c-083e-43a5-90b6-44662bc488e4', 54.69),
('93ada96e-eb2e-40ad-9475-f7267cb63fc8', '65e70f7c-4a36-438d-a43c-b8aa2a7255b1', 48.06),
('53c87117-939c-4b32-bd63-c9388a8f7b07', '340cf72e-6545-416f-8a1a-f08f1b438812', 228.75),
('cbc25065-f70b-48ba-b6b7-b731a8fbdc96', '8a7a5e0b-aeff-4831-a39e-338d61f38df8', 62.06),
('b1aa996c-1d1a-4b2d-9bda-0e936e618168', 'db70df09-a274-482c-8e98-65db58315125', 30.00),
('401bdc1b-358e-46fc-81be-18191bec08f1', '39259c77-96d4-451e-b738-519ca6dc45f0', 146.70),
('2c6b17b4-39d5-4017-9a08-98b460bb73d3', '9d0feaf4-09a4-4842-a36e-3b4cf2f8c7d9', 466.92),
('d3bf3898-659a-4291-a171-2413c6d3ebb1', 'ef592911-eb76-4851-8f05-f89e3113f385', 38.26),
('06cc73b3-1f16-455f-8639-371c5cdbfa8d', '5582f2c8-2d22-4084-9646-ffb105f6dcd0', 30.00),
('8e3e135a-c71d-4833-8e0f-86e34fa12d8e', '9ffa5662-de45-4474-8613-fe04fb33c241', 8.99),
('ea9555ba-f550-4f97-b49a-a24c22f73382', 'd1d5ef07-e9ef-4055-9380-a34867295608', 30.00),
('82b6a022-ce18-46e5-bf26-28eb89dc173b', '74ca177d-9d00-4d7d-98cf-0c66cbc03d6a', 286.91),
('051e9006-095a-40ec-845e-6e3b40240636', 'f7883472-3eba-49da-9542-1b1f1e532d7e', 30.00),
('cf7dedcc-e3c3-4271-ba5f-b5a875bdf7ac', '124a52db-b3c9-426c-b70b-890c39e7ca3f', 39.70),
('01ce08d8-4501-4f1e-9834-642c4a626d1c', '380f80bc-14ef-481e-81bf-a577c40530ee', 53.18),
('83a5e7ae-219e-41c1-91b1-efce586bba76', '1935f123-148f-4610-9bb9-07cd799963d4', 78.22),
('f6eda150-1ae4-43af-9dbf-1003541bfa8a', '7c986b34-39b0-443c-84f6-65d0cfab4c0d', 379.04),
('6f7f1af6-d0b9-40d3-aae4-d9f8777c0790', '372d6276-54a1-41fd-b2ce-78b729107f24', 98.30),
('50c4e393-7e7d-44b0-9a93-26b249ed37a7', '4d125e97-2b84-44c6-b8ad-133e26cfebc1', 42.18),
('607c82a7-a788-41f9-a969-87353efa6abe', 'e6cce8eb-16e5-4d51-a1d6-ee81c3dde8b3', 30.00),
('81c383dc-d78b-4e26-9353-5592c77338f9', '085c3eba-b812-4192-9847-6b5beac6a87d', 92.29),
('3b8c4910-0af7-4c72-af7b-5105ce20c719', '07acee41-c479-463e-a240-c7783e67f84c', 30.00),
('df7a7122-affd-4aef-a53a-a584dcabf5a1', '16ceb76a-3848-491a-a593-43dbc596d14f', 5.66),
('c8ad6c5c-3e09-43e4-9fcb-70ddc4b88350', '8610eec9-1cfd-4a58-af8c-1e8c809d48e3', 86.83),
('fd06cc69-5681-4ab7-8c0c-43fc6fb20f73', '8df8082c-1f8a-483e-a945-650db649beff', 30.00),
('dc8d79bd-a258-479e-acbe-dacc7239e9d3', 'dcb1d624-df12-46b8-8249-452630b90be5', 260.04),
('54dfcc11-e216-438e-8644-f692f0731297', '31a0198b-496e-452c-a42f-0b4c732c8859', 53.17),
('82eea397-c78a-4514-af17-b49b529c9260', 'ab3db652-4f17-4d71-9fcb-42bcb0202ae5', 30.00),
('97fce2b2-34a6-4c80-b877-eef02b75a7a4', 'f240e239-cf2f-4146-88cb-b2e6d82c0ac3', 91.85),
('d7d73c14-2955-469f-a4e0-7081e266520e', 'e741698d-5d3f-431a-b30e-e25ba6c0a737', 101.75),
('831b1c49-2e2e-45a2-adcc-7e8ffff7b9ff', '9682e68e-712c-4553-a055-5a82d9a2e394', 30.19),
('149296a5-8fa3-4f59-bd34-3abddb5c7b4f', '6b8cd5cc-b698-4275-89e7-acbf2525a05b', 30.00),
('770769df-4ae9-4a49-bd7c-e146ed200533', '169a96b7-07a7-4c4e-be1a-fb3c1af64a76', 12.69),
('6f49a3d5-b3d1-4025-a4fb-0b3b8b2092c4', '4d7f3244-5ed3-4b56-94dd-3cd7a976c423', 95.87),
('2038e787-6c07-4e30-ab02-2acf24dd5ba7', '848b6947-6bea-409a-bd8e-5960a20c50ff', 125.15),
('3f07443b-97ef-4ca5-9c2d-31d4fc339bf8', '60328015-384d-4e52-8422-bd739a6ee459', 119.35),
('27e9c6c2-3e2a-4380-a371-d3e1b9cbe71b', '3af68a4c-ba4d-4240-95dd-fbe55350336b', 142.04),
('22fc0c15-d64d-4f3c-a41b-3a72a6340f8e', '74cacaa4-bf90-48ca-accd-983225b912c9', 31.42),
('56fb6cea-3ed6-4da7-8d4b-3fe860e1d975', '8a823355-9fcb-43c1-bc63-376f9cca1221', 31.50),
('6d83b4ab-8b14-4a6a-82e8-381a14fb3ae9', '8c6f017b-e2bd-4dfa-8866-a6ea5643de8b', 73.89),
('b6d7fbce-2758-4da5-a065-b0aacdc62409', '68cd0f2d-f610-4279-a9b8-9f60e9a375f4', 38.30),
('475b15df-7202-4440-87fc-a88c2a8bee92', 'b82650dc-4e31-438d-870c-3bc6ae1947dd', 209.18),
('74bde286-be25-4c66-9c7a-8f20f2d11745', '922cba47-d245-4737-ac53-2fefb64e92e5', 30.00),
('eabf2723-cef2-4cd4-bf88-316dfb60c9b9', '7ab71a56-69e6-4762-adc2-8dd4e76edce5', 24.73),
('73530527-6f61-42d5-a2c6-fe36af5ec9c1', '7c026c38-5d62-43df-b9e3-8582247e5368', 218.25),
('6dd4b25a-3a75-4886-a0e6-82e840104855', '20f5700a-f7ab-41cb-92d7-92a3f6ea6633', 30.00),
('c3b75570-887e-4666-9071-58bd0a4f5b65', 'c0f06872-4571-43cb-b570-71f80a191230', 65.08),
('5de470ed-deb6-4a19-87b9-3a61436f8c98', 'dc7a8aa7-0169-46b6-96be-22dabc792048', 45.18),
('8b028f88-b0e8-4e43-aab3-63e8f9e8c4fd', 'f7e5a49a-6687-460d-ab60-d7ce439dd406', 220.37),
('d4989bc6-06eb-4621-8cda-25677fb69e48', '29428b20-80a7-438d-a0be-a3a2ba1914e3', 30.00),
('7b0c6d90-4335-4d02-9e88-87859c16010d', '26b89a0b-0486-479e-a628-dabdc15167fd', 63.34),
('0d92f77a-50f1-4f0c-9048-14d24f2b6c30', '1485f8b6-3b30-4e64-a619-100c21aacaf3', 144.56),
('d8ff4276-a412-4c09-84f7-79cb8ba59245', '0e06df15-f78a-4052-ad40-6428c386d09c', 8.92),
('210f4d5b-c288-480a-a194-7e16a2793b7d', 'f4554490-e19f-4c01-84de-41fd517cfeeb', 12.15),
('789326ad-a625-4284-82a6-0564a92072ce', '669cb6b0-8f9b-419d-a0e4-768f5a22176b', 23.08),
('ec7bb2dc-1e90-462e-ba45-2a908b8e59b8', 'c56db1e4-6ec5-4189-b22c-db63947fe750', 41.45),
('3ade77fd-6b73-46d1-94be-025c85cd14a7', 'ff0b2254-1b14-4e8d-9fdf-66f1acf39e02', 51.36),
('f3719856-5192-441c-a551-83c8fd3c370c', 'f66fb604-bff7-4c28-8a4c-e79f22ebbe2b', 48.80),
('7dc0846e-12d7-41b4-872f-4231e91589df', '668625a3-21ae-41a7-92a2-30eb71334828', 150.60),
('19b54283-3884-4738-8856-b8166e6d0d15', '1fd45212-4d68-4187-ab02-7755f2378b6b', 113.81),
('cb95da6f-5b7d-4e75-ae1c-ab42095a891b', '62e0a3a2-e8ae-4746-a888-efb88982097f', 151.46),
('42cd0c83-2f02-47bc-9186-8afaa102259d', 'ed2c582b-d086-4552-9f31-211858b225d1', 283.62),
('5b770dff-2455-48ff-be10-f56d450736f0', '3b8e277a-f4b3-450c-8613-c78e014382fe', 30.00),
('b75b2da0-e038-4ff2-a34a-b113ca83d700', '4705461d-2ebf-4182-ab18-e8695081abf6', 30.00),
('f5d05d93-00cc-4a3e-b7c5-62fd351ba4f6', 'b7011773-2450-4e4f-8441-bd32099bfda2', 2.30),
('14f9cf18-5552-404b-8efd-caebb3f2eb8d', 'e516bb78-5d68-4964-ad29-a1bf1bdbcf13', 23.80),
('fa1d60f2-4c69-4caf-bdce-80661a063fd8', '7ed95503-47c3-4682-80f4-62c5ba15808e', 30.00),
('d540a732-db2b-4fc5-8995-c416e5b7e7ca', '29d82629-d2bf-4a98-b89d-d7ab5a0a3d69', 30.00),
('258ae51f-6dae-408b-a530-ae632f56fd56', '95c8ad73-1c14-4317-bc4e-37f465cf860a', 54.29),
('30bd296f-48dd-4bd5-95e8-f0566570be2c', '1d930034-0857-4871-825d-c77a7b2b986e', 26.10),
('e165f26d-a313-4886-9799-fb7f052809c5', '60727d1b-0fd4-42cd-aca2-cc08952bc532', 30.00),
('af719064-af3c-47c6-aa2f-5354b8bec0f9', '2174862b-d94e-49b2-b0c8-5aae428291e6', 118.81),
('e9a00c63-c01a-488a-b5e7-a5a03d1f66e0', '3fe37692-a9f9-46ec-a956-4b74fd581de3', 17.54),
('f8248f69-047f-4dd7-b101-beaa76efc893', '826865b3-cca2-4727-bdf2-991a60c02cad', 30.51),
('9eec112b-095b-4f17-8d16-4f72b41fbf86', 'f3b459c2-e5f2-448b-ace5-a9c237bdd999', 29.30),
('430ecbdb-4016-4f07-97d7-77a6b93f2706', 'bb451825-c1f7-4931-8236-f8af3c3ec95c', 80.92),
('97232d30-9778-41c6-905b-013719fae8b9', '09795b38-eea4-420a-9464-c5f5297967d6', 482.93),
('a344f292-4fef-49f1-b179-ddac7939353c', '82d03675-e2d1-4a5f-8bed-c2cfea44f549', 295.90),
('cbadc653-103b-4238-8a47-1f6abc815a1e', '3ebdd329-b324-4f3f-8ccb-d07ca101587f', 11.67),
('30ce7f20-de20-40a0-b92a-ce79613717a4', '2f918f5a-da17-47c9-9217-c578398996e4', 11.24),
('fe93d61d-f038-405c-860c-d9877d2fbabe', '660bf177-ad4a-49d2-91ef-7e1c6a10ef48', 30.23),
('06f50681-ff0c-4c8a-9b38-e9fdbe3cc28c', '8b7370f4-ea7f-422b-ab4b-ac120ef4a2e1', 13.42),
('72cd74c6-f1c2-45e7-a9de-f922cf0f4c47', 'eb7367d9-2e5b-4b7b-8ea8-1404ec792b5f', 40.02),
('e5e9b595-84c4-4950-b8f9-a4eed087423a', 'b4d158b5-dd23-41e1-9db0-453dc687c0be', 5.60),
('375fe6a1-c33e-45d4-b62b-0f4c54db2c4c', 'da4b852c-bc67-4d0d-a998-79bebeede891', 30.00),
('4aaa16a8-54c9-4d23-a837-e7554ebc8bc0', '29e2f9b1-5a26-4cc2-b2ed-2494e4bb4ffc', 30.00),
('a13dd089-55ab-4f91-acdd-80b71bba3aea', '7296bc6b-8b51-41b5-98e0-ac5116c36021', 11.13),
('94f9e310-aad5-48b1-80ba-1c33602a6980', 'ce0afa1f-d49b-4d95-92f3-17ad50588276', 30.00),
('e1986cf7-4782-4a9a-ad94-79705b52f888', 'ba312322-ef66-4812-8fd6-22b8e5eb1edc', 30.00),
('4f1aaac1-2343-43d7-8995-7cc84062602f', '9e07b45d-efcb-49c4-99fc-ae3cc5b0599b', 57.43),
('eb6dadf9-feb7-4ec7-8738-37a781e4f035', '39eba44d-9105-4c9e-9e9e-84060bca909a', 80.96),
('fcce76a2-b988-4953-b61c-e6d4039a6de8', '2431bbc2-7bac-4dc9-a799-f68e85a7e0d2', 53.92),
('58c80174-30f7-430e-a2f4-a9e2d5c2b429', '08f20014-1004-480b-a9dc-81b8757dd4ff', 108.78),
('a5a7055c-54c1-4e3c-8b9a-d1f18209755c', 'a51f817b-5542-4bc9-9ed6-24a60fe8b79b', 19.20),
('32092fbc-1a97-4c8e-ac76-46c0cbdff43a', '8204f3b2-a293-4731-b06a-b1a773858b67', 43.29),
('50554afc-ea80-4dbf-a4f2-700bf28aad76', 'fb38fdd3-ae4b-4cd0-a974-9676e94b1748', 166.08),
('c4e612bd-77fe-4b36-b9f2-d1d7bb7a36e4', '4aa1eda7-faa1-4b32-89e1-be3866015b7c', 30.00),
('d2fe8929-28d1-4c2a-9bc5-56ca8549504f', 'b377706a-c4c8-4765-b059-da24bb80886a', 30.00),
('6fe8e695-8766-4ba7-b3a6-c94724a732ae', 'c38418c4-91be-4abd-9ea2-39a7534dfec7', 30.00),
('b27cc5c2-eb3c-4e2f-93f5-557125396f86', 'bacab9d1-f104-45e3-b756-33b44e0434ed', 81.13),
('dce45607-7e02-4bc7-9687-9008a4f1f74b', '38e5fdc3-da43-407b-bc24-2479da7cb594', 120.06),
('a80c3026-ad3a-44a3-b1dc-7009e468449d', 'bd69c54a-9230-4e64-8ff8-be0d8c375eb0', 27.66),
('f59b0093-76e8-4c83-86ee-f73bd282b37b', '3d878bbb-5715-403d-b0c1-7dfbb64af33d', 183.76),
('28b3721b-1191-4ee4-ba20-13eb611f5549', '4ba884ad-0abf-42f9-b860-4c751427a34a', 221.68),
('6bf7861a-5ec7-475c-87c6-824e7e48cada', '17945a79-1160-4a0e-ad8a-39d5581fd229', 139.20),
('c8996d47-1491-47b6-9ef1-7fe56e807d54', '1c5587fd-85f5-4b98-9f1b-34aa60f7857b', 147.31),
('86d747ff-bd5a-475e-914c-1657ab26a2d1', 'a414c392-751c-40fe-987d-cc3dadc1aad7', 284.95),
('3754ae4f-ba6b-4594-ae88-7316a663ec25', '7a6f0f0b-70f8-4745-8222-01a51310ee95', 30.00),
('4273df68-a982-40c5-abc8-bf96b88378c4', '597fc673-f8c7-4eab-aafd-3eef62b54ae3', 37.62),
('75fb2fb6-bb21-4c8e-9efd-9ebc21d21b18', 'f2281d68-f239-4b74-b051-c1c424af3de5', 122.19),
('94e2641d-3017-42f0-93b5-aec6749dd7a8', 'e52094eb-5710-4331-91c5-841977f7e58a', 172.52),
('ac75459e-9d48-4d28-ae84-b0238baa521c', '7adb711e-54c3-47ae-adc4-2b170bb79ace', 39.63),
('d8fb72cc-09e9-414c-87e0-f26ade9ded71', 'c7c11fab-edde-47f5-8f2c-0d55a44b524b', 30.00),
('43ab661a-b550-4e01-a1b4-1e60b772d811', '6e231f59-71b7-4d20-8f63-6b329640ddaf', 94.65),
('de6d2b98-1d18-479f-bdd5-5d273620dce9', '7fa27819-8664-4970-b571-574fdfaa2a77', 123.77),
('2003b301-59a4-488f-b2ee-53cc24e34cfe', 'defff038-ce47-42ee-a733-6cd24f6e4230', 372.73),
('fdaa09ed-df34-4cf7-baef-83ceaac6a1a2', '70999b56-335a-4e3d-a3d5-6f4df6f99c20', 142.23),
('32ffb5e2-3780-430e-9df9-00e4d6a78dc1', '6778b6d9-7a8b-4c7a-8d8e-09c981959bf8', 19.33),
('5c072e64-43cd-41a4-bc80-f0005d6bfef3', '838289bb-3634-4adf-9458-da1cb38443df', 69.24),
('50cf0cc5-d041-4be2-a135-995e6c1c9387', '8197ee97-3126-47d7-9ca8-c4ef9d5c85c7', 30.00),
('5bc03d80-6fd3-4b97-9911-169a3f28ef44', '052b276c-475d-4b66-a789-1c0201377043', 67.99),
('0ab68d1c-586c-403c-8dbb-7a5f6938a41f', '74dfe4a2-ec6f-42a1-8065-9b26d95cabef', 34.03),
('32ba0dc1-ca1d-47a0-8ecb-ff5bd05a91f0', '26146281-2e51-4c89-8f02-00b7dedd044c', 30.00),
('1431274b-513b-4058-baec-99ac1e75485a', '23f71941-39d6-4bc6-9fdf-f7d4c88a71a9', 2.51),
('7c4c5235-d8fb-4f47-88c4-42386190488f', '5816d1ef-81df-4d59-9209-437bda1a8367', 260.48),
('fe79d6c9-1b37-4cd4-9587-e8e5e557d8e1', '5a9fdc10-1c1d-4d38-964a-537a314f986c', 235.90),
('4ea3bf0b-5782-4923-8e47-64674d944deb', 'a7769dd1-d7d9-4d9e-b88c-f281d17ddaf4', 15.70),
('87cb6d80-75f7-4ce2-bf67-4a1606037397', '6c2cf5a6-e781-4273-ac94-690681ae0f68', 8.00),
('6356cc96-93d2-4359-aa48-5ebd6e495937', '814ccb15-5721-4d67-b679-685402c89755', 318.02),
('03c0e623-8660-48cd-aa68-83bef7c99efa', '995666b0-893e-4490-ac10-4a2751a70d35', 30.00),
('90add959-0d6c-4088-9119-c8b054f18231', '3ae32086-9880-4478-ba17-c00284f0bf6f', 30.00),
('91c76f90-57a5-4b41-a999-c47ab6729ef2', '02b54c81-4456-4155-b98e-357ef71c6889', 147.60),
('e88d5e91-fc65-4f09-9d1d-07df80fd37e1', '5ba9f46b-1955-47cf-b6c4-d99b04a2da82', 30.00),
('ae6303d6-1b9c-457e-b39d-ff45f3b968d4', '9cf88a1f-6104-4d75-9389-0d8905c73120', 30.54),
('d4fb32eb-8116-42f2-8c07-aad1c3bcb113', '6f5d429a-0014-41b8-8ae1-8211cad0f443', 61.99),
('c82f7257-b7f7-43b8-b3a5-72b4ff1b1a93', 'b3ecdb87-9dde-470b-8520-13cd8069ba02', 77.37),
('61329135-edd6-4b0b-822d-6526927a5a66', '4c7aee14-02c1-4bb1-811c-d5ab67e96944', 68.93),
('a882899b-d1e1-431e-9292-53c841bae5ed', '17252ee3-6f5f-4ec1-852a-882d42e97e65', 33.87),
('512c0a0a-d2d3-4c54-bafb-683323520642', '7f764247-5bd8-4aca-8910-563393753284', 41.20),
('cccf03c4-8123-4d6d-a3f1-e82713285174', '92404177-1cbe-48d9-8e95-d83d7a021c98', 30.00),
('d174375f-b88f-44f1-aa40-abdd1b46637f', '95323575-a0b1-4c8b-b5d4-69d6feb0d8c9', 129.80),
('7c4a1938-0bfe-4e5a-afb9-0dc1f12cfe23', 'c8b3add6-afe4-4452-b15f-56d89accec38', 81.10),
('e1dc3020-7a43-430e-a516-08aa856b0cc5', '8ba97a82-5428-4e99-af57-ca7dacd04d00', 47.72),
('54d7df25-ad53-4eba-9395-290c7c80b8bf', '5d487d45-f4aa-4cfc-ab8e-4fafbb7e6f86', 22.10),
('36000f6f-6feb-4761-b9a0-05bb9dc3b4be', '595be602-6bbc-4f97-94b9-81075f0ca51d', 19.19),
('c92078fa-7b7e-4c4a-b743-82e68824db20', '2913e0d9-231e-4948-aba2-1c777643d5bc', 182.69),
('1674311e-5d34-4fa3-8b8c-3478dc62c4a8', '77f186b1-fb19-4d7e-bc14-2e2083e5fe1c', 18.64),
('6a9a5e42-453c-417f-b622-66eb00e734dc', '630f2773-ce4b-4d5a-a494-81d2d1a12d8e', 21.30),
('56c08b26-9d18-4a41-aa29-d404a338c6da', '752f5b43-3c0f-4ccd-95fd-180c680e9ef6', 30.00),
('a154d110-02c2-4084-acb5-c2ea7037e537', '26cbad75-da5f-4a87-bc03-9126a43a2a19', 61.19),
('b3ba2efa-9bc1-45cc-98da-ca8139f5e821', '8e81428f-ca65-4836-a987-0b0eb1ba6904', 117.44),
('a862ce96-3ecd-4a80-8dca-7acb0b106681', '1d5df5b7-64ea-46bc-bb54-df1d832b0cb8', 59.96),
('103ea84f-4a05-4d29-ab61-81af77306e72', '9ed6777d-098c-409a-9e62-6f9c26c17b28', 18.26),
('657a7077-9d65-40de-9d3e-94728365c0ab', '87d08dba-a18b-41aa-86cb-1fc6cc84ad2d', 142.74),
('d7b133b6-2ac9-4571-8149-0bf714aa9c2e', '522ecb54-f606-445c-9d05-19307f99f0de', 30.00),
('5eae5247-5eb0-4f5e-bebd-dba6e07adf4b', '9b99a7ba-6e2c-4c2a-a34d-9704014bf96b', 136.82),
('968fed7f-9094-40f4-8ed1-ac1af914868f', '76940111-0ba2-4eb1-b4ad-ef553a044b63', 30.00),
('22a50a4b-b3c6-4e93-ac2e-8532fc1b4039', '889dcf95-2be9-4d81-af4f-4ff3a9434c00', 125.88),
('b0e04af4-b6e4-403f-bf1f-a2efd06a1966', 'fbc91e17-b5a1-4a41-aa9f-cfd8b68c6ab3', 30.00),
('b87809b2-3140-483b-b807-7aec3ba5b745', '2c17b42e-fcff-4fe5-989c-29d2e9751ca2', 19.42),
('55ad1c19-d6e9-4785-b617-e60940ebee8d', 'fec309be-cab4-402f-9c5a-449ca5bd8401', 250.74),
('3967d71b-b25f-4e17-92ce-07a6a2c875aa', '7692a5f8-593f-4d9c-94f9-226f4ee8d26a', 183.51),
('e6ddd85f-7532-4587-a829-9c0fd0ca842a', '80304338-e66b-4b25-8edc-3e1bf5b80fb1', 586.51),
('1cfbb22b-e2f9-45c8-86b8-8a79e694a670', '5f4c8b15-8b56-4f6f-a885-ab52d91e73df', 100.01),
('2ac10687-0763-4518-b81d-6f4e8939f4a7', '764f8580-3573-4b7c-a865-215121693b56', 30.00),
('d8717085-e589-4713-a131-240cffead0f3', 'd95dbb75-afda-4845-b903-94c65d8b2eee', 214.59),
('7c7064a4-9510-4dcd-ae57-809c5ae27e32', '66f11cdc-ef19-4abe-95d8-956df0caaf9a', 44.68),
('64b7bef8-fca3-498b-8b08-3360de3c093b', 'd6790a98-ae05-4895-9a60-a49a85e7822d', 115.44),
('27faadc9-73bf-4b56-9a72-2cfda65a33c9', '9a583565-7ffe-4691-9429-6e0af30b89ad', 1008.78),
('a20055e2-2444-45b6-a035-ae563da7b0f4', '80960fea-6c8e-4b42-ac00-1feabe74b5c9', 102.74),
('d346699b-fff4-40bd-a958-da856f8c78b5', '160627ab-d554-4246-b8ad-5208550f0b03', 9.24),
('3aba699f-6ac8-49ea-9645-6f4440fa14ab', 'b14fcc6a-9aaa-4552-ae93-6f0443317eb7', 30.00),
('2a9aa51e-1dba-4212-b44a-cd708e25072f', '143a729a-bc79-4b68-830d-c4af60704c2e', 103.50),
('7769e650-d426-4b10-9b61-86e0d48564a7', '5f520517-5984-4f86-8ca8-40873415cc4e', 646.35),
('5d9a4872-fd69-4099-b25b-bed04742a72d', '7fe75609-5024-47f3-969c-8788303588e2', 70.23),
('08a4004b-0b33-4bf3-9c58-96b10d3bf3ee', 'f2a6f44b-97ce-4bbd-93b5-3db04fe2154e', 815.06),
('330fb0de-4fa6-45a5-a9b6-58b9a1a10a77', 'a8328a45-1664-4899-81b3-34b395cf66bb', 1.77),
('b70f6aa8-d554-4aa6-a0a4-c5f43111947d', '3cf55ef8-ec46-4fc4-960b-ed3af1551291', 44.74),
('c6e85a3a-9dd9-4a50-9dca-baa5be256c18', '921b6e4f-eb92-41a7-96b6-62967e00d3b7', 30.00),
('fda399de-363e-4ddc-8aaa-6f4ce9a5f870', 'fac154aa-6bb4-42b5-853d-0b3da7150561', 3.50),
('7841927f-6490-4823-92be-f19f696f5a55', '454d0fc1-dedb-4c16-bbef-2e7b138c8bae', 23.62),
('5f16d70d-1b59-41ca-a06e-c903cfc4eedd', 'adb3c3ef-0a08-44ca-8891-ea14626f2488', 114.72),
('23cb302d-d353-4b52-bf93-f86f1e336235', 'f5446a16-f555-49bd-a31c-9222bab58caf', 30.00),
('aa24ab61-477e-4cd6-ad10-5548fbd927db', '72e6abd3-d7b9-447e-8f1d-95b4f423ece1', 30.55),
('f52daad4-5293-4cd3-b219-45936fd29611', '8b8f404a-957e-46c8-bdcb-754ff99cd039', 19.32),
('67197e0f-b351-4d19-883b-7ca74a3f2d5f', '0220fd67-3e00-4687-8b06-38382e9b81eb', 37.79),
('ab73ebf0-a0bd-4528-bf8c-4fd11c64a528', '1db71e7c-fe82-4e1a-bb64-2eafd1d8e74a', 30.00),
('d1d2559a-2d32-4125-969a-d0044c781cd4', 'e4db11fd-c39e-43fb-adf4-e833e2e74c95', 30.00),
('010af7b6-dcf9-4a29-a738-069214927864', 'a7383973-e4ff-4625-bab1-ea0085e4b941', 14.96),
('7af791a7-fd93-4222-b72f-9bb2bffa1d90', 'de2342f1-f4f7-41dc-9775-1c3d88db66ff', 18.81),
('5a31b73f-b4c2-4700-8783-744523a1efac', '8fccdf2f-ea32-452a-968b-21103ff02483', 30.00),
('cedffd04-f114-421f-b08e-98e92c8522ce', 'fd87e0e5-3108-4fe7-86a2-3cdd3961dc80', 30.00),
('45e1d33c-9891-4c28-b5df-7bb807586002', '301d29fe-a52a-4af7-8ce4-9b2753c2aea5', 30.00),
('42aab859-f896-4e66-972f-190cd95a0e53', '4a88d870-641c-48d6-9c9e-2a0fbfe0d9e3', 30.00),
('d116ca1b-a7ba-4c5e-98c8-bbe380f562c3', 'c43eda7f-29a9-4e79-b9f4-002321b7094e', 50.04),
('1251ecb8-55a5-4146-8a58-fd93b938c387', '18706694-640a-43b8-9db1-1afb24ef9a6f', 17.76),
('8a084d6a-b195-404e-bc7d-c55ef0c2145b', 'ee6e655d-ec2c-4cdc-844f-ef400861c7b5', 30.00),
('693bc673-1571-4107-9877-cbe07343e321', 'bf1c9cb2-d02a-49a2-a252-f75337b29bfd', 14.95),
('23ad7cc9-ed3a-4f6e-b0cb-ffc5a6bc2a45', '008c17b7-07d2-4eef-9ae7-8e36d20b4e72', 120.92),
('dc5a4b2d-389e-44a5-9316-7ed06a6f4e4d', '4c95a08b-a680-489d-b331-75c1e67c2681', 55.46),
('5650b748-cbcb-4bf2-9988-3f3e9d632f70', 'eaf77dee-e5bc-4e10-a985-6db13ed4e847', 30.00),
('00e4a873-cf0d-4678-8e2d-0d4e9a55b1ad', 'db125c45-56b5-4f98-8f98-2d680e4d2102', 39.89)


*/