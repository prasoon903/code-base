
--select sentflag,sentflag2,* from ls_proddrgsdb01.ccgs_coreissue.dbo.updatecallrequest with(nolock) where requestid = 3410619541

BEGIN TRANSACTION

UPDATE updatecallrequest SET sentflag = 6 where requestid = 3410619541

-- 1 row updated.

--COMMIT
--ROLLBACK
