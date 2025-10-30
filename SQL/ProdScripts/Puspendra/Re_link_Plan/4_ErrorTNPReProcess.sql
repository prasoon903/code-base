BEGIN TRAN
--COMMIT TRAN
--ROLLBACK TRAN


--DECLARE @TranIDToReprocess INT = 0
DECLARE @CurrentTime DATETIME = GETDATE()

----=============================== SET THE TRANID JOB TO REPROCESS ==================================
--SET @TranIDToReprocess = 94986312302
----=============================== SET THE TRANID JOB TO REPROCESS ==================================


--SELECT * FROM AccountsOfPlanToReLink



UPDATE E
SET TranTime=DATEADD(SECOND, TimeGap, @CurrentTime),TnpDate=DATEADD(SECOND, TimeGap, @CurrentTime)
FROM ErrorTNP E
JOIN AccountsOfPlanToReLink A ON (E.TranID = A.TranID AND E.ATID=51)
WHERE A.JobStatus = 2

UPDATE C
SET TranTime=CASE WHEN TranTime < PostTime THEN TranTime ELSE DATEADD(SECOND, TimeGap, @CurrentTime) END,PostTime=DATEADD(SECOND, TimeGap, @CurrentTime)
FROM CCard_Primary C
JOIN AccountsOfPlanToReLink A ON (C.TranID = A.TranID)
WHERE A.JobStatus = 2

INSERT INTO commontnp (tnpdate,priority,trantime,tranid,atid,acctid,ttid,nadandrooflag,getalltnpjobsflag, Retries,InstitutionID)
SELECT E.tnpdate,E.priority,E.trantime,E.tranid,E.atid,E.acctid,E.ttid,E.nadandrooflag,E.getalltnpjobsflag, 0,6981 
FROM errortnp E WITH(NOLOCK)
JOIN AccountsOfPlanToReLink A ON (E.TranID = A.TranID AND E.ATID=51)
WHERE A.JobStatus = 2

DELETE E
FROM ErrorTNP E
JOIN AccountsOfPlanToReLink A ON (E.TranID = A.TranID AND E.ATID=51)
WHERE A.JobStatus = 2

UPDATE AccountsOfPlanToReLink SET JobStatus = 3 WHERE JobStatus = 2



--UPDATE errortnp SET TranTime=@CurrentTime,TnpDate=@CurrentTime WHERE  ATID=51 AND tranid IN (@TranIDToReprocess)
-----(1 row(s) affected)

--Update CCard_Primary set TranTime=@CurrentTime, PostTime= @CurrentTime where tranid IN (@TranIDToReprocess)
---(1 row(s) affected)

--INSERT INTO commontnp (tnpdate,priority,trantime,tranid,atid,acctid,ttid,nadandrooflag,getalltnpjobsflag,InstitutionID)
--SELECT E.tnpdate,E.priority,E.trantime,E.tranid,E.atid,E.acctid,E.ttid,E.nadandrooflag,E.getalltnpjobsflag,6981 FROM errortnp E WITH(NOLOCK)
--WHERE E.ATID = 51 AND  E.tranid IN (@TranIDToReprocess)
-----(1 row(s) affected)

--DELETE FROM errortnp  WHERE ATID = 51  AND tranid  IN (@TranIDToReprocess)
---(1 row(s) affected)
