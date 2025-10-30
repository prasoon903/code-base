-- TO BE RUN ON REPLICATION SERVER ONLY

BEGIN TRANSACTION
--COMMIT TRANSACTION
-- ROLLBACK TRANSACTION


UPDATE TOP(1) StatementHeader SET AmountOfPayment30DLate = AmountOfPayment30DLate + 32.19, AmountOfPayment60DLate = AmountOfPayment60DLate - 32.19 WHERE acctId = 13004403 AND StatementID = 83351600

UPDATE TOP(1) AccountInfoForReport SET AmountOfPayment30DLate = AmountOfPayment30DLate + 32.19, AmountOfPayment60DLate = AmountOfPayment60DLate - 32.19 WHERE BSacctId = 13004403 AND BusinessDay = '2021-06-30 23:59:57.000'	

