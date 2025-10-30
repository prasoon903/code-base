-------------------------------------------STEP 1

BEGIN TRANSACTION
------Commit
------Rollback

delete from purchasereversalrecord  where skey in 
(7795155,
7795156,
7795157,
7795158) and 
tranid in (90407393840,
90407393841,
90407393842,
90407393843)
----4 rows.

---------------------------------------------STEP 2

BEGIN TRANSACTION
------Commit
------Rollback

UPDATE errortnp SET TranTime=GetDATE(),TnpDate=GetDAte() WHERE  ATID=51 AND tranid  IN (95863897352)
----1 ROWS .
Update CCard_Primary set  TranTime = GetDATE(),PostTime= GetDAte() where tranid  IN (95863897352)
----1 ROWS .

INSERT INTO commontnp (tnpdate,priority,trantime,tranid,atid,acctid,ttid,nadandrooflag,getalltnpjobsflag,InstitutionID)
SELECT E.tnpdate,E.priority,E.trantime,E.tranid,E.atid,E.acctid,E.ttid,E.nadandrooflag,E.getalltnpjobsflag,6981 
FROM errortnp E WITH(NOLOCK) WHERE E.ATID = 51 AND  E.tranid IN (95863897352)
----1 ROWS .

DELETE FROM errortnp  WHERE ATID = 51  AND tranid IN (95863897352)
----1 ROWS .

---------------------------------------------STEP 3

select count(1) from trans_in_acct with(nolock) where tran_id_index = 95863897352
select count(1) from errortnp with(nolock) where tranid = 95863897352

--NOTE : if count(1) = 1 from any of the the above query then run below script.

BEGIN TRANSACTION
----Commit
----Rollback

--4 rows
INSERT INTO PurchaseReversalRecord ( acctid, parent02aid, tranid, tranref, transactionamount, reversalflag, cmttrantype, tranorig, originaltranref)
VALUES (1040465,	1028045,	90407393840,	90407048862,	99.00,	'0',	'121',	90395269697,	89856893066)
INSERT INTO PurchaseReversalRecord ( acctid, parent02aid, tranid, tranref, transactionamount, reversalflag, cmttrantype, tranorig, originaltranref)
VALUES (1040465,	1028045,	90407393840,	90407048862,	949.00,	'0',	'121',	90395269697,	89856893066)
INSERT INTO PurchaseReversalRecord ( acctid, parent02aid, tranid, tranref, transactionamount, reversalflag, cmttrantype, tranorig, originaltranref)
VALUES (1040465,	1028045,	90407393840,	90407048862,	100.00,	'0',	'121',	90395269697,	89856893066)
INSERT INTO PurchaseReversalRecord ( acctid, parent02aid, tranid, tranref, transactionamount, reversalflag, cmttrantype, tranorig, originaltranref)
VALUES (1040465,	1028045,	90407393840,	90407048862,	119.00,	'0',	'121',	90395269697,	89856893066)



