/*
Move the schedules to corrected table batch wise
*/

SET XACT_ABORT ON
SET NOCOUNT ON

DECLARE				@RecordCount		INT = 0,
					@ValidateCount		INT = 0,
					@BatchCount			INT = 20,
					@LoopCount			INT  = 0,
					@PlanUUIDToCorrect	VARCHAR(64)

DROP TABLE IF EXISTS #TempAccountsJobTable_PlanCorrection

CREATE TABLE #TempAccountsJobTable_PlanCorrection
(
	Skey DECIMAL(19,0),
	PlanUUID VARCHAR(64),
	JobStatus INT
)

DROP TABLE IF EXISTS #TempPlansMoved

CREATE TABLE #TempPlansMoved
(
	Error INT,
	ErrorMessage VARCHAR(100),
	TotalRecordsMoved INT
)

SELECT @RecordCount = COUNT(1) FROM TEMP_PlanToMove WITH (NOLOCK) WHERE JobStatus = 0
PRINT 'TOTAL RECORDS TO UPDATE ===> ' + CAST(@RecordCount AS VARCHAR)
PRINT 'BATCH SIZE ===> ' + CAST(@BatchCount AS VARCHAR)
PRINT 'NUMBER OF TIME THIS SCRIPT NEEDS TO RUN WITH THIS SETTING ===> ' + CAST(CEILING(@RecordCount/(@BatchCount*1.0)) AS VARCHAR)

IF(@RecordCount > 0)
BEGIN 
	BEGIN TRY
		INSERT INTO #TempAccountsJobTable_PlanCorrection (Skey, PlanUUID, JobStatus)
		SELECT TOP(@BatchCount)
			Skey, PlanUUID, JobStatus
		FROM TEMP_PlanToMove WITH (NOLOCK)
		WHERE JobStatus = 0

		SELECT @LoopCount = COUNT(1) FROM #TempAccountsJobTable_PlanCorrection

		WHILE(@LoopCount > 0)
		BEGIN
			BEGIN TRY
				SET @PlanUUIDToCorrect = NULL
				SELECT TOP 1 @PlanUUIDToCorrect = PlanUUID FROM #TempAccountsJobTable_PlanCorrection WHERE JobStatus = 0

				IF(@PlanUUIDToCorrect IS NOT NULL)
				BEGIN 
					INSERT INTO #TempPlansMoved
					EXEC USP_RetailMoveCorrectSchedules 0, NULL, NULL, @PlanUUIDToCorrect, 0

					UPDATE TEMP_PlanToMove SET JobStatus = 1 WHERE PlanUUID = @PlanUUIDToCorrect

					--UPDATE TEMP_BadSchedulesCorrection SET JobStatus = 2 WHERE PlanUUID = @PlanUUIDToCorrect

					DELETE FROM #TempAccountsJobTable_PlanCorrection WHERE PlanUUID = @PlanUUIDToCorrect
				END

				SET @LoopCount = @LoopCount - 1

			END TRY

			BEGIN CATCH
				IF @@TRANCOUNT > 0
					ROLLBACK TRANSACTION 
					SELECT ERROR_MESSAGE(),ERROR_LINE(),ERROR_NUMBER()
					RAISERROR('ERROR OCCURED :-', 16, 1);
			END CATCH
		END
		BEGIN 
			SELECT 'Iteration Complete, Please run this step again until it is finished'
		END
	END TRY
	BEGIN CATCH
		PRINT 'Error in filling JobTable' 
	END CATCH
END
ELSE	
BEGIN 
	SELECT 'Updated Sucessfully'
END
