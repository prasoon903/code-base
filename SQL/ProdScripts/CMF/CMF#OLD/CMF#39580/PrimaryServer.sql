-- TO BE RUN ON PRIMARY SERVER ONLY
USE CCGS_CoreIssue
GO

BEGIN TRAN

	UPDATE BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 44, CycleDueDTD = 0 WHERE acctId = 612607
	-- 1 row

	UPDATE BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 44 WHERE acctId = 612607
	-- 1 row

	UPDATE DelinquencyRecord SET AmtOfPayCurrDue = AmtOfPayCurrDue + 44, AmountOfTotalDue = AmountOfTotalDue + 44 WHERE acctId = 612607 AND TranID = 28551827229
	-- 1 row

	INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES 
	(28551827229, '2020-07-01 13:04:06.000', 51, 612607, 115, '1', '0'),
	(28551827229, '2020-07-01 13:04:06.000', 51, 612607, 200, '44.00', '0.00')
	-- 2 row inserted



--COMMIT TRAN
--ROLLBACK TRAN

/*
VALIDATION

SELECT acctid,SystemStatus,AmtOfPayCurrDue, CycleDueDTD FROM ls_proddrgsdb01.ccgs_coreissue.dbo.BSegment_Primary WITH (NOLOCK) WHERE acctid = 612607
SELECT AmountOfTotalDue, AmtOfPayXDLate, RunningMinimumDue, RemainingMinimumDue, DtOfLastDelinqCTD, DaysDelinquent, FirstDueDate, DateOfOriginalPaymentDUeDTD
FROM ls_proddrgsdb01.ccgs_coreissue.dbo.BsegmentCreditCard WITH (NOLOCK) WHERE acctid = 612607

select AmtOfPayCurrDue,AmountOfTotalDue,* from ls_proddrgsdb01.ccgs_coreissue.dbo.delinquencyrecord with(nolock) WHERE acctId = 612607 AND TranID = 28551827229


*/