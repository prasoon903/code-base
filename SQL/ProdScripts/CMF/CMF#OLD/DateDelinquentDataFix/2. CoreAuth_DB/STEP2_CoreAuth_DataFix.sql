USE CCGS_CoreAuth
GO

IF EXISTS (SELECT 1 FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'dbo.Temp_bsegment_DateDelinq') AND TYPE = 'U') 
BEGIN

	INSERT INTO Temp_bsegment_DateDelinq (acctId, AccountNumber, UniversalUniqueID, CycleDueDTD, DtOfLastDelinqCTD, DateOfOriginalPaymentDueDTD, JobStatus, ProcessTime)
	SELECT acctId, AccountNumber, UniversalUniqueID, CycleDueDTD, DtOfLastDelinqCTD, DateOfOriginalPaymentDueDTD, JobStatus, ProcessTime
	FROM CCGS_CoreIssue..Temp_bsegment_DateDelinq WITH (NOLOCK)
	WHERE JobStatus = 1

END
ELSE
BEGIN 
	PRINT 'Temp_bsegment_DateDelinq table does not exist, please execute the Supporting table script.'
END