SELECT * FROm LS_PRODDRGSDB01.ccgs_coreauth.dbo.CoreAuthTransactions WITH (NOLOCK) WHERE TransactionUUID IN

('586e23b6-80f8-4f50-8ad7-938099fc01cc',
'60580359-51a9-4383-adad-b4be5585f529',
'64ab57b1-d6d1-4327-b0bd-19cb1fcca880',
'a148deca-3d64-4f12-bf94-0a3351f81d66')


SELECT * FROm Auth_Primary WITH (NOLOCK) WHERE TransactionUUID IN

('586e23b6-80f8-4f50-8ad7-938099fc01cc',
'60580359-51a9-4383-adad-b4be5585f529',
'64ab57b1-d6d1-4327-b0bd-19cb1fcca880',
'a148deca-3d64-4f12-bf94-0a3351f81d66')



SELECT * FROm CCard_Primary WITH (NOLOCK) WHERE UniversalUniqueId IN

('586e23b6-80f8-4f50-8ad7-938099fc01cc',
'60580359-51a9-4383-adad-b4be5585f529',
'64ab57b1-d6d1-4327-b0bd-19cb1fcca880',
'a148deca-3d64-4f12-bf94-0a3351f81d66')
AND CMTTranType = '40'

SELECT * 
FROM ##TempRecords t
JOIN CCard_Primary C ON (t.TransactionLifeCycleUUID = c.UniversalUniqueId)
WHERE c.CMTTRANTYPE = '40'