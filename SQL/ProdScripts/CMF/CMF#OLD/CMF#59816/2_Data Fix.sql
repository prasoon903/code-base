-------------------------------------------STEP 1

BEGIN TRANSACTION
----Commit
----Rollback

INSERT INTO commontnp (tnpdate,priority,trantime,tranid,atid,acctid,ttid,nadandrooflag,getalltnpjobsflag,InstitutionID)
SELECT E.tnpdate,E.priority,E.trantime,E.tranid,E.atid,E.acctid,E.ttid,E.nadandrooflag,E.getalltnpjobsflag,6981 
FROM errortnp E WITH(NOLOCK) WHERE E.ATID = 51 AND  E.tranid in (50401523853,50402094505)
--1 ROWS .

DELETE FROM errortnp  WHERE ATID = 51  AND tranid IN (50401523853,50402094505)
--1 ROWS .

---------------------------------------STEP 3

--BEGIN TRANSACTION
------Commit
------Rollback

--UPDATE errortnp SET TranTime=GetDATE(),TnpDate=GetDAte() WHERE  ATID=51 AND tranid  IN (50298994890)
----1 ROWS .
--Update CCard_Primary set  TranTime = GetDATE(),PostTime= GetDAte() where tranid  IN (50298994890)
----1 ROWS .

--INSERT INTO commontnp (tnpdate,priority,trantime,tranid,atid,acctid,ttid,nadandrooflag,getalltnpjobsflag,InstitutionID)
--SELECT E.tnpdate,E.priority,E.trantime,E.tranid,E.atid,E.acctid,E.ttid,E.nadandrooflag,E.getalltnpjobsflag,6981 
--FROM errortnp E WITH(NOLOCK) WHERE E.ATID = 51 AND  E.tranid in (50298994890)
----1 ROWS .

--DELETE FROM errortnp  WHERE ATID = 51  AND tranid IN (50298994890)
----1 ROWS .

-------------------------------------------step 4-------------------------------

--BEGIN TRANSACTION 

--INSERT INTO ecommontnp (tnpdate,priority,trantime,tranid,atid,acctid,ttid,nadandrooflag,getalltnpjobsflag,Retries,InstitutionID)
--SELECT E.tnpdate,E.priority,E.trantime,E.tranid,E.atid,E.acctid,E.ttid,E.nadandrooflag,E.getalltnpjobsflag,0,6981 
--FROM eerrortnp E WITH(NOLOCK) WHERE E.ATID = 53 AND  E.tranid in (50316056243,50316062321,50316084029,50316084030)
-----(4 rows affected)

--DELETE FROM eerrortnp  WHERE ATID = 53  AND tranid in (50316056243,50316062321,50316084029,50316084030)

-----(4 rows affected)

----Commit Transaction 
----Rollback Transaction 

