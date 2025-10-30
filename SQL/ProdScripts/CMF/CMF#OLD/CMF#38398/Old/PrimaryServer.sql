-- TO BE RUN ON PRIMARY SERVER ONLY
USE CCGS_CoreIssue
GO

BEGIN TRAN

	UPDATE BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 4.47, CycleDueDTD = 0 WHERE acctid = 4301354
	-- 1 rows update

	UPDATE BsegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 4.47, RemainingMinimumDue = RemainingMinimumDue - 4.47, RunningMinimumDue = RunningMinimumDue - 4.47 WHERE acctid = 4301354
	-- 1 rows update

	DELETE FROM CurrentBalanceAudit WHERE aid = 4301354 AND IdentityField IN (430244107, 430244108)
	-- 2 rows update




	UPDATE BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue + 18.17 WHERE acctid = 3791584
	-- 1 rows update

	UPDATE BsegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 18.17, RemainingMinimumDue = RemainingMinimumDue + 18.17, RunningMinimumDue = RunningMinimumDue + 18.17 WHERE acctid = 3791584
	-- 1 rows update
	
	UPDATE CurrentBalanceAudit SET NewValue = '52.74' WHERE aid = 3791584 AND IdentityField = 430239844
	-- 1 rows update


	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 8.42, AmtOfPayCurrDue = AmtOfPayCurrDue + 8.42 WHERE acctId = 4711734 
	-- 1 row update

	UPDATE CurrentBalanceAuditPS SET NewValue = '23.67' WHERE aid = 4711734 AND IdentityField = 696395839
	-- 1 rows update


	UPDATE BsegmentCreditCard SET DtOfLastDelinqCTD = '2020-04-30', DaysDelinquent = 5 WHERE acctId = 2625505
	-- 1 rows update

	UPDATE BsegmentCreditCard SET DtOfLastDelinqCTD = '2020-02-29', DaysDelinquent = 78 WHERE acctId = 2285575
	-- 1 rows update

	UPDATE BsegmentCreditCard SET DtOfLastDelinqCTD = '2020-04-30', DaysDelinquent = 26 WHERE acctId = 557976
	-- 1 rows update

--COMMIT TRAN
--ROLLBACK TRAN

/*
VALIDATION

SELECT acctid,SystemStatus,AmtOfPayCurrDue, CycleDueDTD FROM BSegment_Primary WITH (NOLOCK) WHERE acctid = 4301354
SELECT AmountOfTotalDue, RunningMinimumDue, RemainingMinimumDue FROM BsegmentCreditCard WITH (NOLOCK) WHERE acctid = 4301354

SELECT acctid,SystemStatus,AmtOfPayCurrDue, CycleDueDTD FROM BSegment_Primary WITH (NOLOCK) WHERE acctid = 3791584
SELECT AmountOfTotalDue, RunningMinimumDue, RemainingMinimumDue FROM BsegmentCreditCard WITH (NOLOCK) WHERE acctid = 3791584

SELECT LAPD, DtOfLastDelinqCTD, DaysDelinquent, DATEDIFF(DAY, '2020-04-30', LAPD) 
FROM BSegment_Primary BP WITH (NOLOCK)
JOIN BsegmentCreditCard BCC WITH (NOLOCK) ON (BP.acctId = BCC.acctId)
WHERE BP.acctid = 2625505

SELECT LAPD, DtOfLastDelinqCTD, DaysDelinquent, DATEDIFF(DAY, '2020-02-29', LAPD) 
FROM BSegment_Primary BP WITH (NOLOCK)
JOIN BsegmentCreditCard BCC WITH (NOLOCK) ON (BP.acctId = BCC.acctId)
WHERE BP.acctid = 2285575

SELECT LAPD, DtOfLastDelinqCTD, DaysDelinquent, DATEDIFF(DAY, '2020-04-30', LAPD) 
FROM BSegment_Primary BP WITH (NOLOCK)
JOIN BsegmentCreditCard BCC WITH (NOLOCK) ON (BP.acctId = BCC.acctId)
WHERE BP.acctid = 557976


*/