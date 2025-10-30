BEGIN TRAN
--COMMIT TRAN
--ROLLBACK TRAN


--UPDATE CCard_Primary SET ArTxnType = '93', PostingRef = 'Duplicate as of 134508721911' WHERE TranID = 134627711793

DECLARE @CurrentTime DATETIME = GETDATE()

--SELECT * FROM AccountsOfPlanToReLink

UPDATE E
SET TranTime=DATEADD(SECOND, TimeGap, @CurrentTime),TnpDate=DATEADD(SECOND, TimeGap, @CurrentTime)
FROM ErrorAP E
JOIN AccountsOfPlanToReLink A ON (E.TranID = A.TranID AND E.ATID=51)
WHERE A.JobStatus = 2

UPDATE C
SET TranTime=CASE WHEN TranTime < PostTime THEN TranTime ELSE DATEADD(SECOND, TimeGap, @CurrentTime) END,PostTime=DATEADD(SECOND, TimeGap, @CurrentTime)
FROM CCard_Primary C
JOIN AccountsOfPlanToReLink A ON (C.TranID = A.TranID)
WHERE A.JobStatus = 2

INSERT INTO CommonAP (tnpdate,priority,trantime,tranid,atid,acctid,ttid,nadandrooflag,getalltnpjobsflag, Retries,InstitutionID)
SELECT E.tnpdate,E.priority,E.trantime,E.tranid,E.atid,E.acctid,E.ttid,E.nadandrooflag,E.getalltnpjobsflag, 0,6981 
FROM ErrorAP E WITH(NOLOCK)
JOIN AccountsOfPlanToReLink A ON (E.TranID = A.TranID AND E.ATID=51)
WHERE A.JobStatus = 2

DELETE E
FROM ErrorAP E
JOIN AccountsOfPlanToReLink A ON (E.TranID = A.TranID AND E.ATID=51)
WHERE A.JobStatus = 2

UPDATE AccountsOfPlanToReLink SET JobStatus = 3 WHERE JobStatus = 2
