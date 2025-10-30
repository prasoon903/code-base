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

SELECT @ExecutionCount = ISNULL(MAX(ExecutionCount), 0) + 1 FROM ##TEMP_HighBalance_Update

DECLARE		@RecordCount		INT			= 0,
			@ProcessingTime		DATETIME	= GETDATE(),
			@ValidateCount		INT			= 0,
			@BatchCount			INT			= 10,
			@Iteration			INT			= 2

DROP TABLE IF EXISTS #TEMP_HighBalance_JobTable
CREATE TABLE #TEMP_HighBalance_JobTable 
(
	SN DECIMAL(19,0),
	BSacctID INT,
	AccountNumber VARCHAR(19),
	CalcCurrentBalance MONEY, 
	CalcHighBalance MONEY,
	CBRAmountOfCurrentBalance_STMT MONEY,
	CBRAmountOfHighBalance_STMT MONEY,
	LastStatementDate DATETIME,
	JobStatus INT DEFAULT(0)
)


SELECT @RecordCount = COUNT(1) FROM ##Accounts WITH (NOLOCK) WHERE JobStatus = 1
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

			INSERT INTO #TEMP_HighBalance_JobTable (SN, BSacctId, AccountNumber, CalcCurrentBalance, CalcHighBalance, CBRAmountOfCurrentBalance_STMT, CBRAmountOfHighBalance_STMT, LastStatementDate, JobStatus)
			SELECT TOP(@BatchCount)
				SN, BSacctId, AccountNumber, CalcCurrentBalance, CalcHighBalance, CBRAmountOfCurrentBalance_STMT, CBRAmountOfHighBalance_STMT, LastStatementDate, JobStatus
			FROM ##Accounts WITH (NOLOCK)
			WHERE JobStatus = 1

			INSERT INTO ##TEMP_HighBalance_Update VALUES (@ExecutionCount, @BatchCount, @IterationLoop, 'JOB TABLE FILLED', @@ROWCOUNT)

			BEGIN TRY
				
					UPDATE B
					SET
						CBRAmountOfCurrentBalance = CalcCurrentBalance,
						CBRAmountOfCurrentBalanceBP1 = 0,	
						CBRAmountOfCurrentBalanceBP2 = 0,	
						CBRAmountOfCurrentBalanceBP3 = 0,	
						CBRAmountOfCurrentBalanceBP4 = 0,	
						CBRAmountOfHighBalance	= CalcHighBalance,
						CBRAmountOfHighBalanceBP1 = 0,	
						CBRAmountOfHighBalanceBP2 = 0,	
						CBRAmountOfHighBalanceBP3 = 0,	
						CBRAmountOfHighBalanceBP4 = 0,	
						CBRBreakPoint1 = NULL,
						CBRBreakPoint2 = NULL,	
						CBRBreakPoint3 = NULL,	
						CBRBreakPoint4 = NULL,	
						CBRLastCalculatedDate = NULL
					FROM #BSegment_Balances B
					JOIN #TEMP_HighBalance_JobTable T ON (B.acctID = T.BSAcctID)

					INSERT INTO ##TEMP_HighBalance_Update VALUES (@ExecutionCount, @BatchCount, @IterationLoop, 'BSegment_Balances TABLE UPDATED WITH VALUES', @@ROWCOUNT) 

					UPDATE B
					SET
						AmtOfAcctHighBalLTD = CalcHighBalance
					FROM #BSegment_Primary B
					JOIN #TEMP_HighBalance_JobTable T ON (B.acctID = T.BSAcctID)

					INSERT INTO ##TEMP_HighBalance_Update VALUES (@ExecutionCount, @BatchCount, @IterationLoop, 'BSegment_Primary TABLE UPDATED WITH VALUES', @@ROWCOUNT) 

					UPDATE B
					SET
						CBRAmountOfCurrentBalance = CBRAmountOfCurrentBalance_STMT,
						CBRAmountOfHighBalance	= CBRAmountOfHighBalance_STMT
					FROM #CurrentStatementHeader B
					JOIN #TEMP_HighBalance_JobTable T ON (B.acctID = T.BSAcctID AND B.StatementDate = T.LastStatementDate)

					INSERT INTO ##TEMP_HighBalance_Update VALUES (@ExecutionCount, @BatchCount, @IterationLoop, 'CurrentStatementHeader TABLE UPDATED WITH VALUES', @@ROWCOUNT) 

					UPDATE A
						SET JobStatus = 2
					FROM ##Accounts A
					JOIN #TEMP_HighBalance_JobTable TT ON (A.SN = TT.SN)
					AND A.JobStatus = 1

					INSERT INTO ##TEMP_HighBalance_Update VALUES (@ExecutionCount, @BatchCount, @IterationLoop, 'JOB TABLE UPDATED', @@ROWCOUNT) 

				
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
		SELECT @RecordCount = COUNT(1) FROM ##Accounts WITH (NOLOCK) WHERE JobStatus = 1
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
