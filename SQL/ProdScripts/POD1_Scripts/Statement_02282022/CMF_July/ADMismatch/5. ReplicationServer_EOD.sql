-- TO BE RUN ON REPLICATION SERVER ONLY


USE CCGS_RPT_CoreIssue
GO


BEGIN TRANSACTION
--COMMIT TRANSACTION
-- ROLLBACK TRANSACTION

UPDATE TOP(1) AccountInfoForReport SET AmtOfPayCurrDue = AmtOfPayCurrDue - 29.17, AmountOfTotalDue = AmountOfTotalDue - 29.17,
RunningMinimumDue = RunningMinimumDue - 29.17, RemainingMinimumDue = RemainingMinimumDue - 29.17 WHERE BSacctId = 7603336 AND BusinessDay = '2021-07-31 23:59:57.000'



UPDATE TOP(1) AccountInfoForReport SET AmtOfPayCurrDue = AmtOfPayCurrDue + 29.17, AmountOfTotalDue = AmountOfTotalDue + 29.17,
RunningMinimumDue = RunningMinimumDue + 29.17, RemainingMinimumDue = RemainingMinimumDue + 29.17 WHERE BSacctId = 9812311 AND BusinessDay = '2021-07-31 23:59:57.000'