

SET XACT_ABORT ON
SET NOCOUNT ON

DECLARE		@RecordCount			INT		= 0,
			@ProcessingTime		DATETIME = GETDATE(),
			@ValidateCount		INT		= 0,
			@BatchCount			INT		= 1000,
			@Iteration			INT		= 10

DROP TABLE IF EXISTS #TEMP_IncorrectCPMCorrection_JobTable

CREATE TABLE #TEMP_IncorrectCPMCorrection_JobTable
(
	SN DECIMAL(19,0),
	AccountNumber VARCHAR(19),
	TranID DECIMAL(19, 0),
	NewCPM INT,
	JobStatus INT
)

SELECT @RecordCount = COUNT(1) FROM TEMP_IncorrectCPMCorrection WITH (NOLOCK) WHERE JobStatus = 1
PRINT 'TOTAL RECORDS TO UPDATE ===> ' + CAST(@RecordCount AS VARCHAR)
PRINT 'BATCH SIZE ===> ' + CAST(@BatchCount AS VARCHAR) + ' AND ITERATION ===> ' + CAST(@Iteration AS VARCHAR)
PRINT 'NUMBER OF TIME THIS SCRIPT NEEDS TO RUN WITH THIS SETTING ===> ' + CAST(CEILING(@RecordCount/(@BatchCount*@Iteration*1.0)) AS VARCHAR)

IF(@RecordCount > 0)
BEGIN
	WHILE(@RecordCount >= @ValidateCount and @Iteration > 0 )
	Begin 
		BEGIN TRY
			SET @ValidateCount = @ValidateCount + @BatchCount

			INSERT INTO #TEMP_IncorrectCPMCorrection_JobTable (SN, AccountNumber, TranID, NewCPM, JobStatus)
			SELECT --TOP(@BatchCount)
				SN, AccountNumber, TranID, NewCPM, JobStatus
			FROM TEMP_IncorrectCPMCorrection WITH (NOLOCK)
			WHERE JobStatus = 1

			BEGIN TRY
				BEGIN TRANSACTION

					UPDATE CP
					SET CreditPlanMaster = T.NewCPM
					FROM LogArTxnAddl CP
					JOIN #TEMP_IncorrectCPMCorrection_JobTable T ON (CP.TranId = T.TranID)

					UPDATE TS
						SET JobStatus = 2
					FROM TEMP_IncorrectCPMCorrection TS
					JOIN #TEMP_IncorrectCPMCorrection_JobTable TT ON (TS.SN = TT.SN)

				COMMIT TRANSACTION
			END TRY

			BEGIN CATCH
				IF @@TRANCOUNT > 0
					ROLLBACK TRANSACTION 
					SELECT ERROR_MESSAGE(),ERROR_LINE(),ERROR_NUMBER()
					RAISERROR('ERROR OCCURED :-', 16, 1);
			END CATCH

			TRUNCATE TABLE #TEMP_IncorrectCPMCorrection_JobTable
			SET @Iteration = @Iteration - 1 
			WAITFOR DELAY '00:00:02'
		END TRY

		BEGIN CATCH
			PRINT 'ERROR IN FILLING JOBTABLE'
			set @Iteration = @Iteration - 1 
		END CATCH
	END
	Begin 
		SELECT @RecordCount = COUNT(1) FROM TEMP_IncorrectCPMCorrection WITH (NOLOCK) WHERE JobStatus = 1
		IF(@RecordCount > 0)
		BEGIN
			Select 'ITERATION COMPLETE, PLEASE RUN THIS STEP AGAIN UNTIL IT IS FINISHED' [Result]
		END
		ELSE
		BEGIN 
			Select 'UPDATED SUCESSFULLY' [Result]
		END
	End
END
Else
Begin 
	Select 'NO RECORD TO UPDATE' [Result]
End
