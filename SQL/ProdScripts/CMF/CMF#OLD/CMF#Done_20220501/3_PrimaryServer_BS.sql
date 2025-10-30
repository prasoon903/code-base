BEGIN TRAN
--COMMIT TRAN
--ROLLBACK TRAN

update    top(1)  bsegmentcreditcard    set   srbwithinstallmentdue  = 0 , sbwithinstallmentdue = 0 , runningminimumdue = 0 , remainingminimumdue = 0    ,amountoftotaldue = 0   ,   amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,DateOfOriginalPaymentDUeDTD =  null    , daysdelinquent  = 0 , nopaydaysdelinquent = 0 , DtOfLastDelinqCTD = null   where   acctid  = 2075467
update    top(1)  bsegment_primary     set   cycleduedtd= 0  , amtofpaycurrdue =0   where   acctid  = 2075467

update    top(1)  bsegmentcreditcard    set    runningminimumdue = 3809.70 , remainingminimumdue = 3809.70   ,amountoftotaldue = 3809.70   ,   amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0   where   acctid  = 566251
update    top(1)  bsegmentcreditcard    set    runningminimumdue = 1200.00 , remainingminimumdue = 1200.00   ,amountoftotaldue = 1200.00   ,   amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0   where   acctid  = 2212370
update    top(1)  bsegmentcreditcard    set    runningminimumdue = 1280.83 , remainingminimumdue = 1280.83   ,amountoftotaldue = 1280.83   ,   amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0   where   acctid  = 2246083
update    top(1)  bsegmentcreditcard    set    runningminimumdue = 1870.18 , remainingminimumdue = 1870.18   ,amountoftotaldue = 1870.18   ,   amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0   where   acctid  = 4352082
update    top(1)  bsegmentcreditcard    set    runningminimumdue = 1038.56 , remainingminimumdue = 1038.56   ,amountoftotaldue = 1038.56   ,   amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0   where   acctid  = 5766783

update    top(1)  bsegment_primary     set   cycleduedtd= 1  , amtofpaycurrdue= 3809.70   where   acctid  = 566251
update    top(1)  bsegment_primary     set   cycleduedtd= 1  , amtofpaycurrdue= 1200.00   where   acctid  = 2212370
update    top(1)  bsegment_primary     set   cycleduedtd= 1  , amtofpaycurrdue= 1280.83   where   acctid  = 2246083
update    top(1)  bsegment_primary     set   cycleduedtd= 1  , amtofpaycurrdue= 1870.18   where   acctid  = 4352082
update    top(1)  bsegment_primary     set   cycleduedtd= 1  , amtofpaycurrdue= 1038.56   where   acctid  = 5766783

update    top(1)  bsegmentcreditcard    set    runningminimumdue = 3809.70 , remainingminimumdue = 3809.70   ,amountoftotaldue = 3809.70   ,   amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0   where   acctid  = 566251
update    top(1)  bsegmentcreditcard    set    runningminimumdue = 1200.00 , remainingminimumdue = 1200.00   ,amountoftotaldue = 1200.00   ,   amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0   where   acctid  = 2212370
update    top(1)  bsegmentcreditcard    set    runningminimumdue = 1280.83 , remainingminimumdue = 1280.83   ,amountoftotaldue = 1280.83   ,   amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0   where   acctid  = 2246083
update    top(1)  bsegmentcreditcard    set    runningminimumdue = 1870.18 , remainingminimumdue = 1870.18   ,amountoftotaldue = 1870.18   ,   amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0   where   acctid  = 4352082
update    top(1)  bsegmentcreditcard    set    runningminimumdue = 1038.56 , remainingminimumdue = 1038.56   ,amountoftotaldue = 1038.56   ,   amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0   where   acctid  = 5766783

update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 319388
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 916258
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 1216528
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 1299125
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 1620510
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 1620602
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 1686932
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 2447179
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 2598151
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 2729755
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 3999025
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 7723254
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 8231046
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 9746492
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 11753600
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 13077329
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 13692168
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 14039844
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 16056546
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 17031377
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 18265051
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 18323183
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 18516275
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 19368004
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 21869135


update   top(1)   CPSgmentCreditcard   set   srbwithinstallmentdue  = 0 , sbwithinstallmentdue = 0  ,amountoftotaldue = 0   , amtofpaycurrdue= 0   ,  amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,cycleduedtd = 0    where   acctid  = 2106767
update   top(1)   CPSgmentCreditcard   set   srbwithinstallmentdue  = 0 , sbwithinstallmentdue = 0  ,amountoftotaldue = 0   , amtofpaycurrdue= 0   ,  amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,cycleduedtd = 0    where   acctid  = 8242579

update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 331478
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 928678
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 83179544
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 1228948
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 1311545
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 1633022
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 2530119
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 78175275
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 82919168
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 2714091
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 2887395
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 5409175
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 19957204
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 24044650
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 30335683
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 35973877
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 37794545
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 38915934
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 48715215
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 78127521
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 82255811
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 56899435
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 57541134
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 59825996
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 68260474
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 72925432
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 78647716
update   top(1)   CPSgmentCreditcard   set   cycleduedtd = 1    where   acctid  = 81422553

update   top(1)   CPSgmentCreditcard   set   srbwithinstallmentdue  = 6.70 , sbwithinstallmentdue = 6.70  ,amountoftotaldue = 6.70      , amtofpaycurrdue= 6.70   ,  amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,cycleduedtd = 1    where   acctid  = 50456456

