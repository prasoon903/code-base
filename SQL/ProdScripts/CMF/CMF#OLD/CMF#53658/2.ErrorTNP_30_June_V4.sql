--**************************************STEP 1 ***************************************

BEGIN TRANSACTION A

delete from purchasereversalrecord where tranid in (41757825026) 
and Skey in (2240241)

--(1 rows affected for each)

--COMMIT TRANSACTION A
--ROLLBACK TRANSACTION A

--**************************************STEP 2 ***************************************

BEGIN TRANSACTION

UPDATE errortnp SET TranTime=GetDATE(),TnpDate=GetDAte() WHERE  ATID=51 AND tranid  IN (41770865245)
Update CCard_Primary set  TranTime = GetDATE(),PostTime= GetDAte() where tranid  IN (41770865245)

INSERT INTO commontnp (tnpdate,priority,trantime,tranid,atid,acctid,ttid,nadandrooflag,getalltnpjobsflag,InstitutionID)
SELECT E.tnpdate,E.priority,E.trantime,E.tranid,E.atid,E.acctid,E.ttid,E.nadandrooflag,E.getalltnpjobsflag,6981 
FROM errortnp E WITH(NOLOCK) WHERE E.ATID = 51 AND  E.tranid in (41770865245)

DELETE FROM errortnp  WHERE ATID = 51  AND tranid IN (41770865245)

--(1 rows affected for each)

--Commit TRANSACTION
--Rollback TRANSACTION
