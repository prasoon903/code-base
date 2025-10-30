-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO


BEGIN TRANSACTION
COMMIT TRANSACTION
-- ROLLBACK TRANSACTION

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE acctId = 53511881 AND StatementID = 74035522
UPDATE TOP(1) SummaryHeaderCreditCard SET CurrentDue = CurrentDue - 0.01 WHERE acctId = 53511881 AND StatementID = 74035522



UPDATE TOP(1) StatementHeader SET AmountOfTotalDue = AmountOfTotalDue + 175.40, AmtOfPayCurrDue = AmtOfPayCurrDue + 175.40, 
MinimumPaymentDue = MinimumPaymentDue + 175.40 WHERE acctId = 1742986 AND StatementID = 74718801



UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE acctId = 53525762 AND StatementID = 74783992
UPDATE TOP(1) SummaryHeaderCreditCard SET CurrentDue = CurrentDue - 0.01 WHERE acctId = 53525762 AND StatementID = 74783992


UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE acctId = 53566038 AND StatementID = 75348058
UPDATE TOP(1) SummaryHeaderCreditCard SET CurrentDue = CurrentDue - 0.01 WHERE acctId = 53566038 AND StatementID = 75348058



UPDATE TOP(1) StatementHeader SET AmountOfTotalDue = AmountOfTotalDue + 19.97, AmtOfPayCurrDue = AmtOfPayCurrDue + 19.97, 
MinimumPaymentDue = MinimumPaymentDue + 19.97, DateOfOriginalPaymentDueDTD = '2021-04-30 23:59:57' WHERE acctId = 3211712 AND StatementID = 75824222



UPDATE TOP(1) StatementHeader SET AmountOfTotalDue = AmountOfTotalDue + 59, AmtOfPayXDLate = AmtOfPayXDLate + 37.31, AmountOfPayment30DLate = AmountOfPayment30DLate + 21.69, 
CycleDueDTD = 3, SystemStatus = 15991, MinimumPaymentDue = MinimumPaymentDue + 59, DateOfOriginalPaymentDueDTD = '2021-03-31 23:59:57' WHERE acctId = 311669 AND StatementID = 73372548



UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE acctId = 53517848 AND StatementID = 76231846
UPDATE TOP(1) SummaryHeaderCreditCard SET CurrentDue = CurrentDue - 0.01 WHERE acctId = 53517848 AND StatementID = 76231846



UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE acctId = 53543938 AND StatementID = 77062380
UPDATE TOP(1) SummaryHeaderCreditCard SET CurrentDue = CurrentDue - 0.01 WHERE acctId = 53543938 AND StatementID = 77062380



UPDATE TOP(1) StatementHeader SET AmountOfTotalDue = AmountOfTotalDue + 80.04, AmtOfPayCurrDue = AmtOfPayCurrDue + 80.04, 
MinimumPaymentDue = MinimumPaymentDue + 80.04, DateOfOriginalPaymentDueDTD = '2021-04-30 23:59:57' WHERE acctId = 13004403 AND StatementID = 77426950




UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue + 58.73 WHERE acctId = 10449489 AND StatementID = 76431663
UPDATE TOP(1) SummaryHeaderCreditCard SET CurrentDue = CurrentDue + 58.73, CycleDueDTD = 1 WHERE acctId = 10449489 AND StatementID = 76431663



UPDATE TOP(1) StatementHeader SET AmountOfTotalDue = AmountOfTotalDue + 430.09, AmtOfPayCurrDue = AmtOfPayCurrDue + 430.09, CycleDueDTD = 1, 
MinimumPaymentDue = MinimumPaymentDue + 430.09, DateOfOriginalPaymentDueDTD = '2021-05-31 23:59:57' WHERE acctId = 7493132 AND StatementID = 76656646