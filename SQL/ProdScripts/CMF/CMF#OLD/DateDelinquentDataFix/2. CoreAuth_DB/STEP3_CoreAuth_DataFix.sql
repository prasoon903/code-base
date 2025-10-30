USE CCGS_CoreAuth
GO

SET XACT_ABORT ON
SET NOCOUNT ON

DECLARE		@RecordCount	INT = 0,
			@ValidateCount	INT = 0,
			@BatchCount		INT = 50,
			@Iteration		INT  = 2

DROP TABLE IF EXISTS #TempAccountsJobTable
CREATE TABLE #TempAccountsJobTable
(
	Skey DECIMAL(19,0),
	acctId INT,
	AccountNumber VARCHAR(19),
	UniversalUniqueID VARCHAR(64),
	CycleDueDTD INT,
	DtOfLastDelinqCTD DATETIME, 
	DateOfOriginalPaymentDueDTD DATETIME,
	JobStatus INT 
)

SELECT @RecordCount = COUNT(1) FROM Temp_bsegment_DateDelinq WITH (NOLOCK) WHERE JobStatus = 1
PRINT 'TOTAL RECORDS TO UPDATE ===> ' + CAST(@RecordCount AS VARCHAR)
PRINT 'BATCH SIZE ===> ' + CAST(@BatchCount AS VARCHAR) + ' AND ITERATION ===> ' + CAST(@Iteration AS VARCHAR)
PRINT 'NUMBER OF TIME THIS SCRIPT NEEDS TO RUN WITH THIS SETTING ===> ' + CAST(CEILING(@RecordCount/(@BatchCount*@Iteration*1.0)) AS VARCHAR)

IF(@RecordCount > 0)
BEGIN
	WHILE(@RecordCount >= @ValidateCount and @Iteration > 0 )
	Begin 
		BEGIN TRY
			SET @ValidateCount = @ValidateCount + @BatchCount

			INSERT INTO #TempAccountsJobTable (Skey, acctId, AccountNumber, UniversalUniqueID, CycleDueDTD, DtOfLastDelinqCTD, DateOfOriginalPaymentDueDTD, JobStatus)
			SELECT TOP(@BatchCount)
				Skey, acctId, AccountNumber, UniversalUniqueID, CycleDueDTD, DtOfLastDelinqCTD, DateOfOriginalPaymentDueDTD, JobStatus
			FROM Temp_bsegment_DateDelinq WITH (NOLOCK)
			WHERE JobStatus = 1

			BEGIN TRY
				BEGIN TRANSACTION
					UPDATE BP
						SET 
							DateOfLastDelinquent = TT.DtOfLastDelinqCTD
						FROM BSegment_Primary BP
						JOIN #TempAccountsJobTable TT ON (BP.acctId = TT.acctId)
						WHERE TT.JobStatus = 1

					UPDATE TS
						SET JobStatus = 2
					FROM Temp_bsegment_DateDelinq TS
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
