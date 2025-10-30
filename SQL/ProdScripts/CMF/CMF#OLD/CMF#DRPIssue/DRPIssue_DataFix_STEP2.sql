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
	ccinhparent125AID INT,
	SystemStatus INT,
	JobStatus INT
)

SELECT @RecordCount = COUNT(1) FROM Temp_bsegment_DRP WITH (NOLOCK) WHERE JobStatus = 0
PRINT 'Total records to update'
PRINT @RecordCount

IF(@RecordCount > 0)
BEGIN
	WHILE(@RecordCount >= @ValidateCount and @Iteration > 0 )
	Begin 
		BEGIN TRY
			SET @ValidateCount = @ValidateCount + @BatchCount

			INSERT INTO #TempAccountsJobTable (Skey, acctId, ccinhparent125AID, SystemStatus, JobStatus)
			SELECT TOP(@BatchCount)
				Skey, acctId, ccinhparent125AID, SystemStatus, JobStatus
			FROM Temp_bsegment_DRP WITH (NOLOCK)
			WHERE JobStatus = 0

			BEGIN TRY
				BEGIN TRANSACTION
					UPDATE CT 
						SET TranTime = DATEADD(SECOND, 10, GETDATE())
						FROM CommonTNP CT 
						JOIN #TempAccountsJobTable TT ON (CT.acctId = TT.acctId)
						WHERE CT.TranID = 0 AND ATID = 51 AND TT.JobStatus = 0

					UPDATE TS
						SET JobStatus = 1
					FROM Temp_bsegment_DRP TS
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
