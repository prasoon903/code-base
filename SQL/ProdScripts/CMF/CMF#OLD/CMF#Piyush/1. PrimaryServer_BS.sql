-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO


BEGIN TRANSACTION
--COMMIT TRANSACTION
-- ROLLBACK TRANSACTION

UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue + 2.99 WHERE acctId = 10079993

UPDATE Top(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 2.99,
RunningMinimumDue = RunningMinimumDue + 2.99, RemainingMinimumDue = RemainingMinimumDue + 2.99 WHERE acctId = 10079993

UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '103.19' WHERE AID = 10079993 AND ATID = 51 AND IdentityField = 2487159845


UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 466969
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 12975411
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 19355304
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 466969
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 12975411
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 19355304

UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 21093825
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 35411745
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 59811296

UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 14.17 WHERE acctID = 747025
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 193.16 WHERE acctID = 1677662
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 2.29 WHERE acctID = 2886096
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 29.12 WHERE acctID = 4525820
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 116.58 WHERE acctID = 13872549
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 4.04 WHERE acctID = 15944915
UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 34.54 WHERE acctID = 16905806

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 14.17, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 14.17, RemainingMinimumDue = 14.17, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DateOfOriginalPaymentDueDTD = '2021-12-31 23:59:57', DtOfLastDelinqCTD = NULL, FirstDueDate = '2021-12-31 23:59:57'  WHERE acctID = 747025
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 193.16, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 193.16, RemainingMinimumDue = 193.16, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DateOfOriginalPaymentDueDTD = '2021-12-31 23:59:57', DtOfLastDelinqCTD = NULL, FirstDueDate = '2021-12-31 23:59:57'  WHERE acctID = 1677662
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 2.29, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 2.29, RemainingMinimumDue = 2.29, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DateOfOriginalPaymentDueDTD = '2021-12-31 23:59:57', DtOfLastDelinqCTD = NULL, FirstDueDate = '2021-12-31 23:59:57'  WHERE acctID = 2886096
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 29.12, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 29.12, RemainingMinimumDue = 29.12, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DateOfOriginalPaymentDueDTD = '2021-12-31 23:59:57', DtOfLastDelinqCTD = NULL, FirstDueDate = '2021-12-31 23:59:57'  WHERE acctID = 4525820
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 116.58, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 116.58, RemainingMinimumDue = 116.58, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DateOfOriginalPaymentDueDTD = '2021-12-31 23:59:57', DtOfLastDelinqCTD = NULL, FirstDueDate = '2021-12-31 23:59:57'  WHERE acctID = 13872549
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 4.04, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 4.04, RemainingMinimumDue = 4.04, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DateOfOriginalPaymentDueDTD = '2021-12-31 23:59:57', DtOfLastDelinqCTD = NULL, FirstDueDate = '2021-12-31 23:59:57'  WHERE acctID = 15944915
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 34.54, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 34.54, RemainingMinimumDue = 34.54, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DateOfOriginalPaymentDueDTD = '2021-12-31 23:59:57', DtOfLastDelinqCTD = NULL, FirstDueDate = '2021-12-31 23:59:57'  WHERE acctID = 16905806

UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 1692652
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 6340708
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 12874141
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 38378407
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 51323749

UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 14.17, AmtOfPayCurrDue = 14.17 WHERE acctID = 759435
UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 2.29, AmtOfPayCurrDue = 2.29 WHERE acctID = 16195882
UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 4.04, AmtOfPayCurrDue = 4.04 WHERE acctID = 48251584


UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 1.26 WHERE acctID = 4250558
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 26.12, AmtOfPayXDLate = AmtOfPayXDLate - 24.86,  
RunningMinimumDue = RunningMinimumDue - 26.26, RemainingMinimumDue = RemainingMinimumDue - 26.26  WHERE acctID = 4250558



DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 1692652 AND ATID = 52 AND IdentityField = 4254053828
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 48251584 AND ATID = 52 AND IdentityField = 4273048414

UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = '0.00' WHERE AID = 6340708 AND ATID = 52 AND IdentityField = 4262494409
UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = '0.00' WHERE AID = 12874141 AND ATID = 52 AND IdentityField = 4275447694
UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = '0.00' WHERE AID = 35411745 AND ATID = 52 AND IdentityField = 4307515192
UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = '0.00' WHERE AID = 51323749 AND ATID = 52 AND IdentityField = 4289979279
UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = '0.00' WHERE AID = 59811296 AND ATID = 52 AND IdentityField = 4278262673

DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 59811296 AND ATID = 52 AND IdentityField = 4278262626
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 1692652 AND ATID = 52 AND IdentityField = 4254053829


UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '0.00' WHERE AID = 466969 AND ATID = 51 AND IdentityField = 2481555331
UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '197.09' WHERE AID = 1677662 AND ATID = 51 AND IdentityField = 2481891609
UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '29.90' WHERE AID = 4525820 AND ATID = 51 AND IdentityField = 2493404323
UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '0.00' WHERE AID = 12975411 AND ATID = 51 AND IdentityField = 2510592708
UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '0.00' WHERE AID = 19355304 AND ATID = 51 AND IdentityField = 2494884721

INSERT INTO CurrentBalanceAudit(tid,businessday,atid,aid,dename,oldvalue,newvalue) VALUES (52342021619, '2021-12-21 12:35:11', 51, 466969, 115, '1', '0')
INSERT INTO CurrentBalanceAudit(tid,businessday,atid,aid,dename,oldvalue,newvalue) VALUES (52717342876, '2021-12-28 19:18:49', 51, 12975411, 115, '1', '0')
INSERT INTO CurrentBalanceAudit(tid,businessday,atid,aid,dename,oldvalue,newvalue) VALUES (52378339754, '2021-12-24 14:15:49', 51, 19355304, 115, '1', '0')



update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 18.70 where  acctid  =  20668114
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 6.20 where  acctid  =  20668115
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 49.55 where  acctid  =  55639423
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 200.99 where  acctid  =  68272251
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 49.00 where  acctid  =  31079603
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 32.94 where  acctid  =  31661985
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 312.20 where  acctid  =  31661986
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 4.99 where  acctid  =  35320477
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 312.20 where  acctid  =  34578461
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 32.94 where  acctid  =  34578462
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 582.75 where  acctid  =  58483629
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 255.76 where  acctid  =  68268334
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 41.44 where  acctid  =  65958906
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 6.58 where  acctid  =  60949522
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 91.58 where  acctid  =  60949523
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 41.50 where  acctid  =  54809144
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 116.58 where  acctid  =  39460100
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 8.29 where  acctid  =  35536773
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 58.29 where  acctid  =  35536835
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 6.20 where  acctid  =  30517537
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 54.12 where  acctid  =  30517538
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 37.45 where  acctid  =  35433155
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 99.00 where  acctid  =  72649830
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 9.68 where  acctid  =  59434988
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 16.17 where  acctid  =  59434989
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 8.22 where  acctid  =  36331195
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 72.49 where  acctid  =  36331196
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 75.00 where  acctid  =  72383970
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 156.92 where  acctid  =  72384728
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 31.62 where  acctid  =  66719677
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 6.99 where  acctid  =  52268548
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 46.60 where  acctid  =  34633732
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 74.91 where  acctid  =  39341255
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 4.08 where  acctid  =  35459066
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 45.79 where  acctid  =  35491258
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 224.75 where  acctid  =  43219303
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 21.50 where  acctid  =  52971458
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 25.74 where  acctid  =  44184945
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 45.79 where  acctid  =  35905870
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 9.00 where  acctid  =  44664516
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 20.75 where  acctid  =  44007771
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 133.25 where  acctid  =  44007772
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 61.66 where  acctid  =  62030893
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 3.34 where  acctid  =  69305813
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 37.45 where  acctid  =  45397899
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 4.27 where  acctid  =  37118598
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 341.59 where  acctid  =  70840415
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 40.84 where  acctid  =  68473602
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 154.18 where  acctid  =  67601125
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 21.23 where  acctid  =  67335455
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 29.08 where  acctid  =  53388397
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 166.58 where  acctid  =  52810980
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 41.62 where  acctid  =  44459532
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 22.87 where  acctid  =  38673219
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 58.29 where  acctid  =  59591980
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 58.29 where  acctid  =  59591981
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 184.74 where  acctid  =  67092846
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 41.50 where  acctid  =  51611428
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 54.12 where  acctid  =  41629228
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 83.00 where  acctid  =  54828736
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 22.41 where  acctid  =  36173369
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 108.25 where  acctid  =  36173370
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 13.50 where  acctid  =  61193284
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 19.12 where  acctid  =  67236430
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 4.08 where  acctid  =  66727613
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 116.54 where  acctid  =  55257999
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 31.41 where  acctid  =  39001441
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 89.11 where  acctid  =  40407022
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 45.79 where  acctid  =  36065059
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 24.91 where  acctid  =  46917649
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 61.66 where  acctid  =  63742334
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 24.33 where  acctid  =  53417300
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 11.20 where  acctid  =  53417301
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 3.25 where  acctid  =  52938856
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 3.29 where  acctid  =  41561830
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 11.71 where  acctid  =  41561832
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 3.29 where  acctid  =  52783896
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 33.29 where  acctid  =  52783897
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 58.29 where  acctid  =  56853741
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 13.00 where  acctid  =  60984533
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 41.50 where  acctid  =  66423799
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 32.50 where  acctid  =  66467708
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 9.91 where  acctid  =  66475763
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 47.87 where  acctid  =  23455004
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 6.20 where  acctid  =  66469066
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 35.37 where  acctid  =  66469067
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 108.25 where  acctid  =  44968540
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 104.08 where  acctid  =  61206261
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 3.02 where  acctid  =  13273018
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 90.53 where  acctid  =  69572912
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 136.60 where  acctid  =  62378630
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 383.64 where  acctid  =  62438621
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 41.62 where  acctid  =  34536314
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 24.40 where  acctid  =  32965595
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 30.75 where  acctid  =  23215951
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 4.58 where  acctid  =  57774301
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 34.08 where  acctid  =  57774340
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 45.79 where  acctid  =  55036828
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 8.29 where  acctid  =  55036829
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 3.29 where  acctid  =  37291302
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 14.33 where  acctid  =  37291303
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 3.25 where  acctid  =  40431165
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 4.08 where  acctid  =  40438747
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 10.75 where  acctid  =  40438748
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 4.08 where  acctid  =  51510643
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 4.08 where  acctid  =  51514936
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 4.08 where  acctid  =  51377976
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 20.75 where  acctid  =  53805558
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 29.08 where  acctid  =  53418203
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 116.58 where  acctid  =  52808060
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 91.58 where  acctid  =  53416189
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 4.08 where  acctid  =  68303849
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 4.08 where  acctid  =  68303850
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 4.08 where  acctid  =  68305157
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 71.61 where  acctid  =  68370207
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 45.79 where  acctid  =  34541179
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 27.41 where  acctid  =  43728761
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 300.00 where  acctid  =  57889892
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 16.58 where  acctid  =  44194075
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 79.38 where  acctid  =  44194076
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 8.29 where  acctid  =  69891602
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 45.79 where  acctid  =  69891603
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 14.95 where  acctid  =  36130813
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 14.99 where  acctid  =  36136366
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 70.74 where  acctid  =  30562530
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 30.37 where  acctid  =  44469868
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 35.74 where  acctid  =  33126453
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 11.06 where  acctid  =  72145247
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 13.70 where  acctid  =  45223541
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 37.04 where  acctid  =  36178872
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 54.12 where  acctid  =  36868505
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 66.50 where  acctid  =  66262835
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 22.04 where  acctid  =  39990338
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 61.66 where  acctid  =  60474053
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 13.25 where  acctid  =  60474054
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 26.50 where  acctid  =  60514084
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 11.62 where  acctid  =  55650187
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 45.79 where  acctid  =  39362934
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 6.58 where  acctid  =  39431298
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 58.25 where  acctid  =  41814912
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 9.91 where  acctid  =  39958393
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 22.04 where  acctid  =  63750412
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 47.41 where  acctid  =  50401532
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 148.37 where  acctid  =  48472296
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 33.33 where  acctid  =  50327028
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 253.22 where  acctid  =  52777606
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 4.08 where  acctid  =  51409808
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 16.62 where  acctid  =  51448280
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 41.50 where  acctid  =  52316748
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 16.62 where  acctid  =  61214755
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 41.50 where  acctid  =  64606321
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 41.50 where  acctid  =  64606322
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 273.37 where  acctid  =  53759640
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 17.87 where  acctid  =  54922967
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 24.91 where  acctid  =  57123833
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 91.58 where  acctid  =  55376754
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 15.00 where  acctid  =  57100111
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 240.78 where  acctid  =  68207888
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 12.04 where  acctid  =  54935891
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 2.04 where  acctid  =  54935892
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 8.29 where  acctid  =  54993712
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 45.79 where  acctid  =  54993713
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 45.79 where  acctid  =  55022928
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 8.29 where  acctid  =  57512253
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 30.37 where  acctid  =  57512254
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 47.97 where  acctid  =  61221260
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 12.87 where  acctid  =  55612274
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 13.70 where  acctid  =  55626495
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 24.91 where  acctid  =  57719256
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 10.75 where  acctid  =  57731327
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 41.50 where  acctid  =  57076169
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 2.99 where  acctid  =  61336042
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 438.61 where  acctid  =  57942348
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 166.50 where  acctid  =  60973214
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 19.95 where  acctid  =  59096780
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 17.87 where  acctid  =  59096781
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 3.29 where  acctid  =  59096782
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 3.29 where  acctid  =  59108777
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 3.73 where  acctid  =  59613667
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 105.83 where  acctid  =  61007539
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 26.50 where  acctid  =  59875220
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 101.66 where  acctid  =  60671912
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 83.25 where  acctid  =  62839410
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 32.50 where  acctid  =  60976035
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 26.50 where  acctid  =  60976036
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 4.58 where  acctid  =  60976037
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 9.91 where  acctid  =  60982120
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 13.25 where  acctid  =  60982121
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 26.50 where  acctid  =  62253776
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 3.50 where  acctid  =  62253777
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 32.80 where  acctid  =  69540756
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 45.79 where  acctid  =  62627623
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 148.25 where  acctid  =  69569276
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 81.32 where  acctid  =  64990220
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 91.50 where  acctid  =  64990221
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 26.50 where  acctid  =  67086323
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 57.50 where  acctid  =  68363884
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 1.94 where  acctid  =  68637206
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 45.23 where  acctid  =  68364448
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 4.08 where  acctid  =  68232091
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 4.91 where  acctid  =  67611811
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 4.08 where  acctid  =  67667932
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 24.54 where  acctid  =  67909789
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 3.25 where  acctid  =  67374128
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 49.95 where  acctid  =  67224224
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 124.91 where  acctid  =  68093208
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 41.50 where  acctid  =  68093209
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 124.91 where  acctid  =  68093210
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 41.50 where  acctid  =  68093211
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 15.60 where  acctid  =  67192763
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 58.29 where  acctid  =  68358388
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 38.70 where  acctid  =  68360045
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 12.45 where  acctid  =  67325326
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 3.15 where  acctid  =  68619900
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 11.20 where  acctid  =  68614886
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 45.79 where  acctid  =  68614887
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 41.71 where  acctid  =  68890484
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 11.20 where  acctid  =  68894409
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 15.96 where  acctid  =  69554987


update  top(1) bsegmentcreditcard  set  manualinitialchargeoffreason  =  '2' where    acctid  =3396021
update  top(1) bsegmentcreditcard  set  manualinitialchargeoffreason  =  '2' where    acctid  =7703215
update  top(1) bsegmentcreditcard  set  manualinitialchargeoffreason  =  '2' where    acctid  =335941
update  top(1) bsegmentcreditcard  set  manualinitialchargeoffreason  =  '2' where    acctid  =401972
update  top(1) bsegmentcreditcard  set  manualinitialchargeoffreason  =  '2' where    acctid  =1315514
update  top(1) bsegmentcreditcard  set  manualinitialchargeoffreason  =  '2' where    acctid  =2631532
update  top(1) bsegmentcreditcard  set  manualinitialchargeoffreason  =  '6' where    acctid  =1221045
update  top(1) bsegmentcreditcard  set  manualinitialchargeoffreason  =  '3' where    acctid  =1892770
update  top(1) bsegmentcreditcard  set  manualinitialchargeoffreason  =  '2' where    acctid  =2141401
update  top(1) bsegmentcreditcard  set  manualinitialchargeoffreason  =  '2' where    acctid  =2658693
update  top(1) bsegmentcreditcard  set  manualinitialchargeoffreason  =  '2' where    acctid  =4361357
update  top(1) bsegmentcreditcard  set  manualinitialchargeoffreason  =  '3' where    acctid  =2451692
update  top(1) bsegmentcreditcard  set  manualinitialchargeoffreason  =  '6' where    acctid  =9865242
update  top(1) bsegmentcreditcard  set  manualinitialchargeoffreason  =  '2' where    acctid  =308103
update  top(1) bsegmentcreditcard  set  manualinitialchargeoffreason  =  '2' where    acctid  =1879320
update  top(1) bsegmentcreditcard  set  manualinitialchargeoffreason  =  '2' where    acctid  =1945492
update  top(1) bsegmentcreditcard  set  manualinitialchargeoffreason  =  '2' where    acctid  =2147419
update  top(1) bsegmentcreditcard  set  manualinitialchargeoffreason  =  '2' where    acctid  =2791470
update  top(1) bsegmentcreditcard  set  manualinitialchargeoffreason  =  '2' where    acctid  =7234000

update  top(1) bsegment_primary  set  tpyblob  =  null  ,tpynad = null , tpylad = null   where    acctid  =3396021
update  top(1) bsegment_primary  set  tpyblob  =  null  ,tpynad = null , tpylad = null   where    acctid  =7703215
update  top(1) bsegment_primary  set  tpyblob  =  null  ,tpynad = null , tpylad = null   where    acctid  =335941
update  top(1) bsegment_primary  set  tpyblob  =  null  ,tpynad = null , tpylad = null   where    acctid  =401972
update  top(1) bsegment_primary  set  tpyblob  =  null  ,tpynad = null , tpylad = null   where    acctid  =1315514
update  top(1) bsegment_primary  set  tpyblob  =  null  ,tpynad = null , tpylad = null   where    acctid  =2631532
update  top(1) bsegment_primary  set  tpyblob  =  null  ,tpynad = null , tpylad = null   where    acctid  =1221045
update  top(1) bsegment_primary  set  tpyblob  =  null  ,tpynad = null , tpylad = null   where    acctid  =1892770
update  top(1) bsegment_primary  set  tpyblob  =  null  ,tpynad = null , tpylad = null   where    acctid  =2141401
update  top(1) bsegment_primary  set  tpyblob  =  null  ,tpynad = null , tpylad = null   where    acctid  =2658693
update  top(1) bsegment_primary  set  tpyblob  =  null  ,tpynad = null , tpylad = null   where    acctid  =4361357
update  top(1) bsegment_primary  set  tpyblob  =  null  ,tpynad = null , tpylad = null   where    acctid  =2451692
update  top(1) bsegment_primary  set  tpyblob  =  null  ,tpynad = null , tpylad = null   where    acctid  =9865242
update  top(1) bsegment_primary  set  tpyblob  =  null  ,tpynad = null , tpylad = null   where    acctid  =308103
update  top(1) bsegment_primary  set  tpyblob  =  null  ,tpynad = null , tpylad = null   where    acctid  =1879320
update  top(1) bsegment_primary  set  tpyblob  =  null  ,tpynad = null , tpylad = null   where    acctid  =1945492
update  top(1) bsegment_primary  set  tpyblob  =  null  ,tpynad = null , tpylad = null   where    acctid  =2147419
update  top(1) bsegment_primary  set  tpyblob  =  null  ,tpynad = null , tpylad = null   where    acctid  =2791470
update  top(1) bsegment_primary  set  tpyblob  =  null  ,tpynad = null , tpylad = null   where    acctid  =7234000