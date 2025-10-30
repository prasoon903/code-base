-----STEP ---- 1 ---------------

BEGIN TRAN
--COMMIT TRAN
--ROLLBACK TRAN

UPDATE TOP(1) BSegmentCreditCard SET ChargeOffDateParam = NULL, UserChargeOffStatus = '0' WHERE acctId = 11416041
UPDATE TOP(1) BSegment_Primary SET TpyBLOB = NULL, TpyLAD = NULL, TpyNAD = NULL WHERE acctId = 11416041


-----STEP ---- 2 ---------------

BEGIN TRAN
--COMMIT TRAN
--ROLLBACK TRAN

INSERT INTO commontnp (tnpdate,priority,trantime,tranid,atid,acctid,ttid,nadandrooflag,getalltnpjobsflag,InstitutionID)
SELECT E.tnpdate,E.priority,E.trantime,E.tranid,E.atid,E.acctid,E.ttid,E.nadandrooflag,E.getalltnpjobsflag,6981 FROM errortnp E WITH(NOLOCK)
WHERE E.ATID = 51  AND E.acctID  IN (11416041) AND E.TranID = 0
---(1 row(s) affected)

DELETE FROM errortnp  WHERE ATID = 51  AND acctID  IN (11416041) AND TranID = 0