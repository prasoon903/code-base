--**************************************STEP 1 ***************************************

BEGIN TRANSACTION A

delete from purchasereversalrecord where tranid in (41743264454,41743264453,41743264452,41743264451,41743264450) 
and Skey in (2238544,2238543,2238542,2238541,2238540)

--(5 rows affected for each)

INSERT INTO PurchaseReversalRecord ( acctid, parent02aid, tranid, tranref, transactionamount, reversalflag, cmttrantype, tranorig, originaltranref, ReferenceTranID)
VALUES (817588,	805178,	41163697866,	41743264435,	1.41,	'1',	'121',	41744462078,	37786455919, 41743264434)
INSERT INTO PurchaseReversalRecord ( acctid, parent02aid, tranid, tranref, transactionamount, reversalflag, cmttrantype, tranorig, originaltranref, ReferenceTranID)
VALUES (817588,	805178,	41163697867,	41743264435,	1404.94,	'1',	'121',	41744462078,	37786455919, 41743264434)
INSERT INTO PurchaseReversalRecord ( acctid, parent02aid, tranid, tranref, transactionamount, reversalflag, cmttrantype, tranorig, originaltranref, ReferenceTranID)
VALUES (817588,	805178,	41163697871,	41743264435,	24.61,	'1',	'121',	41744462078,	37786455919, 41743264434)
INSERT INTO PurchaseReversalRecord ( acctid, parent02aid, tranid, tranref, transactionamount, reversalflag, cmttrantype, tranorig, originaltranref, ReferenceTranID)
VALUES (45983090,	805178,	41163697873,	41743264435,	47.02,	'1',	'121',	41744462078,	37786455919, 41743264434)
INSERT INTO PurchaseReversalRecord ( acctid, parent02aid, tranid, tranref, transactionamount, reversalflag, cmttrantype, tranorig, originaltranref, ReferenceTranID)
VALUES (4305441,	805178,	41743264461,	41743264435,	1.41,	'0',	'135',	41744462078,	37786455919, 41743264434)
INSERT INTO PurchaseReversalRecord ( acctid, parent02aid, tranid, tranref, transactionamount, reversalflag, cmttrantype, tranorig, originaltranref, ReferenceTranID)
VALUES (817588,	805178,	41743264460,	41743264435,	1430.96,	'0',	'121',	41744462078,	37786455919, 41743264434)

--(1 rows affected for each)

--COMMIT TRANSACTION A
--ROLLBACK TRANSACTION A

--**************************************STEP 2 ***************************************

BEGIN TRANSACTION

UPDATE errortnp SET TranTime=GetDATE(),TnpDate=GetDAte() WHERE  ATID=51 AND tranid  IN (41748768527)
Update CCard_Primary set  TranTime = GetDATE(),PostTime= GetDAte() where tranid  IN (41748768527)

INSERT INTO commontnp (tnpdate,priority,trantime,tranid,atid,acctid,ttid,nadandrooflag,getalltnpjobsflag,InstitutionID)
SELECT E.tnpdate,E.priority,E.trantime,E.tranid,E.atid,E.acctid,E.ttid,E.nadandrooflag,E.getalltnpjobsflag,6981 
FROM errortnp E WITH(NOLOCK) WHERE E.ATID = 51 AND  E.tranid in (41748768527)

DELETE FROM errortnp  WHERE ATID = 51  AND tranid IN (41748768527)

--(1 rows affected for each)

--Commit TRANSACTION
--Rollback TRANSACTION
