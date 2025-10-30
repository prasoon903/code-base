USE CCGS_CoreIssue
GO

IF EXISTS (SELECT 1 FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'dbo.Temp_bsegment_DateDelinq') AND TYPE = 'U') 
BEGIN

	DECLARE @OldProcessTime DATETIME = '2020-10-16 03:59:42.123'

	UPDATE Temp_bsegment_DateDelinq SET ProcessTime = @OldProcessTime WHERE ProcessTime IS NULL

	DECLARE @ProcessTime DATETIME = GETDATE()

	-- TEMP DATA Tables

	INSERT INTO Temp_bsegment_DateDelinq
	SELECT
		BP.acctId, BP.AccountNumber, BP.UniversalUniqueID, CycleDueDTD, NULL, DateOfOriginalPaymentDueDTD, 0, @ProcessTime
	FROM BsegmentCreditCard BCC WITH (NOLOCK)
	INNER JOIN BSegment_Primary BP WITH (NOLOCK) ON (BP.acctId = BCC.acctId)
	WHERE CycleDueDTD < 2 AND DtOfLastDelinqCTD IS NOT NULL
	AND BP.SystemStatus <> 14 And BillingCycle <>'LTD'

END
ELSE
BEGIN 
	PRINT 'Temp_bsegment_DateDelinq table does not exist, please execute the Supporting table script.'
END
