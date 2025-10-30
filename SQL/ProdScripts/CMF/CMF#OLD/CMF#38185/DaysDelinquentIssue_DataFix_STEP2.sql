SET XACT_ABORT ON
SET NOCOUNT ON

DECLARE		@RecordCount		INT = 0,
					@ValidateCount	INT = 0,
					@BatchCount		INT = 20,
					@Iteration				INT  = 2

DROP TABLE IF EXISTS #TempAccountsJobTable
CREATE TABLE #TempAccountsJobTable
(
	Skey  DECIMAL(19,0),
	acctId INT,
	FirstDueDate DATETIME,
	NoPayDaysDelinquent INT, 
	DaysDelinquent INT, 
	LAD DATETIME,
	JobStatus INT
)

SELECT @RecordCount = COUNT(1) FROM Temp_bsegment_DelinqDays WITH (NOLOCK) WHERE JobStatus IN (0, 1)
PRINT 'Total records to update'
PRINT @RecordCount

IF(@RecordCount > 0)
BEGIN
	WHILE(@RecordCount >= @ValidateCount and @Iteration > 0 )
	Begin 
		BEGIN TRY
			SET @ValidateCount = @ValidateCount + @BatchCount

			INSERT INTO #TempAccountsJobTable (Skey,acctId, FirstDueDate, NoPayDaysDelinquent, DaysDelinquent, LAD, JobStatus)
			SELECT TOP(@BatchCount)
				Skey,acctId, FirstDueDate, NoPayDaysDelinquent, DaysDelinquent, LAD, JobStatus
			FROM Temp_bsegment_DelinqDays WITH (NOLOCK)
			WHERE JobStatus IN (0, 1)

			BEGIN TRY
				BEGIN TRANSACTION
					UPDATE BCC
						SET 
							NoPayDaysDelinquent = TT.NoPayDaysDelinquent,
							DaysDelinquent = TT.DaysDelinquent
						FROM BsegmentCreditCard BCC
						JOIN #TempAccountsJobTable TT ON (BCC.acctId = TT.acctId)
						WHERE TT.JobStatus = 1

					UPDATE BCC
						SET 
							FirstDueDate = TT.FirstDueDate
						FROM BsegmentCreditCard BCC
						JOIN #TempAccountsJobTable TT ON (BCC.acctId = TT.acctId)
						WHERE TT.JobStatus = 0

					UPDATE CT 
						SET TranTime = DATEADD(SECOND, 10, getdate())
						FROM CommonTNP CT 
						JOIN #TempAccountsJobTable TT ON (CT.acctId = TT.acctId)
						WHERE CT.TranID = 0 AND ATID = 51 AND TT.JobStatus = 0

					UPDATE TS
						SET JobStatus = 3
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
