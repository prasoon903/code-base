-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION
--COMMIT TRANSACTION
--ROLLBACK TRANSACTION

-- UPDATE WILL BE 1 ROW EACH STATEMENT




UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 41.51, AmtOfPayXDLate = AmtOfPayXDLate - 41.51, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00, DateOfOriginalPaymentDueDTD = NULL, FirstDueDate = NULL, DtOfLastDelinqCTD = NULL, DaysDelinquent = 0, NoPayDaysDelinquent = 0 WHERE acctId = 1255358
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 0.02, AmountOfPayment30DLate = AmountOfPayment30DLate - 0.02, RunningMinimumDue = 46.70, RemainingMinimumDue = 46.70 WHERE acctId = 1392139
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 0.10, AmtOfPayXDLate = AmtOfPayXDLate - 0.10, RunningMinimumDue = 1.38, RemainingMinimumDue = 1.38 WHERE acctId = 2983913
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 52.30, AmtOfPayXDLate = AmtOfPayXDLate - 26.15, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00, DateOfOriginalPaymentDueDTD = NULL, FirstDueDate = NULL, DtOfLastDelinqCTD = NULL, DaysDelinquent = 0, NoPayDaysDelinquent = 0 WHERE acctId = 417786

UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2 WHERE acctId = 1255358
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 26.15, CycleDueDTD = 0, SystemStatus = 2 WHERE acctId = 417786


UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 0.01, CycleDueDTD = 0 WHERE acctId = 945731
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 25.00, CycleDueDTD = 0 WHERE acctId = 939282
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 25.00, CycleDueDTD = 0 WHERE acctId = 994620
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 25.00, CycleDueDTD = 0 WHERE acctId = 988963
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 1.94, CycleDueDTD = 0 WHERE acctId = 1013701
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 1.12, CycleDueDTD = 0 WHERE acctId = 1069265
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 46.33, CycleDueDTD = 0 WHERE acctId = 1111312
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 25.00, CycleDueDTD = 0 WHERE acctId = 1157572
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 20.35, CycleDueDTD = 0 WHERE acctId = 1199866
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 17.68, CycleDueDTD = 0 WHERE acctId = 1225289
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 34.66, CycleDueDTD = 0 WHERE acctId = 1240951
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 4.08, CycleDueDTD = 0 WHERE acctId = 1286316
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 4.08, CycleDueDTD = 0 WHERE acctId = 1284325
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 237.97, CycleDueDTD = 0 WHERE acctId = 1301840
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 25.00, CycleDueDTD = 0 WHERE acctId = 1304812
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 20.37, CycleDueDTD = 0 WHERE acctId = 1310859
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 11.25, CycleDueDTD = 0 WHERE acctId = 1307664
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 77.75, CycleDueDTD = 0 WHERE acctId = 1349610
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 49.95, CycleDueDTD = 0 WHERE acctId = 1337072
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 25.00, CycleDueDTD = 0 WHERE acctId = 1344799
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 4.47, CycleDueDTD = 0 WHERE acctId = 1356278
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 5.84, CycleDueDTD = 0 WHERE acctId = 1406521
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 25.00, CycleDueDTD = 0 WHERE acctId = 1420140
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 2.66, CycleDueDTD = 0 WHERE acctId = 1408972
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 17.87, CycleDueDTD = 0 WHERE acctId = 1410294
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 37.45, CycleDueDTD = 0 WHERE acctId = 1508643
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 33.70, CycleDueDTD = 0 WHERE acctId = 1516160
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 25.00, CycleDueDTD = 0 WHERE acctId = 1510448
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 58.99, CycleDueDTD = 0 WHERE acctId = 1528168
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 34.54, CycleDueDTD = 0 WHERE acctId = 1554308
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 13.70, CycleDueDTD = 0 WHERE acctId = 1621680
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 25.00, CycleDueDTD = 0 WHERE acctId = 1665352
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 42.82, CycleDueDTD = 0 WHERE acctId = 1659297
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 25.00, CycleDueDTD = 0 WHERE acctId = 1699310
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 20.69, CycleDueDTD = 0 WHERE acctId = 1713995
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 33.79, CycleDueDTD = 0 WHERE acctId = 1725293
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 33.70, CycleDueDTD = 0 WHERE acctId = 1769675
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 4.91, CycleDueDTD = 0 WHERE acctId = 1852352
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 41.00, CycleDueDTD = 0 WHERE acctId = 1841142
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 1.17, CycleDueDTD = 0 WHERE acctId = 1841625
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 224.91, CycleDueDTD = 0 WHERE acctId = 1845697
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 27.41, CycleDueDTD = 0 WHERE acctId = 1877109
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 4.91, CycleDueDTD = 0 WHERE acctId = 1860660
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 3.21, CycleDueDTD = 0 WHERE acctId = 1908463
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 4.08, CycleDueDTD = 0 WHERE acctId = 1913091
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 25.00, CycleDueDTD = 0 WHERE acctId = 1960328
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 0.50, CycleDueDTD = 0 WHERE acctId = 1958254
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 25.00, CycleDueDTD = 0 WHERE acctId = 1974872
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 0.09, CycleDueDTD = 0 WHERE acctId = 1997732
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 25.00, CycleDueDTD = 0 WHERE acctId = 1992951
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 33.16, CycleDueDTD = 0 WHERE acctId = 2025126
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 65.32, CycleDueDTD = 0 WHERE acctId = 2049938
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 4.91, CycleDueDTD = 0 WHERE acctId = 2054296
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 11.62, CycleDueDTD = 0 WHERE acctId = 2068146
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 37.00, CycleDueDTD = 0 WHERE acctId = 2074418
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 73.32, CycleDueDTD = 0 WHERE acctId = 2058378
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 0.86, CycleDueDTD = 0 WHERE acctId = 2077434
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 4.08, CycleDueDTD = 0 WHERE acctId = 2096976
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 25.00, CycleDueDTD = 0 WHERE acctId = 2121825
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 1.98, CycleDueDTD = 0 WHERE acctId = 2142845
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 8.23, CycleDueDTD = 0 WHERE acctId = 2164912
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 25.00, CycleDueDTD = 0 WHERE acctId = 2222919
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 198.40, CycleDueDTD = 0 WHERE acctId = 2205796
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 24.52, CycleDueDTD = 0 WHERE acctId = 2246771
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 25.00, CycleDueDTD = 0 WHERE acctId = 2233108
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 54.12, CycleDueDTD = 0 WHERE acctId = 2248816
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 12.00, CycleDueDTD = 0 WHERE acctId = 2275562
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 24.72, CycleDueDTD = 0 WHERE acctId = 2279693
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 42.78, CycleDueDTD = 0 WHERE acctId = 2345600
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 25.00, CycleDueDTD = 0 WHERE acctId = 2381184
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 10.75, CycleDueDTD = 0 WHERE acctId = 2381370
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 21.78, CycleDueDTD = 0 WHERE acctId = 2409013
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 25.00, CycleDueDTD = 0 WHERE acctId = 2450800
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 4.91, CycleDueDTD = 0 WHERE acctId = 2454896
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 22.32, CycleDueDTD = 0 WHERE acctId = 2476697
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 0.25, CycleDueDTD = 0 WHERE acctId = 2531177
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 12.36, CycleDueDTD = 0 WHERE acctId = 2583190
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 10.83, CycleDueDTD = 0 WHERE acctId = 2595433
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 34.93, CycleDueDTD = 0 WHERE acctId = 2652061
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 14.68, CycleDueDTD = 0 WHERE acctId = 2642367
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 13.70, CycleDueDTD = 0 WHERE acctId = 2654223
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 7.11, CycleDueDTD = 0 WHERE acctId = 2669680
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 56.99, CycleDueDTD = 0 WHERE acctId = 2695187
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 14.62, CycleDueDTD = 0 WHERE acctId = 2717049
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 54.64, CycleDueDTD = 0 WHERE acctId = 2706267
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 25.00, CycleDueDTD = 0 WHERE acctId = 2707733
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 33.81, CycleDueDTD = 0 WHERE acctId = 2724147
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 25.00, CycleDueDTD = 0 WHERE acctId = 2734392
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 1.31, CycleDueDTD = 0 WHERE acctId = 2837196
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 38.16, CycleDueDTD = 0 WHERE acctId = 2976127
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 41.58, CycleDueDTD = 0 WHERE acctId = 3190962
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 135.00, CycleDueDTD = 0 WHERE acctId = 3470988
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 4.91, CycleDueDTD = 0 WHERE acctId = 3507103
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 13.00, CycleDueDTD = 0 WHERE acctId = 3638249
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 8.25, CycleDueDTD = 0 WHERE acctId = 3908886
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 18.70, CycleDueDTD = 0 WHERE acctId = 3996361
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 4.91, CycleDueDTD = 0 WHERE acctId = 3984254
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 19.38, CycleDueDTD = 0 WHERE acctId = 4001409
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 4.08, CycleDueDTD = 0 WHERE acctId = 4021740
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 4.91, CycleDueDTD = 0 WHERE acctId = 4126587
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 25.00, CycleDueDTD = 0 WHERE acctId = 4185659
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 4.08, CycleDueDTD = 0 WHERE acctId = 4245428
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 45.79, CycleDueDTD = 0 WHERE acctId = 4279439
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 25.00, CycleDueDTD = 0 WHERE acctId = 4311723
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 25.00, CycleDueDTD = 0 WHERE acctId = 4326867
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 61.15, CycleDueDTD = 0 WHERE acctId = 4383041
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 0.61, CycleDueDTD = 0 WHERE acctId = 4383406
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 39.00, CycleDueDTD = 0 WHERE acctId = 4445379
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 24.22, CycleDueDTD = 0 WHERE acctId = 4567102
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 35.99, CycleDueDTD = 0 WHERE acctId = 4655133
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 4.74, CycleDueDTD = 0 WHERE acctId = 4653684
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 11.20, CycleDueDTD = 0 WHERE acctId = 4680052
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 37.18, CycleDueDTD = 0 WHERE acctId = 4854985
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 25.00, CycleDueDTD = 0 WHERE acctId = 4845190
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 8.29, CycleDueDTD = 0 WHERE acctId = 4880990
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 25.00, CycleDueDTD = 0 WHERE acctId = 4915235
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 39.47, CycleDueDTD = 0 WHERE acctId = 4926941
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 24.69, CycleDueDTD = 0 WHERE acctId = 4916930
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 4.08, CycleDueDTD = 0 WHERE acctId = 5624363
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 23.40, CycleDueDTD = 0 WHERE acctId = 6466646
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 12.03, CycleDueDTD = 0 WHERE acctId = 6587226
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 36.15, CycleDueDTD = 0 WHERE acctId = 6765664
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 24.76, CycleDueDTD = 0 WHERE acctId = 7428785
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 13.25, CycleDueDTD = 0 WHERE acctId = 7593377
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 18.14, CycleDueDTD = 0 WHERE acctId = 7707318
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 25.00, CycleDueDTD = 0 WHERE acctId = 8193964
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 97.41, CycleDueDTD = 0 WHERE acctId = 8188580
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 25.74, CycleDueDTD = 0 WHERE acctId = 8206284
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 1.03, CycleDueDTD = 0 WHERE acctId = 8349434
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 38.62, CycleDueDTD = 0 WHERE acctId = 8490497
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 0.64, CycleDueDTD = 0 WHERE acctId = 8940606
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 7.87, CycleDueDTD = 0 WHERE acctId = 8939521
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 16.62, CycleDueDTD = 0 WHERE acctId = 8974782
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 41.50, CycleDueDTD = 0 WHERE acctId = 8973924
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 19.96, CycleDueDTD = 0 WHERE acctId = 9100949
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 59.83, CycleDueDTD = 0 WHERE acctId = 9457420
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 25.00, CycleDueDTD = 0 WHERE acctId = 9865993
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 16.62, CycleDueDTD = 0 WHERE acctId = 10277443
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 8.72, CycleDueDTD = 0 WHERE acctId = 10655987
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 4.35, CycleDueDTD = 0 WHERE acctId = 10782859
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 24.33, CycleDueDTD = 0 WHERE acctId = 10892209
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 64.49, CycleDueDTD = 0 WHERE acctId = 11089488
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 9.91, CycleDueDTD = 0 WHERE acctId = 11432744
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 30.37, CycleDueDTD = 0 WHERE acctId = 11520974
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 58.42, CycleDueDTD = 0 WHERE acctId = 11915083
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 16.95, CycleDueDTD = 0 WHERE acctId = 12128935
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 31.85, CycleDueDTD = 0 WHERE acctId = 12321119
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 22.21, CycleDueDTD = 0 WHERE acctId = 12377987
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 26.20, CycleDueDTD = 0 WHERE acctId = 12394035
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 34.54, CycleDueDTD = 0 WHERE acctId = 12408577
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 25.00, CycleDueDTD = 0 WHERE acctId = 12497858
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 25.00, CycleDueDTD = 0 WHERE acctId = 12494404
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 23.70, CycleDueDTD = 0 WHERE acctId = 12728239
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 49.91, CycleDueDTD = 0 WHERE acctId = 12807178
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 25.00, CycleDueDTD = 0 WHERE acctId = 12845401
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 6.88, CycleDueDTD = 0 WHERE acctId = 12861429
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 33.70, CycleDueDTD = 0 WHERE acctId = 12960983
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 16.77, CycleDueDTD = 0 WHERE acctId = 13002651
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 33.25, CycleDueDTD = 0 WHERE acctId = 13018693
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 1.07, CycleDueDTD = 0 WHERE acctId = 13126315
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 3.25, CycleDueDTD = 0 WHERE acctId = 13121962
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 1.66, CycleDueDTD = 0 WHERE acctId = 13402663
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 4.08, CycleDueDTD = 0 WHERE acctId = 13572797
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 25.00, CycleDueDTD = 0 WHERE acctId = 13574464
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 6.72, CycleDueDTD = 0 WHERE acctId = 14111857
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 25.00, CycleDueDTD = 0 WHERE acctId = 14886165
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 26.50, CycleDueDTD = 0 WHERE acctId = 14996948
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 25.00, CycleDueDTD = 0 WHERE acctId = 15302872
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 0.02, CycleDueDTD = 0 WHERE acctId = 15311049
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 4.91, CycleDueDTD = 0 WHERE acctId = 15927501
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 25.00, CycleDueDTD = 0 WHERE acctId = 16285936
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 13.66, CycleDueDTD = 0 WHERE acctId = 16549326
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 0.17, CycleDueDTD = 0 WHERE acctId = 16534502
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 10.75, CycleDueDTD = 0 WHERE acctId = 16958201
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 25.00, CycleDueDTD = 0 WHERE acctId = 17003098
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 0.05, CycleDueDTD = 0 WHERE acctId = 17482733
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 49.95, CycleDueDTD = 0 WHERE acctId = 17532995
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 12.87, CycleDueDTD = 0 WHERE acctId = 17564718
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 41.50, CycleDueDTD = 0 WHERE acctId = 17578890
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 104.08, CycleDueDTD = 0 WHERE acctId = 17883578
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 0.40, CycleDueDTD = 0 WHERE acctId = 18023824
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 0.99, CycleDueDTD = 0 WHERE acctId = 18041996
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 25.00, CycleDueDTD = 0 WHERE acctId = 18047876
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 28.24, CycleDueDTD = 0 WHERE acctId = 18297255
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 22.04, CycleDueDTD = 0 WHERE acctId = 18310493
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 47.87, CycleDueDTD = 0 WHERE acctId = 18390195
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 0.03, CycleDueDTD = 0 WHERE acctId = 18533310
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 2.03, CycleDueDTD = 0 WHERE acctId = 18537998
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 2.10, CycleDueDTD = 0 WHERE acctId = 18537769
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 5.98, CycleDueDTD = 0 WHERE acctId = 18737843
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 9.12, CycleDueDTD = 0 WHERE acctId = 19057428
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 58.25, CycleDueDTD = 0 WHERE acctId = 19076473
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 41.50, CycleDueDTD = 0 WHERE acctId = 19211284
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 11.94, CycleDueDTD = 0 WHERE acctId = 19495755
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 25.00, CycleDueDTD = 0 WHERE acctId = 19611584
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 2.99, CycleDueDTD = 0 WHERE acctId = 19620291
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 12.40, CycleDueDTD = 0 WHERE acctId = 20133542
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 7.94, CycleDueDTD = 0 WHERE acctId = 20153533
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 25.00, CycleDueDTD = 0 WHERE acctId = 20258189
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 15.97, CycleDueDTD = 0 WHERE acctId = 20449483
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 0.46, CycleDueDTD = 0 WHERE acctId = 20450010
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 45.79, CycleDueDTD = 0 WHERE acctId = 20448401
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 41.62, CycleDueDTD = 0 WHERE acctId = 20591141
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 1.12, CycleDueDTD = 0 WHERE acctId = 20602937
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 9.91, CycleDueDTD = 0 WHERE acctId = 20605943
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 25.00, CycleDueDTD = 0 WHERE acctId = 20774956
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 25.00, CycleDueDTD = 0 WHERE acctId = 20773301
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 10.79, CycleDueDTD = 0 WHERE acctId = 20782763
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 25.00, CycleDueDTD = 0 WHERE acctId = 20975013
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 129.83, CycleDueDTD = 0 WHERE acctId = 20993717
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 24.90, CycleDueDTD = 0 WHERE acctId = 20995308
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 41.99, CycleDueDTD = 0 WHERE acctId = 21091933
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 1.95, CycleDueDTD = 0 WHERE acctId = 21102013
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 45.79, CycleDueDTD = 0 WHERE acctId = 21171302
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 25.00, CycleDueDTD = 0 WHERE acctId = 21353997
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 25.00, CycleDueDTD = 0 WHERE acctId = 21363249
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 4.08, CycleDueDTD = 0 WHERE acctId = 21370327
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 146.41, CycleDueDTD = 0 WHERE acctId = 21398959
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 140.40, CycleDueDTD = 0 WHERE acctId = 21398996
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 36.41, CycleDueDTD = 0 WHERE acctId = 21394177
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 41.62, CycleDueDTD = 0 WHERE acctId = 21429904
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 68.16, CycleDueDTD = 0 WHERE acctId = 21430766
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 58.29, CycleDueDTD = 0 WHERE acctId = 21431308
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 6.15, CycleDueDTD = 0 WHERE acctId = 21455491
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 16.62, CycleDueDTD = 0 WHERE acctId = 21459378
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 17.87, CycleDueDTD = 0 WHERE acctId = 21464255
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 13.70, CycleDueDTD = 0 WHERE acctId = 21463396
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 25.00, CycleDueDTD = 0 WHERE acctId = 21467212
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 52.78, CycleDueDTD = 0 WHERE acctId = 21470164
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 25.00, CycleDueDTD = 0 WHERE acctId = 21513227
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 4.08, CycleDueDTD = 0 WHERE acctId = 21522118
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 9.91, CycleDueDTD = 0 WHERE acctId = 21529031
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 2.04, CycleDueDTD = 0 WHERE acctId = 21536924
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 30.37, CycleDueDTD = 0 WHERE acctId = 21536931
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 26.83, CycleDueDTD = 0 WHERE acctId = 21559947
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 3.25, CycleDueDTD = 0 WHERE acctId = 21559017
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 11.28, CycleDueDTD = 0 WHERE acctId = 21571460
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 25.00, CycleDueDTD = 0 WHERE acctId = 21578298
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 10.80, CycleDueDTD = 0 WHERE acctId = 21632344
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 119.73, CycleDueDTD = 0 WHERE acctId = 21644933
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 25.00, CycleDueDTD = 0 WHERE acctId = 11131
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 42.32, CycleDueDTD = 0 WHERE acctId = 90853
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 24.91, CycleDueDTD = 0 WHERE acctId = 173476
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 27.57, CycleDueDTD = 0 WHERE acctId = 155787
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 24.91, CycleDueDTD = 0 WHERE acctId = 174231
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 25.00, CycleDueDTD = 0 WHERE acctId = 161145
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 25.00, CycleDueDTD = 0 WHERE acctId = 184605
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 49.16, CycleDueDTD = 0 WHERE acctId = 184550
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 3.40, CycleDueDTD = 0 WHERE acctId = 244248
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 8.25, CycleDueDTD = 0 WHERE acctId = 245784
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 4.08, CycleDueDTD = 0 WHERE acctId = 322140
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 25.00, CycleDueDTD = 0 WHERE acctId = 322358
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 80.55, CycleDueDTD = 0 WHERE acctId = 307964
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 25.00, CycleDueDTD = 0 WHERE acctId = 336878
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 25.00, CycleDueDTD = 0 WHERE acctId = 390385
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 32.00, CycleDueDTD = 0 WHERE acctId = 405323
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 24.95, CycleDueDTD = 0 WHERE acctId = 416808
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 41.62, CycleDueDTD = 0 WHERE acctId = 418318
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 0.26, CycleDueDTD = 0 WHERE acctId = 412729
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 4.08, CycleDueDTD = 0 WHERE acctId = 435053
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 32.50, CycleDueDTD = 0 WHERE acctId = 443253
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 8.70, CycleDueDTD = 0 WHERE acctId = 499507
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 25.00, CycleDueDTD = 0 WHERE acctId = 488391
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 45.79, CycleDueDTD = 0 WHERE acctId = 544889
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 47.00, CycleDueDTD = 0 WHERE acctId = 535852
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 25.00, CycleDueDTD = 0 WHERE acctId = 550191
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 41.57, CycleDueDTD = 0 WHERE acctId = 592632
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 31.62, CycleDueDTD = 0 WHERE acctId = 595419
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 44.91, CycleDueDTD = 0 WHERE acctId = 582748
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 25.00, CycleDueDTD = 0 WHERE acctId = 588281
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 133.25, CycleDueDTD = 0 WHERE acctId = 608768
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 29.12, CycleDueDTD = 0 WHERE acctId = 619731
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 38.65, CycleDueDTD = 0 WHERE acctId = 618994
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 4.08, CycleDueDTD = 0 WHERE acctId = 644791
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 38.70, CycleDueDTD = 0 WHERE acctId = 633808
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 19.84, CycleDueDTD = 0 WHERE acctId = 699362
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 40.74, CycleDueDTD = 0 WHERE acctId = 702713
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 4.08, CycleDueDTD = 0 WHERE acctId = 707774
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 56.99, CycleDueDTD = 0 WHERE acctId = 794471
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 17.04, CycleDueDTD = 0 WHERE acctId = 842557
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 8.70, CycleDueDTD = 0 WHERE acctId = 851914
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 4.91, CycleDueDTD = 0 WHERE acctId = 856558
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 49.91, CycleDueDTD = 0 WHERE acctId = 861885


UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 0.01, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 945731
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25.00, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 939282
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25.00, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 994620
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25.00, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 988963
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 1.94, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 1013701
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 1.12, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 1069265
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 46.33, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 1111312
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25.00, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 1157572
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 20.35, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 1199866
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 17.68, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 1225289
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 34.66, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 1240951
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 4.08, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 1286316
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 4.08, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 1284325
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 237.97, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 1301840
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25.00, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 1304812
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 20.37, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 1310859
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 11.25, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 1307664
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 77.75, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 1349610
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 49.95, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 1337072
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25.00, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 1344799
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 4.47, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 1356278
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 5.84, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 1406521
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25.00, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 1420140
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 2.66, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 1408972
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 17.87, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 1410294
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 37.45, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 1508643
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 33.70, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 1516160
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25.00, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 1510448
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 58.99, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 1528168
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 34.54, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 1554308
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 13.70, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 1621680
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25.00, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 1665352
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 42.82, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 1659297
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25.00, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 1699310
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 20.69, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 1713995
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 33.79, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 1725293
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 33.70, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 1769675
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 4.91, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 1852352
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 41.00, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 1841142
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 1.17, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 1841625
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 224.91, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 1845697
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 27.41, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 1877109
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 4.91, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 1860660
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 3.21, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 1908463
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 4.08, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 1913091
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25.00, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 1960328
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 0.50, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 1958254
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25.00, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 1974872
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 0.09, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 1997732
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25.00, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 1992951
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 33.16, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 2025126
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 65.32, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 2049938
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 4.91, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 2054296
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 11.62, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 2068146
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 37.00, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 2074418
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 73.32, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 2058378
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 0.86, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 2077434
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 4.08, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 2096976
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25.00, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 2121825
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 1.98, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 2142845
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 8.23, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 2164912
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25.00, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 2222919
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 198.40, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 2205796
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 24.52, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 2246771
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25.00, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 2233108
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 54.12, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 2248816
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 12.00, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 2275562
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 24.72, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 2279693
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 42.78, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 2345600
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25.00, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 2381184
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 10.75, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 2381370
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 21.78, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 2409013
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25.00, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 2450800
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 4.91, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 2454896
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 22.32, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 2476697
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 0.25, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 2531177
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 12.36, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 2583190
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 10.83, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 2595433
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 34.93, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 2652061
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 14.68, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 2642367
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 13.70, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 2654223
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 7.11, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 2669680
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 56.99, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 2695187
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 14.62, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 2717049
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 54.64, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 2706267
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25.00, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 2707733
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 33.81, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 2724147
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25.00, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 2734392
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 1.31, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 2837196
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 38.16, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 2976127
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 41.58, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 3190962
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 135.00, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 3470988
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 4.91, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 3507103
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 13.00, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 3638249
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 8.25, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 3908886
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 18.70, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 3996361
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 4.91, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 3984254
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 19.38, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 4001409
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 4.08, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 4021740
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 4.91, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 4126587
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25.00, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 4185659
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 4.08, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 4245428
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 45.79, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 4279439
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25.00, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 4311723
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25.00, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 4326867
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 61.15, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 4383041
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 0.61, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 4383406
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 39.00, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 4445379
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 24.22, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 4567102
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 35.99, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 4655133
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 4.74, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 4653684
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 11.20, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 4680052
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 37.18, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 4854985
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25.00, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 4845190
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 8.29, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 4880990
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25.00, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 4915235
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 39.47, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 4926941
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 24.69, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 4916930
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 4.08, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 5624363
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 23.40, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 6466646
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 12.03, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 6587226
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 36.15, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 6765664
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 24.76, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 7428785
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 13.25, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 7593377
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 18.14, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 7707318
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25.00, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 8193964
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 97.41, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 8188580
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25.74, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 8206284
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 1.03, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 8349434
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 38.62, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 8490497
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 0.64, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 8940606
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 7.87, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 8939521
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 16.62, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 8974782
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 41.50, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 8973924
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 19.96, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 9100949
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 59.83, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 9457420
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25.00, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 9865993
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 16.62, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 10277443
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 8.72, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 10655987
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 4.35, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 10782859
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 24.33, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 10892209
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 64.49, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 11089488
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 9.91, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 11432744
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 30.37, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 11520974
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 58.42, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 11915083
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 16.95, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 12128935
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 31.85, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 12321119
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 22.21, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 12377987
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 26.20, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 12394035
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 34.54, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 12408577
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25.00, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 12497858
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25.00, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 12494404
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 23.70, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 12728239
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 49.91, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 12807178
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25.00, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 12845401
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 6.88, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 12861429
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 33.70, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 12960983
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 16.77, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 13002651
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 33.25, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 13018693
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 1.07, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 13126315
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 3.25, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 13121962
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 1.66, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 13402663
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 4.08, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 13572797
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25.00, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 13574464
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 6.72, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 14111857
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25.00, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 14886165
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 26.50, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 14996948
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25.00, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 15302872
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 0.02, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 15311049
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 4.91, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 15927501
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25.00, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 16285936
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 13.66, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 16549326
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 0.17, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 16534502
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 10.75, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 16958201
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25.00, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 17003098
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 0.05, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 17482733
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 49.95, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 17532995
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 12.87, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 17564718
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 41.50, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 17578890
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 104.08, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 17883578
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 0.40, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 18023824
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 0.99, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 18041996
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25.00, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 18047876
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 28.24, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 18297255
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 22.04, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 18310493
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 47.87, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 18390195
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 0.03, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 18533310
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 2.03, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 18537998
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 2.10, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 18537769
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 5.98, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 18737843
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 9.12, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 19057428
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 58.25, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 19076473
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 41.50, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 19211284
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 11.94, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 19495755
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25.00, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 19611584
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 2.99, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 19620291
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 12.40, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 20133542
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 7.94, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 20153533
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25.00, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 20258189
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 15.97, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 20449483
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 0.46, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 20450010
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 45.79, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 20448401
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 41.62, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 20591141
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 1.12, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 20602937
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 9.91, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 20605943
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25.00, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 20774956
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25.00, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 20773301
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 10.79, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 20782763
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25.00, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 20975013
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 129.83, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 20993717
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 24.90, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 20995308
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 41.99, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 21091933
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 1.95, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 21102013
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 45.79, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 21171302
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25.00, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 21353997
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25.00, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 21363249
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 4.08, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 21370327
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 146.41, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 21398959
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 140.40, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 21398996
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 36.41, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 21394177
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 41.62, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 21429904
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 68.16, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 21430766
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 58.29, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 21431308
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 6.15, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 21455491
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 16.62, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 21459378
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 17.87, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 21464255
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 13.70, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 21463396
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25.00, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 21467212
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 52.78, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 21470164
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25.00, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 21513227
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 4.08, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 21522118
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 9.91, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 21529031
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 2.04, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 21536924
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 30.37, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 21536931
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 26.83, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 21559947
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 3.25, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 21559017
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 11.28, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 21571460
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25.00, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 21578298
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 10.80, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 21632344
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 119.73, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 21644933
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25.00, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 11131
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 42.32, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 90853
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 24.91, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 173476
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 27.57, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 155787
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 24.91, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 174231
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25.00, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 161145
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25.00, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 184605
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 49.16, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 184550
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 3.40, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 244248
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 8.25, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 245784
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 4.08, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 322140
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25.00, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 322358
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 80.55, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 307964
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25.00, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 336878
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25.00, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 390385
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 32.00, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 405323
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 24.95, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 416808
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 41.62, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 418318
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 0.26, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 412729
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 4.08, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 435053
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 32.50, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 443253
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 8.70, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 499507
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25.00, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 488391
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 45.79, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 544889
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 47.00, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 535852
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25.00, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 550191
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 41.57, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 592632
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 31.62, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 595419
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 44.91, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 582748
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25.00, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 588281
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 133.25, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 608768
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 29.12, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 619731
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 38.65, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 618994
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 4.08, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 644791
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 38.70, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 633808
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 19.84, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 699362
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 40.74, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 702713
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 4.08, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 707774
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 56.99, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 794471
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 17.04, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 842557
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 8.70, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 851914
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 4.91, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 856558
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 49.91, RunningMinimumDue = 0.00, RemainingMinimumDue = 0.00 WHERE acctId = 861885



UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 4.08 WHERE acctId = 1262247
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 135.99 WHERE acctId = 1454168
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 24.49 WHERE acctId = 1502745
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 5.43 WHERE acctId = 2228111
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 25.74 WHERE acctId = 2355149
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 5.64 WHERE acctId = 2367739
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 60.25 WHERE acctId = 2521277
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 25.00 WHERE acctId = 2537639
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 20.66 WHERE acctId = 2574113
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 196.24 WHERE acctId = 2725239
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 25.00 WHERE acctId = 2766388
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 5.46 WHERE acctId = 3809490
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 10.75 WHERE acctId = 4815570
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 0.14 WHERE acctId = 4864173
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 30.37 WHERE acctId = 5582158
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 8.43 WHERE acctId = 6739037
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 41.50 WHERE acctId = 8214775
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 141.03 WHERE acctId = 8235030
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 4.91 WHERE acctId = 9586281
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 25.00 WHERE acctId = 10752718
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 25.00 WHERE acctId = 11963995
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 4.08 WHERE acctId = 12732210
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 5.99 WHERE acctId = 13005662
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 48.11 WHERE acctId = 13545334
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 25.00 WHERE acctId = 14886219
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 25.00 WHERE acctId = 15724822
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 13.23 WHERE acctId = 16564141
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 25.00 WHERE acctId = 17332309
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 25.00 WHERE acctId = 18463669
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 9.83 WHERE acctId = 18824805
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 66.58 WHERE acctId = 20155007
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 25.00 WHERE acctId = 21118927
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 25.00 WHERE acctId = 21197798
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 56.99 WHERE acctId = 21271597
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 62.41 WHERE acctId = 21305706
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 93.16 WHERE acctId = 21370195
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 25.00 WHERE acctId = 21375316
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 4.91 WHERE acctId = 21387691
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 25.00 WHERE acctId = 21510693
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 25.00 WHERE acctId = 21525579
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 25.00 WHERE acctId = 21592466
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 25.00 WHERE acctId = 57761
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 246.16 WHERE acctId = 214161
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 18.76 WHERE acctId = 430994
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 10.75 WHERE acctId = 463930
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 33.29 WHERE acctId = 608233
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 25.00 WHERE acctId = 703669
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 17.25 WHERE acctId = 701855
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 0.99 WHERE acctId = 832239
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 9.20 WHERE acctId = 845012
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 45.79 WHERE acctId = 868662
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 27.40 WHERE acctId = 869809
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 4.08 WHERE acctId = 883659


UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 4.08, RunningMinimumDue = 51.64, RemainingMinimumDue = 51.64 WHERE acctId = 1262247
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 135.99, RunningMinimumDue = 187.29, RemainingMinimumDue = 187.29 WHERE acctId = 1454168
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 24.49, RunningMinimumDue = 24.95, RemainingMinimumDue = 24.95 WHERE acctId = 1502745
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 5.43, RunningMinimumDue = 3.25, RemainingMinimumDue = 3.25 WHERE acctId = 2228111
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25.74, RunningMinimumDue = 76.06, RemainingMinimumDue = 76.06 WHERE acctId = 2355149
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 5.64, RunningMinimumDue = 58.53, RemainingMinimumDue = 58.53 WHERE acctId = 2367739
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 60.25, RunningMinimumDue = 231.49, RemainingMinimumDue = 231.49 WHERE acctId = 2521277
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25.00, RunningMinimumDue = 36.62, RemainingMinimumDue = 36.62 WHERE acctId = 2537639
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 20.66, RunningMinimumDue = 78.66, RemainingMinimumDue = 78.66 WHERE acctId = 2574113
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 196.24, RunningMinimumDue = 110.15, RemainingMinimumDue = 110.15 WHERE acctId = 2725239
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25.00, RunningMinimumDue = 74.86, RemainingMinimumDue = 74.86 WHERE acctId = 2766388
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 5.46, RunningMinimumDue = 6.99, RemainingMinimumDue = 6.99 WHERE acctId = 3809490
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 10.75, RunningMinimumDue = 34.67, RemainingMinimumDue = 34.67 WHERE acctId = 4815570
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 0.14, RunningMinimumDue = 14.63, RemainingMinimumDue = 14.63 WHERE acctId = 4864173
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 30.37, RunningMinimumDue = 3.18, RemainingMinimumDue = 3.18 WHERE acctId = 5582158
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 8.43, RunningMinimumDue = 90.70, RemainingMinimumDue = 90.70 WHERE acctId = 6739037
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 41.50, RunningMinimumDue = 42.24, RemainingMinimumDue = 42.24 WHERE acctId = 8214775
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 141.03, RunningMinimumDue = 64.75, RemainingMinimumDue = 64.75 WHERE acctId = 8235030
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 4.91, RunningMinimumDue = 32.00, RemainingMinimumDue = 32.00 WHERE acctId = 9586281
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25.00, RunningMinimumDue = 21.58, RemainingMinimumDue = 21.58 WHERE acctId = 10752718
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25.00, RunningMinimumDue = 309.99, RemainingMinimumDue = 309.99 WHERE acctId = 11963995
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 4.08, RunningMinimumDue = 59.86, RemainingMinimumDue = 59.86 WHERE acctId = 12732210
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 5.99, RunningMinimumDue = 108.91, RemainingMinimumDue = 108.91 WHERE acctId = 13005662
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 48.11, RunningMinimumDue = 11.76, RemainingMinimumDue = 11.76 WHERE acctId = 13545334
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25.00, RunningMinimumDue = 125.48, RemainingMinimumDue = 125.48 WHERE acctId = 14886219
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25.00, RunningMinimumDue = 91.50, RemainingMinimumDue = 91.50 WHERE acctId = 15724822
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 13.23, RunningMinimumDue = 66.50, RemainingMinimumDue = 66.50 WHERE acctId = 16564141
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25.00, RunningMinimumDue = 22.04, RemainingMinimumDue = 22.04 WHERE acctId = 17332309
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25.00, RunningMinimumDue = 59.00, RemainingMinimumDue = 59.00 WHERE acctId = 18463669
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 9.83, RunningMinimumDue = 16.62, RemainingMinimumDue = 16.62 WHERE acctId = 18824805
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 66.58, RunningMinimumDue = 19.30, RemainingMinimumDue = 19.30 WHERE acctId = 20155007
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25.00, RunningMinimumDue = 40.74, RemainingMinimumDue = 40.74 WHERE acctId = 21118927
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25.00, RunningMinimumDue = 88.16, RemainingMinimumDue = 88.16 WHERE acctId = 21197798
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 56.99, RunningMinimumDue = 12.98, RemainingMinimumDue = 12.98 WHERE acctId = 21271597
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 62.41, RunningMinimumDue = 25.66, RemainingMinimumDue = 25.66 WHERE acctId = 21305706
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 93.16, RunningMinimumDue = 121.87, RemainingMinimumDue = 121.87 WHERE acctId = 21370195
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25.00, RunningMinimumDue = 28.70, RemainingMinimumDue = 28.70 WHERE acctId = 21375316
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 4.91, RunningMinimumDue = 10.67, RemainingMinimumDue = 10.67 WHERE acctId = 21387691
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25.00, RunningMinimumDue = 88.16, RemainingMinimumDue = 88.16 WHERE acctId = 21510693
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25.00, RunningMinimumDue = 34.54, RemainingMinimumDue = 34.54 WHERE acctId = 21525579
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25.00, RunningMinimumDue = 52.41, RemainingMinimumDue = 52.41 WHERE acctId = 21592466
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25.00, RunningMinimumDue = 106.04, RemainingMinimumDue = 106.04 WHERE acctId = 57761
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 246.16, RunningMinimumDue = 164.31, RemainingMinimumDue = 164.31 WHERE acctId = 214161
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 18.76, RunningMinimumDue = 84.32, RemainingMinimumDue = 84.32 WHERE acctId = 430994
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 10.75, RunningMinimumDue = 70.12, RemainingMinimumDue = 70.12 WHERE acctId = 463930
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 33.29, RunningMinimumDue = 45.74, RemainingMinimumDue = 45.74 WHERE acctId = 608233
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25.00, RunningMinimumDue = 96.49, RemainingMinimumDue = 96.49 WHERE acctId = 703669
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 17.25, RunningMinimumDue = 7.12, RemainingMinimumDue = 7.12 WHERE acctId = 701855
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 0.99, RunningMinimumDue = 22.87, RemainingMinimumDue = 22.87 WHERE acctId = 832239
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 9.20, RunningMinimumDue = 199.90, RemainingMinimumDue = 199.90 WHERE acctId = 845012
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 45.79, RunningMinimumDue = 96.65, RemainingMinimumDue = 96.65 WHERE acctId = 868662
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 27.40, RunningMinimumDue = 63.20, RemainingMinimumDue = 63.20 WHERE acctId = 869809
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 4.08, RunningMinimumDue = 71.89, RemainingMinimumDue = 71.89 WHERE acctId = 883659

