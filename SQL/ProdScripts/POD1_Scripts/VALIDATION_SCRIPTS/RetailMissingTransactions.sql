SELECT transactionamount, TxnSource,authtranid,* 
FROM ccard_primary WITH (NOLOCK) 
WHERE AccountNumber = '1100011113517233' 
AND TransactionLifeCycleUniqueID = 1561200670 
ORDER BY PostTime DESC
select top 10 * from auth_primary with (nolock) where txnsource in ('29') and messagetypeidentifier = '0220'

SELECT request_id,* FROM LS_P1MARPRODDB01.CCGS_CoreAuth.DBO.RetailAPILog WITH(NOLOCK) WHERE AccountNumber = '1100011189323383' ORDER BY Skey DESC
select * from monetaryTxnControl WITH (NOLOCK) WHERE TransactionCode = 18355
SELECT MessageTypeIdentifier, TxnSource,coreauthtranid,* 
FROM Auth_Primary WITH (NOLOCK) 
WHERE AccountNumber = '1100011113517233' 
AND TransactionLifeCycleUniqueID = 1561200669 
ORDER BY PostTime DESC

select messagetypeidentifier, TransactionAmount,* from LS_P1MARPRODDB01.CCGS_CoreAuth.DBO.coreauthtransactions with (nolock) where TransactionLifeCycleUniqueID in (1561200668)

select msgindicator, jobStatus, * from LS_P1MARPRODDB01.CCGS_CoreAuth.DBO.retailauthjobs with (nolock) where tranid in (1563766211)

select msgindicator, jobStatus, * from LS_P1MARPRODDB01.CCGS_CoreAuth.DBO.retailauthjobs with (nolock) where TransactionLifeCycleUniqueID in ('1561200668')

SELECT A.MTI, TransactionDescription,* 
FROM LS_P1MARPRODDB01.CCGS_CoreAuth.DBO.RetailAPILineItems A WITH (NOLOCK)
JOIN LS_P1MARPRODDB01.CCGS_CoreAuth.DBO.RetailAPILog B WITH (NOLOCK) ON (A.request_id = B.request_id)
WHERE B.AccountNumber = '1100011113517233' 
AND A.uuid = 'fdfb2ce5-9974-4c8d-a1fa-a7ee0a607d10' 
AND A.MTI = 9200

1561200669
1561200668
1100011113517233   


SELECT T.*, BP.acctId, BP.AccountNumber 
FROM #TempData T
LEFT JOIN BSegment_Primary BP with (NOLOCK) ON (T.AccountUUID = BP.UniversaluniqueID)
WHERE type = 'DR' AND RMATranUUID <> '' AND BP.AccountNumber IS NULL

;WITH CTE
AS
(
SELECT T.*, BP.acctId, BP.AccountNumber 
FROM #TempData T
JOIN BSegment_Primary BP with (NOLOCK) ON (T.AccountUUID = BP.UniversaluniqueID)
--WHERE type = 'DR' AND RMATranUUID <> ''
)
SELECT A.MTI, TranID CoreAuthTranID, A.Plan_ID, CP.EqualPayments, CPMDescription, Amount,C.* 
FROM LS_P1MARPRODDB01.CCGS_CoreAuth.DBO.RetailAPILineItems A WITH (NOLOCK)
JOIN LS_P1MARPRODDB01.CCGS_CoreAuth.DBO.RetailAPILog B WITH (NOLOCK) ON (A.request_id = B.request_id)
JOIN CPMAccounts CP WITH (NOLOCK) ON (CP.acctId = A.Plan_ID)
JOIN CTE C ON (C.AccountNumber = B.AccountNumber AND C.RMATranUUID = A.uuid /*AND A.MTI = 9200*/)
ORDER BY A.uuid, A.MTI

--fdfb2ce5-9974-4c8d-a1fa-a7ee0a607d10


;WITH CTE
AS
(
SELECT T.*, BP.acctId, BP.AccountNumber 
FROM #TempData T
JOIN BSegment_Primary BP with (NOLOCK) ON (T.AccountUUID = BP.UniversaluniqueID)
--WHERE type = 'DR' AND Installment = 0
)
SELECT A.MTI, TranID CoreAuthTranID, A.Plan_ID, CP.EqualPayments, CPMDescription, Amount,C.* 
FROM LS_P1MARPRODDB01.CCGS_CoreAuth.DBO.RetailAPILineItems A WITH (NOLOCK)
JOIN LS_P1MARPRODDB01.CCGS_CoreAuth.DBO.RetailAPILog B WITH (NOLOCK) ON (A.request_id = B.request_id)
JOIN CPMAccounts CP WITH (NOLOCK) ON (CP.acctId = A.Plan_ID)
JOIN CTE C ON (C.AccountNumber = B.AccountNumber AND C.RMATranUUID = A.uuid /*AND A.MTI = 9200*/)
ORDER BY A.uuid, A.MTI



;WITH CTE
AS
(
SELECT T.*, BP.acctId, BP.AccountNumber 
FROM #TempData T
JOIN BSegment_Primary BP with (NOLOCK) ON (T.AccountUUID = BP.UniversaluniqueID)
WHERE type = 'DR' AND Installment = 1
),
RetailAuth
AS
(
SELECT A.MTI, TranID CoreAuthTranID,C.* 
FROM LS_P1MARPRODDB01.CCGS_CoreAuth.DBO.RetailAPILineItems A WITH (NOLOCK)
JOIN LS_P1MARPRODDB01.CCGS_CoreAuth.DBO.RetailAPILog B WITH (NOLOCK) ON (A.request_id = B.request_id)
JOIN CTE C ON (C.AccountNumber = B.AccountNumber AND C.RMATranUUID = A.uuid AND A.MTI = 9200)
--ORDER BY A.uuid, A.MTI
),
Auth
AS
(
SELECT A.*, AP.TransactionAmount TransactionAmountOnAuth, TranID AuthTranID, TransactionLifeCycleUniqueID
FROM RetailAuth A
JOIN Auth_Primary AP WITH (NOLOCK) ON (A.AccountNumber = AP.AccountNumber AND A.CoreAuthTranID = AP.CoreAuthTranID)
)
SELECT A.*, C.TxnAcctId
FROM CCard_Primary C WITH (NOLOCK)
JOIN Auth A ON (C.AccountNumber = A.AccountNumber AND C.AuthTranID = A.AuthTranID)




;WITH CTE
AS
(
SELECT T.*, BP.acctId, BP.AccountNumber 
FROM #TempData T
JOIN BSegment_Primary BP with (NOLOCK) ON (T.AccountUUID = BP.UniversaluniqueID)
--WHERE type = 'DR' AND Installment = 1
),
RetailAuth
AS
(
SELECT A.MTI, TranID CoreAuthTranID,C.* 
FROM LS_P1MARPRODDB01.CCGS_CoreAuth.DBO.RetailAPILineItems A WITH (NOLOCK)
JOIN LS_P1MARPRODDB01.CCGS_CoreAuth.DBO.RetailAPILog B WITH (NOLOCK) ON (A.request_id = B.request_id)
JOIN CTE C ON (C.AccountNumber = B.AccountNumber AND C.RMATranUUID = A.uuid AND A.MTI = 9200)
--ORDER BY A.uuid, A.MTI
),
Auth
AS
(
SELECT A.*, AP.TransactionAmount TransactionAmountOnAuth, TranID AuthTranID, TransactionLifeCycleUniqueID
FROM RetailAuth A
JOIN Auth_Primary AP WITH (NOLOCK) ON (A.AccountNumber = AP.AccountNumber AND A.CoreAuthTranID = AP.CoreAuthTranID)
)
SELECT A.*, C.TxnAcctId
FROM CCard_Primary C WITH (NOLOCK)
RIGHT JOIN Auth A ON (C.AccountNumber = A.AccountNumber AND C.AuthTranID = A.AuthTranID)
WHERE C.AuthTranID IS NULL




;WITH CTE
AS
(
SELECT T.*, BP.acctId, BP.AccountNumber 
FROM #TempData T
JOIN BSegment_Primary BP with (NOLOCK) ON (T.AccountUUID = BP.UniversaluniqueID)
WHERE type = 'DR' AND Installment = 0
),
RetailAuth
AS
(
SELECT A.MTI, TranID CoreAuthTranID,C.* 
FROM LS_P1MARPRODDB01.CCGS_CoreAuth.DBO.RetailAPILineItems A WITH (NOLOCK)
JOIN LS_P1MARPRODDB01.CCGS_CoreAuth.DBO.RetailAPILog B WITH (NOLOCK) ON (A.request_id = B.request_id)
JOIN CTE C ON (C.AccountNumber = B.AccountNumber AND C.RMATranUUID = A.uuid AND A.MTI = 9200)
--ORDER BY A.uuid, A.MTI
),
Auth
AS
(
SELECT A.*, AP.TransactionAmount TransactionAmountOnAuth, TranID AuthTranID, TransactionLifeCycleUniqueID
FROM RetailAuth A
JOIN Auth_Primary AP WITH (NOLOCK) ON (A.AccountNumber = AP.AccountNumber AND A.CoreAuthTranID = AP.CoreAuthTranID)
)
SELECT A.*, C.TxnAcctId
FROM CCard_Primary C WITH (NOLOCK)
RIGHT JOIN Auth A ON (C.AccountNumber = A.AccountNumber AND C.AuthTranID = A.AuthTranID)
WHERE C.AuthTranID IS NULL







SELECT A.MTI, TransactionDescription,* 
FROM LS_P1MARPRODDB01.CCGS_CoreAuth.DBO.RetailAPILineItems A WITH (NOLOCK)
JOIN LS_P1MARPRODDB01.CCGS_CoreAuth.DBO.RetailAPILog B WITH (NOLOCK) ON (A.request_id = B.request_id)
WHERE B.AccountNumber = '1100011189323383' 
AND A.uuid = '94888299-5d5f-4667-9025-4d5a506ecfd1' 
AND A.MTI = 9200

DROP TABLE IF EXISTS #TempData
CREATE TABLE #TempData (AccountUUID VARCHAR(64), Type VARCHAR(5), RMATranUUID VARCHAR(64), TransactionAmount MONEY, Installment INT)

INSERT INTO #TempData VALUES ('e6285137-3fa0-4e1c-b131-71b32ca0a55c', 'DR', 'ef2a0871-0c65-416d-82cf-e19464556ffd', 269.00, 1)
INSERT INTO #TempData VALUES ('e6285137-3fa0-4e1c-b131-71b32ca0a55c', 'DR', 'fdfb2ce5-9974-4c8d-a1fa-a7ee0a607d10', 158.08, 0)
INSERT INTO #TempData VALUES ('e6285137-3fa0-4e1c-b131-71b32ca0a55c', 'DR', '16a3ed9b-0f2e-4d3f-b458-6dc0866a9920', 1599.00, 1)
INSERT INTO #TempData VALUES ('0d94258e-4d9f-4a26-865e-4a8e62e3d3d5', 'DR', '8423b045-b1ed-4b31-82a9-6669fa0ea688', 15.83, 0)
INSERT INTO #TempData VALUES ('dabd3526-3e1a-4937-92eb-efafef26053e', 'DR', '94888299-5d5f-4667-9025-4d5a506ecfd1', 529.00, 1)
--INSERT INTO #TempData VALUES ('dabd3526-3e1a-4937-92eb-efafef26053e', 'CR', '94888299-5d5f-4667-9025-4d5a506ecfd1', -49.00, 1)
INSERT INTO #TempData VALUES ('12e60c6d-5139-434e-996c-8c8a1dbc9825', 'DR', '32757ba1-791d-49cc-abb3-004a1ed251e5', 129.00, 1)
INSERT INTO #TempData VALUES ('12e60c6d-5139-434e-996c-8c8a1dbc9825', 'DR', 'c65a168e-5d88-408b-8ad1-d57d34836b84', 59.00, 1)
INSERT INTO #TempData VALUES ('7ef1b768-3e64-4fa1-aaf2-6877410d4270', 'DR', '4f3fb242-830b-4dd1-a31c-3cdc7a417c3a', 309.00, 1)
INSERT INTO #TempData VALUES ('64916b01-73f7-42af-8c4d-75d5e0da8682', 'DR', '28b2e223-dce1-4e45-bf8d-46f7ca163c90', 309.00, 1)
INSERT INTO #TempData VALUES ('4b6c0ec1-16c9-403c-9f09-7dfb896fb2ff', 'DR', 'acaf3359-00a7-46ba-8bd6-0f0f8a714c45', 479.00, 1)
INSERT INTO #TempData VALUES ('55ac8356-b8bf-4ce6-b8f9-293b92bbb3ee', 'DR', '09ec1199-b888-42c0-b2e5-7c85db7a8a0c', 479.00, 1)
INSERT INTO #TempData VALUES ('c4bdd663-aca1-4fed-a655-ae6d3039439f', 'DR', 'bec546e7-085d-4d5a-91ae-5303dc9257ce', 549.00, 1)
--INSERT INTO #TempData VALUES ('5e91820e-faa5-4a90-9b3d-976235d15fe3', 'CR', 'e5dfb652-ba08-405b-a5c3-4cc61227313d', -999.00, 1)
--INSERT INTO #TempData VALUES ('39f4c22a-9990-40c6-984c-7b494e848cbe', 'CR', 'eb01d508-dff3-4546-be02-f1425370a542', -129.00, 1)
--INSERT INTO #TempData VALUES ('39f4c22a-9990-40c6-984c-7b494e848cbe', 'CR', '', -7.74, 0)
--INSERT INTO #TempData VALUES ('cff207d0-cac4-4ad1-88a2-78ab606c3776', 'CR', '', -47.41, 0)
--INSERT INTO #TempData VALUES ('6b66ed8d-54c3-4eaa-9c60-b8d88f1c4af3', 'CR', '3bab2bfb-c584-4764-9ee8-f450fdd59588', -2399.00, 1)
--INSERT INTO #TempData VALUES ('6b66ed8d-54c3-4eaa-9c60-b8d88f1c4af3', 'CR', '', -212.91, 0)