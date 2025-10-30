-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO


BEGIN TRANSACTION
--COMMIT TRANSACTION
-- ROLLBACK TRANSACTION

--update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 16.56 where  acctid  =  45307205


--update top(1) SummaryHeader  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 16.56 where  acctid  =  45307205 AND StatementID = 113869906


update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 50.00 where  acctid  =  67217618

update top(1) SummaryHeader  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 50 where  acctid  =  67217618 AND StatementID = 116473847