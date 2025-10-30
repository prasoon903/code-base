BEGIN TRAN
--COMMIT TRAN
--ROLLBACK TRAN

UPDATE TOP(1) BSegmentCreditCard SET ChargeOffDateParam = '2024-03-31 23:59:55', ManualInitialChargeOffStartDate = '2024-02-28 23:59:57', 
ManualInitialChargeOffReason = '6', UserChargeOffStatus = '1' WHERE acctID = 2811762
UPDATE TOP(1) BSegment_Primary SET NAD = '2024-03-31 23:59:55' WHERE acctID = 2811762
UPDATE TOP(1) CommonTNP SET TranTime = '2024-03-31 23:59:55' WHERE acctID = 2811762 AND TranID = 0