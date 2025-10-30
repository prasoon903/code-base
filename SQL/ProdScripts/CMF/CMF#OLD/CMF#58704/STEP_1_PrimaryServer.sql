-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION
--COMMIT TRANSACTION
--ROLLBACK TRANSACTION

-- UPDATE WILL BE 1 ROW EACH STATEMENT

UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 1.18, AmtofPayCurrDue = AmtofPayCurrDue - 1.18, CycleDueDTD = 0 WHERE acctId = 15847260 --BS: 4733586

INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(48317350466, '2021-10-22 10:54:06.000', 52, 15847260, 115, '1', '0'),
(48317350466, '2021-10-22 10:54:06.000', 52, 15847260, 200, '1.18', '0.00')



UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 24.89, AmtofPayCurrDue = AmtofPayCurrDue - 24.89, CycleDueDTD = 0 WHERE acctId = 15347 --BS: 12887

INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(48317793737, '2021-10-22 12:21:43.000', 52, 15347, 115, '1', '0'),
(48317793737, '2021-10-22 12:21:43.000', 52, 15347, 200, '24.89', '0.00')




UPDATE TOP(1) BSegment_Primary SET AmtofPayCurrDue = AmtofPayCurrDue + 1.77 WHERE acctId = 3783604

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 1.77, RemainingMinimumDue = RemainingMinimumDue + 1.77,
RunningMinimumDue = RunningMinimumDue + 1.77 WHERE acctId = 3783604

UPDATE TOP(1) CurrentBalanceAudit SET Newvalue = '184.88' WHERE AID = 3783604 AND ATID = 51 AND IdentityField = 2155254349





UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 24.40, AmtofPayCurrDue = AmtofPayCurrDue - 24.40, CycleDueDTD = 0 WHERE acctId = 12992 --BS: 10772

INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(48400290947, '2021-10-23 11:26:57.000', 52, 12992, 115, '1', '0'),
(48400290947, '2021-10-23 11:26:57.000', 52, 12992, 200, '24.40', '0.00')



UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 24.71, AmtofPayCurrDue = AmtofPayCurrDue - 24.71, CycleDueDTD = 0 WHERE acctId = 297068 --BS: 284978

INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(48317792719, '2021-10-22 12:22:36.000', 52, 297068, 115, '1', '0'),
(48317792719, '2021-10-22 12:22:36.000', 52, 297068, 200, '24.71', '0.00')


UPDATE TOP(1) BSegment_Primary SET AmtofPayCurrDue = AmtofPayCurrDue + 45.51, CycleDueDTD = 1 WHERE acctId = 3748505

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 45.51, RemainingMinimumDue = RemainingMinimumDue + 45.51,
RunningMinimumDue = RunningMinimumDue + 45.51 WHERE acctId = 3748505

DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 3748505 AND ATID = 51 AND IdentityField = 2157615799
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 3748505 AND ATID = 51 AND IdentityField = 2157615798



UPDATE TOP(1) BSegment_Primary SET AmtofPayCurrDue = AmtofPayCurrDue + 20.79, CycleDueDTD = 1 WHERE acctId = 2259429

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 20.79, RemainingMinimumDue = RemainingMinimumDue + 20.79,
RunningMinimumDue = RunningMinimumDue + 20.79 WHERE acctId = 2259429

DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 2259429 AND ATID = 51 AND IdentityField = 2157799552
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 2259429 AND ATID = 51 AND IdentityField = 2157799553



UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 0.24, AmtofPayCurrDue = AmtofPayCurrDue - 0.24, CycleDueDTD = 0 WHERE acctId = 20632852 --BS: 4640763

INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(48271780674, '2021-10-20 11:18:24.000', 52, 20632852, 115, '1', '0'),
(48271780674, '2021-10-20 11:18:24.000', 52, 20632852, 200, '0.24', '0.00')



UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 21.78, AmtofPayCurrDue = AmtofPayCurrDue - 21.78, CycleDueDTD = 0 WHERE acctId = 1922110 --BS: 275808

INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(48317700848, '2021-10-22 12:22:33.000', 52, 1922110, 115, '1', '0'),
(48317700848, '2021-10-22 12:22:33.000', 52, 1922110, 200, '21.78', '0.00')



UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtofPayCurrDue = AmtofPayCurrDue - 22.34 WHERE acctId = 4337624

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 22.34, RemainingMinimumDue = RemainingMinimumDue - 22.34, RunningMinimumDue = RunningMinimumDue - 22.34,
DateOfOriginalPaymentDueDTD = NULL, FirstDueDate = NULL WHERE acctId = 4337624


INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(48314014635, '2021-10-22 06:45:20.000', 51, 4337624, 115, '1', '0'),
(48314014635, '2021-10-22 06:45:20.000', 51, 4337624, 200, '21.78', '0.00')



UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 24.50, AmtofPayCurrDue = AmtofPayCurrDue - 24.50, CycleDueDTD = 0 WHERE acctId = 12847 --BS: 10667

INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(48499494423, '2021-10-25 12:01:44.000', 52, 12847, 115, '1', '0'),
(48499494423, '2021-10-25 12:01:44.000', 52, 12847, 200, '24.50', '0.00')




update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 3.29 where  acctid  =  20524096
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 6.20 where  acctid  =  36191248
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 58.29 where  acctid  =  36191249
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 45.35 where  acctid  =  62836204
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 26.50 where  acctid  =  62836205
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 98.61 where  acctid  =  37966501
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 1.89 where  acctid  =  57948381
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 47.00 where  acctid  =  54486774
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 8.29 where  acctid  =  35535097
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 113.66 where  acctid  =  58206187
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 91.50 where  acctid  =  47971631
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 45.98 where  acctid  =  44242282
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 11.20 where  acctid  =  35952158
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 41.50 where  acctid  =  57471973
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 170.00 where  acctid  =  57518539
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 76.08 where  acctid  =  67207713
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 107.81 where  acctid  =  36180531
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 278.37 where  acctid  =  36180819
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 8.29 where  acctid  =  46927852
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 31.62 where  acctid  =  46928138
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 73.88 where  acctid  =  30529982
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 17.87 where  acctid  =  34730492
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 49.95 where  acctid  =  42101439
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 37.45 where  acctid  =  30499268
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 2799.00 where  acctid  =  61212468
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 67.31 where  acctid  =  42401744
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 61.38 where  acctid  =  42401745
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 10.75 where  acctid  =  41564888
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 92.41 where  acctid  =  41564889
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 40.03 where  acctid  =  23228213
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 16.62 where  acctid  =  21273792
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 26.50 where  acctid  =  58795779
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 76.66 where  acctid  =  59104955
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 80.00 where  acctid  =  59101108
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 116.58 where  acctid  =  51451372
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 45.92 where  acctid  =  44222385
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 54.21 where  acctid  =  42745068
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 8.29 where  acctid  =  42745070
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 91.50 where  acctid  =  47214893
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 8.20 where  acctid  =  37979368
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 6.50 where  acctid  =  37979369
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 408.25 where  acctid  =  34079178
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 31.58 where  acctid  =  34079179
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 17.87 where  acctid  =  59113616
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 60.23 where  acctid  =  62276896
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 26.50 where  acctid  =  62276897
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 41.50 where  acctid  =  62320924
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 61.66 where  acctid  =  62320925
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 45.79 where  acctid  =  52825160
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 41.50 where  acctid  =  53811764
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 813.94 where  acctid  =  51407522
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 49.95 where  acctid  =  35475542
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 4.91 where  acctid  =  36879727
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 83.25 where  acctid  =  30640473
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 24.17 where  acctid  =  45320384
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 207.50 where  acctid  =  45320385
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 4.08 where  acctid  =  41630665
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 4.08 where  acctid  =  41630666
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 4.91 where  acctid  =  41887784
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 24.95 where  acctid  =  33710487
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 25.00 where  acctid  =  44438608
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 9.54 where  acctid  =  51455273
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 3.29 where  acctid  =  51455274
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 17.87 where  acctid  =  44457854
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 26.50 where  acctid  =  63688333
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 38.11 where  acctid  =  40520377
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 6.59 where  acctid  =  34664463
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 20.79 where  acctid  =  50088072
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 9.95 where  acctid  =  62634491
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 71.58 where  acctid  =  43270770
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 45.79 where  acctid  =  34714565
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 8.25 where  acctid  =  53736475
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 45.79 where  acctid  =  42716503
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 60.37 where  acctid  =  13286882
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 24.91 where  acctid  =  43219535
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 24.91 where  acctid  =  53960321
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 24.91 where  acctid  =  54986161
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 141.58 where  acctid  =  54986162
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 4.08 where  acctid  =  32628467
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 4.08 where  acctid  =  40177468
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 4.08 where  acctid  =  41866867
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 41.62 where  acctid  =  10444479
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 12.45 where  acctid  =  10444480
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 41.62 where  acctid  =  10444488
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 12.45 where  acctid  =  10444489
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 44.92 where  acctid  =  66437282
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 58.29 where  acctid  =  35444002
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 22.87 where  acctid  =  42362449
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 20.79 where  acctid  =  44159149
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 62.41 where  acctid  =  52929885
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 49.95 where  acctid  =  36889907
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 41.50 where  acctid  =  57785816
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 21.20 where  acctid  =  36856991
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 177.41 where  acctid  =  36440550
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 58.07 where  acctid  =  12711493
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 129.35 where  acctid  =  12711494
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 38.33 where  acctid  =  66803324
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 53.90 where  acctid  =  42706475
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 58.29 where  acctid  =  46622862
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 18.70 where  acctid  =  45415631
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 20.79 where  acctid  =  54461770
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 342.50 where  acctid  =  42125368
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 37.41 where  acctid  =  54807992
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 45.79 where  acctid  =  45450129
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 12.87 where  acctid  =  50330292
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 105.73 where  acctid  =  19666053
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 62.21 where  acctid  =  19666054
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 4.62 where  acctid  =  29058307
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 26.74 where  acctid  =  29058308
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 158.25 where  acctid  =  45943382
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 31.20 where  acctid  =  45991453
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 58.25 where  acctid  =  54808599
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 91.50 where  acctid  =  47955521
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 208.25 where  acctid  =  59617996
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 48.04 where  acctid  =  63304751
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 14.12 where  acctid  =  52884459
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 101.33 where  acctid  =  20241318
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 119.82 where  acctid  =  62266210
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 11.20 where  acctid  =  62266211
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 4.91 where  acctid  =  62266212
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 41.62 where  acctid  =  35342733
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 17.80 where  acctid  =  31072906
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 17.80 where  acctid  =  31072907
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 103.62 where  acctid  =  52603856
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 10.75 where  acctid  =  46871698
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 24.91 where  acctid  =  30550504
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 54.08 where  acctid  =  30550505
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 83.25 where  acctid  =  35356501
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 79.75 where  acctid  =  45979591
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 35.75 where  acctid  =  29895189
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 17.87 where  acctid  =  30688190
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 8.29 where  acctid  =  39386350
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 6.62 where  acctid  =  31084025
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 49.16 where  acctid  =  34452585
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 49.95 where  acctid  =  35536239
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 0.08 where  acctid  =  32624293
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 21.93 where  acctid  =  32624296
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 9.90 where  acctid  =  38558908
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 49.91 where  acctid  =  36001635
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 55.29 where  acctid  =  35936748
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 4.08 where  acctid  =  36111425
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 3.25 where  acctid  =  37068056
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 26.23 where  acctid  =  35265853
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 100.00 where  acctid  =  45447470
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 4.08 where  acctid  =  53661466
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 4.08 where  acctid  =  53661467
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 3.29 where  acctid  =  36133469
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 31.20 where  acctid  =  36055133
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 20.79 where  acctid  =  47233789
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 125.75 where  acctid  =  52462613
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 4.83 where  acctid  =  50059968
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 41.50 where  acctid  =  50059969
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 74.91 where  acctid  =  46622291
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 42.38 where  acctid  =  63751876
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 62.08 where  acctid  =  39201580
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 429.00 where  acctid  =  59080878
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 59.15 where  acctid  =  59531573
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 271.86 where  acctid  =  50362116
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 33.00 where  acctid  =  50926522
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 22.04 where  acctid  =  50926652
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 9.91 where  acctid  =  59111032
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 145.00 where  acctid  =  58888101
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 26.50 where  acctid  =  57219495
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 20.79 where  acctid  =  52785170
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 74.91 where  acctid  =  53389363
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 8.25 where  acctid  =  46664340
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 74.91 where  acctid  =  46664341
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 17.87 where  acctid  =  46929428
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 27.41 where  acctid  =  51826393
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 41.50 where  acctid  =  54076194
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 4.08 where  acctid  =  50344440
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 4.91 where  acctid  =  50344441
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 3.25 where  acctid  =  50344442
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 45.79 where  acctid  =  60969505
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 3.25 where  acctid  =  60969506
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 11.20 where  acctid  =  60969507
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 33.16 where  acctid  =  60969508
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 2.99 where  acctid  =  52285977
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 91.58 where  acctid  =  52932076
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 24.91 where  acctid  =  52147248
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 2014.19 where  acctid  =  57890469
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 114.91 where  acctid  =  51624121
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 74.18 where  acctid  =  54997370
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 8.25 where  acctid  =  54997531
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 103.33 where  acctid  =  54997532
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 8.25 where  acctid  =  54997533
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 4.08 where  acctid  =  64871480
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 83.00 where  acctid  =  53797196
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 28.79 where  acctid  =  52985205
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 11.20 where  acctid  =  52985206
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 10.75 where  acctid  =  55295086
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 84.91 where  acctid  =  55295087
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 17.87 where  acctid  =  52894448
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 45.79 where  acctid  =  53379776
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 274.50 where  acctid  =  55014742
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 31.58 where  acctid  =  55014743
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 33.29 where  acctid  =  58203972
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 34.07 where  acctid  =  57422007
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 33.16 where  acctid  =  54352165
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 15.95 where  acctid  =  62255674
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 4.08 where  acctid  =  54844351
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 6.72 where  acctid  =  54844352
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 5.98 where  acctid  =  54875627
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 10.00 where  acctid  =  57417543
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 116.58 where  acctid  =  63755249
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 12.41 where  acctid  =  63755250
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 12.40 where  acctid  =  59565659
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 69.08 where  acctid  =  59565660
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 2.99 where  acctid  =  60956689
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 83.25 where  acctid  =  63284522
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 6.20 where  acctid  =  60505876
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 30.11 where  acctid  =  60505877
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 40.84 where  acctid  =  60505878
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 19.78 where  acctid  =  59855627
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 105.54 where  acctid  =  62645759
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 29.53 where  acctid  =  60834763
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 13.70 where  acctid  =  60974558
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 28.33 where  acctid  =  62330987
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 2.04 where  acctid  =  62330989
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 91.58 where  acctid  =  64040273
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 26.50 where  acctid  =  62278230
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 61.66 where  acctid  =  62278231
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 13.25 where  acctid  =  62278232
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 8.29 where  acctid  =  62599827
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 45.79 where  acctid  =  62599828
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 41.50 where  acctid  =  62856985
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 10.75 where  acctid  =  64064290
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 45.00 where  acctid  =  63306206
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 97.92 where  acctid  =  63735528
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 799.00 where  acctid  =  67230274
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 13.25 where  acctid  =  63748118
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 61.66 where  acctid  =  63748119
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 26.50 where  acctid  =  63748120