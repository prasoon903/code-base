
Begin Transaction

UPDATE Bsegment_Primary SET DateAcctClosed= '2020-05-01 06:17:51.000',tpyblob=NULL,tpyNAD=NULL,tpyLAD=NULL WHERE ACCTID= 4782970  AND DateAcctClosed IS NULL
UPDATE Bsegment_Primary SET DateAcctClosed= '2020-05-01 05:19:18.000',tpyblob=NULL,tpyNAD=NULL,tpyLAD=NULL WHERE ACCTID= 605294   AND DateAcctClosed IS NULL
---------(2 row(s) affected)

--Commit Transaction
--Rollback Transaction