

-------------------------------------------STEP 1

BEGIN TRANSACTION
----Commit
----Rollback

update CPSgmentCreditCard set currentbalanceco = currentbalanceco + 10.92, recoveryfeesbnpco = recoveryfeesbnpco + 10.92 where 
acctid = 62089196
--1 ROWS.
update CPSgmentAccounts set decurrentbalance_trantime_ps = decurrentbalance_trantime_ps + 10.92 where acctid = 62089196
--1 ROWS.
update  BSegmentCreditCard set recoveryfeesbnpco = recoveryfeesbnpco + 10.92 where acctid  = 10233189
--1 rows
update BSegmentCreditCard set principalco = principalco + 20 where acctid = 335763
--1 rows

----------------------------------------STEP 2

BEGIN TRANSACTION
----Commit
----Rollback

update logartxnaddl set ExcludeFlag = 1 where tranid = 48603620861

--1 ROW .

----------------------------------------STEP 3

BEGIN TRANSACTION
----Commit
----Rollback

update currentbalanceauditps set newvalue = '17.35' where aid = 62089196 and dename = 222 and tid = 48601112890
and businessday = '2021-10-27 00:31:51.000' and atid = 52
--1 row.
update currentbalanceauditps set oldvalue = '17.35', newvalue = '25.30' where aid = 62089196 and dename = 222 and tid = 48827227280
and businessday = '2021-10-31 06:03:34.000' and atid = 52
--1 ROW .

----------------------------------------STEP 4

BEGIN TRANSACTION
----Commit
----Rollback


update statementheader set currentbalanceco = currentbalanceco + 10.92 where acctid in (10233189) 
and statementdate = '2021-10-31 23:59:57.000' and statementid = 107568589

update SummaryHeaderCreditCard set currentbalanceco = currentbalanceco + 10.92,recoveryfeesbnpco = recoveryfeesbnpco + 10.92  where 
acctid in (62089196) and statementid = 107568589



















