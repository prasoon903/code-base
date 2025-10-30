-- CALCULATE HB



SET XACT_ABORT ON
SET NOCOUNT ON



DECLARE @ExecutionCount INT, @IterationLoop INT = 0

SELECT @ExecutionCount = ISNULL(MAX(ExecutionCount), 0) + 1 FROM TEMP_HighBalance_Validation

DECLARE		@RecordCount		INT			= 0,
			@ProcessingTime		DATETIME	= dbo.PR_ISOGetBusinessTime(),
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


SELECT @RecordCount = COUNT(1) FROM TSDBOHBConversion WITH (NOLOCK) WHERE JobStatus = 2
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
			WHERE JobStatus = 2

			--SELECT * FROM #TEMP_HighBalance_JobTable
			--SELECT * FROM TSDBOHBConversion_Account

			INSERT INTO TEMP_HighBalance_Validation VALUES (@ExecutionCount, @BatchCount, @IterationLoop, 'JOB TABLE FILLED', @@ROWCOUNT, GETDATE())

			BEGIN TRY
				BEGIN TRANSACTION

					UPDATE T2
					SET
						JobStatus = CASE WHEN T1.CurrentBalance <> T2.CBRAmountOfCurrentBalance THEN -2 END
					FROM TSDBOHBConversion_Account T1
					JOIN #TEMP_HighBalance_JobTable T2 ON (T1.acctID = T2.BSAcctID)

					INSERT INTO TEMP_HighBalance_Validation VALUES (@ExecutionCount, @BatchCount, @IterationLoop, 'Account Validation DONE', @@ROWCOUNT, GETDATE())
			

					UPDATE T1
					SET 
						RecordStatus =	CASE 
											WHEN 
												T1.CurrentBalance <> (S.CurrentBalance+S.CurrentBalanceCO) - C.CurrentBalance
												AND S.StatementDate >= DATEADD(MM, -30, @ProcessingTime) 
												AND RecordStatus = 0 
												AND COALESCE(C.IsAcctSCRA, S.IsAcctSCRA, 0) = 0
											THEN 1
											ELSE RecordStatus 
										END,
						StmtCurrentBalance = (S.CurrentBalance+S.CurrentBalanceCO) - C.CurrentBalance
					FROM TSDBOHBConversion_MetaData T1
					JOIN #TEMP_HighBalance_JobTable T2 ON (T1.acctID = T2.BSAcctID)
					JOIN CurrentStatementHeader C WITH (NOLOCK) ON (T1.acctID = C.acctID AND T1.StatementDate = C.StatementDate)
					JOIN StatementHeader S WITH (NOLOCK) ON (S.acctID = C.acctID AND S.StatementDate = C.StatementDate)
					
					--SELECT * FROM TSDBOHBConversion_MetaData

					;WITH CTE
					AS
					(
						SELECT T1.acctID, T1.StatementDate, SUM(SH.CurrentBalance+SHC.CurrentBalanceCO-CSH.CurrentBalance) CurrentBalance
						FROM TSDBOHBConversion_MetaData T1
						JOIN #TEMP_HighBalance_JobTable T2 ON (T1.acctID = T2.BSAcctID) 
						JOIN SummaryHeader SH WITH (NOLOCK) ON (T1.acctID = SH.parent02AID AND T1.StatementDate = SH.StatementDate)
						JOIN SummaryHeaderCreditcard SHC WITH (NOLOCK) ON (SH.acctID = SHC.acctID AND SH.StatementID = SHC.StatementID) 
						JOIN CurrentSummaryHeader CSH WITH (NOLOCK) ON (SH.acctID = CSH.acctID AND SH.StatementID = CSH.StatementID) 
						WHERE T1.RecordStatus = 1
						GROUP BY T1.acctID, T1.StatementDate
					)
					UPDATE T1
					SET
						RecordStatus = CASE WHEN T1.CurrentBalance <> C.CurrentBalance THEN 1 ELSE 0 END,
						StmtCurrentBalance = C.CurrentBalance
					FROM TSDBOHBConversion_MetaData T1
					JOIN #TEMP_HighBalance_JobTable T2 ON (T1.acctID = T2.BSAcctID)
					JOIN CTE C ON (C.acctID = T1.acctID AND C.StatementDate = T1.StatementDate)
					WHERE T1.RecordStatus = 1


					
					;WITH CTE
					AS
					(
						SELECT T1.acctID
						FROM TSDBOHBConversion_MetaData T1
						JOIN #TEMP_HighBalance_JobTable T2 ON (T1.acctID = T2.BSAcctID)
						WHERE T1.RecordStatus = 1
						GROUP BY T1.acctID
					)
					UPDATE T
					SET
						JobStatus = -1
					FROM #TEMP_HighBalance_JobTable T
					JOIN CTE C ON (T.BSacctID = C.acctID)

					INSERT INTO TEMP_HighBalance_Validation VALUES (@ExecutionCount, @BatchCount, @IterationLoop, 'Statement Validation DONE', @@ROWCOUNT, GETDATE())

					--SELECT * FROM #TEMP_HighBalance_JobTable

					

			

					UPDATE A
						SET JobStatus = CASE WHEN TT.JobStatus IN (-1, -2) THEN TT.JobStatus ELSE 3 END
					FROM TSDBOHBConversion A
					JOIN #TEMP_HighBalance_JobTable TT ON (A.SN = TT.SN)

					INSERT INTO TEMP_HighBalance_Validation VALUES (@ExecutionCount, @BatchCount, @IterationLoop, 'JOB DONE', @@ROWCOUNT, GETDATE())

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
		SELECT @RecordCount = COUNT(1) FROM TSDBOHBConversion WITH (NOLOCK) WHERE JobStatus = 2
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