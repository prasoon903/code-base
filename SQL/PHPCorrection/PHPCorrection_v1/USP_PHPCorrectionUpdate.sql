--EXEC USP_PHPCorrectionUpdate

CREATE OR ALTER PROCEDURE USP_PHPCorrectionUpdate
AS
BEGIN

	SET NOCOUNT ON
	SET QUOTED_IDENTIFIER ON
	SET ARITHABORT ON

	DECLARE 
		@ReportingCuttOffDay VARCHAR(20), 
		@ValidationTime DATETIME = GETDATE(),
		@RowsInserted DECIMAL(19, 0) = 0,
		@Description VARCHAR(MAX) = '',
		@ErrorFlag TINYINT = 1,
		@MaxCount INT = 0, 
		@LoopCounter INT = 0

	--SET @ValidationTime = dbo.PR_ISOGetBusinessTime()

	IF EXISTS (SELECT TOP 1 1 FROM CPS_Environment WITH (NOLOCK) WHERE Environment_Name LIKE '%LOCAL%')
	BEGIN
		SET @ValidationTime = dbo.PR_ISOGetBusinessTime()
	END

	DROP TABLE IF EXISTS #TempRecords
	SELECT *, ROW_NUMBER() OVER(PARTITION BY acctID ORDER BY StatementDate) Row
	INTO #TempRecords
	FROM PHPCorrectionData C WITH (NOLOCK) 
	WHERE JobStatus = 'New'

	SELECT @MaxCount = ISNULL(MAX(Row), 0) FROM #TempRecords

	IF EXISTS (SELECT TOP 1 1 FROM PHPCorrectionData WITH (NOLOCK) WHERE JobStatus = 'NEW')
	BEGIN
		BEGIN TRY
			WHILE @LoopCounter <= @MaxCount
			BEGIN
				BEGIN TRANSACTION
					SET @LoopCounter = @LoopCounter + 1
					UPDATE B
						SET 
							B.ReportHistoryCtrCC01 = CASE WHEN C.PHPCounter = 'ReportHistoryCtrCC01' THEN C.UpdatedCounterValue ELSE B.ReportHistoryCtrCC01 END,
							B.ReportHistoryCtrCC02 = CASE WHEN C.PHPCounter = 'ReportHistoryCtrCC02' THEN C.UpdatedCounterValue ELSE B.ReportHistoryCtrCC02 END,
							B.ReportHistoryCtrCC03 = CASE WHEN C.PHPCounter = 'ReportHistoryCtrCC03' THEN C.UpdatedCounterValue ELSE B.ReportHistoryCtrCC03 END,
							B.ReportHistoryCtrCC04 = CASE WHEN C.PHPCounter = 'ReportHistoryCtrCC04' THEN C.UpdatedCounterValue ELSE B.ReportHistoryCtrCC04 END,
							B.ReportHistoryCtrCC05 = CASE WHEN C.PHPCounter = 'ReportHistoryCtrCC05' THEN C.UpdatedCounterValue ELSE B.ReportHistoryCtrCC05 END,
							B.ReportHistoryCtrCC06 = CASE WHEN C.PHPCounter = 'ReportHistoryCtrCC06' THEN C.UpdatedCounterValue ELSE B.ReportHistoryCtrCC06 END,
							B.ReportHistoryCtrCC07 = CASE WHEN C.PHPCounter = 'ReportHistoryCtrCC07' THEN C.UpdatedCounterValue ELSE B.ReportHistoryCtrCC07 END,
							B.ReportHistoryCtrCC08 = CASE WHEN C.PHPCounter = 'ReportHistoryCtrCC08' THEN C.UpdatedCounterValue ELSE B.ReportHistoryCtrCC08 END,
							B.ReportHistoryCtrCC09 = CASE WHEN C.PHPCounter = 'ReportHistoryCtrCC09' THEN C.UpdatedCounterValue ELSE B.ReportHistoryCtrCC09 END,
							B.ReportHistoryCtrCC10 = CASE WHEN C.PHPCounter = 'ReportHistoryCtrCC10' THEN C.UpdatedCounterValue ELSE B.ReportHistoryCtrCC10 END,
							B.ReportHistoryCtrCC11 = CASE WHEN C.PHPCounter = 'ReportHistoryCtrCC11' THEN C.UpdatedCounterValue ELSE B.ReportHistoryCtrCC11 END,
							B.ReportHistoryCtrCC12 = CASE WHEN C.PHPCounter = 'ReportHistoryCtrCC12' THEN C.UpdatedCounterValue ELSE B.ReportHistoryCtrCC12 END,
							B.ReportHistoryCtrCC13 = CASE WHEN C.PHPCounter = 'ReportHistoryCtrCC13' THEN C.UpdatedCounterValue ELSE B.ReportHistoryCtrCC13 END,
							B.ReportHistoryCtrCC14 = CASE WHEN C.PHPCounter = 'ReportHistoryCtrCC14' THEN C.UpdatedCounterValue ELSE B.ReportHistoryCtrCC14 END,
							B.ReportHistoryCtrCC15 = CASE WHEN C.PHPCounter = 'ReportHistoryCtrCC15' THEN C.UpdatedCounterValue ELSE B.ReportHistoryCtrCC15 END,
							B.ReportHistoryCtrCC16 = CASE WHEN C.PHPCounter = 'ReportHistoryCtrCC16' THEN C.UpdatedCounterValue ELSE B.ReportHistoryCtrCC16 END,
							B.ReportHistoryCtrCC17 = CASE WHEN C.PHPCounter = 'ReportHistoryCtrCC17' THEN C.UpdatedCounterValue ELSE B.ReportHistoryCtrCC17 END,
							B.ReportHistoryCtrCC18 = CASE WHEN C.PHPCounter = 'ReportHistoryCtrCC18' THEN C.UpdatedCounterValue ELSE B.ReportHistoryCtrCC18 END,
							B.ReportHistoryCtrCC19 = CASE WHEN C.PHPCounter = 'ReportHistoryCtrCC19' THEN C.UpdatedCounterValue ELSE B.ReportHistoryCtrCC19 END,
							B.ReportHistoryCtrCC20 = CASE WHEN C.PHPCounter = 'ReportHistoryCtrCC20' THEN C.UpdatedCounterValue ELSE B.ReportHistoryCtrCC20 END,
							B.ReportHistoryCtrCC21 = CASE WHEN C.PHPCounter = 'ReportHistoryCtrCC21' THEN C.UpdatedCounterValue ELSE B.ReportHistoryCtrCC21 END,
							B.ReportHistoryCtrCC22 = CASE WHEN C.PHPCounter = 'ReportHistoryCtrCC22' THEN C.UpdatedCounterValue ELSE B.ReportHistoryCtrCC22 END,
							B.ReportHistoryCtrCC23 = CASE WHEN C.PHPCounter = 'ReportHistoryCtrCC23' THEN C.UpdatedCounterValue ELSE B.ReportHistoryCtrCC23 END,
							B.ReportHistoryCtrCC24 = CASE WHEN C.PHPCounter = 'ReportHistoryCtrCC24' THEN C.UpdatedCounterValue ELSE B.ReportHistoryCtrCC24 END
						FROM PHPCorrectionData C WITH (NOLOCK)
						JOIN #TempRecords T ON (C.Skey = T.Skey)
						JOIN BSegment_Balances B ON (C.Acctid = B.acctId)
						WHERE C.JobStatus = 'NEW'
						AND T.Row = @LoopCounter

						SET @RowsInserted = @RowsInserted + @@ROWCOUNT

						UPDATE P
						SET 
							JobStatus = 'DONE', 
							RowChangedDate = @ValidationTime 
						FROM PHPCorrectionData P
						JOIN #TempRecords T ON (P.Skey = T.Skey)
						WHERE P.JobStatus = 'NEW'
						AND T.Row = @LoopCounter

						SET @ErrorFlag = 0

				COMMIT TRANSACTION
			END

			
			SET @Description = 'PHP UPDATED SUCCESSFULLY FOR ' + TRY_CAST(@RowsInserted AS VARCHAR) + ' RECORDS.'
			
		END TRY
		BEGIN CATCH
			SET @RowsInserted = 0
			SET @ErrorFlag = 1
			ROLLBACK TRANSACTION
			SET @Description = @Description + 'ERROR LINE ( ' + CAST(ERROR_LINE() AS VARCHAR(50)) + ' ) DESCRIPTION : ' + ERROR_MESSAGE() + CHAR(10)
		END CATCH
	END
	ELSE
	BEGIN
		SET @ErrorFlag = 0
		SET @Description = 'NO RECORD TO UPDATE'
	END

	IF @ErrorFlag = 0
		SELECT 'SUCCESS|' + @Description AS 'RESULT'
	ELSE
		SELECT 'ERROR|' + @Description AS 'RESULT'
	
END