BEGIN TRAN
--COMMIT TRAN
--ROLLBACK TRAN

UPDATE TOP(1) StatementHeaderEX SET Nopaydaysdelinquent = daysdelinquent WHERE AcctID = 18326310 AND StatementDate = '2024-04-30 23:59:57'
UPDATE TOP(1) BSegmentCreditCard SET Nopaydaysdelinquent = daysdelinquent WHERE AcctID = 18326310

UPDATE TOP(1) BSegmentCreditCard SET daysdelinquent = 61, Nopaydaysdelinquent = 153, dateoforiginalpaymentduedtd = '2020-07-31', DtOfLastDelinqCTD = '2020-10-31' WHERE AcctID = 2216755
UPDATE TOP(1) StatementHeader SET dateoforiginalpaymentduedtd = '2020-07-31' WHERE AcctID = 2216755 AND StatementDate = '2024-04-30 23:59:57'
UPDATE TOP(1) StatementHeaderEX SET daysdelinquent = 61, Nopaydaysdelinquent = 153, DtOfLastDelinqCTD = '2020-10-31' WHERE AcctID = 2216755 AND StatementDate = '2024-04-30 23:59:57'

UPDATE TOP(1) BSegmentCreditCard SET DtOfLastDelinqCTD = NULL WHERE AcctID = 2300681
UPDATE TOP(1) StatementHeaderEX SET DtOfLastDelinqCTD = NULL WHERE AcctID = 2300681 AND StatementDate = '2024-04-30 23:59:57'