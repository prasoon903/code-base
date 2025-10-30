BEGIN TRAN
--COMMIT TRAN
--ROLLBACK TRAN

UPDATE TOP(1) AccountInfoForReport SET AutoInitialChargeOffReason = '1' WHERE BSAcctID = 11537492 AND BusinessDay = '2023-03-31 23:59:57'
UPDATE TOP(1) StatementHeader SET AutoInitialChargeOffReason = '1' WHERE BSAcctID = 11537492 AND StatementDate = '2023-03-31 23:59:57'