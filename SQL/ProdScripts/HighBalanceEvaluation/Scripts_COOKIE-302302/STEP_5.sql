/*
Updating the CPS data
*/

SET XACT_ABORT ON
SET NOCOUNT ON

--DECLARE		@AccountID INT,
--			@AccountNumber VARCHAR(19), 
--			@AccountCreationTime DATETIME,
--			@ProcessTime DATETIME

DECLARE @ExecutionCount INT, @IterationLoop INT = 0


DECLARE		@RecordCount		INT			= 0,
			@ProcessingTime		DATETIME	= GETDATE(),
			@ValidateCount		INT			= 0,
			@BatchCount			INT			= 1000,
			@Iteration			INT			= 50

DROP TABLE IF EXISTS #TEMP_HighBalance_JobTable
CREATE TABLE #TEMP_HighBalance_JobTable 
(
	acctID INT,
	JobStatus INT DEFAULT(0)
)


SELECT @RecordCount = COUNT(1) FROM ##CBRAccounts WITH (NOLOCK) WHERE JobStatus = 5
PRINT 'TOTAL RECORDS TO UPDATE ===> ' + CAST(@RecordCount AS VARCHAR)
PRINT 'BATCH SIZE ===> ' + CAST(@BatchCount AS VARCHAR) + ' AND ITERATION ===> ' + CAST(@Iteration AS VARCHAR)
PRINT 'NUMBER OF TIME THIS SCRIPT NEEDS TO RUN WITH THIS SETTING ===> ' + CAST(CEILING(@RecordCount/(@BatchCount*@Iteration*1.0)) AS VARCHAR)

IF(@RecordCount > 0)
BEGIN
	WHILE(@RecordCount >= @ValidateCount and @Iteration > 0 )
	Begin 
		BEGIN TRY
			SET @ValidateCount = @ValidateCount + @BatchCount

			SET @IterationLoop = @IterationLoop + 1

			INSERT INTO #TEMP_HighBalance_JobTable (acctId, JobStatus)
			SELECT TOP(@BatchCount)
				acctId, JobStatus
			FROM ##CBRAccounts WITH (NOLOCK)
			WHERE JobStatus = 5


			BEGIN TRY
				
					UPDATE B
					SET
						CBRAmountOfCurrentBalanceBP1 = 0,	
						CBRAmountOfCurrentBalanceBP2 = 0,	
						CBRAmountOfCurrentBalanceBP3 = 0,	
						CBRAmountOfCurrentBalanceBP4 = 0,	
						CBRAmountOfHighBalanceBP1 = 0,	
						CBRAmountOfHighBalanceBP2 = 0,	
						CBRAmountOfHighBalanceBP3 = 0,	
						CBRAmountOfHighBalanceBP4 = 0,	
						CBRBreakPoint1 = NULL,
						CBRBreakPoint2 = NULL,	
						CBRBreakPoint3 = NULL,	
						CBRBreakPoint4 = NULL,	
						CBRLastCalculatedDate = NULL
					FROM BSegment_Balances B
					JOIN #TEMP_HighBalance_JobTable T ON (B.acctID = T.AcctID)

					UPDATE A
						SET JobStatus = 10
					FROM ##CBRAccounts A
					JOIN #TEMP_HighBalance_JobTable TT ON (A.acctID = TT.acctID)
					AND A.JobStatus = 5
					
				
			END TRY

			BEGIN CATCH
				IF @@TRANCOUNT > 0
					SELECT ERROR_MESSAGE(),ERROR_LINE(),ERROR_NUMBER()
					RAISERROR('ERROR OCCURED :-', 16, 1);
			END CATCH

			TRUNCATE TABLE #TEMP_HighBalance_JobTable
			SET @Iteration = @Iteration - 1 
			--WAITFOR DELAY '00:00:02'
		END TRY

		BEGIN CATCH
			PRINT 'ERROR IN FILLING JOBTABLE'
			SELECT ERROR_MESSAGE(),ERROR_LINE(),ERROR_NUMBER()
			set @Iteration = @Iteration - 1 
		END CATCH
	END
	BEGIN 
		SELECT @RecordCount = COUNT(1) FROM ##CBRAccounts WITH (NOLOCK) WHERE JobStatus = 5
		IF(@RecordCount > 0)
		BEGIN
			SELECT 'ITERATION COMPLETE, PLEASE RUN THIS STEP AGAIN UNTIL IT IS FINISHED' [Result]
		END
		ELSE
		BEGIN 
			SELECT 'UPDATED SUCESSFULLY' [Result]
		END
	END
END
Else
Begin 
	SELECT 'NO RECORD TO UPDATE' [Result]
End
