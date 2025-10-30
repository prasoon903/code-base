SET XACT_ABORT ON
SET NOCOUNT ON

DECLARE		@RecordCount	INT = 0,
			@ValidateCount	INT = 0,
			@BatchCount		INT = 50,
			@Iteration		INT = 5

DROP TABLE IF EXISTS #TempAccountsJobTable
CREATE TABLE #TempAccountsJobTable
(
	Skey  DECIMAL(19,0),
	acctId INT,
	NoPayDaysDelinquent INT, 
	DaysDelinquent INT,
	JobStatus INT
)

SELECT @RecordCount = COUNT(1) FROM Temp_bsegment_DelinqDays WITH (NOLOCK) WHERE JobStatus = 0

PRINT 'TOTAL RECORDS TO UPDATE ===> ' + CAST(@RecordCount AS VARCHAR)
PRINT 'BATCH SIZE ===> ' + CAST(@BatchCount AS VARCHAR) + ' AND ITERATION ===> ' + CAST(@Iteration AS VARCHAR)
PRINT 'NUMBER OF TIME THIS SCRIPT NEEDS TO RUN WITH THIS SETTING ===> ' + CAST(CEILING(@RecordCount/(@BatchCount*@Iteration*1.0)) AS VARCHAR)

IF(@RecordCount > 0)
BEGIN
	WHILE(@RecordCount >= @ValidateCount and @Iteration > 0 )
	Begin 
		BEGIN TRY
			SET @ValidateCount = @ValidateCount + @BatchCount

			INSERT INTO #TempAccountsJobTable (Skey, acctId, NoPayDaysDelinquent, DaysDelinquent, JobStatus)
			SELECT TOP(@BatchCount)
				Skey, acctId, NoPayDaysDelinquent, DaysDelinquent, JobStatus
			FROM Temp_bsegment_DelinqDays WITH (NOLOCK)
			WHERE JobStatus = 0

			BEGIN TRY
				BEGIN TRANSACTION
					UPDATE BCC
						SET 
							NoPayDaysDelinquent = TT.DaysDelinquent
						FROM BsegmentCreditCard BCC
						JOIN #TempAccountsJobTable TT ON (BCC.acctId = TT.acctId)
						WHERE TT.JobStatus = 0

					UPDATE TS
						SET JobStatus = 1
					FROM Temp_bsegment_DelinqDays TS
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
			PRINT 'Error in fiiling JobTable'
			set @Iteration = @Iteration - 1 
		END CATCH
	END
	Begin 
		Select 'Iteration Complete, Please run again'
	End
END
Else
Begin 
	Select 'Updated Sucessfully'
End
