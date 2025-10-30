-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO


SELECT AmountOfTotalDue, RunningMinimumDue, RemainingMinimumDue, DateOfOriginalPaymentDueDTD FROM BSegmentCreditCard WITH (NOLOCK) WHERE acctId = 2210876

	