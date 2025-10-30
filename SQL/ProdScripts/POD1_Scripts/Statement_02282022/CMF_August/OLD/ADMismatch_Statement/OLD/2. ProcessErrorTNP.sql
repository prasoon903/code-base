

BEGIN TRANSACTION
--Commit
--Rollback

--1 ROWS each.


INSERT INTO commontnp (tnpdate,priority,trantime,tranid,atid,acctid,ttid,nadandrooflag,getalltnpjobsflag,InstitutionID)
SELECT E.tnpdate,E.priority,E.trantime,E.tranid,E.atid,E.acctid,E.ttid,E.nadandrooflag,E.getalltnpjobsflag,6981 
FROM errortnp E WITH(NOLOCK) WHERE E.ATID = 51 AND E.acctId = 20453980 AND E.TranID = 0

DELETE FROM errortnp  WHERE ATID = 51  AND acctId = 20453980 AND TranID = 0

