BEGIN TRAN 
 -- COMMIT TRAN
 -- ROLLBACK TRAN



UPDATE TOP(1) BSegment_Primary SET SystemStatus = 2, DateOfLastDelinquent = NULL WHERE AcctID = 18310733
UPDATE TOP(1) BSegment_Primary SET SystemStatus = 2, DateOfLastDelinquent = NULL WHERE AcctID = 21471284