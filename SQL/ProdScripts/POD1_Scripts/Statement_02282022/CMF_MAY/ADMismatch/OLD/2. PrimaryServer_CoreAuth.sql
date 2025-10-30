-- TO BE RUN ON PRIMARY SERVER ONLY

BEGIN TRANSACTION
COMMIT TRANSACTION
-- ROLLBACK TRANSACTION

USE CCGS_CoreAuth
GO


UPDATE TOP(1) BSegment_Primary SET DateOfLastDelinquent = '2021-05-31 23:59:57.000' WHERE acctId = 3211712

UPDATE TOP(1) BSegment_Primary SET SystemStatus = 15991, DateOfLastDelinquent = '2021-04-30 23:59:57.000' WHERE acctId = 311669

UPDATE TOP(1) BSegment_Primary SET DateOfLastDelinquent = '2021-05-31 23:59:57.000' WHERE acctId = 13004403



/*
SELECT 'BS_AUTH====>', acctId, DaysDelinquent, DateOfLastDelinquent, SystemStatus, CCINHPARENT125AID 
FROM LS_PRODDRGSDB01.ccgs_coreauth.dbo.BSegment_Primary WITH (NOLOCK) 
WHERE acctId IN (3211712, 311669, 13004403)
*/