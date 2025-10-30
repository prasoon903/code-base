
DROP TABLE IF EXISTS #CO_IDTF
SELECT T1.Account_UUID, BP.AccountNumber, BP.acctId, CYCLE_DELINQUENT, CHARGE_OFF_DATE, STATUS_APPLY_DATE, MANUAL_STATUS_DESC, 
EXPECTED_CHARGE_OFF_DATE, 0 IDTApplied, TRY_CAST(NULL AS DATETIME) ChargeOffDatePosted, --TRY_CAST(NULL AS DATETIME) TentativeCODate,
0 StatusBeforeCO, TRY_CAST(NULL AS DATETIME) StatusBeforeCOSetDate, 0 DPDAtCO
INTO #CO_IDTF
FROM ##TempData T1
JOIN BSegment_Primary BP WITH (NOLOCK) ON T1.Account_UUID = BP.UniversalUniqueID
WHERE MANUAL_STATUS_DESC IN ('ID-Theft Fraud')


DROP TABLE IF EXISTS #CO_IDTF_StatusHistory
SELECT C.AccountNumber, BSAcctID, FeesAcctID StatusBefore, CPMGroup StatusAfter, TranTime, PostTime, CMTTranType, 
ROW_NUMBER() OVER(PARTITION BY C.AccountNumber, CMTTRanType ORDER BY TranTime) StatusCount
INTO #CO_IDTF_StatusHistory
FROM LS_P1MARPRODDB01.CCGS_CoreIssue.DBO.CCard_Primary C WITH (NOLOCK)
JOIN #CO_IDTF T1 ON (C.AccountNumber = T1.AccountNumber)
WHERE CMTTranType IN ('51', '54', 'RCLS', '*SCR')


UPDATE #CO_IDTF SET IDTApplied = 1
WHERE AccountNumber IN (SELECT DISTINCT AccountNumber FROM #CO_IDTF_StatusHistory 
WHERE CMTTranType = '*SCR' 
AND (StatusBefore = 16022 OR StatusAfter = 16022))


UPDATE T1 
SET ChargeOffDatePosted = TRY_CAST(T2.PostTime AS DATE)
--,TentativeCODate = CASE WHEN TRY_CAST(T2.PostTime AS DATE) > STATUS_APPLY_DATE THEN EOMONTH(STATUS_APPLY_DATE) ELSE NULL END
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

;WITH CTE
AS
(
SELECT T1.*, RANK() OVER (PARTITION BY T1.AccountNumber ORDER BY StatusCount DESC) [Count]
FROM #CO_IDTF_StatusHistory T1
JOIN #CO_IDTF T2 ON (T1.AccountNumber = T2.AccountNumber AND IDTApplied = 1)
WHERE ChargeOffDatePosted > STATUS_APPLY_DATE
AND T1.PostTime < ChargeOffDatePosted
AND CMTTranType = '*SCR' --AND (StatusBefore = 16010 OR StatusAfter = 16010)
--AND T1.AccountNumber = '1100011148090875'
)
UPDATE T1 
SET StatusBeforeCOSetDate = TRY_CAST(T2.PostTime AS DATE)
,StatusBeforeCO = StatusAfter
--SELECT *
FROM #CO_IDTF T1
JOIN CTE T2 ON (T1.AccountNumber = T2.AccountNumber)
WHERE T1.IDTApplied = 1
AND [Count] = 1

SELECT T1.*, RANK() OVER (PARTITION BY T1.AccountNumber ORDER BY StatusCount DESC) [Count]
FROM #CO_IDTF_StatusHistory T1
WHERE AccountNumber = '1100011127168395'
ORDER BY PostTime


SELECT T1.*, BusinessDay, DaysDelinquent, CycleDueDTD 
FROM #CO_IDTF T1
JOIN AccountInfoForReport_SwitchOut A WITH (NOLOCK) ON (T1.acctId = A.BSAcctID AND TRY_CAST(ChargeOffDatePosted AS DATE) = TRY_CAST(BusinessDay AS DATE))
WHERE IDTApplied = 1 
AND ChargeOffDatePosted > STATUS_APPLY_DATE 
AND StatusBeforeCO = 0

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
--AND ChargeOffDatePosted > STATUS_APPLY_DATE 
--AND StatusBeforeCO = 0


SELECT * FROM #CO_IDTF WHERE IDTApplied = 1 AND ChargeOffDatePosted > CHARGE_OFF_DATE

SELECT * FROM #CO_IDTF WHERE IDTApplied = 1 AND ChargeOffDatePosted > STATUS_APPLY_DATE AND StatusBeforeCO = 0

SELECT * FROM #CO_IDTF_StatusHistory WHERE AccountNumber = '1100011112186980' ORDER BY PostTime

SELECT * FROM #CO_IDTF WHERE ChargeOffDatePosted = '2020-07-31 00:00:00.000'

SELECT * FROM #CO_IDTF WHERE AccountNumber = '1100011112186980'

SELECT BusinessDay, ccinhparent125AID, SystemStatus, ChargeOffDateParam, ChargeOffDate, SystemChargeOffStatus, UserChargeOffStatus, DateOfTotalDue, CycleDueDTD, DaysDelinquent, DateOfDelinquency
FROM AccountInfoForReport_SwitchOut WITH (NOLOCK) 
WHERE BSAcctID = 1222565 
AND BusinessDay BETWEEN '2020-07-30 23:59:55.000' AND '2020-09-30 23:59:57.000' 
ORDER BY BusinessDay