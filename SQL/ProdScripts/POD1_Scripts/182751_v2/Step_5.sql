/*
Marking the plans correct, batch wise.
*/

SET XACT_ABORT ON
SET NOCOUNT ON

DECLARE		@RecordCount			INT = 0,
			@ProcessingTime			DATETIME = GETDATE(),
			@ValidateCount			INT = 0,
			@BatchCount				INT = 1000,
			@Iteration				INT  = 5

DROP TABLE IF EXISTS #TempAccountsJobTable_PlanCorrection

CREATE TABLE #TempAccountsJobTable_PlanCorrection
(
	Skey DECIMAL(19,0),
	PlanUUID VARCHAR(64),
	JobStatus INT
)

SELECT @RecordCount = COUNT(1) FROM TEMP_PlanToMove WITH (NOLOCK) WHERE JobStatus = 0
PRINT 'TOTAL RECORDS TO UPDATE ===> ' + CAST(@RecordCount AS VARCHAR)
PRINT 'BATCH SIZE ===> ' + CAST(@BatchCount AS VARCHAR) + ' AND ITERATION ===> ' + CAST(@Iteration AS VARCHAR)
PRINT 'NUMBER OF TIME THIS SCRIPT NEEDS TO RUN WITH THIS SETTING ===> ' + CAST(CEILING(@RecordCount/(@BatchCount*@Iteration*1.0)) AS VARCHAR)

IF(@RecordCount > 0)
BEGIN
	WHILE(@RecordCount >= @ValidateCount and @Iteration > 0 )
	Begin 
		BEGIN TRY
			SET @ValidateCount = @ValidateCount + @BatchCount

			INSERT INTO #TempAccountsJobTable_PlanCorrection (Skey, PlanUUID, JobStatus)
			SELECT TOP(@BatchCount)
				Skey, PlanUUID, JobStatus
			FROM TEMP_PlanToMove WITH (NOLOCK)
			WHERE JobStatus = 0

			BEGIN TRY
				BEGIN TRANSACTION
					INSERT INTO RetailSchedulesCorrected
						SELECT
							UniversalUniqueID,
							ILPB.PlanUUID,
							ScheduleID,
							ReportDate,
							BusinessDate,
							BatchTimestamp,
							InstitutionID,
							ProductID,
							ErrorReason,
							FileName,
							FileID,
							parent02AID,
							AccountNumber,
							acctId,
							ILPB.JobStatus,
							ProcessingDate,
							@ProcessingTime,
							Counter,  
							ErrorMessage,  
							FieldPath 
						FROM ILPScheduleDetailsBAD ILPB WITH (NOLOCK)
						JOIN #TempAccountsJobTable_PlanCorrection TT ON (ILPB.PlanUUID = TT.PlanUUID)

					UPDATE ILP
					SET
						ILP.ScheduleType = 2,
						ILP.CorrectionDate = @ProcessingTime
					FROM ILPScheduleDetailSummary ILP
					JOIN #TempAccountsJobTable_PlanCorrection TT ON (ILP.PlanUUID = TT.PlanUUID)
					WHERE ILP.ScheduleType <> -99

					DELETE ILPB 
					FROM ILPScheduleDetailsBAD ILPB
					JOIN #TempAccountsJobTable_PlanCorrection TT ON (ILPB.PlanUUID = TT.PlanUUID)

					UPDATE TS
						SET JobStatus = 1
					FROM TEMP_PlanToMove TS
					JOIN #TempAccountsJobTable_PlanCorrection TT ON (TS.Skey = TT.Skey)
				COMMIT TRANSACTION
			END TRY

			BEGIN CATCH
				IF @@TRANCOUNT > 0
					ROLLBACK TRANSACTION 
					SELECT ERROR_MESSAGE(),ERROR_LINE(),ERROR_NUMBER()
					RAISERROR('ERROR OCCURED :-', 16, 1);
			END CATCH

			TRUNCATE TABLE #TempAccountsJobTable_PlanCorrection
			SET @Iteration = @Iteration - 1 
		END TRY

		BEGIN CATCH
			PRINT 'Error in filling JobTable'
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
