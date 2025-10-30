-- select * into  ccardTransactionMC  from Temp_P1MarProdDb02.CCGS_RPT_CoreIssue.dbo.ccardTransactionMC with(nolock)
--where 1 = 2
-- use coreissue_snapshot_snap_221001
--Drop table if exists #Missingccard
--create table  #Missingccard ( tranid   decimal(19,0), status varchar(10))

--insert into #Missingccard(tranid )
--select cs.tranid from coreissue_snapshot_snap_221001..ccard_primary  cp  with(nolock) 
--join  coreissue_snapshot_snap_221001..ccardTransactionMC  cs  with(nolock)  on (cp.tranid  = cs.tranid )
--where cp.posttime >'2022-09-29 05:59:57'  and cp.posttime <  '2022-09-30 11:59:57'
--Except
--select cs.tranid  from Temp_P1MarProdDb02.CCGS_RPT_CoreIssue.dbo.ccard_primary cp with(nolock) 
--join  Temp_P1MarProdDb02.CCGS_RPT_CoreIssue.dbo.ccardTransactionMC  cs  with(nolock)  on (cp.tranid  = cs.tranid )
--where cp.posttime >'2022-09-29 05:59:57'  and cp.posttime <  '2022-09-30 11:59:57'

select count(1) from  #Missingccard

Create nonclustered index ccardsecTemp on #Missingccard (TranID, status) 

===============================================================================
declare @C int = 0
select @C = Count(1) from #Missingccard where status is null 
drop table if exists #T
Create table #T (TranID decimal(19,0))
while (@c > 0)
begin 
	
	truncate table #T
	insert into #T select top 100000 TranID from #Missingccard where Status is null
	
	Insert into ccardTransactionMC	
	select *  From  coreissue_snapshot_snap_221001..ccardTransactionMC with(nolock)
	where TranID  in(select TranID From #T)

	update #Missingccard SET status = 'don' where TranID in(select TranID from #T)
	select @C = Count(1) from #Missingccard where status is null
	
END