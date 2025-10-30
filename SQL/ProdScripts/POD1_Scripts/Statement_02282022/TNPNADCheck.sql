SELECT COUNT(1) FROM CommonTNP WITH (NOLOCK) WHERE TranTime < GETDATE()


	 select  count(1) from bsegment_primary  b  with(nolock) where billingcycle = '31'


	 
	 select  count(1) from bsegment_primary  b  with(nolock)
	 join   commontnp   c  with(nolock)   on (b.acctid = c.acctid  and c.tranid =0 and c.atid = 51)
	 where b.billingcycle = '31'



	 select  count(1) from bsegment_primary  b  with(nolock)
	 join   commontnp   c  with(nolock)   on (b.acctid = c.acctid  and c.tranid =0 and c.atid = 51)
	 where b.billingcycle = '31'


	 select  * from commontnp  with(nolock)  where acctid in  (1985330)
	 4799226
6840348
927712
10886913
1369680
1985330
3054739
2410644
4120315
	 
	 select accountnumber, b.acctid , billingcycle,systemstatus,currentbalance,laststatementdate,dateofnextstmt,c.acctid  from bsegment_primary  b  with(nolock)
	 left  join   commontnp   c  with(nolock)   on (b.acctid = c.acctid  and c.tranid =0 and c.atid = 51)
	 where b.billingcycle = '31' and  c.acctid is null


	 select * from  errortnp with(nolock)