-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

/************************STEP 1*********************/

BEGIN TRANSACTION
--COMMIT TRANSACTION
--ROLLBACK TRANSACTION

-- UPDATE WILL BE 1 ROW EACH STATEMENT

DECLARE @CurrentTime DATETIME = GETDATE()


UPDATE errortnp SET TranTime=@CurrentTime,TnpDate=@CurrentTime WHERE  ATID=51 AND tranid  IN (39575424084)

Update CCard_Primary set  TranTime = @CurrentTime,PostTime= @CurrentTime where tranid  IN (39575424084)


/************************STEP 2*********************/


BEGIN TRANSACTION
--COMMIT TRANSACTION
--ROLLBACK TRANSACTION

INSERT INTO commontnp (tnpdate,priority,trantime,tranid,atid,acctid,ttid,nadandrooflag,getalltnpjobsflag,InstitutionID)
SELECT E.tnpdate,E.priority,E.trantime,E.tranid,E.atid,E.acctid,E.ttid,E.nadandrooflag,E.getalltnpjobsflag,6981 
FROM errortnp E WITH(NOLOCK) WHERE E.ATID = 51 AND  E.tranid in (39575424084)
---(1 rows affected)

DELETE FROM errortnp  WHERE ATID = 51  AND tranid IN (39575424084)
---(1 rows affected)