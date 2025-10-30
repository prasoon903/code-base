-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION
--COMMIT TRANSACTION
--ROLLBACK TRANSACTION

-- UPDATE WILL BE 1 ROW EACH STATEMENT

UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 15950276

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, 
RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 15950276

UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 48274945



DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 48274945 AND ATID = 52 AND IdentityField = 4037688330
DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 48274945 AND ATID = 52 AND IdentityField = 4037688331

DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 15950276 AND ATID = 51 AND IdentityField = 2359010584
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 15950276 AND ATID = 51 AND IdentityField = 2359010585



update  top(1) bsegmentcreditcard  set  manualinitialchargeoffreason  =  '2' where    acctid  =1084497
update  top(1) bsegmentcreditcard  set  manualinitialchargeoffreason  =  '3' where    acctid  =2766735
update  top(1) bsegmentcreditcard  set  manualinitialchargeoffreason  =  '3' where    acctid  =10821040
update  top(1) bsegmentcreditcard  set  manualinitialchargeoffreason  =  '2' where    acctid  =2353661


update  top(1) bsegment_primary  set  tpyblob  =  null  ,tpynad = null , tpylad = null   where    acctid  =1084497
update  top(1) bsegment_primary  set  tpyblob  =  null  ,tpynad = null , tpylad = null   where    acctid  =2766735
update  top(1) bsegment_primary  set  tpyblob  =  null  ,tpynad = null , tpylad = null   where    acctid  =10821040
update  top(1) bsegment_primary  set  tpyblob  =  null  ,tpynad = null , tpylad = null   where    acctid  =2353661