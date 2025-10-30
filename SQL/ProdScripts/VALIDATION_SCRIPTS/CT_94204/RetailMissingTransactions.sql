SELECT * FROm sys.servers

SELECT * FROM #CCard_NotFound

SELECT C.*, CP.TranID CCardTranID, CP.TransactionAmount CCardTxnAmount
FROM #CCard_NotFound C
JOIN CCard_Primary CP WITH (NOLOCK) ON (C.AccountNumber = CP.AccountNumber AND C.TransactionLifeCycleUniqueID = CP.TransactionLifeCycleUniqueID)
AND CMTTranType = '40'

SELECT transactionamount, TxnSource,authtranid,* 
FROM ccard_primary WITH (NOLOCK) 
WHERE AccountNumber = '1100011172524278' 
AND TransactionLifeCycleUniqueID = 2764588490 
ORDER BY PostTime DESC

--select top 10 * from auth_primary with (nolock) where txnsource in ('29') and messagetypeidentifier = '0220'

--SELECT request_id,* FROM LS_P1MARPRODDB01.CCGS_CoreAuth.DBO.RetailAPILog WITH(NOLOCK) WHERE AccountNumber = '1100011189323383' ORDER BY Skey DESC

--select * from monetaryTxnControl WITH (NOLOCK) WHERE TransactionCode = 18355

SELECT MessageTypeIdentifier, TxnSource,coreauthtranid, TransactionAmount,* 
FROM Auth_Primary WITH (NOLOCK) 
WHERE AccountNumber = '1100011127154197' 
AND TransactionLifeCycleUniqueID = 2647396275 
ORDER BY PostTime DESC

--select messagetypeidentifier, TransactionAmount,* from LS_P1MARPRODDB01.CCGS_CoreAuth.DBO.coreauthtransactions with (nolock) where TransactionLifeCycleUniqueID in (2647396275)

--select msgindicator, jobStatus, * from LS_P1MARPRODDB01.CCGS_CoreAuth.DBO.retailauthjobs with (nolock) where tranid in (2663696002)

--select msgindicator, jobStatus, * from LS_P1MARPRODDB01.CCGS_CoreAuth.DBO.retailauthjobs with (nolock) where TransactionLifeCycleUniqueID in ('2647396275')

SELECT A.MTI, AccountNumber, TransactionDescription,* 
FROM LS_P1MARPRODDB01.CCGS_CoreAuth.DBO.RetailAPILineItems A WITH (NOLOCK)
JOIN LS_P1MARPRODDB01.CCGS_CoreAuth.DBO.RetailAPILog B WITH (NOLOCK) ON (A.request_id = B.request_id)
--WHERE B.AccountNumber = '1100011113517233' 
WHERE A.uuid = '08032c34-7a25-45f3-90e1-0b52b0c3155d' 
--AND A.MTI = 9200


--08032c34-7a25-45f3-90e1-0b52b0c3155d
--116d5ff0-123c-4b94-9ddd-8b7ca13b2fb7
--a13eaede-f69e-456b-b7e3-a38dabc5b58b
--d09242c0-bc99-40e7-b546-5dda8ef294ad
--edd47723-69a6-42c4-bbc8-7df544c06ebd

--1561200669
--1561200668
--1100011113517233 

SELECT * FROM #TempData  

DROP TABLE IF EXISTS #TempData1
;WITH CTE
AS
(
SELECT *, ROW_NUMBER() OVER(PARTITION BY RMATranUUID ORDER BY ORDERID) [RowCount] FROM #TempData  
)
SELECT RmaTranUUID, OrderID, TransactionType
INTO #TempData1
FROM CTE
WHERE [RowCount] = 1



SELECT TransactionType, COUNT(1)
FROM #TempData1
GROUP BY TransactionType


SELECT TransactionType, RMATranUUID, COUNT(1)
FROM #TempData1
GROUP BY TransactionType, RMATranUUID
ORDER BY TransactionType


DROP TABLE IF EXISTS #RetailAuth
SELECT A.MTI, TRY_CAST(AccountNumber AS VARCHAR) AccountNumber, TranID CoreAuthTranID, A.Plan_ID, CP.EqualPayments, CPMDescription, Amount, OTB_Amount_Held,T.* 
INTO #RetailAuth
FROM LS_P1MARPRODDB01.CCGS_CoreAuth.DBO.RetailAPILineItems A WITH (NOLOCK)
JOIN LS_P1MARPRODDB01.CCGS_CoreAuth.DBO.RetailAPILog B WITH (NOLOCK) ON (A.request_id = B.request_id)
JOIN CPMAccounts CP WITH (NOLOCK) ON (CP.acctId = A.Plan_ID)
JOIN #TempData1 T ON (T.RMATranUUID = A.uuid /*AND A.MTI = 9200*/)
--WHERE CR_DR = 'DR'
ORDER BY A.uuid, A.MTI


SELECT RMATranUUID,COUNT(1)
FROM #RetailAuth
GROUP BY RMATranUUID


SELECT RMATranUUID, TransactionType, COUNT(1)
FROM #TempData1 T
--WHERE CR_DR = 'DR'
GROUP BY RMATranUUID, TransactionType


SELECT TransactionType, COUNT(1)
FROM #RetailAuth T
--WHERE CR_DR = 'DR'
GROUP BY TransactionType


DROP TABLE IF EXISTS #RecordNotFound
;WITH CTE AS
(
SELECT RMATranUUID, TransactionType,COUNT(1) [RecordCount]
FROM #RetailAuth
GROUP BY RMATranUUID, TransactionType
)
SELECT T.*
INTO #RecordNotFound
FROM #TempData1 T
LEFT JOIN CTE C ON (T.RMATranUUID = C.RMATranUUID AND T.TransactionType = C.TransactionType)
--WHERE T.CR_DR = 'DR'
WHERE C.RMATranUUID IS NULL AND C.TransactionType IS NULL

SELECT * FROM #RecordNotFound


SELECT TransactionType, COUNT(1) FROM #RecordNotFound GROUP BY TransactionType

SELECT * FROM #TempData1 WHERE RMATRanUUID = '29e969ba-02da-419f-a9e0-bda6efa8925d'
SELECT * FROM #RetailAuth WHERE RMATRanUUID = '29e969ba-02da-419f-a9e0-bda6efa8925d'


DROP TABLE IF EXISTS #TempRecords
;WITH CTE AS
(
SELECT RMATranUUID, TransactionType,COUNT(1) [RecordCount]
FROM #RetailAuth
GROUP BY RMATranUUID, TransactionType
)
SELECT T.*
INTO #TempRecords
FROM #TempData1 T
LEFT JOIN CTE C ON (T.RMATranUUID = C.RMATranUUID AND T.TransactionType = C.TransactionType)
--WHERE T.CR_DR = 'DR'
AND C.RMATranUUID IS NOT NULL AND C.TransactionType IS NOT NULL


SELECT * FROM #TempRecords

SELECT TransactionType, COUNT(1)
FROM #TempRecords
GROUP BY TransactionType


--DROP TABLE IF EXISTS #RetailAuth
--SELECT A.MTI, TRY_CAST(AccountNumber AS VARCHAR) AccountNumber, TranID CoreAuthTranID, A.Plan_ID, CP.EqualPayments, CPMDescription, Amount,T.* 
--INTO #RetailAuth
--FROM LS_P1MARPRODDB01.CCGS_CoreAuth.DBO.RetailAPILineItems A WITH (NOLOCK)
--JOIN LS_P1MARPRODDB01.CCGS_CoreAuth.DBO.RetailAPILog B WITH (NOLOCK) ON (A.request_id = B.request_id)
--JOIN CPMAccounts CP WITH (NOLOCK) ON (CP.acctId = A.Plan_ID)
--JOIN #TempData T ON (T.RMATranUUID = A.uuid /*AND A.MTI = 9200*/)
--WHERE CR_DR = 'DR'
--ORDER BY A.uuid, A.MTI

SELECT RMATranUUID, TransactionType, MTI, COUNT(1)
FROM #RetailAuth 
GROUP BY RMATranUUID, TransactionType, MTI
HAVING MTI = '9200'


SELECT TransactionType, MTI, COUNT(1)
FROM #RetailAuth 
GROUP BY TransactionType, MTI
HAVING MTI = '9200'

SELECT TransactionType, MTI, COUNT(1)
FROM #RetailAuth 
GROUP BY TransactionType, MTI
--HAVING MTI = '9100'
ORDER BY TransactionType


SELECT * FROM #RetailAuth ORDER BY RMATranUUID, MTI


--select messagetypeidentifier, TransactionAmount,* from LS_P1MARPRODDB01.CCGS_CoreAuth.DBO.coreauthtransactions with (nolock) where TransactionLifeCycleUniqueID in (1561200668)

--select msgindicator, jobStatus, * from LS_P1MARPRODDB01.CCGS_CoreAuth.DBO.retailauthjobs with (nolock) where tranid in (2647710009)

--select msgindicator, jobStatus, * from LS_P1MARPRODDB01.CCGS_CoreAuth.DBO.retailauthjobs with (nolock) where TransactionLifeCycleUniqueID in ('1561200668')

DROP TABLE IF EXISTS #MSMQError
SELECT JobStatus, R.*
INTO #MSMQError
FROM #RetailAuth R
LEFT JOIN LS_P1MARPRODDB01.CCGS_CoreAuth.DBO.retailauthjobs RJ ON (R.CoreAuthTranID = RJ.TranID)
WHERE R.MTI = '9200' 
AND RJ.TranID IS NULL 
--AND JobStatus <> 'Processed'

SELECT * FROm #MSMQError

SELECT ActivityType, COUNT(1)
FROM #MSMQError
GROUP BY ActivityType
 

DROP TABLE IF EXISTS #Auth_Primary
SELECT A.*, AP.TransactionAmount TransactionAmountOnAuth, TranID AuthTranID, TransactionLifeCycleUniqueID
INTO #Auth_Primary
FROM #RetailAuth A
JOIN Auth_Primary AP WITH (NOLOCK) ON (A.AccountNumber = AP.AccountNumber AND A.CoreAuthTranID = AP.CoreAuthTranID AND A.MTI = '9200')
--WHERE ActivityType <> 'MDR'


DROP TABLE IF EXISTS #CCard_Found
SELECT A.*, C.TxnAcctId, C.TranID, C.TranTime, C.PostTime, C.ArTxnType
INTO #CCard_Found
FROM CCard_Primary C WITH (NOLOCK)
JOIN #Auth_Primary A ON (C.AccountNumber = A.AccountNumber AND C.AuthTranID = A.AuthTranID)


DROP TABLE IF EXISTS #CCard_NotFound
SELECT A.*
INTO #CCard_NotFound
FROM CCard_Primary C WITH (NOLOCK)
RIGHT JOIN #Auth_Primary A ON (C.AccountNumber = A.AccountNumber AND C.AuthTranID = A.AuthTranID)
WHERE C.AccountNumber IS NULL AND C.AuthTranID IS NULL


SELECT * FROM #CCard_Found WHERE ActivityType <> 'Credit'

SELECT * FROM #CCard_NotFound WHERE ActivityType <> 'Credit'


DROP TABLE IF EXISTS #ILPFound
SELECT ILPS.PlanUUID, ILPS.ScheduleID, C.* 
INTO #ILPFound
FROM #CCard_Found C
LEFT JOIN ILPScheduleDetailSummary ILPS WITH (NOLOCK) ON (C.TxnAcctId = ILPS.PlanID)
WHERE ILPS.Activity = 1
AND ILPS.PlanID IS NOT NULL


SELECT TransactionType, COUNT(1)
FROM #ILPFound
GROUP BY TransactionType




DROP TABLE IF EXISTS #TempData
--CREATE TABLE #TempData (AccountUUID VARCHAR(64), Type VARCHAR(5), RMATranUUID VARCHAR(64), TransactionAmount MONEY, Installment INT)
--CREATE TABLE #TempData (CR_DR VARCHAR(10), TransactionAmount MONEY, ActivityType VARCHAR(20), RMATranUUID VARCHAR(64), FileName VARCHAR(20))
--CREATE TABLE #TempData (RMATranUUID VARCHAR(64), OrderID VARCHAR(20), TransactionType VARCHAR(20))

CREATE TABLE #TempData (Origin VARCHAR(64),Settle_Date DATETIME,Radar VARCHAR(64),Transcode VARCHAR(64),RMATranUUID VARCHAR(64),OrderID VARCHAR(64),TransactionType VARCHAR(64),GROUP_ID VARCHAR(64),REFERENCE_ID VARCHAR(64))

INSERT INTO #TempData VALUES ('Saturn','10/18/2022','89353262', NULL,'08032c34-7a25-45f3-90e1-0b52b0c3155d','W1022149394','RetailPurchase','cf226529-e034-4c0d-8e8b-7bd2be792da6','443D200A-9786-41C6-A1BD-B857132F7E4C')
INSERT INTO #TempData VALUES ('CoreCard','10/18/2022','89353262','F4001','08032c34-7a25-45f3-90e1-0b52b0c3155d','W1022149394','RetailPurchase','cf226529-e034-4c0d-8e8b-7bd2be792da9','443D200A-9786-41C6-A1BD-B857132F7E4C')
INSERT INTO #TempData VALUES ('Saturn','10/1/2022','89353262', NULL,'168dbdf3-346f-4f31-bd43-168b01e516d2','W1032350004','RetailPurchase','f8f1abb7-534e-47dd-800f-8e0e60195aa3','E7233160-BCCC-4631-B9E7-78CB9CDC01DC')
INSERT INTO #TempData VALUES ('CoreCard','10/1/2022','89353262','F4001','168dbdf3-346f-4f31-bd43-168b01e516d2','W1032350004','RetailPurchase','f8f1abb7-534e-47dd-800f-8e0e60195aa3','E7233160-BCCC-4631-B9E7-78CB9CDC01DC')
INSERT INTO #TempData VALUES ('Saturn','9/27/2022','89353262', NULL,'edd47723-69a6-42c4-bbc8-7df544c06ebd','W1038539450','RetailPurchase','341e358d-2290-4c07-abf4-192df7ae8c7e','3E607C3F-29D7-42C7-BF15-05F5D18E5669')
INSERT INTO #TempData VALUES ('CoreCard','9/27/2022','89353262','F4001','edd47723-69a6-42c4-bbc8-7df544c06ebd','W1038539450','RetailPurchase','341e358d-2290-4c07-abf4-192df7ae8c7e','3E607C3F-29D7-42C7-BF15-05F5D18E5669')
INSERT INTO #TempData VALUES ('Saturn','10/7/2022','89353262', NULL,'54d86c18-1f1b-4a98-b5df-5470971e885b','W1090597700','RetailPurchase','ee29ad40-7ad7-4ab7-ac53-ff12b9219750','46E9211D-45FD-4192-8014-A54395F07ACD')
INSERT INTO #TempData VALUES ('Saturn','10/7/2022','89353262', NULL,'30092cbc-422d-4bb1-81ed-cc82f994fc6c','W1090597700','CashPurchase','ee29ad40-7ad7-4ab7-ac53-ff12b9219750','46E9211D-45FD-4192-8014-A54395F07ACD')
INSERT INTO #TempData VALUES ('Saturn','10/7/2022','89353262', NULL,'a2b8652e-eb1c-44d7-b3c0-0fe7efc2ba73','W1091043664','RetailPurchase','d35dc7fb-512a-48ac-ad55-be153615c916','C7728A22-F947-4197-B120-6186BFF2D538')
INSERT INTO #TempData VALUES ('Saturn','10/7/2022','89353262', NULL,'cb9ebb81-9527-4abb-879e-713e86e7e53d','W1091043664','CashPurchase','d35dc7fb-512a-48ac-ad55-be153615c916','C7728A22-F947-4197-B120-6186BFF2D538')
INSERT INTO #TempData VALUES ('Saturn','10/7/2022','89353262', NULL,'9bf186e3-b1c4-4ce6-b57e-8533e1f1070d','W1107669572','RetailPurchase','cb467a09-91e9-44af-8ea3-0ecf405eaacd','19F8A429-0BBE-4606-81A3-BC41A1E0A4EE')
INSERT INTO #TempData VALUES ('Saturn','10/7/2022','89353262', NULL,'eea3ef23-f852-4444-b468-4dd6dc8860ee','W1107669572','RetailPurchase','cb467a09-91e9-44af-8ea3-0ecf405eaacd','19F8A429-0BBE-4606-81A3-BC41A1E0A4EE')
INSERT INTO #TempData VALUES ('Saturn','10/7/2022','89353262', NULL,'8595f931-7c89-4131-a5de-24dd1525588c','W1107669572','CashPurchase','cb467a09-91e9-44af-8ea3-0ecf405eaacd','19F8A429-0BBE-4606-81A3-BC41A1E0A4EE')
INSERT INTO #TempData VALUES ('Saturn','9/16/2022','89353262', NULL,'bfd881f1-f32d-450f-9102-64c0b522dc52','W1152049116','RetailPurchase','180e2bf4-ea12-43a7-accc-2de8a68a462e','0E5F1D15-FBA2-43C1-A510-C6382593B984')
INSERT INTO #TempData VALUES ('Saturn','10/7/2022','89353262', NULL,'02d20cfb-5630-4298-a102-8d2973df9d8a','W1182983852','RetailPurchase','5dc3ed85-2e20-4533-a27b-1997e892bdde','13493213-B254-44F8-B560-6BF67639664E')
INSERT INTO #TempData VALUES ('Saturn','10/7/2022','89353262', NULL,'29e969ba-02da-419f-a9e0-bda6efa8925d','W1182983852','CashPurchase','5dc3ed85-2e20-4533-a27b-1997e892bdde','13493213-B254-44F8-B560-6BF67639664E')
INSERT INTO #TempData VALUES ('Saturn','10/7/2022','89353262', NULL,'e85e64d7-78d9-4dc0-8ede-e4100004109d','W1217628467','RetailPurchase','7b424381-bc83-4943-adbe-60949ac1a12d','3B804401-C6B4-4F4C-A7EC-19D6BC782B15')
INSERT INTO #TempData VALUES ('Saturn','10/7/2022','89353262', NULL,'b05630d1-393c-472f-880d-063e73a38b4c','W1217628467','CashPurchase','7b424381-bc83-4943-adbe-60949ac1a12d','3B804401-C6B4-4F4C-A7EC-19D6BC782B15')
INSERT INTO #TempData VALUES ('Saturn','9/15/2022','89353262', NULL,'7d65ee77-2b90-4b66-bfca-19255db862cf','W1221784546','RetailPurchase','c5403eb4-f85c-40f3-b036-261b21ff5320','2A1A4B3D-3B2D-4969-BFA0-AEC21B7EA97B')
INSERT INTO #TempData VALUES ('CoreCard','9/15/2022','89353262','F4001','7d65ee77-2b90-4b66-bfca-19255db862cf','W1221784546','RetailPurchase','c5403eb4-f85c-40f3-b036-261b21ff5320','2A1A4B3D-3B2D-4969-BFA0-AEC21B7EA97B')
INSERT INTO #TempData VALUES ('Saturn','9/21/2022','89353262', NULL,'d09242c0-bc99-40e7-b546-5dda8ef294ad','W1245019152','RetailPurchase','a657d0da-2309-4966-8c67-5ff0cc142ef0','75C01F1A-E13A-4334-B47D-C6FA36EE785C')
INSERT INTO #TempData VALUES ('CoreCard','9/21/2022','89353262','F4001','d09242c0-bc99-40e7-b546-5dda8ef294ad','W1245019152','RetailPurchase','a657d0da-2309-4966-8c67-5ff0cc142ef0','75C01F1A-E13A-4334-B47D-C6FA36EE785C')
INSERT INTO #TempData VALUES ('Saturn','10/7/2022','89353262', NULL,'309bbd54-d37e-47f6-a6d2-fab1407cba0d','W1260311096','RetailPurchase','f61c4173-fad2-46b6-ab34-62ca073fe98c','27D62D6F-438E-4A3A-B266-E01F520B550A')
INSERT INTO #TempData VALUES ('Saturn','10/7/2022','89353262', NULL,'866b43db-4bb4-49b4-8489-8f1c7150838d','W1260311096','CashPurchase','f61c4173-fad2-46b6-ab34-62ca073fe98c','27D62D6F-438E-4A3A-B266-E01F520B550A')
INSERT INTO #TempData VALUES ('Saturn','10/8/2022','89353262', NULL,'116d5ff0-123c-4b94-9ddd-8b7ca13b2fb7','W1272040892','RetailPurchase','dfe7aab5-eb0a-4b9b-8089-71838f05af60','D6AC83DC-D2F0-4030-A98B-091C02CDA7A6')
INSERT INTO #TempData VALUES ('Saturn','10/8/2022','89353262', NULL,'a13eaede-f69e-456b-b7e3-a38dabc5b58b','W1272040892','CashPurchase','dfe7aab5-eb0a-4b9b-8089-71838f05af60','D6AC83DC-D2F0-4030-A98B-091C02CDA7A6')
INSERT INTO #TempData VALUES ('Saturn','10/13/2022','89353262', NULL,'a13eaede-f69e-456b-b7e3-a38dabc5b58b','W1272040892','CashPurchaseReturn','dfe7aab5-eb0a-4b9b-8089-71838f05af60','D6AC83DC-D2F0-4030-A98B-091C02CDA7A6')
INSERT INTO #TempData VALUES ('Saturn','11/30/2022','89353262', NULL,'a8c0f242-7e8d-4c8b-8622-e357d251f674','W1185872017','CashPurchase','41cca056-b1ad-45f9-b968-31bec60e3b0d','870CC426-8563-4B9C-A3A0-E54158CB7DB1')