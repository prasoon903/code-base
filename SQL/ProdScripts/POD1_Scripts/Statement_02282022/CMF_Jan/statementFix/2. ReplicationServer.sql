-- TO BE RUN ON REPLICATION SERVER ONLY

USE CCGS_RPT_CoreIssue
GO

BEGIN TRANSACTION
--COMMIT TRANSACTION
-- ROLLBACK TRANSACTION

update    top(1)  SummaryHeader   set  amountoftotaldue = 3237.51    where   acctid  = 6459603 and statementid  = 127055298

update   top(1)   planinfoforreport   set   srbwithinstallmentdue  = 3237.51 , sbwithinstallmentdue = 3237.51     ,amountoftotaldue = 3237.51   , amtofpaycurrdue= 3237.51   ,  amtofpayxdlate =0   , AmountOfPayment30DLate =  0  ,  AmountOfPayment60DLate = 0  ,   AmountOfPayment90DLate = 0   ,  AmountOfPayment120DLate  = 0 ,   AmountOfPayment150DLate = 0  ,  AmountOfPayment180DLate  = 0  , AmountOfPayment210DLate = 0 ,cycleduedtd = 1    where   cpsacctid  = 6459603 and businessday  = '2022-01-31 23:59:57'

update top(1) summaryHeader  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 17.00 where  acctid  =  68398087 AND StatementID = 129993266
update top(1) summaryHeader  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 188.90 where  acctid  =  71832410 AND StatementID = 128639236