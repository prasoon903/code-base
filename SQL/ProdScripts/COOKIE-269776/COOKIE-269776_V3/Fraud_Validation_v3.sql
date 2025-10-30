SELECT COUNT(1) FROM #TempData
SELECT COUNT(1) FROM #TempRecords

SELECT * INTO ##TempData FROM #TempData

DROP TABLE IF EXISTS #TempRecords
SELECT T1.*, B.acctID, RTRIM(AccountNumber) AccountNumber, CycleDueDTD, SystemStatus, ChargeOffDateParam, ChargeOffDate, 
ccinhparent125AID, ManualInitialChargeOffReason, 
TRY_CAST(NULL AS INT) FirstStatus, TRY_CAST(NULL AS DATETIME) StatusFirstApplied, TRY_CAST(NULL AS DATETIME) ExpectedCODate, TRY_CAST(NULL AS VARCHAR(100)) Reason
INTO #TempRecords
FROM #TempData T1
JOIN BSegment_Primary B WITH (NOLOCK) ON (T1.AccountUUID = B.UniversalUniqueID)
JOIN BSegmentCreditCard c WITH (NOLOCK) ON (B.acctID = C.acctID)

;WITH CTE
AS
(
SELECT T.*, C.OldValue, C.NewValue 
FROM #TempRecords T
LEFT JOIN CurrentBalanceAudit C WITH (NOLOCK) ON (T.acctID = C.AID AND T.ChargeOffDate = C.BusinessDAy AND C.DENAME = 115)
WHERE Reason IS NULL
)
UPDATE T
SET Reason = 'CO contractually as this date fall prior to status'
FROM CTE C 
JOIN #TempRecords T ON (C.SN = T.SN)
WHERE C.NewValue IN ('7', '8')

SELECT * FROM #TempRecords WHERE Reason IS NULL

DROP TABLE IF EXISTS #TempCCard
SELECT CP.AccountNumber, T.acctID, ChargeOffDate, PostTime, CMTTRanType, TransactionAmount, TransactionDescription, TranID, TranRef, TxnSource, CP.Transactionidentifier,FeesAcctID StatusBefore, CPMGroup StatusAfter--,
--ROW_NUMBER() OVER(PARTITION BY CP.AccountNumber ORDER BY PostTime) TxnCount
INTO #TempCCard
FROM LS_P1MARPRODDB01.CCGS_CoreIssue.DBO.CCard_Primary CP WITH (NOLOCK)
JOIN #TempRecords T ON (T.AccountNumber = CP.AccountNumber)
WHERE CMTTranType IN ('RCLS', '51', '54', '*SCR')
AND T.Reason IS NULL

DROP TABLE IF EXISTS #COStatus
SELECT acctID, COReasonCode, AfterNumberOfCycles, StatusDescription INTO #COStatus FROM AStatusAccounts WITH (NOLOCK) WHERE COReasonCode IS NOT NULL AND parent01AID = 1

SELECT * FROM #COStatus

DROP TABLE IF EXISTS #TempSCR
SELECT *, TRY_CAST(0 AS INT) MaxCount, ROW_NUMBER() OVER(PARTITION BY AccountNumber ORDER BY PostTime, TranID) SCRCount INTO #TempSCR FROM #TempCCard WHERE CMTTRanType = '*SCR' AND PostTime <= ChargeOffDate

DROP TABLE IF EXISTS #NonCO
;WITH CTE
AS
(
SELECT * FROM #TempSCR WHERE StatusAfter NOT IN (SELECT acctID FROM #COStatus)-- AND AccountNumber = '1100011137024943' 
)
SELECT AccountNumber, MAX(SCRCount) SCRCount
INTO #NonCO 
FROM CTE GROUP BY AccountNumber

SELECT * FROM #NonCO WHERE AccountNumber = '1100011137024943'
SELECT * FROM #TempSCR WHERE AccountNumber = '1100011137024943'

UPDATE T1
SET MaxCount = ISNULL(T2.SCRCount, 0)
FROM #TempSCR T1
LEFT JOIN #NonCO T2 ON (T1.AccountNumber = T2.AccountNumber)

SELECT *
FROM #TempSCR T1
LEFT JOIN #NonCO T2 ON (T1.AccountNumber = T2.AccountNumber)
WHERE T1.AccountNumber = '1100011137024943'

DROP TABLE IF EXISTS #TempCOSCR
SELECT RTRIM(T1.AccountNumber) AccountNumber,acctID,ChargeOffDate,PostTime,CMTTRanType, TransactionAmount,TranID,TranRef,TxnSource, Transactionidentifier, StatusBefore, StatusAfter ,
ROW_NUMBER() OVER(PARTITION BY T1.AccountNumber ORDER BY PostTime, TranID) SCRCount
INTO #TempCOSCR
FROM #TempSCR T1
WHERE T1.SCRCount > MaxCount



SELECT RTRIM(T1.AccountNumber) AccountNumber,acctID,ChargeOffDate,PostTime,CMTTRanType, TransactionAmount,TranID,TranRef,TxnSource, Transactionidentifier, StatusBefore, StatusAfter ,T1.SCRCount, MaxCount,
ROW_NUMBER() OVER(PARTITION BY T1.AccountNumber ORDER BY PostTime, TranID) SCRCount
FROM #TempSCR T1
WHERE T1.SCRCount > MaxCount
AND T1.AccountNumber = '1100011137024943'


SELECT * FROM #TempCOSCR WHERE AccountNumber = '1100011184901274' ORDER BY SCRCount


SELECT * FROM #COStatus

;WITH CTE
AS
(
SELECT T1.*, DATEADD(SS, 86395, TRY_CAST(TRY_CAST(EOMONTH(DATEADD(MM, AfterNumberOfCycles-1, PostTime)) AS DATE) AS DATETIME)) ExpectedCODate 
FROM #TempCOSCR T1
LEFT JOIN #COStatus T2 ON (T1.StatusAfter = T2.acctID)
WHERE SCRCount = 1
)
UPDATE T1
SET Reason = 'CO as per the status present at that time',
StatusFirstApplied = C.PostTime, FirstStatus = StatusAfter, ExpectedCODate = C.ExpectedCODate
FROM #TempRecords T1
JOIN CTE C ON (T1.AccountNumber = C.AccountNumber)
WHERE T1.ChargeOffDate = C.ExpectedCODate
AND T1.Reason IS NULL

--;WITH CTE
--AS
--(
--SELECT *, DATEADD(SS, 86395, TRY_CAST(TRY_CAST(EOMONTH(DATEADD(MM, 1, PostTime)) AS DATE) AS DATETIME)) ExpectedCODate 
--FROM #TempCOSCR 
--WHERE SCRCount > 1
--)
----SELECT *
--UPDATE T1
--SET Reason = 'Same group status applied prior to COOKIE-223800',
--StatusFirstApplied = C.PostTime, FirstStatus = StatusAfter, ExpectedCODate = C.ExpectedCODate
--FROM #TempRecords T1
--JOIN CTE C ON (T1.AccountNumber = C.AccountNumber)
--WHERE T1.ChargeOffDate = C.ExpectedCODate
--AND T1.Reason IS NULL

UPDATE #TempRecords SET Reason = 'CO as per the status present at that time but multiple add/remove performed' WHERE SN IN (273, 77, 301)
UPDATE #TempRecords SET Reason = 'Mid cycle CO COOKIE-250239' WHERE SN IN (405)

--UPDATE #TempRecords SET Reason = 'Account is in CAP' WHERE SN = 4372
--UPDATE #TempRecords SET Reason = 'Issue due to multiple status add/remove CARDS-85112' WHERE SN IN (2864, 2865)

SELECT * FROM CurrentBalanceAudit WITH (NOLOCK) WHERE AID = 4877966 AND DENAME IN (114, 115, 112) ORDER BY IdentityField DESC

SELECT * FROM #TempSCR WHERE AccountNumber = '1100011137024943' ORDER BY SCRCount
SELECT * FROM #NonCO WHERE AccountNumber = '1100011137024943' ORDER BY SCRCount
SELECT * FROM #TempCOSCR WHERE AccountNumber = '1100011137024943' ORDER BY SCRCount
SELECT * FROM #TempCCard WHERE AccountNumber = '1100011137024943' ORDER BY PostTime DESC

SELECT * FROM BSegment_Mstatuses WITH (NOLOCK) WHERE AcctID = 504283 ORDer BY Skey DESC

SELECT * FROM CustomerStatusQueue WITH (NOLOCK) WHERE AcctID = 504283 ORDer BY Skey DESC
SELECT * FROM Customer WITH (NOLOCK) WHERE BSAcctID = 504283 

SELECT 'MergeAccountJob===> ' [Table], * FROM MergeAccountJob WITH (NOLOCK) WHERE destBSAcctId = 504283 OR SrcBSAcctId = 504283

SELECT * FROM Trans_In_Acct WITH (NOLOCK) WHERE Tran_ID_Index = 84974300702


SELECT * FROM #TempRecords WHERE Reason IS NULL

SELECT AccountUUID,acctID,AccountNumber,CycleDueDTD,SystemStatus,ChargeOffDate,ccinhparent125AID,FirstStatus,StatusFirstApplied,ExpectedCODate,Reason 
FROM #TempRecords


DROP TABLE IF EXISTS #TempData
CREATE TABLE #TempData(SN DECIMAL(19, 0) IDENTITY(1, 1), AccountUUID VARCHAR(64))

INSERT INTO #TempData (AccountUUID) VALUES ('c6ca87ee-b87e-4391-90d5-d26bcaed4cf4' )
INSERT INTO #TempData (AccountUUID) VALUES ('60c3d009-5b27-41a2-abbb-f5b9353a49b1' )
INSERT INTO #TempData (AccountUUID) VALUES ('d77b133f-5dd5-4e37-880d-5d16fcc65929' )
INSERT INTO #TempData (AccountUUID) VALUES ('59129f31-fe11-44c6-93a5-e602947d2834' )
INSERT INTO #TempData (AccountUUID) VALUES ('74d4b834-8562-4d32-b4ae-efbaf83c0449' )
INSERT INTO #TempData (AccountUUID) VALUES ('c27f2963-3a49-4bd8-9b30-aa98fb01f14e' )
INSERT INTO #TempData (AccountUUID) VALUES ('77795b8d-c59c-4ec7-8c7a-3647ad60ebec' )
INSERT INTO #TempData (AccountUUID) VALUES ('63ebe4da-2ecc-466e-adb4-1ed837176e95' )
INSERT INTO #TempData (AccountUUID) VALUES ('a4db7d30-65ab-46e2-9a5a-8bca46e13c4e' )
INSERT INTO #TempData (AccountUUID) VALUES ('fbbc7082-2827-4ee1-af4c-fdfacbc6a44e' )
INSERT INTO #TempData (AccountUUID) VALUES ('8049e301-28bc-4571-85fa-9e93c4753cc0' )
INSERT INTO #TempData (AccountUUID) VALUES ('8bc2d372-caad-4969-9fff-a23f91ac1f72' )
INSERT INTO #TempData (AccountUUID) VALUES ('65e95559-3dcb-4dae-8eff-448b93600816' )
INSERT INTO #TempData (AccountUUID) VALUES ('d9f3b913-bd5b-466f-b25c-57829ce1821a' )
INSERT INTO #TempData (AccountUUID) VALUES ('8774b275-c152-4656-b2d3-9e1f6a8a5994' )
INSERT INTO #TempData (AccountUUID) VALUES ('8a407c92-faf8-42a3-8a8d-3e31dc59e27d' )
INSERT INTO #TempData (AccountUUID) VALUES ('59842408-bac7-482c-be56-4438d63d56d2' )
INSERT INTO #TempData (AccountUUID) VALUES ('84380cd1-b28f-478b-a97c-629bcf2b1add' )
INSERT INTO #TempData (AccountUUID) VALUES ('a7d2d0b3-9520-4f81-a329-1d028c5371e8' )
INSERT INTO #TempData (AccountUUID) VALUES ('3bdd8543-27d0-41c0-b4e4-676bc2c91b69' )
INSERT INTO #TempData (AccountUUID) VALUES ('3054b3ac-3e6c-4dae-884e-460be68e9ff6' )
INSERT INTO #TempData (AccountUUID) VALUES ('9711cf73-0467-42b7-b2cd-3d24e001847b' )
INSERT INTO #TempData (AccountUUID) VALUES ('b2c15f8f-7161-4aac-83da-8b98e5037c86' )
INSERT INTO #TempData (AccountUUID) VALUES ('376ad5ec-47c7-4118-a840-6a7ea1d43963' )
INSERT INTO #TempData (AccountUUID) VALUES ('17b7d9b7-6354-4715-96f3-b1356beb2876' )
INSERT INTO #TempData (AccountUUID) VALUES ('a04ba078-9f45-4fe5-9c85-4d29b369f7aa' )
INSERT INTO #TempData (AccountUUID) VALUES ('191127ae-6462-492a-a983-e8401415d470' )
INSERT INTO #TempData (AccountUUID) VALUES ('5730a0b6-0f52-421f-ab8f-11936721a038' )
INSERT INTO #TempData (AccountUUID) VALUES ('234edcc2-002e-4bdd-ae9f-0deed5440a0e' )
INSERT INTO #TempData (AccountUUID) VALUES ('83fed0a7-7c38-44ea-b6fb-030aaf880c4e' )
INSERT INTO #TempData (AccountUUID) VALUES ('4051acd8-2f02-4e33-a126-fc6cff25a53e' )
INSERT INTO #TempData (AccountUUID) VALUES ('0cc48dd2-cea1-4713-ac16-ef3f588f3d4b' )
INSERT INTO #TempData (AccountUUID) VALUES ('452d08ca-da08-4ebf-8b43-c16424b57390' )
INSERT INTO #TempData (AccountUUID) VALUES ('4ce5a0f1-e655-4876-b9d7-1f08501a5183' )
INSERT INTO #TempData (AccountUUID) VALUES ('88d66ef7-ac32-4e90-a6cd-8a2e8097df4c' )
INSERT INTO #TempData (AccountUUID) VALUES ('1e4e69a7-48f1-40c2-8fc5-84ce4e4e51c6' )
INSERT INTO #TempData (AccountUUID) VALUES ('d84ae222-3e79-4fa5-8e04-6977037ae225' )
INSERT INTO #TempData (AccountUUID) VALUES ('a2f52e48-83dd-4378-8d16-2c205487baec' )
INSERT INTO #TempData (AccountUUID) VALUES ('43a9b9af-63d7-4495-80db-1b87d679bf13' )
INSERT INTO #TempData (AccountUUID) VALUES ('6e834b48-73f2-45aa-a73e-1287a5889486' )
INSERT INTO #TempData (AccountUUID) VALUES ('c939de7f-6aa4-405b-a5dc-a464289a0ec9' )
INSERT INTO #TempData (AccountUUID) VALUES ('8dda14cf-0af8-463a-b0ef-fde3bf2127d6' )
INSERT INTO #TempData (AccountUUID) VALUES ('c781fc56-b085-4c75-b1ff-1f59e6bf6af5' )
INSERT INTO #TempData (AccountUUID) VALUES ('5f8fd5d8-441a-4269-9fd3-426543e2f86f' )
INSERT INTO #TempData (AccountUUID) VALUES ('cc37292a-aab0-44ce-abf4-97fc05e882fd' )
INSERT INTO #TempData (AccountUUID) VALUES ('25c0d184-a7db-4a7a-b65d-77ce7e47022a' )
INSERT INTO #TempData (AccountUUID) VALUES ('1a03c06a-29af-4f46-b0fe-fc3a17e0b262' )
INSERT INTO #TempData (AccountUUID) VALUES ('14d10c36-f23d-4a6c-9f31-f4606c953cf0' )
INSERT INTO #TempData (AccountUUID) VALUES ('894e9d06-726b-4ac0-9622-96699d60408c' )
INSERT INTO #TempData (AccountUUID) VALUES ('a474f055-00bb-4601-8d18-0ead3ed22ad6' )
INSERT INTO #TempData (AccountUUID) VALUES ('5c1f4739-8e74-42ef-9a1c-266dfaea8a37' )
INSERT INTO #TempData (AccountUUID) VALUES ('a5fcb533-c355-41f5-9426-db32c77df1d1' )
INSERT INTO #TempData (AccountUUID) VALUES ('10551c5f-e1bb-42ce-80ce-975030206e8c' )
INSERT INTO #TempData (AccountUUID) VALUES ('3d305090-4c4f-44a8-b5db-dd34a8929f16' )
INSERT INTO #TempData (AccountUUID) VALUES ('d349676b-5436-482f-b33b-3d7f86a8ba60' )
INSERT INTO #TempData (AccountUUID) VALUES ('e53cebde-a264-4204-8e70-a801bbf98185' )
INSERT INTO #TempData (AccountUUID) VALUES ('434031e8-86f9-4428-95ec-2306857d89d8' )
INSERT INTO #TempData (AccountUUID) VALUES ('65f0f5ef-dbf9-4f24-8f88-26979c598876' )
INSERT INTO #TempData (AccountUUID) VALUES ('36a790f0-1103-4fa3-ba71-f551ca503da6' )
INSERT INTO #TempData (AccountUUID) VALUES ('b66bd929-5579-48c3-abeb-bff7bc1aae5e' )
INSERT INTO #TempData (AccountUUID) VALUES ('92346e15-4545-4637-98a4-f940bbdde07a' )
INSERT INTO #TempData (AccountUUID) VALUES ('a3061aa3-9d8f-461e-b662-9850358aef05' )
INSERT INTO #TempData (AccountUUID) VALUES ('015261c9-5be6-4f86-9fc9-1cfb7f7e5246' )
INSERT INTO #TempData (AccountUUID) VALUES ('c93e570c-f9b0-4642-a5e6-d79a4185581f' )
INSERT INTO #TempData (AccountUUID) VALUES ('ca125775-3a99-40ed-9956-8f1070552887' )
INSERT INTO #TempData (AccountUUID) VALUES ('288b00d8-f4f1-47f3-b2dc-365bdbf961ce' )
INSERT INTO #TempData (AccountUUID) VALUES ('6b7f6458-0986-49e0-9aed-95bbea45005d' )
INSERT INTO #TempData (AccountUUID) VALUES ('22fcf3a9-56b6-4dc9-8307-8b19a92f0c0a' )
INSERT INTO #TempData (AccountUUID) VALUES ('51142f9f-5bb2-4671-a7d5-476a34656bfa' )
INSERT INTO #TempData (AccountUUID) VALUES ('518b00c1-e550-4b0a-8438-fe938de4596f' )
INSERT INTO #TempData (AccountUUID) VALUES ('711ed9f0-4fb5-4e30-b55e-a6f27215dfdc' )
INSERT INTO #TempData (AccountUUID) VALUES ('1c4b4f59-5f12-4ccd-9594-b75a7b8c9fc9' )
INSERT INTO #TempData (AccountUUID) VALUES ('ecf5bc94-d3bd-4e03-9cb1-02976450539b' )
INSERT INTO #TempData (AccountUUID) VALUES ('9f62373b-39fd-446d-a2f3-fc3965285fc1' )
INSERT INTO #TempData (AccountUUID) VALUES ('7ad97860-a5b6-40e9-b988-7e3186c8550e' )
INSERT INTO #TempData (AccountUUID) VALUES ('29f3df30-5416-444f-ad43-d4d3ff1692c7' )
INSERT INTO #TempData (AccountUUID) VALUES ('1c290145-c654-48cc-937a-3420ff27956e' )
INSERT INTO #TempData (AccountUUID) VALUES ('83b10976-722c-4ca3-b1e7-aeccbb99968c' )
INSERT INTO #TempData (AccountUUID) VALUES ('353fee98-00a6-40fc-bb5a-243706f1909a' )
INSERT INTO #TempData (AccountUUID) VALUES ('67bcc656-b9fe-45d5-8649-52749c01ef0d' )
INSERT INTO #TempData (AccountUUID) VALUES ('28d8bd55-2ced-4f52-9318-13559df3c13f' )
INSERT INTO #TempData (AccountUUID) VALUES ('7628a4f0-b0ac-42b6-9055-9034628e7473' )
INSERT INTO #TempData (AccountUUID) VALUES ('2195fcd3-963f-44f2-8486-a8ccba8cb0da' )
INSERT INTO #TempData (AccountUUID) VALUES ('8bacbe7a-cebc-468b-9789-0ad8620e396e' )
INSERT INTO #TempData (AccountUUID) VALUES ('ffca7765-58fd-42a3-b3c6-ba4981d2eb47' )
INSERT INTO #TempData (AccountUUID) VALUES ('3b8fbb70-6605-4d80-b565-2477eed53e8d' )
INSERT INTO #TempData (AccountUUID) VALUES ('a3697eb8-566c-40a6-a735-07cf0644be47' )
INSERT INTO #TempData (AccountUUID) VALUES ('7cfe7312-940e-4e91-aa70-8045f951983d' )
INSERT INTO #TempData (AccountUUID) VALUES ('b2de8faf-8ec1-44ac-9137-6b231a6aaf66' )
INSERT INTO #TempData (AccountUUID) VALUES ('bfbefc36-0dda-4e3e-a265-15619d484762' )
INSERT INTO #TempData (AccountUUID) VALUES ('90faf28a-62a5-4fda-a0ac-1fcfec3e48c7' )
INSERT INTO #TempData (AccountUUID) VALUES ('8d0de6cc-7cfe-4dd4-962e-927409bd9f5c' )
INSERT INTO #TempData (AccountUUID) VALUES ('2d2cf92c-b4a6-462b-94a5-ba2a061e8c02' )
INSERT INTO #TempData (AccountUUID) VALUES ('a54e599c-2762-4fa5-8e41-23fd034ff883' )
INSERT INTO #TempData (AccountUUID) VALUES ('3065a184-174f-4782-b19e-2858fe9d18b0' )
INSERT INTO #TempData (AccountUUID) VALUES ('42181d70-b943-4414-9bc7-c70ccc24b2a1' )
INSERT INTO #TempData (AccountUUID) VALUES ('5d476dd7-d712-4271-bc01-bee213a417eb' )
INSERT INTO #TempData (AccountUUID) VALUES ('9174ab1f-2b96-4408-aa91-82d5c7849d17' )
INSERT INTO #TempData (AccountUUID) VALUES ('5df7cd04-562e-4529-a0de-4fab4ddaeff6' )
INSERT INTO #TempData (AccountUUID) VALUES ('d83f05b0-0252-47de-8089-15ee971368e3' )
INSERT INTO #TempData (AccountUUID) VALUES ('4ea0644d-1533-48d3-add4-c75f13b71146' )
INSERT INTO #TempData (AccountUUID) VALUES ('fba6a626-107b-4ec5-9fa6-078021831923' )
INSERT INTO #TempData (AccountUUID) VALUES ('985c98db-7683-45a8-8eee-a0f74d271304' )
INSERT INTO #TempData (AccountUUID) VALUES ('a43c7bd2-910f-4f1e-b69f-c3c381e3d1f6' )
INSERT INTO #TempData (AccountUUID) VALUES ('dbfc2ad7-fb1b-4dd1-bf04-3afec5e521a1' )
INSERT INTO #TempData (AccountUUID) VALUES ('d6032cb5-ea9e-460c-9616-f2c457587149' )
INSERT INTO #TempData (AccountUUID) VALUES ('1c1a20a0-e90a-4bda-be10-0d0f897e77de' )
INSERT INTO #TempData (AccountUUID) VALUES ('a7753dc6-b355-4963-9629-320626ead037' )
INSERT INTO #TempData (AccountUUID) VALUES ('2bba99b1-ae7b-43a5-bccb-919ba15a51c5' )
INSERT INTO #TempData (AccountUUID) VALUES ('bf74864a-5fce-4ad4-b321-68ffc5ec71d0' )
INSERT INTO #TempData (AccountUUID) VALUES ('3b3c099b-9255-42d9-a1e7-0ffd9f5a28f2' )
INSERT INTO #TempData (AccountUUID) VALUES ('e68a20fc-b360-4d53-9e3c-ac3f8eaf9256' )
INSERT INTO #TempData (AccountUUID) VALUES ('77ffc460-43be-4d83-8923-d2ab92511480' )
INSERT INTO #TempData (AccountUUID) VALUES ('9a0c1cd2-47f3-40ff-a092-8f106286ffc4' )
INSERT INTO #TempData (AccountUUID) VALUES ('a978ffb0-cb6c-4c50-ae3a-7a24e4fd895e' )
INSERT INTO #TempData (AccountUUID) VALUES ('2e62444f-6ce8-4b78-b540-7ef6ee9a8bff' )
INSERT INTO #TempData (AccountUUID) VALUES ('fe2c505a-d492-42ff-a0c4-f662a4bc4103' )
INSERT INTO #TempData (AccountUUID) VALUES ('4becbe54-a255-438c-9a01-1f2766bcd0f2' )
INSERT INTO #TempData (AccountUUID) VALUES ('f8a29d3e-6af3-46e9-b429-34ef717a24aa' )
INSERT INTO #TempData (AccountUUID) VALUES ('d4c26cd1-0028-4959-83a6-9a1b42dc6ecf' )
INSERT INTO #TempData (AccountUUID) VALUES ('ce1cc810-8248-4bf7-b56f-b5bf7a3cf065' )
INSERT INTO #TempData (AccountUUID) VALUES ('745a8300-69d1-47bf-b94a-5c507ec897c0' )
INSERT INTO #TempData (AccountUUID) VALUES ('1ce75a7d-a0cf-4dbe-8702-f4c05a8d730d' )
INSERT INTO #TempData (AccountUUID) VALUES ('eee20a23-b778-4f33-bcd9-02f8261c08cb' )
INSERT INTO #TempData (AccountUUID) VALUES ('ce610ec5-17ad-405a-bf48-8711ae323384' )
INSERT INTO #TempData (AccountUUID) VALUES ('8c11d3f0-3626-448c-97bd-8ee2db8c04e3' )
INSERT INTO #TempData (AccountUUID) VALUES ('3694606e-e23e-4fc5-bb8d-f34c5917cab8' )
INSERT INTO #TempData (AccountUUID) VALUES ('3502f28a-33c9-4e25-b0d7-adef0f63411f' )
INSERT INTO #TempData (AccountUUID) VALUES ('18b6045f-6b31-4c40-a5e8-f4fe07dde164' )
INSERT INTO #TempData (AccountUUID) VALUES ('79c4f014-8b23-4ef4-973b-6c8aa8187c68' )
INSERT INTO #TempData (AccountUUID) VALUES ('d9286670-c4c1-46f5-b337-7e535eb05417' )
INSERT INTO #TempData (AccountUUID) VALUES ('465b1e79-798f-4a92-bfa2-a1308254493a' )
INSERT INTO #TempData (AccountUUID) VALUES ('833a1571-ec05-4387-8fa7-074d97e07ea6' )
INSERT INTO #TempData (AccountUUID) VALUES ('c0e3ede3-b203-4f3d-9eda-c277bb975946' )
INSERT INTO #TempData (AccountUUID) VALUES ('fbafd080-1c4d-4524-af52-81ddaf5c228d' )
INSERT INTO #TempData (AccountUUID) VALUES ('6cbfdfd7-6c79-4545-893b-13687d147fc5' )
INSERT INTO #TempData (AccountUUID) VALUES ('30162eb3-c664-48c8-8f78-2028737027d1' )
INSERT INTO #TempData (AccountUUID) VALUES ('1aa926e0-0e0a-4083-9343-1d11c22b1cc1' )
INSERT INTO #TempData (AccountUUID) VALUES ('d408422a-eae1-456b-a6d3-3641773829ed' )
INSERT INTO #TempData (AccountUUID) VALUES ('7a016de7-9aaa-467e-bb53-1c001798f61d' )
INSERT INTO #TempData (AccountUUID) VALUES ('3ac4ed92-1623-4215-9e5b-ab10f5b79043' )
INSERT INTO #TempData (AccountUUID) VALUES ('aabfcf60-868b-4e47-bc24-9d4a94daad6f' )
INSERT INTO #TempData (AccountUUID) VALUES ('5a35637f-d01f-40a3-be0c-15001c3ede8d' )
INSERT INTO #TempData (AccountUUID) VALUES ('8c15a82c-cb81-4726-9e2b-2e0ee98abb8b' )
INSERT INTO #TempData (AccountUUID) VALUES ('f6065922-543a-42b1-9c1c-45768841def1' )
INSERT INTO #TempData (AccountUUID) VALUES ('70945573-1697-4d95-8fbc-8476891c31a3' )
INSERT INTO #TempData (AccountUUID) VALUES ('4d477b27-3421-4a3d-8258-331bada917e6' )
INSERT INTO #TempData (AccountUUID) VALUES ('ec30e848-f099-49d0-a5e5-ab76aae0c3f2' )
INSERT INTO #TempData (AccountUUID) VALUES ('72a8945f-2afe-40d8-9640-a73f372f0b3c' )
INSERT INTO #TempData (AccountUUID) VALUES ('6842c607-b21a-4552-975f-3daeb2762cfe' )
INSERT INTO #TempData (AccountUUID) VALUES ('f7e20c26-8ba5-4f6a-8338-2c99e9fe1317' )
INSERT INTO #TempData (AccountUUID) VALUES ('5de1f96b-e096-49a4-89f6-c2d0d0840449' )
INSERT INTO #TempData (AccountUUID) VALUES ('bdcf81a9-f1cd-4e29-85e1-710d02b92ca5' )
INSERT INTO #TempData (AccountUUID) VALUES ('fae3340a-f374-4027-9740-5e8774143bfd' )
INSERT INTO #TempData (AccountUUID) VALUES ('1f75a568-c9da-4f3c-93d7-67dd4c0ed123' )
INSERT INTO #TempData (AccountUUID) VALUES ('0f8b0c86-23ec-439c-b235-0c5b3fc8881b' )
INSERT INTO #TempData (AccountUUID) VALUES ('a4e7d257-d1f2-42a3-8f63-4ad5f0cbfb1e' )
INSERT INTO #TempData (AccountUUID) VALUES ('04fc87c0-4f43-4d9f-9b86-ab1af98d7328' )
INSERT INTO #TempData (AccountUUID) VALUES ('cb46dd7f-3ee4-4132-bb37-e444c213491f' )
INSERT INTO #TempData (AccountUUID) VALUES ('7124089d-034f-4575-9bd5-28490c580220' )
INSERT INTO #TempData (AccountUUID) VALUES ('4a92846e-2a92-4df2-b8df-e8af2afcc654' )
INSERT INTO #TempData (AccountUUID) VALUES ('cf758e85-fce5-484b-b716-00faaf538762' )
INSERT INTO #TempData (AccountUUID) VALUES ('a3b72b05-ead9-4671-88e4-d052c387ba08' )
INSERT INTO #TempData (AccountUUID) VALUES ('f1089066-41ce-43aa-94c3-77ac7ce9b84d' )
INSERT INTO #TempData (AccountUUID) VALUES ('d52ecfda-c53e-47fe-bc45-182f22640529' )
INSERT INTO #TempData (AccountUUID) VALUES ('7bbc9b46-f2ad-4088-b1d8-85bd1cfa5f53' )
INSERT INTO #TempData (AccountUUID) VALUES ('448186ab-9a8b-4a46-b4a2-fa768b2a1757' )
INSERT INTO #TempData (AccountUUID) VALUES ('d19cff45-7056-4512-8b49-b09b539ea1c4' )
INSERT INTO #TempData (AccountUUID) VALUES ('d1b28e2b-eb69-4287-9372-ee6aa8f5d2ee' )
INSERT INTO #TempData (AccountUUID) VALUES ('50a7912f-816a-4ad7-877c-d350278e3610' )
INSERT INTO #TempData (AccountUUID) VALUES ('5abb8ac0-86a3-43d6-a995-673c28c57769' )
INSERT INTO #TempData (AccountUUID) VALUES ('8c881dc5-3390-4f9b-8e68-2717817866f6' )
INSERT INTO #TempData (AccountUUID) VALUES ('152e3b77-7e07-4a24-b1cc-8bf4b8a932e4' )
INSERT INTO #TempData (AccountUUID) VALUES ('2c65fe49-c671-40d3-b279-1105ff043bfa' )
INSERT INTO #TempData (AccountUUID) VALUES ('ab05dc75-cfea-4f06-acb4-0ed37322e739' )
INSERT INTO #TempData (AccountUUID) VALUES ('d044cf94-cc36-4479-86d5-58ebd1f53b16' )
INSERT INTO #TempData (AccountUUID) VALUES ('cdbdb191-d0d5-4f10-a06e-ecc32ded302b' )
INSERT INTO #TempData (AccountUUID) VALUES ('4a441507-8ce2-4b75-aa8d-ec2d1df2499d' )
INSERT INTO #TempData (AccountUUID) VALUES ('5bc8c97b-4de3-4594-a054-5ec9f181e270' )
INSERT INTO #TempData (AccountUUID) VALUES ('eb096194-a31b-4383-abb8-3a6f8fe0e882' )
INSERT INTO #TempData (AccountUUID) VALUES ('0abbbfd3-ddfa-435a-ae4c-c7da8c747475' )
INSERT INTO #TempData (AccountUUID) VALUES ('8b89184d-8829-4c47-b643-ba3162cbe0b4' )
INSERT INTO #TempData (AccountUUID) VALUES ('0ccd6ace-04f1-4bca-9c5b-840cff9d9a75' )
INSERT INTO #TempData (AccountUUID) VALUES ('d48bd6f1-51ec-4fa5-96de-ecde73512ad3' )
INSERT INTO #TempData (AccountUUID) VALUES ('a2ac9d00-45ad-4e6b-a149-864a4c101e62' )
INSERT INTO #TempData (AccountUUID) VALUES ('f2287b42-0b65-4928-b604-63d442871371' )
INSERT INTO #TempData (AccountUUID) VALUES ('bed1c076-667e-4771-a482-c99e6131b62a' )
INSERT INTO #TempData (AccountUUID) VALUES ('34a86598-4352-4968-8043-d6487d4548ce' )
INSERT INTO #TempData (AccountUUID) VALUES ('2d8e9188-a27d-4145-90c2-ed29203dec77' )
INSERT INTO #TempData (AccountUUID) VALUES ('478f54ad-fa7e-4a1c-8e5d-f2cb54fdba1f' )
INSERT INTO #TempData (AccountUUID) VALUES ('0cf48190-78f9-4efc-907c-8a637604bef6' )
INSERT INTO #TempData (AccountUUID) VALUES ('3f601247-50be-4ba1-ac7f-a5e36b6a8261' )
INSERT INTO #TempData (AccountUUID) VALUES ('6852fc64-51ee-49b5-934b-9d277319d983' )
INSERT INTO #TempData (AccountUUID) VALUES ('4bd89192-124b-4d19-8ddb-ad53213ba97d' )
INSERT INTO #TempData (AccountUUID) VALUES ('4e479859-ec3b-47ee-9180-58715a08c371' )
INSERT INTO #TempData (AccountUUID) VALUES ('737bcd15-218b-44ba-ad49-f7fae64080fd' )
INSERT INTO #TempData (AccountUUID) VALUES ('ddc68568-035c-4b6e-8f58-8a689d0fcac2' )
INSERT INTO #TempData (AccountUUID) VALUES ('0e364004-36f8-4459-a4aa-558e4cea4e13' )
INSERT INTO #TempData (AccountUUID) VALUES ('e5b9b133-394d-4b97-9afe-0749414d4704' )
INSERT INTO #TempData (AccountUUID) VALUES ('655e0fa7-0616-41cc-9841-13bf1d1f0820' )
INSERT INTO #TempData (AccountUUID) VALUES ('de9436f0-8cd2-4359-b135-fda01deb7a47' )
INSERT INTO #TempData (AccountUUID) VALUES ('c8148451-8bf3-4285-b429-0f246e782a13' )
INSERT INTO #TempData (AccountUUID) VALUES ('c55fd72a-b548-4f30-af8a-1c88b42f39c5' )
INSERT INTO #TempData (AccountUUID) VALUES ('0db2bbe9-2672-4b93-983f-506517c6d932' )
INSERT INTO #TempData (AccountUUID) VALUES ('778bb432-7994-435f-ab9d-fe042d80d7ab' )
INSERT INTO #TempData (AccountUUID) VALUES ('2d37e422-3aec-44ac-8e92-0190fb7518e0' )
INSERT INTO #TempData (AccountUUID) VALUES ('ee381a76-f8af-45a1-80ba-123062fa6246' )
INSERT INTO #TempData (AccountUUID) VALUES ('d7381ee5-54e3-4622-a2e4-4f61cfd40140' )
INSERT INTO #TempData (AccountUUID) VALUES ('034b16e6-9044-47ec-8c77-c4bbe5d5b620' )
INSERT INTO #TempData (AccountUUID) VALUES ('87da246f-290e-4b1d-91e6-1c576361aa52' )
INSERT INTO #TempData (AccountUUID) VALUES ('e604d602-bb67-4736-b170-259496d62326' )
INSERT INTO #TempData (AccountUUID) VALUES ('9a2dacef-67d3-4c55-880d-407a9dbda016' )
INSERT INTO #TempData (AccountUUID) VALUES ('ca229621-a977-472d-918a-5300ff4cb00e' )
INSERT INTO #TempData (AccountUUID) VALUES ('81b5098c-676b-48e1-ad05-2a8e903a9a2a' )
INSERT INTO #TempData (AccountUUID) VALUES ('8dfa0760-7ec4-491e-8143-b0d5ba8f6c14' )
INSERT INTO #TempData (AccountUUID) VALUES ('edaa01fc-92fd-48c4-a8c3-6ec57eab5dee' )
INSERT INTO #TempData (AccountUUID) VALUES ('68b597d8-764d-463a-8002-bcf07709afa3' )
INSERT INTO #TempData (AccountUUID) VALUES ('e13b3aa1-f90d-4e12-b77c-89113d681be9' )
INSERT INTO #TempData (AccountUUID) VALUES ('9bf1f544-9bd7-4025-809d-7d7dec60d0f7' )
INSERT INTO #TempData (AccountUUID) VALUES ('95663a13-8a8e-408e-8a7b-31c476084689' )
INSERT INTO #TempData (AccountUUID) VALUES ('3e4f2156-6cbe-462e-8611-626885058462' )
INSERT INTO #TempData (AccountUUID) VALUES ('d9ecf343-0005-492e-9936-6bf66c8ef9cf' )
INSERT INTO #TempData (AccountUUID) VALUES ('f67de0cc-4535-4156-a950-993239e81242' )
INSERT INTO #TempData (AccountUUID) VALUES ('d57fa7a7-850e-4b82-8ecc-222b85b6d806' )
INSERT INTO #TempData (AccountUUID) VALUES ('66e112c9-b0a5-415e-9e90-66c34cfbddd8' )
INSERT INTO #TempData (AccountUUID) VALUES ('3c077abe-e25c-4780-ada2-0a753d4f626e' )
INSERT INTO #TempData (AccountUUID) VALUES ('20841667-b0b3-469b-a7f4-173af54e94b3' )
INSERT INTO #TempData (AccountUUID) VALUES ('8282d1db-eaf4-499f-a6f1-ba70e724a856' )
INSERT INTO #TempData (AccountUUID) VALUES ('eb591c13-455d-4fba-b08a-f1c0aeeff360' )
INSERT INTO #TempData (AccountUUID) VALUES ('f2748fa5-28bd-4841-82b7-b1e1af1346a2' )
INSERT INTO #TempData (AccountUUID) VALUES ('69c43ef0-abba-422d-8578-185d6a76731d' )
INSERT INTO #TempData (AccountUUID) VALUES ('382ad6d5-4c6a-432b-a69d-4b78ceb34ecb' )
INSERT INTO #TempData (AccountUUID) VALUES ('8393a8f6-acf3-47fa-8256-7250e0e11ab6' )
INSERT INTO #TempData (AccountUUID) VALUES ('d10d96f4-f51c-4b47-b12a-6597858d57dc' )
INSERT INTO #TempData (AccountUUID) VALUES ('7d71ae52-56ee-45c7-a0f4-b814b99a4a87' )
INSERT INTO #TempData (AccountUUID) VALUES ('700f9034-7aba-4d43-807e-7c5ee325e57b' )
INSERT INTO #TempData (AccountUUID) VALUES ('f8b896ee-e468-42ab-9a6e-3bcf0608a6ab' )
INSERT INTO #TempData (AccountUUID) VALUES ('14efafce-77d2-40f4-b467-8984e00ca97e' )
INSERT INTO #TempData (AccountUUID) VALUES ('7859a725-d26d-439f-acd7-860175c834c7' )
INSERT INTO #TempData (AccountUUID) VALUES ('6e4e4635-828a-45fd-87fd-b0092cd59557' )
INSERT INTO #TempData (AccountUUID) VALUES ('cc46ac94-5e3c-4356-8e2b-deed33834afa' )
INSERT INTO #TempData (AccountUUID) VALUES ('0149878d-4297-479e-aaf2-417c28f5d2c0' )
INSERT INTO #TempData (AccountUUID) VALUES ('517a05d6-a6bc-485f-8802-143e5b200659' )
INSERT INTO #TempData (AccountUUID) VALUES ('ad50eaf0-c55e-4640-8562-ce6e68c582e0' )
INSERT INTO #TempData (AccountUUID) VALUES ('d9d6556a-325d-41f1-875c-b5fd00212fc5' )
INSERT INTO #TempData (AccountUUID) VALUES ('04e3d50d-3d29-49b7-8986-2ca8b29572f9' )
INSERT INTO #TempData (AccountUUID) VALUES ('77bc07c4-d0f2-439a-bcb8-0f203b3719a4' )
INSERT INTO #TempData (AccountUUID) VALUES ('3b6a189d-1355-4270-9f5c-f5f89adcc3a7' )
INSERT INTO #TempData (AccountUUID) VALUES ('e9fb11af-273b-4bea-ad1e-2a9bde627367' )
INSERT INTO #TempData (AccountUUID) VALUES ('0ae56260-9337-4ddd-bbe7-c5150fd3e16a' )
INSERT INTO #TempData (AccountUUID) VALUES ('67825366-7789-41a5-97e6-2266381d513e' )
INSERT INTO #TempData (AccountUUID) VALUES ('fed88613-8994-485f-8273-3a0eb4f0548a' )
INSERT INTO #TempData (AccountUUID) VALUES ('ce87e09e-06cb-43da-9427-3c967b03271c' )
INSERT INTO #TempData (AccountUUID) VALUES ('d90bc175-720e-4765-82d5-4e0bee1fc047' )
INSERT INTO #TempData (AccountUUID) VALUES ('43dd1727-616b-4619-8daf-958ce7843286' )
INSERT INTO #TempData (AccountUUID) VALUES ('de50000c-c520-41e8-8d30-35e16be52ef9' )
INSERT INTO #TempData (AccountUUID) VALUES ('f3fa547c-128f-43a7-99d1-c701cd714fc7' )
INSERT INTO #TempData (AccountUUID) VALUES ('70869ae5-cc94-4b66-a381-f03f6200e053' )
INSERT INTO #TempData (AccountUUID) VALUES ('04c90f58-c02c-4c70-8c1d-ac282e5d29b5' )
INSERT INTO #TempData (AccountUUID) VALUES ('00dc7350-de00-4571-9d13-9b8c5a3b5f7a' )
INSERT INTO #TempData (AccountUUID) VALUES ('7e360d36-e26b-4e9e-acdd-bfe76c336afa' )
INSERT INTO #TempData (AccountUUID) VALUES ('8af61639-3128-4b2c-abc6-67d832b3b5ac' )
INSERT INTO #TempData (AccountUUID) VALUES ('39a3e8a6-86bb-4ba5-8a0f-929985ef690a' )
INSERT INTO #TempData (AccountUUID) VALUES ('324595cb-e096-4728-8d6d-4c3ea522ce72' )
INSERT INTO #TempData (AccountUUID) VALUES ('f92719b9-2a9c-4b20-bcf6-376937b86756' )
INSERT INTO #TempData (AccountUUID) VALUES ('c2f3c695-8c9f-4f24-984c-e0c0a5a60b97' )
INSERT INTO #TempData (AccountUUID) VALUES ('28feb5ea-ef51-4bdc-96d8-b0ef9d8979d9' )
INSERT INTO #TempData (AccountUUID) VALUES ('175cc4d6-ec76-40d6-a529-7ed0c07f42b7' )
INSERT INTO #TempData (AccountUUID) VALUES ('e90bda39-368e-4c2d-8edd-c3c7a590241e' )
INSERT INTO #TempData (AccountUUID) VALUES ('402e4b8a-57e1-4475-ac95-f36a5c99764b' )
INSERT INTO #TempData (AccountUUID) VALUES ('e9e7f32c-ed11-4c55-ba14-c26250219ecf' )
INSERT INTO #TempData (AccountUUID) VALUES ('aefffed7-b728-4c57-9c46-545d57b67320' )
INSERT INTO #TempData (AccountUUID) VALUES ('f30b2d13-9dd4-4552-a994-412bb87fd573' )
INSERT INTO #TempData (AccountUUID) VALUES ('085aec4d-0b19-4d27-bcf2-b980ea1a9e12' )
INSERT INTO #TempData (AccountUUID) VALUES ('cb3e5d5e-ed60-4786-b607-dcf5b2f12a07' )
INSERT INTO #TempData (AccountUUID) VALUES ('b301fab4-7e02-4c4e-9244-798890db1529' )
INSERT INTO #TempData (AccountUUID) VALUES ('b987ceb0-5a6f-4b69-816a-2ea637d84bf7' )
INSERT INTO #TempData (AccountUUID) VALUES ('6f020a3f-0711-498d-be75-40132b937752' )
INSERT INTO #TempData (AccountUUID) VALUES ('dc7e0769-9497-4a72-9127-0d5a3b7d24f9' )
INSERT INTO #TempData (AccountUUID) VALUES ('6edbbbdd-c4d6-4a72-9405-0e6a6328c74b' )
INSERT INTO #TempData (AccountUUID) VALUES ('1b66e0e9-4d9f-460b-ae9e-c8602a85bad3' )
INSERT INTO #TempData (AccountUUID) VALUES ('9897841f-17be-4d23-9ec3-8928bc872a8f' )
INSERT INTO #TempData (AccountUUID) VALUES ('86bed9df-4796-4658-989b-7502005b1b48' )
INSERT INTO #TempData (AccountUUID) VALUES ('51a963dc-bbe2-4fc8-bf82-dfea422a5eaf' )
INSERT INTO #TempData (AccountUUID) VALUES ('0376cbbf-672b-46af-9c9e-2f793bbbfc9b' )
INSERT INTO #TempData (AccountUUID) VALUES ('abfd2841-79a5-433a-af35-394999db26a2' )
INSERT INTO #TempData (AccountUUID) VALUES ('eef7ddc4-00c7-4468-8e26-afb08a8b45d4' )
INSERT INTO #TempData (AccountUUID) VALUES ('3a5982fd-bb32-4b77-ad04-691a1e6843ee' )
INSERT INTO #TempData (AccountUUID) VALUES ('ad0c9e05-b9a4-4836-9be3-f8c034630a16' )
INSERT INTO #TempData (AccountUUID) VALUES ('57488a28-96f1-42c6-81a0-0c969929ea57' )
INSERT INTO #TempData (AccountUUID) VALUES ('3b19a8f6-3ef7-4b82-8663-87157e2f8ee9' )
INSERT INTO #TempData (AccountUUID) VALUES ('e6adcaf2-1ddd-48f0-bcaa-402f99c95bfd' )
INSERT INTO #TempData (AccountUUID) VALUES ('8b98c060-0e74-48a7-81e8-528f3cf039c5' )
INSERT INTO #TempData (AccountUUID) VALUES ('4ad33825-62f0-4d47-80a4-a51e9975a210' )
INSERT INTO #TempData (AccountUUID) VALUES ('017befa0-1553-442b-b58b-5be856028acc' )
INSERT INTO #TempData (AccountUUID) VALUES ('4b1d8bb4-fd6e-4f6e-9229-6378af2984db' )
INSERT INTO #TempData (AccountUUID) VALUES ('62352e49-b597-4553-9bac-3799304945ac' )
INSERT INTO #TempData (AccountUUID) VALUES ('f94d4dd9-384b-4c7c-9556-2f34adfc3be2' )
INSERT INTO #TempData (AccountUUID) VALUES ('201ca885-ba40-4061-9ce5-2203e0c86fe7' )
INSERT INTO #TempData (AccountUUID) VALUES ('f8f00f2c-132b-4f46-923d-0dc59e323ac9' )
INSERT INTO #TempData (AccountUUID) VALUES ('4ff3520d-d6a8-47ff-a87f-76e8276b1e78' )
INSERT INTO #TempData (AccountUUID) VALUES ('1b49d358-5b8e-491b-ad57-8929600d7d9d' )
INSERT INTO #TempData (AccountUUID) VALUES ('cc400480-7b72-4067-b119-662bed71ee7b' )
INSERT INTO #TempData (AccountUUID) VALUES ('a49ecb66-bd6b-413a-838f-e89692947346' )
INSERT INTO #TempData (AccountUUID) VALUES ('4355d62e-eaf6-4301-8ef0-46acdda6d451' )
INSERT INTO #TempData (AccountUUID) VALUES ('c8e91332-2c4d-4cab-bc9a-f0a0b25960ab' )
INSERT INTO #TempData (AccountUUID) VALUES ('384cfad0-140c-45e4-88b3-1dc77d588c09' )
INSERT INTO #TempData (AccountUUID) VALUES ('0519fb11-9720-4469-9028-9bcd228d5bff' )
INSERT INTO #TempData (AccountUUID) VALUES ('3ed0c4fb-6169-400b-baad-2ef8dfe5534d' )
INSERT INTO #TempData (AccountUUID) VALUES ('87a445b0-3835-43f9-a353-328e35d1eec1' )
INSERT INTO #TempData (AccountUUID) VALUES ('fa63bb64-f5aa-4ea4-9eb7-69d94600e4a5' )
INSERT INTO #TempData (AccountUUID) VALUES ('a8f4de22-7ffe-4a79-aca4-f8ab710fd17a' )
INSERT INTO #TempData (AccountUUID) VALUES ('dabbfae5-4a4a-485f-949f-824888bcfb36' )
INSERT INTO #TempData (AccountUUID) VALUES ('002bff9e-2616-4e97-a11a-aadc5ed9ccbc' )
INSERT INTO #TempData (AccountUUID) VALUES ('842582b8-7c23-4a8a-9734-b06ed2f6ead0' )
INSERT INTO #TempData (AccountUUID) VALUES ('8f19ace0-0120-43eb-abf0-d6e8a37c1618' )
INSERT INTO #TempData (AccountUUID) VALUES ('891ad395-954c-4e47-81f3-1bed791936a9' )
INSERT INTO #TempData (AccountUUID) VALUES ('247cad57-e945-4209-89c3-ba5ef888691a' )
INSERT INTO #TempData (AccountUUID) VALUES ('3a181f0e-bb79-48de-8297-33b2ce9008e3' )
INSERT INTO #TempData (AccountUUID) VALUES ('04eb709f-e475-4e97-aded-a2687e935244' )
INSERT INTO #TempData (AccountUUID) VALUES ('8cda9f34-94e2-49a1-977d-a3598cb18d30' )
INSERT INTO #TempData (AccountUUID) VALUES ('4b71ca6e-39d8-4c56-b359-bec8e8a43cb8' )
INSERT INTO #TempData (AccountUUID) VALUES ('690975e8-b149-4e12-aaba-2129832f7166' )
INSERT INTO #TempData (AccountUUID) VALUES ('42e68e62-4255-4908-a3a5-0569d71e9469' )
INSERT INTO #TempData (AccountUUID) VALUES ('a4bb11fa-9ecd-4cb7-b8ac-252f20d480d6' )
INSERT INTO #TempData (AccountUUID) VALUES ('b7db926e-1671-4cac-87ec-11583fb362be' )
INSERT INTO #TempData (AccountUUID) VALUES ('6067ee34-3739-4ea4-aac4-ee7fd52d1247' )
INSERT INTO #TempData (AccountUUID) VALUES ('4591dfad-7234-40ca-ad37-00e12ccfeaf2' )
INSERT INTO #TempData (AccountUUID) VALUES ('02988784-9994-4dff-83ab-aff8b81cbd18' )
INSERT INTO #TempData (AccountUUID) VALUES ('c7d16816-81c5-4c0d-b43a-83ff9ace13fe' )
INSERT INTO #TempData (AccountUUID) VALUES ('6ac9d33f-3ef0-4068-b332-e4684f4e2328' )
INSERT INTO #TempData (AccountUUID) VALUES ('756d861e-a3a0-4779-93ce-78a7215ae1b8' )
INSERT INTO #TempData (AccountUUID) VALUES ('0e964490-a221-42f0-916a-df60672adadd' )
INSERT INTO #TempData (AccountUUID) VALUES ('ab66f208-93b2-4c53-b64b-c71bf2ca7a92' )
INSERT INTO #TempData (AccountUUID) VALUES ('a80b54b8-d153-4d4a-b6a8-063c481b7ded' )
INSERT INTO #TempData (AccountUUID) VALUES ('9d56b9b2-9293-4acf-baae-4c01a913ba3c' )
INSERT INTO #TempData (AccountUUID) VALUES ('e7f57b5b-729d-4201-b1d3-bdeba58d5e7a' )
INSERT INTO #TempData (AccountUUID) VALUES ('216623c0-ba94-4154-9101-2dafdffa74c1' )
INSERT INTO #TempData (AccountUUID) VALUES ('b327479c-be0a-4cbc-bc11-8631a1ef0361' )
INSERT INTO #TempData (AccountUUID) VALUES ('24ffbf5c-1410-4eff-9ffc-d194b3b65667' )
INSERT INTO #TempData (AccountUUID) VALUES ('a669734e-6a70-4a63-b6dd-12df592bad74' )
INSERT INTO #TempData (AccountUUID) VALUES ('dc06e755-a273-4dd8-91dd-ff788313ef29' )
INSERT INTO #TempData (AccountUUID) VALUES ('b54bcbc0-0505-44a8-89d8-cebd986e5082' )
INSERT INTO #TempData (AccountUUID) VALUES ('4b304775-a386-402e-8b64-e8b356bcafa1' )
INSERT INTO #TempData (AccountUUID) VALUES ('e31ba5b8-cdf9-4f4f-95d5-a8ce551bdfa6' )
INSERT INTO #TempData (AccountUUID) VALUES ('13601673-9352-4853-b533-2817cf2b94d9' )
INSERT INTO #TempData (AccountUUID) VALUES ('6d0ea30c-4184-48a5-afc2-0b7c90c41e1d' )
INSERT INTO #TempData (AccountUUID) VALUES ('887ad30d-868e-47a8-87b0-ad5567de70a1' )
INSERT INTO #TempData (AccountUUID) VALUES ('d8eb2800-053f-473d-85eb-0cf3e7019510' )
INSERT INTO #TempData (AccountUUID) VALUES ('6fac000b-d35b-4d31-89fd-4ddbf67c2cdb' )
INSERT INTO #TempData (AccountUUID) VALUES ('57b0c9c8-7b7a-44d7-9fb0-75b143578fa8' )
INSERT INTO #TempData (AccountUUID) VALUES ('1057fdb1-35ae-47c5-8886-dfe140edf2ce' )
INSERT INTO #TempData (AccountUUID) VALUES ('ef2bf41a-1d53-4dce-aeda-085c354ae6b0' )
INSERT INTO #TempData (AccountUUID) VALUES ('9d32189f-9ed7-4b23-8466-afd9243a009c' )
INSERT INTO #TempData (AccountUUID) VALUES ('72801722-b58f-4ad0-baae-2429f81c6afd' )
INSERT INTO #TempData (AccountUUID) VALUES ('9e2986be-54ee-4ad5-b7cc-b0e3838aa871' )
INSERT INTO #TempData (AccountUUID) VALUES ('c50f35ca-2f7a-46e4-a800-77d11a406b15' )
INSERT INTO #TempData (AccountUUID) VALUES ('f9e20de3-3348-4088-82a5-d03dc38b3d66' )
INSERT INTO #TempData (AccountUUID) VALUES ('2e024521-c4a7-40c8-bebe-4512ae38dbdf' )
INSERT INTO #TempData (AccountUUID) VALUES ('41e44bd2-8a6a-47ce-98f1-0e94a8ba848c' )
INSERT INTO #TempData (AccountUUID) VALUES ('c9be4453-27df-4ac0-85bd-2eb058ea5232' )
INSERT INTO #TempData (AccountUUID) VALUES ('0247bea1-d662-49dc-a3e0-c1a1ee57b9b8' )
INSERT INTO #TempData (AccountUUID) VALUES ('9127a835-0443-4370-bff8-8fff01a4dcac' )
INSERT INTO #TempData (AccountUUID) VALUES ('bef39e17-dd59-445c-8e76-bb3506eb02c6' )
INSERT INTO #TempData (AccountUUID) VALUES ('1eadce95-cb80-4631-a19b-9e3703985cfa' )
INSERT INTO #TempData (AccountUUID) VALUES ('c3d6ecce-b119-4d42-b8c3-efad2cbc3643' )
INSERT INTO #TempData (AccountUUID) VALUES ('5f3ac242-4976-4364-94eb-5a1c87075e72' )
INSERT INTO #TempData (AccountUUID) VALUES ('e2c8673d-bf4a-4950-90d5-3e82734eaf1e' )
INSERT INTO #TempData (AccountUUID) VALUES ('ce36f5d0-6fe3-4e7d-98df-047df2dc3fbf' )
INSERT INTO #TempData (AccountUUID) VALUES ('16a7460f-6d5d-48a7-af76-b684e08593fd' )
INSERT INTO #TempData (AccountUUID) VALUES ('4af3f637-d29e-425d-ae83-8b2a307403dc' )
INSERT INTO #TempData (AccountUUID) VALUES ('5605bcf9-26e4-476c-b36b-b463b53a8c36' )
INSERT INTO #TempData (AccountUUID) VALUES ('8b1e137a-8715-49d7-97ea-39ba6c4685c1' )
INSERT INTO #TempData (AccountUUID) VALUES ('96becea2-3401-457e-b917-6ecbee1c807d' )
INSERT INTO #TempData (AccountUUID) VALUES ('aa738bd7-c8bf-452d-8dc6-d2f30b25590f' )
INSERT INTO #TempData (AccountUUID) VALUES ('5afc0452-e48e-4ba9-b0e5-029aca8a556b' )
INSERT INTO #TempData (AccountUUID) VALUES ('b84a6d75-2322-443d-ad30-bffa29f8ee8c' )
INSERT INTO #TempData (AccountUUID) VALUES ('8e63365b-9a04-4534-83e3-5bcd1a4c7793' )
INSERT INTO #TempData (AccountUUID) VALUES ('1e50df2f-9879-4c9e-8b6a-74cbc92c4250' )
INSERT INTO #TempData (AccountUUID) VALUES ('2217ae00-e960-4b21-a105-fec4d0a45eda' )
INSERT INTO #TempData (AccountUUID) VALUES ('bea522aa-2464-4ea0-a547-5cc06c8c6939' )
INSERT INTO #TempData (AccountUUID) VALUES ('03cdc151-e8a8-49cf-82fb-8e9d2f5341e1' )
INSERT INTO #TempData (AccountUUID) VALUES ('2331a19d-e356-44b6-ba26-337013ae4f70' )
INSERT INTO #TempData (AccountUUID) VALUES ('019efaa8-bc8a-43ef-ae06-e08843072e99' )
INSERT INTO #TempData (AccountUUID) VALUES ('066274fa-f274-4d98-b1f7-275ebbc2aac1' )
INSERT INTO #TempData (AccountUUID) VALUES ('fcdaf82a-67d3-49f9-b9b9-81421003fbf3' )
INSERT INTO #TempData (AccountUUID) VALUES ('3ac3d37c-156a-4de7-97c1-1ba5ab33e8e1' )
INSERT INTO #TempData (AccountUUID) VALUES ('f83248be-0b02-4fe9-bc1e-f6d1916d948c' )
INSERT INTO #TempData (AccountUUID) VALUES ('31e4fb0e-9e2d-4cda-ae72-992258756031' )
INSERT INTO #TempData (AccountUUID) VALUES ('031dbee6-3c94-4b0c-873a-e4f4fe6c16c9' )
INSERT INTO #TempData (AccountUUID) VALUES ('a7ba9562-b007-46cb-b3b6-a94c652a7238' )
INSERT INTO #TempData (AccountUUID) VALUES ('4a20cd82-af24-4187-a3ff-44a06611781c' )
INSERT INTO #TempData (AccountUUID) VALUES ('d1916e95-ef2b-4132-b60c-5fbc8309cf67' )
INSERT INTO #TempData (AccountUUID) VALUES ('1938f5da-6e5c-4962-9c49-11fea64840db' )
INSERT INTO #TempData (AccountUUID) VALUES ('b959ab11-2c04-44ce-bab3-7fb143ecebd8' )
INSERT INTO #TempData (AccountUUID) VALUES ('c034f4e0-ea02-423e-96ce-b97bf8cc8cd8' )
INSERT INTO #TempData (AccountUUID) VALUES ('b2cf2e3b-bdae-4b8d-af1f-03b545b40462' )
INSERT INTO #TempData (AccountUUID) VALUES ('ffa01426-7ec2-4137-a425-60a0f4ffd99c' )
INSERT INTO #TempData (AccountUUID) VALUES ('fc28b1ce-cc0a-4334-8a98-945606c61288' )
INSERT INTO #TempData (AccountUUID) VALUES ('0429c4a7-e931-47cf-8832-dccc6068a5fa' )
INSERT INTO #TempData (AccountUUID) VALUES ('227da4c2-6c08-495e-b92e-cbac99fce81c' )
INSERT INTO #TempData (AccountUUID) VALUES ('7408faf9-8115-4072-b8eb-70b6a3d32a96' )
INSERT INTO #TempData (AccountUUID) VALUES ('f0432bb6-180c-4dd8-978a-efebef6f65de' )
INSERT INTO #TempData (AccountUUID) VALUES ('607a6901-fe3f-41b2-bcd6-d8bc82d5760b' )
INSERT INTO #TempData (AccountUUID) VALUES ('a8266338-9f98-4c1d-ae7a-aab53c7f3867' )
INSERT INTO #TempData (AccountUUID) VALUES ('7f9879aa-22d3-47d9-a173-6c6b29d19a12' )
INSERT INTO #TempData (AccountUUID) VALUES ('4e73a66e-9884-451f-84d3-511e40c613e6' )
INSERT INTO #TempData (AccountUUID) VALUES ('0f93312a-bd54-4f60-af2c-dd0958f3a1ae' )
INSERT INTO #TempData (AccountUUID) VALUES ('36b160f4-4e37-49d9-a21d-9d5e1e6fbe66' )
INSERT INTO #TempData (AccountUUID) VALUES ('b4060e70-d3a0-4269-8ce1-a3e2a096f678' )
INSERT INTO #TempData (AccountUUID) VALUES ('8d8f0ef4-ead4-485d-a9c0-7e90f4358e31' )
INSERT INTO #TempData (AccountUUID) VALUES ('973c3841-bb1b-40de-b821-bea2746dc0bd' )
INSERT INTO #TempData (AccountUUID) VALUES ('89befdb6-84c9-4ff9-bb3c-681130ef975c' )
INSERT INTO #TempData (AccountUUID) VALUES ('6b85f4e3-8db9-4830-b3e2-8fe73d2061cf' )
INSERT INTO #TempData (AccountUUID) VALUES ('d7f6a770-1324-4673-baa4-0107c00208e9' )
INSERT INTO #TempData (AccountUUID) VALUES ('72b4d3e2-5ed6-40fb-88a1-7cf391ddf5db' )
INSERT INTO #TempData (AccountUUID) VALUES ('eb801dee-cc1c-4894-b5f8-b8e1017a2870' )
INSERT INTO #TempData (AccountUUID) VALUES ('beb03d3e-b205-424a-a119-0434b1009db1' )
INSERT INTO #TempData (AccountUUID) VALUES ('f5d59141-c837-4a5b-bf12-afb2491e7c33' )
INSERT INTO #TempData (AccountUUID) VALUES ('79b61b03-7e23-44c1-bce5-6357d1ed7bf1' )
INSERT INTO #TempData (AccountUUID) VALUES ('ec7b6ccf-d50a-4f52-a360-e59c3c6f2d22' )
INSERT INTO #TempData (AccountUUID) VALUES ('bd2c3dca-e831-4e5e-8fd0-65e02c7fe6f6' )
INSERT INTO #TempData (AccountUUID) VALUES ('7563857a-1be6-47c3-b32c-be159f898136' )
INSERT INTO #TempData (AccountUUID) VALUES ('9e5aeef7-acfe-4f47-b72c-fe717e5055ce' )
INSERT INTO #TempData (AccountUUID) VALUES ('aab52e61-0e85-4f16-9e82-a352161d798b' )
INSERT INTO #TempData (AccountUUID) VALUES ('37904869-2b94-4fa3-b60a-07379474566a' )
INSERT INTO #TempData (AccountUUID) VALUES ('a38024c6-47ca-46af-bf95-8bdd15ec34f2' )
INSERT INTO #TempData (AccountUUID) VALUES ('ed26dca1-86e1-415b-b1ee-48fb3ef75403' )
INSERT INTO #TempData (AccountUUID) VALUES ('eaad9c8e-9a1f-4aa1-b0ff-2e2fcebf997b' )
INSERT INTO #TempData (AccountUUID) VALUES ('1fa1a1a0-e7b0-4db5-bdcf-459aa4185d85' )
INSERT INTO #TempData (AccountUUID) VALUES ('47b222b3-7d3a-452d-9afb-0b6f0ae5808f' )
INSERT INTO #TempData (AccountUUID) VALUES ('348fd416-e22d-4f55-90c3-31cb7f532317' )
INSERT INTO #TempData (AccountUUID) VALUES ('388321b5-de9e-4158-a5c2-96b8f655f8d2' )
INSERT INTO #TempData (AccountUUID) VALUES ('a656fd2a-cdb5-4513-8c19-141c929635d2' )
INSERT INTO #TempData (AccountUUID) VALUES ('5a51f7ce-db30-4f10-beb3-127d1f62839b' )
INSERT INTO #TempData (AccountUUID) VALUES ('cf9883bd-3113-471a-90ed-085006637ec5' )
INSERT INTO #TempData (AccountUUID) VALUES ('ea07ac7f-136e-4b6b-86af-8f7d7f248a77' )
INSERT INTO #TempData (AccountUUID) VALUES ('1d4891f5-349a-499f-be26-aca30a8944bd' )
INSERT INTO #TempData (AccountUUID) VALUES ('33cfaa60-3c6c-4000-bc22-65a7e6d6ce85' )
INSERT INTO #TempData (AccountUUID) VALUES ('5cdfa988-abcd-4f33-ad9a-3d717a4dd34c' )
INSERT INTO #TempData (AccountUUID) VALUES ('9f705ac1-7a58-4553-ab07-600eb7c2c6ba' )
INSERT INTO #TempData (AccountUUID) VALUES ('52f3e19f-8fa1-4e80-b273-160703039eb0' )
INSERT INTO #TempData (AccountUUID) VALUES ('8c8c7971-165a-4c80-9010-e8f0645ddd5a' )
INSERT INTO #TempData (AccountUUID) VALUES ('35572bd8-f5ec-4ed3-9be4-05fef4ed00c6' )
INSERT INTO #TempData (AccountUUID) VALUES ('d4ade4bc-bf0e-44f6-b78a-a31c2eb65366' )
INSERT INTO #TempData (AccountUUID) VALUES ('a89ad119-dc26-4a36-96de-f35a2ba57fb3' )
INSERT INTO #TempData (AccountUUID) VALUES ('bfb1d4d6-6acc-44cf-ad74-ce6adcec224c' )
INSERT INTO #TempData (AccountUUID) VALUES ('cf8361a5-7e08-4eb2-bf5e-9e47872c4cfa' )
INSERT INTO #TempData (AccountUUID) VALUES ('1010b5d9-c031-4484-a402-b03128a68cd3' )
INSERT INTO #TempData (AccountUUID) VALUES ('9b0a930f-fad4-477f-ae72-60296e6c1910' )
INSERT INTO #TempData (AccountUUID) VALUES ('d6da715b-f7ba-43b2-acbe-25489e49c18b' )
INSERT INTO #TempData (AccountUUID) VALUES ('6efcd44c-448c-4a13-b480-2a4d25caf845' )
INSERT INTO #TempData (AccountUUID) VALUES ('b497767a-20d7-4c42-a222-8073711be978' )
INSERT INTO #TempData (AccountUUID) VALUES ('ec71db61-cc68-4bb3-9a47-f129edce2b80' )
INSERT INTO #TempData (AccountUUID) VALUES ('3bbe0472-0742-42c8-91db-e69b61651caa' )
INSERT INTO #TempData (AccountUUID) VALUES ('1dd2b600-9405-41d2-86a5-847cf6b49b95' )
INSERT INTO #TempData (AccountUUID) VALUES ('674b0dd2-aa09-4bd5-88f6-ade079422334' )
INSERT INTO #TempData (AccountUUID) VALUES ('9f54dc9a-b3e5-4717-bb15-701532f8709c' )
INSERT INTO #TempData (AccountUUID) VALUES ('7122dc75-ce1f-4dfb-b94c-3ea6e13680f7' )
INSERT INTO #TempData (AccountUUID) VALUES ('58c14c4b-735f-42f7-9e4c-578b07a933fb' )
INSERT INTO #TempData (AccountUUID) VALUES ('fff03858-def4-4d80-8a1a-20b1fe356aee' )
INSERT INTO #TempData (AccountUUID) VALUES ('796b0c7b-308b-4f13-9471-77d676e18b3b' )
INSERT INTO #TempData (AccountUUID) VALUES ('1ac8f7e5-a23b-4cb8-8f14-fe5d28ae2041' )
INSERT INTO #TempData (AccountUUID) VALUES ('3adf8ccd-d30f-4683-b0b9-a8c4de030934' )
INSERT INTO #TempData (AccountUUID) VALUES ('7f128b4b-509f-417c-aaa7-1a9bcf70f4bd' )
INSERT INTO #TempData (AccountUUID) VALUES ('3c880a07-1a31-4256-b514-b42a0eabaeca' )
INSERT INTO #TempData (AccountUUID) VALUES ('e61925dd-fd46-4ca9-92dc-eb6503474ef4' )
INSERT INTO #TempData (AccountUUID) VALUES ('dcfc9c5d-2670-447d-9dce-229613d1614b' )
INSERT INTO #TempData (AccountUUID) VALUES ('b5928980-5bd0-4fb1-9af1-15c9606cf8f7' )
INSERT INTO #TempData (AccountUUID) VALUES ('f2bcba0d-d458-4f00-9d20-c9651e77a1d4' )
INSERT INTO #TempData (AccountUUID) VALUES ('96f48834-2b8d-4d12-95c4-4e3450f36fc2' )
INSERT INTO #TempData (AccountUUID) VALUES ('a7fd4159-706f-411d-bb49-cd5d52c5b5a6' )
INSERT INTO #TempData (AccountUUID) VALUES ('76093aee-66f7-43f1-8520-61ad1823b946' )
INSERT INTO #TempData (AccountUUID) VALUES ('4f875cdb-60a1-4e11-9e15-580e29a32749' )
INSERT INTO #TempData (AccountUUID) VALUES ('798c8b96-df50-4d60-a2fd-f28a49a3b68f' )
INSERT INTO #TempData (AccountUUID) VALUES ('b5a6c097-82d7-4813-b725-4a00befcfe41' )
INSERT INTO #TempData (AccountUUID) VALUES ('7da3d5de-d8d8-4c11-a3b4-33fc31824e41' )
INSERT INTO #TempData (AccountUUID) VALUES ('9982a9e9-b75d-466e-87ea-13ccc7ee356d' )
INSERT INTO #TempData (AccountUUID) VALUES ('517223a6-e516-4265-9af2-95609890fe2c' )
INSERT INTO #TempData (AccountUUID) VALUES ('64342a85-b22a-474e-a253-c48066a74bab' )
INSERT INTO #TempData (AccountUUID) VALUES ('b37e4fb0-d807-4648-a93d-9be22b0ec561' )
INSERT INTO #TempData (AccountUUID) VALUES ('d20fe970-6c79-49e9-84ee-9dec0f310028' )
INSERT INTO #TempData (AccountUUID) VALUES ('f22e8396-8cfb-4b6e-964c-4096eae57517' )
INSERT INTO #TempData (AccountUUID) VALUES ('113b7039-7a48-45de-96c6-e54154069c18' )
INSERT INTO #TempData (AccountUUID) VALUES ('bd1e08a2-c170-4aa4-819b-68c4f0ee1d3e' )
INSERT INTO #TempData (AccountUUID) VALUES ('2e8665fe-c650-409b-ad9b-348f38bdecd0' )
INSERT INTO #TempData (AccountUUID) VALUES ('2849a932-1781-4237-9350-fed6cd7c3d8a' )
INSERT INTO #TempData (AccountUUID) VALUES ('37c6b4b8-902b-4872-913a-6483fb035b34' )
