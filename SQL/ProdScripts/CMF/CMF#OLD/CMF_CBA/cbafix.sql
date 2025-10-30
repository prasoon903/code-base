

select * from  currentbalanceaudit (nolock) where businessday = '2024-02-29 23:59:58.000' and  dename = '111'
select *   into #tempcba from currentbalanceaudit (nolock) where businessday = '2024-02-29 23:59:58.000' and  dename = '111'
select * from ccard_primary (nolock)
 where  accountnumber  in 
(select accountnumber  from  #tempcba  t join bsegment_primary  b (nolock)  on t.acctid   = b.acctid )
and cmttrantype = '21' 
where 

select*  from  ccard_primary (nolock)  where  tranid in 
(select tid  from  currentbalanceaudit (nolock) where businessday = '2024-02-29 23:59:58.000' and  dename = '111')
select * from #tempcba


select *   into #tempcba1 from currentbalanceaudit (nolock) where  businessday = '2024-02-29 23:59:58.000' and  dename = '111'
alter  table  #tempcba1  add   accountnumber varchar(16)

set identity_insert #tempcba1 on 
insert into #tempcba1 (IdentityField,	tid	,businessday	,atid	,aid	,dename	,oldvalue,	newvalue,	RowCreatedDate)
select IdentityField,	tid	,businessday	,atid	,aid	,dename	,oldvalue,	newvalue,	RowCreatedDate from  currentbalanceaudit (nolock) 
where    businessday = '2024-02-29 23:59:58.000' and  dename = '111'


select  * from  currentbalanceaudit c  (nolock)  join  #tempcba1  t   on c.aid  = t.aid   and  c.newvalue = t.oldvalue   and  c.oldvalue  = t.newvalue
 where  c.businessday = '2024-02-29 23:59:57.000' and  c.dename = '111'
select IdentityField,	tid	,businessday	,atid	,aid	,dename	,oldvalue,	newvalue,	RowCreatedDate from  currentbalanceaudit (nolock) 
where    businessday = '2024-02-29 23:59:58.000' and  dename = '111'


update t
set  accountnumber  =  b.accountnumber 
  from  #tempcba1  t join bsegment_primary  b (nolock)  on t.aid   = b.acctid 

  select * from  statementheader  s (nolock)  join   
  (
  select t.aid,c.transactionamount,try_cast(t.oldvalue as money) - try_cast(t.newvalue as money) as intamount,t.oldvalue , t.newvalue from ccard_primary c  (nolock) join #tempcba1 t  on  c.accountnumber  = t.accountnumber 
  where c.cmttrantype = '02' and  c.posttime = '2024-02-29 23:59:57.000')  cba
   on   s.acctid  =  cba.aid   and  s.currentbalance  =  cba.newvalue  and  s.statementdate  = '2024-02-29 23:59:57.000'
  --and  try_cast(t.oldvalue as money) - try_cast(t.newvalue as money) <>c.transactionamount

select  *   from #tempcba1  order by aid 