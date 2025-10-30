SELECT * FROm LS_PRODDRGSDB01.ccgs_coreauth.dbo.CoreAuthTransactions WITH (NOLOCK) WHERE TransactionUUID IN

('66c9db9f-f94a-44a0-90cc-2093a481541a')


SELECT * FROm Auth_Primary WITH (NOLOCK) WHERE TransactionUUID IN

('66c9db9f-f94a-44a0-90cc-2093a481541a')
AND AccountNumber = '1100011155033305'



SELECT * FROm CCard_Primary WITH (NOLOCK) WHERE UniversalUniqueId IN

('66c9db9f-f94a-44a0-90cc-2093a481541a')
AND CMTTranType = '40'

SELECT * 
FROM ##TempRecords t
JOIN CCard_Primary C ON (t.TransactionLifeCycleUUID = c.UniversalUniqueId)
WHERE c.CMTTRANTYPE = '40'