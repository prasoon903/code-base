

USE CCGS_CoreIssue 
Go 

BEGIN TRAN 
--COMMIT TRAN 
--ROLLBACK TRAN


UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = 0 WHERE acctID = 321834 AND StatementID = 137818156
UPDATE TOP(1) SummaryHeaderCreditCard SET CurrentDue = 0, CycleDUeDTD = 0 WHERE acctID = 321834 AND StatementID = 137818156

UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, CycleDUeDTD = 0 WHERE CPSAcctID = 321834 AND BusinessDay = '2022-03-31 23:59:57.000'



--UPDATE TOP(1) AccountInfoForReport  SET CycleDueDTD = 1, SystemStatus = 2, SRBWithInstallmentDue = SRBWithInstallmentDue -20.75, 
--  DaysDelinquent = 0, TotalDaysDelinquent = 0,
--SBWithInstallmentDue = SBWithInstallmentDue - 20.75, AmountOfTotalDue = AmountOfTotalDue - 20.75, AmountOfPayment30DLate = AmountOfPayment30DLate - 20.75,
--DateOfOriginalPaymentDUeDTD = '2022-04-30 23:59:57.000', DAteOfDelinquency = NULL  WHERE BSAcctID = 2296309 AND BusinessDay = '2022-03-31 23:59:57.000'

--UPDATE TOP(1) PlanInfoForReport SET CycleDueDTD = 1, SystemStatus = 2, SRBWithInstallmentDue = SRBWithInstallmentDue -20.75, 
--SBWithInstallmentDue = SBWithInstallmentDue - 20.75, AmountOfTotalDue = AmountOfTotalDue - 20.75, AmountOfPayment30DLate = AmountOfPayment30DLate - 20.75
-- WHERE BSAcctID = 2296309 AND CPSAcctid = 44220466 AND BusinessDay = '2022-03-31 23:59:57.000'



--UPDATE TOP(1) StatementHeader SET DateOfOriginalPaymentDUeDTD = '2022-04-30 23:59:57.000',  WHERE Acctid = 2296309 AND StatementID = 139776058

--UPDATE TOP(1) StatementHeaderEX SET DaysDelinquent = 0, NoPayDaysDelinquent = 0  WHERE Acctid = 2296309 AND StatementID = 139776058


--UPDATE TOP(1) SummaryHeaderCreditCard SET SBWithInstallmentDue = SBWithInstallmentDue -20.75  WHERE Acctid = 44220466 AND StatementID = 139776058

--UPDATE TOP(1) StatementHeader SET CycleDueDTD = 1, SystemStatus = 2, MinimumPaymentDue = MinimumPaymentDue - 20.75, SRBWithInstallmentDue = SRBWithInstallmentDue -20.75, 
--SBWithInstallmentDue = SBWithInstallmentDue - 20.75, AmountOfTotalDue = AmountOfTotalDue - 20.75, AmountOfPayment30DLate = AmountOfPayment30DLate - 20.75,
--AmtOfPayPastDue = AmtOfPayPastDue -20.75 WHERE Acctid = 2296309 AND StatementID = 139776058

--UPDATE TOP(1) SummaryHeader SET  AmountOfTotalDue = AmountOfTotalDue - 20.75 WHERE Acctid = 44220466 AND StatementID = 139776058

--UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 1,   SRBWithInstallmentDue = SRBWithInstallmentDue -20.75, 
--AmountOfPayment30DLate = AmountOfPayment30DLate - 20.75  WHERE Acctid = 44220466 AND StatementID = 139776058

