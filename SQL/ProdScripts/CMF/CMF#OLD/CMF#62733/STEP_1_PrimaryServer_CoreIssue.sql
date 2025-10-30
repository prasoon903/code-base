-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION
--COMMIT TRANSACTION
--ROLLBACK TRANSACTION



UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 233561
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 752147
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 1360200
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 1726040
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 2360536
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 2718307
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 8359208

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 233561
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 752147
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 1360200
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 1726040
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 2360536
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 2718307
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 8359208


UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 245631
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 1372620
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 1742270
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 2866297
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 10093378
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 20085366
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 44227062


UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 16.62 WHERE acctID = 2487496
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 45.79 WHERE acctID = 5639435
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 61.15 WHERE acctID = 17665285

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 16.62, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 16.62, RemainingMinimumDue = 16.62, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DateOfOriginalPaymentDueDTD = '2022-01-31 23:59:57', DtOfLastDelinqCTD = NULL, FirstDueDate = '2022-01-31 23:59:57'  WHERE acctID = 2487496
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 45.79, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 45.79, RemainingMinimumDue = 45.79, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DateOfOriginalPaymentDueDTD = '2022-01-31 23:59:57', DtOfLastDelinqCTD = NULL, FirstDueDate = '2022-01-31 23:59:57'  WHERE acctID = 5639435
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 61.15, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 61.15, RemainingMinimumDue = 61.15, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DateOfOriginalPaymentDueDTD = '2022-01-31 23:59:57', DtOfLastDelinqCTD = NULL, FirstDueDate = '2022-01-31 23:59:57'  WHERE acctID = 17665285


UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 13527593
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 2573536
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 53638128



UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = '0.00' WHERE AID = 2573536 AND ATID = 52 AND IdentityField = 4615962519

DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 2573536 AND ATID = 52 AND IdentityField = 4615792777
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 13527593 AND ATID = 52 AND IdentityField = 4616471609
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 53638128 AND ATID = 52 AND IdentityField = 4615303601


DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 752147 AND ATID = 51 AND IdentityField = 2681398117
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 1360200 AND ATID = 51 AND IdentityField = 2681397295
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 1726040 AND ATID = 51 AND IdentityField = 2681977710
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 2360536 AND ATID = 51 AND IdentityField = 2682975039
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 2718307 AND ATID = 51 AND IdentityField = 2682741550
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 8359208 AND ATID = 51 AND IdentityField = 2682061735
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 233561 AND ATID = 51 AND IdentityField = 2682681785


update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 45.79 where  acctid  =  71830030
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 62.45 where  acctid  =  68428639
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 16.25 where  acctid  =  54995367
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 20.30 where  acctid  =  67048554
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 31.20 where  acctid  =  19660219
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 39.95 where  acctid  =  46007155
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 43.66 where  acctid  =  45391990
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 171.86 where  acctid  =  68613972
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 24.95 where  acctid  =  48484215
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 38.30 where  acctid  =  52304517
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 147.54 where  acctid  =  69572912
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 11.20 where  acctid  =  59852832
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 82.00 where  acctid  =  68240236
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 1.86 where  acctid  =  51803972
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 8.20 where  acctid  =  51803973
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 297.31 where  acctid  =  50359598
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 4.83 where  acctid  =  69800130