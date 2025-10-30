SELECT * FROM ##TempRecords

DROP TABLE IF EXISTS #TempData
SELECT BP.acctID, BP.AccountNumber, T.* 
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


SELECT COUNT(1) FROM #TempData
--POD1: 47879, POD2: , POD4:
SELECT COUNT(1) FROM #LPSDetails
--POD1: 48334, POD2: , POD4:
SELECT COUNT(1) FROM #LPSDetails WHERE CurrentBalance > 0
--POD1: 47937, POD2: , POD4:

SELECT AccountNumber, 2 AddRemoveAction, 3 RedemMethod, CurrentBalance TransactionAmount, ClientID FROM #LPSDetails WHERE CurrentBalance > 0