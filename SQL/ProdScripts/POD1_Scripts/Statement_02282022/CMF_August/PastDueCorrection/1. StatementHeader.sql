-- TO BE RUN ON PRIMARY AND REPLICATION SERVER BOTH 
-- COREISSUE  DATABASE

BEGIN TRANSACTION

--COMMIT TRANSACTION
--ROLLBACK TRANSACTION

UPDATE TOP(1) StatementHeader SET AmtOfPayPastDue = 0 WHERE StatementDate = '2021-08-31 23:59:57.000' AND acctId = 878557
UPDATE TOP(1) StatementHeader SET AmtOfPayPastDue = 0 WHERE StatementDate = '2021-08-31 23:59:57.000' AND acctId = 1236490
UPDATE TOP(1) StatementHeader SET AmtOfPayPastDue = 0 WHERE StatementDate = '2021-08-31 23:59:57.000' AND acctId = 4346940
UPDATE TOP(1) StatementHeader SET AmtOfPayPastDue = 0 WHERE StatementDate = '2021-08-31 23:59:57.000' AND acctId = 6404696
UPDATE TOP(1) StatementHeader SET AmtOfPayPastDue = 0 WHERE StatementDate = '2021-08-31 23:59:57.000' AND acctId = 7819098
UPDATE TOP(1) StatementHeader SET AmtOfPayPastDue = 0 WHERE StatementDate = '2021-08-31 23:59:57.000' AND acctId = 12125607
UPDATE TOP(1) StatementHeader SET AmtOfPayPastDue = 0 WHERE StatementDate = '2021-08-31 23:59:57.000' AND acctId = 12400964
UPDATE TOP(1) StatementHeader SET AmtOfPayPastDue = 0 WHERE StatementDate = '2021-08-31 23:59:57.000' AND acctId = 18251859
UPDATE TOP(1) StatementHeader SET AmtOfPayPastDue = 0 WHERE StatementDate = '2021-08-31 23:59:57.000' AND acctId = 18683978
UPDATE TOP(1) StatementHeader SET AmtOfPayPastDue = 0 WHERE StatementDate = '2021-08-31 23:59:57.000' AND acctId = 19385355