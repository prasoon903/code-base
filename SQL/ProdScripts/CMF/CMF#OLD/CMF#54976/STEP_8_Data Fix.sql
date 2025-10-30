-----------------------------------------STEP 1

BEGIN TRANSACTION
--Commit
--Rollback

delete from purchasereversalrecord  where tranid in (43201162919,43348415251) and 
Skey in (2595470,2604126) 

--2 ROWS each.

INSERT INTO purchasereversalrecord (acctid,parent02aid,tranid,tranref,transactionamount,reversalflag,cmttrantype,tranorig,originaltranref,referencetranid) 
VALUES
(35366806,		12391897,	43347872357,	43348415196,	1.51,	'1',	'135',     	43350634674,	39438294302,		43348415195)

--1 rows

-----------------------------------------STEP 2

BEGIN TRANSACTION
--Commit
--Rollback

--2 ROWS each.

UPDATE errortnp SET TranTime=GetDATE(),TnpDate=GetDAte() WHERE  ATID=51 AND tranid  IN (43348619529,43354029263)
Update CCard_Primary set  TranTime = GetDATE(),PostTime= GetDAte() where tranid  IN (43348619529,43354029263)

INSERT INTO commontnp (tnpdate,priority,trantime,tranid,atid,acctid,ttid,nadandrooflag,getalltnpjobsflag,InstitutionID)
SELECT E.tnpdate,E.priority,E.trantime,E.tranid,E.atid,E.acctid,E.ttid,E.nadandrooflag,E.getalltnpjobsflag,6981 
FROM errortnp E WITH(NOLOCK) WHERE E.ATID = 51 AND  E.tranid in (43348619529,43354029263)

DELETE FROM errortnp  WHERE ATID = 51  AND tranid IN (43348619529,43354029263)

-----------------------------------------STEP 3

BEGIN TRANSACTION
--Commit
--Rollback

--1 ROWS each.

UPDATE errortnp SET TranTime=GetDATE(),TnpDate=GetDAte() WHERE  ATID=51 AND tranid  IN (43354090414)
Update CCard_Primary set  TranTime = GetDATE(),PostTime= GetDAte() where tranid  IN (43354090414)

INSERT INTO commontnp (tnpdate,priority,trantime,tranid,atid,acctid,ttid,nadandrooflag,getalltnpjobsflag,InstitutionID)
SELECT E.tnpdate,E.priority,E.trantime,E.tranid,E.atid,E.acctid,E.ttid,E.nadandrooflag,E.getalltnpjobsflag,6981 
FROM errortnp E WITH(NOLOCK) WHERE E.ATID = 51 AND  E.tranid in (43354090414)

DELETE FROM errortnp  WHERE ATID = 51  AND tranid IN (43354090414)
