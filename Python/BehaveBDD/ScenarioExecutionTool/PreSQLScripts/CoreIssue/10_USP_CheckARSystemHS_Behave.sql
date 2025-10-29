CREATE OR ALTER PROCEDURE USP_CheckARSystemHS_Behave
AS
BEGIN 
	
	DECLARE @InstitutionsCount INT,
			@ProcDayEnd DATETIME,
			@InstitutionID INT
			

	SELECT @InstitutionsCount = COUNT(1) FROM Institutions WITH(NOLOCK)

	IF EXISTS ( SELECT TOP 1 1 FROM ARSystemHSAccounts WITH(NOLOCK) WHERE ProcDayEnd IS NULL)
		PRINT 'Do Nothing'
	ELSE
	BEGIN
		IF EXISTS ( SELECT TOP 1 1 FROM ARSystemHSAccounts WITH(NOLOCK) WHERE InstitutionID IS NULL)	
			PRINT 'Do Nothing'
		ELSE
		BEGIN
			SELECT TOP 1 @ProcDayEnd = HS.ProcDayEnd, @InstitutionID = HS.InstitutionID
			FROM ARSystemHSAccounts HS WITH(NOLOCK)
			JOIN ARSystemAccounts A WITH(NOLOCK) ON HS.InstitutionID = A.APInstitutionID
			WHERE HS.ProcDayEnd  < A.ProcDayEnd
			
			IF EXISTS (SELECT TOP 1 1 FROM EOD_AsystemHS WITH(NOLOCK) WHERE OldProcDayEnd = @ProcDayEnd AND Status IN ('NEW'))
				EXEC USP_EOD_AsystemHS_JOB
			ELSE IF EXISTS (SELECT TOP 1 1 FROM ARSystemAccounts WITH(NOLOCK) WHERE NADMode = 1)
      BEGIN
        PRINT 'Wait'
      END
      ELSE
				UPDATE ARSystemHSAccounts SET InstitutionID = NULL
		END

	END

END