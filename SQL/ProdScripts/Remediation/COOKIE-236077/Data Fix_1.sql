-------------------------------------------STEP 1

BEGIN TRANSACTION
----Commit
----Rollback

UPDATE CCARD_Primary set trantime = '2022-03-31 08:16:46.000',posttime = '2022-03-31 08:16:46.000' where tranid = 58526684571

--1 rows.

-------------------------------------------STEP 2

BEGIN TRANSACTION
----Commit
----Rollback

UPDATE errortnp SET TranTime=GetDATE(),TnpDate=GetDAte() WHERE  ATID=51 AND tranid  IN (83333972679)
--1 ROWS .
Update CCard_Primary set  TranTime = GetDATE(),PostTime= GetDAte() where tranid  IN (83333972679)
--1 ROWS .

INSERT INTO commontnp (tnpdate,priority,trantime,tranid,atid,acctid,ttid,nadandrooflag,getalltnpjobsflag,InstitutionID)
SELECT E.tnpdate,E.priority,E.trantime,E.tranid,E.atid,E.acctid,E.ttid,E.nadandrooflag,E.getalltnpjobsflag,6981 
FROM errortnp E WITH(NOLOCK) WHERE E.ATID = 51 AND  E.tranid IN (83333972679)
--1 ROWS .

DELETE FROM errortnp  WHERE ATID = 51  AND tranid IN (83333972679)
--1 ROWS .
