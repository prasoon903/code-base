-- TO BE RUN ON PRIMARY SERVER ONLY


USE CCGS_CoreAuth
GO

BEGIN TRANSACTION
COMMIT TRANSACTION
-- ROLLBACK TRANSACTION





UPDATE TOP(1) BSegment_Primary SET SystemStatus = 2 WHERE acctId = 4346940
UPDATE TOP(1) BSegment_Primary SET SystemStatus = 2 WHERE acctId = 6404696
UPDATE TOP(1) BSegment_Primary SET SystemStatus = 2 WHERE acctId = 12400964
UPDATE TOP(1) BSegment_Primary SET SystemStatus = 2 WHERE acctId = 18251859
UPDATE TOP(1) BSegment_Primary SET SystemStatus = 2 WHERE acctId = 18683978
UPDATE TOP(1) BSegment_Primary SET SystemStatus = 2 WHERE acctId = 19385355




/*
SELECT 'BS_AUTH====>', acctId, DaysDelinquent, DateOfLastDelinquent, SystemStatus, CCINHPARENT125AID 
FROM LS_PRODDRGSDB01.ccgs_coreauth.dbo.BSegment_Primary WITH (NOLOCK) 
WHERE acctId IN (4346940, 6404696, 12400964, 18251859, 18683978, 19385355)
*/