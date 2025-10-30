BEGIN TRANSACTION
--COMMIT TRANSACTION
--ROLLBACK TRANSACTION

UPDATE T1
SET TransactionAmount = -CurrentBalanceCO
FROM TransactionCreationTempData T1
JOIN BSegmentCreditCard BC WITH (NOLOCK) ON (T1.TxnAcctId = BC.acctID)
WHERE T1.JiraID = 'COOKIE-278070'

UPDATE TransactionCreationTempData SET JobStatus = -1 WHERE TransactionAmount <= 0



/*
SELECT T1.*, CurrentBalanceCO
FROM TransactionCreationTempData T1 WITH (NOLOCK)
JOIN BSegmentCreditCard BC WITH (NOLOCK) ON (T1.TxnAcctId = BC.acctID)
WHERE JiraID = 'COOKIE-278070'
*/