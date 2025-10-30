-- TO BE RUN ON PRIMARY SERVER ONLY


USE CCGS_CoreAuth
GO

BEGIN TRANSACTION
COMMIT TRANSACTION
-- ROLLBACK TRANSACTION





UPDATE TOP(1) BSegment_Primary SET SystemStatus = 2 WHERE acctId = 10895026
UPDATE TOP(1) BSegment_Primary SET SystemStatus = 2 WHERE acctId = 15709599




/*
SELECT 'BS_AUTH====>', acctId, DaysDelinquent, DateOfLastDelinquent, SystemStatus, CCINHPARENT125AID 
FROM PROD1GSDB01.ccgs_coreauth.dbo.BSegment_Primary WITH (NOLOCK) 
WHERE acctId IN (10895026, 15709599)
*/