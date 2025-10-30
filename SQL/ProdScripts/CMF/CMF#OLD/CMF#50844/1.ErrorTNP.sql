--**************************************STEP 1 ***************************************
--BS AcctID = 
--1573973
--TranID = 38181245216

BEGIN TRANSACTION A

delete from purchasereversalrecord 
where 
skey in (1573973)
and 
tranid in (38174541362)

--(1 rows affected)

--COMMIT TRANSACTION A
--ROLLBACK TRANSACTION A

--**************************************STEP 2 ***************************************

BEGIN TRANSACTION B


UPDATE errortnp SET TranTime=GetDATE(),TnpDate=GetDAte() WHERE  ATID=51 AND tranid  IN (38181245216)
---(1 rows affected)

Update CCard_Primary set  TranTime = GetDATE(),PostTime= GetDAte() where tranid  IN (38181245216)
---(1 rows affected)

INSERT INTO commontnp (tnpdate,priority,trantime,tranid,atid,acctid,ttid,nadandrooflag,getalltnpjobsflag,InstitutionID)
SELECT E.tnpdate,E.priority,E.trantime,E.tranid,E.atid,E.acctid,E.ttid,E.nadandrooflag,E.getalltnpjobsflag,6981 
FROM errortnp E WITH(NOLOCK) WHERE E.ATID = 51 AND  E.tranid in (38181245216)
---(1 rows affected)

DELETE FROM errortnp  WHERE ATID = 51  AND tranid IN (38181245216)
---(1 rows affected)

--Commit Transaction B 
--Rollback Transaction B 





