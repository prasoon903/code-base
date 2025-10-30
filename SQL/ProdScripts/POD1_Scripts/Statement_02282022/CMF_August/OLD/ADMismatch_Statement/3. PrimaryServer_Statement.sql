-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO


BEGIN TRANSACTION
--COMMIT TRANSACTION
-- ROLLBACK TRANSACTION

UPDATE TOP(1) StatementHeader SET MinimumPaymentDue = 0, AmountOfTotalDue = 0, AmtOfPayXDLate = 0, DateOfOriginalPaymentDueDTD = NULL,
CycleDueDTD = 0, SystemStatus = 2 WHERE acctId = 1236490 AND StatementID = 91647685

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = 0 WHERE acctId = 1248910 AND StatementID = 91647685
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0, AmtOfPayXDLate = 0 WHERE acctId = 1248910 AND StatementID = 91647685


UPDATE TOP(1) StatementHeader SET MinimumPaymentDue = 0, AmountOfTotalDue = 0, AmtOfPayXDLate = 0, DateOfOriginalPaymentDueDTD = NULL,AmountOfPayment90DLate = 0,
CycleDueDTD = 0, SystemStatus = 2 WHERE acctId = 878557 AND StatementID = 91412864

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = 0 WHERE acctId = 56748018 AND StatementID = 91412864
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0, AmtOfPayXDLate = 0 WHERE acctId = 56748018 AND StatementID = 91412864




UPDATE TOP(1) StatementHeader SET MinimumPaymentDue = MinimumPaymentDue + 54.22, AmountOfTotalDue = AmountOfTotalDue + 54.22, AmtOfPayCurrDue = AmtOfPayCurrDue + 54.68, 
AmountOfPayment30DLate = AmountOfPayment30DLate - 0.46, DateOfOriginalPaymentDueDTD = NULL,
CycleDueDTD = 0, SystemStatus = 2 WHERE acctId = 7819098 AND StatementID = 94084613

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue - 0.46 WHERE acctId = 56005302 AND StatementID = 94084613
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0, AmountOfPayment30DLate = AmountOfPayment30DLate - 0.46 WHERE acctId = 56005302 AND StatementID = 94084613



UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue + 7.94 WHERE acctId = 3475109 AND StatementID = 93256439
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 1, CurrentDue = CurrentDue + 7.94 WHERE acctId = 3475109 AND StatementID = 93256439


UPDATE TOP(1) StatementHeader SET AmtOfPayXDLate = AmtOfPayXDLate - 25, AmountOfTotalDue = AmountOfTotalDue - 25 WHERE acctId = 12125607 AND StatementID = 94871139

UPDATE TOP(1) SummaryHeaderCreditCard SET AmtOfPayXDLate = AmtOfPayXDLate - 25 WHERE acctId = 32487735 AND StatementID = 94871139


UPDATE TOP(1) StatementHeader SET CycleDueDTD = 1, SystemStatus = 2, MinimumPaymentDue = MinimumPaymentDue - 0.14, AmountOfTotalDue = AmountOfTotalDue - 0.14, 
AmtOfPayXDLate = AmtOfPayXDLate - 0.14, DateOfOriginalPaymentDueDTD = '2021-09-30 23:59:57.000' WHERE acctId = 4346940 AND StatementID = 93890156


UPDATE TOP(1) StatementHeader SET CycleDueDTD = 1, SystemStatus = 2, MinimumPaymentDue = MinimumPaymentDue - 0.08, AmountOfTotalDue = AmountOfTotalDue - 0.08, 
AmtOfPayXDLate = AmtOfPayXDLate - 0.08, DateOfOriginalPaymentDueDTD = '2021-09-30 23:59:57.000' WHERE acctId = 6404696 AND StatementID = 94328157


UPDATE TOP(1) StatementHeader SET CycleDueDTD = 1, SystemStatus = 2, MinimumPaymentDue = MinimumPaymentDue - 1.06, AmountOfTotalDue = AmountOfTotalDue - 1.06, 
AmtOfPayXDLate = AmtOfPayXDLate - 1.06, DateOfOriginalPaymentDueDTD = '2021-09-30 23:59:57.000' WHERE acctId = 12400964 AND StatementID = 94932699


UPDATE TOP(1) StatementHeader SET CycleDueDTD = 1, SystemStatus = 2, MinimumPaymentDue = MinimumPaymentDue - 25, AmountOfTotalDue = AmountOfTotalDue - 25, 
AmtOfPayXDLate = AmtOfPayXDLate - 25, DateOfOriginalPaymentDueDTD = '2021-09-30 23:59:57.000' WHERE acctId = 18251859 AND StatementID = 96347868



UPDATE TOP(1) StatementHeader SET CycleDueDTD = 1, SystemStatus = 2, MinimumPaymentDue = MinimumPaymentDue - 25, AmountOfTotalDue = AmountOfTotalDue - 25, 
AmtOfPayXDLate = AmtOfPayXDLate - 25, DateOfOriginalPaymentDueDTD = '2021-09-30 23:59:57.000' WHERE acctId = 18683978 AND StatementID = 96739944


UPDATE TOP(1) StatementHeader SET AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, DateOfOriginalPaymentDueDTD = NULL,
CycleDueDTD = 0, SystemStatus = 2 WHERE acctId = 19385355 AND StatementID = 96850560

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = 0 WHERE acctId = 60063347 AND StatementID = 96850560
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0, AmtOfPayXDLate = 0 WHERE acctId = 60063347 AND StatementID = 96850560