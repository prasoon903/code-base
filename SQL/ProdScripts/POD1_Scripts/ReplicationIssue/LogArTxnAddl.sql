 select * into  LogArTxnAddl  from coreissue_snapshot_snap_221001.dbo.LogArTxnAddl with(nolock)
where 1 = 2
-- use coreissue_snapshot_snap_221001
--Drop table if exists #Missingccard
--create table  #Missingccard ( TranID   decimal(19,0), ArTxnType CHAR(4), status varchar(10) default 'New')

insert into #Missingccard(TranID, ArTxnType)
select CP.TranID, CP.ArTxnType from coreissue_snapshot_snap_221001..LogArTxnAddl  cp  with(nolock) 
where cp.RowCreatedDate >'2022-09-29 05:59:57'  and cp.RowCreatedDate <  '2022-09-30 11:59:57'
Except
select CP.TranID, CP.ArTxnType  from Temp_P1MarProdDb02.CCGS_RPT_CoreIssue.dbo.LogArTxnAddl cp with(nolock) 
where cp.RowCreatedDate >'2022-09-29 05:59:57'  and cp.RowCreatedDate <  '2022-09-30 11:59:57'

select count(1) from  #Missingccard

--UPDATE  #Missingccard SET Status = 'New' WHERE Status = 'Done'

Create nonclustered index ccardsecTemp4 on #Missingccard (TranID, ArTxnType, status) 

===============================================================================


declare @C int = 0
select @C = Count(1) from #Missingccard where status = 'New' 
drop table if exists #T
Create table #T (TranID   decimal(19,0), ArTxnType CHAR(4))
while (@c > 0)
begin 
	
	truncate table #T
	insert into #T (TranID, ArTxnType) select top 100000 TranID, ArTxnType from #Missingccard where status = 'New'
	
	Insert into LogArTxnAddl 	
	select CB.*  
	From  coreissue_snapshot_snap_221001..LogArTxnAddl CB with(nolock)
	JOIN  #T T ON (CB.TranID = T.TranID AND CB.ArTxnType = T.ArTxnType)
	

	update M
	SET status = 'done'
	FROM #Missingccard M
	JOIN #T T ON (M.TranID = T.TranID AND M.ArTxnType = T.ArTxnType)

	select @C = Count(1) from #Missingccard where status = 'New'
	
END