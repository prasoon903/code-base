DROP TABLE IF EXISTS #TempData
SELECT BP.acctID, AccountNumber, CurrentBalance, CycleDueDTD, SystemStatus, ccinhParent125AID, LastStatementDate, 
ChargeOffDate, ChargeOffDateParam, ManualInitialChargeOffStartDate, AutoInitialChargeOffStartDate, 
ManualInitialChargeOffReason, AutoInitialChargeOffReason, SystemChargeOffStatus, UserChargeOffStatus
INTO #TempData
FROM BSegment_Primary BP WITH (NOLOCK)
JOIN BSegmentCreditCard BC WITH (NOLOCK) ON (BP.acctID = BC.acctID)
WHERE BillingCycle = '31'
AND LastStatementDate = '2024-05-31 23:59:57'

----SELECT EOMONTH(DATEADD(MM, -1, EOMONTH('2023-02-28 18:47:44.000')))
--SELECT 86397*2-2
--SELECT TRY_CAST(EOMONTH(DATEADD(MM, 0, TRY_CAST(EOMONTH('2024-05-21 23:59:57.000') AS DATETIME))) AS DATETIME)
--SELECT DATEADD(SS, 86397*1-2, TRY_CAST(EOMONTH(DATEADD(MM, 0, TRY_CAST(EOMONTH('2024-05-21 23:59:57.000') AS DATETIME))) AS DATETIME))

DROP TABLE IF EXISTS #TempRecords
SELECT T.*, AfterNumberOfCycles, 
DATEADD(SS, 86397-2, TRY_CAST(EOMONTH(DATEADD(MM, TRY_CAST(AfterNumberOfCycles AS INT)-1, TRY_CAST(EOMONTH(ManualInitialChargeOffStartDate) AS DATETIME))) AS DATETIME)) ManualAnticipatedCODate,
DATEADD(SS, 86397-2, TRY_CAST(EOMONTH(DATEADD(MM, 1, TRY_CAST(EOMONTH(AutoInitialChargeOffStartDate) AS DATETIME))) AS DATETIME)) AutoAnticipatedCODate
INTO #TempRecords
FROM #TempData T
LEFT JOIN AStatusAccounts A WITH (NOLOCK) ON (T.ccinhParent125AID = A.parent01AID AND A.MerchantAID = 14992)
WHERE ChargeOffDateParam IS NOT NULL
AND SystemStatus <> 14
AND (AutoInitialChargeOffStartDate IS NOT NULL OR ManualInitialChargeOffStartDate IS NOT NULL)

SELECT COUNT(1) ImpactedAccounts
FROM #TempRecords
--WHERE ManualInitialChargeOffStartDate IS NULL
WHERE COALESCE(ManualAnticipatedCODate, AutoAnticipatedCODate) < GETDATE()

SELECT * FROM #TempRecords

--SELECT *
--FROM #TempRecords
--WHERE SystemStatus <> 14
--AND (AutoInitialChargeOffStartDate < LastStatementDate OR ManualInitialChargeOffStartDate < LastStatementDate)