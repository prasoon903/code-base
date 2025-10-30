BEGIN TRAN
	UPDATE logartxnaddl SET txncode_internal = 18243 where tranid = 710221877
	-- 1 row update
	UPDATE Ccard_primary SET txncode_internal = 18243 where tranid = 710221877
	-- 1 row update
--COMMIT
--ROLLBACK