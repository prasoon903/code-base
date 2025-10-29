CREATE OR ALTER PROCEDURE USP_PDF_GetMaxExecutionID
AS
DECLARE @MaxExecutionID INT = 0
BEGIN TRY
	BEGIN TRAN
		SELECT @MaxExecutionID = Value  FROM MaxExecutionValue WITH(UPDLOCK) WHERE Name = 'ExecutionID'
		UPDATE MaxExecutionValue SET Value = @MaxExecutionID + StepSize WHERE Name = 'ExecutionID'
	COMMIT TRAN
END TRY
BEGIN CATCH
	ROLLBACK TRAN
END CATCH
SELECT @MaxExecutionID AS MaxExecutionID