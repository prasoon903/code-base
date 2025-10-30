BEGIN TRAN
--COMMIT TRAN
--ROLLBACK TRAN

UPDATE TOP(1) StatementHeader SET 
AmountOFPaymentsCTD= 521.68,
AmountOfPurchasesCTD = 238.08,
AmountOfDebitsCTD = 238.08,
AmountOfCreditsCTD = 521.68
WHERE acctID = 21943042
AND StatementDate = '2023-05-31 23:59:57.000'