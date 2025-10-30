



USE CCGS_COREAUTH
GO


BEGIN TRANSACTION
--commit
--rollback


update bsegment_primary set systemstatus = 2, DateOfLastDelinquent = NULL where acctid = 12833157

