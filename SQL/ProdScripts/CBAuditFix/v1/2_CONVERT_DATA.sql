/*
Updating the CPS data
*/

SET XACT_ABORT ON
SET NOCOUNT ON

DECLARE		@RecordCount		INT			= 0,
			@ProcessingTime		DATETIME	= GETDATE(),
			@ValidateCount		INT			= 0,
			@BatchCount			INT			= 100,
			@Iteration			INT			= 4

DROP TABLE IF EXISTS #TEMP_CBA_JobTable
CREATE TABLE #TEMP_CBA_JobTable 
(
	Skey DECIMAL(19,0),
	acctID INT,
	IdentityField DECIMAL(19,0),
	JobStatus INT DEFAULT(0)
)

SELECT @RecordCount = COUNT(1) FROM ##TempCBA WITH (NOLOCK) WHERE JobStatus = 0
PRINT 'TOTAL RECORDS TO UPDATE ===> ' + CAST(@RecordCount AS VARCHAR)
PRINT 'BATCH SIZE ===> ' + CAST(@BatchCount AS VARCHAR) + ' AND ITERATION ===> ' + CAST(@Iteration AS VARCHAR)
PRINT 'NUMBER OF TIME THIS SCRIPT NEEDS TO RUN WITH THIS SETTING ===> ' + CAST(CEILING(@RecordCount/(@BatchCount*@Iteration*1.0)) AS VARCHAR)

IF(@RecordCount > 0)
BEGIN
	WHILE(@RecordCount >= @ValidateCount and @Iteration > 0 )
	Begin 
		BEGIN TRY
			SET @ValidateCount = @ValidateCount + @BatchCount

			INSERT INTO #TEMP_CBA_JobTable (Skey, acctId, IdentityField, JobStatus)
			SELECT TOP(@BatchCount)
				Skey, acctId, IdentityField, JobStatus
			FROM ##TempCBA WITH (NOLOCK)
			WHERE JobStatus = 0

			BEGIN TRY
				BEGIN TRANSACTION

					DELETE C
					FROM CurrentBalanceAudit C
					JOIN ##TempCBA T ON (C.AID = T.acctId AND C.ATID = 51 AND C.IdentityField = T.IdentityField)
					WHERE T.JobStatus = 0

					UPDATE TS
						SET JobStatus = 1
					FROM ##TempCBA TS
					JOIN #TEMP_CBA_JobTable TT ON (TS.Skey = TT.Skey)

				COMMIT TRANSACTION
			END TRY

			BEGIN CATCH
				IF @@TRANCOUNT > 0
					ROLLBACK TRANSACTION 
					SELECT ERROR_MESSAGE(),ERROR_LINE(),ERROR_NUMBER()
					RAISERROR('ERROR OCCURED :-', 16, 1);
			END CATCH

			TRUNCATE TABLE #TEMP_CBA_JobTable
			SET @Iteration = @Iteration - 1 
			--WAITFOR DELAY '00:00:02'
		END TRY

		BEGIN CATCH
			PRINT 'ERROR IN FILLING JOBTABLE'
			set @Iteration = @Iteration - 1 
		END CATCH
	END
	Begin 
		SELECT @RecordCount = COUNT(1) FROM ##TempCBA WITH (NOLOCK) WHERE JobStatus = 0
		IF(@RecordCount > 0)
		BEGIN
			SELECT 'ITERATION COMPLETE, PLEASE RUN THIS STEP AGAIN UNTIL IT IS FINISHED' [Result]
		END
		ELSE
		BEGIN 
			SELECT 'UPDATED SUCESSFULLY' [Result]
		END
	End
END
Else
Begin 
	SELECT 'NO RECORD TO UPDATE' [Result]
End
