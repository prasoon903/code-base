-- CALCULATE HB



SET XACT_ABORT ON
SET NOCOUNT ON



DECLARE @ExecutionCount INT, @IterationLoop INT = 0

--SELECT @ExecutionCount = ISNULL(MAX(ExecutionCount), 0) + 1 FROM ##TEMP_HighBalance_Processing

DECLARE		@RecordCount		INT			= 0,
			@ProcessingTime		DATETIME	= GETDATE(),
			@ValidateCount		INT			= 0,
			@BatchCount			INT			= 1,
			@Iteration			INT			= 1

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

SELECT @RecordCount = COUNT(1) FROM TSDBOHBConversion WITH (NOLOCK) WHERE JobStatus = 3
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
			WHERE JobStatus = 3

			--INSERT INTO ##TEMP_HighBalance_Processing VALUES (@ExecutionCount, @BatchCount, @IterationLoop, 'JOB TABLE FILLED', @@ROWCOUNT)

			BEGIN TRY
				BEGIN TRANSACTION


					UPDATE T1
					SET
						HBRecalcStatus = BB.HBRecalcStatus,
						JobStatus = CASE WHEN HBRecalcRequired = 1 AND ISNULL(BB.HBRecalcStatus, 0) = 0 THEN T1.JobStatus ELSE -6 END
					FROM TSDBOHBConversion T1
					JOIN #TEMP_HighBalance_JobTable T2 ON (T1.SN = T2.SN)
					JOIN BSegment_Balances BB WITH (NOLOCK) ON (BB.acctID = T2.BSacctID)


					DELETE TT
					FROM TSDBOHBConversion A
					JOIN #TEMP_HighBalance_JobTable TT ON (A.SN = TT.SN)
					WHERE A.JobStatus = -6

			
			
					UPDATE C
					SET 
						AdjustedCurrentBalance = T1.CurrentBalance,
						AdjustedHighBalance = T1.AmtOfAcctHighBalLTD
					FROM TSDBOHBConversion_MetaData T1
					JOIN #TEMP_HighBalance_JobTable T2 ON (T1.acctID = T2.BSAcctID)
					JOIN CurrentStatementHeader C ON (T1.acctID = C.acctID AND T1.StatementDate = C.StatementDate)

			

					UPDATE BP
					SET
						AmtOfAcctHighBalLTD = T1.AmtOfAcctHighBalLTD
					FROM BSegment_Primary BP
					JOIN TSDBOHBConversion_Account T1 ON (BP.acctID = T1.acctID)
					JOIN #TEMP_HighBalance_JobTable T2 ON (T1.acctID = T2.BSAcctID)
					WHERE T2.JobStatus = 3


					UPDATE BP
					SET
						HBRecalcStatus = 2
					FROM BSegment_Balances BP
					JOIN TSDBOHBConversion_Account T1 ON (BP.acctID = T1.acctID)
					JOIN #TEMP_HighBalance_JobTable T2 ON (T1.acctID = T2.BSAcctID)
					WHERE T2.JobStatus = 3

					--SELECT * FROM #TEMP_HighBalance_JobTable
					--SELECT * FROM TSDBOHBConversion_Account
					--SELECT * FROM TSDBOHBConversion_Account

			

					UPDATE A
						SET JobStatus = 4
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
		SELECT @RecordCount = COUNT(1) FROM TSDBOHBConversion WITH (NOLOCK) WHERE JobStatus = 3
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