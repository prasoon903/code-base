BEGIN TRAN
--COMMIT TRAN
--ROLLBACK TRAN

UPDATE BSegment_Primary SET DateOfLastDelinquent = NULL, SystemStatus = 2 WHERE acctID = 17277194
UPDATE BSegment_Primary SET DateOfLastDelinquent = NULL, SystemStatus = 2 WHERE acctID = 2296309