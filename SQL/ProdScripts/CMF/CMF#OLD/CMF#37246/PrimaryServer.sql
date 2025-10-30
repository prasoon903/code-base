-- TO BE RUN ON PRIMARY SERVER ONLY
USE CCGS_CoreIssue
GO

BEGIN TRAN

	UPDATE BsegmentCreditCard SET ManualInitialChargeOffReason = '6' WHERE acctid IN (660076, 774627, 822659, 846357, 1742844, 2526050, 2567348, 3206212)
	-- 8 rows update

--COMMIT TRAN
--ROLLBACK TRAN

/*
VALIDATION

select ManualInitialChargeOffReason, Chargeoffdate, bp.acctid 
from ls_proddrgsdb01.ccgs_coreissue.dbo.bsegment_primary bp with (nolock)
join ls_proddrgsdb01.ccgs_coreissue.dbo.bsegmentcreditcard bcc with (nolock) on (bp.acctid = bcc.acctid)
where systemstatus = 14 and ManualInitialChargeOffReason = '0'


*/