CREATE OR ALTER PROCEDURE USP_GetPSDData_Terms(@PlanID_Input INT)
AS
BEGIN

	DECLARE 
		@AccountID			int,
		@PlanID				int,
		@CurrentTime		datetime,
		@LastStatementDate	datetime,
		@ScheduleID			decimal,
		@ScheduleIndicator	int

	SELECT TOP 1
		@AccountID = BP.acctId, @PlanID = ILPS.PlanID, @CurrentTime = dbo.PR_ISOGetBusinessTime(), 
		@LastStatementDate = BP.LastStatementDate, @ScheduleID = ILPS.ScheduleID, @ScheduleIndicator = ILPS.ScheduleIndicator
	FROM ILPScheduleDetailSummary ILPS WITH (NOLOCK)
	JOIN BSegment_Primary BP WITH (NOLOCK) ON (ILPS.parent02AID = BP.acctId)
	JOIN BSegment_Secondary BS WITH (NOLOCK) ON (BS.acctId = BP.acctId)
	JOIN BSegmentCreditCard BCC WITH (NOLOCK) ON (BCC.acctId = BP.acctId)
	WHERE ILPS.PlanID = @PlanID_Input
	ORDER BY ILPS.ActivityOrder DESC
	EXEC dbo.USP_GetPaymentTerms @AccountID, @PlanID, @CurrentTime, @LastStatementDate, @ScheduleID, @ScheduleIndicator

END
GO

CREATE OR ALTER PROCEDURE USP_GetPSDData_Plans(@AccountID_Input INT, @PlanID_Input INT = 0)
AS
BEGIN

	DECLARE 
		@DateOfTotalDue		datetime

	SELECT TOP 1
		@DateOfTotalDue = BCC.DateOfTotalDue
	FROM ILPScheduleDetailSummary ILPS WITH (NOLOCK)
	JOIN BSegment_Primary BP WITH (NOLOCK) ON (ILPS.parent02AID = BP.acctId)
	JOIN BSegment_Secondary BS WITH (NOLOCK) ON (BS.acctId = BP.acctId)
	JOIN BSegmentCreditCard BCC WITH (NOLOCK) ON (BCC.acctId = BP.acctId)
	WHERE ILPS.PlanID = @PlanID_Input
	ORDER BY ILPS.ActivityOrder DESC

	EXEC dbo.USP_GetPlanDetails @AccountID_Input, @PlanID_Input, @DateOfTotalDue, NULL, NULL

END