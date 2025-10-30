-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION

	-- 1 row UPDATE each statement unless specified

	UPDATE BSegmentCreditCard SET ManualInitialChargeOffReason = '3' WHERE acctId = 779409
	UPDATE BSegmentCreditCard SET ManualInitialChargeOffReason = '1' WHERE acctId = 1002682
	UPDATE BSegmentCreditCard SET ManualInitialChargeOffReason = '3' WHERE acctId = 1836328
	UPDATE BSegmentCreditCard SET ManualInitialChargeOffReason = '3' WHERE acctId = 1924544
	UPDATE BSegmentCreditCard SET ManualInitialChargeOffReason = '3' WHERE acctId = 1934910
	UPDATE BSegmentCreditCard SET ManualInitialChargeOffReason = '3' WHERE acctId = 2094738
	UPDATE BSegmentCreditCard SET ManualInitialChargeOffReason = '3' WHERE acctId = 2245136
	UPDATE BSegmentCreditCard SET ManualInitialChargeOffReason = '3' WHERE acctId = 2284868
	UPDATE BSegmentCreditCard SET ManualInitialChargeOffReason = '1' WHERE acctId = 2434558
	UPDATE BSegmentCreditCard SET ManualInitialChargeOffReason = '1' WHERE acctId = 2482176
	UPDATE BSegmentCreditCard SET ManualInitialChargeOffReason = '3' WHERE acctId = 2496406
	UPDATE BSegmentCreditCard SET ManualInitialChargeOffReason = '1' WHERE acctId = 2710989
	UPDATE BSegmentCreditCard SET ManualInitialChargeOffReason = '1' WHERE acctId = 2975141
	UPDATE BSegmentCreditCard SET ManualInitialChargeOffReason = '3' WHERE acctId = 4401484
	UPDATE BSegmentCreditCard SET ManualInitialChargeOffReason = '1' WHERE acctId = 4911916
	UPDATE BSegmentCreditCard SET ManualInitialChargeOffReason = '3' WHERE acctId = 5501178


	UPDATE BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 779409
	UPDATE BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 1002682
	UPDATE BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 1836328
	UPDATE BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 1924544
	UPDATE BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 1934910
	UPDATE BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 2094738
	UPDATE BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 2245136
	UPDATE BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 2284868
	UPDATE BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 2434558
	UPDATE BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 2482176
	UPDATE BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 2496406
	UPDATE BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 2710989
	UPDATE BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 2975141
	UPDATE BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 4401484
	UPDATE BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 4911916
	UPDATE BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 5501178
	

COMMIT TRANSACTION
--ROLLBACK TRANSACTION

