-- select * into  Trans_In_Acct  from coreissue_snapshot_snap_221001.dbo.Trans_In_Acct with(nolock)
--where 1 = 2
-- use coreissue_snapshot_snap_221001
--Drop table if exists #Missingccard
--create table  #Missingccard ( tranid   decimal(19,0), status varchar(10) default 'New')
--create table  #Missingccard ( acctId Int, tran_id_index decimal(19, 0), tran_id_table int, ATID int, tran_state int, RowCreatedDate DATETIME, status varchar(10) default 'New')




insert into #Missingccard(ATID,acctId,tran_id_table,tran_id_index,tran_state,RowCreatedDate)
select CP.* from coreissue_snapshot_snap_221001..Trans_In_Acct  cp  with(nolock) 
where cp.RowCreatedDate >'2022-09-29 05:59:57'  and cp.RowCreatedDate <  '2022-09-30 11:59:57'
Except
select CP.*  from Temp_P1MarProdDb02.CCGS_RPT_CoreIssue.dbo.Trans_In_Acct cp with(nolock) 
where cp.RowCreatedDate >'2022-09-29 05:59:57'  and cp.RowCreatedDate <  '2022-09-30 11:59:57'

--acctId, tran_id_index, tran_id_table, ATID

select count(1) from  #Missingccard WHERE Status = 'Done'

--UPDATE #Missingccard SET Status = 'New' WHERE Status = 'Done'

--16002771



Create nonclustered index ccardsecTemp5 on #Missingccard (acctId, tran_id_index, tran_id_table, ATID, status) 

===============================================================================
declare @C int = 0
select @C = Count(1) from #Missingccard where status = 'New' 
drop table if exists #T
Create table #T (acctId Int, tran_id_index decimal(19, 0), tran_id_table int, ATID int, tran_state int, RowCreatedDate DATETIME)
while (@c > 0)
begin 
	
	truncate table #T
	insert into #T(ATID,acctId,tran_id_table,tran_id_index,tran_state,RowCreatedDate) 
	select top 100000 ATID,acctId,tran_id_table,tran_id_index,tran_state,RowCreatedDate from #Missingccard where status = 'New' 
	
	Insert into Trans_In_Acct(ATID,acctId,tran_id_table,tran_id_index,tran_state,RowCreatedDate)	
	select ATID,acctId,tran_id_table,tran_id_index,tran_state,RowCreatedDate  From  #T
	

	update M
	SET status = 'done'
	FROM #Missingccard M
	JOIN #T T ON (M.acctId = T.acctId AND M.tran_id_index = T.tran_id_index AND M.tran_id_table = T.tran_id_table AND M.ATID = T.ATID)


	select @C = Count(1) from #Missingccard where status = 'New' 
	
END