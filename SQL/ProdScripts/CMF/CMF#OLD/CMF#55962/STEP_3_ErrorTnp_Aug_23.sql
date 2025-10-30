--PLEASE RUN BELOW SCRIPT IN PLAT - PROD PRIMARY SERVER OF COREISSUE DB
--======================================================================================================
-- Do Balance Propogation Jobs Reprocess
--=======================================================================================================

USE CCGS_CoreIssue

GO


BEGIN TRANSACTION 
DECLARE @CURRENTDATE DATETIME = GETDATE()
UPDATE errortnp SET TranTime=@CURRENTDATE WHERE Tranid in (44680641139,44680918643,44680918644,44680918945,44680919018,44681130122) AND ATID=51 
---(6 row(s) affected)
UPDATE CCARD_PRIMARY SET TRANTIME = @CURRENTDATE , POSTTIME =  @CURRENTDATE WHERE TRANID in (44680641139,44680918643,44680918644,44680918945,44680919018,44681130122)
-- (6 row(s) affected)
INSERT INTO commontnp (tnpdate,priority,trantime,tranid,atid,acctid,ttid,nadandrooflag,getalltnpjobsflag,InstitutionID)
SELECT E.tnpdate,E.priority,E.trantime,E.tranid,E.atid,E.acctid,E.ttid,E.nadandrooflag,E.getalltnpjobsflag,6981 FROM errortnp E WITH(NOLOCK)
WHERE E.ATID = 51 AND  E.tranid in (44680641139,44680918643,44680918644,44680918945,44680919018,44681130122)
---(6 row(s) affected)
DELETE FROM errortnp  WHERE ATID = 51  AND tranid  in (44680641139,44680918643,44680918644,44680918945,44680919018,44681130122)
---(6 row(s) affected)
--Commit Transaction 
--Rollback Transaction 


--STEP- 2
--======================================================================================================
-- Eerrop TNP JObs
--=======================================================================================================

BEGIN TRANSACTION 

INSERT INTO ecommontnp (tnpdate,priority,trantime,tranid,atid,acctid,ttid,nadandrooflag,getalltnpjobsflag,Retries,InstitutionID)
SELECT E.tnpdate,E.priority,E.trantime,E.tranid,E.atid,E.acctid,E.ttid,E.nadandrooflag,E.getalltnpjobsflag,0,6981 
FROM eerrortnp E WITH(NOLOCK) WHERE E.ATID = 53 AND  E.tranid  in (44680818461,44680818462,44680818463,44680819167,44680819168,44680819169)
---(6 rows affected)

DELETE FROM eerrortnp  WHERE ATID = 53  AND tranid  in (44680818461,44680818462,44680818463,44680819167,44680819168,44680819169)
---(6 rows affected)

--Commit Transaction 
--Rollback Transaction 
