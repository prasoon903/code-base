BEGIN TRAN
--COMMIT TRAN
--ROLLBACK TRAN

DECLARE @TranID DECIMAL(19, 0)

--108524863883 -- donne
--108628177700
--108659791748
--108941689761
--108941905122

SET @TranID = 108524863883


DECLARE @CurrentTime DATETIME = GETDATE()

--SELECT * FROM LS_P1MARPRODDB01.ccgs_coreissue.dbo.ErrorAP WITH (NOLOCK)

UPDATE E
SET TranTime=@CurrentTime,TnpDate=@CurrentTime
FROM ErrorAP E
WHERE TranID = @TranID

UPDATE C
SET TranTime=CASE WHEN TranTime < PostTime THEN TranTime ELSE @CurrentTime END,PostTime=@CurrentTime
FROM CCard_Primary C
WHERE TranID = @TranID 

INSERT INTO CommonAP (tnpdate,priority,trantime,tranid,atid,acctid,ttid,nadandrooflag,getalltnpjobsflag, Retries,InstitutionID)
SELECT E.tnpdate,E.priority,E.trantime,E.tranid,E.atid,E.acctid,E.ttid,E.nadandrooflag,E.getalltnpjobsflag, 0,6981 
FROM ErrorAP E WITH(NOLOCK)
WHERE TranID = @TranID

DELETE E
FROM ErrorAP E
WHERE TranID = @TranID
