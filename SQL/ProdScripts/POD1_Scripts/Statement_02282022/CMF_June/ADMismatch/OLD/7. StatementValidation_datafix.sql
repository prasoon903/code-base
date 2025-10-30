Begin Transaction 
-- 378144 rows affected
--Commit Transaction
--Rollback Transaction

UPDATE StatementJobs SET Status= 'NEW' WHERE Status = 'ValidationError' and statementdate = '2021-06-30 23:59:57.000'
 and acctid in (SELECT  acctid from statementvalidation with (nolock) WHERE validationfail in ( 'Q11' ) and statementdate = '2021-06-30 23:59:57.000')  -- 7879 rows affected
  
UPDATE StatementJobs SET Status= 'NEW' WHERE Status = 'ValidationError' and statementdate = '2021-06-30 23:59:57.000' 
and acctid in (SELECT  acctid from statementvalidation with (nolock) WHERE validationfail in ( 'Q8' ) and statementdate = '2021-06-30 23:59:57.000')   --  344829 rows affected

UPDATE StatementJobs SET Status= 'NEW' WHERE Status = 'ValidationError' and statementdate = '2021-06-30 23:59:57.000'
 and acctid in (SELECT  acctid from statementvalidation with (nolock) WHERE validationfail in ( 'Q70' ) and statementdate = '2021-06-30 23:59:57.000')   -- 225 rows affected

UPDATE StatementJobs SET Status= 'NEW' WHERE Status = 'ValidationError' and statementdate = '2021-06-30 23:59:57.000'
 and acctid in (SELECT  acctid from statementvalidation with (nolock) WHERE validationfail in ( 'Q74' ) and statementdate = '2021-06-30 23:59:57.000')   -- 135 rows affected

UPDATE StatementJobs SET Status= 'NEW' WHERE Status = 'ValidationError' and statementdate = '2021-06-30 23:59:57.000' 
and acctid in (SELECT  acctid from statementvalidation with (nolock) WHERE validationfail in ( 'Q60' ) and statementdate = '2021-06-30 23:59:57.000')   -- 116 rows affected

UPDATE StatementJobs SET Status= 'NEW' WHERE Status = 'ValidationError' and statementdate = '2021-06-30 23:59:57.000'
 and acctid in (SELECT  acctid from statementvalidation with (nolock) WHERE validationfail in ( 'Q85' ) and statementdate = '2021-06-30 23:59:57.000')   -- 24960 rows affected


