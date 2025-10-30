SELECT * FROM #TempRecords
SELECT COUNT(1) FROM #TempRecords

SELECT DISTINCT DQ_Feb FROM #TempRecords

DROP TABLE IF EXISTS #TempDQ
CREATE TABLE #TempDQ(SN DECIMAL(19, 0) IDENTITY(1, 1), DQ VARCHAR(64), DQValue INT)

INSERT INTO #TempDQ VALUES ('Nothing Due', 0)
INSERT INTO #TempDQ VALUES ('Current Due', 1)
INSERT INTO #TempDQ VALUES ('Past Due', 2)
INSERT INTO #TempDQ VALUES ('1 Cycle Past Due', 3)
INSERT INTO #TempDQ VALUES ('2 Cycles Past Due', 4)
INSERT INTO #TempDQ VALUES ('3 Cycles Past Due', 5)
INSERT INTO #TempDQ VALUES ('4 Cycles Past Due', 6)
INSERT INTO #TempDQ VALUES ('5 Cycles Past Due', 7)

SELECT * FROM #TempDQ 


DROP TABLE IF EXISTS #TempData
SELECT T.*, D1.DQValue DQ_FebValue, D2.DQValue DQ_MarchValue, RTRIM(B.AccountNumber) AccountNumber, B.acctID, B.CycleDueDTD, SystemStatus, AmountOfTotalDue, ReportHistoryCtrCC01,ReportHistoryCtrCC02
INTO #TempData
FROM #TempRecords T
JOIN BSegment_Primary B WITH (NOLOCK) ON (T.AccountUUID = B.UniversalUniqueID)
JOIN BSegmentCreditCard BC WITH (NOLOCK) ON (B.acctId = BC.acctID)
JOIN BSegment_Balances BB WITH (NOLOCK) ON (BB.acctId = BC.acctID)
LEFT JOIN #TempDQ D1 ON (D1.DQ = T.DQ_Feb)
LEFT JOIN #TempDQ D2 ON (D2.DQ = T.DQ_March)

SELECT *
FROM #TempRecords T1
LEFT JOIN #TempData T2 ON (T1.AccountUUID = T2.AccountUUID)
WHERE T2.AccountUUID IS NULL

SELECT T.*, PortfolioID 
FROM StatementHeaderEX S WITH (NOLOCK)
JOIN #TempData T ON (T.acctID = S.acctID AND S.StatementDate = '2024-02-29 23:59:57')

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

INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('025dbc1d-4584-4650-b8ab-cfc10a2379e7', '1 Cycle Past Due', '2 Cycles Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('058f3af4-f2c0-40fc-97a8-c6d927827dfe', 'Current Due', 'Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('1a73749e-38ba-49ec-95c8-39684f5bf28b', 'Current Due', 'Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('1f647218-c84b-4381-9521-387df446a843', 'Past Due', '1 Cycle Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('21008768-0571-4a03-a3dd-53b7f37b85a2', '1 Cycle Past Due', '2 Cycles Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('25865dd2-0528-4ba0-986c-b105b7a01da5', '3 Cycles Past Due', '4 Cycles Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('267e13a4-0013-4fa3-94a9-cd561553f96a', '1 Cycle Past Due', '2 Cycles Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('2b9f9360-c912-4171-aefe-ebef4610eb4b', 'Past Due', '1 Cycle Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('2d72796f-e114-4cf6-80e2-bb4ce29dafc0', '1 Cycle Past Due', '2 Cycles Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('2ddbd3ff-f1e5-49ba-b8b5-75847f059e31', 'Past Due', '1 Cycle Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('307c69a4-f1d5-483d-8ab0-b182df06ace3', '1 Cycle Past Due', '2 Cycles Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('331e42ba-6312-440e-a0be-ffce4fa33130', 'Current Due', 'Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('3e7e5775-c82b-4a1c-b78a-1d40aca2de1a', '2 Cycles Past Due', '3 Cycles Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('40ed3d98-62c0-4864-9d94-add6df1317b2', '4 Cycles Past Due', '5 Cycles Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('430b7cba-6c1d-4642-b434-8495a42f1c73', '3 Cycles Past Due', '4 Cycles Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('45bcbc44-96f5-4c22-970b-1e7cf90778e8', 'Past Due', '1 Cycle Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('468447ff-df4d-48ca-9521-eb239d6c82ba', 'Past Due', '1 Cycle Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('4fd46a69-1d18-4cf5-86a1-c25192b1ed7d', '2 Cycles Past Due', '3 Cycles Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('51d670b0-d980-4734-85be-18ccfefa86f5', 'Current Due', 'Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('56cf6600-76ea-4ffa-82ea-35eccf25da2d', '2 Cycles Past Due', '3 Cycles Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('583971f7-6d7b-430d-87fc-0db7deccee94', '4 Cycles Past Due', '5 Cycles Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('5b0bebb9-877c-451d-94ff-cfbfa5839235', '1 Cycle Past Due', '2 Cycles Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('5cba1527-d673-49df-a99a-4cbb3193b408', '3 Cycles Past Due', '4 Cycles Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('5e7c11c2-f746-46af-900a-d7eb791eee7b', '1 Cycle Past Due', '2 Cycles Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('5f1e562e-6944-4f76-9847-a32c75084d80', '2 Cycles Past Due', '3 Cycles Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('61f21d17-50a5-4bde-bf47-1fafe50a8e12', '1 Cycle Past Due', '2 Cycles Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('638d23a2-99c4-447f-b8aa-fa2936a1fa82', '3 Cycles Past Due', '4 Cycles Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('6b3e6a5b-803a-448a-bc8c-04c4b7482e31', 'Current Due', 'Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('6defd7cb-1c29-40b5-ad68-7553d9bd0fd1', '1 Cycle Past Due', '2 Cycles Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('713c9919-9f34-4ef8-8a82-50aa6ef8c880', 'Past Due', '1 Cycle Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('73d93b5b-c481-4877-9d9c-838f866d5791', '4 Cycles Past Due', '5 Cycles Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('7579042d-33ad-4c2f-ae9d-ca7745555f44', 'Current Due', 'Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('798eb644-818e-4974-9b55-7fd967dca500', '3 Cycles Past Due', '4 Cycles Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('7a82ef8a-1c9b-4786-a4fe-77b53557e8ac', '1 Cycle Past Due', '2 Cycles Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('7c822a66-b0f5-42ac-8012-74495226dc9b', '2 Cycles Past Due', '3 Cycles Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('7da7eb40-2e68-42c2-a183-83aeb2000650', '2 Cycles Past Due', '3 Cycles Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('7e0bda52-f5d3-427d-9bfe-0c848d58bee1', '3 Cycles Past Due', '4 Cycles Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('8222ed02-265d-459b-9474-9fe1e94a987c', '3 Cycles Past Due', '4 Cycles Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('8265df41-8f72-4c1a-8cab-afd49f0e0420', 'Past Due', '1 Cycle Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('826b26e3-2972-47fd-aaac-89b96bfeddce', '4 Cycles Past Due', '5 Cycles Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('84271d25-60f7-4592-a3e9-47447b909b42', 'Past Due', '1 Cycle Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('878e6984-9cc4-4f79-acb9-9d7a10915b32', '3 Cycles Past Due', '4 Cycles Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('88ff07e9-3440-4912-9991-bfbfcf282aa9', 'Past Due', '1 Cycle Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('8a9aa211-72ee-4422-9346-b8a74f112036', '1 Cycle Past Due', '2 Cycles Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('8f71d96c-c897-42ee-810a-925c4d936bfe', '2 Cycles Past Due', '3 Cycles Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('921f4f59-bfd2-48a5-82ad-885708bb32bb', '3 Cycles Past Due', '4 Cycles Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('9a260f14-9397-4f54-99cc-faa98659d12e', 'Past Due', '1 Cycle Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('9a6a796e-75f7-4832-ae67-c5c3e873289e', 'Current Due', '1 Cycle Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('9b0aba30-286a-47de-9a7f-faaccc54f3a2', '2 Cycles Past Due', '3 Cycles Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('9e313736-0496-42b3-9510-fe90a011711a', 'Past Due', '1 Cycle Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('a48db23f-792d-423f-a915-e6ff66585889', '1 Cycle Past Due', '2 Cycles Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('a6ea27dd-01a3-4dd4-8d07-f14b8efa9c61', 'Past Due', '1 Cycle Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('a71a1113-9dcf-4c18-bad8-df2ee14ee79f', '1 Cycle Past Due', '2 Cycles Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('a8d79079-f150-4c66-8a97-1be4e411573c', 'Current Due', 'Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('a93848d4-773c-4137-9993-a7d8e16aef28', '1 Cycle Past Due', '2 Cycles Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('aa054821-d070-492d-b878-85b6c2765854', '4 Cycles Past Due', '5 Cycles Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('adb42e8d-4a27-4dc1-b9cb-b1fc8ddb5eed', 'Past Due', '1 Cycle Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('b560d630-ff83-426c-b64d-981724da75d5', '1 Cycle Past Due', '2 Cycles Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('b684fbfa-1b43-4c28-92e5-78d25fd15316', '1 Cycle Past Due', '2 Cycles Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('b6db517d-90c3-4ee8-83a8-9296013d2bf2', 'Past Due', '1 Cycle Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('b9d11b53-23ae-4171-a6d6-72f85b77a830', '1 Cycle Past Due', '2 Cycles Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('ba1ad628-383f-419b-8161-f4a91af9e311', 'Past Due', '1 Cycle Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('be28d180-c50b-4d29-a1a9-f39b42b95a01', 'Past Due', '1 Cycle Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('bf4311be-641d-49aa-929b-8dc4a32482ba', 'Past Due', '1 Cycle Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('c4a38018-f978-4fde-83a2-0fde7ca1a4cb', 'Past Due', '1 Cycle Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('c60b4a9a-4884-4f78-916a-2dec41f7c819', '3 Cycles Past Due', '4 Cycles Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('cd5af552-6726-4555-b83a-8a01fd2ffa43', '3 Cycles Past Due', '4 Cycles Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('cf30eb44-0171-41d1-9460-526c9db64cf5', '1 Cycle Past Due', '2 Cycles Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('d1cdc6d7-e305-42de-ae66-88a641bcaba2', '1 Cycle Past Due', '2 Cycles Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('d23f0c35-2c39-42e8-b33c-28bf996bb252', 'Past Due', '1 Cycle Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('d2469fbb-30c6-4705-8bee-42d370eda9d7', '2 Cycles Past Due', '3 Cycles Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('d3258746-8acd-4d8b-93a4-36cd87dbb808', '4 Cycles Past Due', '5 Cycles Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('d5c75f47-1d02-41cd-a08e-93c63bb7ac0b', '3 Cycles Past Due', '4 Cycles Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('d6bc4e49-00c5-4b7d-a58a-4cbbe9516459', 'Past Due', '1 Cycle Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('dd6597cb-9278-4d84-bcfe-b8b61c057f11', 'Past Due', '1 Cycle Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('dfea9552-d105-4786-a53b-40d22c321080', 'Past Due', '1 Cycle Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('e65355fa-6a57-46b9-a33c-31ac0bb61fd2', 'Past Due', '1 Cycle Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('e6b59c38-85a0-4e08-b989-36c880f41881', '1 Cycle Past Due', '2 Cycles Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('e83fe503-160a-4a8f-a79b-1f77838a9afe', 'Current Due', 'Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('e8e2b51a-1ec1-45ce-bbaa-71621af0b371', '1 Cycle Past Due', '2 Cycles Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('f0c69098-3180-4f0e-8162-2635101dad3f', '3 Cycles Past Due', '4 Cycles Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('f398baec-d370-4049-bbfb-b62f03985daa', 'Current Due', 'Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('f85be454-f1ff-4c16-82e5-0c74bfd5cb0e', '3 Cycles Past Due', '4 Cycles Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('f919f24f-cf09-4682-a64f-2dfea09b3019', '4 Cycles Past Due', '5 Cycles Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('f97462d4-f2db-4fa8-8d04-9898e9f07bbc', '3 Cycles Past Due', '4 Cycles Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('fc67373b-ffd2-4d4d-a1ca-1e4def459d11', 'Past Due', '1 Cycle Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('fceae091-68bd-487e-a2e1-c0a8304b6f6c', '3 Cycles Past Due', '4 Cycles Past Due' )
INSERT INTO #TempRecords (AccountUUID, DQ_Feb, DQ_March) VALUES ('fe60c9ee-95df-4fe4-8691-02a7796afcae', '3 Cycles Past Due', '4 Cycles Past Due' )
