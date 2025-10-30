-- TO BE RUN ON PRIMARY SERVER ONLY
USE CCGS_CoreIssue
GO

BEGIN TRAN
	UPDATE BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 0.37, RunningMinimumDue = RunningMinimumDue - 0.37, RemainingMinimumDue = RemainingMinimumDue - 0.37, FirstDueDate = NULL WHERE acctId = 2518807
	-- 1 row update

	UPDATE BSegment_Primary SET CycleDueDTD = 0, AmtofpayCurrDue = AmtofpayCurrDue - 0.37 WHERE acctId = 2518807
	-- 1 row update

	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 0.37, AmtOfPayCurrDue = AmtOfPayCurrDue - 0.37, CycleDueDTD = 0 WHERE acctId = 6239664 
	-- 1 row update

	UPDATE CurrentBalanceAudit SET newvalue = '0.00' WHERE AID = 2518807 AND IdentityField = 358093541
	-- 1 row update

	INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES 
	(26735688747, '2020-04-14 23:06:56.000', 51, 2518807, 115, '1', '0')
	-- 1 row update

	INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES 
	(26735688747, '2020-04-14 23:06:56.000', 52, 6239664, 115, '1', '0'),
	(26735688747, '2020-04-14 23:06:56.000', 52, 6239664, 200, '0.37', '0.00')
	-- 2 row update

--COMMIT TRAN
--ROLLBACK TRAN

/*
VALIDATION


SELECT BP.CycleDueDTD, BP.AmtofpayCurrDue, BS.AmountOfTotalDue, BS.RunningMinimumDue, BS.RemainingMinimumDue, BS.FirstDueDate
FROM ls_proddrgsdb01.ccgs_coreissue.dbo.BSEGMENT_PRIMARY BP WITH(NOLOCK)
	JOIN ls_proddrgsdb01.ccgs_coreissue.dbo.BSEGMENTCREDITCARD BS WITH(NOLOCK) ON (BP.ACCTID = BS.ACCTID)
WHERE  bp.acctid = 2518807

SELECT * FROM CurrentBalanceAudit WITH (NOLOCK) WHERE tid = 26735688747 AND AID = 2518807
SELECT * FROM CurrentBalanceAuditPS WITH (NOLOCK) WHERE tid = 26735688747 AND AID = 6239664

SELECT AmountOfTotalDue,AmtofpayCurrDue,CycleDueDTD FROM ls_proddrgsdb01.ccgs_coreissue.dbo.CPSgmentCreditcard WITH (NOLOCK) WHERE acctId IN (6239664)


*/