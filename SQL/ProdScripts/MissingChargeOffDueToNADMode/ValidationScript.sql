SELECT BSAcctID, AccountNumber, CycleDueDTD, SystemStatus, ccinhparent125AID, LastStatementDate, AutoInitialChargeOffReason, 
ManualInitialChargeOffReason, ChargeOffDate, ChargeOffDateParam, SystemChargeOffStatus, UserChargeOffStatus
INTO #ChargeOffAccounts
FROM AccountInfoForReport WITH (NOLOCK)
WHERE BusinessDay = '2024-03-05 23:59:57'
AND SystemStatus <> 14
AND CycleDueDTD >= 7
AND (ChargeOffDateParam IS NULL OR ChargeOffDateParam < LastStatementDate)

SELECT ChargeOffDateParam, COUNT(1) FROM #ChargeOffAccounts GROUP BY ChargeOffDateParam

SELECT COUNT(1) FROM #ChargeOffAccounts


DECLARE @Row INT, 
		@Skey DECIMAL(19, 0), 
		@BATCHSIZE INT, 
		@TotalCount INT = 0, 
		@BatchCount INT = 0,
		@LoopCount INT = 0,
		@Records VARCHAR(MAX)

SET @BATCHSIZE = 300
SELECT @TotalCount = COUNT(1) FROM #ChargeOffAccounts
SET @BatchCount = @TotalCount/@BATCHSIZE + 1

PRINT @BatchCount

DROP TABLE IF EXISTS #TempDataToProcess
SELECT BSAcctID Skey, ROW_NUMBER() OVER(PARTITION BY NULL ORDER BY BSAcctID) [Row] INTO #TempDataToProcess FROM #ChargeOffAccounts

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

