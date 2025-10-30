USE CCGS_CoreIssue
GO

BEGIN TRANSACTION

	--UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 2.99, AmtOfPayCurrDue = AmtOfPayCurrDue + 2.99, CycleDueDTD = 1 WHERE acctId = 10770902

	--UPDATE PlanDelinquencyRecord SET AmtOfPayCurrDue = AmtOfPayCurrDue - 2.99 WHERE TranID = 29463027338 AND acctId = 10770902

	UPDATE CurrentBalanceAuditPS SET newvalue = '2.99' WHERE IdentityField = 944519584 AND aid = 10770902

	--DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 944519585 AND aid = 10770902



	--UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 5.75, AmtOfPayCurrDue = AmtOfPayCurrDue + 5.75 WHERE acctId = 2015376

	--UPDATE PlanDelinquencyRecord SET AmtOfPayCurrDue = AmtOfPayCurrDue - 5.75 WHERE TranID = 29456909625 AND acctId = 2015376

	--UPDATE CurrentBalanceAuditPS SET newvalue = '21.25' WHERE IdentityField = 943561653 AND aid = 2015376

COMMIT TRANSACTION
-- ROLLBACK TRANSACTION

/*

SELECT AmountOfTotalDue, AmtOfPayCurrDue, CycleDueDTD FROM CPSgmentCreditCard WITH (NOLOCK) WHERE acctId = 10770902
SELECT AmtOfPayCurrDue FROM PlanDelinquencyRecord WITH (NOLOCK) WHERE TranID = 29463027338 AND acctId = 10770902
SELECT * FROM CurrentBalanceAuditPS WITH (NOLOCK) WHERE IdentityField = 944519584 AND aid = 10770902

SELECT AmountOfTotalDue, AmtOfPayCurrDue, CycleDueDTD FROM CPSgmentCreditCard WITH (NOLOCK) WHERE acctId = 2015376
SELECT * FROM CurrentBalanceAuditPS WITH (NOLOCK) WHERE IdentityField = 943561653 AND aid = 2015376
SELECT AmtOfPayCurrDue FROM PlanDelinquencyRecord WITH (NOLOCK) WHERE TranID = 29456909625 AND acctId = 2015376

*/