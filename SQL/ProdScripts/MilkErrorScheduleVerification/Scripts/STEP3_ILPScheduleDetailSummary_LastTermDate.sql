/*
Marking the plans correct, batch wise.
*/

SET XACT_ABORT ON
SET NOCOUNT ON

DECLARE		@RecordCount			INT = 0,
			@ProcessingTime			DATETIME = GETDATE(),
			@ValidateCount			INT = 0,
			@BatchCount				INT = 1000,
			@Iteration				INT  = 4

DROP TABLE IF EXISTS #TempAccountsJobTable_ILP

CREATE TABLE #TempAccountsJobTable_ILP
(
	Skey DECIMAL(19,0),
	SkeyOnILP DECIMAL(19,0),
	parent02AID INT,
	PlanID INT,
	LastTermDateOld DATETIME,
	LastTermDate DATETIME,
	JobStatus INT
)

SELECT @RecordCount = COUNT(1) FROM ##TEMP_ILPScheduleDetailSummary_LastTermDate WITH (NOLOCK) WHERE JobStatus = 0
PRINT 'TOTAL RECORDS TO UPDATE ===> ' + CAST(@RecordCount AS VARCHAR)
PRINT 'BATCH SIZE ===> ' + CAST(@BatchCount AS VARCHAR) + ' AND ITERATION ===> ' + CAST(@Iteration AS VARCHAR)
PRINT 'NUMBER OF TIME THIS SCRIPT NEEDS TO RUN WITH THIS SETTING ===> ' + CAST(CEILING(@RecordCount/(@BatchCount*@Iteration*1.0)) AS VARCHAR)

IF(@RecordCount > 0)
BEGIN
	WHILE(@RecordCount >= @ValidateCount and @Iteration > 0 )
	Begin 
		BEGIN TRY
			SET @ValidateCount = @ValidateCount + @BatchCount

			INSERT INTO #TempAccountsJobTable_ILP (Skey, SkeyOnILP, parent02AID, PlanID, LastTermDateOld, LastTermDate, JobStatus)
			SELECT TOP(@BatchCount)
				Skey, SkeyOnILP, parent02AID, PlanID, LastTermDateOld, LastTermDate, JobStatus
			FROM ##TEMP_ILPScheduleDetailSummary_LastTermDate WITH (NOLOCK)
			WHERE JobStatus = 0

			BEGIN TRY
				BEGIN TRANSACTION

					UPDATE ILP
					SET
						ILP.LastTermDate = TT.LastTermDate
					FROM ##ILPScheduleDetailSummary ILP
					JOIN #TempAccountsJobTable_ILP TT ON (ILP.Skey = TT.SkeyOnILP)

					UPDATE TS
						SET JobStatus = 1
					FROM ##TEMP_ILPScheduleDetailSummary_LastTermDate TS
					JOIN #TempAccountsJobTable_ILP TT ON (TS.Skey = TT.Skey)

				COMMIT TRANSACTION
			END TRY

			BEGIN CATCH
				IF @@TRANCOUNT > 0
					ROLLBACK TRANSACTION 
					SELECT ERROR_MESSAGE(),ERROR_LINE(),ERROR_NUMBER()
					RAISERROR('ERROR OCCURED :-', 16, 1);
			END CATCH

			TRUNCATE TABLE #TempAccountsJobTable_ILP
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
