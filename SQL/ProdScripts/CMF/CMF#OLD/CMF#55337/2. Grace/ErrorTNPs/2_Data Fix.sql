-----------------------------------------STEP 1

BEGIN TRANSACTION
--Commit
--Rollback

delete from purchasereversalrecord  where tranid in (43736458851,43736458851) and skey in (2680875,2740901)

--2 ROWS each.

-----------------------------------------STEP 2

BEGIN TRANSACTION
--Commit
--Rollback

--1 ROWS each.

UPDATE errortnp SET TranTime=GetDATE(),TnpDate=GetDAte() WHERE  ATID=51 AND tranid  IN (43869357508)
Update CCard_Primary set  TranTime = GetDATE(),PostTime= GetDAte() where tranid  IN (43869357508)

INSERT INTO commontnp (tnpdate,priority,trantime,tranid,atid,acctid,ttid,nadandrooflag,getalltnpjobsflag,InstitutionID)
SELECT E.tnpdate,E.priority,E.trantime,E.tranid,E.atid,E.acctid,E.ttid,E.nadandrooflag,E.getalltnpjobsflag,6981 
FROM errortnp E WITH(NOLOCK) WHERE E.ATID = 51 AND  E.tranid in (43869357508)

DELETE FROM errortnp  WHERE ATID = 51  AND tranid IN (43869357508)


------------------------------------------STEP 3

BEGIN TRANSACTION
--Commit
--Rollback

--1 ROWS each.

Update CCard_Primary set  postingref='Transaction already Revered' where tranid  IN (43884085765)

DELETE FROM errortnp  WHERE ATID = 51  AND tranid IN (43884085765)


------------------------------------------STEP 4

BEGIN TRANSACTION 

INSERT INTO ecommontnp (tnpdate,priority,trantime,tranid,atid,acctid,ttid,nadandrooflag,getalltnpjobsflag,Retries,InstitutionID)
SELECT E.tnpdate,E.priority,E.trantime,E.tranid,E.atid,E.acctid,E.ttid,E.nadandrooflag,E.getalltnpjobsflag,1,6981 
FROM eerrortnp E WITH(NOLOCK) WHERE E.ATID = 53 AND  E.tranid in (43791328701,43791328702)
--2 rows will be affected

DELETE FROM eerrortnp  WHERE ATID = 53  AND tranid in (43791328701,43791328702)
--2 rows will be affected

--Commit Transaction 
--Rollback Transaction 
