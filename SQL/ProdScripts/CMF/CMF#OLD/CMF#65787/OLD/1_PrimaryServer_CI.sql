BEGIN TRAN
--COMMIT TRAN
--ROLLBACK TRAN

UPDATE BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2 WHERE acctID = 17277194

UPDATE BSegmentCreditCard SET AmtOfPayXDLate = 0, DaysDelinquent = 0, DtOfLastDelinqCTD = NULL WHERE acctID = 17277194

DELETE FROM currentBalanceAudit WHERE AID = 17277194 AND ATID = 51 AND IdentityField = 3015328591
DELETE FROM currentBalanceAudit WHERE AID = 17277194 AND ATID = 51 AND IdentityField = 3015328592

UPDATE TOP(1) AccountInfoForReport  SET CycleDueDTD = 1, SystemStatus = 2, DaysDelinquent = 0, TotalDaysDelinquent = 0, DAteOfDelinquency = NULL  WHERE BSAcctID = 17277194 and BusinessDay = '2022-04-01 23:59:57.000'

--UPDATE BSegment_Primary SET DateOfLastDelinquent = NULL, SystemStatus = 2 WHERE acctID = 17277194
--UPDATE BSegment_Primary SET DateOfLastDelinquent = NULL, SystemStatus = 2 WHERE acctID = 2296309



UPDATE BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2 WHERE acctID = 2296309

UPDATE TOP(1) BSegmentCreditCard  SET SRBWithInstallmentDue = SRBWithInstallmentDue -20.75, 
 SBWithInstallmentDue = SBWithInstallmentDue -20.75, DaysDelinquent = 0, NoPayDaysDelinquent = 0,
AmountOfTotalDue = AmountOfTotalDue - 20.75, RunningMinimumDue = RunningMinimumDue - 20.75, RemainingMinimumDue = RemainingMinimumDue - 20.75, AmountOfPayment30DLate = AmountOfPayment30DLate - 20.75,
DateOfOriginalPaymentDUeDTD = '2022-04-30 23:59:57.000', DtOfLastDelinqCTD = NULL  WHERE AcctID = 2296309

UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, SRBWithInstallmentDue = SRBWithInstallmentDue -20.75, 
SBWithInstallmentDue = SBWithInstallmentDue - 20.75, AmountOfTotalDue = AmountOfTotalDue - 20.75, AmountOfPayment30DLate = AmountOfPayment30DLate - 20.75 WHERE Acctid = 44220466 

UPDATE TOP(1) AccountInfoForReport  SET CycleDueDTD = 1, SystemStatus = 2, SRBWithInstallmentDue = SRBWithInstallmentDue -20.75, 
 SBWithInstallmentDue = SBWithInstallmentDue -20.75, DaysDelinquent = 0, TotalDaysDelinquent = 0,
AmountOfTotalDue = AmountOfTotalDue - 20.75, AmountOfPayment30DLate = AmountOfPayment30DLate - 20.75,
DateOfOriginalPaymentDUeDTD = '2022-04-30 23:59:57.000', DAteOfDelinquency = NULL  WHERE BSAcctID = 2296309 and BusinessDay = '2022-04-01 23:59:57.000'

UPDATE TOP(1) PlanInfoForReport SET CycleDueDTD = 0, SRBWithInstallmentDue = SRBWithInstallmentDue -20.75, 
SBWithInstallmentDue = SBWithInstallmentDue - 20.75, AmountOfTotalDue = AmountOfTotalDue - 20.75, AmountOfPayment30DLate = AmountOfPayment30DLate - 20.75 WHERE cpsAcctid = 44220466  and BusinessDay = '2022-04-01 23:59:57.000'


---for wrong update 

 
UPDATE TOP(1) AccountInfoForReport  SET CycleDueDTD = 0 WHERE BSAcctID = 17277194 and BusinessDay = '2021-05-04 23:59:57.000'
