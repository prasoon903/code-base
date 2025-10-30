-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO


BEGIN TRANSACTION
--COMMIT TRANSACTION
-- ROLLBACK TRANSACTION





UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE acctId = 605914 AND StatementID = 85175948
UPDATE TOP(1) SummaryHeaderCreditCard SET CurrentDue = CurrentDue - 0.01 WHERE acctId = 605914 AND StatementID = 85175948

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE acctId = 795462 AND StatementID =  85237960
UPDATE TOP(1) SummaryHeaderCreditCard SET CurrentDue = CurrentDue - 0.01 WHERE acctId = 795462 AND StatementID =  85237960

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE acctId = 1993729 AND StatementID =  86320661
UPDATE TOP(1) SummaryHeaderCreditCard SET CurrentDue = CurrentDue - 0.01 WHERE acctId = 1993729 AND StatementID =  86320661

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE acctId = 2273994 AND StatementID =  86590737
UPDATE TOP(1) SummaryHeaderCreditCard SET CurrentDue = CurrentDue - 0.01 WHERE acctId = 2273994 AND StatementID =  86590737

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE acctId = 6146787 AND StatementID =  87519605
UPDATE TOP(1) SummaryHeaderCreditCard SET CurrentDue = CurrentDue - 0.01 WHERE acctId = 6146787 AND StatementID =  87519605

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE acctId = 1729696 AND StatementID =  86121025
UPDATE TOP(1) SummaryHeaderCreditCard SET CurrentDue = CurrentDue - 0.01 WHERE acctId = 1729696 AND StatementID =  86121025

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE acctId = 10205156 AND StatementID =  87840138
UPDATE TOP(1) SummaryHeaderCreditCard SET CurrentDue = CurrentDue - 0.01 WHERE acctId = 10205156 AND StatementID =  87840138

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE acctId = 36775347 AND StatementID =  89168871
UPDATE TOP(1) SummaryHeaderCreditCard SET CurrentDue = CurrentDue - 0.01 WHERE acctId = 36775347 AND StatementID =  89168871



UPDATE TOP(1) StatementHeader SET MinimumPaymentDue = MinimumPaymentDue + 2.61, AmtOfPayCurrDue = AmtOfPayCurrDue + 2.61, 
AmountOfTotalDue = AmountOfTotalDue + 2.61 WHERE acctId = 2251171 AND StatementID = 86598162



UPDATE TOP(1) StatementHeader SET AmtOfPayCurrDue = AmtOfPayCurrDue + 100.08, AmountOfTotalDue = AmountOfTotalDue + 100.08, 
MinimumPaymentDue = MinimumPaymentDue + 100.08 WHERE acctId = 4323407 AND StatementID = 87573034



UPDATE TOP(1) StatementHeader SET MinimumPaymentDue = MinimumPaymentDue + 326.32, AmtOfPayCurrDue = AmtOfPayCurrDue + 326.32, 
AmountOfTotalDue = AmountOfTotalDue + 326.32 WHERE acctId = 7603336 AND StatementID = 88139274



UPDATE TOP(1) StatementHeader SET MinimumPaymentDue = MinimumPaymentDue + 29.17, AmtOfPayCurrDue = AmtOfPayCurrDue + 29.17, 
AmountOfTotalDue = AmountOfTotalDue + 29.17 WHERE acctId = 9812311 AND StatementID = 88402718




