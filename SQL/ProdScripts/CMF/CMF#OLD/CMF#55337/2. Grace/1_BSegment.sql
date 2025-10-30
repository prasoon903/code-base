-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION
--COMMIT TRANSACTION
--ROLLBACK TRANSACTION

-- 4 rows
UPDATE TOP(4) LogArTxnAddl SET ExcludeFlag = 1 WHERE TranID IN (43933975832,43935434687,43948915511,43948805908)

-- 74 rows

UPDATE TOP(1) BSegmentCreditCard SET AccountGraceStatus = 'T' WHERE acctId = 115284
UPDATE TOP(1) BSegmentCreditCard SET AccountGraceStatus = 'T' WHERE acctId = 245235
UPDATE TOP(1) BSegmentCreditCard SET AccountGraceStatus = 'T' WHERE acctId = 323788
UPDATE TOP(1) BSegmentCreditCard SET AccountGraceStatus = 'T' WHERE acctId = 333415
UPDATE TOP(1) BSegmentCreditCard SET AccountGraceStatus = 'T' WHERE acctId = 335646
UPDATE TOP(1) BSegmentCreditCard SET AccountGraceStatus = 'T' WHERE acctId = 565270
UPDATE TOP(1) BSegmentCreditCard SET AccountGraceStatus = 'T' WHERE acctId = 607293
UPDATE TOP(1) BSegmentCreditCard SET AccountGraceStatus = 'T' WHERE acctId = 862528
UPDATE TOP(1) BSegmentCreditCard SET AccountGraceStatus = 'T' WHERE acctId = 1052295
UPDATE TOP(1) BSegmentCreditCard SET AccountGraceStatus = 'T' WHERE acctId = 1061486
UPDATE TOP(1) BSegmentCreditCard SET AccountGraceStatus = 'T' WHERE acctId = 1103400
UPDATE TOP(1) BSegmentCreditCard SET AccountGraceStatus = 'T' WHERE acctId = 1189643
UPDATE TOP(1) BSegmentCreditCard SET AccountGraceStatus = 'T' WHERE acctId = 1190456
UPDATE TOP(1) BSegmentCreditCard SET AccountGraceStatus = 'T' WHERE acctId = 1206202
UPDATE TOP(1) BSegmentCreditCard SET AccountGraceStatus = 'T' WHERE acctId = 1213965
UPDATE TOP(1) BSegmentCreditCard SET AccountGraceStatus = 'T' WHERE acctId = 1217410
UPDATE TOP(1) BSegmentCreditCard SET AccountGraceStatus = 'T' WHERE acctId = 1353291
UPDATE TOP(1) BSegmentCreditCard SET AccountGraceStatus = 'T' WHERE acctId = 1420839
UPDATE TOP(1) BSegmentCreditCard SET AccountGraceStatus = 'T' WHERE acctId = 1491614
UPDATE TOP(1) BSegmentCreditCard SET AccountGraceStatus = 'T' WHERE acctId = 1626346
UPDATE TOP(1) BSegmentCreditCard SET AccountGraceStatus = 'T' WHERE acctId = 1658581
UPDATE TOP(1) BSegmentCreditCard SET AccountGraceStatus = 'T' WHERE acctId = 1924420
UPDATE TOP(1) BSegmentCreditCard SET AccountGraceStatus = 'T' WHERE acctId = 1980593
UPDATE TOP(1) BSegmentCreditCard SET AccountGraceStatus = 'T' WHERE acctId = 2051747
UPDATE TOP(1) BSegmentCreditCard SET AccountGraceStatus = 'T' WHERE acctId = 2362917
UPDATE TOP(1) BSegmentCreditCard SET AccountGraceStatus = 'T' WHERE acctId = 2414483
UPDATE TOP(1) BSegmentCreditCard SET AccountGraceStatus = 'T' WHERE acctId = 2419193
UPDATE TOP(1) BSegmentCreditCard SET AccountGraceStatus = 'T' WHERE acctId = 2458156
UPDATE TOP(1) BSegmentCreditCard SET AccountGraceStatus = 'T' WHERE acctId = 2481094
UPDATE TOP(1) BSegmentCreditCard SET AccountGraceStatus = 'T' WHERE acctId = 2618402
UPDATE TOP(1) BSegmentCreditCard SET AccountGraceStatus = 'T' WHERE acctId = 2651492
UPDATE TOP(1) BSegmentCreditCard SET AccountGraceStatus = 'T' WHERE acctId = 2653848
UPDATE TOP(1) BSegmentCreditCard SET AccountGraceStatus = 'T' WHERE acctId = 2782422
UPDATE TOP(1) BSegmentCreditCard SET AccountGraceStatus = 'T' WHERE acctId = 2809293
UPDATE TOP(1) BSegmentCreditCard SET AccountGraceStatus = 'T' WHERE acctId = 2908970
UPDATE TOP(1) BSegmentCreditCard SET AccountGraceStatus = 'T' WHERE acctId = 2950773
UPDATE TOP(1) BSegmentCreditCard SET AccountGraceStatus = 'T' WHERE acctId = 3426946
UPDATE TOP(1) BSegmentCreditCard SET AccountGraceStatus = 'T' WHERE acctId = 3520429
UPDATE TOP(1) BSegmentCreditCard SET AccountGraceStatus = 'T' WHERE acctId = 3564484
UPDATE TOP(1) BSegmentCreditCard SET AccountGraceStatus = 'T' WHERE acctId = 3932776
UPDATE TOP(1) BSegmentCreditCard SET AccountGraceStatus = 'T' WHERE acctId = 4123351
UPDATE TOP(1) BSegmentCreditCard SET AccountGraceStatus = 'T' WHERE acctId = 4127047
UPDATE TOP(1) BSegmentCreditCard SET AccountGraceStatus = 'T' WHERE acctId = 4256940
UPDATE TOP(1) BSegmentCreditCard SET AccountGraceStatus = 'T' WHERE acctId = 4327812
UPDATE TOP(1) BSegmentCreditCard SET AccountGraceStatus = 'T' WHERE acctId = 4494759
UPDATE TOP(1) BSegmentCreditCard SET AccountGraceStatus = 'T' WHERE acctId = 4705367
UPDATE TOP(1) BSegmentCreditCard SET AccountGraceStatus = 'T' WHERE acctId = 4847265
UPDATE TOP(1) BSegmentCreditCard SET AccountGraceStatus = 'T' WHERE acctId = 4895584
UPDATE TOP(1) BSegmentCreditCard SET AccountGraceStatus = 'T' WHERE acctId = 4941741
UPDATE TOP(1) BSegmentCreditCard SET AccountGraceStatus = 'T' WHERE acctId = 5578016
UPDATE TOP(1) BSegmentCreditCard SET AccountGraceStatus = 'T' WHERE acctId = 5714890
UPDATE TOP(1) BSegmentCreditCard SET AccountGraceStatus = 'T' WHERE acctId = 6975124
UPDATE TOP(1) BSegmentCreditCard SET AccountGraceStatus = 'T' WHERE acctId = 9047491
UPDATE TOP(1) BSegmentCreditCard SET AccountGraceStatus = 'T' WHERE acctId = 9455408
UPDATE TOP(1) BSegmentCreditCard SET AccountGraceStatus = 'T' WHERE acctId = 9868645
UPDATE TOP(1) BSegmentCreditCard SET AccountGraceStatus = 'T' WHERE acctId = 11946498
UPDATE TOP(1) BSegmentCreditCard SET AccountGraceStatus = 'T' WHERE acctId = 12103991
UPDATE TOP(1) BSegmentCreditCard SET AccountGraceStatus = 'T' WHERE acctId = 12386882
UPDATE TOP(1) BSegmentCreditCard SET AccountGraceStatus = 'T' WHERE acctId = 12482750
UPDATE TOP(1) BSegmentCreditCard SET AccountGraceStatus = 'T' WHERE acctId = 12710375
UPDATE TOP(1) BSegmentCreditCard SET AccountGraceStatus = 'T' WHERE acctId = 12847707
UPDATE TOP(1) BSegmentCreditCard SET AccountGraceStatus = 'T' WHERE acctId = 13947697
UPDATE TOP(1) BSegmentCreditCard SET AccountGraceStatus = 'T' WHERE acctId = 14875970
UPDATE TOP(1) BSegmentCreditCard SET AccountGraceStatus = 'T' WHERE acctId = 15333467
UPDATE TOP(1) BSegmentCreditCard SET AccountGraceStatus = 'T' WHERE acctId = 15473329
UPDATE TOP(1) BSegmentCreditCard SET AccountGraceStatus = 'T' WHERE acctId = 15929064
UPDATE TOP(1) BSegmentCreditCard SET AccountGraceStatus = 'T' WHERE acctId = 16052197
UPDATE TOP(1) BSegmentCreditCard SET AccountGraceStatus = 'T' WHERE acctId = 16059660
UPDATE TOP(1) BSegmentCreditCard SET AccountGraceStatus = 'T' WHERE acctId = 16251112
UPDATE TOP(1) BSegmentCreditCard SET AccountGraceStatus = 'T' WHERE acctId = 16823292
UPDATE TOP(1) BSegmentCreditCard SET AccountGraceStatus = 'T' WHERE acctId = 17295555
UPDATE TOP(1) BSegmentCreditCard SET AccountGraceStatus = 'T' WHERE acctId = 17301734
UPDATE TOP(1) BSegmentCreditCard SET AccountGraceStatus = 'T' WHERE acctId = 17541200
UPDATE TOP(1) BSegmentCreditCard SET AccountGraceStatus = 'T' WHERE acctId = 18059926