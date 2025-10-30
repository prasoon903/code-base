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



UPDATE TOP(1) BSegmentCreditCard SET DtOfLastDelinqCTD = NULL, daysdelinquent = 0 WHERE acctId = 9745940


UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 0 WHERE acctId = 600732

UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 0 WHERE acctId = 11208890
