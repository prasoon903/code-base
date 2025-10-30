-- TO BE RUN ON PRIMARY SERVER ONLY

BEGIN TRANSACTION
--COMMIT TRANSACTION
-- ROLLBACK TRANSACTION

UPDATE CPSgmentCreditCard SET AmtOfPayCurrDue = AmountOfTotalDue, AmtOfPayXDLate = 0 WHERE 
acctId in (745279,  576777, 514290, 1377978, 1643942, 1687039, 1869157, 2563075, 8228378, 10227247, 10477343, 24116367, 33182621, 37073205)
--30494748,30564120,36331606,36846381,46008454,46008455,53543938

UPDATE TOP(1) StatementHeader SET AmountOfPayment30DLate = AmountOfPayment30DLate + 32.19, AmountOfPayment60DLate = AmountOfPayment60DLate - 32.19 WHERE acctId = 13004403 AND StatementID = 83351600

UPDATE TOP(1) AccountInfoForReport SET AmountOfPayment30DLate = AmountOfPayment30DLate + 32.19, AmountOfPayment60DLate = AmountOfPayment60DLate - 32.19 WHERE BSacctId = 13004403 AND BusinessDay = '2021-06-30 23:59:57.000'	


/*

UPDATE TOP(1) CPSgmentCreditCard SET AmtOfPayCurrDue = AmtOfPayCurrDue - 0.01, AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE acctId = 745279 -- BSAcctId = 732869

UPDATE TOP(1) CPSgmentCreditCard SET AmtOfPayCurrDue = AmtOfPayCurrDue - 0.01, AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE acctId = 576777 -- BSAcctId = 564557

UPDATE TOP(1) CPSgmentCreditCard SET AmtOfPayCurrDue = AmtOfPayCurrDue - 0.01, AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE acctId = 514290 -- BSAcctId = 502070

UPDATE TOP(1) CPSgmentCreditCard SET AmtOfPayCurrDue = AmtOfPayCurrDue - 0.01, AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE acctId = 1377978 -- BSAcctId = 1365558

UPDATE TOP(1) CPSgmentCreditCard SET AmtOfPayCurrDue = AmtOfPayCurrDue - 0.01, AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE acctId = 1643942 -- BSAcctId = 1631522

UPDATE TOP(1) CPSgmentCreditCard SET AmtOfPayCurrDue = AmtOfPayCurrDue - 0.01, AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE acctId = 1687039 -- BSAcctId = 1672059

UPDATE TOP(1) CPSgmentCreditCard SET AmtOfPayCurrDue = AmtOfPayCurrDue - 0.01, AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE acctId = 1869157 -- BSAcctId = 1848767

UPDATE TOP(1) CPSgmentCreditCard SET AmtOfPayCurrDue = AmtOfPayCurrDue - 0.01, AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE acctId = 2563075 -- BSAcctId = 2477135

UPDATE TOP(1) CPSgmentCreditCard SET AmtOfPayCurrDue = AmtOfPayCurrDue - 0.01, AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE acctId = 8228378 -- BSAcctId = 4492220

UPDATE TOP(1) CPSgmentCreditCard SET AmtOfPayCurrDue = AmtOfPayCurrDue - 0.01, AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE acctId = 10227247 -- BSAcctId = 4881089

UPDATE TOP(1) CPSgmentCreditCard SET AmtOfPayCurrDue = AmtOfPayCurrDue - 0.01, AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE acctId = 10477343 -- BSAcctId = 4941185

UPDATE TOP(1) CPSgmentCreditCard SET AmtOfPayCurrDue = AmtOfPayCurrDue - 0.01, AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE acctId = 24116367 -- BSAcctId = 9816209

UPDATE TOP(1) CPSgmentCreditCard SET AmtOfPayCurrDue = AmtOfPayCurrDue - 0.01, AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE acctId = 33182621 -- BSAcctId = 12366511

UPDATE TOP(1) CPSgmentCreditCard SET AmtOfPayCurrDue = AmtOfPayCurrDue - 0.01, AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE acctId = 37073205 -- BSAcctId = 13538031


UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 175.40, AmountOfPayment30DLate = AmountOfPayment30DLate - 4.66, AmountOfPayment60DLate = AmountOfPayment60DLate + 4.66, 
RunningMinimumDue = RunningMinimumDue + 175.40, RemainingMinimumDue = RemainingMinimumDue + 175.40 WHERE acctId = 1742986

UPDATE TOP(1) CPSgmentCreditCard SET AmtOfPayXDLate = AmtOfPayXDLate + 4.66, AmountOfPayment30DLate = AmountOfPayment30DLate - 9.32, 
AmountOfPayment60DLate = AmountOfPayment60DLate + 4.66 WHERE acctId = 26055371 -- BSAcctId = 1742986


UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2 WHERE acctId = 10895026

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 278.32, AmtOfPayXDLate = AmtOfPayXDLate - 278.32, 
RunningMinimumDue = RunningMinimumDue - 278.32, RemainingMinimumDue = RemainingMinimumDue - 278.32 WHERE acctId = 10895026


UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue + 25 WHERE acctId = 12125607

UPDATE TOP(1) CPSgmentCreditCard SET AmtOfPayCurrDue = AmtOfPayCurrDue + 25 WHERE acctId = 32487735 -- BSAcctId = 12125607



UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 3 WHERE acctId = 13004403

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 32.19, RunningMinimumDue = RunningMinimumDue + 32.19, RemainingMinimumDue = RemainingMinimumDue + 32.19 WHERE acctId = 13004403

UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 3 WHERE acctId = 37085917 -- BSAcctId = 13004403



UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 11.50 WHERE acctId = 13566557

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 16.91, AmtOfPayXDLate = AmtOfPayXDLate + 11.50,
RunningMinimumDue = RunningMinimumDue + 16.91, RemainingMinimumDue = RemainingMinimumDue + 16.91, FirstDueDate = '2021-05-31 23:59:57',
DtOfLastDelinqCTD = '2021-06-30 23:59:57', DateOfOriginalPaymentDueDTD = '2021-06-30 23:59:57' WHERE acctId = 13566557

UPDATE TOP(1) CPSgmentCreditCard SET AmtOfPayCurrDue = AmtOfPayCurrDue - 11.50, AmtOfPayXDLate = AmtOfPayXDLate + 11.50 WHERE acctId = 38684709 -- BSAcctId = 13566557


UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue + 30.80, SystemStatus = 2 WHERE acctId = 15709599

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 0.5, RunningMinimumDue = RunningMinimumDue + 0.5, RemainingMinimumDue = RemainingMinimumDue + 0.5, 
SRBWithInstallmentDue = SRBWithInstallmentDue + 5.85, SBWithInstallmentDue = SBWithInstallmentDue + 5.85 WHERE acctId = 15709599

UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 130.05, AmtOfPayCurrDue = AmtOfPayCurrDue + 5.85,
SRBWithInstallmentDue = SRBWithInstallmentDue + 130.05, SBWithInstallmentDue = SBWithInstallmentDue + 130.05 WHERE acctId = 47264603 -- BSAcctId = 15709599

UPDATE TOP(1) CPSgmentCreditCard SET AmtOfPayCurrDue = AmtOfPayCurrDue - 0.5, AmountOfTotalDue = AmountOfTotalDue - 0.5, CycleDueDTD = 0 WHERE acctId = 47566268 -- BSAcctId = 15709599

UPDATE TOP(1) CPSgmentCreditCard SET AmtOfPayCurrDue = AmtOfPayCurrDue + 24.95 WHERE acctId = 47264604 -- BSAcctId = 15709599


*/