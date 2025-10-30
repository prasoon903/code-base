use CCGS_CoreIssue

select COUNT(1) AS NumberOfAccounts,InstitutionID, BillingCycle, getdate() from bsegment_primary with (nolock)
group by InstitutionID, BillingCycle
having InstitutionID = 6981
order by InstitutionID, BillingCycle 

select *from Commontnp with(nolock) where trantime < getdate() order by trantime

select COUNT(1) from Commontnp with(nolock) where trantime < getdate()

select * from Errortnp with(nolock)

select avg(cast(apitooktime as money)) AvgTime, convert(varchar,ResponseDate,101) Date, count(1) Count from AutoRedemMMSResponseLog with(nolock)
Where ResponseDate > '08/01/2019'
group by convert(varchar,ResponseDate,101)
order by convert(varchar,ResponseDate,101) desc

select convert(varchar,PostTIme,101), count(1) from ccard_primary with(nolock)
Where PostTIme > '08/01/2019' and cmttrantype = '40' and artxnType = '91'
group by convert(varchar,PostTIme,101)
order by convert(varchar,PostTIme,101) desc


select convert(varchar,PostTIme,101) , count(1) from ccgs_coreauth..coreauthtransactions with(nolock)
Where PostTIme > '08/01/2019' --and cmttrantype = '40' and artxnType = '91'
group by convert(varchar,PostTIme,101)
order by convert(varchar,PostTIme,101) desc


declare  @tempcount  table (count1  decimal(19,0),logdate  datetime)
insert into  @tempcount
select count(1) as Count1,getdate()   from commontnp with(nolock) where tranid > 0  and trantime < getdate()
waitfor delay '00:01:00' 
insert @tempcount 
select - count(1),getdate() from commontnp with(nolock) where tranid > 0 and trantime < getdate()
select getdate()


select * from  @tempcount
select sum(Count1)  as TPM from @tempcount
select sum(Count1)/60.0  as TPS from @tempcount 


 with cte
 as
 (
 select  apicode,apitooktime,apiname, requestdate , accountnumber ,source,usrid,responsemessage,hostmachinename, rank() over( partition by apicode order by apitooktime  desc) as rank1   from  tcivrrequest t  with(nolock)   join apimaster a with(nolock) on (t.requestname = a.apicode)
 where requestdate  > '2019-08-20 08:39:36.190' and  requestdate  >= dateadd(hour,-12,requestdate) and apitooktime > 0 
 )
 select * from cte where rank1 <6  order by apicode desc ,apitooktime desc