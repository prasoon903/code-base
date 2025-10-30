CREATE OR ALTER FUNCTION GetCurrentTime(@SysOrgID INT=NULL)
RETURNS DATETIME
AS
BEGIN
	DECLARE 
		@CurrentTime DATETIME,
		@InstitutionID INT

	IF @SysOrgID IS NULL
	BEGIN
		SET @SysOrgID = 51
	END

	SELECT TOP 1 @InstitutionID =  InstitutionID FROM Institutions WITH (NOLOCK) WHERE SysOrgID = @SysOrgID  
  
	IF @InstitutionID <> 0 AND @InstitutionID IS NOT NULL
	BEGIN
		SELECT @CurrentTime = CAST(CONVERT(VARCHAR, ProcDayEnd, 23) + ' ' + CONVERT(VARCHAR, GETDATE(), 14) AS DATETIME)  
		FROM ARSystemAccounts AR WITH (NOLOCK)   
		JOIN Org_Balances OB WITH (NOLOCK) ON (AR.acctId = OB.ARSystemAcctId)  
		WHERE OB.acctId = @InstitutionID
	END
	ELSE
	BEGIN
		--PRINT 'Not valid @SysOrgID'
		SET @CurrentTime = GETDATE()
	END

	RETURN @CurrentTime
END

--SELECT dbo.GetCurrentTime(51)