BEGIN TRAN
--COMMIT TRAN
--ROLLBACK TRAN


DECLARE @TranIDToReprocess INT = 0
DECLARE @CurrentTime DATETIME = GETDATE()

----=============================== SET THE TranID JOB TO REPROCESS ==================================
SET @TranIDToReprocess = 134508721911
----=============================== SET THE TranID JOB TO REPROCESS ==================================

--SELECT * FROM CCard_Primary WITH (NOLOCK) WHERE TranID = 134508721911

IF EXISTS (SELECT TOP 1 1 FROM ErrorAP WITH (NOLOCK) WHERE ATID=51 AND TranID IN (@TranIDToReprocess))
BEGIN

	UPDATE ErrorAP SET TranTime=@CurrentTime,TnpDate=@CurrentTime WHERE  ATID=51 AND TranID IN (@TranIDToReprocess)
	---(1 row(s) affected)

	Update CCard_Primary 
	SET TranTime=CASE WHEN TranTime < PostTime THEN TranTime ELSE @CurrentTime END, 
	PostTime= @CurrentTime 
	WHERE TranID IN (@TranIDToReprocess)
	---(1 row(s) affected)

	INSERT INTO CommonAP (tnpdate,priority,trantime,TranID,atid,acctid,ttid,nadandrooflag,getalltnpjobsflag,InstitutionID)
	SELECT E.tnpdate,E.priority,E.trantime,E.TranID,E.atid,E.acctid,E.ttid,E.nadandrooflag,E.getalltnpjobsflag,6981 
	FROM ErrorAP E WITH(NOLOCK)
	WHERE E.ATID = 51 AND  E.TranID IN (@TranIDToReprocess)
	---(1 row(s) affected)

	DELETE FROM ErrorAP  WHERE ATID = 51  AND TranID IN (@TranIDToReprocess)
	---(1 row(s) affected)

	DELETE FROM ErrorAP  WHERE ATID = 51  AND TranID  IN (134627711793)
	---(1 row(s) affected)

END

--SELECT * FROM ErrorAP WITH (NOLOCK) WHERE ATID=51 AND TranID IN (134627711793)
--SELECT * FROM Trans_In_Acct WITH (NOLOCK) WHERE tran_id_index IN (134508721911)
