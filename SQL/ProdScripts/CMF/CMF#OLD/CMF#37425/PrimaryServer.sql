-- TO BE RUN ON PRIMARY SERVER ONLY
USE CCGS_CoreIssue
GO

BEGIN TRAN

	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 1.98, AmtOfPayCurrDue = AmtOfPayCurrDue + 1.98, CycleDueDTD = 1 WHERE acctId = 566406 
	-- 1 row update

	UPDATE PlanDelinquencyRecord SET AmtOfPayCurrDue = AmtOfPayCurrDue - 1.98 WHERE acctId = 566406 AND TranID = 27163817589
	-- 1 row update

	DELETE FROM CurrentBalanceAuditPS WHERE aid = 566406 AND IdentityField IN (633238077)
	-- 1 row delete

	UPDATE CurrentBalanceAuditPS SET newvalue = '1.98' WHERE AID = 566406 AND IdentityField = 633238076
	-- 1 row update

	--UPDATE BsegmentCreditCard SET ManualInitialChargeOffReason = '6' WHERE acctid IN (943160, 2047305)
	---- 2 rows update

	UPDATE BSegmentCreditCard SET firstduedate = '2020-05-31 23:59:57', dateoforiginalpaymentduedtd = '2020-05-31 00:00:00' WHERE acctId = 1150358
	-- 1 row update

	UPDATE BSegmentCreditCard SET firstduedate = '2020-05-31 23:59:57', dateoforiginalpaymentduedtd = '2020-05-31 00:00:00' WHERE acctId = 4680519
	-- 1 row update

--COMMIT TRAN
--ROLLBACK TRAN

/*
VALIDATION

SELECT dtoflastdelinqctd,runningminimumdue,remainingminimumdue,ltrim(rtrim(accountnumber)) AS accountnumber,chargeoffdate,
cycleduedtd,amountoftotaldue,amtofpaycurrdue,AmtOfPayXDLate,AmountOfPayment30DLate,daysdelinquent,nopaydaysdelinquent,BS.firstduedate,dateoforiginalpaymentduedtd
,Statementremainingbalance, srbwithinstallmentdue,amountofcreditsctd,BP.SYSTEMSTATUS,CCINHPARENT125AID,accountnumber,BP.ACCTID,amtofpaycurrdue,
amountoftotaldue,BP.CURRENTBALANCE,CURRENTBALANCECO,BP.PRINCIPAL,NEWTRANSACTIONSBSFC,NEWTRANSACTIONSAGG,
	NEWTRANSACTIONSACCRUED,REVOLVINGBSFC,REVOLVINGAGG,REVOLVINGACCRUED,AfterCycleRevolvBSFC
FROM ls_proddrgsdb01.ccgs_coreissue.dbo.BSEGMENT_PRIMARY BP WITH(NOLOCK)
	JOIN ls_proddrgsdb01.ccgs_coreissue.dbo.BSEGMENTCREDITCARD BS WITH(NOLOCK) ON (BP.ACCTID = BS.ACCTID)
WHERE  bp.acctid = 554186	

SELECT creditplantype,cycleduedtd,amountoftotaldue,amtofpaycurrdue,AmtOfPayXDLate,AmountOfPayment30DLate,daysdelinquent,nopaydaysdelinquent,srbwithinstallmentdue,AMOUNTOFCREDITSCTD,
	gracedaysstatus,accountgracestatus,INTERESTRATE1,CPS.ACCTID,BEGINNINGBALANCE,CURRENTBALANCE,CURRENTBALANCECO,PRINCIPAL,NEWTRANSACTIONSBSFC,NEWTRANSACTIONSAGG,
	NEWTRANSACTIONSACCRUED,REVOLVINGBSFC,REVOLVINGAGG,REVOLVINGACCRUED,AfterCycleRevolvBSFC,PRINCIPAL + PRINCIPALCO,NEWTRANSACTIONSBSFC + REVOLVINGBSFC + AfterCycleRevolvBSFC
FROM ls_proddrgsdb01.ccgs_coreissue.dbo.CPSGMENTACCOUNTS CPS WITH(NOLOCK)
	JOIN ls_proddrgsdb01.ccgs_coreissue.dbo.CPSGMENTCREDITCARD CPC WITH(NOLOCK) ON (CPS.ACCTID = CPC.ACCTID)
WHERE cps.PARENT02AID = 554186	

select * from currentbalanceaudit with(nolock) where aid = 554186 /*AND dename = 200*/ order by businessday desc, IdentityField desc
select * from currentbalanceauditPS with(nolock) where aid in(566406) /*AND dename = 200*/ order by businessday desc

select ManualInitialChargeOffReason, Chargeoffdate, bp.acctid 
from ls_proddrgsdb01.ccgs_coreissue.dbo.bsegment_primary bp with (nolock)
join ls_proddrgsdb01.ccgs_coreissue.dbo.bsegmentcreditcard bcc with (nolock) on (bp.acctid = bcc.acctid)
where systemstatus = 14 and ManualInitialChargeOffReason = '0'


*/