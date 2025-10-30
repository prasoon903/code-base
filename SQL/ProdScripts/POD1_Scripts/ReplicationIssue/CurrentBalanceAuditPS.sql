-- select * into  CurrentBalanceAuditPS  from coreissue_snapshot_snap_221001.dbo.CurrentBalanceAuditPS with(nolock)
--where 1 = 2
-- use coreissue_snapshot_snap_221001
--Drop table if exists #Missingccard
--create table  #Missingccard ( IdentityField   decimal(19,0), AID INT, status varchar(10) default 'New')

insert into #Missingccard(AID, IdentityField)
select CP.AID, CP.IdentityField from coreissue_snapshot_snap_221001..CurrentBalanceAuditPS  cp  with(nolock) 
where cp.RowCreatedDate >'2022-09-29 05:59:57'  and cp.RowCreatedDate <  '2022-09-30 11:59:57'
Except
select CP.AID, CP.IdentityField  from Temp_P1MarProdDb02.CCGS_RPT_CoreIssue.dbo.CurrentBalanceAuditPS cp with(nolock) 
where cp.RowCreatedDate >'2022-09-29 05:59:57'  and cp.RowCreatedDate <  '2022-09-30 11:59:57'

select count(1) from  #Missingccard
--9574577

Create nonclustered index ccardsecTemp1 on #Missingccard (AID, IdentityField, status) 

===============================================================================

SET IDENTITY_INSERT CurrentBalanceAuditPS ON 

declare @C int = 0
select @C = Count(1) from #Missingccard where status = 'New' 
drop table if exists #T
Create table #T (IdentityField   decimal(19,0), AID INT)
while (@c > 0)
begin 
	
	truncate table #T
	insert into #T(AID, IdentityField) select top 100000 AID, IdentityField from #Missingccard where status = 'New'
	
	Insert into CurrentBalanceAuditPS (IdentityField,tid,businessday,atid,aid,dename,oldvalue,newvalue,RowCreatedDate)	
	select CB.IdentityField,CB.tid,CB.businessday,CB.atid,CB.aid,CB.dename,CB.oldvalue,CB.newvalue,CB.RowCreatedDate   
	From  coreissue_snapshot_snap_221001..CurrentBalanceAuditPS CB with(nolock)
	JOIN  #T T ON (CB.AID = T.AID AND CB.IdentityField = T.IdentityField)
	

	update M
	SET status = 'done'
	FROM #Missingccard M
	JOIN #T T ON (M.AID = T.AID AND M.IdentityField = T.IdentityField)

	select @C = Count(1) from #Missingccard where status = 'New'
	
END