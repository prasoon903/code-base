begin  Tran 
	update  ILPScheduleDetailSummary   set jobstatus  =1   where   scheduleid  in (1107158,2674652,2674752,1159340)
	-- 4 rows update
Commit 
--rollback