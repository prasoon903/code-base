SELECT COUNT(1) FROM #TempData
SELECT COUNT(1) FROM #TempRecords

SELECT * INTO ##TempData FROM #TempData

DROP TABLE IF EXISTS #TempRecords
SELECT T1.*, B.acctID, RTRIM(AccountNumber) AccountNumber, CycleDueDTD, SystemStatus, ChargeOffDateParam, ChargeOffDate, 
ccinhparent125AID, ManualInitialChargeOffReason, 
TRY_CAST(NULL AS INT) FirstStatus, TRY_CAST(NULL AS DATETIME) StatusFirstApplied, TRY_CAST(NULL AS DATETIME) ExpectedCODate, TRY_CAST(NULL AS VARCHAR(50)) Reason
INTO #TempRecords
FROM #TempData T1
JOIN BSegment_Primary B WITH (NOLOCK) ON (T1.AccountUUID = B.UniversalUniqueID)
JOIN BSegmentCreditCard c WITH (NOLOCK) ON (B.acctID = C.acctID)

SELECT * FROM #TempRecords

SELECT * FROM CurrentBalanceAudit WITH (NOLOCK) WHERE AID = 305773 AND DENAME IN (114, 115) ORDER BY IdentityField DESC

SELECT CMTTranType,FeesAcctID, CPMGroup, TranTime, PostTime, TransactionDescription
FROM CCArd_Primary WITH (NOLOCK)
WHERE AccountNumber = '1100011194662353'
AND CMTTranType IN ('*SCR', '51', '54', 'RCLS')
ORDER BY PostTime DESC


DROP TABLE IF EXISTS #CCard
SELECT CP.AccountNumber, PostTime, CMTTRanType, TransactionAmount, TranID, TranRef, TxnSource, CP.Transactionidentifier,
rOW_NUMBER() OVER(PARTITION BY CP.AccountNumber, CP.CMTTRanType ORDER BY PostTime) Txn
INTO #CCard
FROM CCard_Primary CP WITH (NOLOCK)
JOIN #TempRecords T ON (T.AccountNumber = CP.AccountNumber)
WHERE CMTTranType IN ('RCLS', '51', '54')
AND CP.Transactionidentifier IS NULL

;WITH CTE
AS
(
	SELECT * FROM #CCard
)
, CORev
AS
(
	SELECT C1.*
	FROM CTE C1
	JOIN CTE C2 ON (C1.AccountNumber = C2.AccountNumber AND C1.CMTTRanType = '51' aND C2.CMTTRanType = '54' AND C1.Txn = C2.Txn)
)
, AllTxn
AS
(
	SELECT *, ROW_NUMBER() OVER(PARTITION BY AccountNumber, CMTTRanType ORDER BY PostTime) TxnCounter
	FROM CTE
	WHERE CMTTranType IN ('RCLS', '51')
	AND TranID NOT IN (SELECT TranID FROM CORev)
)
,
TxnData
AS
(
	SELECT C1.AccountNumber, C1.PostTime RCLSDate, C2.TransactionAmount OriginalCOAmount, 
	ROW_NUMBER() OVER(PARTITION BY C1.AccountNumber ORDER BY C1.PostTime DESC) RowCounter
	FROM AllTxn C1
	JOIN AllTxn C2 ON (C1.AccountNumber = C2.AccountNumber AND C1.CMTTRanType = 'RCLS' AND C2.CMTTRanType = '51')
	WHERE C1.TxnCounter = 1
	AND C2.TxnCounter = 1
)
UPDATE T
SET Reason = 'Reclass'
FROM #TempRecords T 
JOIN TxnData C ON (T.AccountNumber = C.AccountNumber)
WHERE RowCounter = 1

SELECT * FROM #TempRecords WHERE Reason IS NULL ORDER BY SN

DROP TABLE IF EXISTS #TempCCard
SELECT CP.AccountNumber, PostTime, CMTTRanType, TransactionAmount, TranID, TranRef, TxnSource, CP.Transactionidentifier,FeesAcctID StatusBefore, CPMGroup StatusAfter--,
--ROW_NUMBER() OVER(PARTITION BY CP.AccountNumber ORDER BY PostTime) TxnCount
INTO #TempCCard
FROM LS_P1MARPRODDB01.CCGS_CoreIssue.DBO.CCard_Primary CP WITH (NOLOCK)
JOIN #TempRecords T ON (T.AccountNumber = CP.AccountNumber)
WHERE CMTTranType IN ('RCLS', '51', '54', '*SCR')
AND T.Reason IS NULL

DROP TABLE IF EXISTS #CCard_Status
SELECT *, ROW_NUMBER() OVER(PARTITION BY AccountNumber ORDER BY PostTime) TxnCount
INTO #CCard_Status
FROM #TempCCard 
WHERE (CMTTranType = '*SCR' AND (StatusBefore = 16010 OR StatusAfter = 16010 OR StatusBefore = 5202 OR StatusAfter = 5202))
OR CMTTranType IN ('51', '54', 'RCLS')
ORDER BY AccountNumber, PostTime

;WITH CTE
AS
(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY AccountNumber ORDER BY TxnCount) RN 
FROM #CCard_Status WHERE 
CMTTranType = '*SCR' --AND
--AccountNumber = '1100011194662353'
)
UPDATE T
SET StatusFirstApplied = C.PostTime, FirstStatus = StatusAfter, ExpectedCODate = DATEADD(SS, 86395, TRY_CAST(TRY_CAST(EOMONTH(DATEADD(MM, 1, C.PostTime)) AS DATE) AS DATETIME))
FROM #TempRecords T
JOIN CTE C ON (T.AccountNumber = C.AccountNumber)
WHERE C.RN = 1

UPDATE #TempRecords SET Reason = 'Same group status applied on different dates' WHERE ExpectedCODate = ChargeOffDate AND Reason IS NULL

UPDATE #TempRecords 
SET StatusFirstApplied = '2023-12-21 06:12:27.000', FirstStatus = 16010, 
ExpectedCODate = DATEADD(SS, 86395, TRY_CAST(TRY_CAST(EOMONTH(DATEADD(MM, 1, '2023-12-21 06:12:27.000')) AS DATE) AS DATETIME))
WHERE SN = 33

UPDATE #TempRecords SET Reason = 'Same group status applied on different dates' WHERE ExpectedCODate = ChargeOffDate AND Reason IS NULL



SELECT *
FROM #TempCCard
WHERE AccountNumber = '1100011196782860'
ORDER BY PostTime DESC

SELECT * FROM #TempRecords WHERE Reason IS NULL

UPDATE #TempRecords SET Reason = 'CO contractually as this date fall prior to status' WHERE SN IN (32, 64) 

SELECT * FROM CurrentBalanceAudit WITH (NOLOCK) WHERE AID = 21898089 AND DENAME IN (114, 115) ORDER BY IdentityField DESC

SELECT * FROM #CCard_Status WHERE CMTTRanType = '*SCR'

SELECT AccountUUID,acctID,AccountNumber,CycleDueDTD,SystemStatus,ChargeOffDate,ccinhparent125AID,FirstStatus,StatusFirstApplied,ExpectedCODate,Reason FROM #TempRecords

DROP TABLE IF EXISTS #TempData
CREATE TABLE #TempData(SN DECIMAL(19, 0) IDENTITY(1, 1), AccountUUID VARCHAR(64))

INSERT INTO #TempData (AccountUUID) VALUES ('93938967-036b-40ab-8717-2dd346eacfbe' )
INSERT INTO #TempData (AccountUUID) VALUES ('6741cea1-6752-4a1d-96b9-394849db15d7' )
INSERT INTO #TempData (AccountUUID) VALUES ('7379ceea-2425-45c8-9ac8-7a209fe1bf74' )
INSERT INTO #TempData (AccountUUID) VALUES ('5681a075-fc39-45d0-8664-48b39c9ab0e8' )
INSERT INTO #TempData (AccountUUID) VALUES ('9889aa0e-7663-4397-aa3a-5b6f3a90d4f0' )
INSERT INTO #TempData (AccountUUID) VALUES ('0b33d05c-e211-412b-a126-defd18c71aaf' )
INSERT INTO #TempData (AccountUUID) VALUES ('66763313-9d82-48e6-ba71-71c27569386b' )
INSERT INTO #TempData (AccountUUID) VALUES ('96cbe71d-e1cf-449f-a016-385e3c15c97c' )
INSERT INTO #TempData (AccountUUID) VALUES ('e0a82d12-53bd-43d0-817a-51a7e75f61ea' )
INSERT INTO #TempData (AccountUUID) VALUES ('3df4c368-aee6-44ce-8a30-f28b715c1d86' )
INSERT INTO #TempData (AccountUUID) VALUES ('0e2ca8bf-fd07-4a90-9728-b5942185c543' )
INSERT INTO #TempData (AccountUUID) VALUES ('a748d0e1-2f0a-40cc-a72f-1f1bafde3a88' )
INSERT INTO #TempData (AccountUUID) VALUES ('cb157746-463c-42ed-b428-56958c87ffbf' )
INSERT INTO #TempData (AccountUUID) VALUES ('b3b2640c-7230-4135-9a5b-c8bc76476e51' )
INSERT INTO #TempData (AccountUUID) VALUES ('e1816ca5-71b7-4d65-acbe-e227005fdc89' )
INSERT INTO #TempData (AccountUUID) VALUES ('b44202dd-29e6-4625-b8b8-8da5e553ab82' )
INSERT INTO #TempData (AccountUUID) VALUES ('3ff4eca1-723a-4fcc-97ea-ae0abb213dcd' )
INSERT INTO #TempData (AccountUUID) VALUES ('6efe9b9a-f0c0-4006-86f6-73bbee98d86f' )
INSERT INTO #TempData (AccountUUID) VALUES ('b115e21c-7cdd-4e7f-a97c-7fc22bf7b6f0' )
INSERT INTO #TempData (AccountUUID) VALUES ('93d7dbad-eba3-47c3-8187-b09dc9e4cc2c' )
INSERT INTO #TempData (AccountUUID) VALUES ('4a6dcb03-bd1a-4c4e-b5ac-eb26642ee548' )
INSERT INTO #TempData (AccountUUID) VALUES ('c40f5a7b-341f-40ff-a6e1-8668e1e15dc3' )
INSERT INTO #TempData (AccountUUID) VALUES ('7c9e5f18-51f9-4bc5-b0fc-b179bfed0485' )
INSERT INTO #TempData (AccountUUID) VALUES ('32c72353-3396-4a2e-b034-ed3d59db1c59' )
INSERT INTO #TempData (AccountUUID) VALUES ('7a486953-7bde-4777-ac12-0e6c0c8a7d99' )
INSERT INTO #TempData (AccountUUID) VALUES ('8d9a33f2-48f0-4602-929a-1f04189095a7' )
INSERT INTO #TempData (AccountUUID) VALUES ('48b7c656-dacf-4399-aa5a-72bf42ddc947' )
INSERT INTO #TempData (AccountUUID) VALUES ('5b3337af-5235-41e7-82af-f097765ab7a2' )
INSERT INTO #TempData (AccountUUID) VALUES ('ba8fc84f-0fa9-4f14-b6e4-b87346ae098f' )
INSERT INTO #TempData (AccountUUID) VALUES ('1f001c64-e61c-439d-98ca-9095cf090665' )
INSERT INTO #TempData (AccountUUID) VALUES ('254fd031-1070-4f60-a9a1-df328a4f0d66' )
INSERT INTO #TempData (AccountUUID) VALUES ('c63d7c6d-8704-438c-b306-ae10b4ef0094' )
INSERT INTO #TempData (AccountUUID) VALUES ('f0566b22-75a9-447c-92c6-1ba7a4aed55c' )
INSERT INTO #TempData (AccountUUID) VALUES ('446af050-e3d7-4379-a7a5-e179df72efe7' )
INSERT INTO #TempData (AccountUUID) VALUES ('0dd4ade6-4f79-41b3-a48e-d89de749c954' )
INSERT INTO #TempData (AccountUUID) VALUES ('6569b562-3db6-4a9d-a7de-b058d3749bf5' )
INSERT INTO #TempData (AccountUUID) VALUES ('f08cf141-ebee-4851-9c62-95f9f2c28b36' )
INSERT INTO #TempData (AccountUUID) VALUES ('3d7d77c7-9219-4d93-8516-ef24cae9e5bb' )
INSERT INTO #TempData (AccountUUID) VALUES ('2cee442d-5f81-425f-8fcf-80cc6ea05c92' )
INSERT INTO #TempData (AccountUUID) VALUES ('300fdebb-0fed-4ebc-b58f-3819e383ff41' )
INSERT INTO #TempData (AccountUUID) VALUES ('bb763e0a-08f0-4246-9871-8b31379a31ef' )
INSERT INTO #TempData (AccountUUID) VALUES ('cfbcfb4e-d6e1-4327-ac00-a6325f484043' )
INSERT INTO #TempData (AccountUUID) VALUES ('0998f37d-cf18-4787-a614-8b87d68573b0' )
INSERT INTO #TempData (AccountUUID) VALUES ('cf6fc4ad-9010-4575-a9f4-2e72454e7b5f' )
INSERT INTO #TempData (AccountUUID) VALUES ('241c8c70-7d3c-4589-b860-a3ddaae4fb50' )
INSERT INTO #TempData (AccountUUID) VALUES ('1b6427f3-791c-4e2c-9068-453abc5cd4bb' )
INSERT INTO #TempData (AccountUUID) VALUES ('ce2005cb-3e71-4754-a701-7155137cdbf7' )
INSERT INTO #TempData (AccountUUID) VALUES ('3bdbafc8-0f3a-4c99-b7f4-746d37d409a8' )
INSERT INTO #TempData (AccountUUID) VALUES ('d6aaab43-78fe-4a09-838b-e644ee564a19' )
INSERT INTO #TempData (AccountUUID) VALUES ('6f81c526-7180-4900-bf38-c4ddc2269363' )
INSERT INTO #TempData (AccountUUID) VALUES ('deb2af57-1582-416d-84d1-41e476eaafcd' )
INSERT INTO #TempData (AccountUUID) VALUES ('a3f827f7-081b-4c5b-ba41-07bd164e4c24' )
INSERT INTO #TempData (AccountUUID) VALUES ('f1aebf44-6bb7-4b41-8f05-e8ef4d13b213' )
INSERT INTO #TempData (AccountUUID) VALUES ('9cba5c67-9524-40cb-9939-471582072c61' )
INSERT INTO #TempData (AccountUUID) VALUES ('3f0aa0e1-35df-4961-8374-e6276f1a8676' )
INSERT INTO #TempData (AccountUUID) VALUES ('0990f9ef-98a0-4311-9303-cd0c078eb677' )
INSERT INTO #TempData (AccountUUID) VALUES ('ec0b9d9e-8806-42f0-970a-620b4fa3ebaa' )
INSERT INTO #TempData (AccountUUID) VALUES ('89f23d5c-0dd5-4be8-9365-fb9fd88212ca' )
INSERT INTO #TempData (AccountUUID) VALUES ('71b01107-79aa-4be2-a38e-c194cd0d4f96' )
INSERT INTO #TempData (AccountUUID) VALUES ('73bae2b7-2c24-412d-9660-89ca8f5a3f40' )
INSERT INTO #TempData (AccountUUID) VALUES ('4b19955d-9d76-4336-8515-88931c02fb21' )
INSERT INTO #TempData (AccountUUID) VALUES ('a3369814-c635-4e11-b94c-ff6c40f515c1' )
INSERT INTO #TempData (AccountUUID) VALUES ('6603a987-9174-4a76-846d-80546256cd12' )
INSERT INTO #TempData (AccountUUID) VALUES ('b0febe6f-1fa0-47f0-813c-2666a86bc102' )
INSERT INTO #TempData (AccountUUID) VALUES ('1e45bb68-0fef-4bb8-a461-dc6225fbc628' )
INSERT INTO #TempData (AccountUUID) VALUES ('e38eaef7-f804-4658-9dc0-7971f75dadc0' )
INSERT INTO #TempData (AccountUUID) VALUES ('ad388a6e-cff4-4d16-a346-dc878c42f6bc' )
INSERT INTO #TempData (AccountUUID) VALUES ('746e90ab-a14e-4a8f-80dd-9f46831a6d94' )
INSERT INTO #TempData (AccountUUID) VALUES ('23767327-0706-42e7-879e-3426b4e4bd08' )
INSERT INTO #TempData (AccountUUID) VALUES ('0cc5240c-0b8f-4f7d-b77f-329fdf76dc0e' )
INSERT INTO #TempData (AccountUUID) VALUES ('d3c34a22-e9c8-4ae6-af88-27f28f58fc31' )
INSERT INTO #TempData (AccountUUID) VALUES ('d4c2277f-3762-47da-88a8-a3a5533e304d' )
INSERT INTO #TempData (AccountUUID) VALUES ('9dbb23a7-abcf-4907-adb1-cdbd3f8a1e13' )
INSERT INTO #TempData (AccountUUID) VALUES ('edfaa05d-14e2-494e-b07e-8a498b8403a0' )
INSERT INTO #TempData (AccountUUID) VALUES ('594df743-93e4-4fb6-9e7c-d48b3f09ed70' )
INSERT INTO #TempData (AccountUUID) VALUES ('286bdb23-78e4-4a89-a437-1ef8374ff942' )
INSERT INTO #TempData (AccountUUID) VALUES ('75121543-4c7a-42ae-82ad-62fc94a18b9c' )
INSERT INTO #TempData (AccountUUID) VALUES ('e61126d3-00dc-46ed-a314-8be39f306f01' )
INSERT INTO #TempData (AccountUUID) VALUES ('c9123e9b-5579-433e-bac9-40bd3cca19de' )
INSERT INTO #TempData (AccountUUID) VALUES ('c6bd0331-2d69-4bad-b0a1-80890ee9fd25' )
INSERT INTO #TempData (AccountUUID) VALUES ('b980a04c-7da8-4faa-976a-b83268178883' )
INSERT INTO #TempData (AccountUUID) VALUES ('010c0fed-689b-40ae-aff1-152a57b7c627' )
INSERT INTO #TempData (AccountUUID) VALUES ('cd856b99-8d36-4909-a591-1ac751d7e291' )
INSERT INTO #TempData (AccountUUID) VALUES ('6658e2e3-c697-41d6-9983-83767de5ebef' )
INSERT INTO #TempData (AccountUUID) VALUES ('cb5d6e97-8cae-4447-ae65-1d60884328ed' )
INSERT INTO #TempData (AccountUUID) VALUES ('b179f489-5b94-46bc-b37c-edefc9dbe1a1' )
INSERT INTO #TempData (AccountUUID) VALUES ('cf9e7cff-685e-4269-b147-6f3a67099471' )
