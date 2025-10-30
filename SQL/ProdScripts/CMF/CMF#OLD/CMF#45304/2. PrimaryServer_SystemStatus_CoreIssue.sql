-- TO BE RUN ON PRIMARY SEVRER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION
-- COMMIT TRANSACTION
-- ROLLBACK TRANSACTION
UPDATE TOP(1) BSegment_Primary SET SystemStatus = 2 WHERE acctId = 1180076
UPDATE TOP(1) BSegment_Primary SET SystemStatus = 2 WHERE acctId = 1180260
UPDATE TOP(1) BSegment_Primary SET SystemStatus = 2 WHERE acctId = 1180513
UPDATE TOP(1) BSegment_Primary SET SystemStatus = 2 WHERE acctId = 1180593
UPDATE TOP(1) BSegment_Primary SET SystemStatus = 2 WHERE acctId = 1180773