hghghghghg
--IF(1!=0)
--BEGIN
-- RETURN;
--END

SELECT * FROM sys.tables where name like '%AccountInfoForReport%'

SELECT BusinessDay, COUNT(1) TotalAccounts
FROM AccountInfoForReport_NCPartitioned WITH (NOLOCK)
GROUP BY BusinessDay 
ORDER BY BusinessDay 
--2018-08-20 23:59:57.000 to 2020-12-18 23:59:57.000
--852 days data

SELECT BusinessDay, COUNT(1) TotalAccounts
FROM AccountInfoForReport_SwitchOut WITH (NOLOCK)
GROUP BY BusinessDay 
ORDER BY BusinessDay
--2019-12-31 23:59:57 to  2022-03-31 23:59:57.000
--503 days data


DROP TABLE IF EXISTS #CBAudit1
SELECT Identityfield, BusinessDay, AID, TRY_CAST(OldValue AS INT) OldValue, TRY_CAST(NewValue AS INT) NewValue,
ROW_NUMBER() OVER(PARTITION BY AID ORDER BY IdentityField) StatusCount
INTO #CBAudit1 
FROM CurrentBalanceAudit WITH (NOLOCK)
WHERE BusinessDay BETWEEN '2018-08-20' AND '2019-11-30 23:59:57.000'
AND DENAME = 114

SELECT TOP 100 * FROM #CBAudit1 ORDER BY AID, IdentityField

DROP TABLE IF EXISTS #MissingCBA
;WITH CTE
AS
(
SELECT C1.AID, C1.StatusCount
--INTO #MissingCBA
FROM #CBAudit1 C1
FULL JOIN  #CBAudit1 C2 ON (C1.AID = C2.AID )
WHERE C1.StatusCount = C2.StatusCount-1
AND C1.NewValue <> C2.OldValue
--ORDER By C1.AID
)
SELECT C1.*, C1.StatusCount-C2.StatusCount StatusCountToUpdate,
ROW_NUMBER() OVER(PARTITION BY C1.AID ORDER BY C1.StatusCount DESC) MaxCount
INTO #MissingCBA
FROM #CBAudit1 C1
JOIN CTE C2 On (C1.AID = C2.AID)
WHERE C1.StatusCount >= C2.StatusCount
ORDER By C1.AID

DROP TABLE IF EXISTS #CBAEntries
;WITH CTE
AS
(
SELECT NULL IdentityField, BusinessDay, AID, OldValue, NewValue, StatusCount FROM #MissingCBA WHERE MaxCount = 1 --ORDER BY AID
UNION ALL
SELECT C2.IdentityField, C2.BusinessDay, C1.AID, 
CASE WHEN C2.StatusCountToUpdate = 1 THEN C1.NewValue ELSE C1.OldValue END OldValue,
CASE WHEN C2.StatusCountToUpdate = 1 THEN C2.OldValue ELSE C2.OldValue END NewValue,
C1.StatusCount
FROM #MissingCBA C1
FULL JOIN  #MissingCBA C2 ON (C1.AID = C2.AID )
WHERE C1.StatusCountToUpdate = C2.StatusCountToUpdate-1
--ORDER By C1.AID
)
SELECT *
INTO #CBAEntries
FROM CTE

DROP TABLE IF EXISTS #CBAScript
SELECT *,
CASE WHEN IdentityField IS NOT NULL THEN
	'UPDATE TOP(1) CurrentBalanceAudit SET OldValue = '''+TRY_CAST(OldValue AS VARCHAR)+''', NewValue = '''+TRY_CAST(NewValue AS VARCHAR)+''' WHERE AID = '+TRY_CAST(AID AS VARCHAR)+' AND ATID = 51 AND IdentityField = '+TRY_CAST(IdentityField AS VARCHAR)
ELSE
	'INSERT INTO CurrentBalanceAudit(tid,businessday,atid,aid,dename,oldvalue,newvalue) VALUES (0, ''' + TRY_CONVERT(VARCHAR(20), businessday, 20) + ''', 51, '+TRY_CAST(AID AS VARCHAR)+', ''' +TRY_CAST(OldValue AS VARCHAR)+''', '''+TRY_CAST(NewValue AS VARCHAR)+''')'
END Script
INTO #CBAScript
FROM #CBAEntries ORDER BY AID, StatusCount

SELECT * FROM #CBAScript ORDER BY AID, StatusCount



--;WITH CTE
--AS
--(
--SELECT C.*, A.ccinhparent125AID ManualStatusAccount, 
--ROW_NUMBER() OVER(PARTITION BY AID, A.BusinessDay ORDER BY C.IdentityField DESC) StatusCount
--FROM #CBAudit1 C
--JOIN AccountInfoForReport_NCPartitioned A WITH (NOLOCK) ON (C.AID = A.BSAcctID AND TRY_CAST(C.BusinessDAy AS DATE) = TRY_CAST(A.BusinessDAy AS DATE))
--)
--SELECT *
--INTO #Mismatch1
--FROM CTE
--WHERE Try_CAST(NewValue )

SELECT *
INTO #CBAudit1 
FROM CurrentBalanceAudit WITH (NOLOCK)
WHERE BusinessDay BETWEEN '2020-07-31' AND '2020-06-30 23:59:57.000'
AND DENAME = 114