-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO


BEGIN TRANSACTION
--COMMIT TRANSACTION
-- ROLLBACK TRANSACTION

update    top(1)  bsegment_primary     set   cycleduedtd= 1  , amtofpaycurrdue= 1690.00   where   acctid  = 2827406
update    top(1)  bsegment_primary     set   cycleduedtd= 1  , amtofpaycurrdue= 1556.13   where   acctid  = 3630948
update    top(1)  bsegment_primary     set   cycleduedtd= 1  , amtofpaycurrdue= 3287.51   where   acctid  = 4321453
update    top(1)  bsegment_primary     set   cycleduedtd= 1  , amtofpaycurrdue= 2270.18   where   acctid  = 4352082
update    top(1)  bsegment_primary     set   cycleduedtd= 1  , amtofpaycurrdue= 0.03   where   acctid  = 8349434
update    top(1)  bsegment_primary     set   cycleduedtd= 1  , amtofpaycurrdue= 55.60   where   acctid  = 12976604

update    top(1)  bsegmentcreditcard    set    runningminimumdue = 1690.00 , remainingminimumdue = 1690.00   ,amountoftotaldue = 1690.00   ,   amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0   where   acctid  = 2827406
update    top(1)  bsegmentcreditcard    set    runningminimumdue = 1556.13 , remainingminimumdue = 1556.13   ,amountoftotaldue = 1556.13   ,   amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0   where   acctid  = 3630948
update    top(1)  bsegmentcreditcard    set    runningminimumdue = 3287.51 , remainingminimumdue = 3287.51   ,amountoftotaldue = 3287.51   ,   amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0   where   acctid  = 4321453
update    top(1)  bsegmentcreditcard    set    runningminimumdue = 2270.18 , remainingminimumdue = 2270.18   ,amountoftotaldue = 2270.18   ,   amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0   where   acctid  = 4352082
update    top(1)  bsegmentcreditcard    set    runningminimumdue = 0.03 , remainingminimumdue = 0.03   ,amountoftotaldue = 0.03   ,   amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0   where   acctid  = 8349434
update    top(1)  bsegmentcreditcard    set    runningminimumdue = 55.60 , remainingminimumdue = 55.60   ,amountoftotaldue = 55.60   ,   amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0   where   acctid  = 12976604


update    top(1)  bsegmentcreditcard    set   srbwithinstallmentdue  = 0 , sbwithinstallmentdue = 0 , runningminimumdue = 0 , remainingminimumdue = 0    ,amountoftotaldue = 0   ,   amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,DateOfOriginalPaymentDUeDTD =  null ,    daysdelinquent  = 0 , nopaydaysdelinquent = 0 , DtOfLastDelinqCTD = null   where   acctid  = 499372
update    top(1)  bsegmentcreditcard    set   srbwithinstallmentdue  = 0 , sbwithinstallmentdue = 0 , runningminimumdue = 0 , remainingminimumdue = 0    ,amountoftotaldue = 0   ,   amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,DateOfOriginalPaymentDUeDTD =  null ,    daysdelinquent  = 0 , nopaydaysdelinquent = 0 , DtOfLastDelinqCTD = null   where   acctid  = 2779857

update    top(1)  bsegment_primary     set   cycleduedtd= 0  , amtofpaycurrdue =0   where   acctid  = 499372
update    top(1)  bsegment_primary     set   cycleduedtd= 0  , amtofpaycurrdue =0   where   acctid  = 2779857

update   top(1)   CPSgmentCreditcard   set   srbwithinstallmentdue  = 0 , sbwithinstallmentdue = 0  ,amountoftotaldue = 0   , amtofpaycurrdue= 0   ,  amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,cycleduedtd = 0    where   cpsacctid  = 2955687
update   top(1)   CPSgmentCreditcard   set   srbwithinstallmentdue  = 0 , sbwithinstallmentdue = 0  ,amountoftotaldue = 0   , amtofpaycurrdue= 0   ,  amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,cycleduedtd = 0    where   cpsacctid  = 16540472




update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 1060980
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 1198879
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 1213501
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 1338870
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 1442360
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 1504869
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 1776655
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 2095559
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 2165424
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 2332630
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 3296304
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 3999025
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 4714465
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 8323081
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 9455782
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 9841570
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 13468076
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 16935840
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 18058587
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 18248714
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 18741329
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 19611860
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 20437347
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 20994857
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 21144423
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 21211787
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 21659289
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 21660691
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 21860253
update    top(1)  bsegment_primary     set   CycleDueDTD = 1   where   acctid  = 21875367




