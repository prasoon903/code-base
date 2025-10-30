SELECT * INTO ##TempData FROM #TempData

DROP TABLE IF EXISTS #CO_Decd
SELECT T1.*, B.acctID, AccountNumber, CycleDueDTD, SystemStatus, ChargeOffDateParam, ccinhparent125AID, ManualInitialChargeOffReason
, 0 DecdApplied, TRY_CAST(NULL AS DATETIME) ChargeOffDatePosted, --TRY_CAST(NULL AS DATETIME) TentativeCODate,
0 StatusBeforeCO, TRY_CAST(NULL AS DATETIME) StatusBeforeCOSetDate, 0 DPDAtCO
INTO #CO_Decd
FROM #TempData T1
JOIN BSegment_Primary B WITH (NOLOCK) ON (T1.AccountUUID = B.UniversalUniqueID)
JOIN BSegmentCreditCard c WITH (NOLOCK) ON (B.acctID = C.acctID)

SELECT * FROM #CO_Decd

DROP TABLE IF EXISTS #CO_Decd_StatusHistory
SELECT C.AccountNumber, BSAcctID, FeesAcctID StatusBefore, CPMGroup StatusAfter, TranTime, PostTime, CMTTranType, 
ROW_NUMBER() OVER(PARTITION BY C.AccountNumber, CMTTRanType ORDER BY TranTime) StatusCount
INTO #CO_Decd_StatusHistory
FROM CCard_Primary C WITH (NOLOCK)
JOIN #CO_Decd T1 ON (C.AccountNumber = T1.AccountNumber)
WHERE CMTTranType IN ('51', '54', 'RCLS', '*SCR')

SELECT * FROM #CO_Decd_StatusHistory WHERE AccountNumber = '1100011104418490' ORDER BY PostTime DESC

UPDATE #CO_Decd SET DecdApplied = 1
WHERE AccountNumber IN (SELECT DISTINCT AccountNumber FROM #CO_Decd_StatusHistory 
WHERE CMTTranType = '*SCR' 
AND (StatusBefore = 5211 OR StatusAfter = 5211))

UPDATE T1 
SET ChargeOffDatePosted = TRY_CAST(T2.PostTime AS DATE)
--,TentativeCODate = CASE WHEN TRY_CAST(T2.PostTime AS DATE) > STATUS_APPLY_DATE THEN EOMONTH(STATUS_APPLY_DATE) ELSE NULL END
FROM #CO_Decd T1
JOIN #CO_Decd_StatusHistory T2 ON (T1.AccountNumber = T2.AccountNumber AND CMTTranType = '51' AND StatusCount = 1)
WHERE T1.DecdApplied = 1

SELECT T1.*, T2.PostTime ChargeOffDatePosted
FROM #CO_Decd T1
JOIN #CO_Decd_StatusHistory T2 ON (T1.AccountNumber = T2.AccountNumber AND CMTTranType = '51' AND StatusCount = 1)
WHERE T1.DecdApplied = 1

--AccountUUID	acctID	AccountNumber	CycleDueDTD	SystemStatus	ChargeOffDateParam
--a7bb7929-90b0-4645-bae4-d3fc4411e868	17736591	1100011179076710   	0	2	2022-08-31 23:59:55.000
----db308f50-97df-4d28-aeeb-3b8b10e02ba9	489655	1100011104854686   	0	2	2023-02-28 23:59:55.000
--b2dc1a9c-4ca7-44ca-b013-80c9a06019e0	2251218	1100011122461969   	0	2	2022-05-31 23:59:55.000
--customer--6c59e970-a4ff-460f-b982-5ac2173924b3	17304137	1100011175262694   	0	2	NULL
--reported--c1c591f3-cdf0-4c67-8655-b48a1f959f27	2811762	1100011128249871   	0	2	2022-05-31 23:59:55.000
--reported--51586a8e-f36c-4137-a2e5-93641633477e	11162416	1100011148501350   	0	2	2022-08-31 23:59:55.000
--580fbc34-b509-4d2b-8d40-87d936f4b593	21776320	1100011204260149   	6	15991	NULL
--4e3da579-d4bd-4da9-97fc-f87fae452159	446036	1100011104418490   	0	2	2023-02-28 23:59:55.000

SELECT * FROM CurrentBalanceAudit WITH (NOLOCK) WHERE AID = 11162416 AND DENAME IN (114, 115) ORDER BY IdentityField DESC

SELECT CMTTranType,FeesAcctID, CPMGroup, TranTime, PostTime, TransactionDescription
FROM CCArd_Primary WITH (NOLOCK)
WHERE AccountNumber = '1100011128249871'
AND CMTTranType IN ('*SCR', '51', '54')
ORDER BY PostTime DESC



DROP TABLE IF EXISTS #TempData
CREATE TABLE #TempData(AccountUUID VARCHAR(64))

INSERT INTO #TempData (AccountUUID) VALUES ('db308f50-97df-4d28-aeeb-3b8b10e02ba9')
INSERT INTO #TempData (AccountUUID) VALUES ('4e3da579-d4bd-4da9-97fc-f87fae452159')
INSERT INTO #TempData (AccountUUID) VALUES ('944b721e-f163-4cc8-8b80-fbf9f947b652')
INSERT INTO #TempData (AccountUUID) VALUES ('6c59e970-a4ff-460f-b982-5ac2173924b3')
INSERT INTO #TempData (AccountUUID) VALUES ('580fbc34-b509-4d2b-8d40-87d936f4b593')