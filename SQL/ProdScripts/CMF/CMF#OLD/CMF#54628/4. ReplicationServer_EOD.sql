-- TO BE RUN ON REPLICATION SERVER ONLY



USE CCGS_RPT_CoreIssue
GO


BEGIN TRANSACTION
--COMMIT TRANSACTION
-- ROLLBACK TRANSACTION

UPDATE TOP(1) AccountInfoForReport SET SystemStatus = 2, CycleDueDTD = 0, AmtofPayCurrDue = AmtofPayCurrDue - 24.92,
AmountOfTotalDue = AmountOfTotalDue - 39.93, RunningMinimumDue = RunningMinimumDue - 39.93, RemainingMinimumDue = RemainingMinimumDue - 39.93,
AmtOfPayXDLate = AmtOfPayXDLate - 15.01, DaysDelinquent = 0, TotalDaysDelinquent = 0, DateOfDelinquency = NULL, DateOfOriginalPaymentDueDTD = NULL WHERE 
BSacctId = 3751544 AND businessday = '2021-07-24 23:59:57'


UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue - 39.93, AmtofPayCurrDue = AmtofPayCurrDue - 24.92, AmtOfPayXDLate = AmtOfPayXDLate - 15.01,
CycleDueDTD = 0 WHERE CPSacctId = 4663694 AND businessday = '2021-07-24 23:59:57'