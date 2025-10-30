
--- script need  to  run on ccgs_coreissue  primary  database  plat production  pod1

Begin Tran

--commit 
--rollback
update  top(1) BSegment_Primary   set  amountoftotaldue  =  amountoftotaldue  + 9.32   where acctid    =  1742986
update  top(1) BSegmentCreditCard   set  AmountOfPayment90DLate  =  AmountOfPayment90DLate  + 9.32   where acctid    =  1742986
update  top(1) AccountInfoForReport   set  amountoftotaldue  =  amountoftotaldue  + 9.32 ,
AmountOfPayment90DLate  =  AmountOfPayment90DLate  + 9.32  where BSAcctid    =  1742986 and  BusinessDay = '2021-07-01 23:59:57'
