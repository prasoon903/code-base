BEGIN TRAN
--COMMIT TRAN
--ROLLBACK TRAN

--UPDATE TransactionCreationTempData SET JobStatus = -1 WHERE JobStatus = 0

DELETE FROM PurchaseReversalRecord WHERE parent02AID = 4708461