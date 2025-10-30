-- TO BE RUN ON PRIMARY SERVER ONLY
USE CCGS_CoreIssue
GO

BEGIN TRAN

	UPDATE BSegmentCreditCard SET dtoflastdelinqctd = '2020-02-29 00:00:00' WHERE acctId = 1212683
	-- 1 row update

--COMMIT TRAN
--ROLLBACK TRAN

/*
VALIDATION


SELECT BP.CycleDueDTD, BP.AmtofpayCurrDue, BS.AmountOfTotalDue, BS.RunningMinimumDue, BS.RemainingMinimumDue, BS.FirstDueDate
FROM ls_proddrgsdb01.ccgs_coreissue.dbo.BSEGMENT_PRIMARY BP WITH(NOLOCK)
	JOIN ls_proddrgsdb01.ccgs_coreissue.dbo.BSEGMENTCREDITCARD BS WITH(NOLOCK) ON (BP.ACCTID = BS.ACCTID)
WHERE  bp.acctid = 790482

SELECT * FROM CurrentBalanceAudit WITH (NOLOCK) WHERE tid = 26966747827 AND AID = 790482
SELECT * FROM CurrentBalanceAuditPS WITH (NOLOCK) WHERE tid = 26966747827 AND AID = 2477564

SELECT AmountOfTotalDue,AmtofpayCurrDue,CycleDueDTD FROM ls_proddrgsdb01.ccgs_coreissue.dbo.CPSgmentCreditcard WITH (NOLOCK) WHERE acctId IN (2477564)


*/