
BEGIN TRANSACTION
 
	update  TEMP_ILPDetails  set  jobstatus  = -3  where jobstatus =1
	-- rows 6101 
	

COMMIT 
--ROLLBACK 

-- After above commit  please run below exec 

exec  USP_FixILPSchedules  3000,1