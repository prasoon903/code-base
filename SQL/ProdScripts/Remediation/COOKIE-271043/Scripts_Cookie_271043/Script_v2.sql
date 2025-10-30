SELECT * FROM ##TempRecords

DROP TABLE IF EXISTS #TempData
SELECT BP.acctID, BP.AccountNumber, ccinhparent125AID, SystemStatus, T.* 
INTO #TempData
FROM ##TempRecords T
JOIN BSegment_Primary BP WITH (NOLOCK) ON (T.AccountUUID = BP.UniversalUniqueID)

DROP TABLE IF EXISTS #LPSDetails
SELECT T.*, L.LPSAcctID, L.ClientID, L.CurrentBalance
INTO #LPSDetails
FROM #TempData T
JOIN LS_P1MARPRODDB01.CCGS_CoreIssue.DBO.LPSCustomerDetails L WITH (NOLOCK) ON (T.acctID = L.BSAcctID)

SELECT acctID, COUNT(1)
FROM #LPSDetails
GROUP BY acctID
HAVING COUNT(1) > 1
ORDER BY COUNT(1) DESC 

SELECT * FROM #LPSDetails WHERE AccountNumber = '1100011143145773'

SELECT * FROM #TempData WHERE acctID = 8300149

SELECT * FROM Customer WITH (NOLOCK) WHERE BSAcctID = 8300149

SELECT COUNT(1) FROM #TempData
--POD1: 2461, POD2: , POD4:
SELECT COUNT(1) FROM #LPSDetails
--POD1: 2537, POD2: , POD4:
SELECT COUNT(1) FROM #LPSDetails WHERE CurrentBalance > 0
--POD1: 2477, POD2: , POD4:

SELECT RTRIM(AccountNumber) AccountNumber, 2 AddRemoveAction, 3 RedemMethod, CurrentBalance TransactionAmount, ClientID FROM #LPSDetails WHERE CurrentBalance > 0