DROP PROCEDURE IF EXISTS USP_GetStatusOfExternalFileProcessing
GO
CREATE PROCEDURE USP_GetStatusOfExternalFileProcessing (@FileName VARCHAR(200), @FileSource VARCHAR(30))  
AS  
BEGIN  
	SET NOCOUNT ON  
	SET QUOTED_IDENTIFIER ON  
	SET ANSI_NULLS ON  
	SET XACT_ABORT ON  
  
	-- AUTHOR: PRASOON PARASHAR  
	-- DESCRIPTION: Apply Debit and Credit on account  
  
	DECLARE	@JobStatus  VARCHAR(20), @ErrorFlag   INT = 0, @JobID INT = 0
  
	IF EXISTS (SELECT TOP 1 1 FROM ExternalFileProcessing WITH (NOLOCK) WHERE JobStatus IN ('NEW', 'INPROCESS'))
	BEGIN
		SET @JobStatus = 'WAIT'
	END
	
	IF(@JobStatus IS NULL OR @JobStatus = '')
	BEGIN
		SELECT 
			@JobStatus	= JobStatus
		FROM ExternalFileProcessing WITH (NOLOCK)  
		WHERE FileName = @FileName
	END
  
	IF(@JobStatus IS NULL OR @JobStatus = '' OR @JobStatus = 'ERROR')  
	BEGIN  
		BEGIN TRY  
			BEGIN TRANSACTION  
			
			INSERT INTO ExternalFileProcessing  
			(  
				JobStatus,
				FileName,
				FileSource,
				Date_Received
			)  
			VALUES  
			(   
				'NEW',
				@FileName, 
				@FileSource,
				GETDATE()
			)  
  
			SET @JobStatus = 'NEW'  
  
			COMMIT TRANSACTION  
		END TRY  
		BEGIN CATCH  
			ROLLBACK TRANSACTION  
			SET @ErrorFlag = 1  
		END CATCH    
	END 
	
	IF(@JobStatus = 'NEW')
	BEGIN
		SELECT @JobID = JobID FROM ExternalFileProcessing WITH (NOLOCK) WHERE FileName = @FileName ORDER BY JobID DESC
	END
  
	SELECT @ErrorFlag AS ErrorFlag, @JobStatus AS JobStatus, @JobID AS JobID  
END