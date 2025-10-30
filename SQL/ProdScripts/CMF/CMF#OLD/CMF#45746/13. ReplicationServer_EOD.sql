-- TO BE RUN ON REPLICATION SERVER ONLY

USE CCGS_RPT_CoreIssue
GO

BEGIN TRANSACTION
--COMMIT TRANSACTION
--ROLLBACK TRANSACTION

-- 1 row UPDATE TOP(1) each statement unless specified


UPDATE TOP(1) AccountInfoForReport SET AmtOfPayCurrDue = AmtOfPayCurrDue - 7.5, AmountOfTotalDue = AmountOfTotalDue - 7.5, RunningMinimumDue = RunningMinimumDue - 7.5,
RemainingMinimumDue = RemainingMinimumDue - 7.5 WHERE BSacctId = 7912164 AND BusinessDay = '2020-12-02 23:59:57.000'

