BEGIN TRAN
--COMMIT TRAN
--ROLLBACK TRAN

UPDATE TOP(1) StatementHeader SET AmountOfPaymentsCTD = AmountOfPaymentsCTD + 25.74, amountofcreditsctd = amountofcreditsctd + 25.74 WHERE 
acctID = 6730375 AND StatementDate = '2022-07-31 23:59:57.000'