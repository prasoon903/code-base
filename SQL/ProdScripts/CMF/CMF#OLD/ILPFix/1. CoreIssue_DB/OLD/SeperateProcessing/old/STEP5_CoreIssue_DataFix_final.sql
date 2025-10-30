
BEGIN TRANSACTION
 
	update  TEMP_ILPDetails  set  jobstatus  = -2  where jobstatus =1
	-- rows 3000 
	

COMMIT 
--ROLLBACK 

-- After above commit  please run below exec 

exec  USP_FixILPSchedules  2901,1