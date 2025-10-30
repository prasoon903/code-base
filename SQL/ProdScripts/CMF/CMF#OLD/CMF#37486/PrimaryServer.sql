-- TO BE RUN ON PRIMARY SERVER ONLY
USE CCGS_CoreIssue
GO

BEGIN TRAN

	UPDATE BsegmentCreditCard SET ManualInitialChargeOffReason = '6' WHERE acctid IN (918954)
	-- 1 rows update

	UPDATE BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue + 13.64, CycleDueDTD = 1, SystemStatus = 2 WHERE acctid = 4680519
	-- 1 rows update

	UPDATE BsegmentCreditCard SET AmtOfPayXDLate = AmtOfPayXDLate - 13.64 WHERE acctid = 4680519
	-- 1 rows update

	DELETE FROM CurrentBalanceAudit WHERE aid = 4680519 AND IdentityField = 401401182
	-- 1 rows update

--COMMIT TRAN
--ROLLBACK TRAN

/*
VALIDATION

select ManualInitialChargeOffReason, Chargeoffdate, bp.acctid 
from ls_proddrgsdb01.ccgs_coreissue.dbo.bsegment_primary bp with (nolock)
join ls_proddrgsdb01.ccgs_coreissue.dbo.bsegmentcreditcard bcc with (nolock) on (bp.acctid = bcc.acctid)
where systemstatus = 14 and ManualInitialChargeOffReason = '0'

SELECT acctid,SystemStatus,AmtOfPayCurrDue, CycleDueDTD FROM BSegment_Primary WITH (NOLOCK) WHERE acctid = 4680519
SELECT AmtOfPayXDLate FROM BsegmentCreditCard WITH (NOLOCK) WHERE acctid = 4680519


*/