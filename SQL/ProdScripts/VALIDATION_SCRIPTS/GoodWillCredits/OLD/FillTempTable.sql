--SELECT *, ROW_NUMBER() OVER (PARTITION BY transactionuuid ORDER BY SN) [Rank] FROM #TempRecords

;WITH CTE AS
(SELECT *, ROW_NUMBER() OVER (PARTITION BY transactionuuid ORDER BY SN) [Rank] FROM #TempRecords)
SELECT * FROM CTE WHERE Rank > 1

--DELETE FROM #TempRecords WHERE SN = 152

DROP TABLE IF EXISTS ##TempRecords
SELECT * INTO ##TempRecords FROm #TempRecords

DROP TABLE IF EXISTS #NotFound
; WITH CTE AS (SELECT *, ROW_NUMBER() OVER (PARTITION BY transactionlifecycleuniqueid ORDER BY POSTTIME DESC)  AS Ranking FROM ##TempData WHERE CMTTRanType = '40')
, CTE2 AS (SELECT * FROM CTE where Ranking = 1)
SELECT T1.* 
INTO #NotFound
FROM CTE2 C
RIGHT JOIN #POD1 T1 ON (T1.transactionuuid = C.transactionuuid)
WHERE  C.transactionuuid IS NULL


SELECT *  FROM #NotFound


SELECT * 
FROm ##TempData WITH (NOLOCK) 
WHERE AccountNumber = '1100011104708429' 
AND TransactionUUID = '7d39df14-d4ec-429d-a1c6-5cdc82da08f1'
--AND TransactionLifeCycleUUID = '7d39df14-d4ec-429d-a1c6-5cdc82da08f1'

SELECT * 
FROm LS_PRODDRGSDB01.ccgs_coreauth.dbo.CoreAuthTransactions WITH (NOLOCK) 
WHERE AccountNumber = '1100011104708429' 
--AND TransactionUUID = 'bb59eba9-9bb4-4c2a-bac1-e38fae6a7b08'
AND TransactionLifeCycleUUID = '7d39df14-d4ec-429d-a1c6-5cdc82da08f1'


SELECT TransactionLifeCycleUniqueID,* 
FROm Auth_Primary WITH (NOLOCK) WHERE AccountNumber = '1100011110359365' 
--AND TransactionUUID = 'bb59eba9-9bb4-4c2a-bac1-e38fae6a7b08'
--AND TransactionLifeCycleUUID = 'bb59eba9-9bb4-4c2a-bac1-e38fae6a7b08'
--AND CoreAuthTranID IN (1731327025,1729033516)
AND TransactionLifeCycleUniqueID = 36293697


SELECT TransactionAmount, TransactionLifeCycleUUID,* 
FROm CCard_Primary WITH (NOLOCK) WHERE AccountNumber = '1100011104708429' 
--AND UniversalUniqueID = '7d39df14-d4ec-429d-a1c6-5cdc82da08f1'
--AND TransactionLifeCycleUUID = 'bb59eba9-9bb4-4c2a-bac1-e38fae6a7b08'
AND TransactionLifeCycleUniqueID = 36293697
AND TranID = 704453895


DROP TABLE IF EXISTS #POD1
--DROP TABLE IF EXISTS #POD2
SELECT AccountUUID, RTRIM(AccountNumber) AccountNumber, ClientID, MergeInProcessPH, transactionuuid, Amount
INTO #POD1
FROM #TempRecords T1
LEFT JOIN BSegment_Primary B WITH (NOLOCK) ON (T1.AccountUUID = B.UniversalUniqueID)
WHERE B.UniversalUniqueID IS NOT NULL

SELECT * FROM #POD1

SELECT * FROM #POD2

SELECT *
FROM #TempRecords T1
LEFT JOIN #TempRecords_OLD T2 ON (T1.transactionuuid = T2.transactionuuid)
WHERE T2.transactionuuid IS NOT NULL

SELECT *
FROM #TempRecords T1
WHERE transactionuuid IN 
(SELECT transactionuuid FROM #TempRecords_OLD)

--DELETE FROM #TempRecords WHERE transactionuuid IN (SELECT transactionuuid FROM #TempRecords_OLD)


DROP TABLE IF EXISTS #TempRecords
CREATE TABLE #TempRecords (SN INT IDENTITY(1, 1), AccountUUID VARCHAR(64), ClientID VARCHAR(64), transactionuuid VARCHAR(64), Amount MONEY)

INSERT INTO #TempRecords VALUES ('886ffe43-1015-43d5-8b61-6bbe8489633a', '598f6d63-d0b0-4bfd-b28f-3a44d51a615f', '16fa4d08-8744-41b1-a207-adef597700de', 50.00)
INSERT INTO #TempRecords VALUES ('bd2c0ea3-d07a-4cca-89e3-d1a0f9811b91', '1811a8c0-8d02-4e04-b26a-d7048ffd6f95', 'b795b71e-93ed-4ebc-b8dd-ba778f569106', 640.93)
INSERT INTO #TempRecords VALUES ('2241e522-a020-4a2b-820e-c1cc8a719e50', '6c6e866b-79bd-4baf-8f7e-e8704dadce7a', '25a4e877-2e72-4093-941b-d5abe8625246', 95.72)
INSERT INTO #TempRecords VALUES ('5c786e68-6b4e-4f0c-89b9-4f5f7063d9aa', '7caf038e-f6fc-4daf-b6b8-5d7e288bdb10', 'eda3e8f6-8782-43b3-8214-77fa8426dfdf', 89.24)
INSERT INTO #TempRecords VALUES ('5a41697e-5b87-4d44-9a0a-48ca0aafed10', 'd2e84d94-581c-482e-92ea-cdadbf1d60b6', '43cc3d4a-adcd-4f64-a604-4cc10d068281', 119.99)
INSERT INTO #TempRecords VALUES ('51d7c6f3-b9ce-47f9-a5cf-29fa82ee099b', '26a32a27-c323-4736-8d7b-5774757d8f9c', '0af7cd75-1191-4e79-8acd-60e46c35f983', 87.28)
INSERT INTO #TempRecords VALUES ('bbdfebe6-a658-40aa-87f9-a8277f05a165', '4db7ab34-658f-4ca8-8549-ba2887a5bf2a', '6e3b845f-cab5-42b3-92d9-4e88de20acc4', 58.59)
INSERT INTO #TempRecords VALUES ('aeb93cff-a846-403d-8fda-0c3b7426780e', 'a0b02d92-64d5-417c-b70a-640f56736be6', 'b69ae773-55b6-4b89-90e9-b1969bf776d9', 56.56)
INSERT INTO #TempRecords VALUES ('483e696b-104f-4b47-a0a4-c7ab49a28073', '5518a8dd-dd11-45bb-be02-30925c553638', '966798ab-0d44-4c54-bf73-94939a3cc468', 461.98)
INSERT INTO #TempRecords VALUES ('1b089622-66a1-48b2-8ee2-d77e7ebc6fd3', 'bb0b4761-5906-4f99-9110-b770ee23122f', 'a6df42e7-9c05-4fe3-9921-10f60e898bfe', 152.09)
INSERT INTO #TempRecords VALUES ('bd34d2d0-fbf9-4f43-a158-220aa95f7236', '3476e31d-003b-4c19-b147-63b1c4ea911d', '93583cf5-c881-4b96-98ca-08cdfa40c9c4', 95.24)
INSERT INTO #TempRecords VALUES ('b51aa753-6b97-4871-a57d-33bd8bee7eca', '6b0ed3bc-cb7d-4c97-add1-4ef1053e9869', '7283029c-166d-4087-a45d-63569549c390', 124.00)
INSERT INTO #TempRecords VALUES ('bf19cb65-017c-4672-ad14-8ffe7549f8f6', '6c67e648-1377-4337-8a00-2ee15b875853', 'a6b8e914-4cce-4ec6-b780-a988709f2a0d', 281.00)
INSERT INTO #TempRecords VALUES ('6ba5c7c4-f995-42ef-83d8-f23badc3d5cb', '04a75907-81f4-4965-b872-1852e4f46fcc', '015378b0-7213-480c-8ca7-78fb912e001c', 433.99)
INSERT INTO #TempRecords VALUES ('b061f86e-3510-4fc2-bb69-565b80d7a3a0', '4d746551-0512-406f-980b-ecba6567ac17', '28451623-7458-48cc-83fa-92d6a999710c', 25.95)
INSERT INTO #TempRecords VALUES ('4f9b0576-d874-4576-9e80-5061093fb683', '93326c71-4162-4ae9-8a01-c221ed02ab2a', 'f1a8e2e5-05b1-4b4b-99eb-64f8575e5920', 149.00)
INSERT INTO #TempRecords VALUES ('e0df2d6d-050b-4238-966e-67835b8ad76c', 'c1eae91e-4b73-4b6f-a7bb-0f96356271f9', 'ad85c4a3-82bc-4de6-9e07-3badabae16ef', 383.35)
INSERT INTO #TempRecords VALUES ('2a5759ce-55fc-40ae-b815-884440d888d7', '67e0470f-9520-46eb-86a3-534129fb3d8f', '359291e0-2f27-4929-801f-3bcbfda49f7d', 325.00)
INSERT INTO #TempRecords VALUES ('aa6774df-7b80-44b2-8ff9-64a0f5f78076', '4156035f-8c2b-4e1a-89ce-9033b65fed1f', 'c72503d5-76f8-4ae1-86e8-9f012b3b378f', 269.00)
INSERT INTO #TempRecords VALUES ('986e914f-d241-4207-b9d9-0eb48be47491', '93bddbce-eabb-4e8e-94a2-10801b3e7e47', '5304d30f-4985-4959-a86a-e324bf2f541d', 243.50)
INSERT INTO #TempRecords VALUES ('d0ef25b4-58d3-4b2d-9f8c-1f7dfdf30462', '014ebfeb-4096-4304-9fa1-2318dabe5861', '9b10186f-3aab-4bef-8a48-f43be2e45bfb', 89.00)
INSERT INTO #TempRecords VALUES ('2980eba4-e239-42d7-884d-f48ec96489aa', '38bc7c09-a06f-4c9c-9e6e-cedba54d202d', '6e50ce9e-a744-4f5b-8c9e-d9f0b59fece6', 200.00)
INSERT INTO #TempRecords VALUES ('670ae471-d6ac-4fa3-9b0c-7c0b7630166e', 'e0026668-acf5-4906-b9ed-d82bb75f884f', '53786cb8-27b1-4631-a3ad-94035a96ce49', 50.00)
INSERT INTO #TempRecords VALUES ('ee3075ec-452b-440b-a669-7db201104643', '2768266b-f56e-4a07-9005-e1c1a0735f58', '25871cc2-18e8-4974-8fc0-75c2ec3a8a48', 202.00)
INSERT INTO #TempRecords VALUES ('ea616249-406f-4119-9bc8-bbe64c834957', '14d87e2e-fbed-42de-a66f-219f232e5a15', '80aab062-ea7a-40c6-a50d-621433ebf9cc', 141.38)
INSERT INTO #TempRecords VALUES ('590b1c89-821e-4aeb-8d4b-f48ab950143e', '40581923-b6fa-441b-a260-d8a5f0f73a05', '3c10b493-de97-4695-9043-2a1852bed880', 154.35)
INSERT INTO #TempRecords VALUES ('c78b3e88-3f0b-4f0b-a8d8-e5dd9cbbb3c6', 'e7a6cf56-3697-4495-941d-36bff1023095', '1ad37693-c843-4a6e-89d6-7ea01b638e45', 109.95)
INSERT INTO #TempRecords VALUES ('daafa886-69b2-45cf-bc0f-9a68411c99dc', '8108d66b-a74c-45b6-a1e4-828b8fd8ebc8', 'e0c30163-21a0-4e33-8548-915175c82698', 145.93)
INSERT INTO #TempRecords VALUES ('5b329435-dfbf-4821-aa7d-2bf92b8b10a1', '7d24d1f8-582b-4850-be73-fa7206dcb4b1', '6195d0c5-0daf-4d2a-9cb4-487eb2f81649', 200.00)
INSERT INTO #TempRecords VALUES ('4e15ab31-a00d-4c06-adf0-5d45f3578a8b', '954982e6-9107-4e22-8714-50a8d0136cfe', '3fdb1abe-7354-4dde-816f-8cd565ac9548', 974.00)
INSERT INTO #TempRecords VALUES ('eea78cba-3ec8-41ef-a736-e6a8b4c7d43a', '091dbc41-aa57-40b5-9857-53604ba568cf', 'fa2cc872-41e2-4ba7-b914-4af6cb96143f', 100.00)