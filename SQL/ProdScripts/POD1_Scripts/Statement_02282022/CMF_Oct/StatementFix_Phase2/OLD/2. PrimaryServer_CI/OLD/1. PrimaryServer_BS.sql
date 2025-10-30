-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO


BEGIN TRANSACTION
--COMMIT TRANSACTION
-- ROLLBACK TRANSACTION

UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 1, AmtOfPayXDLate = AmtOfPayXDLate - 2.59, AmountOfTotalDue = AmountOfTotalDue - 2.59 WHERE acctId = 14715 

UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 1, AmtOfPayXDLate = AmtOfPayXDLate - 24.30, AmountOfTotalDue = AmountOfTotalDue - 24.30 WHERE acctId = 15984

UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 1, AmtOfPayXDLate = AmtOfPayXDLate - 24.34, AmountOfTotalDue = AmountOfTotalDue - 24.34 WHERE acctId = 56291

UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 1, AmtOfPayXDLate = AmtOfPayXDLate - 24.82, AmountOfTotalDue = AmountOfTotalDue - 24.82 WHERE acctId = 16587  

UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SYstemStatus = 2 WHERE acctId = 122810

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 42.88, AmtOfPayXDLate = AmtOfPayXDLate - 42.88,
RunningMinimumDue = RunningMinimumDue - 42.88, RemainingMinimumDue = RemainingMinimumDue - 42.88 WHERE acctId = 122810

UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 1, AmtOfPayXDLate = AmtOfPayXDLate - 24.69, AmountOfTotalDue = AmountOfTotalDue - 24.69 WHERE acctId = 120236 


UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctId = 417786

UPDATE TOP(1) BSegmentCreditCard SET AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, DtOfLastDelinqCTD = NULL, DateOfOriginalPaymentDueDTD = NULL,
SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 ,FirstDueDate = NULL, DaysDelinquent = 0, NoPayDaysDelinquent = 0 WHERE acctId = 417786

UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 430006
UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 6277877
UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 57775975
UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 57775976

UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '0' WHERE AID = 417786 AND ATID = 51 AND IdentityField = 2209495345


UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = 0, CycleDueDTD = 0, SystemStatus = 2 WHERE acctId = 1845697

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, SRBWithInstallmentDue = 0, 
SBWithInstallmentDue = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DtOfLastDelinqCTD = NULL, DateOfOriginalPaymentDueDTD = NULL, 
FirstDueDate = NULL, DaysDelinquent = 0, NoPayDaysDelinquent = 0 WHERE acctId = 1845697

UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 67385604


UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = 0, CycleDueDTD = 0, SystemStatus = 2 WHERE acctId = 21091933

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, SRBWithInstallmentDue = 0, 
SBWithInstallmentDue = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DtOfLastDelinqCTD = NULL, DateOfOriginalPaymentDueDTD = NULL, 
FirstDueDate = NULL, DaysDelinquent = 0, NoPayDaysDelinquent = 0 WHERE acctId = 21091933

UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 67656519
UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 67656520

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue + 64.72 WHERE acctId = 68406221 AND StatementID = 109961293
UPDATE TOP(1) SummaryHeaderCreditCard SET CurrentDue = CurrentDue + 32.36, AmtOfPayXDLate = AmtOfPayXDLate + 64.72 WHERE acctId = 68406221 AND StatementID = 109961293



UPDATE TOP(1) StatementHeader SET AmountOfTotalDue = AmountOfTotalDue - 4.2, MinimumPaymentDue = MinimumPaymentDue - 4.2, AmtOfPayCurrDue = AmtOfPayCurrDue + 37.42, AmtOfPayXDLate = AmtOfPayXDLate - 41.62,
AmtOfPayPastDue = AmtOfPayPastDue - 41.62, SRBWithInstallmentDue = SRBWithInstallmentDue - 37.54, 
SBWithInstallmentDue = SBWithInstallmentDue - 37.54, CycleDueDTD = 1, SystemStatus = 2 WHERE acctId = 20591141 AND StatementID = 109881012

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = 0 WHERE acctId = 66820565 AND StatementID = 109881012
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0, CurrentDue = 0, AmtOfPayXDLate = 0 WHERE acctId = 66820565 AND StatementID = 109881012

UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = AmtOfPayCurrDue + 4.14 WHERE acctId = 20591141

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 4.2, AmtOfPayXDLate = AmtOfPayXDLate - 41.62, SRBWithInstallmentDue = SRBWithInstallmentDue - 37.54, 
SBWithInstallmentDue = SBWithInstallmentDue - 37.54, RunningMinimumDue = RunningMinimumDue - 4.2, RemainingMinimumDue = RemainingMinimumDue - 4.2, DtOfLastDelinqCTD = NULL, DateOfOriginalPaymentDueDTD = NULL, 
FirstDueDate = NULL, DaysDelinquent = 0, NoPayDaysDelinquent = 0 WHERE acctId = 20591141

UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 66820565
UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0.06, AmtOfPayCurrDue = 0.06 WHERE acctId = 63449589
UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 4.08, AmtOfPayCurrDue = 4.08, SRBWithInstallmentDue = 4.08, SBWithInstallmentDue = 4.08 WHERE acctId = 69347016

DELETE FROM CurrentBalanceAudit WHERE AID = 20591141 AND ATID = 51 AND IdentityField = 2234337736
DELETE FROM CurrentBalanceAudit WHERE AID = 20591141 AND ATID = 51 AND IdentityField = 2234337737
UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '4.14' WHERE AID = 20591141 AND ATID = 51 AND IdentityField = 2234337738

