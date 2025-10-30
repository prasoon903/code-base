BEGIN TRANSACTION

UPDATE CPSgmentCreditCard SET amountoftotaldue = AmountOfTotalDue - 22.12,
	AmtOfPayCurrDue = AmtOfPayCurrDue - 22.12,CycleDueDTD = 0 WHERE AcctId = 123793 

	-- 1 row update

UPDATE CurrentBalanceAuditPS SET newvalue = 0 WHERE IdentityField = 41430687

-- 1 row update

INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES 
(611283379,'2019-09-20 10:32:21.000',52,123793,'115','1','0')

-- 1 rows insert

--COMMIT
--ROLLBACK