-- TO BE RUN ON REPLICATION SERVER ONLY

USE CCGS_RPT_CoreIssue
GO

BEGIN TRANSACTION
--COMMIT TRANSACTION
-- ROLLBACK TRANSACTION


 

 update statementheader set amountofdebitsctd = amountofdebitsctd - 157.55 where acctid = 3298612  and statementdate = '2022-01-31 23:59:57.000'   
 -- 1 row


/*

select currentbalance, beginningbalance, amountofdebitsctd, amountofcreditsctd,systemstatus,amountofdebitsrevctd, amountofcreditsrevctd,
 * from statementheader with (nolock) where acctid = 553437
 order by statementdate desc
*/






