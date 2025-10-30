
DROP TABLE IF EXISTS #CO_Decd
SELECT T1.Account_UUID, BP.AccountNumber, BP.acctId, CYCLE_DELINQUENT, CHARGE_OFF_DATE, STATUS_APPLY_DATE, MANUAL_STATUS_DESC, 
EXPECTED_CHARGE_OFF_DATE, 0 DecdApplied, TRY_CAST(NULL AS DATETIME) ChargeOffDatePosted, --TRY_CAST(NULL AS DATETIME) TentativeCODate,
0 StatusBeforeCO, TRY_CAST(NULL AS DATETIME) StatusBeforeCOSetDate, 0 DPDAtCO
INTO #CO_Decd
FROM ##TempData T1
JOIN BSegment_Primary BP WITH (NOLOCK) ON T1.Account_UUID = BP.UniversalUniqueID
WHERE MANUAL_STATUS_DESC IN ('Deceased')


DROP TABLE IF EXISTS #CO_Decd_StatusHistory
SELECT C.AccountNumber, BSAcctID, FeesAcctID StatusBefore, CPMGroup StatusAfter, TranTime, PostTime, CMTTranType, 
ROW_NUMBER() OVER(PARTITION BY C.AccountNumber, CMTTRanType ORDER BY TranTime) StatusCount
INTO #CO_Decd_StatusHistory
FROM LS_P1MARPRODDB01.CCGS_CoreIssue.DBO.CCard_Primary C WITH (NOLOCK)
JOIN #CO_Decd T1 ON (C.AccountNumber = T1.AccountNumber)
WHERE CMTTranType IN ('51', '54', 'RCLS', '*SCR')


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
--AND TRY_CAST(T2.PostTime AS DATE) > CHARGE_OFF_DATE

SELECT *, EOMONTH(STATUS_APPLY_DATE) TentativeCODate
FROM #CO_Decd 
WHERE DecdApplied = 1 
AND TRY_CAST(ChargeOffDatePosted AS DATE) > STATUS_APPLY_DATE

;WITH CTE
AS
(
SELECT T1.*, RANK() OVER (PARTITION BY T1.AccountNumber ORDER BY StatusCount DESC) [Count]
FROM #CO_Decd_StatusHistory T1
JOIN #CO_Decd T2 ON (T1.AccountNumber = T2.AccountNumber AND DecdApplied = 1)
WHERE ChargeOffDatePosted > STATUS_APPLY_DATE
AND T1.PostTime < ChargeOffDatePosted
AND CMTTranType = '*SCR' --AND (StatusBefore = 16010 OR StatusAfter = 16010)
--AND T1.AccountNumber = '1100011148090875'
)
UPDATE T1 
SET StatusBeforeCOSetDate = TRY_CAST(T2.PostTime AS DATE)
,StatusBeforeCO = StatusAfter
--SELECT *
FROM #CO_Decd T1
JOIN CTE T2 ON (T1.AccountNumber = T2.AccountNumber)
WHERE T1.DecdApplied = 1
AND [Count] = 1

SELECT T1.*, RANK() OVER (PARTITION BY T1.AccountNumber ORDER BY StatusCount DESC) [Count]
FROM #CO_Decd_StatusHistory T1
WHERE AccountNumber = '1100011127168395'
ORDER BY PostTime


SELECT T1.*, BusinessDay, DaysDelinquent, CycleDueDTD 
FROM #CO_Decd T1
JOIN AccountInfoForReport_SwitchOut A WITH (NOLOCK) ON (T1.acctId = A.BSAcctID AND TRY_CAST(ChargeOffDatePosted AS DATE) = TRY_CAST(BusinessDay AS DATE))
WHERE DecdApplied = 1 
AND ChargeOffDatePosted > STATUS_APPLY_DATE 
AND StatusBeforeCO = 0

UPDATE T1
SET DPDAtCO = DaysDelinquent
FROM #CO_Decd T1
JOIN AccountInfoForReport_SwitchOut A WITH (NOLOCK) ON (T1.acctId = A.BSAcctID AND TRY_CAST(ChargeOffDatePosted AS DATE) = TRY_CAST(BusinessDay AS DATE))
WHERE DecdApplied = 1 
--AND ChargeOffDatePosted > STATUS_APPLY_DATE 
--AND StatusBeforeCO = 0


UPDATE T1
SET DPDAtCO = DaysDelinquent
FROM #CO_Decd T1
JOIN AccountInfoForReport A WITH (NOLOCK) ON (T1.acctId = A.BSAcctID AND TRY_CAST(ChargeOffDatePosted AS DATE) = TRY_CAST(BusinessDay AS DATE))
WHERE DecdApplied = 1 
--AND ChargeOffDatePosted > STATUS_APPLY_DATE 
--AND StatusBeforeCO = 0


SELECT * FROM #CO_Decd WHERE DecdApplied = 1 AND ChargeOffDatePosted > CHARGE_OFF_DATE

SELECT * FROM #CO_Decd WHERE DecdApplied = 1 AND ChargeOffDatePosted > STATUS_APPLY_DATE AND StatusBeforeCO = 0

SELECT * FROM #CO_Decd_StatusHistory WHERE AccountNumber = '1100011127168395' ORDER BY PostTime