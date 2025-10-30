-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION

	-- UPDATE WILL BE 1 row each

	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 0.05, AmtOfPayCurrDue = AmtOfPayCurrDue + 0.05 WHERE acctId = 23212742   -- AccountID: 2263476
	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 999053087 AND AID = 23212742
	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29858495955 AND acctId = 23212742

	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 0.30, AmtOfPayCurrDue = AmtOfPayCurrDue + 0.30 WHERE acctId = 22629289   -- AccountID: 2356186
	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 996758756 AND AID = 22629289
	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29844124490 AND acctId = 22629289

	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 0.30, AmtOfPayCurrDue = AmtOfPayCurrDue + 0.30 WHERE acctId = 22629290   -- AccountID: 2356186
	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 996758757 AND AID = 22629290
	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29844124491 AND acctId = 22629290

	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 0.05, AmtOfPayCurrDue = AmtOfPayCurrDue + 0.05 WHERE acctId = 23212742   -- AccountID: 2263476
	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 999053087 AND AID = 23212742
	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29858495955 AND acctId = 23212742

	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 1.63, AmtOfPayCurrDue = AmtOfPayCurrDue + 1.63 WHERE acctId = 10040886   -- AccountID: 2439106
	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 993892648 AND AID = 10040886
	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29822987716 AND acctId = 10040886

	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 1.63, AmtOfPayCurrDue = AmtOfPayCurrDue + 1.63 WHERE acctId = 10780104   -- AccountID: 2439106
	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 993892649 AND AID = 10780104
	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29822987717 AND acctId = 10780104

	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 0.22, AmtOfPayCurrDue = AmtOfPayCurrDue + 0.22 WHERE acctId = 13121436   -- AccountID: 798618
	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 996796162 AND AID = 13121436
	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29844302055 AND acctId = 13121436

	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 4.01, AmtOfPayCurrDue = AmtOfPayCurrDue + 4.01 WHERE acctId = 13129894   -- AccountID: 4924436
	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 999048080 AND AID = 13129894
	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29858477360 AND acctId = 13129894

	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 4.50, AmtOfPayCurrDue = AmtOfPayCurrDue + 4.50 WHERE acctId = 19676336   -- AccountID: 5625165
	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 993968735 AND AID = 19676336
	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29823795839 AND acctId = 19676336

	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 4.50, AmtOfPayCurrDue = AmtOfPayCurrDue + 4.50 WHERE acctId = 19686334   -- AccountID: 5625165
	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 993968736 AND AID = 19686334
	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29823795840 AND acctId = 19686334

	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 0.30, AmtOfPayCurrDue = AmtOfPayCurrDue + 0.30 WHERE acctId = 22629289   -- AccountID: 2356186
	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 996758756 AND AID = 22629289
	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29844124490 AND acctId = 22629289

	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 0.30, AmtOfPayCurrDue = AmtOfPayCurrDue + 0.30 WHERE acctId = 22629290   -- AccountID: 2356186
	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 996758757 AND AID = 22629290
	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29844124491 AND acctId = 22629290

	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 4.29, AmtOfPayCurrDue = AmtOfPayCurrDue + 4.29 WHERE acctId = 23808478   -- AccountID: 368231
	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 996766858 AND AID = 23808478
	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29844128067 AND acctId = 23808478

	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 4.29, AmtOfPayCurrDue = AmtOfPayCurrDue + 4.29 WHERE acctId = 23808479   -- AccountID: 368231
	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 996766859 AND AID = 23808479
	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29844128068 AND acctId = 23808479

	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 9.50, AmtOfPayCurrDue = AmtOfPayCurrDue + 9.50 WHERE acctId = 10432699   -- AccountID: 2799196
	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 1002181992 AND AID = 10432699
	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29880358172 AND acctId = 10432699

	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 4.51, AmtOfPayCurrDue = AmtOfPayCurrDue + 4.51 WHERE acctId = 12709326   -- AccountID: 1915302
	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 1002176864 AND AID = 12709326
	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29880324407 AND acctId = 12709326

	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 4.51, AmtOfPayCurrDue = AmtOfPayCurrDue + 4.51 WHERE acctId = 12709327   -- AccountID: 1915302
	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 1002176878 AND AID = 12709327
	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29880324408 AND acctId = 12709327

	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 1.96, AmtOfPayCurrDue = AmtOfPayCurrDue + 1.96 WHERE acctId = 13125764   -- AccountID: 5618326
	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 1000113515 AND AID = 13125764
	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29866666732 AND acctId = 13125764

	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 1.96, AmtOfPayCurrDue = AmtOfPayCurrDue + 1.96 WHERE acctId = 13125765   -- AccountID: 5618326
	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 1000113516 AND AID = 13125765
	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29866666734 AND acctId = 13125765

	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 1.99, AmtOfPayCurrDue = AmtOfPayCurrDue + 1.99 WHERE acctId = 13125769   -- AccountID: 1391236
	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 1002190286 AND AID = 13125769
	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29880430245 AND acctId = 13125769

	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 1.59, AmtOfPayCurrDue = AmtOfPayCurrDue + 1.59 WHERE acctId = 14222340   -- AccountID: 1597620
	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 1000103112 AND AID = 14222340
	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29866600407 AND acctId = 14222340

	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 0.33, AmtOfPayCurrDue = AmtOfPayCurrDue + 0.33 WHERE acctId = 16045565   -- AccountID: 730631
	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 1002198460 AND AID = 16045565
	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29880458694 AND acctId = 16045565

	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 1.18, AmtOfPayCurrDue = AmtOfPayCurrDue + 1.18 WHERE acctId = 21920937   -- AccountID: 2033030
	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 982706154 AND AID = 21920937
	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29741171952 AND acctId = 21920937

	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 4.77, AmtOfPayCurrDue = AmtOfPayCurrDue + 4.77 WHERE acctId = 22323906   -- AccountID: 835131
	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 999071885 AND AID = 22323906
	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29858614788 AND acctId = 22323906

	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 4.77, AmtOfPayCurrDue = AmtOfPayCurrDue + 4.77 WHERE acctId = 22709278   -- AccountID: 835131
	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 999071886 AND AID = 22709278
	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29858614789 AND acctId = 22709278

	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 1.18, AmtOfPayCurrDue = AmtOfPayCurrDue + 1.18 WHERE acctId = 22721743   -- AccountID: 2033030
	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 1000734025 AND AID = 22721743
	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29870549762 AND acctId = 22721743

	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 1.18, AmtOfPayCurrDue = AmtOfPayCurrDue + 1.18 WHERE acctId = 23364251   -- AccountID: 2033030
	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 1000734026 AND AID = 23364251
	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29870549763 AND acctId = 23364251

	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 0.74, AmtOfPayCurrDue = AmtOfPayCurrDue + 0.74 WHERE acctId = 23365126   -- AccountID: 2254076
	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 1000117447 AND AID = 23365126
	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29866617878 AND acctId = 23365126

	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 0.74, AmtOfPayCurrDue = AmtOfPayCurrDue + 0.74 WHERE acctId = 23365127   -- AccountID: 2254076
	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 1000117448 AND AID = 23365127
	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29866617879 AND acctId = 23365127

	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 9.50, AmtOfPayCurrDue = AmtOfPayCurrDue + 9.50 WHERE acctId = 23453046   -- AccountID: 2799196
	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 1002181996 AND AID = 23453046
	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29880358174 AND acctId = 23453046

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