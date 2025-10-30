

--SELECT *, ROW_NUMBER() OVER (PARTITION BY transactionuuid ORDER BY SN) [Rank] FROM #TempRecords

;WITH CTE AS
(SELECT *, ROW_NUMBER() OVER (PARTITION BY AccountUUID ORDER BY SN) [Rank] FROM #TempRecords)
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


--DROP TABLE IF EXISTS #POD1
DROP TABLE IF EXISTS #POD2
SELECT AccountUUID, RTRIM(B.AccountNumber) AccountNumber, ClientID, MergeInProcessPH, transactionuuid, Amount
INTO #POD2
FROM #TempRecords T1
LEFT JOIN BSegment_Primary B WITH (NOLOCK) ON (T1.AccountUUID = B.UniversalUniqueID)
WHERE B.UniversalUniqueID IS  NULL

SELECT * FROM #POD1

SELECT AccountUUID, Amount FROM #POD2

SELECT *
FROM #TempRecords T1
LEFT JOIN #TempRecords_OLD T2 ON (T1.transactionuuid = T2.transactionuuid)
WHERE T2.transactionuuid IS NOT NULL

SELECT *
FROM #TempRecords T1
WHERE transactionuuid IN 
(SELECT transactionuuid FROM #TempRecords_OLD)

DROP TABLE IF EXISTS #TxnToPost
SELECT BP.AcctID, T1.*
INTO #TxnToPost 
FROM #POD1 T1
JOIN BSegment_Primary BP WITH (NOLOCK) ON (T1.AccountNumber = BP.AccountNumber)

SELECT * FROM #TxnToPost

SELECT 'INSERT INTO CreateNewSingleTransactionData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode) VALUES (' + TRY_CONVERT(VARCHAR, acctID) + ', '''+RTRIM(AccountNumber)+''', ' + TRY_CONVERT(VARCHAR, Amount) + ', ''49''' + ', ''4907''' + ')'
FROM #TxnToPost
ORDER BY acctID

--DELETE FROM #TempRecords WHERE transactionuuid IN (SELECT transactionuuid FROM #TempRecords_OLD)

/*
DROP TABLE IF EXISTS #TempRecords
CREATE TABLE #TempRecords (SN INT IDENTITY(1, 1), AccountUUID VARCHAR(64), AccountNumber VARCHAR(19), BSAcctId INT, ClientID VARCHAR(64), ClaimID VARCHAR(64), transactionuuid VARCHAR(64), Amount VARCHAR(50))

INSERT INTO #TempRecords (AccountUUID, Amount) VALUES
('a4f0fb0c-64bb-48ef-b5dc-808acd380606', 2.75),
('aa765c57-fad4-4c46-bdac-a1b5cf9e737f', 382.27),
('4520b697-40da-4fc6-849c-67f23b729e61', 2558.66),
('ac0a29dd-0e24-4c97-b31e-afe0f179bc1a', 47.75),
('909db6c4-c5bd-4c72-9014-af561a52a5ab', 40.78),
('deb3621a-0ff1-4c2e-a97f-bf2887bccda2', 450),
('909db6c4-c5bd-4c72-9014-af561a52a5ab', 11.77),
('0f3bf528-d926-46da-aa91-567a2a9ba0f8', 78.21),
('a4f0fb0c-64bb-48ef-b5dc-808acd380606', 2.75),
('f54ffd7f-3f6a-401e-b342-65c6f78b014a', 78.44),
('bc4c93de-d486-43f3-9cfd-8e7502fc5f75', 12.67),
('54de2f66-dc6b-4343-90eb-60384ac50a00', 3960),
('1961d61a-b940-4799-9d5d-d32b3c10a94d', 36.48),
('e9172b91-b57b-4b1c-9c63-eeba0818e1fb', 106.92),
('909db6c4-c5bd-4c72-9014-af561a52a5ab', 231.68),
('212cb29d-191a-4252-b494-4ac36445b5e6', 207.16),
('2b2a8d39-6e16-49cd-a4dc-597e727fad7f', 43.33),
('1961d61a-b940-4799-9d5d-d32b3c10a94d', 32.13),
('651b4f97-ea6f-484b-a9e8-f93eedc89fc4', 143.92),
('42374f8c-3a0d-415b-9fc5-f2ac810e2735', 13.35),
('a4f0fb0c-64bb-48ef-b5dc-808acd380606', 2.75),
('74c076ad-5e26-41fc-bab8-e9c4d2a78306', 153.36),
('38d1b3ef-8eba-4cc2-b3a8-85172d35abf2', 160),
('bb97e9c9-1c47-449e-b75d-227a9f81af7b', 359.29),
('212cb29d-191a-4252-b494-4ac36445b5e6', 216.52),
('a4f0fb0c-64bb-48ef-b5dc-808acd380606', 2.75),
('1961d61a-b940-4799-9d5d-d32b3c10a94d', 25.49),
('aa765c57-fad4-4c46-bdac-a1b5cf9e737f', 382.27),
('a2585ed6-33f3-4bad-b2dc-a6948afb4d90', 80),
('a4f0fb0c-64bb-48ef-b5dc-808acd380606', 2.75),
('baa96786-f053-49fb-99b5-1ac76699505f', 324),
('2b2a8d39-6e16-49cd-a4dc-597e727fad7f', 60),
('1961d61a-b940-4799-9d5d-d32b3c10a94d', 3.31),
('e850f1d4-3447-4e92-b72d-b8097d268ba4', 430),
('da4137d5-3eb6-4378-bd99-62fcb9a9f270', 291.33),
('e2fed62b-91ee-417e-9904-1e370f5b8756', 269.02),
('bc4c93de-d486-43f3-9cfd-8e7502fc5f75', 116.63),
('a79e3089-26e4-440f-8467-6bcf431876af', 60),
('1e2c7e12-f611-4d52-ac72-26a2e6d85f73', 294.57),
('20fc12ef-7d3d-4d72-a216-c6100a60c4eb', 393.18),
('aa765c57-fad4-4c46-bdac-a1b5cf9e737f', 382.27),
('7036ec6c-f895-48b6-9908-6c5b19e769a6', 3048.83),
('60e794c4-2100-45d8-91b7-1713e3dd3130', 9.83),
('8363118e-c60c-43fd-82ba-017c955ecd19', 95.98),
('a41d6b42-9955-4b3a-bc25-40563ad24304', 16.54),
('81500607-1c35-4276-9764-715f24504a8a', 1175),
('eab58b26-e7b5-4511-be83-0070cef53bd3', 8),
('0193a311-74b2-42cd-b61f-e98a3ecdc9cf', 54.82),
('bc4c93de-d486-43f3-9cfd-8e7502fc5f75', 10.7),
('efc2729b-4108-466d-80ee-6e32a82e6f88', 1039.2),
('1961d61a-b940-4799-9d5d-d32b3c10a94d', 21.67),
('cab2b98f-9b6b-442a-8d56-da6c8aa30795', 613.54),
('aa765c57-fad4-4c46-bdac-a1b5cf9e737f', 382.27),
('81500607-1c35-4276-9764-715f24504a8a', 905),
('2b6053e7-7238-4533-91b5-43ca71e9f59d', 20.92),
('11f14987-d165-449e-a84c-0707b4cfe1f2', 165.4),
('02f66641-2544-4796-a72b-ac6518ba9cbf', 251.32),
('311c203e-2eb0-4976-9a28-f29e01274057', 145.19),
('eab58b26-e7b5-4511-be83-0070cef53bd3', 220),
('bc4c93de-d486-43f3-9cfd-8e7502fc5f75', 16.05),
('56972e1b-b47c-496b-931c-4b026c28232e', 29),
('b031840b-f325-4c0e-a106-9aada0447744', 170.65),
('18776a49-5162-4c31-a636-cf59d1e363fc', 14),
('b84aca7a-6ca0-40a9-b509-66af4aa79cf3', 86.16),
('eb2fb5a1-e9c6-4dff-8b57-b93cb0a24f3f', 28.38),
('578a591d-c3c4-49db-89a2-90dccdb52dc0', 62.38),
('2b6053e7-7238-4533-91b5-43ca71e9f59d', 53.42),
('b9bf6b42-d06c-4696-b4e1-cccc247aa462', 880.02),
('db31f7a9-cccf-4ca9-b203-2388cec477ce', 179),
('568e4de1-dad3-4743-b2e5-5211ef5d3e0c', 535.18),
('909db6c4-c5bd-4c72-9014-af561a52a5ab', 8.91),
('a4f0fb0c-64bb-48ef-b5dc-808acd380606', 2.75),
('84b88dbb-4355-475b-a841-1ef425daadf9', 9.99),
('bc4c93de-d486-43f3-9cfd-8e7502fc5f75', 31.19),
('eac35ae6-4131-4016-85c0-b9908a6bf5ef', 299),
('7d1e7853-d80f-4067-bf36-20398ca57c26', 150.36),
('a8bac648-8600-465d-be34-0cf4589475f4', 2537.73),
('4141c727-63b5-4d40-a095-de67164f1cab', 1560),
('909db6c4-c5bd-4c72-9014-af561a52a5ab', 88.48),
('909db6c4-c5bd-4c72-9014-af561a52a5ab', 7.77),
('bc4c93de-d486-43f3-9cfd-8e7502fc5f75', 5.35),
('a48c1502-a0fd-44ff-9124-416174be63db', 94.6),
('eab58b26-e7b5-4511-be83-0070cef53bd3', 220),
('cc4c1888-0a7f-4d23-8747-c61e9fda821a', 36.38),
('243c1edf-828d-4bab-bd0f-009fa4fdb9d2', 451.03),
('bda9918f-dbe7-4e04-8284-6571124aff11', 208.44),
('a2585ed6-33f3-4bad-b2dc-a6948afb4d90', 80),
('2b2a8d39-6e16-49cd-a4dc-597e727fad7f', 41.49),
('a7183345-dcf9-42b1-af05-925085791da5', 131.7),
('47b3b5e0-5c48-4b21-859d-b3de62242d0f', 71),
('8e769fe6-cf94-4a9e-801a-66dffd7c33ea', 1500),
('aa765c57-fad4-4c46-bdac-a1b5cf9e737f', 382.27),
('ddd1d964-8bb7-4cb8-aaad-0ea77db88102', 90),
('a4f0fb0c-64bb-48ef-b5dc-808acd380606', 2.75),
('a2585ed6-33f3-4bad-b2dc-a6948afb4d90', 80),
('aa765c57-fad4-4c46-bdac-a1b5cf9e737f', 382.27),
('bc4c93de-d486-43f3-9cfd-8e7502fc5f75', 7.48),
('c059a785-9400-4710-9dab-9a991d4d1f7d', 14.99),
('bc4c93de-d486-43f3-9cfd-8e7502fc5f75', 35.02),
('212cb29d-191a-4252-b494-4ac36445b5e6', 213),
('fb77528a-5c76-40c1-8d69-b18508058050', 129.65),
('6b3c249c-a38e-4b56-b5ab-c780794c17db', 253.66),
('909db6c4-c5bd-4c72-9014-af561a52a5ab', 39.93),
('2b2a8d39-6e16-49cd-a4dc-597e727fad7f', 60),
('9ca00615-4b48-431a-b45d-a9c0df4a457f', 921.84),
('c4396e63-7ca9-4f91-81ca-a196ed1ecc5d', 507.49),
('1961d61a-b940-4799-9d5d-d32b3c10a94d', 100),
('ea2c06d4-bc3a-4e44-bea3-ecacb42c897b', 235),
('14cca7c4-cd57-4468-9afb-a7b9c64d6a35', 3500),
('2b2a8d39-6e16-49cd-a4dc-597e727fad7f', 60),
('51c2f436-a4e5-4409-9090-20cdbd19d0c1', 342.93),
('60e61530-9fbd-4341-8562-1b332aa65a8c', 29),
('bc4c93de-d486-43f3-9cfd-8e7502fc5f75', 16.95),
('6485cf0e-d842-4cb7-bd2b-b2fd1bf2b703', 69.95),
('aa765c57-fad4-4c46-bdac-a1b5cf9e737f', 382.27),
('909db6c4-c5bd-4c72-9014-af561a52a5ab', 9.08),
('32257ef5-ad39-4df9-919d-6aedd5e9607a', 111.54),
('02a348cc-329f-491b-ad40-998f0de973dc', 119.88),
('20fc12ef-7d3d-4d72-a216-c6100a60c4eb', 393.18),
('63a77321-05db-466d-b494-252d88f3e7ef', 17),
('dbd46217-8d50-43a5-b2b2-6460526b70f5', 724),
('e447f28a-c9bf-4066-9fd7-5010328b618e', 1471.16),
('06141fb0-ce4c-4838-99b2-1e7cf3cdde40', 26.02),
('aa765c57-fad4-4c46-bdac-a1b5cf9e737f', 16.85),
('a4f0fb0c-64bb-48ef-b5dc-808acd380606', 2.75),
('da4137d5-3eb6-4378-bd99-62fcb9a9f270', 235.49),
('bc4c93de-d486-43f3-9cfd-8e7502fc5f75', 13.77),
('a4f0fb0c-64bb-48ef-b5dc-808acd380606', 2.75),
('a2585ed6-33f3-4bad-b2dc-a6948afb4d90', 80),
('1ecca376-2e56-4a2e-a439-aa92108819d6', 1193.35),
('44041df7-999e-4788-91be-cb0287d447da', 186.86),
('140ab848-b2a4-4134-b73d-78e05031f9f2', 577.67),
('99d253db-4d4c-4084-8405-2facd7d4161e', 372.9),
('1961d61a-b940-4799-9d5d-d32b3c10a94d', 20.06),
('6cb44980-71b0-4843-928c-bda310fddb47', 35.96),
('8d115ae9-e604-43ba-8505-f6ecbff4625d', 34.64),
('81500607-1c35-4276-9764-715f24504a8a', 1175),
('909db6c4-c5bd-4c72-9014-af561a52a5ab', 6.77),
('134e4406-72f2-4e9b-adff-1408bf9aa359', 231.87),
('7069a3f8-a3a9-4b43-a610-4ca5ea7acf95', 152.41),
('a4f0fb0c-64bb-48ef-b5dc-808acd380606', 2.75),
('b858f93d-61e7-45c3-ba32-e29abec01101', 300.62),
('680bbe30-3952-4cdf-806e-8d0c1e742e02', 380.4),
('909db6c4-c5bd-4c72-9014-af561a52a5ab', 9.49),
('0f7e8477-d921-40bb-8e03-58f9fa31c86a', 335.39),
('909db6c4-c5bd-4c72-9014-af561a52a5ab', 12.87),
('a4f0fb0c-64bb-48ef-b5dc-808acd380606', 2.75),
('909db6c4-c5bd-4c72-9014-af561a52a5ab', 155.61),
('dfa080f7-2311-464c-b1e3-54c79479b3f6', 156.94),
('50dd3811-6eec-4feb-988b-a8ce8a7b9617', 110.96),
('909db6c4-c5bd-4c72-9014-af561a52a5ab', 11.19),
('a4f0fb0c-64bb-48ef-b5dc-808acd380606', 2.75),
('a4f0fb0c-64bb-48ef-b5dc-808acd380606', 2.75),
('a4f0fb0c-64bb-48ef-b5dc-808acd380606', 2.75),
('a4f0fb0c-64bb-48ef-b5dc-808acd380606', 2.75),
('8ad79d15-8af2-4dca-a34b-e0e650475779', 53.13),
('ad0b08be-2b39-4078-af26-22a6b730c268', 198.08),
('a4f0fb0c-64bb-48ef-b5dc-808acd380606', 2.75),
('991c5170-a0d2-4bf6-8d08-f8e347516a1c', 95),
('a15ee215-c382-46fe-a7a9-c90a6b8e0179', 75.9),
('2b2a8d39-6e16-49cd-a4dc-597e727fad7f', 82.91),
('266f64f7-739c-4f60-9240-61a7dbf63dc4', 11.96),
('bc4c93de-d486-43f3-9cfd-8e7502fc5f75', 2.88),
('b9bf6b42-d06c-4696-b4e1-cccc247aa462', 880.02),
('e879ecc5-a613-421b-85d4-07a05a259716', 15),
('39478e65-4f6d-4c0b-b225-33fd6f6a1fb0', 81.42),
('bc4c93de-d486-43f3-9cfd-8e7502fc5f75', 32.65),
('a2585ed6-33f3-4bad-b2dc-a6948afb4d90', 80),
('1961d61a-b940-4799-9d5d-d32b3c10a94d', 10.59),
('578a591d-c3c4-49db-89a2-90dccdb52dc0', 77.74),
('dc8d3b54-2b4a-41dd-8c22-bb068531da6f', 657.19),
('9656e000-c55c-4356-ac96-bd3fbd4e5362', 1344.35),
('fc5c8901-1865-4a67-9991-45d449bddaa2', 63.98),
('a4f0fb0c-64bb-48ef-b5dc-808acd380606', 2.75)


*/