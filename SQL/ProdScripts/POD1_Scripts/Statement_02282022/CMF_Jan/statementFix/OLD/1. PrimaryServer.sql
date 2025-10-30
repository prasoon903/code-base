-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION
--COMMIT TRANSACTION
-- ROLLBACK TRANSACTION

UPDATE TOP(1) StatementHeaderEX SET NoPayDaysDelinquent = 62 WHERE AcctID = 1149951 AND StatementDate = '2022-01-31 23:59:57.000'
UPDATE TOP(1) StatementHeaderEX SET NoPayDaysDelinquent = 62 WHERE AcctID = 2055327 AND StatementDate = '2022-01-31 23:59:57.000'

UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 62 WHERE BSAcctID = 1149951 AND BusinessDay = '2022-01-31 23:59:57.000'
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 62 WHERE BSAcctID = 2055327 AND BusinessDay = '2022-01-31 23:59:57.000'

update      top(1) summaryheadercreditcard    set   srbwithinstallmentdue  = 825.00 , sbwithinstallmentdue = 825.00 , currentdue= 825.00   ,  amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,cycleduedtd = 1         where   acctId  = 2964298 and statementid  = 126611199
update     top(1)   summaryheader    set   amountoftotaldue  = 825.00     where   acctId  = 2964298 and statementid  = 126611199

update   top(1)   planinfoforreport   set   srbwithinstallmentdue  = 825.00 , sbwithinstallmentdue = 825.00     ,amountoftotaldue = 825.00   , amtofpaycurrdue= 825.00   ,  amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,cycleduedtd = 1    where   cpsacctid  = 2964298 and businessday  = '2022-01-31 23:59:57'



update    top(1)  statementheader   set   srbwithinstallmentdue  = 0 , sbwithinstallmentdue = 0 ,amountoftotaldue = 0   , amtofpaycurrdue= 0   ,  amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,cycleduedtd = 0  ,DateOfOriginalPaymentDUeDTD =  null  , minimumpaymentdue = 0  , AmtOfPayPastDue = 0   where   acctid  = 1156354 and statementid  = 124700726
update    top(1)  statementheader   set   srbwithinstallmentdue  = 0 , sbwithinstallmentdue = 0 ,amountoftotaldue = 0   , amtofpaycurrdue= 0   ,  amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,cycleduedtd = 0  ,DateOfOriginalPaymentDUeDTD =  null  , minimumpaymentdue = 0  , AmtOfPayPastDue = 0   where   acctid  = 2842258 and statementid  = 126655556

update    top(1)  accountinfoforreport   set   srbwithinstallmentdue  = 0 , sbwithinstallmentdue = 0 , runningminimumdue = 0 , remainingminimumdue = 0 ,   amountoftotaldue = 0   , amtofpaycurrdue= 0   ,  amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,cycleduedtd = 0  ,DateOfOriginalPaymentDUeDTD =  null ,    daysdelinquent  = 0 , Totaldaysdelinquent = 0 , dateofdelinquency = null   where   bsacctid  = 1156354 and businessday  = '2022-01-31 23:59:57'
update    top(1)  accountinfoforreport   set   srbwithinstallmentdue  = 0 , sbwithinstallmentdue = 0 , runningminimumdue = 0 , remainingminimumdue = 0 ,   amountoftotaldue = 0   , amtofpaycurrdue= 0   ,  amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,cycleduedtd = 0  ,DateOfOriginalPaymentDUeDTD =  null ,    daysdelinquent  = 0 , Totaldaysdelinquent = 0 , dateofdelinquency = null   where   bsacctid  = 2842258 and businessday  = '2022-01-31 23:59:57'

update    top(1)  statementheader   set  amountoftotaldue = 1938.00   , amtofpaycurrdue= 1938.00 ,  amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,cycleduedtd = 1 , minimumpaymentdue = 1938.00  , AmtOfPayPastDue = 0   where   acctid  = 1845119 and statementid  = 125712077
update    top(1)  statementheader   set  amountoftotaldue = 2505.86   , amtofpaycurrdue= 2505.86 ,  amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,cycleduedtd = 1 , minimumpaymentdue = 2505.86  , AmtOfPayPastDue = 0   where   acctid  = 2081371 and statementid  = 125928217
update    top(1)  statementheader   set  amountoftotaldue = 69.01   , amtofpaycurrdue= 69.01 ,  amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,cycleduedtd = 1 , minimumpaymentdue = 69.01  , AmtOfPayPastDue = 0   where   acctid  = 2428372 and statementid  = 126248902
update    top(1)  statementheader   set  amountoftotaldue = 3237.51   , amtofpaycurrdue= 3237.51 ,  amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,cycleduedtd = 1 , minimumpaymentdue = 3237.51  , AmtOfPayPastDue = 0   where   acctid  = 4321453 and statementid  = 127055298

update    top(1)  accountinfoforreport   set      amountoftotaldue = 1938.00   , amtofpaycurrdue= 1938.00   ,  amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,cycleduedtd = 1  where   bsacctid  = 1845119 and businessday  = '2022-01-31 23:59:57'
update    top(1)  accountinfoforreport   set      amountoftotaldue = 2505.86   , amtofpaycurrdue= 2505.86   ,  amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,cycleduedtd = 1  where   bsacctid  = 2081371 and businessday  = '2022-01-31 23:59:57'
update    top(1)  accountinfoforreport   set      amountoftotaldue = 69.01   , amtofpaycurrdue= 69.01   ,  amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,cycleduedtd = 1  where   bsacctid  = 2428372 and businessday  = '2022-01-31 23:59:57'
update    top(1)  accountinfoforreport   set      amountoftotaldue = 3237.51   , amtofpaycurrdue= 3237.51   ,  amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,cycleduedtd = 1  where   bsacctid  = 4321453 and businessday  = '2022-01-31 23:59:57'

update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 949199 and statementid  = 124924532
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 1110029 and statementid  = 125031302
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 1160598 and statementid  = 124740630
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 1314578 and statementid  = 125200644
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 1524431 and statementid  = 125404885
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 2014779 and statementid  = 125875367
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 2723439 and statementid  = 126545873
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 3213690 and statementid  = 126771074
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 4562909 and statementid  = 127168783
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 4729409 and statementid  = 127276372
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 4799387 and statementid  = 127304122
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 4875875 and statementid  = 127352277
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 6663972 and statementid  = 127566834
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 12788950 and statementid  = 128448523
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 12881811 and statementid  = 128521980
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 12987795 and statementid  = 128577897
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 14125149 and statementid  = 128878590
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 14128454 and statementid  = 128879603
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 15319928 and statementid  = 129041383
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 16056582 and statementid  = 129172444
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 16999020 and statementid  = 129335963
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 18086845 and statementid  = 129745339
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 18252523 and statementid  = 129774392
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 18535669 and statementid  = 129886251
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 18732625 and statementid  = 129959390
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 19638506 and statementid  = 130158348
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 20140758 and statementid  = 130202550
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 20778026 and statementid  = 130316297
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 21630979 and statementid  = 130647245
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 21949179 and statementid  = 130806383

update    top(1)  accountinfoforreport   set   CycleDueDTD = 1  where   bsacctid  = 949199 and businessday  = '2022-01-31 23:59:57'
update    top(1)  accountinfoforreport   set   CycleDueDTD = 1  where   bsacctid  = 1110029 and businessday  = '2022-01-31 23:59:57'
update    top(1)  accountinfoforreport   set   CycleDueDTD = 1  where   bsacctid  = 1160598 and businessday  = '2022-01-31 23:59:57'
update    top(1)  accountinfoforreport   set   CycleDueDTD = 1  where   bsacctid  = 1314578 and businessday  = '2022-01-31 23:59:57'
update    top(1)  accountinfoforreport   set   CycleDueDTD = 1  where   bsacctid  = 1524431 and businessday  = '2022-01-31 23:59:57'
update    top(1)  accountinfoforreport   set   CycleDueDTD = 1  where   bsacctid  = 2014779 and businessday  = '2022-01-31 23:59:57'
update    top(1)  accountinfoforreport   set   CycleDueDTD = 1  where   bsacctid  = 2723439 and businessday  = '2022-01-31 23:59:57'
update    top(1)  accountinfoforreport   set   CycleDueDTD = 1  where   bsacctid  = 3213690 and businessday  = '2022-01-31 23:59:57'
update    top(1)  accountinfoforreport   set   CycleDueDTD = 1  where   bsacctid  = 4562909 and businessday  = '2022-01-31 23:59:57'
update    top(1)  accountinfoforreport   set   CycleDueDTD = 1  where   bsacctid  = 4729409 and businessday  = '2022-01-31 23:59:57'
update    top(1)  accountinfoforreport   set   CycleDueDTD = 1  where   bsacctid  = 4799387 and businessday  = '2022-01-31 23:59:57'
update    top(1)  accountinfoforreport   set   CycleDueDTD = 1  where   bsacctid  = 4875875 and businessday  = '2022-01-31 23:59:57'
update    top(1)  accountinfoforreport   set   CycleDueDTD = 1  where   bsacctid  = 6663972 and businessday  = '2022-01-31 23:59:57'
update    top(1)  accountinfoforreport   set   CycleDueDTD = 1  where   bsacctid  = 12788950 and businessday  = '2022-01-31 23:59:57'
update    top(1)  accountinfoforreport   set   CycleDueDTD = 1  where   bsacctid  = 12881811 and businessday  = '2022-01-31 23:59:57'
update    top(1)  accountinfoforreport   set   CycleDueDTD = 1  where   bsacctid  = 12987795 and businessday  = '2022-01-31 23:59:57'
update    top(1)  accountinfoforreport   set   CycleDueDTD = 1  where   bsacctid  = 14125149 and businessday  = '2022-01-31 23:59:57'
update    top(1)  accountinfoforreport   set   CycleDueDTD = 1  where   bsacctid  = 14128454 and businessday  = '2022-01-31 23:59:57'
update    top(1)  accountinfoforreport   set   CycleDueDTD = 1  where   bsacctid  = 15319928 and businessday  = '2022-01-31 23:59:57'
update    top(1)  accountinfoforreport   set   CycleDueDTD = 1  where   bsacctid  = 16056582 and businessday  = '2022-01-31 23:59:57'
update    top(1)  accountinfoforreport   set   CycleDueDTD = 1  where   bsacctid  = 16999020 and businessday  = '2022-01-31 23:59:57'
update    top(1)  accountinfoforreport   set   CycleDueDTD = 1  where   bsacctid  = 18086845 and businessday  = '2022-01-31 23:59:57'
update    top(1)  accountinfoforreport   set   CycleDueDTD = 1  where   bsacctid  = 18252523 and businessday  = '2022-01-31 23:59:57'
update    top(1)  accountinfoforreport   set   CycleDueDTD = 1  where   bsacctid  = 18535669 and businessday  = '2022-01-31 23:59:57'
update    top(1)  accountinfoforreport   set   CycleDueDTD = 1  where   bsacctid  = 18732625 and businessday  = '2022-01-31 23:59:57'
update    top(1)  accountinfoforreport   set   CycleDueDTD = 1  where   bsacctid  = 19638506 and businessday  = '2022-01-31 23:59:57'
update    top(1)  accountinfoforreport   set   CycleDueDTD = 1  where   bsacctid  = 20140758 and businessday  = '2022-01-31 23:59:57'
update    top(1)  accountinfoforreport   set   CycleDueDTD = 1  where   bsacctid  = 20778026 and businessday  = '2022-01-31 23:59:57'
update    top(1)  accountinfoforreport   set   CycleDueDTD = 1  where   bsacctid  = 21630979 and businessday  = '2022-01-31 23:59:57'
update    top(1)  accountinfoforreport   set   CycleDueDTD = 1  where   bsacctid  = 21949179 and businessday  = '2022-01-31 23:59:57'

update      top(1) summaryheadercreditcard    set   srbwithinstallmentdue  = 0 , sbwithinstallmentdue = 0 , currentdue= 0   ,  amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,cycleduedtd = 0         where   acctId  = 1168774 and statementid  = 124700726
update      top(1) summaryheadercreditcard    set   srbwithinstallmentdue  = 0 , sbwithinstallmentdue = 0 , currentdue= 0   ,  amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,cycleduedtd = 0         where   acctId  = 3035218 and statementid  = 126655556

update     top(1)   summaryheader    set   amountoftotaldue  = 0     where   acctId  = 1168774 and statementid  = 124700726
update     top(1)   summaryheader    set   amountoftotaldue  = 0     where   acctId  = 3035218 and statementid  = 126655556

update   top(1)   planinfoforreport   set   srbwithinstallmentdue  = 0 , sbwithinstallmentdue = 0  ,amountoftotaldue = 0   , amtofpaycurrdue= 0   ,  amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,cycleduedtd = 0    where   cpsacctid  = 1168774 and businessday  = '2022-01-31 23:59:57'
update   top(1)   planinfoforreport   set   srbwithinstallmentdue  = 0 , sbwithinstallmentdue = 0  ,amountoftotaldue = 0   , amtofpaycurrdue= 0   ,  amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,cycleduedtd = 0    where   cpsacctid  = 3035218 and businessday  = '2022-01-31 23:59:57'

update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 961619 and statementid  = 124924532
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 1122449 and statementid  = 125031302
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 1173018 and statementid  = 124740630
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 1326998 and statementid  = 125200644
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 1536851 and statementid  = 125404885
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 76184743 and statementid  = 125031302
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 2736523 and statementid  = 125875367
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 2871439 and statementid  = 126545873
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 8549067 and statementid  = 127168783
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 9905567 and statementid  = 127276372
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 9983545 and statementid  = 127304122
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 12281294 and statementid  = 126771074
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 72086045 and statementid  = 127352277
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 77327636 and statementid  = 127566834
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 35200695 and statementid  = 128521980
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 39189282 and statementid  = 128879603
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 40403131 and statementid  = 128878590
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 46630809 and statementid  = 129041383
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 48715251 and statementid  = 129172444
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 51622136 and statementid  = 129335963
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 55285974 and statementid  = 129745339
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 56069190 and statementid  = 129774392
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 57751317 and statementid  = 129886251
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 62257730 and statementid  = 130202550
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 63716264 and statementid  = 130316297
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 64420474 and statementid  = 130316297
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 65432234 and statementid  = 129959390
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 67579123 and statementid  = 130647245
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 70791632 and statementid  = 129335963
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 71714604 and statementid  = 128448523
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 73057086 and statementid  = 130158348
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 75759764 and statementid  = 130647245
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 75810020 and statementid  = 130806383
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 77166110 and statementid  = 129041383
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 77240588 and statementid  = 129959390
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 77311636 and statementid  = 128577897

update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 961619 and businessday  = '2022-01-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 1122449 and businessday  = '2022-01-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 1173018 and businessday  = '2022-01-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 1326998 and businessday  = '2022-01-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 1536851 and businessday  = '2022-01-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 76184743 and businessday  = '2022-01-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 2736523 and businessday  = '2022-01-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 2871439 and businessday  = '2022-01-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 8549067 and businessday  = '2022-01-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 9905567 and businessday  = '2022-01-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 9983545 and businessday  = '2022-01-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 12281294 and businessday  = '2022-01-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 72086045 and businessday  = '2022-01-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 77327636 and businessday  = '2022-01-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 35200695 and businessday  = '2022-01-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 39189282 and businessday  = '2022-01-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 40403131 and businessday  = '2022-01-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 46630809 and businessday  = '2022-01-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 48715251 and businessday  = '2022-01-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 51622136 and businessday  = '2022-01-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 55285974 and businessday  = '2022-01-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 56069190 and businessday  = '2022-01-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 57751317 and businessday  = '2022-01-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 62257730 and businessday  = '2022-01-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 63716264 and businessday  = '2022-01-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 64420474 and businessday  = '2022-01-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 65432234 and businessday  = '2022-01-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 67579123 and businessday  = '2022-01-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 70791632 and businessday  = '2022-01-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 71714604 and businessday  = '2022-01-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 73057086 and businessday  = '2022-01-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 75759764 and businessday  = '2022-01-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 75810020 and businessday  = '2022-01-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 77166110 and businessday  = '2022-01-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 77240588 and businessday  = '2022-01-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 77311636 and businessday  = '2022-01-31 23:59:57'



insert into dodetailtxns values (54164297225, 51,295468, '2022-01-31 23:59:57.000',124156838,124155657, null)
 update ccard_primary set accountnumber = '1100011102912916', txnacctid = 295468 where tranid = 54164297225
insert into dodetailtxns values (54426355870, 51,9337382, '2022-01-31 23:59:57.000',127819047,127818969, null)
 update ccard_primary set accountnumber = '1100011145708065', txnacctid = 9337382 where tranid = 54426355870
 insert into dodetailtxns values (54426355885, 51,1064989, '2022-01-31 23:59:57.000',124689559,124688378, null)
 update ccard_primary set accountnumber = '1100011110609421', txnacctid = 1064989 where tranid = 54426355885