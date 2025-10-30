-- TO BE EXECUTED ON REPLICATION SERVER COREISSUE DATABASE ONLY

BEGIN TRANSACTION
--COMMIT TRANSACTION
--ROLLBACK TRANSACTION

UPDATE TOP(1) StatementHeader SET CurrentBalance = CurrentBalance + 25.74, AmountOfTotalDue = AmountOfTotalDue + 25, 
AmtOfPayCurrDue = AmtOfPayCurrDue + 25, MinimumPaymentDue = MinimumPaymentDue + 25, SRBWithInstallmentDue = SRBWithInstallmentDue + 25.74,
amountofpaymentsctd = 123.63, amountofcreditsctd = 123.63
WHERE AcctId = 6730375 AND StatementID = 165420011

UPDATE TOP(1) SummaryHeader SET CurrentBalance = CurrentBalance + 25.74, AmountOfTotalDue = AmountOfTotalDue + 25
WHERE AcctId = 16354533 AND StatementID = 165420011



UPDATE TOP(1) AccountInfoForReport SET CurrentBalance = CurrentBalance + 25.74, AmountOfTotalDue = AmountOfTotalDue + 25, 
AmtOfPayCurrDue = AmtOfPayCurrDue + 25, SRBWithInstallmentDue = SRBWithInstallmentDue + 25.74
WHERE BSAcctId = 6730375 AND BusinessDay = '2022-06-30 23:59:57'

UPDATE TOP(1) PlanInfoForReport SET CurrentBalance = CurrentBalance + 25.74, AmountOfTotalDue = AmountOfTotalDue + 25, 
AmtOfPayCurrDue = AmtOfPayCurrDue + 25, SRBWithInstallmentDue = SRBWithInstallmentDue + 25.74, CycleDUeDTD = 1
WHERE CPSAcctId = 16354533 AND BusinessDay = '2022-06-30 23:59:57'



