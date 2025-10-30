


-- CALCULATE HB



SET XACT_ABORT ON
SET NOCOUNT ON



DECLARE @ExecutionCount INT, @IterationLoop INT = 0

--SELECT @ExecutionCount = ISNULL(MAX(ExecutionCount), 0) + 1 FROM ##TEMP_HighBalance_Processing

DECLARE		@RecordCount		INT			= 0,
			@ProcessingTime		DATETIME	= GETDATE(),
			@ValidateCount		INT			= 0,
			@BatchCount			INT			= 100,
			@Iteration			INT			= 5

DROP TABLE IF EXISTS #TEMP_HighBalance_JobTable
CREATE TABLE #TEMP_HighBalance_JobTable 
(
	SN DECIMAL(19,0),
	BSacctID INT,
	AccountNumber VARCHAR(19),
	Acquisitiondate DATETIME, 
	CBRAmountOfCurrentBalance MONEY, 
	CBRAmountOfHighBalance MONEY,
	LastStatementDate DATETIME,
	ProcessTime DATETIME,
	JobStatus INT DEFAULT(0)
)

--DROP TABLE IF EXISTS ##TEMP_HighBalance_Processing
--CREATE TABLE ##TEMP_HighBalance_Processing 
--(
--	SN DECIMAL(19,0) IDENTITY(1, 1),
--	Iteration INT,
--	Activity VARCHAR(100),
--	RecordCount INT
--)

SELECT @RecordCount = COUNT(1) FROM TSDBOHBConversion WITH (NOLOCK) WHERE JobStatus = 0
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

			INSERT INTO #TEMP_HighBalance_JobTable (SN, BSacctId, AccountNumber, CBRAmountOfCurrentBalance, CBRAmountOfHighBalance, LastStatementDate, ProcessTime, JobStatus)
			SELECT TOP(@BatchCount)
				SN, acctId, AccountNumber, CurrentBalance, AmtOfAcctHighBalLTD, LastStatementDate, CreatedTime, JobStatus
			FROM TSDBOHBConversion WITH (NOLOCK)
			WHERE JobStatus = 0

			--INSERT INTO ##TEMP_HighBalance_Processing VALUES (@ExecutionCount, @BatchCount, @IterationLoop, 'JOB TABLE FILLED', @@ROWCOUNT)

			BEGIN TRY
				BEGIN TRANSACTION
			
			
					UPDATE BC
					SET
						HBRecalcRequired = 1
					FROM BSegment_Balances BC
					JOIN #TEMP_HighBalance_JobTable T ON (BC.acctID = T.BSacctId)

					UPDATE A
					SET JobStatus = 1
					FROM TSDBOHBConversion A
					JOIN #TEMP_HighBalance_JobTable TT ON (A.SN = TT.SN)


				COMMIT TRANSACTION
				

			END TRY

			BEGIN CATCH
				IF @@TRANCOUNT > 0
					ROLLBACK TRANSACTION
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
		SELECT @RecordCount = COUNT(1) FROM TSDBOHBConversion WITH (NOLOCK) WHERE JobStatus = 0
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