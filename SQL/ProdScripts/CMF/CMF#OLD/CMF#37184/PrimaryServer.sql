-- TO BE RUN ON PRIMARY SERVER ONLY
USE CCGS_CoreIssue
GO

BEGIN TRAN
	UPDATE BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 23.64 WHERE acctId = 790482
	-- 1 row update

	UPDATE BSegment_Primary SET CycleDueDTD = 0, AmtofpayCurrDue = AmtofpayCurrDue - 23.64 WHERE acctId = 790482
	-- 1 row update

	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 23.64, AmtOfPayCurrDue = AmtOfPayCurrDue - 23.64, CycleDueDTD = 0 WHERE acctId = 802892 
	-- 1 row update

	DELETE FROM CurrentBalanceAudit WHERE aid = 790482 AND IdentityField IN (374132515, 374132516)
	-- 2 row delete

	DELETE FROM CurrentBalanceAuditPS WHERE aid = 802892 AND IdentityField IN (609205381, 609205382)
	-- 2 row delete

	-----------------------

	UPDATE BSegmentCreditCard SET dtoflastdelinqctd = '2020-02-29 00:00:00' WHERE acctId = 1185600
	-- 1 row update

	-----------------------

	UPDATE BSegmentCreditCard SET dtoflastdelinqctd = NULL WHERE acctId = 1212683
	-- 1 row update

	-----------------------

	UPDATE BSegmentCreditCard SET dtoflastdelinqctd = '2020-02-29 00:00:00' WHERE acctId = 1218755
	-- 1 row update

	-----------------------

	UPDATE BSegmentCreditCard SET SRBWithInstallmentDue = SRBWithInstallmentDue + 0.01 WHERE acctId = 2144301 
	--1 row update

	UPDATE CurrentBalanceAudit SET newvalue = '49.09' WHERE aid = 2144301 AND IdentityField = 360521532
	-- 1 row update

	-----------------------

	UPDATE BSegmentCreditCard SET dtoflastdelinqctd = '2020-02-29 00:00:00' WHERE acctId = 3866773
	-- 1 row update

	-----------------------

	UPDATE BSegmentCreditCard SET dtoflastdelinqctd = '2020-02-29 00:00:00' WHERE acctId = 4078987
	-- 1 row update

	-----------------------

	UPDATE BSegmentCreditCard SET SRBWithInstallmentDue = SRBWithInstallmentDue + 1.95 WHERE acctId = 4261938 
	--1 row update

	UPDATE CurrentBalanceAudit SET newvalue = '49.82' WHERE aid = 4261938 AND IdentityField = 372220757
	-- 1 row update

	-----------------------

	UPDATE BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 2.25, RunningMinimumDue = RunningMinimumDue - 2.25, RemainingMinimumDue = RemainingMinimumDue - 2.25, FirstDueDate = NULL WHERE acctId = 540227
	-- 1 row update

	UPDATE BSegment_Primary SET CycleDueDTD = 0, AmtofpayCurrDue = AmtofpayCurrDue - 2.25 WHERE acctId = 540227
	-- 1 row update

	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 2.25, AmtOfPayCurrDue = AmtOfPayCurrDue - 2.25, CycleDueDTD = 0 WHERE acctId = 2477564 
	-- 1 row update

	UPDATE PlanDelinquencyRecord SET AmtOfPayCurrDue = AmtOfPayCurrDue + 2.25, AmtOfPayXDLate = AmtOfPayXDLate - 2.25 WHERE acctId = 2477564 AND TranId = 26965181911
	-- 1 row update

	UPDATE DelinquencyRecord SET AmtOfPayCurrDue = AmtOfPayCurrDue + 2.25 WHERE acctId = 540227 AND TranId = 26966747827
	-- 1 row update

	UPDATE CurrentBalanceAudit SET newvalue = '0.00' WHERE AID = 540227 AND IdentityField = 373864821
	-- 1 row update

	INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES 
	(26966747827, '2020-04-27 06:05:17.000', 51, 540227, 115, '1', '0')
	-- 1 row update

	INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES 
	(26966747827, '2020-04-27 06:05:17.000', 52, 2477564, 115, '1', '0'),
	(26966747827, '2020-04-27 06:05:17.000', 52, 2477564, 200, '2.25', '0.00')
	-- 2 row update

	-----------------------

	UPDATE BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 0.40, RunningMinimumDue = RunningMinimumDue - 0.40, RemainingMinimumDue = RemainingMinimumDue - 0.40, FirstDueDate = NULL WHERE acctId = 2658517
	-- 1 row update

	UPDATE BSegment_Primary SET CycleDueDTD = 0, AmtofpayCurrDue = AmtofpayCurrDue - 0.40 WHERE acctId = 2658517
	-- 1 row update

	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 0.40, AmtOfPayCurrDue = AmtOfPayCurrDue - 0.40, CycleDueDTD = 0 WHERE acctId = 12784488 
	-- 1 row update

	UPDATE PlanDelinquencyRecord SET AmtOfPayCurrDue = AmtOfPayCurrDue + 0.40, AmtOfPayXDLate = AmtOfPayXDLate - 0.40 WHERE acctId = 12784488 AND TranId = 26790539419
	-- 1 row update

	UPDATE DelinquencyRecord SET AmtOfPayCurrDue = AmtOfPayCurrDue + 0.40 WHERE acctId = 2658517 AND TranId = 26790539406
	-- 1 row update

	UPDATE CurrentBalanceAudit SET newvalue = '0.00' WHERE AID = 2658517 AND IdentityField = 361983115
	-- 1 row update

	INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES 
	(26790539406, '2020-04-17 18:23:17.000', 51, 2658517, 115, '1', '0')
	-- 1 row update

	INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES 
	(26790539406, '2020-04-17 18:23:17.000', 52, 12784488, 115, '1', '0'),
	(26790539406, '2020-04-17 18:23:17.000', 52, 12784488, 200, '0.40', '0.00')
	-- 2 row update

	-----------------------

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