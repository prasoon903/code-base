Begin Tran
--commit
--rollback

update  top(1) planinfoforreport  set   amountoftotaldue  = amountoftotaldue  - 1.26,amtofpayxdlate = amtofpayxdlate  - 1.26   where  cpsacctid   = 2055616 and  businessday   = '2021-10-31 23:59:57.000'
update  top(1) accountinfoforreport  set   amountoftotaldue  = amountoftotaldue  - 1.26,amtofpayxdlate = amtofpayxdlate  - 1.26 where  
bsacctid   = 2024356 and  businessday   = '2021-10-31 23:59:57.000'


update  top(1) planinfoforreport  set   amountoftotaldue  = amountoftotaldue  - 0.08,amtofpayxdlate = amtofpayxdlate  - 0.08   where  cpsacctid   = 2743845 and  businessday   = '2021-10-31 23:59:57.000'
update  top(1) accountinfoforreport  set   amountoftotaldue  = amountoftotaldue  - 0.08,amtofpayxdlate = amtofpayxdlate  - 0.08 where  
bsacctid   = 161145 and  businessday   = '2021-10-31 23:59:57.000'

update  top(1) planinfoforreport  set   amountoftotaldue  = amountoftotaldue  - 8.08,amtofpayxdlate = amtofpayxdlate  - 8.08   where  cpsacctid   = 4497560 and  businessday   = '2021-10-31 23:59:57.000'
update  top(1) accountinfoforreport  set   amountoftotaldue  = amountoftotaldue  - 8.08,amtofpayxdlate = amtofpayxdlate  - 8.08 where  
bsacctid   = 2074418 and  businessday   = '2021-10-31 23:59:57.000'
