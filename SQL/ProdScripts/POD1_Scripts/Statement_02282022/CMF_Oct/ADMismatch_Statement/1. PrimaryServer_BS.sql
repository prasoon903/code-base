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

UPDATE TOP(1) BSegmentCreditCard SET AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, DateOfLastDelinqCTD = NULL, DateOfOriginalPaymentDueDTD = NULL,
SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 ,FirstDueDate = NULL, DaysDelinquent = 0, NoPayDaysDelinquent = 0 WHERE acctId = 417786

UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 430006
UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 6277877
UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 57775975
UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 57775976

UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '0' WHERE AID = 417786 AND ATID = 51 AND IdentityField = 2209495345


UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = 0, CycleDueDTD = 0, SystemStatus = 2 WHERE acctId = 1845697

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, SRBWithInstallmentDue = 0, 
SBWithInstallmentDue = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DateOfLastDelinqCTD = NULL, DateOfOriginalPaymentDueDTD = NULL, 
FirstDueDate = NULL, DaysDelinquent = 0, NoPayDaysDelinquent = 0 WHERE acctId = 1845697

UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 67385604


UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = 0, CycleDueDTD = 0, SystemStatus = 2 WHERE acctId = 21091933

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, SRBWithInstallmentDue = 0, 
SBWithInstallmentDue = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DateOfLastDelinqCTD = NULL, DateOfOriginalPaymentDueDTD = NULL, 
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
SBWithInstallmentDue = SBWithInstallmentDue - 37.54, RunningMinimumDue = RunningMinimumDue - 4.2, RemainingMinimumDue = RemainingMinimumDue - 4.2, DateOfLastDelinqCTD = NULL, DateOfOriginalPaymentDueDTD = NULL, 
FirstDueDate = NULL, DaysDelinquent = 0, NoPayDaysDelinquent = 0 WHERE acctId = 20591141

UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 66820565
UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0.06, AmtOfPayCurrDue = 0.06 WHERE acctId = 63449589
UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 4.08, AmtOfPayCurrDue = 4.08, SRBWithInstallmentDue = 4.08, SBWithInstallmentDue = 4.08 WHERE acctId = 69347016

DELETE FROM CurrentBalanceAudit WHERE AID = 20591141 AND ATID = 51 AND IdentityField = 2234337736
DELETE FROM CurrentBalanceAudit WHERE AID = 20591141 AND ATID = 51 AND IdentityField = 2234337737
UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '4.14' WHERE AID = 20591141 AND ATID = 51 AND IdentityField = 2234337738



/*
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 1, AmtOfPayXDLate = AmtOfPayXDLate - 2.59, AmountOfTotalDue = AmountOfTotalDue - 2.59 WHERE acctId = 14715 

UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 1, AmtOfPayXDLate = AmtOfPayXDLate - 24.30, AmountOfTotalDue = AmountOfTotalDue - 24.30 WHERE acctId = 15984 

UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 1, AmtOfPayXDLate = AmtOfPayXDLate - 24.82, AmountOfTotalDue = AmountOfTotalDue - 24.82 WHERE acctId = 16587 

UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 1, AmtOfPayXDLate = AmtOfPayXDLate - 21.03, AmountOfTotalDue = AmountOfTotalDue - 21.03 WHERE acctId = 55603609 

UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 1, AmtOfPayXDLate = AmtOfPayXDLate - 24.34, AmountOfTotalDue = AmountOfTotalDue - 24.34 WHERE acctId = 56291 

UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 1, AmtOfPayXDLate = AmtOfPayXDLate - 24.69, AmountOfTotalDue = AmountOfTotalDue - 24.69 WHERE acctId = 120236 



UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SYstemStatus = 2 WHERE acctId = 122810

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 42.88, AmtOfPayXDLate = AmtOfPayXDLate - 42.88,
RunningMinimumDue = RunningMinimumDue - 42.88, RemainingMinimumDue = RemainingMinimumDue - 42.88 WHERE acctId = 122810



UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctId = 244248

UPDATE TOP(1) BSegmentCreditCard SET AmtOfPayXDLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DateOfLastDelinqCTD = NULL, DateOfOriginalPaymentDueDTD = NULL, 
FirstDueDate = NULL, DaysDelinquent = 0, NoPayDaysDelinquent = 0 WHERE acctId = 244248

UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, CycleDueDTD = 0 WHERE acctId = 20590875



UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = AmtOfPayCurrDue + 52.30 WHERE acctId = 417786

UPDATE TOP(1) BSegmentCreditCard SET AmtOfPayXDLate = AmtOfPayXDLate - 26.15, AmountOfPayment30DLate = AmountOfPayment30DLate - 26.15, DateOfLastDelinqCTD = NULL, DateOfOriginalPaymentDueDTD = NULL,
SRBWithInstallmentDue = SRBWithInstallmentDue - 52.30, SBWithInstallmentDue = SBWithInstallmentDue - 52.30 ,
FirstDueDate = NULL, DaysDelinquent = 0, NoPayDaysDelinquent = 0 WHERE acctId = 417786

UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 7.78, CycleDueDTD = 1, AmtOfPayCurrDue = AmtOfPayCurrDue + 7.78 WHERE acctId = 430006
UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 3.41, CycleDueDTD = 1, AmtOfPayCurrDue = AmtOfPayCurrDue + 3.41 WHERE acctId = 6277877
UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 57775975
UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 57775976



UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctId = 588281

UPDATE TOP(1) BSegmentCreditCard SET AmtOfPayXDLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DateOfLastDelinqCTD = NULL, DateOfOriginalPaymentDueDTD = NULL, 
FirstDueDate = NULL, DaysDelinquent = 0, NoPayDaysDelinquent = 0 WHERE acctId = 588281

UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, CycleDueDTD = 0 WHERE acctId = 600501




UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctId = 659234

UPDATE TOP(1) BSegmentCreditCard SET AmtOfPayXDLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DateOfLastDelinqCTD = NULL, DateOfOriginalPaymentDueDTD = NULL, 
FirstDueDate = NULL, DaysDelinquent = 0, NoPayDaysDelinquent = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 659234

UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 66215965
UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 66810225



UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctId = 883659

UPDATE TOP(1) BSegmentCreditCard SET AmtOfPayXDLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DateOfLastDelinqCTD = NULL, DateOfOriginalPaymentDueDTD = NULL, 
FirstDueDate = NULL, DaysDelinquent = 0, NoPayDaysDelinquent = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 883659

UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 66742392



UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctId = 1240951

UPDATE TOP(1) BSegmentCreditCard SET AmtOfPayXDLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DateOfLastDelinqCTD = NULL, DateOfOriginalPaymentDueDTD = NULL, 
FirstDueDate = NULL, DaysDelinquent = 0, NoPayDaysDelinquent = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 1240951

UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 66478297
UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 66478298





UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctId = 1255358

UPDATE TOP(1) BSegmentCreditCard SET AmountOfPayment30DLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DateOfLastDelinqCTD = NULL, DateOfOriginalPaymentDueDTD = NULL, 
FirstDueDate = NULL, DaysDelinquent = 0, NoPayDaysDelinquent = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 1255358

UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 44752305
UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 45639853




UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctId = 1344799

UPDATE TOP(1) BSegmentCreditCard SET AmtOfPayXDLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DateOfLastDelinqCTD = NULL, DateOfOriginalPaymentDueDTD = NULL, 
FirstDueDate = NULL, DaysDelinquent = 0, NoPayDaysDelinquent = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 1344799

UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 1357219




UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctId = 1356278

UPDATE TOP(1) BSegmentCreditCard SET AmtOfPayXDLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DateOfLastDelinqCTD = NULL, DateOfOriginalPaymentDueDTD = NULL, 
FirstDueDate = NULL, DaysDelinquent = 0, NoPayDaysDelinquent = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 1356278

UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 8350272




UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctId = 1378174

UPDATE TOP(1) BSegmentCreditCard SET AmtOfPayXDLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DateOfLastDelinqCTD = NULL, DateOfOriginalPaymentDueDTD = NULL, 
FirstDueDate = NULL, DaysDelinquent = 0, NoPayDaysDelinquent = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 1378174

UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 67069091




UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue + 0.2 WHERE acctId = 1392139

UPDATE TOP(1) BSegmentCreditCard SET AmountOfPayment60DLate = AmountOfPayment60DLate - 0.2 WHERE acctId = 1392139

UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 10.46, CycleDueDTD = 1, AmtOfPayCurrDue = AmtOfPayCurrDue + 10.46 WHERE acctId = 1404559
UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 0.2, AmountOfPayment60DLate = AmountOfPayment60DLate - 0.2 WHERE acctId = 12720174



UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctId = 1508643

UPDATE TOP(1) BSegmentCreditCard SET AmtOfPayXDLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DateOfLastDelinqCTD = NULL, DateOfOriginalPaymentDueDTD = NULL, 
FirstDueDate = NULL, DaysDelinquent = 0, NoPayDaysDelinquent = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 1508643

UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 41925982




UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctId = 1722050

UPDATE TOP(1) BSegmentCreditCard SET AmtOfPayXDLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DateOfLastDelinqCTD = NULL, DateOfOriginalPaymentDueDTD = NULL, 
FirstDueDate = NULL, DaysDelinquent = 0, NoPayDaysDelinquent = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 1722050

UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 13449029




UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctId = 1841625

UPDATE TOP(1) BSegmentCreditCard SET AmtOfPayXDLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DateOfLastDelinqCTD = NULL, DateOfOriginalPaymentDueDTD = NULL, 
FirstDueDate = NULL, DaysDelinquent = 0, NoPayDaysDelinquent = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 1841625

UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 16149698




UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue + 52.02, CycleDueDTD = 1, SystemStatus = 2 WHERE acctId = 1845697

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 172.89, AmtOfPayXDLate = AmtOfPayXDLate - 224.91, SRBWithInstallmentDue = SRBWithInstallmentDue - 224.91, 
SBWithInstallmentDue = SBWithInstallmentDue - 224.91, RunningMinimumDue = RunningMinimumDue - 172.89, RemainingMinimumDue = RemainingMinimumDue - 172.89, DateOfLastDelinqCTD = NULL, DateOfOriginalPaymentDueDTD = NULL, 
FirstDueDate = NULL, DaysDelinquent = 0, NoPayDaysDelinquent = 0 WHERE acctId = 1845697

UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 224.91, AmtOfPayCurrDue = AmtOfPayCurrDue + 224.91 WHERE acctId = 1865687
UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 67385604



UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 3.07, CycleDueDTD = 1, AmtOfPayCurrDue = AmtOfPayCurrDue + 3.07 WHERE acctId = 2136728




UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue + 54.64, CycleDueDTD = 1, SystemStatus = 2 WHERE acctId = 2706267

UPDATE TOP(1) BSegmentCreditCard SET AmtOfPayXDLate = AmtOfPayXDLate - 54.64, SRBWithInstallmentDue = SRBWithInstallmentDue + 94.33, 
SBWithInstallmentDue = SBWithInstallmentDue + 94.33, DateOfLastDelinqCTD = NULL, DateOfOriginalPaymentDueDTD = NULL, 
FirstDueDate = NULL, DaysDelinquent = 0, NoPayDaysDelinquent = 0 WHERE acctId = 2706267

UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 1124.01, CycleDueDTD = 1, AmtOfPayCurrDue = AmtOfPayCurrDue + 1124.01, 
SRBWithInstallmentDue = SRBWithInstallmentDue + 1124.01, SBWithInstallmentDue = SBWithInstallmentDue + 1124.01 WHERE acctId = 69562449
UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 13079736






UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctId = 2724147

UPDATE TOP(1) BSegmentCreditCard SET AmtOfPayXDLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DateOfLastDelinqCTD = NULL, DateOfOriginalPaymentDueDTD = NULL, 
FirstDueDate = NULL, DaysDelinquent = 0, NoPayDaysDelinquent = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 2724147

UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 2872157
UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 36114861




UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = AmtOfPayCurrDue + 1.31 WHERE acctId = 2837196

UPDATE TOP(1) BSegmentCreditCard SET AmtOfPayXDLate = AmtOfPayXDLate - 1.31, SRBWithInstallmentDue = SRBWithInstallmentDue + 22.04, 
SBWithInstallmentDue = SBWithInstallmentDue + 22.04, DateOfLastDelinqCTD = NULL, DateOfOriginalPaymentDueDTD = NULL, 
FirstDueDate = NULL, DaysDelinquent = 0, NoPayDaysDelinquent = 0 WHERE acctId = 2837196

UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 9699839
UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 239.50, CycleDueDTD = 1, AmtOfPayCurrDue = AmtOfPayCurrDue + 239.50, 
SRBWithInstallmentDue = SRBWithInstallmentDue + 239.50, SBWithInstallmentDue = SBWithInstallmentDue + 239.50 WHERE acctId = 36114861





UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue + 0.1 WHERE acctId = 2983913

UPDATE TOP(1) BSegmentCreditCard SET AmountOfPayment60DLate = AmountOfPayment60DLate - 0.1 WHERE acctId = 2983913

UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 28.4, CycleDueDTD = 1, AmtOfPayCurrDue = AmtOfPayCurrDue + 28.4 WHERE acctId = 3472063
UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 0.1, AmountOfPayment60DLate = AmountOfPayment60DLate - 0.1 WHERE acctId = 10320496




UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctId = 3996361

UPDATE TOP(1) BSegmentCreditCard SET AmtOfPayXDLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DateOfLastDelinqCTD = NULL, DateOfOriginalPaymentDueDTD = NULL, 
FirstDueDate = NULL, DaysDelinquent = 0, NoPayDaysDelinquent = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 3996361

UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 11109111



UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = AmtOfPayCurrDue + 41.62 WHERE acctId = 7853217

UPDATE TOP(1) BSegmentCreditCard SET AmtOfPayXDLate = AmtOfPayXDLate - 41.62, SRBWithInstallmentDue = SRBWithInstallmentDue + 41.62, 
SBWithInstallmentDue = SBWithInstallmentDue + 41.62, DateOfLastDelinqCTD = NULL, DateOfOriginalPaymentDueDTD = NULL, 
FirstDueDate = NULL, DaysDelinquent = 0, NoPayDaysDelinquent = 0 WHERE acctId = 7853217

UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 67249738
UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 20.98, AmtOfPayCurrDue = AmtOfPayCurrDue + 20.98 WHERE acctId = 19159375



UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctId = 8940606

UPDATE TOP(1) BSegmentCreditCard SET AmtOfPayXDLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DateOfLastDelinqCTD = NULL, DateOfOriginalPaymentDueDTD = NULL, 
FirstDueDate = NULL, DaysDelinquent = 0, NoPayDaysDelinquent = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 8940606

UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 33326406




UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctId = 9806096

UPDATE TOP(1) BSegmentCreditCard SET AmtOfPayXDLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DateOfLastDelinqCTD = NULL, DateOfOriginalPaymentDueDTD = NULL, 
FirstDueDate = NULL, DaysDelinquent = 0, NoPayDaysDelinquent = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 9806096

UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 24106254
UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 33539153
UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 33539154
UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 37712715
UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 37712824
UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 37712825
UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 53701058
UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 67224884
UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 67225007



UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctId = 10655987

UPDATE TOP(1) BSegmentCreditCard SET AmtOfPayXDLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DateOfLastDelinqCTD = NULL, DateOfOriginalPaymentDueDTD = NULL, 
FirstDueDate = NULL, DaysDelinquent = 0, NoPayDaysDelinquent = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 10655987

UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 28870326



UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctId = 11089488

UPDATE TOP(1) BSegmentCreditCard SET AmtOfPayXDLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DateOfLastDelinqCTD = NULL, DateOfOriginalPaymentDueDTD = NULL, 
FirstDueDate = NULL, DaysDelinquent = 0, NoPayDaysDelinquent = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 11089488

UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 35504324
UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 36850490




UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctId = 11520974

UPDATE TOP(1) BSegmentCreditCard SET AmtOfPayXDLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DateOfLastDelinqCTD = NULL, DateOfOriginalPaymentDueDTD = NULL, 
FirstDueDate = NULL, DaysDelinquent = 0, NoPayDaysDelinquent = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 11520974

UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 67551672


UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctId = 13071394

UPDATE TOP(1) BSegmentCreditCard SET AmtOfPayXDLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DateOfLastDelinqCTD = NULL, DateOfOriginalPaymentDueDTD = NULL, 
FirstDueDate = NULL, DaysDelinquent = 0, NoPayDaysDelinquent = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 13071394

UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 66851331



UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctId = 13572797

UPDATE TOP(1) BSegmentCreditCard SET AmtOfPayXDLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DateOfLastDelinqCTD = NULL, DateOfOriginalPaymentDueDTD = NULL, 
FirstDueDate = NULL, DaysDelinquent = 0, NoPayDaysDelinquent = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 13572797

UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 67141268



UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctId = 13611044

UPDATE TOP(1) BSegmentCreditCard SET AmtOfPayXDLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DateOfLastDelinqCTD = NULL, DateOfOriginalPaymentDueDTD = NULL, 
FirstDueDate = NULL, DaysDelinquent = 0, NoPayDaysDelinquent = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 13611044

UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 40157009



UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctId = 18041996

UPDATE TOP(1) BSegmentCreditCard SET AmtOfPayXDLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DateOfLastDelinqCTD = NULL, DateOfOriginalPaymentDueDTD = NULL, 
FirstDueDate = NULL, DaysDelinquent = 0, NoPayDaysDelinquent = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 18041996

UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 66124027


UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctId = 18390195

UPDATE TOP(1) BSegmentCreditCard SET AmtOfPayXDLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DateOfLastDelinqCTD = NULL, DateOfOriginalPaymentDueDTD = NULL, 
FirstDueDate = NULL, DaysDelinquent = 0, NoPayDaysDelinquent = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 18390195

UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 57295800
UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 66432453


UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctId = 13071394

UPDATE TOP(1) BSegmentCreditCard SET AmtOfPayXDLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DateOfLastDelinqCTD = NULL, DateOfOriginalPaymentDueDTD = NULL, 
FirstDueDate = NULL, DaysDelinquent = 0, NoPayDaysDelinquent = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 13071394

UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 66851331


UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctId = 20602937

UPDATE TOP(1) BSegmentCreditCard SET AmtOfPayXDLate = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DateOfLastDelinqCTD = NULL, DateOfOriginalPaymentDueDTD = NULL, 
FirstDueDate = NULL, DaysDelinquent = 0, NoPayDaysDelinquent = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 20602937

UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, CycleDueDTD = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 65591084





*/