BEGIN TRAN
--COMMIT TRAN
--ROLLBACK TRAN

UPDATE TOP(3) AccountInfoForReport SET DateAcctClosed = NULL WHERE BSAcctID IN (2841126, 880795, 21146543) AND BusinessDay = '2024-04-30 23:59:57'

UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = DaysDelinquent WHERE BSAcctID IN (18326310) AND BusinessDay = '2024-04-30 23:59:57'
UPDATE TOP(1) StatementHeaderEX SET Nopaydaysdelinquent = daysdelinquent WHERE AcctID = 18326310 AND StatementDate = '2024-04-30 23:59:57'

UPDATE TOP(1) AccountInfoForReport SET DaysDelinquent = 61, dateoforiginalpaymentduedtd = '2020-07-31', DateOfDelinquency = '2020-10-31'   WHERE BSAcctID IN (2216755) AND BusinessDay = '2024-04-30 23:59:57'
UPDATE TOP(1) StatementHeader SET dateoforiginalpaymentduedtd = '2020-07-31' WHERE AcctID = 2216755 AND StatementDate = '2024-04-30 23:59:57'
UPDATE TOP(1) StatementHeaderEX SET daysdelinquent = 61, Nopaydaysdelinquent = 153, DtOfLastDelinqCTD = '2020-10-31' WHERE AcctID = 2216755 AND StatementDate = '2024-04-30 23:59:57'

UPDATE TOP(1) AccountInfoForReport SET DateOfDelinquency = NULL WHERE BSAcctID IN (2300681) AND BusinessDay = '2024-04-30 23:59:57'
UPDATE TOP(1) StatementHeaderEX SET DtOfLastDelinqCTD = NULL WHERE AcctID = 2300681 AND StatementDate = '2024-04-30 23:59:57'




--SELECT TotalDaysDelinquent, DaysDelinquent,* FROM AccountInfoForReport WITH (NOLOCK) WHERE BSAcctID IN (18326310) AND BusinessDay = '2024-04-30 23:59:57'
--SELECT DateAcctClosed FROM AccountInfoForReport WITH (NOLOCK) WHERE BSAcctID IN (2841126, 880795, 21146543) AND BusinessDay = '2024-04-30 23:59:57'
--SELECT TotalDaysDelinquent, DaysDelinquent, DateOfDelinquency,* FROM AccountInfoForReport WITH (NOLOCK) WHERE BSAcctID IN (2216755) AND BusinessDay = '2024-04-30 23:59:57'
--SELECT TotalDaysDelinquent, DaysDelinquent, DateOfDelinquency,* FROM AccountInfoForReport WITH (NOLOCK) WHERE BSAcctID IN (2300681) AND BusinessDay = '2024-04-30 23:59:57'