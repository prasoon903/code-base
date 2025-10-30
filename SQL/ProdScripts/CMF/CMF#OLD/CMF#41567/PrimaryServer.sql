-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION

	-- UPDATE WILL BE 1 row each

	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 1.46, AmtOfPayCurrDue = AmtOfPayCurrDue + 1.46 WHERE acctId = 14318355
	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 1.46, AmtOfPayCurrDue = AmtOfPayCurrDue + 1.46 WHERE acctId = 20512033

	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29794978960 AND acctId = 14318355
	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29794978961 AND acctId = 20512033

	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 989870416 AND AID = 14318355
	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 989870417 AND AID = 20512033



	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 61.37, AmtOfPayCurrDue = AmtOfPayCurrDue + 61.37 WHERE acctId = 23513875
	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 17.91, AmtOfPayCurrDue = AmtOfPayCurrDue + 17.91, CycleDueDTD = 1 WHERE acctId = 23513876

	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29784280602 AND acctId = 23513875
	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29784280603 AND acctId = 23513876

	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 988515993 AND AID = 23513875
	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 988515994 AND AID = 23513876
	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 988515995 AND AID = 23513876



	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 0.80, AmtOfPayCurrDue = AmtOfPayCurrDue + 0.80 WHERE acctId = 11692232
	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 0.80, AmtOfPayCurrDue = AmtOfPayCurrDue + 0.80 WHERE acctId = 11658233

	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29794963646 AND acctId = 11692232
	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29794963645 AND acctId = 11658233

	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 989867853 AND AID = 11692232
	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 989867852 AND AID = 11658233



	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 1.16, AmtOfPayCurrDue = AmtOfPayCurrDue + 1.16 WHERE acctId = 10040032

	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29795024114 AND acctId = 10040032

	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 989878307 AND AID = 10040032



	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 9.42, AmtOfPayCurrDue = AmtOfPayCurrDue + 9.42 WHERE acctId = 23785707

	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29801350535 AND acctId = 23785707

	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 990794697 AND AID = 23785707



	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 1.96, AmtOfPayCurrDue = AmtOfPayCurrDue + 1.96 WHERE acctId = 10431534

	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29778210267 AND acctId = 10431534

	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 987656069 AND AID = 10431534



	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 0.10, AmtOfPayCurrDue = AmtOfPayCurrDue + 0.10 WHERE acctId = 23246523

	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29786595191 AND acctId = 23246523

	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 988874961 AND AID = 23246523



	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 1.54, AmtOfPayCurrDue = AmtOfPayCurrDue + 1.54 WHERE acctId = 20515927

	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29778079842 AND acctId = 20515927

	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 987632874 AND AID = 20515927



	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 8.15, AmtOfPayCurrDue = AmtOfPayCurrDue + 8.15 WHERE acctId = 13129208
	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 8.15, AmtOfPayCurrDue = AmtOfPayCurrDue + 8.15 WHERE acctId = 13129209

	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29801246036 AND acctId = 13129208
	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29801246037 AND acctId = 13129209

	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 990777270 AND AID = 13129208
	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 990777271 AND AID = 13129209



	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 2.52, AmtOfPayCurrDue = AmtOfPayCurrDue + 2.52 WHERE acctId = 13129092
	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 2.52, AmtOfPayCurrDue = AmtOfPayCurrDue + 2.52 WHERE acctId = 13129093
	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 2.52, AmtOfPayCurrDue = AmtOfPayCurrDue + 2.52 WHERE acctId = 23226760
	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 2.52, AmtOfPayCurrDue = AmtOfPayCurrDue + 2.52 WHERE acctId = 23226761

	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29801189845 AND acctId = 13129092
	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29801189846 AND acctId = 13129093
	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29801189847 AND acctId = 23226760
	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29801189848 AND acctId = 13129209

	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 990764620 AND AID = 13129092
	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 990764621 AND AID = 13129093
	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 990764622 AND AID = 23226760
	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 990764623 AND AID = 23226761



	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 0.44, AmtOfPayCurrDue = AmtOfPayCurrDue + 0.44 WHERE acctId = 9206342

	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29806009302 AND acctId = 9206342

	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 991487479 AND AID = 9206342



	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 1.10, AmtOfPayCurrDue = AmtOfPayCurrDue + 1.10 WHERE acctId = 23788958

	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29777969203 AND acctId = 23788958

	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 987618981 AND AID = 23788958

	INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
	VALUES
	(29771447570, '2020-08-21 06:37:02.000', 52, 3932015, 200, '23.90', '0.00'),
	(29771447570, '2020-08-21 06:37:02.000', 52, 3932015, 115, '1', '0'),
	(29771447570, '2020-08-21 06:37:02.000', 52, 3932015, 210, '46.42', '-129.22'),
	(29771447570, '2020-08-21 06:37:02.000', 52, 23942002, 200, '1.10', '0.00'),
	(29771447570, '2020-08-21 06:37:02.000', 52, 23942002, 115, '1', '0')



	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 0.18, AmtOfPayCurrDue = AmtOfPayCurrDue + 0.18 WHERE acctId = 10017683
	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 0.18, AmtOfPayCurrDue = AmtOfPayCurrDue + 0.18 WHERE acctId = 10018724

	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29805990714 AND acctId = 10017683
	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29805990716 AND acctId = 10018724

	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 991483043 AND AID = 10017683
	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 991483044 AND AID = 10018724



	UPDATE CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 1.55, AmtOfPayCurrDue = AmtOfPayCurrDue + 1.55 WHERE acctId = 23237980

	DELETE FROM PlanDelinquencyRecord WHERE TranID = 29795110297 AND acctId = 23237980

	DELETE FROM CurrentBalanceAuditPS WHERE IdentityField = 989895648 AND AID = 23237980



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