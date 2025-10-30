BEGIN TRAN
--COMMIT TRAN
--ROLLBACK TRAN

UPDATE TOP(1) StatementHeader SET 
AmountOFPaymentsCTD= 6598.79,
AmountOfPurchasesCTD = 5546.94,
AmountOfDebitsCTD = 5547.1,
AmountOfReturnsCTD = 15.98,
AmountOfCreditsCTD = 6614.77
WHERE acctID = 12946127
AND StatementDate = '2022-10-31 23:59:57.000'