-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION
--COMMIT TRANSACTION
--ROLLBACK TRANSACTION

-- UPDATE WILL BE 1 ROW EACH STATEMENT


UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 5.58, AmtOfPayCurrDue = AmtOfPayCurrDue + 5.58, CycleDueDTD = 1 WHERE acctId = 770282

UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = '5.58' WHERE AID = 770282 AND ATID = 52 AND IdentityField = 2356505814

DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 770282 AND ATID = 52 AND IdentityField = 2356505815



UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 3.93, AmtOfPayXDLate = AmtOfPayXDLate - 3.93, CycleDueDTD = 0 WHERE acctId = 44736444
UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0 WHERE acctId = 40105381

DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 44736444 AND ATID = 52 AND IdentityField = 2366055602
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 44736444 AND ATID = 52 AND IdentityField = 2366055603
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 40105381 AND ATID = 52 AND IdentityField = 2366055599




UPDATE TOP(1) BSegmentCreditCard SET ManualInitialChargeOffReason = '2' WHERE acctId = 293115
UPDATE TOP(1) BSegmentCreditCard SET ManualInitialChargeOffReason = '1' WHERE acctId = 294192
UPDATE TOP(1) BSegmentCreditCard SET ManualInitialChargeOffReason = '1' WHERE acctId = 334184
UPDATE TOP(1) BSegmentCreditCard SET ManualInitialChargeOffReason = '2' WHERE acctId = 363111
UPDATE TOP(1) BSegmentCreditCard SET ManualInitialChargeOffReason = '2' WHERE acctId = 446324
UPDATE TOP(1) BSegmentCreditCard SET ManualInitialChargeOffReason = '2' WHERE acctId = 451786
UPDATE TOP(1) BSegmentCreditCard SET ManualInitialChargeOffReason = '1' WHERE acctId = 452566
UPDATE TOP(1) BSegmentCreditCard SET ManualInitialChargeOffReason = '1' WHERE acctId = 503318
UPDATE TOP(1) BSegmentCreditCard SET ManualInitialChargeOffReason = '1' WHERE acctId = 520937
UPDATE TOP(1) BSegmentCreditCard SET ManualInitialChargeOffReason = '6' WHERE acctId = 781496
UPDATE TOP(1) BSegmentCreditCard SET ManualInitialChargeOffReason = '1' WHERE acctId = 1867647
UPDATE TOP(1) BSegmentCreditCard SET ManualInitialChargeOffReason = '2' WHERE acctId = 1892491
UPDATE TOP(1) BSegmentCreditCard SET ManualInitialChargeOffReason = '1' WHERE acctId = 1971597
UPDATE TOP(1) BSegmentCreditCard SET ManualInitialChargeOffReason = '2' WHERE acctId = 2268309
UPDATE TOP(1) BSegmentCreditCard SET ManualInitialChargeOffReason = '2' WHERE acctId = 2278663
UPDATE TOP(1) BSegmentCreditCard SET ManualInitialChargeOffReason = '2' WHERE acctId = 2410733
UPDATE TOP(1) BSegmentCreditCard SET ManualInitialChargeOffReason = '6' WHERE acctId = 2517405
UPDATE TOP(1) BSegmentCreditCard SET ManualInitialChargeOffReason = '1' WHERE acctId = 2573756
UPDATE TOP(1) BSegmentCreditCard SET ManualInitialChargeOffReason = '1' WHERE acctId = 2758108
UPDATE TOP(1) BSegmentCreditCard SET ManualInitialChargeOffReason = '2' WHERE acctId = 2800030
UPDATE TOP(1) BSegmentCreditCard SET ManualInitialChargeOffReason = '2' WHERE acctId = 3592487
UPDATE TOP(1) BSegmentCreditCard SET ManualInitialChargeOffReason = '1' WHERE acctId = 4133367
UPDATE TOP(1) BSegmentCreditCard SET ManualInitialChargeOffReason = '2' WHERE acctId = 4562578
UPDATE TOP(1) BSegmentCreditCard SET ManualInitialChargeOffReason = '1' WHERE acctId = 4582496
UPDATE TOP(1) BSegmentCreditCard SET ManualInitialChargeOffReason = '1' WHERE acctId = 4696989
UPDATE TOP(1) BSegmentCreditCard SET ManualInitialChargeOffReason = '2' WHERE acctId = 4902062
UPDATE TOP(1) BSegmentCreditCard SET ManualInitialChargeOffReason = '3' WHERE acctId = 279203
UPDATE TOP(1) BSegmentCreditCard SET ManualInitialChargeOffReason = '3' WHERE acctId = 791513
UPDATE TOP(1) BSegmentCreditCard SET ManualInitialChargeOffReason = '3' WHERE acctId = 944294
UPDATE TOP(1) BSegmentCreditCard SET ManualInitialChargeOffReason = '3' WHERE acctId = 1080881
UPDATE TOP(1) BSegmentCreditCard SET ManualInitialChargeOffReason = '3' WHERE acctId = 1755201
UPDATE TOP(1) BSegmentCreditCard SET ManualInitialChargeOffReason = '3' WHERE acctId = 1766754
UPDATE TOP(1) BSegmentCreditCard SET ManualInitialChargeOffReason = '3' WHERE acctId = 2429222
UPDATE TOP(1) BSegmentCreditCard SET ManualInitialChargeOffReason = '3' WHERE acctId = 2616583
UPDATE TOP(1) BSegmentCreditCard SET ManualInitialChargeOffReason = '3' WHERE acctId = 2728489
UPDATE TOP(1) BSegmentCreditCard SET ManualInitialChargeOffReason = '3' WHERE acctId = 2884194
UPDATE TOP(1) BSegmentCreditCard SET ManualInitialChargeOffReason = '3' WHERE acctId = 2917094
UPDATE TOP(1) BSegmentCreditCard SET ManualInitialChargeOffReason = '3' WHERE acctId = 6256502
UPDATE TOP(1) BSegmentCreditCard SET ManualInitialChargeOffReason = '3' WHERE acctId = 7605435


UPDATE TOP(1) BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 293115
UPDATE TOP(1) BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 294192
UPDATE TOP(1) BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 334184
UPDATE TOP(1) BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 363111
UPDATE TOP(1) BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 446324
UPDATE TOP(1) BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 451786
UPDATE TOP(1) BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 452566
UPDATE TOP(1) BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 503318
UPDATE TOP(1) BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 520937
UPDATE TOP(1) BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 781496
UPDATE TOP(1) BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 1867647
UPDATE TOP(1) BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 1892491
UPDATE TOP(1) BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 1971597
UPDATE TOP(1) BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 2268309
UPDATE TOP(1) BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 2278663
UPDATE TOP(1) BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 2410733
UPDATE TOP(1) BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 2517405
UPDATE TOP(1) BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 2573756
UPDATE TOP(1) BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 2758108
UPDATE TOP(1) BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 2800030
UPDATE TOP(1) BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 3592487
UPDATE TOP(1) BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 4133367
UPDATE TOP(1) BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 4562578
UPDATE TOP(1) BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 4582496
UPDATE TOP(1) BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 4696989
UPDATE TOP(1) BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 4902062
UPDATE TOP(1) BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 279203
UPDATE TOP(1) BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 791513
UPDATE TOP(1) BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 944294
UPDATE TOP(1) BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 1080881
UPDATE TOP(1) BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 1755201
UPDATE TOP(1) BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 1766754
UPDATE TOP(1) BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 2429222
UPDATE TOP(1) BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 2616583
UPDATE TOP(1) BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 2728489
UPDATE TOP(1) BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 2884194
UPDATE TOP(1) BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 2917094
UPDATE TOP(1) BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 6256502
UPDATE TOP(1) BSegment_Primary SET tpylad = NULL, tpyNad = NULL, tpyBlob = NULL WHERE acctId = 7605435