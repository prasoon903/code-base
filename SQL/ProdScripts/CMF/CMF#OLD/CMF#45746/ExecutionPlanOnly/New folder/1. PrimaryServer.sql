-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION
--COMMIT TRANSACTION
--ROLLBACK TRANSACTION

	-- UPDATE TOP(1) WILL BE 1 ROW EACH STATEMENT

UPDATE CCard_Primary SET PostingRef = 'Transaction posted successfully', ArTxnType = '91', TransactionAmount = 0 WHERE TranID IN (31365809577)



UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 7.5 WHERE acctId = 7912164
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 7.5, RunningMinimumDue = RunningMinimumDue - 7.5,
RemainingMinimumDue = RemainingMinimumDue - 7.5 WHERE acctId = 7912164

UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '5.47' WHERE AID = 7912164 AND ATID = 51 AND IdentityField = 894847767



--UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = AmountOfTotalDue - 6.82, AmtOfPayCurrDue = AmtOfPayCurrDue - 6.82 WHERE acctId = 14687714

--INSERT INTO CurrentBalanceAuditPS (tid, businessday, atid, aid, dename, oldvalue, newvalue)
--VALUES 
--(33026817241, '2020-12-01 21:02:37.000', 52, 14687714, 200, '6.82', '0.00'),
--(33026817241, '2020-12-01 21:02:37.000', 52, 14687714, 115, '1', '0')


--UPDATE TOP(1) BSegment_Primary SET SystemStatus = 2, CycleDueDTD = 1 WHERE acctId = 3771532
--UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 25, AmtOfPayXDLate = AmtOfPayXDLate - 25, RunningMinimumDue = RunningMinimumDue - 25,
--RemainingMinimumDue = RemainingMinimumDue - 25 WHERE acctId = 3771532

--DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 3771532 AND ATID = 51 AND IdentityField = 884337239
--DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 3771532 AND ATID = 51 AND IdentityField = 884337243
--DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 3771532 AND ATID = 51 AND IdentityField = 884337246

--UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 1, AmountOfTotalDue = AmountOfTotalDue - 25, AmtOfPayCurrDue = AmtOfPayCurrDue - 0.76, AmtOfPayXDLate = AmtOfPayXDLate - 24.24 WHERE acctId = 4691682
--UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 1, AmtOfPayCurrDue = AmtOfPayCurrDue + 0.76, AmtOfPayXDLate = AmtOfPayXDLate - 0.76 WHERE acctId = 11030594

--DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 4691682 AND ATID = 52 AND IdentityField = 1436310128
--DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 4691682 AND ATID = 52 AND IdentityField = 1436310133
--DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 11030594 AND ATID = 52 AND IdentityField = 1436310136

--UPDATE TOP(1) StatementHeader SET SystemStatus = 2, CycleDueDTD = 1, AmountOfTotalDue = AmountOfTotalDue - 25, AmtOfPayXDLate = AmtOfPayXDLate - 25, RunningMinimumDue = RunningMinimumDue - 25,
--RemainingMinimumDue = RemainingMinimumDue - 25, MinimumPaymentDue = MinimumPaymentDue - 25 WHERE acctId = 3771532 AND StatementID = 47301288

--UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue - 25 WHERE acctId = 4691682 AND StatementID = 47301288
--UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 1, CurrentDue = CurrentDue - 0.76, AmtOfPayXDLate = AmtOfPayXDLate - 24.24 WHERE acctId = 4691682 AND StatementID = 47301288

--UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 1, CurrentDue = CurrentDue + 0.76, AmtOfPayXDLate = AmtOfPayXDLate - 0.76 WHERE acctId = 11030594 AND StatementID = 47301288



UPDATE TOP(1) BSegmentCreditCard SET DtOfLastDelinqCTD = NULL, daysdelinquent = 0 WHERE acctId = 9745940

--UPDATE TOP(1) BSegmentCreditCard SET DateOfOriginalPaymentDueDTD = '2020-11-30 23:59:57.000', NoPayDaysDelinquent = 1 WHERE acctId = 1147830

UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 0 WHERE acctId = 600732

UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 0 WHERE acctId = 11208890
