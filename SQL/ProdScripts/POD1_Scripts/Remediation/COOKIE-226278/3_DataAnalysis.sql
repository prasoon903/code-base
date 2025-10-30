DROP TABLE IF EXISTS #ValidData
;WITH CTE
AS
(
	SELECT *, ROW_NUMBER() OVER (PARTITION BY TransactionUUID, CaseID ORDER BY SN) [Rank] 
	FROM ##POD1Accounts
	WHERE CaseID IS NOT NULL
)
SELECT * INTO #ValidData FROM CTE WHERE [Rank] = 1

DROP TABLE IF EXISTS #InValidData
;WITH CTE
AS
(
	SELECT *, ROW_NUMBER() OVER (PARTITION BY TransactionUUID, CaseID ORDER BY SN) [Rank] 
	FROM ##POD1Accounts
	WHERE CaseID IS NOT NULL
)
SELECT * INTO #InValidData FROM CTE WHERE [Rank] > 1

DROP TABLE IF EXISTS #CaseIDNULL
SELECT * INTO #CaseIDNULL FROM ##POD1Accounts WHERE CaseID IS NULL

SELECT CaseID,TransactionUUID,AccountUUID,ClientID,Amount FROM #InValidData

SELECT CaseID,TransactionUUID,AccountUUID,ClientID,Amount FROM #CaseIDNULL

SELECT COUNT(1) FROM ##POD1Accounts
SELECT COUNT(1) FROM #InValidData
SELECT COUNT(1) FROM #ValidData
SELECT COUNT(1) FROM #CaseIDNULL

--SELECT * FROM ##TempRecords WHERE TransactionUUID = 'e8a2ac35-01f9-4fa7-b504-8954575ede26'


DROP TABLE IF EXISTS #LM40
;WITH CTE
AS
(
	SElect *, ROW_NUMBER() OVER (PARTITION BY TransactionLifeCycleUniqueID, TranID ORDER BY TranTime) [Ranking1] 
	FROM ##TempData WHERE cmttrantype = '40'
)
SELECT * INTO #LM40 FROM CTE WHERE [Ranking1] = 1

DROP TABLE IF EXISTS #OriginalLM40
SELECT T1.*, CP.TxnSource, CP.ClaimID
INTO #OriginalLM40 
FROM #LM40 T1
JOIN CCard_primary CP WITH (NOLOCK) ON (T1.TranID = CP.TranID)
WHERE CP.TxnSource <> '10'


SELECT * FROM #OriginalLM40 WHERE TransactionUUID IN ('94f4c164-a0f1-4a9e-91ae-a3dbae55ea88')
SELECT * FROM #LM40 WHERE TransactionUUID IN ('94f4c164-a0f1-4a9e-91ae-a3dbae55ea88')
SELECT * FROM ##TempRecords WHERE TransactionUUID IN ('94f4c164-a0f1-4a9e-91ae-a3dbae55ea88')

DROP TABLE IF EXISTS #LM40WithDisputes
;WITH CTE
AS
(
	SELECT T1.*, ROW_NUMBER() OVER (PARTITION BY TransactionUUID, T1.ClaimID ORDER BY T1.TranTime) [Rank]
	FROM #OriginalLM40 T1
	JOIN CCard_primary CP WITH (NOLOCK) ON (T1.TranID = CP.TranRef)
	WHERE CP.CMTTranType = '110'
)
SELECT * INTO #LM40WithDisputes FROM CTE WHERE [Rank] = 1

SELECT * FROM #LM40WithDisputes WHERE TransactionUUID IN ('94f4c164-a0f1-4a9e-91ae-a3dbae55ea88')

DROP TABLE IF EXISTS #TempRewardDetails
SELECT D1.Skey,T1.acctId, T1.AccountNumber, T1.UniversalUniqueID AccountUUID, D1.PurchaseTranId, T1.TranTime, T1.TransactionLifeCycleUniqueID, 
T1.TransactionUUID, D1.DisputeID, D1.TotalRewardPoints, D1.DisputeStage
INTO #TempRewardDetails
FROM #LM40WithDisputes T1
JOIN DisputeLog D1 WITH (NOLOCK) ON (T1.TranId = D1.PurchaseTranId)

DROP TABLE IF EXISTS #TempRewardDetailsWithClaimID
SELECT T1.*, CP.ClaimID
INTO #TempRewardDetailsWithClaimID
FROM #TempRewardDetails T1
JOIN CCard_Primary CP WITH (NOLOCK) ON (T1.PurchaseTranID = CP.TranID)

SELECT * FROM #TempRewardDetailsWithClaimID WHERE PurchaseTranID = 33767559689

SELECT * FROM #ValidData WHERE TransactionUUID IN ('94f4c164-a0f1-4a9e-91ae-a3dbae55ea88')

SELECT * FROM #TempRewardDetailsWithClaimID WHERE DisputeStage <> 0

--DROP TABLE IF EXISTS #ValidData
;WITH CTE
AS
(
	SELECT *, ROW_NUMBER() OVER (PARTITION BY PurchaseTranID, ClaimID ORDER BY TranTime) [Rank] 
	FROM #TempRewardDetailsWithClaimID
)
SELECT * FROM CTE WHERE [Rank] > 1

DROP TABLE IF EXISTS #TempNotMapped
SELECT T2.*
INTO #TempNotMapped 
FROM #TempRewardDetailsWithClaimID T1
RIGHT JOIN #ValidData T2 ON (T1.ClaimID = T2.CaseID)
WHERE --T2.CaseID IS NOT NULL AND 
T1.ClaimID IS NULL

DROP TABLE IF EXISTS #TempMapped
SELECT T1.*
INTO #TempMapped 
FROM #TempRewardDetailsWithClaimID T1
JOIN #ValidData T2 ON (T1.ClaimID = T2.CaseID)
--WHERE T2.CaseID IS NOT NULL


SELECT COUNT(1) FROM #TempMapped

SELECT COUNT(1) FROM #TempNotMapped

SELECT COUNT(1) FROM #ValidData --WHERE CaseID IS NOT NULL

SELECT * FROM #OriginalLM40 WHERE TransactionUUID IN ('94f4c164-a0f1-4a9e-91ae-a3dbae55ea88')
SELECT * FROM #LM40 WHERE TransactionUUID IN ('94f4c164-a0f1-4a9e-91ae-a3dbae55ea88')
SELECT * FROM ##TempRecords WHERE TransactionUUID IN ('94f4c164-a0f1-4a9e-91ae-a3dbae55ea88')

SELECT *
FROM #TempMapped T1
JOIN #TempNotMapped T2 ON (T1.ClaimID = T2.CaseID)




SELECT 'UPDATE TOP(1) DisputeLog SET TotalRewardPoints = 0.00 WHERE Skey = ' + TRY_CAST(Skey AS VARCHAR) , * 
FROM #TempMapped

SELECT * FROM #TempNotMapped

SELECT AccountUUID,TransactionUUID,CaseID,Amount FROM #TempNotMapped

SELECT * FROM #ValidData-- WHERE CaseID IS NOT NULL

SELECT RTRIM(AccountNumber) AccountNumber, AccountUUID, PurchaseTranID, TranTime TransactionTime, TransactionUUID TransactionID, DisputeID, ClaimID CaseID, TotalRewardPoints
FROM #TempMapped

SELECT AccountUUID,TransactionUUID,CaseID,Amount FROM #ValidData


SELECT T1.CaseID, T1.TransactionUUID, T1.AccountUUID, RTRIM(BP.AccountNumber) AccountNumber--, T1.Amount DisputeAmount
FROM #TempNotMapped T1
LEFT JOIN Bsegment_Primary BP WITH (NOLOCK) ON (T1.AccountUUID = BP.UniversalUniqueID)
WHERE BP.UniversalUniqueID IS NOT NULL


SELECT T1.CaseID, T1.TransactionUUID, T1.AccountUUID, T1.Amount
FROM #TempNotMapped T1
LEFT JOIN Bsegment_Primary BP WITH (NOLOCK) ON (T1.AccountUUID = BP.UniversalUniqueID)
WHERE BP.UniversalUniqueID IS NULL


SELECT T1.CaseID, T1.ClientID, T1.TransactionUUID, T1.AccountUUID, T1.Amount DisputeAmount FROM #ValidData t1-- WHERE CaseID IS NOT NULL


SELECT * FROM BSegment_Primary BP WITH (NOLOCK) WHERE UniversalUniqueID = 'e899a866-9e85-4485-9924-9a223d377239'


DECLARE @Row INT, 
		@Skey DECIMAL(19, 0), 
		@BATCHSIZE INT, 
		@TotalCount INT = 0, 
		@BatchCount INT = 0,
		@LoopCount INT = 0,
		@Records VARCHAR(MAX)

SET @BATCHSIZE = 300
SELECT @TotalCount = COUNT(1) FROM #TempMapped
SET @BatchCount = @TotalCount/@BATCHSIZE + 1

PRINT @BatchCount

DROP TABLE IF EXISTS #TempDataToProcess
SELECT Skey, ROW_NUMBER() OVER(PARTITION BY NULL ORDER BY TranTime) [Row] INTO #TempDataToProcess FROM #TempMapped

DROP TABLE IF EXISTS #TempSkey
CREATE TABLE #TempSkey (SN INT IDENTITY(1, 1), Records VARCHAR(MAX))

WHILE(@LoopCount <= @BatchCount)
BEGIN
	SET @LoopCount += 1

	DECLARE db_cursor CURSOR FOR
	SELECT Skey, Row FROM #TempDataToProcess WHERE Row > @BATCHSIZE*(@LoopCount-1) AND Row <= @BATCHSIZE*(@LoopCount)
	

	OPEN db_cursor 
	FETCH NEXT FROM db_cursor INTO @Skey, @Row

	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF(@Row = 1)
		BEGIN
			--SET @Records = REPLACE(REPLACE(TRY_CAST(@Skey AS NVARCHAR(MAX)), CHAR(13), ''), CHAR(10), '')
			SET @Records = TRY_CAST(@Skey AS VARCHAR)
		END
		ELSE
		BEGIN
			--SET @Records = @Records + ', ' + REPLACE(REPLACE(TRY_CAST(@Skey AS NVARCHAR(MAX)), CHAR(13), ''), CHAR(10), '')
			SET @Records = @Records + ', ' + TRY_CAST(@Skey AS VARCHAR)
		END

		FETCH NEXT FROM db_cursor INTO @Skey, @Row
	END
	PRINT @LoopCount
	PRINT @Records
	INSERT INTO #TempSkey VALUES (@Records)
	SET @Records = ''

	CLOSE db_cursor
	DEALLOCATE db_cursor
END

SELECT * FROM #TempSkey ORDER BY SN


SELECT * FROM #TempMapped
