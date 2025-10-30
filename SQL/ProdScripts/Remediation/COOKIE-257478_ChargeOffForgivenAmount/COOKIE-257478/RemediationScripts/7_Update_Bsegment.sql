/*
Updating the CPS data
*/

SET XACT_ABORT ON
SET NOCOUNT ON

DECLARE		@RecordCount		INT			= 0,
			@ProcessingTime		DATETIME	= GETDATE(),
			@ValidateCount		INT			= 0,
			@BatchCount			INT			= 1000,
			@Iteration			INT			= 4

DROP TABLE IF EXISTS #TEMP_BSegment_JobTable
CREATE TABLE #TEMP_BSegment_JobTable 
(
	Skey DECIMAL(19, 0),
	acctId INT,
	AccountNumber VARCHAR(19),
	AccountUUID VARCHAR(64),
	ForgivenAmount MONEY,
	TotalAmountCO_Before MONEY,
	TotalAmountCO_After MONEY,
	RCLSDateOnAccount DATETIME,
	RCLSDateToSet DATETIME,
	JobStatus INT
)

SELECT @RecordCount = COUNT(1) FROM COOKIE_257478_ChargeOffAccount WITH (NOLOCK) WHERE JobStatus = 1
PRINT 'TOTAL RECORDS TO UPDATE ===> ' + CAST(@RecordCount AS VARCHAR)
PRINT 'BATCH SIZE ===> ' + CAST(@BatchCount AS VARCHAR) + ' AND ITERATION ===> ' + CAST(@Iteration AS VARCHAR)
PRINT 'NUMBER OF TIME THIS SCRIPT NEEDS TO RUN WITH THIS SETTING ===> ' + CAST(CEILING(@RecordCount/(@BatchCount*@Iteration*1.0)) AS VARCHAR)

IF(@RecordCount > 0)
BEGIN
	WHILE(@RecordCount >= @ValidateCount and @Iteration > 0 )
	Begin 
		BEGIN TRY
			SET @ValidateCount = @ValidateCount + @BatchCount

			INSERT INTO #TEMP_BSegment_JobTable (Skey, acctId, TotalAmountCO_After, RCLSDateToSet, JobStatus)
			SELECT TOP(@BatchCount)
				Skey, acctId, TotalAmountCO_After, RCLSDateToSet, JobStatus
			FROM COOKIE_257478_ChargeOffAccount WITH (NOLOCK)
			WHERE JobStatus = 1

			BEGIN TRY
				BEGIN TRANSACTION

					UPDATE BCC
					SET 
						TotalAmountCO = T.TotalAmountCO_After,
						TotalPrincipalCO = T.TotalAmountCO_After - (BCC.TotalInterestCO+BCC.TotalLateFeesCO+BCC.recoveryfeesbnpco),
						ChargeOffReclassDate = CASE WHEN ChargeOffReclassDate IS NULL THEN T.RCLSDateToSet ELSE ChargeOffReclassDate END
					FROM BSegmentCreditCard BCC
					JOIN #TEMP_BSegment_JobTable T ON (BCC.acctID = T.acctID)
					WHERE T.JobStatus = 1

					UPDATE TS
						SET JobStatus = 2
					FROM COOKIE_257478_ChargeOffAccount TS
					JOIN #TEMP_BSegment_JobTable TT ON (TS.Skey = TT.Skey)

				COMMIT TRANSACTION
			END TRY

			BEGIN CATCH
				IF @@TRANCOUNT > 0
					ROLLBACK TRANSACTION 
					SELECT ERROR_MESSAGE(),ERROR_LINE(),ERROR_NUMBER()
					RAISERROR('ERROR OCCURED :-', 16, 1);
			END CATCH

			TRUNCATE TABLE #TEMP_BSegment_JobTable
			SET @Iteration = @Iteration - 1 
			--WAITFOR DELAY '00:00:02'
		END TRY

		BEGIN CATCH
			PRINT 'ERROR IN FILLING JOBTABLE'
			set @Iteration = @Iteration - 1 
		END CATCH
	END
	Begin 
		SELECT @RecordCount = COUNT(1) FROM COOKIE_257478_ChargeOffAccount WITH (NOLOCK) WHERE JobStatus = 1
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
