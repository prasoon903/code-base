-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION
--COMMIT TRANSACTION
-- ROLLBACK TRANSACTION

update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 17.00 where  acctid  =  68398087
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 188.90 where  acctid  =  71832410



update   top(1)   CPSgmentCreditcard   set   srbwithinstallmentdue  = 825.00 , sbwithinstallmentdue = 825.00  ,amountoftotaldue = 825.00      , amtofpaycurrdue= 825.00   ,  amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,cycleduedtd = 1    where   acctid  = 2964298

update   top(1)   CPSgmentCreditcard   set   srbwithinstallmentdue  = 3237.51 , sbwithinstallmentdue = 3237.51  ,amountoftotaldue = 3237.51      , amtofpaycurrdue= 3237.51   ,  amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,cycleduedtd = 1    where   acctid  = 6459603



update    top(1)  bsegment_primary     set   cycleduedtd= 0  , amtofpaycurrdue =0   where   acctid  = 1156354
update    top(1)  bsegment_primary     set   cycleduedtd= 0  , amtofpaycurrdue =0   where   acctid  = 2842258

update    top(1)  bsegmentcreditcard    set   srbwithinstallmentdue  = 0 , sbwithinstallmentdue = 0 , runningminimumdue = 0 , remainingminimumdue = 0    ,amountoftotaldue = 0   ,   amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,DateOfOriginalPaymentDUeDTD =  null    , daysdelinquent  = 0 , nopaydaysdelinquent = 0 , DtOfLastDelinqCTD = null   where   acctid  = 1156354
update    top(1)  bsegmentcreditcard    set   srbwithinstallmentdue  = 0 , sbwithinstallmentdue = 0 , runningminimumdue = 0 , remainingminimumdue = 0    ,amountoftotaldue = 0   ,   amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,DateOfOriginalPaymentDUeDTD =  null    , daysdelinquent  = 0 , nopaydaysdelinquent = 0 , DtOfLastDelinqCTD = null   where   acctid  = 2842258

update    top(1)  bsegment_primary     set   cycleduedtd= 1  , amtofpaycurrdue= 1938.00   where   acctid  = 1845119
update    top(1)  bsegment_primary     set   cycleduedtd= 1  , amtofpaycurrdue= 2505.86   where   acctid  = 2081371
update    top(1)  bsegment_primary     set   cycleduedtd= 1  , amtofpaycurrdue= 69.01   where   acctid  = 2428372
update    top(1)  bsegment_primary     set   cycleduedtd= 1  , amtofpaycurrdue= 3237.51   where   acctid  = 4321453

update    top(1)  bsegmentcreditcard    set    runningminimumdue = 1938.00 , remainingminimumdue = 1938.00   ,amountoftotaldue = 1938.00   ,   amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0   where   acctid  = 1845119
update    top(1)  bsegmentcreditcard    set    runningminimumdue = 2505.86 , remainingminimumdue = 2505.86   ,amountoftotaldue = 2505.86   ,   amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0   where   acctid  = 2081371
update    top(1)  bsegmentcreditcard    set    runningminimumdue = 69.01 , remainingminimumdue = 69.01   ,amountoftotaldue = 69.01   ,   amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0   where   acctid  = 2428372
update    top(1)  bsegmentcreditcard    set    runningminimumdue = 3237.51 , remainingminimumdue = 3237.51   ,amountoftotaldue = 3237.51   ,   amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0   where   acctid  = 4321453

update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 949199
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 1110029
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 1160598
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 1314578
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 1524431
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 2014779
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 2723439
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 3213690
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 4562909
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 4729409
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 4799387
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 4875875
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 6663972
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 12788950
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 12881811
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 12987795
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 14125149
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 14128454
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 15319928
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 16056582
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 16999020
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 18086845
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 18252523
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 18535669
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 18732625
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 19638506
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 20140758
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 20778026
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 21630979
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 21949179

update   top(1)   CPSgmentCreditcard   set   srbwithinstallmentdue  = 0 , sbwithinstallmentdue = 0  ,amountoftotaldue = 0   , amtofpaycurrdue= 0   ,  amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,cycleduedtd = 0    where   acctid  = 1168774
update   top(1)   CPSgmentCreditcard   set   srbwithinstallmentdue  = 0 , sbwithinstallmentdue = 0  ,amountoftotaldue = 0   , amtofpaycurrdue= 0   ,  amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,cycleduedtd = 0    where   acctid  = 3035218

update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 961619
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 1122449
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 1173018
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 1326998
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 1536851
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 76184743
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 2736523
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 2871439
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 8549067
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 9905567
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 9983545
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 12281294
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 72086045
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 77327636
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 35200695
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 39189282
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 40403131
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 46630809
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 48715251
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 51622136
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 55285974
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 56069190
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 57751317
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 62257730
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 63716264
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 64420474
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 65432234
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 67579123
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 70791632
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 71714604
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 73057086
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 75759764
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 75810020
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 77166110
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 77240588
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 77311636