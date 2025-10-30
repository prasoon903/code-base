BEGIN TRAN
--COMMIT TRAN
--ROLLBACK TRAN


UPDATE TOP(1) BSegmenCreditCard SET CurrentBalanceCO = 2946.24 WHERE acctId = 19630045

UPDATE TOP(1) CPSgmentCreditCard SET CurrentBalanceCO = 2901.02 WHERE acctId = 61132037
UPDATE TOP(1) CPSgmentAccounts SET decurrentbalance_trantime_ps = 2901.02 WHERE acctId = 61132037



UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '2946.24' WHERE AID = 19630045 AND ATID = 51 AND IdentityField = 4218792814

DELETE TOP(1) CurrentBalanceAuditPS WHERE AID = 61132037 AND ATID = 52 AND IdentityField = 7327801537



UPDATE TOP(1) AccountInfoForReport SET CurrentBalanceCO = 2946.24 WHERE BusinessDay = '2022-11-16 23:59:57' AND BSAcctID = 19630045

UPDATE TOP(1) PlanInfoForReport SET CurrentBalanceCO = 2901.02 WHERE BusinessDay = '2022-11-16 23:59:57' AND CPSAcctID = 61132037