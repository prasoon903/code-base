DROP PROCEDURE IF EXISTS USP_STOPFixILPSchedules
GO
CREATE PROCEDURE USP_STOPFixILPSchedules (@BatchCount INT, @Ranking INT)
AS
BEGIN


	SET XACT_ABORT ON
	SET NOCOUNT ON

	DECLARE		@RecordCount	INT = 0,
				@ValidateCount	INT = 0,
				@Iteration		INT  = 1,
				@Message		VARCHAR(MAX),
				@ErrorFlag		INT = 0

	DROP TABLE IF EXISTS #TempAccountsJobTable
	CREATE TABLE #TempAccountsJobTable
	(
		Skey DECIMAL(19,0),
		parent02AID INT,
		PlanID INT,
		PlanUUID VARCHAR(64),
		ActivityOrder INT,
		ScheduleID DECIMAL(19, 0),
		EqualPaymentAmountCalc MONEY, 
		LastMonthPayment MONEY,
		Ranking INT,
		SkeyOnILP DECIMAL(19, 0),
		JobStatus INT
	)

	SELECT @RecordCount = COUNT(1) FROM TEMP_ILPDetails WITH (NOLOCK) WHERE JobStatus = 0 AND Ranking = @Ranking

	IF((SELECT COUNT(1) FROM TEMP_ILPDetails WITH (NOLOCK) WHERE JobStatus = 0 AND Ranking = @Ranking-1) > 0 AND @Ranking <> 1)
	BEGIN
		SET @RecordCount = 0
		SET @Message = 'ALL LOWER RANK RECORDS ARE NOT PROCESSED YET, PROCESS THEM FIRST TO CONTINUE WITH OTHERS'
		SET @ErrorFlag = 1
	END
	--PRINT 'TOTAL RECORDS TO UPDATE ===> ' + CAST(@RecordCount AS VARCHAR)
	--PRINT 'BATCH SIZE ===> ' + CAST(@BatchCount AS VARCHAR) + ' AND ITERATION ===> ' + CAST(@Iteration AS VARCHAR)
	--PRINT 'NUMBER OF TIME THIS SCRIPT NEEDS TO RUN WITH THIS SETTING ===> ' + CAST(CEILING(@RecordCount/(@BatchCount*@Iteration*1.0)) AS VARCHAR)

	IF(@RecordCount > 0)
	BEGIN
		WHILE(@RecordCount >= @ValidateCount and @Iteration > 0 )
		Begin 
			BEGIN TRY
				SET @ValidateCount = @ValidateCount + @BatchCount

				INSERT INTO #TempAccountsJobTable (Skey, parent02AID, PlanID, PlanUUID, ActivityOrder, ScheduleID, EqualPaymentAmountCalc, LastMonthPayment, Ranking, SkeyOnILP, JobStatus)
				SELECT TOP(@BatchCount)
					Skey, parent02AID, PlanID, PlanUUID, ActivityOrder, ScheduleID, EqualPaymentAmountCalc, LastMonthPayment, Ranking, SkeyOnILP, JobStatus
				FROM TEMP_ILPDetails WITH (NOLOCK)
				WHERE JobStatus = 0 AND Ranking = @Ranking

				BEGIN TRY
					BEGIN TRANSACTION
						IF(@Ranking = 1)
						BEGIN
							UPDATE ILP
								SET 
									PlanID = 0 - TT.PlanID,
									LastMonthPayment = TT.EqualPaymentAmountCalc
								FROM ILPScheduleDetailSummary ILP
								JOIN #TempAccountsJobTable TT ON (ILP.PlanUUID = TT.PlanUUID)
								WHERE TT.JobStatus = 0 AND ILP.ActivityOrder > TT.ActivityOrder

							UPDATE ILP
								SET 
									JobStatus = 1,
									LastMonthPayment = TT.EqualPaymentAmountCalc
								FROM ILPScheduleDetailSummary ILP
								JOIN #TempAccountsJobTable TT ON (ILP.PlanUUID = TT.PlanUUID)
								WHERE TT.JobStatus = 0 AND ILP.ActivityOrder = TT.ActivityOrder

							UPDATE TS
								SET JobStatus = 1
							FROM TEMP_ILPDetails TS
							JOIN #TempAccountsJobTable TT ON (TS.Skey = TT.Skey)
						END
						ELSE
						BEGIN
							UPDATE ILP
								SET 
									JobStatus = 0,
									PlanID = 0 - ILP.PlanID
								FROM ILPScheduleDetailSummary ILP
								JOIN #TempAccountsJobTable TT ON (ILP.Skey = TT.SkeyOnILP)
								WHERE TT.JobStatus = 0 AND ILP.ActivityOrder = TT.ActivityOrder

							UPDATE TS
								SET JobStatus = 1
							FROM TEMP_ILPDetails TS
							JOIN #TempAccountsJobTable TT ON (TS.Skey = TT.Skey)
						END
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
				PRINT 'ERROR IN FIILING JOBTABLE'
				set @Iteration = @Iteration - 1 
			END CATCH
		END
		Begin 
			SET @Message = 'THIS BATCH IS SUCCESSFULLY UPDATED. NEED TO RUN AGAIN'
		End
	END
	Else
	Begin 
		IF(@ErrorFlag <> 1)
		SET @Message = 'ALL RECORDS UPDATED SUCESSFULLY FOR THIS RANKING. PLEASE RUN THE ILP WORKFLOW'
	End

	SELECT @Message AS [Message]
END