-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION
--COMMIT TRANSACTION
--ROLLBACK TRANSACTION

-- UPDATE WILL BE 1 ROW EACH STATEMENT

UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 37 WHERE acctId = 12994172
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 37, RunningMinimumDue = RunningMinimumDue - 37, 
RemainingMinimumDue = RemainingMinimumDue - 37, DateOfOriginalPaymentDueDTD = NULL, FirstDueDate = NULL  WHERE acctId = 12994172

UPDATE TOP(1) DelinquencyRecord SET AmtOfPayCurrDue = AmtOfPayCurrDue + 37 WHERE TranID = 36930428411 AND acctId = 12994172

INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(36930428411, '2021-03-16 09:15:49.000', 51, 12994172, 200, '37', '0.00'),
(36930428411, '2021-03-16 09:15:49.000', 51, 12994172, 115, '1', '0')



UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 8.7, AmountOfTotalDue = AmountOfTotalDue - 8.7 WHERE acctId = 2378669

INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(36910347588, '2021-03-15 20:34:18.000', 52, 2378669, 200, '8.7', '0.00'),
(36910347588, '2021-03-15 20:34:18.000', 52, 2378669, 115, '1', '0')



UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 3.02, AmountOfTotalDue = AmountOfTotalDue - 3.02 WHERE acctId = 752524

INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(37208832771, '2021-03-24 20:33:57.000', 52, 752524, 200, '3.02', '0.00'),
(37208832771, '2021-03-24 20:33:57.000', 52, 752524, 115, '1', '0')



--UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, AmtOfPayCurrDue = AmtOfPayCurrDue + 3.65 WHERE acctId = 13431777
--UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 3.65, RunningMinimumDue = RunningMinimumDue + 3.65, 
--RemainingMinimumDue = RemainingMinimumDue + 3.65, DateOfOriginalPaymentDueDTD = '2021-03-31 23:59:57', FirstDueDate = '2021-03-31 23:59:57' WHERE acctId = 13431777

--UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '160.12' WHERE AID = 13431777 AND ATID = 51 AND IdentityField = 1217626229
--UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '3.65' WHERE AID = 13431777 AND ATID = 51 AND IdentityField = 1260815195
--DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 13431777 AND ATID = 51 AND IdentityField = 1260815194

UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 3.65, AmountOfTotalDue = AmountOfTotalDue - 3.65 WHERE acctId = 41887084




UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 20.58 WHERE acctId = 2740721
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 20.58 WHERE acctId = 2740721

DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 2740721 AND ATID = 51 AND IdentityField = 1222013976
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 2740721 AND ATID = 51 AND IdentityField = 1222013977



UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 33 WHERE acctId = 1995164
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 33, RunningMinimumDue = RunningMinimumDue - 33, 
RemainingMinimumDue = RemainingMinimumDue - 33, DateOfOriginalPaymentDueDTD = NULL, FirstDueDate = NULL  WHERE acctId = 1995164

UPDATE TOP(1) DelinquencyRecord SET AmtOfPayCurrDue = AmtOfPayCurrDue + 33 WHERE TranID = 36916372984 AND acctId = 1995164

INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(36916372984, '2021-03-15 21:31:58.000', 51, 1995164, 200, '33', '0.00'),
(36916372984, '2021-03-15 21:31:58.000', 51, 1995164, 115, '1', '0')



UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, AmtOfPayCurrDue = AmtOfPayCurrDue + 41.5 WHERE acctId = 9446252
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 41.5, RunningMinimumDue = RunningMinimumDue + 41.5, 
RemainingMinimumDue = RemainingMinimumDue + 41.5, DateOfOriginalPaymentDueDTD = '2021-03-31 23:59:57', FirstDueDate = '2021-03-31 23:59:57'  WHERE acctId = 9446252


INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(36940512217, '2021-03-16 16:12:24.000', 51, 9446252, 200, '0.00', '41.50'),
(36940512217, '2021-03-16 16:12:24.000', 51, 9446252, 115, '0', '1')



UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 5.53, AmountOfTotalDue = AmountOfTotalDue - 5.53 WHERE acctId = 3032696

INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(37422302567, '2021-03-30 20:42:58.000', 52, 3032696, 200, '5.53', '0.00'),
(37422302567, '2021-03-30 20:42:58.000', 52, 3032696, 115, '1', '0')



UPDATE TOP(1) BSegmentCreditCard SET ManualInitialChargeOffReason = '2' WHERE acctId = 45788
UPDATE TOP(1) BSegmentCreditCard SET ManualInitialChargeOffReason = '2' WHERE acctId = 277084
UPDATE TOP(1) BSegmentCreditCard SET ManualInitialChargeOffReason = '2' WHERE acctId = 278563
UPDATE TOP(1) BSegmentCreditCard SET ManualInitialChargeOffReason = '2' WHERE acctId = 293955
UPDATE TOP(1) BSegmentCreditCard SET ManualInitialChargeOffReason = '2' WHERE acctId = 307514
UPDATE TOP(1) BSegmentCreditCard SET ManualInitialChargeOffReason = '1' WHERE acctId = 334688
UPDATE TOP(1) BSegmentCreditCard SET ManualInitialChargeOffReason = '1' WHERE acctId = 1053887
UPDATE TOP(1) BSegmentCreditCard SET ManualInitialChargeOffReason = '6' WHERE acctId = 1156474
UPDATE TOP(1) BSegmentCreditCard SET ManualInitialChargeOffReason = '2' WHERE acctId = 1278892
UPDATE TOP(1) BSegmentCreditCard SET ManualInitialChargeOffReason = '2' WHERE acctId = 1317904
UPDATE TOP(1) BSegmentCreditCard SET ManualInitialChargeOffReason = '2' WHERE acctId = 1667620
UPDATE TOP(1) BSegmentCreditCard SET ManualInitialChargeOffReason = '2' WHERE acctId = 1834004
UPDATE TOP(1) BSegmentCreditCard SET ManualInitialChargeOffReason = '2' WHERE acctId = 1957378
UPDATE TOP(1) BSegmentCreditCard SET ManualInitialChargeOffReason = '1' WHERE acctId = 2032526
UPDATE TOP(1) BSegmentCreditCard SET ManualInitialChargeOffReason = '1' WHERE acctId = 2068344
UPDATE TOP(1) BSegmentCreditCard SET ManualInitialChargeOffReason = '2' WHERE acctId = 2163674
UPDATE TOP(1) BSegmentCreditCard SET ManualInitialChargeOffReason = '2' WHERE acctId = 2386763
UPDATE TOP(1) BSegmentCreditCard SET ManualInitialChargeOffReason = '3' WHERE acctId = 343912
UPDATE TOP(1) BSegmentCreditCard SET ManualInitialChargeOffReason = '3' WHERE acctId = 439547
UPDATE TOP(1) BSegmentCreditCard SET ManualInitialChargeOffReason = '3' WHERE acctId = 934898
UPDATE TOP(1) BSegmentCreditCard SET ManualInitialChargeOffReason = '3' WHERE acctId = 1336000
UPDATE TOP(1) BSegmentCreditCard SET ManualInitialChargeOffReason = '3' WHERE acctId = 1688332
UPDATE TOP(1) BSegmentCreditCard SET ManualInitialChargeOffReason = '3' WHERE acctId = 1858685
UPDATE TOP(1) BSegmentCreditCard SET ManualInitialChargeOffReason = '3' WHERE acctId = 2204884
UPDATE TOP(1) BSegmentCreditCard SET ManualInitialChargeOffReason = '3' WHERE acctId = 2306145
UPDATE TOP(1) BSegmentCreditCard SET ManualInitialChargeOffReason = '3' WHERE acctId = 2450847
UPDATE TOP(1) BSegmentCreditCard SET ManualInitialChargeOffReason = '3' WHERE acctId = 2513823
UPDATE TOP(1) BSegmentCreditCard SET ManualInitialChargeOffReason = '3' WHERE acctId = 2735093
UPDATE TOP(1) BSegmentCreditCard SET ManualInitialChargeOffReason = '3' WHERE acctId = 2906778
UPDATE TOP(1) BSegmentCreditCard SET ManualInitialChargeOffReason = '3' WHERE acctId = 2954466
UPDATE TOP(1) BSegmentCreditCard SET ManualInitialChargeOffReason = '3' WHERE acctId = 3438950
UPDATE TOP(1) BSegmentCreditCard SET ManualInitialChargeOffReason = '3' WHERE acctId = 4238597
UPDATE TOP(1) BSegmentCreditCard SET ManualInitialChargeOffReason = '3' WHERE acctId = 4666090
UPDATE TOP(1) BSegmentCreditCard SET ManualInitialChargeOffReason = '3' WHERE acctId = 5600182
UPDATE TOP(1) BSegmentCreditCard SET ManualInitialChargeOffReason = '3' WHERE acctId = 6906895


UPDATE TOP(1) BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 45788
UPDATE TOP(1) BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 277084
UPDATE TOP(1) BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 278563
UPDATE TOP(1) BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 293955
UPDATE TOP(1) BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 307514
UPDATE TOP(1) BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 334688
UPDATE TOP(1) BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 1053887
UPDATE TOP(1) BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 1156474
UPDATE TOP(1) BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 1278892
UPDATE TOP(1) BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 1317904
UPDATE TOP(1) BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 1667620
UPDATE TOP(1) BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 1834004
UPDATE TOP(1) BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 1957378
UPDATE TOP(1) BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 2032526
UPDATE TOP(1) BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 2068344
UPDATE TOP(1) BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 2163674
UPDATE TOP(1) BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 2386763
UPDATE TOP(1) BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 343912
UPDATE TOP(1) BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 439547
UPDATE TOP(1) BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 934898
UPDATE TOP(1) BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 1336000
UPDATE TOP(1) BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 1688332
UPDATE TOP(1) BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 1858685
UPDATE TOP(1) BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 2204884
UPDATE TOP(1) BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 2306145
UPDATE TOP(1) BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 2450847
UPDATE TOP(1) BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 2513823
UPDATE TOP(1) BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 2735093
UPDATE TOP(1) BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 2906778
UPDATE TOP(1) BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 2954466
UPDATE TOP(1) BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 3438950
UPDATE TOP(1) BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 4238597
UPDATE TOP(1) BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 4666090
UPDATE TOP(1) BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 5600182
UPDATE TOP(1) BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 6906895


update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 77.92 where  acctid  =  39436991
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 143.33 where  acctid  =  27292110
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 346.00 where  acctid  =  37084100
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 56.00 where  acctid  =  30499788
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 19.98 where  acctid  =  41074050
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 11.20 where  acctid  =  34609762
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 599.00 where  acctid  =  47264604
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 149.00 where  acctid  =  47264603