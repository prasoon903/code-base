

--------------------------------------------Step 1---------------------------------------

BEGIN TRAN
--COMMIT TRAN
--ROLLBACK TRAN

INSERT INTO purchasereversalrecord (acctid,parent02aid,tranid,tranref,transactionamount,reversalflag,cmttrantype,tranorig,originaltranref,referencetranid) 
VALUES
(2345933,		2298633,	58326806008,	58326805998,	37.67,	'0',	'121',     	58327347663,	58327347663,		58326805997)


--------------------------------------------Step 2---------------------------------------
Begin Transaction
DECLARE @CurrentTime DATETIME = GETDATE()

UPDATE errortnp SET TranTime=@CurrentTime,TnpDate=@CurrentTime WHERE  ATID=51 AND tranid IN (57347600961)
---(1 row(s) affected)

Update CCard_Primary set PostTime= @CurrentTime where tranid IN (57347600961)
---(1 row(s) affected)

INSERT INTO commontnp (tnpdate,priority,trantime,tranid,atid,acctid,ttid,nadandrooflag,getalltnpjobsflag,InstitutionID)
SELECT E.tnpdate,E.priority,E.trantime,E.tranid,E.atid,E.acctid,E.ttid,E.nadandrooflag,E.getalltnpjobsflag,6981 FROM errortnp E WITH(NOLOCK)
WHERE E.ATID = 51 AND  E.tranid IN (57347600961)
---(1 row(s) affected)

DELETE FROM errortnp  WHERE ATID = 51  AND tranid  IN (57347600961)
---(1 row(s) affected)
--Commit Transaction
--Rollback Transaction  