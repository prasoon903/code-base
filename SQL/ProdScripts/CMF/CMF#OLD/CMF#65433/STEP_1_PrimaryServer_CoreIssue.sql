-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION
--COMMIT TRANSACTION
--ROLLBACK TRANSACTION

UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 2.99 WHERE acctID = 12441854
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 2.99,  RunningMinimumDue = 2.99, RemainingMinimumDue = 2.99  WHERE acctID = 12441854

/*
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 78258358
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 78655585
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 78653773
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 78310331
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 77961318
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 77736459
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 77727305
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 70069897
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 74976457
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 76267202
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 78931905
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 76146820
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 76144711
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 76132953
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 74152289
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 73453271
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 73419237
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 72883293
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 72876872
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 72867104
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 72324920
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 72145274
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 71728793
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 70779731
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 70334027
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 73497513
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 77963464
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 76719148
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 76717148
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 79851923
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 79649524
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 79310036
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 72426230
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 72057438
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 72028219
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 67961144
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 72017838
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 71474075
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 68058433
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 67974547
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 66486304
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 66482314
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 74689642
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 74677530
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 74675725
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 73245220
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 72051981
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 72036217
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 66147123
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 66109192
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 68058106
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 65706002
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 65358303
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 67950630
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 67500553
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 66889611
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 65297524
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 78273152
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 78651448
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 77165801
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 71946980
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 66518545
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 75564066
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 74950869
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 76281165
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 76176722
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 74454290
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 74203459
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 71331153
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 70787660
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 70673486
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 70236022
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 69482707
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 69398486
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 69338187
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 69079569
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 69061462
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 66500314
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 79175421
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 79158964
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 77679513
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 71994798
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 71810851
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 71543673
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 71155484
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 70695457
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 70324218
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 66942935
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 68265301
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 65977629
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 69380361
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 69380360
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 67555019
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 65129704
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 75105241
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 70729888
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 68659336
UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 67948788


UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 57444
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 2626437

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,   RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,    DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL   WHERE acctID = 57444
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,   RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,    DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL   WHERE acctID = 2626437

UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 79254050
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 11721
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 51066
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 179008

UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 0.50 WHERE acctID = 16566388
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0.50, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,   RunningMinimumDue = 0.50, RemainingMinimumDue = 0.50, DaysDelinquent = 0, NoPayDaysDelinquent = 0,    DateOfOriginalPaymentDueDTD = '2022-03-31 23:59:57', DtOfLastDelinqCTD = NULL, FirstDueDate = '2022-03-31 23:59:57'   WHERE acctID = 16566388






--SRB
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 1999560
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 1999560

UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 2029790

UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 49.95 WHERE acctID = 224496
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 17.87 WHERE acctID = 936191
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 99.39 WHERE acctID = 1714669
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 16.08 WHERE acctID = 1862100
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 22.04 WHERE acctID = 2956494
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 19.91 WHERE acctID = 3586612
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 29.47 WHERE acctID = 9045958
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0.00 WHERE acctID = 11846168
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 321.64 WHERE acctID = 11944216
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 99.76 WHERE acctID = 12441854
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 358.25 WHERE acctID = 12979161
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 36.12 WHERE acctID = 12998663
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 5.78 WHERE acctID = 18260525
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 119.82 WHERE acctID = 21133168
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 71.12 WHERE acctID = 21592909


UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 49.95, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 49.95, RemainingMinimumDue = 49.95, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DateOfOriginalPaymentDueDTD = '2022-03-31 23:59:57', DtOfLastDelinqCTD = NULL, FirstDueDate = '2022-03-31 23:59:57'   WHERE acctID = 224496
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 17.87, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 17.87, RemainingMinimumDue = 17.87, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DateOfOriginalPaymentDueDTD = '2022-03-31 23:59:57', DtOfLastDelinqCTD = NULL, FirstDueDate = '2022-03-31 23:59:57'   WHERE acctID = 936191
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 99.39, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 99.39, RemainingMinimumDue = 99.39, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DateOfOriginalPaymentDueDTD = '2022-03-31 23:59:57', DtOfLastDelinqCTD = NULL, FirstDueDate = '2022-03-31 23:59:57'   WHERE acctID = 1714669
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 16.08, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 16.08, RemainingMinimumDue = 16.08, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DateOfOriginalPaymentDueDTD = '2022-03-31 23:59:57', DtOfLastDelinqCTD = NULL, FirstDueDate = '2022-03-31 23:59:57'   WHERE acctID = 1862100
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 22.04, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 22.04, RemainingMinimumDue = 22.04, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DateOfOriginalPaymentDueDTD = '2022-03-31 23:59:57', DtOfLastDelinqCTD = NULL, FirstDueDate = '2022-03-31 23:59:57'   WHERE acctID = 2956494
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 19.91, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 19.91, RemainingMinimumDue = 19.91, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DateOfOriginalPaymentDueDTD = '2022-03-31 23:59:57', DtOfLastDelinqCTD = NULL, FirstDueDate = '2022-03-31 23:59:57'   WHERE acctID = 3586612
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 29.47, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 29.47, RemainingMinimumDue = 29.47, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DateOfOriginalPaymentDueDTD = '2022-03-31 23:59:57', DtOfLastDelinqCTD = NULL, FirstDueDate = '2022-03-31 23:59:57'   WHERE acctID = 9045958
--UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 42.82, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 42.82, RemainingMinimumDue = 42.82, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DateOfOriginalPaymentDueDTD = '2022-03-31 23:59:57', DtOfLastDelinqCTD = NULL, FirstDueDate = '2022-03-31 23:59:57'   WHERE acctID = 11846168
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 11846168
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 321.64, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 321.64, RemainingMinimumDue = 321.64, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DateOfOriginalPaymentDueDTD = '2022-03-31 23:59:57', DtOfLastDelinqCTD = NULL, FirstDueDate = '2022-03-31 23:59:57'   WHERE acctID = 11944216
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 99.76, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 99.76, RemainingMinimumDue = 99.76, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DateOfOriginalPaymentDueDTD = '2022-03-31 23:59:57', DtOfLastDelinqCTD = NULL, FirstDueDate = '2022-03-31 23:59:57'   WHERE acctID = 12441854
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 358.25, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 358.25, RemainingMinimumDue = 358.25, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DateOfOriginalPaymentDueDTD = '2022-03-31 23:59:57', DtOfLastDelinqCTD = NULL, FirstDueDate = '2022-03-31 23:59:57'   WHERE acctID = 12979161
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 36.12, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 36.12, RemainingMinimumDue = 36.12, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DateOfOriginalPaymentDueDTD = '2022-03-31 23:59:57', DtOfLastDelinqCTD = NULL, FirstDueDate = '2022-03-31 23:59:57'   WHERE acctID = 12998663
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 5.78, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 5.78, RemainingMinimumDue = 5.78, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DateOfOriginalPaymentDueDTD = '2022-03-31 23:59:57', DtOfLastDelinqCTD = NULL, FirstDueDate = '2022-03-31 23:59:57'   WHERE acctID = 18260525
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 119.82, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 119.82, RemainingMinimumDue = 119.82, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DateOfOriginalPaymentDueDTD = '2022-03-31 23:59:57', DtOfLastDelinqCTD = NULL, FirstDueDate = '2022-03-31 23:59:57'   WHERE acctID = 21133168
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 71.12, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 71.12, RemainingMinimumDue = 71.12, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DateOfOriginalPaymentDueDTD = '2022-03-31 23:59:57', DtOfLastDelinqCTD = NULL, FirstDueDate = '2022-03-31 23:59:57'   WHERE acctID = 21592909

UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 42081153
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 23524629
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 78045220
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 79140963
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 32576060
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 33567805
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 35417671
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 39087913
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 35565256
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 79254043
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 236566
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 948611
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 78778943

UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 5.16, AmtOfPayCurrDue = 5.16 WHERE acctID = 56077192
UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 3.84, AmtOfPayCurrDue = 3.84 WHERE acctID = 71476247
UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 16.08, AmtOfPayCurrDue = 16.08 WHERE acctID = 1882880


UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '0.00' WHERE AID = 57444 AND ATID = 51 AND IdentityField = 2934446379
UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '0.00' WHERE AID = 2626437 AND ATID = 51 AND IdentityField = 2934870330
UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '0.50' WHERE AID = 16566388 AND ATID = 51 AND IdentityField = 2955099841

INSERT INTO CurrentBalanceAudit(tid,businessday,atid,aid,dename,oldvalue,newvalue) VALUES (57923556043, '2022-03-19 06:08:34', 51, 57444, 115, '1', '0')
INSERT INTO CurrentBalanceAudit(tid,businessday,atid,aid,dename,oldvalue,newvalue) VALUES (57922814470, '2022-03-19 06:54:40', 51, 2626437, 115, '1', '0')

INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)     VALUES (57884714986, '2022-03-18 08:57:17', 52, 51066, 200, '3.04', '0.00')
INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)     VALUES (58327985705, '2022-03-27 05:57:37', 52, 11721, 200, '24.41', '0.00')
INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)     VALUES (58018658183, '2022-03-21 07:48:08', 52, 179008, 200, '24.73', '0.00')

INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)     VALUES (57884714986, '2022-03-18 08:57:17', 52, 51066, 115, '1', '0')
INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)     VALUES (58327985705, '2022-03-27 05:57:37', 52, 11721, 115, '1', '0')
INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)     VALUES (58018658183, '2022-03-21 07:48:08', 52, 179008, 115, '1', '0')

DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 236566 AND ATID = 52 AND IdentityField = 5105209243
UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = '0.00' WHERE AID = 948611 AND ATID = 52 AND IdentityField = 5096369450
UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = '0.00' WHERE AID = 2029790 AND ATID = 52 AND IdentityField = 5089941902
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 34530383 AND ATID = 52 AND IdentityField = 5122997390
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 34530384 AND ATID = 52 AND IdentityField = 5122997396
UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = '0.00' WHERE AID = 35565256 AND ATID = 52 AND IdentityField = 4926394250
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 56077192 AND ATID = 52 AND IdentityField = 5078524782


UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '107.79' WHERE AID = 1714669 AND ATID = 51 AND IdentityField = 2946153701
UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '0.00' WHERE AID = 1999560 AND ATID = 51 AND IdentityField = 2951255163
UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '28.08' WHERE AID = 3586612 AND ATID = 51 AND IdentityField = 2944118783
UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '29.97' WHERE AID = 9045958 AND ATID = 51 AND IdentityField = 2959033331
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 11846168 AND ATID = 51 AND IdentityField = 2969076909
UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '323.68' WHERE AID = 11944216 AND ATID = 51 AND IdentityField = 2921615190
UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '71.18' WHERE AID = 21592909 AND ATID = 51 AND IdentityField = 2925196517
INSERT INTO CurrentBalanceAudit(tid,businessday,atid,aid,dename,oldvalue,newvalue) VALUES (57305000286, '2022-03-23 19:32:32', 51, 1999560, 115, '1', '0')

*/