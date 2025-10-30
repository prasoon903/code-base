-- TO BE RUN ON PRIMARY SERVER ONLY
USE CCGS_CoreIssue
GO

BEGIN TRAN

	UPDATE BsegmentCreditCard SET ManualInitialChargeOffReason = '6' WHERE acctid IN (2299088)
	-- 1 rows update

	UPDATE BSegment_Primary SET TPYBlob = NULL, TPYLAD = NULL, TPYNAD = NULL WHERE 
	acctid IN (660076,774627,846357,943160,1742844,2567348,3206212,822659,2526050,3529045,783069, 2299088, 918954)
	-- 13 rows update

--COMMIT TRAN
--ROLLBACK TRAN

/*
VALIDATION

select ManualInitialChargeOffReason, Chargeoffdate, bp.acctid, BP.TPYBlob
from ls_proddrgsdb01.ccgs_coreissue.dbo.bsegment_primary bp with (nolock)
join ls_proddrgsdb01.ccgs_coreissue.dbo.bsegmentcreditcard bcc with (nolock) on (bp.acctid = bcc.acctid)
where systemstatus = 14 and (ManualInitialChargeOffReason = '0' OR ManualInitialChargeOffReason = '')

select ManualInitialChargeOffReason, Chargeoffdate, bp.acctid, BP.TPYBlob, TPYLAD, TPYNAD
from ls_proddrgsdb01.ccgs_coreissue.dbo.bsegment_primary bp with (nolock)
join ls_proddrgsdb01.ccgs_coreissue.dbo.bsegmentcreditcard bcc with (nolock) on (bp.acctid = bcc.acctid)
WHERE BP.acctId IN (660076,774627,846357,943160,1742844,2567348,3206212,822659,2526050,3529045,783069, 2299088, 918954)

2299088,3529045,846357,918954 -- Arun
660076,774627,846357,943160,1742844,2567348,3206212,822659,2526050,3529045,783069, 2299088, 918954 -- Yesterday


*/