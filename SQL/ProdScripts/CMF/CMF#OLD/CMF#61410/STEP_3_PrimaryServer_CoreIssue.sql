-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION
--COMMIT TRANSACTION
--ROLLBACK TRANSACTION

UPDATE TOP(1) BSegmentCreditcard SET DateOfOriginalPaymentDueDTD = '2021-09-30 23:59:57.000', DtOfLastDelinqCTD = '2021-09-30 23:59:57.000',
NoPayDaysDelinquent = 0, DaysDelinquent = 0 WHERE acctId = 13278153

UPDATE TOP(1) DelinquencyFreezeCycle SET DateOfOriginalPaymentDueDTD = '2021-07-31 23:59:57.000' WHERE acctId = 13278153 AND StatementDate = '2021-08-31 23:59:57.000'
UPDATE TOP(1) DelinquencyFreezeCycle SET DateOfOriginalPaymentDueDTD = '2021-09-30 23:59:57.000' WHERE acctId = 13278153 AND StatementDate = '2021-10-31 23:59:57.000'
UPDATE TOP(1) DelinquencyFreezeCycle SET DateOfOriginalPaymentDueDTD = '2021-09-30 23:59:57.000' WHERE acctId = 13278153 AND StatementDate = '2021-11-30 23:59:57.000'

UPDATE TOP(1) BSegmentCreditCard SET ManualInitialChargeOffReason  =  '2' WHERE acctId  =1986525
UPDATE TOP(1) BSegment_Primary SET tpyblob  =  NULL, tpynad = NULL, tpylad = NULL WHERE acctId  =1986525


UPDATE TOP(1) CPSgmentCreditCard SET AmtOfpayCurrDue = 2287.76, AmountOfTotalDue = 2550.65 WHERE acctId = 2912355

UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0 WHERE acctId = 30307575
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0 WHERE acctId = 34721815
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0 WHERE acctId = 34721816
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0 WHERE acctId = 34727186
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0 WHERE acctId = 34727187
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0 WHERE acctId = 35190044
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0 WHERE acctId = 42264310

UPDATE TOP(3) BSegmentCreditCard SET ActivityCodePayment = 1 WHERE acctId IN (1753890,1767305,2788428)

UPDATE TOP(3) BSegment_Primary SET tpyblob  =  NULL, tpynad = NULL, tpylad = NULL WHERE acctId IN (1753890,1767305,2788428)


SELECT ActivityCode FROM BSegment_Primary WITH (NOLOCK) WHERE acctId = 2788428
SELECT ActivityCodePayment FROM BSegmentCreditCard WITH (NOLOCK) WHERE acctId = 2788428

UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 3483141

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, 
RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, 
DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 3483141

UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 4181291

UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 60.32 WHERE acctID = 849252
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 408.65 WHERE acctID = 21515305

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 60.32, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 60.32, RemainingMinimumDue = 60.32, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DateOfOriginalPaymentDueDTD = '2021-12-31 23:59:57', DtOfLastDelinqCTD = NULL, FirstDueDate = '2021-12-31 23:59:57'  WHERE acctID = 849252
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 408.65, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 408.65, RemainingMinimumDue = 408.65, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DateOfOriginalPaymentDueDTD = '2021-12-31 23:59:57', DtOfLastDelinqCTD = NULL, FirstDueDate = '2021-12-31 23:59:57'  WHERE acctID = 21515305

UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 68074655
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 3376606



UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = '0.00' WHERE AID = 3376606 AND ATID = 52 AND IdentityField = 4324210595



update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 41.50 where  acctid  =  66428212
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 241.21 where  acctid  =  30522730
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 91.50 where  acctid  =  51029779
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 33.16 where  acctid  =  57540936
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 49.95 where  acctid  =  35514297
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 89.91 where  acctid  =  39990173
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 49.95 where  acctid  =  44810333
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 70.41 where  acctid  =  60933677
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 29.12 where  acctid  =  66965081
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 430.30 where  acctid  =  72152077
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 819.00 where  acctid  =  68094587
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 30.37 where  acctid  =  44469868
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 18.84 where  acctid  =  69566180
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 4.08 where  acctid  =  68232091
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 45.23 where  acctid  =  68364448


