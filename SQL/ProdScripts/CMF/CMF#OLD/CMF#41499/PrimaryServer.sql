-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION

	-- UPDATE WILL BE 1 row each

	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 28.29, AmtOfPayCurrDue = AmtOfPayCurrDue + 28.29, CycleDueDTD = 1 WHERE acctId = 12711146
	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 8.29, AmtOfPayCurrDue = AmtOfPayCurrDue + 8.29, CycleDueDTD = 1 WHERE acctId = 12711147
	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 8.29, AmtOfPayCurrDue = AmtOfPayCurrDue + 8.29, CycleDueDTD = 1 WHERE acctId = 17634552
	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 32.20, AmtOfPayCurrDue = AmtOfPayCurrDue + 32.20 WHERE acctId = 17634551
	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 32.20, AmtOfPayCurrDue = AmtOfPayCurrDue + 32.20 WHERE acctId = 23419518
	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 26.50, AmtOfPayCurrDue = AmtOfPayCurrDue + 26.50, CycleDueDTD = 1 WHERE acctId = 23485181

	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29755200052 AND acctId = 12711146
	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29755200053 AND acctId = 12711147
	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29755200055 AND acctId = 17634551
	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29755200056 AND acctId = 23419518
	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29755200057 AND acctId = 17634552
	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29755200058 AND acctId = 23485181

	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 984445369 AND AID = 12711146
	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 984445370 AND AID = 12711146
	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 984445371 AND AID = 12711147
	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 984445372 AND AID = 12711147
	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 984445375 AND AID = 17634551
	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 984445376 AND AID = 17634552
	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 984445377 AND AID = 17634552
	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 984445378 AND AID = 23419518
	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 984445380 AND AID = 23485181
	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 984445381 AND AID = 23485181



	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 7.63, AmtOfPayCurrDue = AmtOfPayCurrDue + 7.63 WHERE acctId = 11091474

	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29764449924 AND acctId = 11091474

	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 985806897 AND AID = 11091474



	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 5.44, AmtOfPayCurrDue = AmtOfPayCurrDue + 5.44 WHERE acctId = 10036149
	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 5.44, AmtOfPayCurrDue = AmtOfPayCurrDue + 5.44 WHERE acctId = 10052434

	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29757261939 AND acctId = 10036149
	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29757261941 AND acctId = 10052434

	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 984750424 AND AID = 10036149
	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 984750434 AND AID = 10052434



	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 0.58, AmtOfPayCurrDue = AmtOfPayCurrDue + 0.58 WHERE acctId = 18897419
	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 0.58, AmtOfPayCurrDue = AmtOfPayCurrDue + 0.58 WHERE acctId = 18897420

	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29757317281 AND acctId = 18897419
	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29757317282 AND acctId = 18897420

	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 984761691 AND AID = 18897419
	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 984761692 AND AID = 18897420



	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 19.96, AmtOfPayCurrDue = AmtOfPayCurrDue + 19.96 WHERE acctId = 23200402
	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 6.50, AmtOfPayCurrDue = AmtOfPayCurrDue + 6.50, CycleDueDTD = 1 WHERE acctId = 23200403
	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 14.91, AmtOfPayCurrDue = AmtOfPayCurrDue + 14.91, CycleDueDTD = 1 WHERE acctId = 23200732
	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 10.75, AmtOfPayCurrDue = AmtOfPayCurrDue + 10.75, CycleDueDTD = 1 WHERE acctId = 23228421
	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 19.96, AmtOfPayCurrDue = AmtOfPayCurrDue + 19.96 WHERE acctId = 23228423
	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 19.96, AmtOfPayCurrDue = AmtOfPayCurrDue + 19.96 WHERE acctId = 23228424
	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 19.96, AmtOfPayCurrDue = AmtOfPayCurrDue + 19.96 WHERE acctId = 23230437
	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 10.75, AmtOfPayCurrDue = AmtOfPayCurrDue + 10.75, CycleDueDTD = 1 WHERE acctId = 23230439

	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29749875778 AND acctId = 23200402
	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29749875779 AND acctId = 23200403
	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29749875777 AND acctId = 23200732
	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29749875773 AND acctId = 23228421
	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29749875774 AND acctId = 23228423
	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29749875775 AND acctId = 23228424
	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29749875772 AND acctId = 23230437
	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29749875776 AND acctId = 23230439

	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 983723434 AND AID = 23200402
	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 983723435 AND AID = 23200403
	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 983723436 AND AID = 23200403
	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 983723437 AND AID = 23200732
	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 983723438 AND AID = 23200732
	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 983723442 AND AID = 23228421
	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 983723443 AND AID = 23228421
	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 983723444 AND AID = 23228423
	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 983723445 AND AID = 23228424
	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 983723446 AND AID = 23230437
	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 983723447 AND AID = 23230439
	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 983723448 AND AID = 23230439



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