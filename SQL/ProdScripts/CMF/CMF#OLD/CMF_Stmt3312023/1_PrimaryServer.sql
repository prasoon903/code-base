BEGIN TRAN
--COMMIT TRAN
--ROLLBACK TRAN


UPDATE TOP(1) BSegmentCreditCard SET AutoInitialChargeOffReason = '1' WHERE AcctID = 11537492

UPDATE TOP(1) BSegment_Primary SET tpyBlob = NULL, tpyLAD = NULL, tpyNAD = NULL WHERE AcctID = 11537492


UPDATE TOP(1) StatementHeader SET AutoInitialChargeOffReason = '1' WHERE BSAcctID = 11537492 AND StatementDate = '2023-03-31 23:59:57'