
DROP TABLE IF EXISTS #TempAccounts
SELECT BP.acctID, BP.AccountNumber, SystemStatus, CurrentBalance+CurrentBalanceCO CurrentBalance, CreditBalanceDate
INTO #TempAccounts
FROM BSegment_Primary BP WITH (NOLOCK)
JOIN BSegmentCreditCard BC WITH (NOLOCK) ON (BP.acctID = BC.acctId)
WHERE CurrentBalance+CurrentBalanceCO < 0

--SELECT TOP 10 *
--FROM #TempAccounts

DROP TABLE IF EXISTS #CBA
SELECT *
INTO #CBA
FROM CurrentBalanceAudit CBA WITH (NOLOCK)
JOIN #TempAccounts T ON (T.acctID = CBA.AID AND CBA.ATID = 51)
WHERE CBA.DENAME IN (111, 222)

DROP TABLE IF EXISTS #CBA222
SELECT C2.*
INTO #CBA222
FROM #CBA C1
LEFT JOIN #CBA C2 ON (C1.AID = C2.AID AND C1.BusinessDay = C2.BusinessDay AND C1.DENAME = 111 AND C2.DENAME = 222)
WHERE C2.AID IS NOT NULL

DELETE C1
FROM #CBA C1
JOIN #CBA222 C2 ON (C1.IdentityField = C2.IdentityField)

DELETE C1
FROM #CBA C1
JOIN #CBA222 C2 ON (C1.AID = C2.AID AND C1.BusinessDay = C2.BusinessDay AND C1.DENAME = 111 AND C2.DENAME = 222)

UPDATE #CBA SET DENAME = 111 WHERE DENAME = 222

DROP TABLE IF EXISTS #TempFinalCBA
;WITH CTE
AS
(
SELECT *, ROW_NUMBER() OVER(PARTITION BY AID ORDER BY BusinessDay DESC) RN
FROM #CBA
WHERE TRY_CAST(OldValue AS MONEY) >= 0 AND TRY_CAST(NewValue AS MONEY) < 0
)
SELECT *
INTO #TempFinalCBA
FROM CTE 
WHERE RN = 1


SELECT * FROM CurrentBalanceAudit WITH (NOLOCK) WHERE AID = 2101734 AND DENAME IN (111, 222) ORDER BY BusinessDay DESC

SELECT * FROM #TempFinalCBA WHERE AID = 2101734 

SELECT * FROM #TempFinalCBA WHERE CreditBalanceDate IS NULL

DROP TABLE IF EXISTS #TempImpacted
SELECT *
INTO #TempImpacted 
FROM #TempFinalCBA 
WHERE (CreditBalanceDate <> BusinessDay OR CreditBalanceDate IS NULL)

SELECT * FROM #TempImpacted WHERE acctID = 21159988

SELECT * FROM #TempImpacted WHERE CreditBalanceDate IS NULL

SELECT * FROM #TempImpacted WHERE SystemStatus = 14

SELECT SystemStatus, COUNT(1) ImpactedAccounts
FROM #TempImpacted
GROUP BY SystemStatus


DROP TABLE IF EXISTS #TempImpactedToUpdate
SELECT T1.*
INTO #TempImpactedToUpdate
FROM #TempImpacted T1
JOIN BSegment_Primary BP WITH (NOLOCK) ON (T1.acctID = BP.acctID)
WHERE T1.CreditBalanceDate = BP.CreditBalanceDate
OR (T1.CreditBalanceDate IS NULL AND BP.CreditBalanceDate IS NULL)

SELECT T1.*, BP.CreditBalanceDate
FROM #TempImpacted T1
JOIN BSegment_Primary BP WITH (NOLOCK) ON (T1.acctID = BP.acctID)
WHERE T1.CreditBalanceDate = BP.CreditBalanceDate
OR (T1.CreditBalanceDate IS NULL AND BP.CreditBalanceDate IS NULL)
