-------------------------------------------STEP 1

BEGIN TRANSACTION
----Commit
----Rollback

delete from purchasereversalrecord  where tranid in (48397475884,48655588723,48397475877,48398825989,48655588718,48655588720) 
and skey in (3897522,3897530,3820685,3884898,3897528,3897529)

--6 ROWS.

----------------------------------------STEP 2

BEGIN TRANSACTION
----Commit
----Rollback

update ccard_primary set trantime  = '2021-08-15 21:36:33.000' where tranid = 48687251170
update ccard_primary set trantime  = '2021-08-15 21:36:35.000' where tranid = 48687251172
update ccard_primary set trantime  = '2021-08-16 17:33:25.000' where tranid = 48687251171
update ccard_primary set trantime  = '2021-08-16 17:33:27.000' where tranid = 48687251173

--1 row each.

----------------------------------------STEP 3

BEGIN TRANSACTION
----Commit
----Rollback

UPDATE errortnp SET TranTime=GetDATE(),TnpDate=GetDAte() WHERE  ATID=51 AND tranid  IN (48660707982)
--1 ROWS .
Update CCard_Primary set  TranTime = GetDATE(),PostTime= GetDAte() where tranid  IN (48660707982)
--1 ROWS .

INSERT INTO commontnp (tnpdate,priority,trantime,tranid,atid,acctid,ttid,nadandrooflag,getalltnpjobsflag,InstitutionID)
SELECT E.tnpdate,E.priority,E.trantime,E.tranid,E.atid,E.acctid,E.ttid,E.nadandrooflag,E.getalltnpjobsflag,6981 
FROM errortnp E WITH(NOLOCK) WHERE E.ATID = 51 AND  E.tranid in (48660707982,48687251170)
--2 ROWS .

DELETE FROM errortnp  WHERE ATID = 51  AND tranid IN (48660707982,48687251170)
--2 ROWS .

----------------------------------------STEP 4

BEGIN TRANSACTION
----Commit
----Rollback

UPDATE errortnp SET TranTime=GetDATE(),TnpDate=GetDAte() WHERE  ATID=51 AND tranid  IN (48660748534)
--1 ROWS .
Update CCard_Primary set  TranTime = GetDATE(),PostTime= GetDAte() where tranid  IN (48660748534)
--1 ROWS .

INSERT INTO commontnp (tnpdate,priority,trantime,tranid,atid,acctid,ttid,nadandrooflag,getalltnpjobsflag,InstitutionID)
SELECT E.tnpdate,E.priority,E.trantime,E.tranid,E.atid,E.acctid,E.ttid,E.nadandrooflag,E.getalltnpjobsflag,6981 
FROM errortnp E WITH(NOLOCK) WHERE E.ATID = 51 AND  E.tranid in (48660748534,48687251172)
--2 ROWS .

DELETE FROM errortnp  WHERE ATID = 51  AND tranid IN (48660748534,48687251172)
--2 ROWS .

----------------------------------------STEP 5

BEGIN TRANSACTION
----Commit
----Rollback

INSERT INTO commontnp (tnpdate,priority,trantime,tranid,atid,acctid,ttid,nadandrooflag,getalltnpjobsflag,InstitutionID)
SELECT E.tnpdate,E.priority,E.trantime,E.tranid,E.atid,E.acctid,E.ttid,E.nadandrooflag,E.getalltnpjobsflag,6981 
FROM errortnp E WITH(NOLOCK) WHERE E.ATID = 51 AND  E.tranid in (48687251171)
--1 ROWS .

DELETE FROM errortnp  WHERE ATID = 51  AND tranid IN (48687251171)
--1 ROWS .

----------------------------------------STEP 6

BEGIN TRANSACTION
----Commit
----Rollback

INSERT INTO commontnp (tnpdate,priority,trantime,tranid,atid,acctid,ttid,nadandrooflag,getalltnpjobsflag,InstitutionID)
SELECT E.tnpdate,E.priority,E.trantime,E.tranid,E.atid,E.acctid,E.ttid,E.nadandrooflag,E.getalltnpjobsflag,6981 
FROM errortnp E WITH(NOLOCK) WHERE E.ATID = 51 AND  E.tranid in (48687251173)
--1 ROWS .

DELETE FROM errortnp  WHERE ATID = 51  AND tranid IN (48687251173)
--1 ROWS .
