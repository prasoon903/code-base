SELECT * FROM LS_P1MARPRODDB01.CCGS_CoreIssue.dbo.Version WITH (NOLOCK) ORDER BY 1 DESC
--23.2.4.9            	4.3.2.14            	2023-10-12 03:09:00

DROP TABLE IF EXISTS #ChargeOffAccounts
SELECT BSAcctID, AccountNumber, CycleDueDTD, SystemStatus, ccinhparent125AID, ManualInitialChargeOffReason, ChargeOffDate, ChargeOffDateParam, DATEADD(SECOND, 86395, TRY_CAST(EOMONTH(ChargeOffDate) AS DATETIME)) EOM
INTO #ChargeOffAccounts
FROM AccountInfoForreport WITH (NOLOCK)
WHERE BusinessDay = '2024-03-07 23:59:57'
AND SystemStatus = 14
AND ChargeOffDate > '2023-10-12 03:09:00'

SELECT T.*, UniversalUniqueID 
FROM #ChargeOffAccounts  T
JOIN BSegment_Primary BP WITH (NOLOCK) ON (BP.acctID = T.BSAcctID)
WHERE ChargeOffDate <> EOM


SELECT CMTTranType,FeesAcctID, CPMGroup, TranTime, PostTime, TransactionDescription, ReconFlag
FROM CCArd_Primary CP WITH (NOLOCK)
LEFT JOIN CCard_Secondary CS WITH (NOLOCK) ON (Cp.TranID = CS.TranID)
WHERE AccountNumber = '1100011109710164'
AND CMTTranType IN ('*SCR', '51', '54')
ORDER BY PostTime DESC

SELECT *
--FROM LS_P1MARPRODDB01.CCGS_CoreIssue.DBO.NonMonetaryLog WITH (NOLOCK)
FROM NonMonetaryLog WITH (NOLOCK)
WHERE AccountNumber= '1100011109450696'
AND requestType IN ('113473', '113474')

SELECT accountNumber,* FROM BSegment_Primary WITH (NOLOCK) WHERE UniversalUniqueID = '3e833893-c4fd-4717-a678-5a2519e8ba61'

--89f62451-3fdc-4a14-9efc-241403c4c823
--3e833893-c4fd-4717-a678-5a2519e8ba61