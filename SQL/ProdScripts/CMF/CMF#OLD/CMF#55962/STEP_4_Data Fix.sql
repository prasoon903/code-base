-----------------------------------------STEP 1

BEGIN TRANSACTION
--Commit
--Rollback

delete from purchasereversalrecord  where tranid in (44356450197,44356450198,44356450199) and 
skey in (2919301,2919303,2919305)

--3 ROWS.

-----------------------------------------STEP 2

BEGIN TRANSACTION
--Commit
--Rollback

UPDATE errortnp SET TranTime=GetDATE(),TnpDate=GetDAte() WHERE  ATID=51 AND tranid  IN (44670525204)
--1 ROWS .
Update CCard_Primary set  TranTime = GetDATE(),PostTime= GetDAte() where tranid  IN (44670525204)
--1 ROWS .

INSERT INTO commontnp (tnpdate,priority,trantime,tranid,atid,acctid,ttid,nadandrooflag,getalltnpjobsflag,InstitutionID)
SELECT E.tnpdate,E.priority,E.trantime,E.tranid,E.atid,E.acctid,E.ttid,E.nadandrooflag,E.getalltnpjobsflag,6981 
FROM errortnp E WITH(NOLOCK) WHERE E.ATID = 51 AND  E.tranid in (44670525204)
--1 ROWS .

DELETE FROM errortnp  WHERE ATID = 51  AND tranid IN (44670525204)
--1 ROWS.

-----------------------------------------STEP 3

BEGIN TRANSACTION
--Commit
--Rollback

UPDATE errortnp SET TranTime=GetDATE(),TnpDate=GetDAte() WHERE  ATID=51 AND tranid  IN (44670529912)
--1 ROWS .
Update CCard_Primary set  TranTime = GetDATE(),PostTime= GetDAte() where tranid  IN (44670529912)
--1 ROWS .

INSERT INTO commontnp (tnpdate,priority,trantime,tranid,atid,acctid,ttid,nadandrooflag,getalltnpjobsflag,InstitutionID)
SELECT E.tnpdate,E.priority,E.trantime,E.tranid,E.atid,E.acctid,E.ttid,E.nadandrooflag,E.getalltnpjobsflag,6981 
FROM errortnp E WITH(NOLOCK) WHERE E.ATID = 51 AND  E.tranid in (44670529912)
--1 ROWS .

DELETE FROM errortnp  WHERE ATID = 51  AND tranid IN (44670529912)
--1 ROWS.