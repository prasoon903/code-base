BEGIN TRAN
--COMMIT TRAN
--ROLLBACK TRAN

UPDATE TOP(1) AccountInfoForReport  SET CycleDueDTD = 1, SystemStatus = 2, DaysDelinquent = 0, TotalDaysDelinquent = 0, DAteOfDelinquency = NULL  WHERE BSAcctID = 17277194 and BusinessDay = '2022-04-01 23:59:57.000'

--UPDATE BSegment_Primary SET DateOfLastDelinquent = NULL, SystemStatus = 2 WHERE acctID = 17277194
--UPDATE BSegment_Primary SET DateOfLastDelinquent = NULL, SystemStatus = 2 WHERE acctID = 2296309



UPDATE TOP(1) AccountInfoForReport  SET CycleDueDTD = 1, SystemStatus = 2, SRBWithInstallmentDue = SRBWithInstallmentDue -20.75, 
 SBWithInstallmentDue = SBWithInstallmentDue -20.75, DaysDelinquent = 0, TotalDaysDelinquent = 0,
AmountOfTotalDue = AmountOfTotalDue - 20.75, AmountOfPayment30DLate = AmountOfPayment30DLate - 20.75,
DateOfOriginalPaymentDUeDTD = '2022-04-30 23:59:57.000', DAteOfDelinquency = NULL  WHERE bsAcctID = 2296309  and BusinessDay = '2022-04-01 23:59:57.000'

UPDATE TOP(1) PlanInfoForReport SET CycleDueDTD = 0, SRBWithInstallmentDue = SRBWithInstallmentDue -20.75, 
SBWithInstallmentDue = SBWithInstallmentDue - 20.75, AmountOfTotalDue = AmountOfTotalDue - 20.75, AmountOfPayment30DLate = AmountOfPayment30DLate - 20.75 WHERE cpsAcctid = 44220466   and BusinessDay = '2022-04-01 23:59:57.000'