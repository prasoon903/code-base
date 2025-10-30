-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION

	-- UPDATE WILL BE 1 row each

	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 1.56, AmtOfPayCurrDue = AmtOfPayCurrDue + 1.56 WHERE acctId = 23190458   -- AccountID: 758374
	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 1004342178 AND AID = 23190458
	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29896099885 AND acctId = 23190458

	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 6.20, AmtOfPayCurrDue = AmtOfPayCurrDue + 6.20, CycleDueDTD = 1 WHERE acctId = 10948807   -- AccountID: 4959473
	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 1005449232 AND AID = 10948807
	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 1005449233 AND AID = 10948807
	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29903101661 AND acctId = 10948807

	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 26.20, AmtOfPayCurrDue = AmtOfPayCurrDue + 26.20, CycleDueDTD = 1 WHERE acctId = 10948808   -- AccountID: 4959473
	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 1005449234 AND AID = 10948808
	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 1005449235 AND AID = 10948808
	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29903101662 AND acctId = 10948808

	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 1.56, AmtOfPayCurrDue = AmtOfPayCurrDue + 1.56 WHERE acctId = 23230545   -- AccountID: 758374
	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 1004342179 AND AID = 23230545
	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29896099886 AND acctId = 23230545

	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 5.97, AmtOfPayCurrDue = AmtOfPayCurrDue + 5.97 WHERE acctId = 19117218   -- AccountID: 1728411
	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 1003256324 AND AID = 19117218
	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29888897158 AND acctId = 19117218

	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 5.97, AmtOfPayCurrDue = AmtOfPayCurrDue + 5.97 WHERE acctId = 19117219   -- AccountID: 1728411
	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 1003256325 AND AID = 19117219
	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29888897159 AND acctId = 19117219

	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 5.97, AmtOfPayCurrDue = AmtOfPayCurrDue + 5.97 WHERE acctId = 19119220   -- AccountID: 1728411
	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 1003256326 AND AID = 19119220
	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29888897156 AND acctId = 19119220

	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 5.97, AmtOfPayCurrDue = AmtOfPayCurrDue + 5.97 WHERE acctId = 19119221   -- AccountID: 1728411
	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 1003256330 AND AID = 19119221
	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29888897157 AND acctId = 19119221

	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 0.30, AmtOfPayCurrDue = AmtOfPayCurrDue - 0.30 WHERE acctId = 22629289   -- AccountID: 2356186

	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 0.30, AmtOfPayCurrDue = AmtOfPayCurrDue - 0.30 WHERE acctId = 22629290   -- AccountID: 2356186

	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 0.05, AmtOfPayCurrDue = AmtOfPayCurrDue - 0.05 WHERE acctId = 23212742   -- AccountID: 2263476

	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 0.09, AmtOfPayCurrDue = AmtOfPayCurrDue + 0.09 WHERE acctId = 22797294   -- AccountID: 9155985
	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 1003997013 AND AID = 22797294
	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29893852677 AND acctId = 22797294

	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 5.97, AmtOfPayCurrDue = AmtOfPayCurrDue + 5.97 WHERE acctId = 23828941   -- AccountID: 1728411
	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 1003256332 AND AID = 23828941
	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29888897160 AND acctId = 23828941

	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 5.97, AmtOfPayCurrDue = AmtOfPayCurrDue + 5.97 WHERE acctId = 23828942   -- AccountID: 1728411
	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 1003256333 AND AID = 23828942
	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29888897161 AND acctId = 23828942


COMMIT TRANSACTION
-- ROLLBACK TRANSACTION

/*

SELECT * FROM CurrentBalanceAuditPS WITH (NOLOCK)
WHERE DENAME IN (200, 115)
--AND AID IN (10279455,12711146,12711147,12754492,17634551,17634552,22697850,23187753,23419518,23485181)
AND aid IN (12711146, 12711147, 17634552, 17634551, 23419518, 23485181)
AND Businessday > '2020-07-31 23:59:57.000'

SELECT * FROM CurrentBalanceAuditPS WITH (NOLOCK) 
WHERE IdentityField IN (984445369,984445370,984445371,984445372,984445375,984445376,984445377,984445378,984445380,984445381) AND 
aid IN (12711146, 12711147, 17634552, 17634551, 23419518, 23485181)

SELECT AmountOfTotalDue, AmtOfPayCurrDue, CycleDueDTD FROM CPSgmentCreditCard WITH (NOLOCK) WHERE acctId = 10770902
SELECT AmtOfPayCurrDue FROM PlanDelinquencyRecord WITH (NOLOCK) WHERE TranID = 29463027338 AND acctId = 10770902
SELECT * FROM CurrentBalanceAuditPS WITH (NOLOCK) WHERE IdentityField = 944519584 AND aid = 10770902

SELECT AmountOfTotalDue, AmtOfPayCurrDue, CycleDueDTD FROM CPSgmentCreditCard WITH (NOLOCK) WHERE acctId = 2015376
SELECT * FROM CurrentBalanceAuditPS WITH (NOLOCK) WHERE IdentityField = 943561653 AND aid = 2015376
SELECT AmtOfPayCurrDue FROM PlanDelinquencyRecord WITH (NOLOCK) WHERE TranID = 29456909625 AND acctId = 2015376

*/