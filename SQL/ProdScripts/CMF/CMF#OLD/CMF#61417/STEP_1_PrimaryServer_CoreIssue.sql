-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION
--COMMIT TRANSACTION
--ROLLBACK TRANSACTION


UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = 19.12 WHERE acctID = 12930750
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 19.12, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  
RunningMinimumDue = 19.12, RemainingMinimumDue = 19.12  WHERE acctID = 12930750

--UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 66143240

DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 12930750 AND ATID = 51 AND IdentityField = 2531591421


update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 129.22 where  acctid  =  10788212
update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 227.82 where  acctid  =  34671106

update  top(1) bsegmentcreditcard  set  manualinitialchargeoffreason  =  '3' where    acctid  =2441098
update  top(1) bsegmentcreditcard  set  manualinitialchargeoffreason  =  '2' where    acctid  =2461119
update  top(1) bsegmentcreditcard  set  manualinitialchargeoffreason  =  '3' where    acctid  =283222
update  top(1) bsegmentcreditcard  set  manualinitialchargeoffreason  =  '3' where    acctid  =1213517

update  top(1) bsegment_primary  set  tpyblob  =  null  ,tpynad = null , tpylad = null   where    acctid  =2441098
update  top(1) bsegment_primary  set  tpyblob  =  null  ,tpynad = null , tpylad = null   where    acctid  =2461119
update  top(1) bsegment_primary  set  tpyblob  =  null  ,tpynad = null , tpylad = null   where    acctid  =283222
update  top(1) bsegment_primary  set  tpyblob  =  null  ,tpynad = null , tpylad = null   where    acctid  =1213517