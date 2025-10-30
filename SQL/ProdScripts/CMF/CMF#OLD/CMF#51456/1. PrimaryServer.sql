-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION
--COMMIT TRANSACTION
--ROLLBACK TRANSACTION

-- UPDATE WILL BE 1 ROW EACH STATEMENT


UPDATE TOP(1) BSegmentCreditCard SET AmtOfPayXDLate = AmtOfPayXDLate + 0.62, AmountOfTotalDue = AmountOfTotalDue + 0.62,
RunningMinimumDue = RunningMinimumDue + 0.62, RemainingMinimumDue = RemainingMinimumDue + 0.62 WHERE acctId = 1034893

UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '10.10' WHERE AID = 1034893 AND ATID = 51 AND IdentityField = 1373732897



UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 1.26, AmtofPayCurrDue = AmtofPayCurrDue - 1.26, CycleDueDTD = 0 WHERE acctId = 1576133

INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(38713367776, '2021-04-29 05:42:10.000', 52, 1576133, 115, '1', '0'),
(38713367776, '2021-04-29 05:42:10.000', 52, 1576133, 200, '1.26', '0.00')


update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD   - 14.95 where  acctid  =  45928005
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD   - 31.20 where  acctid  =  30651259
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 179.95 where  acctid  =  35386399
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD   - 162.49 where  acctid  =  27157824
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 32.68 where  acctid  =  37339599
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 90.75 where  acctid  =  48463994
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD   - 29.12 where  acctid  =  10038451
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD   - 29.12 where  acctid  =  19662142
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD   - 29.12 where  acctid  =  19718159
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD   - 34.08 where  acctid  =  27578334
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD   - 45.79 where  acctid  =  37085270