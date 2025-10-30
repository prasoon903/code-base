-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO


BEGIN TRANSACTION
--COMMIT TRANSACTION
-- ROLLBACK TRANSACTION

update    top(1)  bsegmentcreditcard    set    runningminimumdue = 57.59 , remainingminimumdue = 57.59   ,amountoftotaldue = 57.59   ,   amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 , daysdelinquent  = 0 , nopaydaysdelinquent = 0 , DtOfLastDelinqCTD = null   where   acctid  = 3466950

update    top(1)  bsegmentcreditcard    set   srbwithinstallmentdue  = 0 , sbwithinstallmentdue = 0 , runningminimumdue = 0 , remainingminimumdue = 0    ,amountoftotaldue = 0   ,   amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,DateOfOriginalPaymentDUeDTD =  null , daysdelinquent  = 0 , nopaydaysdelinquent = 0 , DtOfLastDelinqCTD = null   where   acctid  = 410649
update    top(1)  bsegmentcreditcard    set   srbwithinstallmentdue  = 0 , sbwithinstallmentdue = 0 , runningminimumdue = 0 , remainingminimumdue = 0    ,amountoftotaldue = 0   ,   amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,DateOfOriginalPaymentDUeDTD =  null , daysdelinquent  = 0 , nopaydaysdelinquent = 0 , DtOfLastDelinqCTD = null   where   acctid  = 1678058
update    top(1)  bsegmentcreditcard    set   srbwithinstallmentdue  = 0 , sbwithinstallmentdue = 0 , runningminimumdue = 0 , remainingminimumdue = 0    ,amountoftotaldue = 0   ,   amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,DateOfOriginalPaymentDUeDTD =  null , daysdelinquent  = 0 , nopaydaysdelinquent = 0 , DtOfLastDelinqCTD = null   where   acctid  = 2243409

update    top(1)  bsegment_primary     set   cycleduedtd= 0  , amtofpaycurrdue =0   where   acctid  = 410649
update    top(1)  bsegment_primary     set   cycleduedtd= 0  , amtofpaycurrdue =0   where   acctid  = 1678058
update    top(1)  bsegment_primary     set   cycleduedtd= 0  , amtofpaycurrdue =0   where   acctid  = 2243409

update    top(1)  bsegment_primary     set    amtofpaycurrdue =57.59   where   acctid  = 3466950

update    top(1)  bsegmentcreditcard    set    runningminimumdue = 775.07 , remainingminimumdue = 775.07   ,amountoftotaldue = 775.07   ,   amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0   where   acctid  = 560524
update    top(1)  bsegmentcreditcard    set    runningminimumdue = 289.20 , remainingminimumdue = 289.20   ,amountoftotaldue = 289.20   ,   amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0   where   acctid  = 1195299
update    top(1)  bsegmentcreditcard    set    runningminimumdue = 1360.00 , remainingminimumdue = 1360.00   ,amountoftotaldue = 1360.00   ,   amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0   where   acctid  = 1767305
update    top(1)  bsegmentcreditcard    set    runningminimumdue = 1000.00 , remainingminimumdue = 1000.00   ,amountoftotaldue = 1000.00   ,   amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0   where   acctid  = 1838049
update    top(1)  bsegmentcreditcard    set    runningminimumdue = 1872.89 , remainingminimumdue = 1872.89   ,amountoftotaldue = 1872.89   ,   amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0   where   acctid  = 2147728
update    top(1)  bsegmentcreditcard    set    runningminimumdue = 500.00 , remainingminimumdue = 500.00   ,amountoftotaldue = 500.00   ,   amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0   where   acctid  = 2171113
update    top(1)  bsegmentcreditcard    set    runningminimumdue = 761.78 , remainingminimumdue = 761.78   ,amountoftotaldue = 761.78   ,   amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0   where   acctid  = 2460832
update    top(1)  bsegmentcreditcard    set    runningminimumdue = 1900.00 , remainingminimumdue = 1900.00   ,amountoftotaldue = 1900.00   ,   amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0   where   acctid  = 2788428
update    top(1)  bsegmentcreditcard    set    runningminimumdue = 1410.48 , remainingminimumdue = 1410.48   ,amountoftotaldue = 1410.48   ,   amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0   where   acctid  = 2954792
update    top(1)  bsegmentcreditcard    set    runningminimumdue = 3501.24 , remainingminimumdue = 3501.24   ,amountoftotaldue = 3501.24   ,   amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0   where   acctid  = 3530330
update    top(1)  bsegmentcreditcard    set    runningminimumdue = 1873.59 , remainingminimumdue = 1873.59   ,amountoftotaldue = 1873.59   ,   amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0   where   acctid  = 3736532
update    top(1)  bsegmentcreditcard    set    runningminimumdue = 3362.51 , remainingminimumdue = 3362.51   ,amountoftotaldue = 3362.51   ,   amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0   where   acctid  = 4321453
update    top(1)  bsegmentcreditcard    set    runningminimumdue = 666.56 , remainingminimumdue = 666.56   ,amountoftotaldue = 666.56   ,   amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0   where   acctid  = 4874091
update    top(1)  bsegmentcreditcard    set    runningminimumdue = 2499.58 , remainingminimumdue = 2499.58   ,amountoftotaldue = 2499.58   ,   amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0   where   acctid  = 4956782
update    top(1)  bsegmentcreditcard    set    runningminimumdue = 935.85 , remainingminimumdue = 935.85   ,amountoftotaldue = 935.85   ,   amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0   where   acctid  = 7002669
update    top(1)  bsegmentcreditcard    set    runningminimumdue = 180.60 , remainingminimumdue = 180.60   ,amountoftotaldue = 180.60   ,   amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0   where   acctid  = 16832684


update    top(1)  bsegment_primary     set   cycleduedtd= 1  , amtofpaycurrdue= 775.07   where   acctid  = 560524
update    top(1)  bsegment_primary     set   cycleduedtd= 1  , amtofpaycurrdue= 289.20   where   acctid  = 1195299
update    top(1)  bsegment_primary     set   cycleduedtd= 1  , amtofpaycurrdue= 1360.00   where   acctid  = 1767305
update    top(1)  bsegment_primary     set   cycleduedtd= 1  , amtofpaycurrdue= 1000.00   where   acctid  = 1838049
update    top(1)  bsegment_primary     set   cycleduedtd= 1  , amtofpaycurrdue= 1872.89   where   acctid  = 2147728
update    top(1)  bsegment_primary     set   cycleduedtd= 1  , amtofpaycurrdue= 500.00   where   acctid  = 2171113
update    top(1)  bsegment_primary     set   cycleduedtd= 1  , amtofpaycurrdue= 761.78   where   acctid  = 2460832
update    top(1)  bsegment_primary     set   cycleduedtd= 1  , amtofpaycurrdue= 1900.00   where   acctid  = 2788428
update    top(1)  bsegment_primary     set   cycleduedtd= 1  , amtofpaycurrdue= 1410.48   where   acctid  = 2954792
update    top(1)  bsegment_primary     set   cycleduedtd= 1  , amtofpaycurrdue= 3501.24   where   acctid  = 3530330
update    top(1)  bsegment_primary     set   cycleduedtd= 1  , amtofpaycurrdue= 1873.59   where   acctid  = 3736532
update    top(1)  bsegment_primary     set   cycleduedtd= 1  , amtofpaycurrdue= 3362.51   where   acctid  = 4321453
update    top(1)  bsegment_primary     set   cycleduedtd= 1  , amtofpaycurrdue= 666.56   where   acctid  = 4874091
update    top(1)  bsegment_primary     set   cycleduedtd= 1  , amtofpaycurrdue= 2499.58   where   acctid  = 4956782
update    top(1)  bsegment_primary     set   cycleduedtd= 1  , amtofpaycurrdue= 935.85   where   acctid  = 7002669
update    top(1)  bsegment_primary     set   cycleduedtd= 1  , amtofpaycurrdue= 180.60   where   acctid  = 16832684


update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 70952
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 213313
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 238489
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 391887
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 393317
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 663341
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 741627
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 838606
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 978299
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 1081027
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 1112290
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 1153876
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 1210713
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 1216888
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 1500322
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 1548137
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 2152222
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 2355055
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 2431248
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 3896777
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 4343157
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 4517006
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 4929962
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 5632347
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 5754096
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 7542679
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 8491246
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 8934389
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 9064909
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 9260504
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 9514124
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 11415519
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 11520302
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 13536233
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 17631665
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 17980788
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 18547040
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 18699833
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 19067810
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 21659826
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 21945510



update   top(1)   CPSgmentCreditcard   set   srbwithinstallmentdue  = 0 , sbwithinstallmentdue = 0  ,amountoftotaldue = 0   , amtofpaycurrdue= 0   ,  amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,cycleduedtd = 0    where   cpsacctid  = 422869
update   top(1)   CPSgmentCreditcard   set   srbwithinstallmentdue  = 0 , sbwithinstallmentdue = 0  ,amountoftotaldue = 0   , amtofpaycurrdue= 0   ,  amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,cycleduedtd = 0    where   cpsacctid  = 1693048
update   top(1)   CPSgmentCreditcard   set   srbwithinstallmentdue  = 0 , sbwithinstallmentdue = 0  ,amountoftotaldue = 0   , amtofpaycurrdue= 0   ,  amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,cycleduedtd = 0    where   cpsacctid  = 2282209
update   top(1)   CPSgmentCreditcard   set   srbwithinstallmentdue  = 0 , sbwithinstallmentdue = 0  ,amountoftotaldue = 0   , amtofpaycurrdue= 0   ,  amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,cycleduedtd = 0    where   cpsacctid  = 4962812


update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 74532
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 225383
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 250559
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 39632716
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 61192765
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 61192766
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 675751
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 754037
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 851016
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 1093447
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 61194671
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 61194672
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 61343060
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 66173263
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 1124710
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 1166296
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 1223133
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 1229308
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 1560557
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 2412055
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 2509538
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 5028927
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 10464120
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 13142505
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 13962254
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 44096513
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 63314458
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 63314459
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 67563051
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 20661404
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 21642547
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 22193067
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 22592662
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 30310170
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 30557953
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 54787955
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 58133719
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 59074721
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 65172430
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 65416658
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 66115036
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 66774829
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 67757300
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 68487284
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 69449054
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 71599623
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 71890676
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 72084284
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 72193038
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 72310863