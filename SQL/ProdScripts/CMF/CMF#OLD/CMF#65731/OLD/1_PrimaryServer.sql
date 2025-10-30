BEGIN TRAN
--COMMIT TRAN
--ROLLBACK TRAN


UPDATE TOP(1) AccountInfoForReport SET AmtOfPayXDLate = 0, CycleDueDTD = 1, SystemStatus = 2, DaysDelinquent = 0, TotalDaysDelinquent = 0, 
DAteOfOriginalPaymentDueDTD = '2022-04-30 23:59:57.000', dateofdelinquency = null  WHERE 
BSAcctID = 17277194 AND BusinessDay = '2022-03-31 23:59:57.000'

UPDATE TOP(1) StatementHeader SET AmtOfPayXDLate = 0, CycleDueDTD = 1, SystemStatus = 2, DAteOfOriginalPaymentDueDTD = '2022-04-30 23:59:57.000' WHERE AcctID = 17277194 AND StatementID = 143046085

UPDATE TOP(1) StatementHeaderEX SET DaysDelinquent = 0, NoPayDaysDelinquent = 0 WHERE AcctID = 17277194 AND StatementID = 143046085

update    top(1)  statementheader   set   srbwithinstallmentdue  = 0 , sbwithinstallmentdue = 0 ,amountoftotaldue = 0   , amtofpaycurrdue= 0   ,  amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,cycleduedtd = 0  ,DateOfOriginalPaymentDUeDTD =  null  , minimumpaymentdue = 0  , AmtOfPayPastDue = 0   where   acctid  = 2617166 and statementid  = 140090439
update    top(1)  statementheader   set   srbwithinstallmentdue  = 0 , sbwithinstallmentdue = 0 ,amountoftotaldue = 0   , amtofpaycurrdue= 0   ,  amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,cycleduedtd = 0  ,DateOfOriginalPaymentDUeDTD =  null  , minimumpaymentdue = 0  , AmtOfPayPastDue = 0   where   acctid  = 2915158 and statementid  = 140335090

update    top(1)  statementheader   set  amountoftotaldue = 3829.70   , amtofpaycurrdue= 3829.70 ,  amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,cycleduedtd = 1 , minimumpaymentdue = 3829.70  , AmtOfPayPastDue = 0   where   acctid  = 566251 and statementid  = 137652159
update    top(1)  statementheader   set  amountoftotaldue = 1908.00   , amtofpaycurrdue= 1908.00 ,  amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,cycleduedtd = 1 , minimumpaymentdue = 1908.00  , AmtOfPayPastDue = 0   where   acctid  = 1845119 and statementid  = 139331748

update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 309744 and statementid  = 137818156
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 462900 and statementid  = 138276130
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 1129291 and statementid  = 138343633
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 1330111 and statementid  = 138832163
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 1589595 and statementid  = 139123128
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 1592325 and statementid  = 139127600
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 1948780 and statementid  = 139433316
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 2095559 and statementid  = 139573835
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 2255470 and statementid  = 139728282
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 2447179 and statementid  = 139923187
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 2519596 and statementid  = 139991229
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 2542851 and statementid  = 140011745
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 2910893 and statementid  = 140340648
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 3370000 and statementid  = 140443329
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 3986127 and statementid  = 140586563
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 3999025 and statementid  = 140594161
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 4048770 and statementid  = 140600453
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 4584526 and statementid  = 140825343
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 4654918 and statementid  = 140855405
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 4805172 and statementid  = 140956673
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 6418651 and statementid  = 141206368
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 8184658 and statementid  = 141343655
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 8300099 and statementid  = 141370639
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 10650147 and statementid  = 141672227
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 12376716 and statementid  = 141981952
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 12742380 and statementid  = 142089462
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 13055371 and statementid  = 142273417
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 13077329 and statementid  = 142270193
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 13692168 and statementid  = 142445684
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 16960702 and statementid  = 142965551
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 17314443 and statementid  = 143071359
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 17652762 and statementid  = 143177399
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 17724590 and statementid  = 143232539
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 17973067 and statementid  = 143294131
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 18274033 and statementid  = 143437804
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 18299694 and statementid  = 143462390
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 19352418 and statementid  = 143718732
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 20603004 and statementid  = 143951660
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 21441961 and statementid  = 144153236
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 21532022 and statementid  = 144215545
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 21592896 and statementid  = 144264128
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 21796112 and statementid  = 144357764
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 21854422 and statementid  = 144391145
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 21870512 and statementid  = 144401728
update    top(1)  statementheader   set   CycleDueDTD = 1   where   acctid  = 21915975 and statementid  = 144434554

update      top(1) summaryheadercreditcard    set   srbwithinstallmentdue  = 0 , sbwithinstallmentdue = 0 , currentdue= 0   ,  amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,cycleduedtd = 0         where   acctId  = 2733146 and statementid  = 140090439
update      top(1) summaryheadercreditcard    set   srbwithinstallmentdue  = 0 , sbwithinstallmentdue = 0 , currentdue= 0   ,  amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,cycleduedtd = 0         where   acctId  = 3225308 and statementid  = 140335090
update      top(1) summaryheadercreditcard    set   srbwithinstallmentdue  = 0 , sbwithinstallmentdue = 0 , currentdue= 0   ,  amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,cycleduedtd = 0         where   acctId  = 18011119 and statementid  = 140335090

update     top(1)   summaryheader    set   amountoftotaldue  = 0     where   acctId  = 2733146 and statementid  = 140090439
update     top(1)   summaryheader    set   amountoftotaldue  = 0     where   acctId  = 3225308 and statementid  = 140335090
update     top(1)   summaryheader    set   amountoftotaldue  = 0     where   acctId  = 18011119 and statementid  = 140335090

update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 475120 and statementid  = 138276130
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 1342531 and statementid  = 138832163
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 1602015 and statementid  = 139123128
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 1604745 and statementid  = 139127600
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 25700381 and statementid  = 139433316
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 2127279 and statementid  = 139573835
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 2294290 and statementid  = 139728282
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 2530119 and statementid  = 139923187
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 12720403 and statementid  = 139573835
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 28985519 and statementid  = 139433316
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 28985520 and statementid  = 139433316
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 28985521 and statementid  = 139433316
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 79884201 and statementid  = 138343633
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 2617816 and statementid  = 139991229
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 3221043 and statementid  = 140340648
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 3972150 and statementid  = 140443329
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 5216277 and statementid  = 140586563
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 5409175 and statementid  = 140594161
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 6483899 and statementid  = 139991229
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 8572684 and statementid  = 140825343
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 9989330 and statementid  = 140956673
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 15628809 and statementid  = 141206368
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 27133159 and statementid  = 141672227
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 28985522 and statementid  = 139433316
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 28987538 and statementid  = 139433316
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 28987539 and statementid  = 139433316
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 28987540 and statementid  = 139433316
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 31563352 and statementid  = 139433316
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 33418826 and statementid  = 141981952
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 34249537 and statementid  = 142089462
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 35949382 and statementid  = 142273417
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 35973877 and statementid  = 142270193
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 37794545 and statementid  = 142445684
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 52582026 and statementid  = 143071359
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 53533899 and statementid  = 143071359
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 53567669 and statementid  = 142273417
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 53625077 and statementid  = 143177399
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 54767724 and statementid  = 143294131
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 56612614 and statementid  = 143462390
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 58745916 and statementid  = 143232539
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 63487452 and statementid  = 143951660
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 66102808 and statementid  = 140855405
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 67326750 and statementid  = 144264128
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 68005350 and statementid  = 144264128
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 68116238 and statementid  = 144357764
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 68224592 and statementid  = 144391145
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 72796269 and statementid  = 143462390
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 75385251 and statementid  = 142965551
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 76170736 and statementid  = 144434554
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 77238574 and statementid  = 144401728
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 78055369 and statementid  = 144153236
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 79842190 and statementid  = 140825343
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 79862137 and statementid  = 144215545
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 79866081 and statementid  = 141370639
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 79868136 and statementid  = 143718732
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 79868166 and statementid  = 140600453
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 79868181 and statementid  = 143437804
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 79884066 and statementid  = 141343655
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 80190395 and statementid  = 141206368
update      top(1) summaryheadercreditcard    set   cycleduedtd = 1 where   acctId  = 80228241 and statementid  = 141981952

update    top(1)  accountinfoforreport   set   srbwithinstallmentdue  = 0 , sbwithinstallmentdue = 0 , runningminimumdue = 0 , remainingminimumdue = 0 ,   amountoftotaldue = 0   , amtofpaycurrdue= 0   ,  amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,cycleduedtd = 0  ,DateOfOriginalPaymentDUeDTD =  null ,    daysdelinquent  = 0 , Totaldaysdelinquent = 0 , dateofdelinquency = null   where   bsacctid  = 2617166 and businessday  = '2022-03-31 23:59:57'
update    top(1)  accountinfoforreport   set   srbwithinstallmentdue  = 0 , sbwithinstallmentdue = 0 , runningminimumdue = 0 , remainingminimumdue = 0 ,   amountoftotaldue = 0   , amtofpaycurrdue= 0   ,  amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,cycleduedtd = 0  ,DateOfOriginalPaymentDUeDTD =  null ,    daysdelinquent  = 0 , Totaldaysdelinquent = 0 , dateofdelinquency = null   where   bsacctid  = 2915158 and businessday  = '2022-03-31 23:59:57'

update    top(1)  accountinfoforreport   set      amountoftotaldue = 3829.70   , amtofpaycurrdue= 3829.70   ,  amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,cycleduedtd = 1  where   bsacctid  = 566251 and businessday  = '2022-03-31 23:59:57'
update    top(1)  accountinfoforreport   set      amountoftotaldue = 1908.00   , amtofpaycurrdue= 1908.00   ,  amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,cycleduedtd = 1  where   bsacctid  = 1845119 and businessday  = '2022-03-31 23:59:57'

update    top(1)  accountinfoforreport   set   CycleDueDTD = 1  where   bsacctid  = 309744 and businessday  = '2022-03-31 23:59:57'
update    top(1)  accountinfoforreport   set   CycleDueDTD = 1  where   bsacctid  = 462900 and businessday  = '2022-03-31 23:59:57'
update    top(1)  accountinfoforreport   set   CycleDueDTD = 1  where   bsacctid  = 1129291 and businessday  = '2022-03-31 23:59:57'
update    top(1)  accountinfoforreport   set   CycleDueDTD = 1  where   bsacctid  = 1330111 and businessday  = '2022-03-31 23:59:57'
update    top(1)  accountinfoforreport   set   CycleDueDTD = 1  where   bsacctid  = 1589595 and businessday  = '2022-03-31 23:59:57'
update    top(1)  accountinfoforreport   set   CycleDueDTD = 1  where   bsacctid  = 1592325 and businessday  = '2022-03-31 23:59:57'
update    top(1)  accountinfoforreport   set   CycleDueDTD = 1  where   bsacctid  = 1948780 and businessday  = '2022-03-31 23:59:57'
update    top(1)  accountinfoforreport   set   CycleDueDTD = 1  where   bsacctid  = 2095559 and businessday  = '2022-03-31 23:59:57'
update    top(1)  accountinfoforreport   set   CycleDueDTD = 1  where   bsacctid  = 2255470 and businessday  = '2022-03-31 23:59:57'
update    top(1)  accountinfoforreport   set   CycleDueDTD = 1  where   bsacctid  = 2447179 and businessday  = '2022-03-31 23:59:57'
update    top(1)  accountinfoforreport   set   CycleDueDTD = 1  where   bsacctid  = 2519596 and businessday  = '2022-03-31 23:59:57'
update    top(1)  accountinfoforreport   set   CycleDueDTD = 1  where   bsacctid  = 2542851 and businessday  = '2022-03-31 23:59:57'
update    top(1)  accountinfoforreport   set   CycleDueDTD = 1  where   bsacctid  = 2910893 and businessday  = '2022-03-31 23:59:57'
update    top(1)  accountinfoforreport   set   CycleDueDTD = 1  where   bsacctid  = 3370000 and businessday  = '2022-03-31 23:59:57'
update    top(1)  accountinfoforreport   set   CycleDueDTD = 1  where   bsacctid  = 3986127 and businessday  = '2022-03-31 23:59:57'
update    top(1)  accountinfoforreport   set   CycleDueDTD = 1  where   bsacctid  = 3999025 and businessday  = '2022-03-31 23:59:57'
update    top(1)  accountinfoforreport   set   CycleDueDTD = 1  where   bsacctid  = 4048770 and businessday  = '2022-03-31 23:59:57'
update    top(1)  accountinfoforreport   set   CycleDueDTD = 1  where   bsacctid  = 4584526 and businessday  = '2022-03-31 23:59:57'
update    top(1)  accountinfoforreport   set   CycleDueDTD = 1  where   bsacctid  = 4654918 and businessday  = '2022-03-31 23:59:57'
update    top(1)  accountinfoforreport   set   CycleDueDTD = 1  where   bsacctid  = 4805172 and businessday  = '2022-03-31 23:59:57'
update    top(1)  accountinfoforreport   set   CycleDueDTD = 1  where   bsacctid  = 6418651 and businessday  = '2022-03-31 23:59:57'
update    top(1)  accountinfoforreport   set   CycleDueDTD = 1  where   bsacctid  = 8184658 and businessday  = '2022-03-31 23:59:57'
update    top(1)  accountinfoforreport   set   CycleDueDTD = 1  where   bsacctid  = 8300099 and businessday  = '2022-03-31 23:59:57'
update    top(1)  accountinfoforreport   set   CycleDueDTD = 1  where   bsacctid  = 10650147 and businessday  = '2022-03-31 23:59:57'
update    top(1)  accountinfoforreport   set   CycleDueDTD = 1  where   bsacctid  = 12376716 and businessday  = '2022-03-31 23:59:57'
update    top(1)  accountinfoforreport   set   CycleDueDTD = 1  where   bsacctid  = 12742380 and businessday  = '2022-03-31 23:59:57'
update    top(1)  accountinfoforreport   set   CycleDueDTD = 1  where   bsacctid  = 13055371 and businessday  = '2022-03-31 23:59:57'
update    top(1)  accountinfoforreport   set   CycleDueDTD = 1  where   bsacctid  = 13077329 and businessday  = '2022-03-31 23:59:57'
update    top(1)  accountinfoforreport   set   CycleDueDTD = 1  where   bsacctid  = 13692168 and businessday  = '2022-03-31 23:59:57'
update    top(1)  accountinfoforreport   set   CycleDueDTD = 1  where   bsacctid  = 16960702 and businessday  = '2022-03-31 23:59:57'
update    top(1)  accountinfoforreport   set   CycleDueDTD = 1  where   bsacctid  = 17314443 and businessday  = '2022-03-31 23:59:57'
update    top(1)  accountinfoforreport   set   CycleDueDTD = 1  where   bsacctid  = 17652762 and businessday  = '2022-03-31 23:59:57'
update    top(1)  accountinfoforreport   set   CycleDueDTD = 1  where   bsacctid  = 17724590 and businessday  = '2022-03-31 23:59:57'
update    top(1)  accountinfoforreport   set   CycleDueDTD = 1  where   bsacctid  = 17973067 and businessday  = '2022-03-31 23:59:57'
update    top(1)  accountinfoforreport   set   CycleDueDTD = 1  where   bsacctid  = 18274033 and businessday  = '2022-03-31 23:59:57'
update    top(1)  accountinfoforreport   set   CycleDueDTD = 1  where   bsacctid  = 18299694 and businessday  = '2022-03-31 23:59:57'
update    top(1)  accountinfoforreport   set   CycleDueDTD = 1  where   bsacctid  = 19352418 and businessday  = '2022-03-31 23:59:57'
update    top(1)  accountinfoforreport   set   CycleDueDTD = 1  where   bsacctid  = 20603004 and businessday  = '2022-03-31 23:59:57'
update    top(1)  accountinfoforreport   set   CycleDueDTD = 1  where   bsacctid  = 21441961 and businessday  = '2022-03-31 23:59:57'
update    top(1)  accountinfoforreport   set   CycleDueDTD = 1  where   bsacctid  = 21532022 and businessday  = '2022-03-31 23:59:57'
update    top(1)  accountinfoforreport   set   CycleDueDTD = 1  where   bsacctid  = 21592896 and businessday  = '2022-03-31 23:59:57'
update    top(1)  accountinfoforreport   set   CycleDueDTD = 1  where   bsacctid  = 21796112 and businessday  = '2022-03-31 23:59:57'
update    top(1)  accountinfoforreport   set   CycleDueDTD = 1  where   bsacctid  = 21854422 and businessday  = '2022-03-31 23:59:57'
update    top(1)  accountinfoforreport   set   CycleDueDTD = 1  where   bsacctid  = 21870512 and businessday  = '2022-03-31 23:59:57'
update    top(1)  accountinfoforreport   set   CycleDueDTD = 1  where   bsacctid  = 21915975 and businessday  = '2022-03-31 23:59:57'

update   top(1)   planinfoforreport   set   srbwithinstallmentdue  = 0 , sbwithinstallmentdue = 0  ,amountoftotaldue = 0   , amtofpaycurrdue= 0   ,  amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,cycleduedtd = 0    where   cpsacctid  = 2733146 and businessday  = '2022-03-31 23:59:57'
update   top(1)   planinfoforreport   set   srbwithinstallmentdue  = 0 , sbwithinstallmentdue = 0  ,amountoftotaldue = 0   , amtofpaycurrdue= 0   ,  amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,cycleduedtd = 0    where   cpsacctid  = 3225308 and businessday  = '2022-03-31 23:59:57'
update   top(1)   planinfoforreport   set   srbwithinstallmentdue  = 0 , sbwithinstallmentdue = 0  ,amountoftotaldue = 0   , amtofpaycurrdue= 0   ,  amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,cycleduedtd = 0    where   cpsacctid  = 18011119 and businessday  = '2022-03-31 23:59:57'

update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 475120 and businessday  = '2022-03-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 1342531 and businessday  = '2022-03-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 1602015 and businessday  = '2022-03-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 1604745 and businessday  = '2022-03-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 25700381 and businessday  = '2022-03-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 2127279 and businessday  = '2022-03-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 2294290 and businessday  = '2022-03-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 2530119 and businessday  = '2022-03-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 12720403 and businessday  = '2022-03-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 28985519 and businessday  = '2022-03-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 28985520 and businessday  = '2022-03-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 28985521 and businessday  = '2022-03-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 79884201 and businessday  = '2022-03-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 2617816 and businessday  = '2022-03-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 3221043 and businessday  = '2022-03-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 3972150 and businessday  = '2022-03-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 5216277 and businessday  = '2022-03-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 5409175 and businessday  = '2022-03-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 6483899 and businessday  = '2022-03-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 8572684 and businessday  = '2022-03-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 9989330 and businessday  = '2022-03-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 15628809 and businessday  = '2022-03-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 27133159 and businessday  = '2022-03-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 28985522 and businessday  = '2022-03-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 28987538 and businessday  = '2022-03-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 28987539 and businessday  = '2022-03-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 28987540 and businessday  = '2022-03-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 31563352 and businessday  = '2022-03-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 33418826 and businessday  = '2022-03-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 34249537 and businessday  = '2022-03-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 35949382 and businessday  = '2022-03-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 35973877 and businessday  = '2022-03-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 37794545 and businessday  = '2022-03-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 52582026 and businessday  = '2022-03-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 53533899 and businessday  = '2022-03-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 53567669 and businessday  = '2022-03-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 53625077 and businessday  = '2022-03-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 54767724 and businessday  = '2022-03-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 56612614 and businessday  = '2022-03-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 58745916 and businessday  = '2022-03-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 63487452 and businessday  = '2022-03-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 66102808 and businessday  = '2022-03-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 67326750 and businessday  = '2022-03-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 68005350 and businessday  = '2022-03-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 68116238 and businessday  = '2022-03-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 68224592 and businessday  = '2022-03-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 72796269 and businessday  = '2022-03-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 75385251 and businessday  = '2022-03-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 76170736 and businessday  = '2022-03-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 77238574 and businessday  = '2022-03-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 78055369 and businessday  = '2022-03-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 79842190 and businessday  = '2022-03-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 79862137 and businessday  = '2022-03-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 79866081 and businessday  = '2022-03-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 79868136 and businessday  = '2022-03-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 79868166 and businessday  = '2022-03-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 79868181 and businessday  = '2022-03-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 79884066 and businessday  = '2022-03-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 80190395 and businessday  = '2022-03-31 23:59:57'
update   top(1)   planinfoforreport   set   cycleduedtd = 1    where   cpsacctid  = 80228241 and businessday  = '2022-03-31 23:59:57'

