USE CCGS_CoreIssue
GO

SET XACT_ABORT ON
SET NOCOUNT ON

DECLARE		@RecordCount	INT = 0,
			@ValidateCount	INT = 0,
			@BatchCount		INT = 10,
			@Iteration		INT  = 5

DROP TABLE IF EXISTS #TempAccountsJobTable
CREATE TABLE #TempAccountsJobTable
(
	Skey  DECIMAL(19,0),
	acctId INT,
	CreditLimit MONEY,
	JobStatus INT
)

SELECT @RecordCount = COUNT(1) FROM TEMP_CreditLimit WITH (NOLOCK) WHERE JobStatus = 0
PRINT 'TOTAL RECORDS TO UPDATE ===> ' + CAST(@RecordCount AS VARCHAR)
PRINT 'BATCH SIZE ===> ' + CAST(@BatchCount AS VARCHAR) + ' AND ITERATION ===> ' + CAST(@Iteration AS VARCHAR)
PRINT 'NUMBER OF TIME THIS SCRIPT NEEDS TO RUN WITH THIS SETTING ===> ' + CAST(CEILING(@RecordCount/(@BatchCount*@Iteration*1.0)) AS VARCHAR)

IF(@RecordCount > 0)
BEGIN
	WHILE(@RecordCount >= @ValidateCount AND @Iteration > 0 )
	Begin 
		BEGIN TRY
			SET @ValidateCount = @ValidateCount + @BatchCount

			INSERT INTO #TempAccountsJobTable (Skey, acctId, CreditLimit, JobStatus)
			SELECT TOP(@BatchCount)
				Skey, acctId, CreditLimit, JobStatus
			FROM TEMP_CreditLimit WITH (NOLOCK)
			WHERE JobStatus = 0

			BEGIN TRY
				BEGIN TRANSACTION
					UPDATE BP
						SET 
							CreditLimit = TT.CreditLimit,
							tpyBlob = NULL,
							tpyNAD = NULL,
							tpyLAD = NULL
						FROM BSegment_Primary BP
						JOIN #TempAccountsJobTable TT ON (BP.acctId = TT.acctId)
						WHERE TT.JobStatus = 0

					UPDATE BCC
						SET
							AutoInitialChargeOffStartDate  = NULL,
							SystemChargeOffStatus = '0',
							ChargeOffDateParam = NULL,
							ChargeOffDate = NULL,
							AutoInitialChargeOffReason = NULL
						FROM BSegmentCreditCard BCC
						JOIN #TempAccountsJobTable TT ON (BCC.acctId = TT.acctId)
						WHERE TT.JobStatus = 0

					UPDATE TS
						SET JobStatus = 1
					FROM TEMP_CreditLimit TS
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
		Select 'Iteration Complete, Please run this step again until it is finished'
	End
END
Else
Begin 
	Select 'Updated Sucessfully'
End
