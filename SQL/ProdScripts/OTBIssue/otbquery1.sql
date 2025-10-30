
SELECT pendingotb,* FROM AccountInfoForReport WITH(NOLOCK) WHERE BusinessDay > '2023-11-01 23:59:57.000' and bsacctid  = 4269669 order by businessday desc
SELECT pendingotb,* FROM AccountInfoForReport WITH(NOLOCK) WHERE BusinessDay = '2024-01-18 23:59:57.000' and bsacctid  = 11196521


select  count(1)from paymentholddetails with(nolock)  where  status = 3 and posttime >'2023-12-07 02:34:00' 
select  * from paymentholddetails with(nolock)  where  bsacctid =1172238 and posttime >'2023-12-07 02:34:00'  order by posttime  desc
select  bsacctid ,PaymentTranId,holdamount,posttime,status,originalreleasedate  into #temp1  from paymentholddetails with(nolock) 
 where  status = 3 and posttime >'2023-12-07 02:34:00'  order by posttime  desc


 select  bsacctid ,PaymentTranId,holdamount,posttime,status,originalreleasedate  into #temp1  from paymentholddetails with(nolock) 
 where  status = 3 and posttime >'2023-12-07 02:34:00'  




 select  bsacctid ,sum(holdamount)  holdamount ,sum(holdamount)  holdamountbs , sum(holdamount)  holdamountcalc into #temp5  from #temp1 with(nolock) 
 group by bsacctid 

 --update  t    set  holdamountbs = pendingotb  from   #temp5 t join bsegment_primary  bs  (nolock)  on t.bsacctid = bs.acctid 
 --update  t    set  holdamountcalc = bs.holdamount  from   #temp5 t join #temp4  bs  (nolock)  on t.bsacctid = bs.bsacctid 
 
 select  bsacctid ,PaymentTranId,holdamount,posttime,status,originalreleasedate  into #temp3  from paymentholddetails with(nolock) 
 where  status = 0 and posttime >'2023-12-07 02:34:00'  

 
 select  bsacctid ,sum(holdamount)  holdamount ,sum(holdamount)  holdamountbs  into #temp4  from #temp3 with(nolock) 
 group by bsacctid 

 select * from  #temp2
 
 select * from  #temp5 where holdamountbs <> holdamountcalc and holdamountbs > 0 


 order by posttime desc 