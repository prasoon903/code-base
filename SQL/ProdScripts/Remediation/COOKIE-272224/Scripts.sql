SELECT * FROM #TempRecords
SELECT COUNT(1) FROM #TempRecords



DROP TABLE IF EXISTS #TempData
SELECT T.*, RTRIM(B.AccountNumber) AccountNumber, B.acctID, B.CycleDueDTD, SystemStatus, AmountOfTotalDue, ReportHistoryCtrCC01,ReportHistoryCtrCC02
INTO #TempData
FROM #TempRecords T
JOIN BSegment_Primary B WITH (NOLOCK) ON (T.AccountUUID = B.UniversalUniqueID)
JOIN BSegmentCreditCard BC WITH (NOLOCK) ON (B.acctId = BC.acctID)
JOIN BSegment_Balances BB WITH (NOLOCK) ON (BB.acctId = BC.acctID)

SELECT T.*, PortfolioID 
FROM StatementHeaderEX S WITH (NOLOCK)
JOIN #TempData T ON (T.acctID = S.acctID AND S.StatementDate = '2024-02-29 23:59:57')

SELECT COUNT(1)
FROM StatementHeaderEX S WITH (NOLOCK)
JOIN #TempData T ON (T.acctID = S.acctID AND S.StatementDate = '2024-02-29 23:59:57')
WHERE PortfolioID = '1'

SELECT * FROM #TempData WHERE DQ_MarchValue <> CycleDueDTD

SELECT * FROM #TempData WHERE CycleDueDTD > DQ_FebValue --AND DQ_MarchValue <> CycleDueDTD

SELECT * FROM #TempData WHERE CycleDueDTD = DQ_FebValue

--SCRIPTS

SELECT 1 TypeOfManualReage, AccountNumber, DQ_FebValue CycleDueMethod FROM #TempData WHERE CycleDueDTD > DQ_FebValue

SELECT 'UPDATE TOP(1) StatementHeaderEX SET PortfolioID = ''1'' WHERE StatementDate = ''2024-02-29 23:59:57'' AND acctID = ' + TRY_CAST(acctID AS VARCHAR) FROM #TempData



SELECT ReportHistoryCtrCC01,ReportHistoryCtrCC02,ReportHistoryCtrCC03,ReportHistoryCtrCC04,ReportHistoryCtrCC05,ReportHistoryCtrCC06,
ReportHistoryCtrCC07,ReportHistoryCtrCC08,ReportHistoryCtrCC09,ReportHistoryCtrCC10,ReportHistoryCtrCC11,ReportHistoryCtrCC12,
ReportHistoryCtrCC13,ReportHistoryCtrCC14,ReportHistoryCtrCC15,ReportHistoryCtrCC16,ReportHistoryCtrCC17,ReportHistoryCtrCC18,
ReportHistoryCtrCC19,ReportHistoryCtrCC20,ReportHistoryCtrCC21,ReportHistoryCtrCC22,ReportHistoryCtrCC23,ReportHistoryCtrCC24 
FROM BSegment_balances WITH (NOLOCK)
WHERE acctId = 21637644



DROP TABLE IF EXISTS #TempRecords
CREATE TABLE #TempRecords(SN DECIMAL(19, 0) IDENTITY(1, 1), AccountUUID VARCHAR(64), DQ_Feb VARCHAR(64), DQ_March VARCHAR(64))

INSERT INTO #TempRecords (AccountUUID) VALUES ('025dbc1d-4584-4650-b8ab-cfc10a2379e7' )
INSERT INTO #TempRecords (AccountUUID) VALUES ('099c514a-b1b3-4390-bf69-78be90f3916c' )
INSERT INTO #TempRecords (AccountUUID) VALUES ('19dde356-b133-477f-8821-888b80a86ba2' )
INSERT INTO #TempRecords (AccountUUID) VALUES ('1b101afa-5d2d-4191-adf5-2fb56bdae016' )
INSERT INTO #TempRecords (AccountUUID) VALUES ('208f3ec0-cae9-45be-b67a-39b94fae8d8e' )
INSERT INTO #TempRecords (AccountUUID) VALUES ('21008768-0571-4a03-a3dd-53b7f37b85a2' )
INSERT INTO #TempRecords (AccountUUID) VALUES ('25865dd2-0528-4ba0-986c-b105b7a01da5' )
INSERT INTO #TempRecords (AccountUUID) VALUES ('267e13a4-0013-4fa3-94a9-cd561553f96a' )
INSERT INTO #TempRecords (AccountUUID) VALUES ('2d72796f-e114-4cf6-80e2-bb4ce29dafc0' )
INSERT INTO #TempRecords (AccountUUID) VALUES ('307c69a4-f1d5-483d-8ab0-b182df06ace3' )
INSERT INTO #TempRecords (AccountUUID) VALUES ('36349869-a037-4cc0-9c20-01d77567175f' )
INSERT INTO #TempRecords (AccountUUID) VALUES ('390d5f88-18e4-4ab7-bae8-a329dde3cf66' )
INSERT INTO #TempRecords (AccountUUID) VALUES ('3e7e5775-c82b-4a1c-b78a-1d40aca2de1a' )
INSERT INTO #TempRecords (AccountUUID) VALUES ('40ed3d98-62c0-4864-9d94-add6df1317b2' )
INSERT INTO #TempRecords (AccountUUID) VALUES ('430b7cba-6c1d-4642-b434-8495a42f1c73' )
INSERT INTO #TempRecords (AccountUUID) VALUES ('45251d7a-0215-4641-afdb-724a3310d9db' )
INSERT INTO #TempRecords (AccountUUID) VALUES ('4be01684-86ea-42d7-8c68-17db8b10fa5e' )
INSERT INTO #TempRecords (AccountUUID) VALUES ('4f1938bc-4d4a-46d4-9062-d2dfe692d2af' )
INSERT INTO #TempRecords (AccountUUID) VALUES ('4fd46a69-1d18-4cf5-86a1-c25192b1ed7d' )
INSERT INTO #TempRecords (AccountUUID) VALUES ('56cf6600-76ea-4ffa-82ea-35eccf25da2d' )
INSERT INTO #TempRecords (AccountUUID) VALUES ('583971f7-6d7b-430d-87fc-0db7deccee94' )
INSERT INTO #TempRecords (AccountUUID) VALUES ('5b0bebb9-877c-451d-94ff-cfbfa5839235' )
INSERT INTO #TempRecords (AccountUUID) VALUES ('5b69ba82-11ac-43bc-8974-8be85bd4d200' )
INSERT INTO #TempRecords (AccountUUID) VALUES ('5cba1527-d673-49df-a99a-4cbb3193b408' )
INSERT INTO #TempRecords (AccountUUID) VALUES ('5e7c11c2-f746-46af-900a-d7eb791eee7b' )
INSERT INTO #TempRecords (AccountUUID) VALUES ('61f21d17-50a5-4bde-bf47-1fafe50a8e12' )
INSERT INTO #TempRecords (AccountUUID) VALUES ('638d23a2-99c4-447f-b8aa-fa2936a1fa82' )
INSERT INTO #TempRecords (AccountUUID) VALUES ('6defd7cb-1c29-40b5-ad68-7553d9bd0fd1' )
INSERT INTO #TempRecords (AccountUUID) VALUES ('73236740-a4d6-44d6-8aea-fc27cc6ed598' )
INSERT INTO #TempRecords (AccountUUID) VALUES ('73d93b5b-c481-4877-9d9c-838f866d5791' )
INSERT INTO #TempRecords (AccountUUID) VALUES ('798eb644-818e-4974-9b55-7fd967dca500' )
INSERT INTO #TempRecords (AccountUUID) VALUES ('7a82ef8a-1c9b-4786-a4fe-77b53557e8ac' )
INSERT INTO #TempRecords (AccountUUID) VALUES ('7c822a66-b0f5-42ac-8012-74495226dc9b' )
INSERT INTO #TempRecords (AccountUUID) VALUES ('7da7eb40-2e68-42c2-a183-83aeb2000650' )
INSERT INTO #TempRecords (AccountUUID) VALUES ('7e0bda52-f5d3-427d-9bfe-0c848d58bee1' )
INSERT INTO #TempRecords (AccountUUID) VALUES ('81f38cb5-3a95-4a99-a167-4a59f93c163d' )
INSERT INTO #TempRecords (AccountUUID) VALUES ('8222ed02-265d-459b-9474-9fe1e94a987c' )
INSERT INTO #TempRecords (AccountUUID) VALUES ('826b26e3-2972-47fd-aaac-89b96bfeddce' )
INSERT INTO #TempRecords (AccountUUID) VALUES ('878e6984-9cc4-4f79-acb9-9d7a10915b32' )
INSERT INTO #TempRecords (AccountUUID) VALUES ('8a9aa211-72ee-4422-9346-b8a74f112036' )
INSERT INTO #TempRecords (AccountUUID) VALUES ('8f71d96c-c897-42ee-810a-925c4d936bfe' )
INSERT INTO #TempRecords (AccountUUID) VALUES ('921f4f59-bfd2-48a5-82ad-885708bb32bb' )
INSERT INTO #TempRecords (AccountUUID) VALUES ('9b0aba30-286a-47de-9a7f-faaccc54f3a2' )
INSERT INTO #TempRecords (AccountUUID) VALUES ('9cd991d5-7fef-40de-9c44-0ea1ae029e05' )
INSERT INTO #TempRecords (AccountUUID) VALUES ('a48db23f-792d-423f-a915-e6ff66585889' )
INSERT INTO #TempRecords (AccountUUID) VALUES ('a71a1113-9dcf-4c18-bad8-df2ee14ee79f' )
INSERT INTO #TempRecords (AccountUUID) VALUES ('a93848d4-773c-4137-9993-a7d8e16aef28' )
INSERT INTO #TempRecords (AccountUUID) VALUES ('aa054821-d070-492d-b878-85b6c2765854' )
INSERT INTO #TempRecords (AccountUUID) VALUES ('aec85225-9f19-4674-99e6-7e1dbd7c9c29' )
INSERT INTO #TempRecords (AccountUUID) VALUES ('afe7de88-5462-49e7-84da-eab09ddc955f' )
INSERT INTO #TempRecords (AccountUUID) VALUES ('b560d630-ff83-426c-b64d-981724da75d5' )
INSERT INTO #TempRecords (AccountUUID) VALUES ('b684fbfa-1b43-4c28-92e5-78d25fd15316' )
INSERT INTO #TempRecords (AccountUUID) VALUES ('b9d11b53-23ae-4171-a6d6-72f85b77a830' )
INSERT INTO #TempRecords (AccountUUID) VALUES ('c60b4a9a-4884-4f78-916a-2dec41f7c819' )
INSERT INTO #TempRecords (AccountUUID) VALUES ('cd5af552-6726-4555-b83a-8a01fd2ffa43' )
INSERT INTO #TempRecords (AccountUUID) VALUES ('cf30eb44-0171-41d1-9460-526c9db64cf5' )
INSERT INTO #TempRecords (AccountUUID) VALUES ('cfd59698-9d3d-4d3b-8e53-19aef6100558' )
INSERT INTO #TempRecords (AccountUUID) VALUES ('d1cdc6d7-e305-42de-ae66-88a641bcaba2' )
INSERT INTO #TempRecords (AccountUUID) VALUES ('d2469fbb-30c6-4705-8bee-42d370eda9d7' )
INSERT INTO #TempRecords (AccountUUID) VALUES ('d3258746-8acd-4d8b-93a4-36cd87dbb808' )
INSERT INTO #TempRecords (AccountUUID) VALUES ('d5c75f47-1d02-41cd-a08e-93c63bb7ac0b' )
INSERT INTO #TempRecords (AccountUUID) VALUES ('d6abadeb-2a78-4a7a-ba1d-a5c684b25da5' )
INSERT INTO #TempRecords (AccountUUID) VALUES ('e6b59c38-85a0-4e08-b989-36c880f41881' )
INSERT INTO #TempRecords (AccountUUID) VALUES ('e8e2b51a-1ec1-45ce-bbaa-71621af0b371' )
INSERT INTO #TempRecords (AccountUUID) VALUES ('edbf2b1e-66d3-43c6-bbaf-263df5bc7541' )
INSERT INTO #TempRecords (AccountUUID) VALUES ('f0c69098-3180-4f0e-8162-2635101dad3f' )
INSERT INTO #TempRecords (AccountUUID) VALUES ('f85be454-f1ff-4c16-82e5-0c74bfd5cb0e' )
INSERT INTO #TempRecords (AccountUUID) VALUES ('f919f24f-cf09-4682-a64f-2dfea09b3019' )
INSERT INTO #TempRecords (AccountUUID) VALUES ('f97462d4-f2db-4fa8-8d04-9898e9f07bbc' )
INSERT INTO #TempRecords (AccountUUID) VALUES ('fceae091-68bd-487e-a2e1-c0a8304b6f6c' )
INSERT INTO #TempRecords (AccountUUID) VALUES ('fe60c9ee-95df-4fe4-8691-02a7796afcae' )
