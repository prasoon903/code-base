-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreAuth
GO

BEGIN TRANSACTION
COMMIT TRANSACTION
-- ROLLBACK TRANSACTION




UPDATE TOP(1) BSegment_Primary SET SystemStatus = 3, DateOfLastDelinquent = '2021-05-31 23:59:57.000' WHERE acctId = 2478772

UPDATE TOP(1) BSegment_Primary SET SystemStatus = 2, DateOfLastDelinquent = NULL WHERE acctId = 4919331




/*
SELECT 'BS_AUTH====>', acctId, DaysDelinquent, DateOfLastDelinquent, SystemStatus, CCINHPARENT125AID 
FROM LS_PRODDRGSDB01.ccgs_coreauth.dbo.BSegment_Primary WITH (NOLOCK) 
WHERE acctId IN (2478772, 4919331)
*/