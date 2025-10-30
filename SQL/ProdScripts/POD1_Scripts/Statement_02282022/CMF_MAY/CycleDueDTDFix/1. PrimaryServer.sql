-- TO BE RUN ON PRIMARY SERVER ONLY



USE CCGS_CoreIssue
GO


BEGIN TRANSACTION
--COMMIT TRANSACTION
-- ROLLBACK TRANSACTION


UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0 WHERE acctId = 39005821
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0 WHERE acctId = 37713481
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0 WHERE acctId = 1412633
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0 WHERE acctId = 1653314
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0 WHERE acctId = 30660578
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0 WHERE acctId = 23277702

UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0 WHERE acctId = 39005821 AND StatementID = 77766239
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0 WHERE acctId = 37713481 AND StatementID = 77834047
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0 WHERE acctId = 1412633  AND StatementID = 74447759
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0 WHERE acctId = 1653314  AND StatementID = 74637804
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0 WHERE acctId = 30660578 AND StatementID = 77228626
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0 WHERE acctId = 23277702 AND StatementID = 76854426
