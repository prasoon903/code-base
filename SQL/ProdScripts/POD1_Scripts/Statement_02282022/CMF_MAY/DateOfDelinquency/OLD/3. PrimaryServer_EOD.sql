-- TO BE RUN ON PRIMARY SERVER ONLY




USE CCGS_CoreIssue
GO


BEGIN TRANSACTION
--COMMIT TRANSACTION
-- ROLLBACK TRANSACTION

UPDATE TOP(1) AccountInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 4.8, AmtOfPayCurrDue = AmtOfPayCurrDue + 4.8,
RunningMinimumDue = RunningMinimumDue + 4.8, RemainingMinimumDue = RemainingMinimumDue + 4.8 WHERE BSacctId = 4919331 AND BusinessDay = '2021-05-31 23:59:57.000'


UPDATE TOP(1) AccountInfoForReport SET DateOfOriginalPaymentDueDTD = '2021-05-31 23:59:57', DaysDelinquent = 1, TotalDaysDelinquent = 1 WHERE BSacctId = 370915 AND BusinessDay = '2021-05-31 23:59:57.000'
UPDATE TOP(1) AccountInfoForReport SET DateOfOriginalPaymentDueDTD = '2021-05-31 23:59:57', DaysDelinquent = 1, TotalDaysDelinquent = 1 WHERE BSacctId = 2172341 AND BusinessDay = '2021-05-31 23:59:57.000'
UPDATE TOP(1) AccountInfoForReport SET DateOfOriginalPaymentDueDTD = '2021-05-31 23:59:57', DaysDelinquent = 1, TotalDaysDelinquent = 1 WHERE BSacctId = 2189937 AND BusinessDay = '2021-05-31 23:59:57.000'
UPDATE TOP(1) AccountInfoForReport SET DateOfOriginalPaymentDueDTD = '2021-05-31 23:59:57', DaysDelinquent = 1, TotalDaysDelinquent = 1 WHERE BSacctId = 2199023 AND BusinessDay = '2021-05-31 23:59:57.000'
UPDATE TOP(1) AccountInfoForReport SET DateOfOriginalPaymentDueDTD = '2021-05-31 23:59:57', DaysDelinquent = 1, TotalDaysDelinquent = 1 WHERE BSacctId = 2478772 AND BusinessDay = '2021-05-31 23:59:57.000'
UPDATE TOP(1) AccountInfoForReport SET DateOfOriginalPaymentDueDTD = '2021-05-31 23:59:57', DaysDelinquent = 1, TotalDaysDelinquent = 1 WHERE BSacctId = 2948431 AND BusinessDay = '2021-05-31 23:59:57.000'
UPDATE TOP(1) AccountInfoForReport SET DateOfOriginalPaymentDueDTD = '2021-05-31 23:59:57', DaysDelinquent = 1, TotalDaysDelinquent = 1 WHERE BSacctId = 12622798 AND BusinessDay = '2021-05-31 23:59:57.000'
