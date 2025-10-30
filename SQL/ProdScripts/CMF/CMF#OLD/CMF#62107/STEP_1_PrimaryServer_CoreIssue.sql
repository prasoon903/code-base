-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION
--COMMIT TRANSACTION
--ROLLBACK TRANSACTION

UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = AmountOfTotalDue - 21.64, AmtOfPayCurrDue = AmtOfPayCurrDue - 21.64 WHERE acctID = 83439

INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue) VALUES 
(53879044005, '2022-01-13 12:25:20.000', 52, 83439, 115, '1', '0'),
(53879044005, '2022-01-13 12:25:20.000', 52, 83439, 200, '21.64', '0.00')



UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = AmountOfTotalDue - 16.50, AmtOfPayCurrDue = AmtOfPayCurrDue - 16.50 WHERE acctID = 16216

INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue) VALUES 
(53879142914, '2022-01-13 12:25:14.000', 52, 16216, 115, '1', '0'),
(53879142914, '2022-01-13 12:25:14.000', 52, 16216, 200, '16.50', '0.00')



UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue + 4.12 WHERE acctID = 709301
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 4.12, RunningMinimumDue = RunningMinimumDue + 4.12, RemainingMinimumDue = RemainingMinimumDue + 4.12  WHERE acctID = 709301

UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 1, AmountOfTotalDue = AmountOfTotalDue + 46.06, AmtOfPayCurrDue = AmtOfPayCurrDue + 46.06 WHERE acctID = 721711

UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '46.06' WHERE AID = 709301 AND ATID = 51 AND IdentityField = 2612252517

UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = '46.06' WHERE AID = 721711 AND ATID = 52 AND IdentityField = 4485095216
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 721711 AND ATID = 52 AND IdentityField = 4485095217



UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = AmountOfTotalDue - 4, AmtOfPayCurrDue = AmtOfPayCurrDue - 4 WHERE acctID = 192533

INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue) VALUES 
(54059696687, '2022-01-17 06:02:26.000', 52, 192533, 115, '1', '0'),
(54059696687, '2022-01-17 06:02:26.000', 52, 192533, 200, '4.00', '0.00')



UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = AmountOfTotalDue - 19.73, AmtOfPayCurrDue = AmtOfPayCurrDue - 19.73 WHERE acctID = 12640

INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue) VALUES 
(54016776036, '2022-01-16 05:50:17.000', 52, 12640, 115, '1', '0'),
(54016776036, '2022-01-16 05:50:17.000', 52, 12640, 200, '19.73', '0.00')


UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = AmountOfTotalDue - 38.54, AmtOfPayCurrDue = AmtOfPayCurrDue - 38.54 WHERE acctID = 97915

INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue) VALUES 
(53902225535, '2022-01-13 16:14:34.000', 52, 97915, 115, '1', '0'),
(53902225535, '2022-01-13 16:14:34.000', 52, 97915, 200, '38.54', '0.00')



UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 23 WHERE acctID = 16510042
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 23, RunningMinimumDue = RunningMinimumDue - 23, RemainingMinimumDue = RemainingMinimumDue - 23 WHERE acctID = 16510042

INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue) VALUES 
(53681781845, '2022-01-14 02:07:41.000', 51, 16510042, 115, '1', '0'),
(53681781845, '2022-01-14 02:07:41.000', 51, 16510042, 200, '23.00', '0.00')



UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = AmountOfTotalDue - 5.80, AmtOfPayCurrDue = AmtOfPayCurrDue - 5.80 WHERE acctID = 10244

INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue) VALUES 
(54091497960, '2022-01-17 21:01:04.000', 52, 10244, 115, '1', '0'),
(54091497960, '2022-01-17 21:01:04.000', 52, 10244, 200, '5.80', '0.00')

