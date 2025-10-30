/*
De-link the schedules batch wise as we donot require them as per the new enhancement also marking the job as done.
*/

SET XACT_ABORT ON
SET NOCOUNT ON

DECLARE				@RecordCount		INT = 0,
					@ValidateCount		INT = 0,
					@BatchCount			INT = 1000,
					@Iteration			INT  = 2

DROP TABLE IF EXISTS #TempAccountsJobTable
CREATE TABLE #TempAccountsJobTable
(
	Skey DECIMAL(19,0),
	PlanUUID VARCHAR(64),
	PlanID INT,
	ScheduleID INT,
	JobStatus INT
)

SELECT @RecordCount = COUNT(1) FROM TEMP_BadSchedulesCorrection WITH (NOLOCK) WHERE JobStatus = 0
PRINT 'TOTAL RECORDS TO UPDATE ===> ' + CAST(@RecordCount AS VARCHAR)
PRINT 'BATCH SIZE ===> ' + CAST(@BatchCount AS VARCHAR) + ' AND ITERATION ===> ' + CAST(@Iteration AS VARCHAR)
PRINT 'NUMBER OF TIME THIS SCRIPT NEEDS TO RUN WITH THIS SETTING ===> ' + CAST(CEILING(@RecordCount/(@BatchCount*@Iteration*1.0)) AS VARCHAR)

IF(@RecordCount > 0)
BEGIN
	WHILE(@RecordCount >= @ValidateCount and @Iteration > 0 )
	Begin 
		BEGIN TRY
			SET @ValidateCount = @ValidateCount + @BatchCount

			INSERT INTO #TempAccountsJobTable (Skey, PlanUUID, PlanID, ScheduleID, JobStatus)
			SELECT TOP(@BatchCount)
				Skey, PlanUUID, PlanID, ScheduleID, JobStatus
			FROM TEMP_BadSchedulesCorrection WITH (NOLOCK)
			WHERE JobStatus = 0

			BEGIN TRY
				BEGIN TRANSACTION
					UPDATE ILPS
						SET 
							ILPS.ScheduleType = -99
						FROM ILPScheduleDetailSummary ILPS
						JOIN #TempAccountsJobTable TT ON (ILPS.ScheduleID = TT.ScheduleID)

					UPDATE TS
						SET JobStatus = 1
					FROM TEMP_BadSchedulesCorrection TS
					JOIN #TempAccountsJobTable TT ON (TS.Skey = TT.Skey)
				COMMIT TRANSACTION
			END TRY

			BEGIN CATCH
				IF @@TRANCOUNT > 0
					ROLLBACK TRANSACTION 
					SELECT ERROR_MESSAGE(),ERROR_LINE(),ERROR_NUMBER()
					RAISERROR('ERROR OCCURED :-', 16, 1);
			END CATCH

			TRUNCATE TABLE #TempAccountsJobTable
			set @Iteration = @Iteration - 1 
		END TRY

		BEGIN CATCH
			PRINT 'Error in filling JobTable'
			SET @Iteration = @Iteration - 1 
		END CATCH
	END
	Begin 
		Select 'Iteration Complete, Please run this step again until it is finished'
	End
END
Else
Begin 
	Select 'Updated Sucessfully, now go to the next step'
End
