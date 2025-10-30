-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION
-- COMMIT TRANSACTION
-- ROLLBACK TRANSACTION


update TOP(1) ccard_primary set PostingRef = 'Transaction Posted Successfully' where tranid = 44897057125

/*

UPDATE TOP(1) CPSgmentAccounts SET AmountOfCreditsLTD = AmountOfCreditsLTD - 49 WHERE acctID = 45450207
UPDATE TOP(1) CPSgmentAccounts SET AmountOfCreditsLTD = AmountOfCreditsLTD - 120.91 WHERE acctID = 45991958

update TOP(1) ccard_primary set accountnumber = '1100011113567881', txnacctid = 1360385 where tranid = 44897057125
update TOP(1) ccard_primary set accountnumber = '1100011113567881', txnacctid = 1360385 where tranid = 45866178310

*/


/*
SELECT AmountOfCreditsLTD, * 
FROM LS_PRODDRGSDB01.ccgs_coreissue.dbo.CPSgmentAccounts WITH (NOLOCK) 
WHERE acctID = 45991958
*/