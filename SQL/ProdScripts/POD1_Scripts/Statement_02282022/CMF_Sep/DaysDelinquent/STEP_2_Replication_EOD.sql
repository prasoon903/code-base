-- TO BE RUN ON REPLICATION SERVER ONLY

USE CCGS_RPT_CoreIssue
GO

BEGIN TRANSACTION
-- COMMIT TRANSACTION
-- ROLLBACK TRANSACTION


--Q18
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 30 WHERE BSAcctID = 277948 AND BusinessDay = '2021-09-30 23:59:57.000'
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 30 WHERE BSAcctID = 1035017 AND BusinessDay = '2021-09-30 23:59:57.000'
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 30 WHERE BSAcctID = 2080569 AND BusinessDay = '2021-09-30 23:59:57.000'
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 30 WHERE BSAcctID = 2116841 AND BusinessDay = '2021-09-30 23:59:57.000'
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 30 WHERE BSAcctID = 2215724 AND BusinessDay = '2021-09-30 23:59:57.000'
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 30 WHERE BSAcctID = 2234687 AND BusinessDay = '2021-09-30 23:59:57.000'
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 30 WHERE BSAcctID = 2301281 AND BusinessDay = '2021-09-30 23:59:57.000'
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 30 WHERE BSAcctID = 4520648 AND BusinessDay = '2021-09-30 23:59:57.000'
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 30 WHERE BSAcctID = 7909910 AND BusinessDay = '2021-09-30 23:59:57.000'
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 30 WHERE BSAcctID = 13947697 AND BusinessDay = '2021-09-30 23:59:57.000'
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 30 WHERE BSAcctID = 14122228 AND BusinessDay = '2021-09-30 23:59:57.000'
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 30 WHERE BSAcctID = 17743380 AND BusinessDay = '2021-09-30 23:59:57.000'


--Q26
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 61 WHERE BSAcctID = 1440067 AND BusinessDay = '2021-09-30 23:59:57.000'
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 61 WHERE BSAcctID = 2908817 AND BusinessDay = '2021-09-30 23:59:57.000'
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 61 WHERE BSAcctID = 4853815 AND BusinessDay = '2021-09-30 23:59:57.000'
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 61 WHERE BSAcctID = 4909611 AND BusinessDay = '2021-09-30 23:59:57.000'
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 61 WHERE BSAcctID = 4913824 AND BusinessDay = '2021-09-30 23:59:57.000'
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 61 WHERE BSAcctID = 6805783 AND BusinessDay = '2021-09-30 23:59:57.000'
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 61 WHERE BSAcctID = 13543464 AND BusinessDay = '2021-09-30 23:59:57.000'
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 61 WHERE BSAcctID = 15945625 AND BusinessDay = '2021-09-30 23:59:57.000'
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 61 WHERE BSAcctID = 17323865 AND BusinessDay = '2021-09-30 23:59:57.000'
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 61 WHERE BSAcctID = 277855 AND BusinessDay = '2021-09-30 23:59:57.000'
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 61 WHERE BSAcctID = 404922 AND BusinessDay = '2021-09-30 23:59:57.000'
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 61 WHERE BSAcctID = 1140904 AND BusinessDay = '2021-09-30 23:59:57.000'
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 61 WHERE BSAcctID = 1156616 AND BusinessDay = '2021-09-30 23:59:57.000'
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 61 WHERE BSAcctID = 1992621 AND BusinessDay = '2021-09-30 23:59:57.000'
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 61 WHERE BSAcctID = 2639620 AND BusinessDay = '2021-09-30 23:59:57.000'
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 61 WHERE BSAcctID = 2645992 AND BusinessDay = '2021-09-30 23:59:57.000'
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 61 WHERE BSAcctID = 2676140 AND BusinessDay = '2021-09-30 23:59:57.000'
UPDATE TOP(1) AccountInfoForReport SET DaysDelinquent =		 0  WHERE BSAcctID = 4346940 AND BusinessDay = '2021-09-30 23:59:57.000' -- Q24
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 61 WHERE BSAcctID = 6408687 AND BusinessDay = '2021-09-30 23:59:57.000'
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 61 WHERE BSAcctID = 7895161 AND BusinessDay = '2021-09-30 23:59:57.000'
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 61 WHERE BSAcctID = 10234517 AND BusinessDay = '2021-09-30 23:59:57.000'
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 61 WHERE BSAcctID = 10890281 AND BusinessDay = '2021-09-30 23:59:57.000'
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 61 WHERE BSAcctID = 11862323 AND BusinessDay = '2021-09-30 23:59:57.000'
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 61 WHERE BSAcctID = 11957840 AND BusinessDay = '2021-09-30 23:59:57.000'
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 61 WHERE BSAcctID = 17996163 AND BusinessDay = '2021-09-30 23:59:57.000'

--Q20

UPDATE TOP(1) StatementHeader SET DateOfOriginalPaymentDueDTD = '2021-09-30 23:59:57.000' WHERE StatementDate = '2021-09-30 23:59:57.000' AND acctId = 241303
UPDATE TOP(1) StatementHeader SET DateOfOriginalPaymentDueDTD = '2021-09-30 23:59:57.000' WHERE StatementDate = '2021-09-30 23:59:57.000' AND acctId = 442759
UPDATE TOP(1) StatementHeader SET DateOfOriginalPaymentDueDTD = '2021-09-30 23:59:57.000' WHERE StatementDate = '2021-09-30 23:59:57.000' AND acctId = 1075129
UPDATE TOP(1) StatementHeader SET DateOfOriginalPaymentDueDTD = '2021-09-30 23:59:57.000' WHERE StatementDate = '2021-09-30 23:59:57.000' AND acctId = 1860208
UPDATE TOP(1) StatementHeader SET DateOfOriginalPaymentDueDTD = '2021-09-30 23:59:57.000' WHERE StatementDate = '2021-09-30 23:59:57.000' AND acctId = 4620669
UPDATE TOP(1) StatementHeader SET DateOfOriginalPaymentDueDTD = '2021-09-30 23:59:57.000' WHERE StatementDate = '2021-09-30 23:59:57.000' AND acctId = 4725201
UPDATE TOP(1) StatementHeader SET DateOfOriginalPaymentDueDTD = '2021-09-30 23:59:57.000' WHERE StatementDate = '2021-09-30 23:59:57.000' AND acctId = 9591604
UPDATE TOP(1) StatementHeader SET DateOfOriginalPaymentDueDTD = '2021-09-30 23:59:57.000' WHERE StatementDate = '2021-09-30 23:59:57.000' AND acctId = 13382512
UPDATE TOP(1) StatementHeader SET DateOfOriginalPaymentDueDTD = '2021-09-30 23:59:57.000' WHERE StatementDate = '2021-09-30 23:59:57.000' AND acctId = 15129357

UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 1, DaysDelinquent = 1, DateOfOriginalPaymentDueDTD = '2021-09-30 23:59:57.000' WHERE BSAcctID = 241303 AND BusinessDay = '2021-09-30 23:59:57.000'
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 1, DaysDelinquent = 1, DateOfOriginalPaymentDueDTD = '2021-09-30 23:59:57.000' WHERE BSAcctID = 442759 AND BusinessDay = '2021-09-30 23:59:57.000'
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 1, DaysDelinquent = 1, DateOfOriginalPaymentDueDTD = '2021-09-30 23:59:57.000' WHERE BSAcctID = 1075129 AND BusinessDay = '2021-09-30 23:59:57.000'
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 1, DaysDelinquent = 1, DateOfOriginalPaymentDueDTD = '2021-09-30 23:59:57.000' WHERE BSAcctID = 1860208 AND BusinessDay = '2021-09-30 23:59:57.000'
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 1, DaysDelinquent = 1, DateOfOriginalPaymentDueDTD = '2021-09-30 23:59:57.000' WHERE BSAcctID = 4620669 AND BusinessDay = '2021-09-30 23:59:57.000'
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 1, DaysDelinquent = 1, DateOfOriginalPaymentDueDTD = '2021-09-30 23:59:57.000' WHERE BSAcctID = 4725201 AND BusinessDay = '2021-09-30 23:59:57.000'
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 1, DaysDelinquent = 1, DateOfOriginalPaymentDueDTD = '2021-09-30 23:59:57.000' WHERE BSAcctID = 9591604 AND BusinessDay = '2021-09-30 23:59:57.000'
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 1, DaysDelinquent = 1, DateOfOriginalPaymentDueDTD = '2021-09-30 23:59:57.000' WHERE BSAcctID = 13382512 AND BusinessDay = '2021-09-30 23:59:57.000'
UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 1, DaysDelinquent = 1, DateOfOriginalPaymentDueDTD = '2021-09-30 23:59:57.000' WHERE BSAcctID = 15129357 AND BusinessDay = '2021-09-30 23:59:57.000'