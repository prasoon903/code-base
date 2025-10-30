SELECT * FROM ##TempData

SELECT MANUAL_STATUS_DESC, COUNT(1) FROM ##TempData GROUP BY MANUAL_STATUS_DESC

--Bankruptcy No Payments	523
--Deceased					186
--Bankruptcy with Payments	63
--ID-Theft Fraud			908 -- POD1 - 902

DROP TABLE IF EXISTS #CO_BKNP
SELECT T1.Account_UUID, BP.AccountNumber, BP.acctId, CYCLE_DELINQUENT, CHARGE_OFF_DATE, STATUS_APPLY_DATE, MANUAL_STATUS_DESC, 
EXPECTED_CHARGE_OFF_DATE, 0 BKNPApplied, TRY_CAST(NULL AS DATETIME) ChargeOffDatePosted, --TRY_CAST(NULL AS DATETIME) TentativeCODate,
0 StatusBeforeCO, TRY_CAST(NULL AS DATETIME) StatusBeforeCOSetDate, 0 DPDAtCO
INTO #CO_BKNP
FROM ##TempData T1
JOIN BSegment_Primary BP WITH (NOLOCK) ON T1.Account_UUID = BP.UniversalUniqueID
WHERE MANUAL_STATUS_DESC IN ('Bankruptcy No Payments', 'Bankruptcy with Payments')


DROP TABLE IF EXISTS #CO_BKNP_StatusHistory
SELECT C.AccountNumber, BSAcctID, FeesAcctID StatusBefore, CPMGroup StatusAfter, TranTime, PostTime, CMTTranType, 
ROW_NUMBER() OVER(PARTITION BY C.AccountNumber, CMTTRanType ORDER BY TranTime) StatusCount
INTO #CO_BKNP_StatusHistory
FROM LS_P1MARPRODDB01.CCGS_CoreIssue.DBO.CCard_Primary C WITH (NOLOCK)
JOIN #CO_BKNP T1 ON (C.AccountNumber = T1.AccountNumber)
WHERE CMTTranType IN ('51', '54', 'RCLS', '*SCR')


UPDATE #CO_BKNP SET BKNPApplied = 1
WHERE AccountNumber IN (SELECT DISTINCT AccountNumber FROM #CO_BKNP_StatusHistory 
WHERE CMTTranType = '*SCR' 
AND (StatusBefore = 16010 OR StatusAfter = 16010 OR StatusBefore = 5202 OR StatusAfter = 5202))


UPDATE T1 
SET ChargeOffDatePosted = TRY_CAST(T2.PostTime AS DATE)
--,TentativeCODate = CASE WHEN TRY_CAST(T2.PostTime AS DATE) > STATUS_APPLY_DATE THEN EOMONTH(STATUS_APPLY_DATE) ELSE NULL END
FROM #CO_BKNP T1
JOIN #CO_BKNP_StatusHistory T2 ON (T1.AccountNumber = T2.AccountNumber AND CMTTranType = '51' AND StatusCount = 1)
WHERE T1.BKNPApplied = 1

SELECT T1.*, T2.PostTime ChargeOffDatePosted
FROM #CO_BKNP T1
JOIN #CO_BKNP_StatusHistory T2 ON (T1.AccountNumber = T2.AccountNumber AND CMTTranType = '51' AND StatusCount = 1)
WHERE T1.BKNPApplied = 1
--AND TRY_CAST(T2.PostTime AS DATE) > CHARGE_OFF_DATE

SELECT *, EOMONTH(STATUS_APPLY_DATE) TentativeCODate
FROM #CO_BKNP 
WHERE BKNPApplied = 1 
AND TRY_CAST(ChargeOffDatePosted AS DATE) > STATUS_APPLY_DATE

;WITH CTE
AS
(
SELECT T1.*, RANK() OVER (PARTITION BY T1.AccountNumber ORDER BY StatusCount DESC) [Count]
FROM #CO_BKNP_StatusHistory T1
JOIN #CO_BKNP T2 ON (T1.AccountNumber = T2.AccountNumber AND BKNPApplied = 1)
WHERE ChargeOffDatePosted > STATUS_APPLY_DATE
AND T1.PostTime < ChargeOffDatePosted
AND CMTTranType = '*SCR' --AND (StatusBefore = 16010 OR StatusAfter = 16010)
--AND T1.AccountNumber = '1100011148090875'
)
UPDATE T1 
SET StatusBeforeCOSetDate = TRY_CAST(T2.PostTime AS DATE)
,StatusBeforeCO = StatusAfter
--SELECT *
FROM #CO_BKNP T1
JOIN CTE T2 ON (T1.AccountNumber = T2.AccountNumber)
WHERE T1.BKNPApplied = 1
AND [Count] = 1

SELECT T1.*, RANK() OVER (PARTITION BY T1.AccountNumber ORDER BY StatusCount DESC) [Count]
FROM #CO_BKNP_StatusHistory T1
WHERE AccountNumber = '1100011127168395'
ORDER BY PostTime


SELECT T1.*, BusinessDay, DaysDelinquent, CycleDueDTD 
FROM #CO_BKNP T1
JOIN AccountInfoForReport_SwitchOut A WITH (NOLOCK) ON (T1.acctId = A.BSAcctID AND TRY_CAST(ChargeOffDatePosted AS DATE) = TRY_CAST(BusinessDay AS DATE))
WHERE BKNPApplied = 1 
AND ChargeOffDatePosted > STATUS_APPLY_DATE 
AND StatusBeforeCO = 0

UPDATE T1
SET DPDAtCO = DaysDelinquent
FROM #CO_BKNP T1
JOIN AccountInfoForReport_SwitchOut A WITH (NOLOCK) ON (T1.acctId = A.BSAcctID AND TRY_CAST(ChargeOffDatePosted AS DATE) = TRY_CAST(BusinessDay AS DATE))
WHERE BKNPApplied = 1 
--AND ChargeOffDatePosted > STATUS_APPLY_DATE 
--AND StatusBeforeCO = 0


UPDATE T1
SET DPDAtCO = DaysDelinquent
FROM #CO_BKNP T1
JOIN AccountInfoForReport A WITH (NOLOCK) ON (T1.acctId = A.BSAcctID AND TRY_CAST(ChargeOffDatePosted AS DATE) = TRY_CAST(BusinessDay AS DATE))
WHERE BKNPApplied = 1 
--AND ChargeOffDatePosted > STATUS_APPLY_DATE 
--AND StatusBeforeCO = 0


SELECT * FROM #CO_BKNP WHERE BKNPApplied = 1 AND ChargeOffDatePosted > CHARGE_OFF_DATE

SELECT * FROM #CO_BKNP WHERE BKNPApplied = 1 AND ChargeOffDatePosted > STATUS_APPLY_DATE AND StatusBeforeCO = 0

SELECT * FROM #CO_BKNP_StatusHistory WHERE AccountNumber = '1100011127168395' ORDER BY PostTime

-- ID-Theft Fraud

DROP TABLE IF EXISTS #CO_IDTF
SELECT T1.Account_UUID, BP.AccountNumber, BP.acctId, CYCLE_DELINQUENT, CHARGE_OFF_DATE, STATUS_APPLY_DATE, MANUAL_STATUS_DESC, 
EXPECTED_CHARGE_OFF_DATE, 0 IDTApplied, TRY_CAST(NULL AS DATETIME) ChargeOffDatePosted, TRY_CAST(NULL AS DATETIME) TentativeCODate, 0 DPDAtCO
INTO #CO_IDTF
FROM ##TempData T1
JOIN BSegment_Primary BP WITH (NOLOCK) ON T1.Account_UUID = BP.UniversalUniqueID
WHERE MANUAL_STATUS_DESC = 'ID-Theft Fraud'

--SELECT * FROM #CO_IDTF

DROP TABLE IF EXISTS #CO_IDTF_StatusHistory
SELECT C.AccountNumber, BSAcctID, FeesAcctID StatusBefore, CPMGroup StatusAfter, TranTime, PostTime, CMTTranType, 
ROW_NUMBER() OVER(PARTITION BY C.AccountNumber, CMTTRanType ORDER BY TranTime) StatusCount
INTO #CO_IDTF_StatusHistory
FROM CCard_Primary C WITH (NOLOCK)
JOIN #CO_IDTF T1 ON (C.AccountNumber = T1.AccountNumber)
WHERE CMTTranType IN ('51', '54', 'RCLS', '*SCR')
--OR (CMTTranType = '*SCR' AND (FeesAcctID = 16022 OR CPMGroup = 16022))

--SELECT * FROM #CO_IDTF_StatusHistory WHERE AccountNumber= '1100011110811340' ORDER BY PostTime

--SELECT DISTINCT AccountNumber FROM #CO_IDTF_StatusHistory WHERE CMTTranType = '*SCR' AND (StatusBefore = 16022 OR StatusAfter = 16022)

UPDATE #CO_IDTF SET IDTApplied = 1
WHERE AccountNumber IN (SELECT DISTINCT AccountNumber FROM #CO_IDTF_StatusHistory WHERE CMTTranType = '*SCR' AND (StatusBefore = 16022 OR StatusAfter = 16022))

UPDATE T1 
SET ChargeOffDatePosted = TRY_CAST(T2.PostTime AS DATE)
,TentativeCODate = CASE WHEN TRY_CAST(T2.PostTime AS DATE) > STATUS_APPLY_DATE THEN EOMONTH(STATUS_APPLY_DATE) ELSE NULL END
FROM #CO_IDTF T1
JOIN #CO_IDTF_StatusHistory T2 ON (T1.AccountNumber = T2.AccountNumber AND CMTTranType = '51' AND StatusCount = 1)
WHERE T1.IDTApplied = 1

SELECT T1.*, T2.PostTime ChargeOffDatePosted
FROM #CO_IDTF T1
JOIN #CO_IDTF_StatusHistory T2 ON (T1.AccountNumber = T2.AccountNumber AND CMTTranType = '51' AND StatusCount = 1)
WHERE T1.IDTApplied = 1
--AND TRY_CAST(T2.PostTime AS DATE) > CHARGE_OFF_DATE

SELECT *, EOMONTH(STATUS_APPLY_DATE) TentativeCODate
FROM #CO_IDTF 
WHERE IDTApplied = 1 
AND TRY_CAST(ChargeOffDatePosted AS DATE) > STATUS_APPLY_DATE

UPDATE T1
SET DPDAtCO = DaysDelinquent
FROM #CO_IDTF T1
JOIN AccountInfoForReport_SwitchOut A WITH (NOLOCK) ON (T1.acctId = A.BSAcctID AND TRY_CAST(ChargeOffDatePosted AS DATE) = TRY_CAST(BusinessDay AS DATE))
WHERE IDTApplied = 1 
--AND ChargeOffDatePosted > STATUS_APPLY_DATE 
--AND StatusBeforeCO = 0


UPDATE T1
SET DPDAtCO = DaysDelinquent
FROM #CO_IDTF T1
JOIN AccountInfoForReport A WITH (NOLOCK) ON (T1.acctId = A.BSAcctID AND TRY_CAST(ChargeOffDatePosted AS DATE) = TRY_CAST(BusinessDay AS DATE))
WHERE IDTApplied = 1 

SELECT * FROm #CO_IDTF WHERE IDTApplied = 1

SELECT BSAcctID, FeesAcctID StatusBefore, CPMGroup StatusAfter, TranTime, PostTime, CMTTranType
FROM CCard_Primary WITH (NOLOCK)
WHERE AccountNumber= '1100011129236562'
AND CMTTranType IN ('*SCR', '51', '54', 'RCLS')
ORDER By PostTime

SELECT *
--FROM LS_P1MARPRODDB01.CCGS_CoreIssue.DBO.NonMonetaryLog WITH (NOLOCK)
FROM NonMonetaryLog WITH (NOLOCK)
WHERE AccountNumber= '1100011112186980'
AND requestType IN ('113473', '113474')

--SELECT *
--FROM TCIVRRequest WITH (NOLOCK)
--WHERE AccountNumber= '1100011115605895'
--AND RequestName IN ('113473', '113474')

--2020-09-21 00:00:00.000	2020-09-17 00:00:00.000