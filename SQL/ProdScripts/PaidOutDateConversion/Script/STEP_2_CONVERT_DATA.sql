/*
Updating the CPS data
*/

SET XACT_ABORT ON
SET NOCOUNT ON

DECLARE		@RecordCount		INT			= 0,
			@ProcessingTime		DATETIME	= GETDATE(),
			@ValidateCount		INT			= 0,
			@BatchCount			INT			= 1000,
			@Iteration			INT			= 10

DROP TABLE IF EXISTS #TEMP_PaidOutDate_Populator_JobTable
CREATE TABLE #TEMP_PaidOutDate_Populator_JobTable 
(
	Skey DECIMAL(19,0),
	acctID INT,
	parent02AID INT,
	CurrentBalance MONEY,
	PaidOutDate DATETIME,
	JobStatus INT DEFAULT(0)
)

SELECT @RecordCount = COUNT(1) FROM PaidOutDate_Populator WITH (NOLOCK) WHERE JobStatus = 0
PRINT 'TOTAL RECORDS TO UPDATE ===> ' + CAST(@RecordCount AS VARCHAR)
PRINT 'BATCH SIZE ===> ' + CAST(@BatchCount AS VARCHAR) + ' AND ITERATION ===> ' + CAST(@Iteration AS VARCHAR)
PRINT 'NUMBER OF TIME THIS SCRIPT NEEDS TO RUN WITH THIS SETTING ===> ' + CAST(CEILING(@RecordCount/(@BatchCount*@Iteration*1.0)) AS VARCHAR)

IF(@RecordCount > 0)
BEGIN
	WHILE(@RecordCount >= @ValidateCount and @Iteration > 0 )
	Begin 
		BEGIN TRY
			SET @ValidateCount = @ValidateCount + @BatchCount

			INSERT INTO #TEMP_PaidOutDate_Populator_JobTable (Skey, acctId, parent02AID, CurrentBalance, PaidOutDate, JobStatus)
			SELECT TOP(@BatchCount)
				Skey, acctId, parent02AID, CurrentBalance, PaidOutDate, JobStatus
			FROM PaidOutDate_Populator WITH (NOLOCK)
			WHERE JobStatus = 0

			BEGIN TRY
				BEGIN TRANSACTION

					UPDATE CPC
					SET PaidOutDate = TT.PaidOutDate
					FROM CPSgmentCreditCard CPC
					JOIN CPSgmentAccounts CPS WITH (NOLOCK) ON CPC.acctId = CPS.acctId
					JOIN #TEMP_PaidOutDate_Populator_JobTable TT ON TT.acctID = CPS.acctID
					WHERE CPS.CurrentBalance+CPC.CurrentBalanceCO <= 0

					UPDATE TS
						SET JobStatus = 1
					FROM PaidOutDate_Populator TS
					JOIN #TEMP_PaidOutDate_Populator_JobTable TT ON (TS.Skey = TT.Skey)

				COMMIT TRANSACTION
			END TRY

			BEGIN CATCH
				IF @@TRANCOUNT > 0
					ROLLBACK TRANSACTION 
					SELECT ERROR_MESSAGE(),ERROR_LINE(),ERROR_NUMBER()
					RAISERROR('ERROR OCCURED :-', 16, 1);
			END CATCH

			TRUNCATE TABLE #TEMP_PaidOutDate_Populator_JobTable
			SET @Iteration = @Iteration - 1 
			WAITFOR DELAY '00:00:02'
		END TRY

		BEGIN CATCH
			PRINT 'ERROR IN FILLING JOBTABLE'
			set @Iteration = @Iteration - 1 
		END CATCH
	END
	Begin 
		SELECT @RecordCount = COUNT(1) FROM PaidOutDate_Populator WITH (NOLOCK) WHERE JobStatus = 0
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
