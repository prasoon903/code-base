-----------------------------------------STEP 1

BEGIN TRANSACTION
--Commit
--Rollback

delete from purchasereversalrecord  where tranid in (43736458851,43736458851,43839766471,43838942574) and 
skey in (2680875,2740901,2700594,2700521)

--4 ROWS each.

-----------------------------------------STEP 2

BEGIN TRANSACTION
--Commit
--Rollback

--3 ROWS each.

UPDATE errortnp SET TranTime=GetDATE(),TnpDate=GetDAte() WHERE  ATID=51 AND tranid  IN (43950603559,43951544731,43951785000)
Update CCard_Primary set  TranTime = GetDATE(),PostTime= GetDAte() where tranid  IN (43950603559,43951544731,43951785000)

INSERT INTO commontnp (tnpdate,priority,trantime,tranid,atid,acctid,ttid,nadandrooflag,getalltnpjobsflag,InstitutionID)
SELECT E.tnpdate,E.priority,E.trantime,E.tranid,E.atid,E.acctid,E.ttid,E.nadandrooflag,E.getalltnpjobsflag,6981 
FROM errortnp E WITH(NOLOCK) WHERE E.ATID = 51 AND  E.tranid in (43950603559,43951544731,43951785000)

DELETE FROM errortnp  WHERE ATID = 51  AND tranid IN (43950603559,43951544731,43951785000)


------------------------------------------STEP 3

BEGIN TRANSACTION
--Commit
--Rollback

--3 ROWS each.

UPDATE errortnp SET TranTime=GetDATE(),TnpDate=GetDAte() WHERE  ATID=51 AND tranid  IN (43951051778,43951631707,43952780740)
Update CCard_Primary set  TranTime = GetDATE(),PostTime= GetDAte() where tranid  IN (43951051778,43951631707,43952780740)

INSERT INTO commontnp (tnpdate,priority,trantime,tranid,atid,acctid,ttid,nadandrooflag,getalltnpjobsflag,InstitutionID)
SELECT E.tnpdate,E.priority,E.trantime,E.tranid,E.atid,E.acctid,E.ttid,E.nadandrooflag,E.getalltnpjobsflag,6981 
FROM errortnp E WITH(NOLOCK) WHERE E.ATID = 51 AND  E.tranid in (43951051778,43951631707,43952780740)

DELETE FROM errortnp  WHERE ATID = 51  AND tranid IN (43951051778,43951631707,43952780740)

------------------------------------------STEP 4

BEGIN TRANSACTION
--Commit
--Rollback

--3 rows will be affected

UPDATE errortnp SET TranTime=GetDATE(),TnpDate=GetDAte() WHERE  ATID=51 AND tranid  IN (43951680478,43954426587,43951300905)
Update CCard_Primary set  TranTime = GetDATE(),PostTime= GetDAte() where tranid  IN (43951680478,43954426587,43951300905)

INSERT INTO commontnp (tnpdate,priority,trantime,tranid,atid,acctid,ttid,nadandrooflag,getalltnpjobsflag,Retries,InstitutionID)
SELECT E.tnpdate,E.priority,E.trantime,E.tranid,E.atid,E.acctid,E.ttid,E.nadandrooflag,E.getalltnpjobsflag,1,6981 
FROM errortnp E WITH(NOLOCK) WHERE E.ATID = 51 AND  E.tranid in (43951680478,43954426587,43951300905)

DELETE FROM errortnp  WHERE ATID = 51  AND tranid in (43951680478,43954426587,43951300905)

------------------------------------------STEP 5

BEGIN TRANSACTION
--Commit
--Rollback

--2 rows will be affected

UPDATE errortnp SET TranTime=GetDATE(),TnpDate=GetDAte() WHERE  ATID=51 AND tranid  IN (43951090960,43951656449)
Update CCard_Primary set  TranTime = GetDATE(),PostTime= GetDAte() where tranid  IN (43951090960,43951656449)

INSERT INTO commontnp (tnpdate,priority,trantime,tranid,atid,acctid,ttid,nadandrooflag,getalltnpjobsflag,Retries,InstitutionID)
SELECT E.tnpdate,E.priority,E.trantime,E.tranid,E.atid,E.acctid,E.ttid,E.nadandrooflag,E.getalltnpjobsflag,1,6981 
FROM errortnp E WITH(NOLOCK) WHERE E.ATID = 51 AND  E.tranid in (43951090960,43951656449)

DELETE FROM errortnp  WHERE ATID = 51  AND tranid in (43951090960,43951656449)

------------------------------------------STEP 6
BEGIN TRANSACTION
--Commit
--Rollback

--2 rows will be affected

UPDATE errortnp SET TranTime=GetDATE(),TnpDate=GetDAte() WHERE  ATID=51 AND tranid  IN (43951105446,43951673308)
Update CCard_Primary set  TranTime = GetDATE(),PostTime= GetDAte() where tranid  IN (43951105446,43951673308)

INSERT INTO commontnp (tnpdate,priority,trantime,tranid,atid,acctid,ttid,nadandrooflag,getalltnpjobsflag,Retries,InstitutionID)
SELECT E.tnpdate,E.priority,E.trantime,E.tranid,E.atid,E.acctid,E.ttid,E.nadandrooflag,E.getalltnpjobsflag,1,6981 
FROM errortnp E WITH(NOLOCK) WHERE E.ATID = 51 AND  E.tranid in (43951105446,43951673308)

DELETE FROM errortnp  WHERE ATID = 51  AND tranid in (43951105446,43951673308)

------------------------------------------STEP 7

BEGIN TRANSACTION
--Commit
--Rollback

--2 rows will be affected

UPDATE errortnp SET TranTime=GetDATE(),TnpDate=GetDAte() WHERE  ATID=51 AND tranid  IN (43951109548,43952479954)
Update CCard_Primary set  TranTime = GetDATE(),PostTime= GetDAte() where tranid  IN (43951109548,43952479954)

INSERT INTO commontnp (tnpdate,priority,trantime,tranid,atid,acctid,ttid,nadandrooflag,getalltnpjobsflag,Retries,InstitutionID)
SELECT E.tnpdate,E.priority,E.trantime,E.tranid,E.atid,E.acctid,E.ttid,E.nadandrooflag,E.getalltnpjobsflag,1,6981 
FROM errortnp E WITH(NOLOCK) WHERE E.ATID = 51 AND  E.tranid in (43951109548,43952479954)

DELETE FROM errortnp  WHERE ATID = 51  AND tranid in (43951109548,43952479954)

------------------------------------------STEP 8
BEGIN TRANSACTION
--Commit
--Rollback

--2 rows will be affected

UPDATE errortnp SET TranTime=GetDATE(),TnpDate=GetDAte() WHERE  ATID=51 AND tranid  IN (43951127627,43952615615)
Update CCard_Primary set  TranTime = GetDATE(),PostTime= GetDAte() where tranid  IN (43951127627,43952615615)

INSERT INTO commontnp (tnpdate,priority,trantime,tranid,atid,acctid,ttid,nadandrooflag,getalltnpjobsflag,Retries,InstitutionID)
SELECT E.tnpdate,E.priority,E.trantime,E.tranid,E.atid,E.acctid,E.ttid,E.nadandrooflag,E.getalltnpjobsflag,1,6981 
FROM errortnp E WITH(NOLOCK) WHERE E.ATID = 51 AND  E.tranid in (43951127627,43952615615)

DELETE FROM errortnp  WHERE ATID = 51  AND tranid in (43951127627,43952615615)

------------------------------------------STEP 9

BEGIN TRANSACTION
--Commit
--Rollback

--2 rows will be affected

UPDATE errortnp SET TranTime=GetDATE(),TnpDate=GetDAte() WHERE  ATID=51 AND tranid  IN (43951139222,43952623563)
Update CCard_Primary set  TranTime = GetDATE(),PostTime= GetDAte() where tranid  IN (43951139222,43952623563)

INSERT INTO commontnp (tnpdate,priority,trantime,tranid,atid,acctid,ttid,nadandrooflag,getalltnpjobsflag,Retries,InstitutionID)
SELECT E.tnpdate,E.priority,E.trantime,E.tranid,E.atid,E.acctid,E.ttid,E.nadandrooflag,E.getalltnpjobsflag,1,6981 
FROM errortnp E WITH(NOLOCK) WHERE E.ATID = 51 AND  E.tranid in (43951139222,43952623563)

DELETE FROM errortnp  WHERE ATID = 51  AND tranid in (43951139222,43952623563)

-----------------------------------------STEP 10

BEGIN TRANSACTION
--Commit
--Rollback

--2 rows will be affected

UPDATE errortnp SET TranTime=GetDATE(),TnpDate=GetDAte() WHERE  ATID=51 AND tranid  IN (43951140981,43952648650)
Update CCard_Primary set  TranTime = GetDATE(),PostTime= GetDAte() where tranid  IN (43951140981,43952648650)

INSERT INTO commontnp (tnpdate,priority,trantime,tranid,atid,acctid,ttid,nadandrooflag,getalltnpjobsflag,Retries,InstitutionID)
SELECT E.tnpdate,E.priority,E.trantime,E.tranid,E.atid,E.acctid,E.ttid,E.nadandrooflag,E.getalltnpjobsflag,1,6981 
FROM errortnp E WITH(NOLOCK) WHERE E.ATID = 51 AND  E.tranid in (43951140981,43952648650)

DELETE FROM errortnp  WHERE ATID = 51  AND tranid in (43951140981,43952648650)

-----------------------------------------STEP 11

BEGIN TRANSACTION
--Commit
--Rollback

--2 rows will be affected

UPDATE errortnp SET TranTime=GetDATE(),TnpDate=GetDAte() WHERE  ATID=51 AND tranid  IN (43951152079,43952668672)
Update CCard_Primary set  TranTime = GetDATE(),PostTime= GetDAte() where tranid  IN (43951152079,43952668672)

INSERT INTO commontnp (tnpdate,priority,trantime,tranid,atid,acctid,ttid,nadandrooflag,getalltnpjobsflag,Retries,InstitutionID)
SELECT E.tnpdate,E.priority,E.trantime,E.tranid,E.atid,E.acctid,E.ttid,E.nadandrooflag,E.getalltnpjobsflag,1,6981 
FROM errortnp E WITH(NOLOCK) WHERE E.ATID = 51 AND  E.tranid in (43951152079,43952668672)

DELETE FROM errortnp  WHERE ATID = 51  AND tranid in (43951152079,43952668672)

-----------------------------------------STEP 12
BEGIN TRANSACTION
--Commit
--Rollback

--2 rows will be affected

UPDATE errortnp SET TranTime=GetDATE(),TnpDate=GetDAte() WHERE  ATID=51 AND tranid  IN (43951215840,43952677163)
Update CCard_Primary set  TranTime = GetDATE(),PostTime= GetDAte() where tranid  IN (43951215840,43952677163)

INSERT INTO commontnp (tnpdate,priority,trantime,tranid,atid,acctid,ttid,nadandrooflag,getalltnpjobsflag,Retries,InstitutionID)
SELECT E.tnpdate,E.priority,E.trantime,E.tranid,E.atid,E.acctid,E.ttid,E.nadandrooflag,E.getalltnpjobsflag,1,6981 
FROM errortnp E WITH(NOLOCK) WHERE E.ATID = 51 AND  E.tranid in (43951215840,43952677163)

DELETE FROM errortnp  WHERE ATID = 51  AND tranid in (43951215840,43952677163)

-----------------------------------------STEP 13
BEGIN TRANSACTION
--Commit
--Rollback

--2 rows will be affected

UPDATE errortnp SET TranTime=GetDATE(),TnpDate=GetDAte() WHERE  ATID=51 AND tranid  IN (43951276122,43952692697)
Update CCard_Primary set  TranTime = GetDATE(),PostTime= GetDAte() where tranid  IN (43951276122,43952692697)

INSERT INTO commontnp (tnpdate,priority,trantime,tranid,atid,acctid,ttid,nadandrooflag,getalltnpjobsflag,Retries,InstitutionID)
SELECT E.tnpdate,E.priority,E.trantime,E.tranid,E.atid,E.acctid,E.ttid,E.nadandrooflag,E.getalltnpjobsflag,1,6981 
FROM errortnp E WITH(NOLOCK) WHERE E.ATID = 51 AND  E.tranid in (43951276122,43952692697)

DELETE FROM errortnp  WHERE ATID = 51  AND tranid in (43951276122,43952692697)

-----------------------------------------STEP 14
BEGIN TRANSACTION
--Commit
--Rollback

--1 rows will be affected

UPDATE errortnp SET TranTime=GetDATE(),TnpDate=GetDAte() WHERE  ATID=51 AND tranid  IN (43952709614)
Update CCard_Primary set  TranTime = GetDATE(),PostTime= GetDAte() where tranid  IN (43952709614)

INSERT INTO commontnp (tnpdate,priority,trantime,tranid,atid,acctid,ttid,nadandrooflag,getalltnpjobsflag,Retries,InstitutionID)
SELECT E.tnpdate,E.priority,E.trantime,E.tranid,E.atid,E.acctid,E.ttid,E.nadandrooflag,E.getalltnpjobsflag,1,6981 
FROM errortnp E WITH(NOLOCK) WHERE E.ATID = 51 AND  E.tranid in (43952709614)

DELETE FROM errortnp  WHERE ATID = 51  AND tranid in (43952709614)

-----------------------------------------STEP 15
BEGIN TRANSACTION
--Commit
--Rollback

--1 rows will be affected

UPDATE errortnp SET TranTime=GetDATE(),TnpDate=GetDAte() WHERE  ATID=51 AND tranid  IN (43952731428)
Update CCard_Primary set  TranTime = GetDATE(),PostTime= GetDAte() where tranid  IN (43952731428)

INSERT INTO commontnp (tnpdate,priority,trantime,tranid,atid,acctid,ttid,nadandrooflag,getalltnpjobsflag,Retries,InstitutionID)
SELECT E.tnpdate,E.priority,E.trantime,E.tranid,E.atid,E.acctid,E.ttid,E.nadandrooflag,E.getalltnpjobsflag,1,6981 
FROM errortnp E WITH(NOLOCK) WHERE E.ATID = 51 AND  E.tranid in (43952731428)

DELETE FROM errortnp  WHERE ATID = 51  AND tranid in (43952731428)

-----------------------------------------STEP 16
BEGIN TRANSACTION
--Commit
--Rollback

--1 rows will be affected

UPDATE errortnp SET TranTime=GetDATE(),TnpDate=GetDAte() WHERE  ATID=51 AND tranid  IN (43951709732)
Update CCard_Primary set  TranTime = GetDATE(),PostTime= GetDAte() where tranid  IN (43951709732)

INSERT INTO commontnp (tnpdate,priority,trantime,tranid,atid,acctid,ttid,nadandrooflag,getalltnpjobsflag,Retries,InstitutionID)
SELECT E.tnpdate,E.priority,E.trantime,E.tranid,E.atid,E.acctid,E.ttid,E.nadandrooflag,E.getalltnpjobsflag,1,6981 
FROM errortnp E WITH(NOLOCK) WHERE E.ATID = 51 AND  E.tranid in (43951709732)

DELETE FROM errortnp  WHERE ATID = 51  AND tranid in (43951709732)

-----------------------------------------STEP 17
BEGIN TRANSACTION
--Commit
--Rollback

--1 rows will be affected

UPDATE errortnp SET TranTime=GetDATE(),TnpDate=GetDAte() WHERE  ATID=51 AND tranid  IN (43951734387)
Update CCard_Primary set  TranTime = GetDATE(),PostTime= GetDAte() where tranid  IN (43951734387)

INSERT INTO commontnp (tnpdate,priority,trantime,tranid,atid,acctid,ttid,nadandrooflag,getalltnpjobsflag,Retries,InstitutionID)
SELECT E.tnpdate,E.priority,E.trantime,E.tranid,E.atid,E.acctid,E.ttid,E.nadandrooflag,E.getalltnpjobsflag,1,6981 
FROM errortnp E WITH(NOLOCK) WHERE E.ATID = 51 AND  E.tranid in (43951734387)

DELETE FROM errortnp  WHERE ATID = 51  AND tranid in (43951734387)

-----------------------------------------STEP 18
BEGIN TRANSACTION
--Commit
--Rollback

--1 rows will be affected

UPDATE errortnp SET TranTime=GetDATE(),TnpDate=GetDAte() WHERE  ATID=51 AND tranid  IN (43951764937)
Update CCard_Primary set  TranTime = GetDATE(),PostTime= GetDAte() where tranid  IN (43951764937)

INSERT INTO commontnp (tnpdate,priority,trantime,tranid,atid,acctid,ttid,nadandrooflag,getalltnpjobsflag,Retries,InstitutionID)
SELECT E.tnpdate,E.priority,E.trantime,E.tranid,E.atid,E.acctid,E.ttid,E.nadandrooflag,E.getalltnpjobsflag,1,6981 
FROM errortnp E WITH(NOLOCK) WHERE E.ATID = 51 AND  E.tranid in (43951764937)

DELETE FROM errortnp  WHERE ATID = 51  AND tranid in (43951764937)

-----------------------------------------STEP 19
BEGIN TRANSACTION
--Commit
--Rollback

--1 rows will be affected

UPDATE errortnp SET TranTime=GetDATE(),TnpDate=GetDAte() WHERE  ATID=51 AND tranid  IN (43951782479)
Update CCard_Primary set  TranTime = GetDATE(),PostTime= GetDAte() where tranid  IN (43951782479)

INSERT INTO commontnp (tnpdate,priority,trantime,tranid,atid,acctid,ttid,nadandrooflag,getalltnpjobsflag,Retries,InstitutionID)
SELECT E.tnpdate,E.priority,E.trantime,E.tranid,E.atid,E.acctid,E.ttid,E.nadandrooflag,E.getalltnpjobsflag,1,6981 
FROM errortnp E WITH(NOLOCK) WHERE E.ATID = 51 AND  E.tranid in (43951782479)

DELETE FROM errortnp  WHERE ATID = 51  AND tranid in (43951782479)

-----------------------------------------STEP 20
BEGIN TRANSACTION
--Commit
--Rollback

--1 rows will be affected

UPDATE errortnp SET TranTime=GetDATE(),TnpDate=GetDAte() WHERE  ATID=51 AND tranid  IN (43953060038)
Update CCard_Primary set  TranTime = GetDATE(),PostTime= GetDAte() where tranid  IN (43953060038)

INSERT INTO commontnp (tnpdate,priority,trantime,tranid,atid,acctid,ttid,nadandrooflag,getalltnpjobsflag,Retries,InstitutionID)
SELECT E.tnpdate,E.priority,E.trantime,E.tranid,E.atid,E.acctid,E.ttid,E.nadandrooflag,E.getalltnpjobsflag,1,6981 
FROM errortnp E WITH(NOLOCK) WHERE E.ATID = 51 AND  E.tranid in (43953060038)

DELETE FROM errortnp  WHERE ATID = 51  AND tranid in (43953060038)

-----------------------------------------STEP 21
BEGIN TRANSACTION
--Commit
--Rollback

--1 rows will be affected

UPDATE errortnp SET TranTime=GetDATE(),TnpDate=GetDAte() WHERE  ATID=51 AND tranid  IN (43953367001)
Update CCard_Primary set  TranTime = GetDATE(),PostTime= GetDAte() where tranid  IN (43953367001)

INSERT INTO commontnp (tnpdate,priority,trantime,tranid,atid,acctid,ttid,nadandrooflag,getalltnpjobsflag,Retries,InstitutionID)
SELECT E.tnpdate,E.priority,E.trantime,E.tranid,E.atid,E.acctid,E.ttid,E.nadandrooflag,E.getalltnpjobsflag,1,6981 
FROM errortnp E WITH(NOLOCK) WHERE E.ATID = 51 AND  E.tranid in (43953367001)

DELETE FROM errortnp  WHERE ATID = 51  AND tranid in (43953367001)
