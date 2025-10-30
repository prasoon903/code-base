-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION
--COMMIT TRANSACTION
--ROLLBACK TRANSACTION

-- UPDATE WILL BE 1 ROW EACH STATEMENT

DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 2995499 AND ATID = 51 AND IdentityField = 1296200677

/*
UPDATE TOP(1) Bsegment_primary SET TPYLAD = NULL, TPYNAD = NULL, TPYBLOB = NULL WHERE acctId = 2995499

UPDATE TOP(1) Bsegment_primary SET ccinhparent125aid = 16100 WHERE acctId = 2995499

------DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 2995499 AND ATID = 51 AND IdentityField = 1288273793


UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 22.42, AmountOfTotalDue = AmountOfTotalDue - 22.42 WHERE acctId = 4949496

UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = '0.00' WHERE AID = 4949496 AND ATID = 52 AND IdentityField = 2144929532

INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(37696726801, '2021-04-01 10:08:25.000', 52, 4949496, 115, '1', '0')




UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1, DateOfOriginalPaymentDueDTD = '2021-03-31 23:59:57', FirstDueDate = '2021-03-31 23:59:57' WHERE acctId = 5523794

UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1, DateOfOriginalPaymentDueDTD = '2021-03-31 23:59:57', FirstDueDate = '2021-03-31 23:59:57' WHERE acctId = 119158


UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 2841611
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 7488914
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 346239
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 12732499
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 2331160
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 10194962
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 2601754
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 4526778
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 11148476
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 1191557
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 8186192
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 2952633
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 1322297
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 394472
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 224657
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 505841
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 2602756
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 1900546
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 7694659
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 10890002
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 8973934
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 4359355
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 686556
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 9387567
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 2495210
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 4877757
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 14159041
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 13003795
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 10808577
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 12998210
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 9437568
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 512026
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 13155076
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 32 WHERE acctId = 10005258
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 9369264
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 10343386
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 4607263
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 5629245
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 9317351
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 586091
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 2052468
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 2744998
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 4670558
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 4864067
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 13138005
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 4910711
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 11945219
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 4726105
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 32 WHERE acctId = 343409
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 2701696
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 2190930
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 1349610
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 2518355
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 4668879
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 10624946
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 2005304
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 32 WHERE acctId = 5712843
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 1165579
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 2408478
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 7685665
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 9747665
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 10882173
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 2159294
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 2811466
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 6114273
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 2325541
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 1193959
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 7700555
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 13593791
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 2544184
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 2079592
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 3532115
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 3516673
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 1164341
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 285444
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 1220107
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 2039940
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 400512
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 4503406
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 6961125
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 12358316
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 9747610
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 1080474
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 1190793
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 4612588
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 2902837
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 13027715
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 543353
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 2772645
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 32 WHERE acctId = 2755298
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 3993059
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 12268852
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 32 WHERE acctId = 12933657
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 12710580
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 2702654
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 3989797
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 4496252
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 9446083
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 8979157
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 1111111
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 12290595
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 2376361
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 1834477
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 1841931
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 1946634
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 604405
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 1305140
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 1680286
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 2161104
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 2789678
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 3528753
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 5533578
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 4655121
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 4082921
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 1199200
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 7597135
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 6037509
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 12460949
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 2 WHERE acctId = 5701858
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 2193459
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 3874165
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 13541460
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 2128262
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 4871648
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 32 WHERE acctId = 12409139
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 6829697
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 239152
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 1204466
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 2824104
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 319859
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 4925132
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 547693
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 430223
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 2334275
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 2279198
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 2480759
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 2528012
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 2467323
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 9446238
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 12474429
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 1859080
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 9859247
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 13017199
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 13168990
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 1046704
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 1183587
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 4945447
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 14149480
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 328713
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 433383
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 4298977
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 3793430
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 13174858
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 11492846
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 2997925
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 281758
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 2115691
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 2167410
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 2724034
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 4301149
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 12441262
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 12818446
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 11212230
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 4126160
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 443075
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 2240165
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 1225217
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 2772941
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 2600196
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 3979256
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 4117529
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 4313129
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 8469328
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 7005577
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 3530512
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 415774
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 11407273
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 2 WHERE acctId = 9443809
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 1 WHERE acctId = 3922704


UPDATE BSegmentCreditCard SET DaysDelinquent = 1 ,NoPayDaysDelinquent = 32 WHERE Acctid = 508333 AND DaysDelinquent = 90
UPDATE BSegmentCreditCard SET DaysDelinquent = 59 ,NoPayDaysDelinquent = 59 WHERE Acctid = 9850254 AND DaysDelinquent = 95
UPDATE BSegmentCreditCard SET DaysDelinquent = 0 ,NoPayDaysDelinquent = 0 WHERE Acctid = 2716879 AND DaysDelinquent = 1
UPDATE BSegmentCreditCard SET DaysDelinquent = 1 ,NoPayDaysDelinquent = 93 WHERE Acctid = 2642604 AND DaysDelinquent = 0
UPDATE BSegmentCreditCard SET DaysDelinquent = 29 ,NoPayDaysDelinquent = 60 WHERE Acctid = 7167512 AND DaysDelinquent = 32

*/