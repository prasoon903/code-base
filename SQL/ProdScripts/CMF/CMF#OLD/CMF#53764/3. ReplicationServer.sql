
--- script need  to  run on ccgs_coreissue  replication  database  plat production  pod1

Begin Tran

--commit 
--rollback

update  top(1) AccountInfoForReport   set  amountoftotaldue  =  amountoftotaldue  + 4.66 ,
AmountOfPayment90DLate  =  AmountOfPayment90DLate  + 4.66  where BSAcctid    =  1742986 and  BusinessDay = '2021-07-01 23:59:57'
