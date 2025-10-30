
Select CycleDelinquent,acctid,accountnumber,* from DailyDataFeed_Multithread with (nolock) where acctid in ('10895026') -- q56

select CycleDueDtd,acctid,accountnumber,aid,ReportDate r,* from DTDTableForLTDFields with (nolock) where aid = '6981' and ReportDate = '2021-07-01 18:00:00.000' and acctid in ('10895026')


Begin Tran
update DailyDataFeed_Multithread
set CycleDelinquent = 'Current Due'
Where acctid in (10895026)
-- 1 row will be affected
-- commit
-- rollback

Begin Tran
update DTDTableForLTDFields
set CycleDueDtd = 1
Where aid = 6981 and ReportDate = '2021-07-01 18:00:00.000' and acctid in (10895026)
-- 1 row will be affected
-- commit
-- rollback