-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION

	UPDATE AccountInfoForReport SET AmtOfPayCurrDue = AmtOfPayCurrDue - 25.08, CycleDueDTD = 0, AmountOfTotalDue = AmountOfTotalDue - 25.08, RunningMinimumDue = RunningMinimumDue - 25.08, RemainingMinimumDue = RemainingMinimumDue - 25.08 WHERE BSacctId = 9429605 AND BusinessDay = '2020-08-30 23:59:57'

	UPDATE AccountInfoForReport SET AmtOfPayCurrDue = AmtOfPayCurrDue - 56.18, CycleDueDTD = 0, AmountOfTotalDue = AmountOfTotalDue - 56.18, RunningMinimumDue = RunningMinimumDue - 56.18, RemainingMinimumDue = RemainingMinimumDue - 56.18 WHERE BSacctId = 2993761 AND BusinessDay = '2020-08-30 23:59:57'

COMMIT TRANSACTION
-- ROLLBACK TRANSACTION

/*
SELECT AmtOfPayCurrDue, CycleDueDTD, AmountOfTotalDue, RunningMinimumDue, RemainingMinimumDue FROM AccountInfoForReport WITH (NOLOCK) WHERE BSacctId = 9429605 AND BusinessDay = '2020-08-30 23:59:57'
*/