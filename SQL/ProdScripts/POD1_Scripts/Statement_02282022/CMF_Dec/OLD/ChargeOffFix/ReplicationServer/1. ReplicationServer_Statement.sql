-- TO BE RUN ON REPLICATION SERVER ONLY

USE CCGS_RPT_CoreIssue
GO


BEGIN TRANSACTION
--COMMIT TRANSACTION
-- ROLLBACK TRANSACTION

update    top(1)  statementheader   set   amountoftotaldue = 57.59  , amtofpaycurrdue= 57.59  ,  amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0  ,DateOfOriginalPaymentDUeDTD =  null  , minimumpaymentdue = 57.59 , AmtOfPayPastDue = 0   where   acctid  = 3466950 and statementid  = 113184559

update    top(1)  statementheader   set   srbwithinstallmentdue  = 0 , sbwithinstallmentdue = 0 ,amountoftotaldue = 0   , amtofpaycurrdue= 0   ,  amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,cycleduedtd = 0  ,DateOfOriginalPaymentDUeDTD =  null  , minimumpaymentdue = 0  , AmtOfPayPastDue = 0   where   acctid  = 410649 and statementid  = 110622382
update    top(1)  statementheader   set   srbwithinstallmentdue  = 0 , sbwithinstallmentdue = 0 ,amountoftotaldue = 0   , amtofpaycurrdue= 0   ,  amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,cycleduedtd = 0  ,DateOfOriginalPaymentDUeDTD =  null  , minimumpaymentdue = 0  , AmtOfPayPastDue = 0   where   acctid  = 1678058 and statementid  = 111940806
update    top(1)  statementheader   set   srbwithinstallmentdue  = 0 , sbwithinstallmentdue = 0 ,amountoftotaldue = 0   , amtofpaycurrdue= 0   ,  amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,cycleduedtd = 0  ,DateOfOriginalPaymentDUeDTD =  null  , minimumpaymentdue = 0  , AmtOfPayPastDue = 0   where   acctid  = 2243409 and statementid  = 112448864

update    top(1)  statementheader   set  amountoftotaldue = 775.07   , amtofpaycurrdue= 775.07 ,  amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,cycleduedtd = 1 , minimumpaymentdue = 775.07  , AmtOfPayPastDue = 0   where   acctid  = 560524 and statementid  = 111068064
update    top(1)  statementheader   set  amountoftotaldue = 289.20   , amtofpaycurrdue= 289.20 ,  amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,cycleduedtd = 1 , minimumpaymentdue = 289.20  , AmtOfPayPastDue = 0   where   acctid  = 1195299 and statementid  = 111478904
update    top(1)  statementheader   set  amountoftotaldue = 1360.00   , amtofpaycurrdue= 1360.00 ,  amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,cycleduedtd = 1 , minimumpaymentdue = 1360.00  , AmtOfPayPastDue = 0   where   acctid  = 1767305 and statementid  = 112021341
update    top(1)  statementheader   set  amountoftotaldue = 1000.00   , amtofpaycurrdue= 1000.00 ,  amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,cycleduedtd = 1 , minimumpaymentdue = 1000.00  , AmtOfPayPastDue = 0   where   acctid  = 1838049 and statementid  = 112056192
update    top(1)  statementheader   set  amountoftotaldue = 1872.89   , amtofpaycurrdue= 1872.89 ,  amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,cycleduedtd = 1 , minimumpaymentdue = 1872.89  , AmtOfPayPastDue = 0   where   acctid  = 2147728 and statementid  = 112353582
update    top(1)  statementheader   set  amountoftotaldue = 500.00   , amtofpaycurrdue= 500.00 ,  amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,cycleduedtd = 1 , minimumpaymentdue = 500.00  , AmtOfPayPastDue = 0   where   acctid  = 2171113 and statementid  = 112385601
update    top(1)  statementheader   set  amountoftotaldue = 761.78   , amtofpaycurrdue= 761.78 ,  amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,cycleduedtd = 1 , minimumpaymentdue = 761.78  , AmtOfPayPastDue = 0   where   acctid  = 2460832 and statementid  = 112674237
update    top(1)  statementheader   set  amountoftotaldue = 1900.00   , amtofpaycurrdue= 1900.00 ,  amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,cycleduedtd = 1 , minimumpaymentdue = 1900.00  , AmtOfPayPastDue = 0   where   acctid  = 2788428 and statementid  = 112987057
update    top(1)  statementheader   set  amountoftotaldue = 1410.48   , amtofpaycurrdue= 1410.48 ,  amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,cycleduedtd = 1 , minimumpaymentdue = 1410.48  , AmtOfPayPastDue = 0   where   acctid  = 2954792 and statementid  = 113093945
update    top(1)  statementheader   set  amountoftotaldue = 3501.24   , amtofpaycurrdue= 3501.24 ,  amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,cycleduedtd = 1 , minimumpaymentdue = 3501.24  , AmtOfPayPastDue = 0   where   acctid  = 3530330 and statementid  = 113217686
update    top(1)  statementheader   set  amountoftotaldue = 1873.59   , amtofpaycurrdue= 1873.59 ,  amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,cycleduedtd = 1 , minimumpaymentdue = 1873.59  , AmtOfPayPastDue = 0   where   acctid  = 3736532 and statementid  = 113256751
update    top(1)  statementheader   set  amountoftotaldue = 3362.51   , amtofpaycurrdue= 3362.51 ,  amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,cycleduedtd = 1 , minimumpaymentdue = 3362.51  , AmtOfPayPastDue = 0   where   acctid  = 4321453 and statementid  = 113440691
update    top(1)  statementheader   set  amountoftotaldue = 666.56   , amtofpaycurrdue= 666.56 ,  amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,cycleduedtd = 1 , minimumpaymentdue = 666.56  , AmtOfPayPastDue = 0   where   acctid  = 4874091 and statementid  = 113733169
update    top(1)  statementheader   set  amountoftotaldue = 2499.58   , amtofpaycurrdue= 2499.58 ,  amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,cycleduedtd = 1 , minimumpaymentdue = 2499.58  , AmtOfPayPastDue = 0   where   acctid  = 4956782 and statementid  = 113810458
update    top(1)  statementheader   set  amountoftotaldue = 935.85   , amtofpaycurrdue= 935.85 ,  amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,cycleduedtd = 1 , minimumpaymentdue = 935.85  , AmtOfPayPastDue = 0   where   acctid  = 7002669 and statementid  = 113988367
update    top(1)  statementheader   set  amountoftotaldue = 180.60   , amtofpaycurrdue= 180.60 ,  amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,cycleduedtd = 1 , minimumpaymentdue = 180.60  , AmtOfPayPastDue = 0   where   acctid  = 16832684 and statementid  = 115653154

update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 70952 and statementid  = 110757646
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 213313 and statementid  = 110689221
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 238489 and statementid  = 110719562
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 391887 and statementid  = 110741926
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 393317 and statementid  = 110819879
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 663341 and statementid  = 111019617
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 741627 and statementid  = 111147918
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 838606 and statementid  = 111233895
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 978299 and statementid  = 111321236
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 1081027 and statementid  = 111392329
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 1112290 and statementid  = 111418209
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 1153876 and statementid  = 111449510
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 1210713 and statementid  = 111493692
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 1216888 and statementid  = 111505256
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 1500322 and statementid  = 111772861
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 1548137 and statementid  = 111803234
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 2152222 and statementid  = 112360076
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 2355055 and statementid  = 112560879
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 2431248 and statementid  = 112642631
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 3896777 and statementid  = 113292584
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 4343157 and statementid  = 113456972
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 4517006 and statementid  = 113534851
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 4929962 and statementid  = 113788289
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 5632347 and statementid  = 113879999
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 5754096 and statementid  = 113905638
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 7542679 and statementid  = 114005789
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 8491246 and statementid  = 114142214
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 8934389 and statementid  = 114158249
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 9064909 and statementid  = 114174480
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 9260504 and statementid  = 114198601
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 9514124 and statementid  = 114264246
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 11415519 and statementid  = 114531768
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 11520302 and statementid  = 114580833
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 13536233 and statementid  = 115116098
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 17631665 and statementid  = 115897426
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 17980788 and statementid  = 116037924
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 18547040 and statementid  = 116280973
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 18699833 and statementid  = 116317229
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 19067810 and statementid  = 116384645
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 21659826 and statementid  = 117053386
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 21945510 and statementid  = 117189714



update     top(1)   summaryheader    set   amountoftotaldue  = 0     where   acctId  = 422869 and statementid  = 110622382
update     top(1)   summaryheader    set   amountoftotaldue  = 0     where   acctId  = 1693048 and statementid  = 111940806
update     top(1)   summaryheader    set   amountoftotaldue  = 0     where   acctId  = 2282209 and statementid  = 112448864
update     top(1)   summaryheader    set   amountoftotaldue  = 0     where   acctId  = 4962812 and statementid  = 112448864

