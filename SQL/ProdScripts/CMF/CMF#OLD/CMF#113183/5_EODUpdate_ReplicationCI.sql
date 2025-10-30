--TO BE EXECUTED ON REPLICATION SERVER CI DATABASE

SET XACT_ABORT ON
SET NOCOUNT ON

DECLARE		@RecordCount		INT			= 0,
			@ProcessingTime		DATETIME	= GETDATE(),
			@ValidateCount		INT			= 0,
			@BatchCount			INT			= 100,
			@Iteration			INT			= 20

DROP TABLE IF EXISTS #TempAI_Records_JobTable
CREATE TABLE #TempAI_Records_JobTable 
(
	SN DECIMAL(19,0),
	BSAcctid int,
	AI_Businessday Datetime,
	AI_ChargeOffDate Datetime,
	CBA_ChargeOffDate Datetime,
	JobStatus INT DEFAULT(0)
)


SELECT @RecordCount = COUNT(1) FROM TempAI_Records WITH (NOLOCK) WHERE JobStatus = 0
PRINT 'TOTAL RECORDS TO UPDATE ===> ' + CAST(@RecordCount AS VARCHAR)
PRINT 'BATCH SIZE ===> ' + CAST(@BatchCount AS VARCHAR) + ' AND ITERATION ===> ' + CAST(@Iteration AS VARCHAR)
PRINT 'NUMBER OF TIME THIS SCRIPT NEEDS TO RUN WITH THIS SETTING ===> ' + CAST(CEILING(@RecordCount/(@BatchCount*@Iteration*1.0)) AS VARCHAR)

IF(@RecordCount > 0)
BEGIN
	WHILE(@RecordCount >= @ValidateCount and @Iteration > 0 )
	Begin 
		BEGIN TRY
			SET @ValidateCount = @ValidateCount + @BatchCount
			
			INSERT INTO #TempAI_Records_JobTable (SN, BSAcctid, AI_Businessday, AI_ChargeOffDate, CBA_ChargeOffDate, JobStatus)
			SELECT TOP(@BatchCount)
				SN, BSAcctid, AI_Businessday, AI_ChargeOffDate, CBA_ChargeOffDate, JobStatus
			FROM TempAI_Records WITH (NOLOCK)
			WHERE JobStatus = 0


			BEGIN TRY
				
					UPDATE B
					SET
						ChargeOffDate = CBA_ChargeoffDate
					FROM AccountInfoForreport B
					JOIN #TempAI_Records_JobTable T ON (B.BSacctID = T.BSAcctID AND T.AI_Businessday = B.BusinessDay)

					UPDATE A
						SET JobStatus = 1
					FROM TempAI_Records A
					JOIN #TempAI_Records_JobTable TT ON (A.SN = TT.SN)
					AND A.JobStatus = 0
				
			END TRY

			BEGIN CATCH
				IF @@TRANCOUNT > 0
					SELECT ERROR_MESSAGE(),ERROR_LINE(),ERROR_NUMBER()
					RAISERROR('ERROR OCCURED :-', 16, 1);
			END CATCH

			TRUNCATE TABLE #TempAI_Records_JobTable
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
		SELECT @RecordCount = COUNT(1) FROM TempAI_Records WITH (NOLOCK) WHERE JobStatus = 0
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
ELSE
BEGIN 
	SELECT 'NO RECORD TO UPDATE' [Result]
END
