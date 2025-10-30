/*
Updating the correct activity order of the plans batch wise.
*/

SET XACT_ABORT ON
SET NOCOUNT ON

DECLARE				@RecordCount		INT = 0,
					@ValidateCount		INT = 0,
					@BatchCount			INT = 50,
					@Iteration			INT  = 2

DROP TABLE IF EXISTS #TempAccountsJobTable_ActivityOrder

CREATE TABLE #TempAccountsJobTable_ActivityOrder
(
	Skey DECIMAL(19,0),
	SkeyOnILP DECIMAL(19,0),
	PlanUUID VARCHAR(64),
	PlanID INT,
	ActivityOrder INT,
	JobStatus INT
)

SELECT @RecordCount = COUNT(1) FROM TEMP_BadSchedulesCorrection_ActivityOrder WITH (NOLOCK) WHERE JobStatus = 0
PRINT 'TOTAL RECORDS TO UPDATE ===> ' + CAST(@RecordCount AS VARCHAR)
PRINT 'BATCH SIZE ===> ' + CAST(@BatchCount AS VARCHAR) + ' AND ITERATION ===> ' + CAST(@Iteration AS VARCHAR)
PRINT 'NUMBER OF TIME THIS SCRIPT NEEDS TO RUN WITH THIS SETTING ===> ' + CAST(CEILING(@RecordCount/(@BatchCount*@Iteration*1.0)) AS VARCHAR)

IF(@RecordCount > 0)
BEGIN
	WHILE(@RecordCount >= @ValidateCount and @Iteration > 0 )
	Begin 
		BEGIN TRY
			SET @ValidateCount = @ValidateCount + @BatchCount

			INSERT INTO #TempAccountsJobTable_ActivityOrder (Skey, SkeyOnILP, PlanUUID, PlanID, ActivityOrder, JobStatus)
			SELECT TOP(@BatchCount)
				Skey, SkeyOnILP, PlanUUID, PlanID, ActivityOrder, JobStatus
			FROM TEMP_BadSchedulesCorrection_ActivityOrder WITH (NOLOCK)
			WHERE JobStatus = 0

			BEGIN TRY
				BEGIN TRANSACTION
					UPDATE ILPS
						SET 
							ActivityOrder = TT.ActivityOrder
						FROM ILPScheduleDetailSummary ILPS
						JOIN #TempAccountsJobTable_ActivityOrder TT ON (ILPS.Skey = TT.SkeyOnILP)

					UPDATE TS
						SET JobStatus = 1
					FROM TEMP_BadSchedulesCorrection_ActivityOrder TS
					JOIN #TempAccountsJobTable_ActivityOrder TT ON (TS.Skey = TT.Skey)
				COMMIT TRANSACTION
			END TRY

			BEGIN CATCH
				IF @@TRANCOUNT > 0
					ROLLBACK TRANSACTION 
					SELECT ERROR_MESSAGE(),ERROR_LINE(),ERROR_NUMBER()
					RAISERROR('ERROR OCCURED :-', 16, 1);
			END CATCH

			TRUNCATE TABLE #TempAccountsJobTable_ActivityOrder
			SET @Iteration = @Iteration - 1 
		END TRY

		BEGIN CATCH
			PRINT 'Error in filling JobTable'
			set @Iteration = @Iteration - 1 
		END CATCH
	END
	Begin 
		Select 'Iteration Complete, Please run this step again until it is finished'
	End
END
Else
Begin 
	Select 'Updated Sucessfully'
End
