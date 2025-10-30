-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION
--COMMIT TRANSACTION
--ROLLBACK TRANSACTION

-- UPDATE WILL BE 1 ROW EACH STATEMENT


UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtofPayCurrDue = AmtofPayCurrDue - 81.29 WHERE acctId = 210405

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 81.29, RemainingMinimumDue = RemainingMinimumDue - 81.29, RunningMinimumDue = RunningMinimumDue - 81.29,
DateOfOriginalPaymentDueDTD = NULL, FirstDueDate = NULL WHERE acctId = 210405


INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(50407201241, '2021-11-23 13:32:46.000', 51, 210405, 115, '1', '0'),
(50407201241, '2021-11-23 13:32:46.000', 51, 210405, 200, '81.29', '0.00')



UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 22.42, AmtofPayCurrDue = AmtofPayCurrDue - 22.42, CycleDueDTD = 0 WHERE acctId = 15732 --BS: 13272

INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(50470855208, '2021-11-24 21:16:00.000', 52, 15732, 115, '1', '0'),
(50470855208, '2021-11-24 21:16:00.000', 52, 15732, 200, '22.42', '0.00')




UPDATE TOP(1) BSegment_Primary SET SystemStatus = 3, CycleDueDTD = 2 WHERE acctId = 2971439

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 38.06, AmtOfPayXDLate = AmtOfPayXDLate + 38.06, RemainingMinimumDue = RemainingMinimumDue + 38.06,
RunningMinimumDue = RunningMinimumDue + 38.06, DateOfOriginalPaymentDueDTD = '2021-10-31 23:59:57.000', 
FirstDueDate = '2021-10-31 23:59:57.000', DtOfLastDelinqCTD = '2021-10-31 23:59:57.000', DaysDelinquent = 25, NoPayDaysDelinquent = 25 WHERE acctId = 2971439

INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(49545747513, '2021-11-06 12:06:06.000', 51, 2971439, 115, '0', '2'),
(49545747513, '2021-11-06 12:06:06.000', 51, 2971439, 112, '2', '3'),
(49545747513, '2021-11-06 12:06:06.000', 51, 2971439, 200, '0.00', '38.06')




UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 27.14, AmtofPayCurrDue = AmtofPayCurrDue - 27.14, CycleDueDTD = 0 WHERE acctId = 115072 --BS: 110872

INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(49612776251, '2021-11-08 11:34:32.000', 52, 115072, 115, '1', '0'),
(49612776251, '2021-11-08 11:34:32.000', 52, 115072, 200, '27.14', '0.00')



UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, AmtofPayCurrDue = AmtofPayCurrDue - 9.00 WHERE acctId = 19037231

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 9.00, RemainingMinimumDue = RemainingMinimumDue - 9.00, RunningMinimumDue = RunningMinimumDue - 9.00,
DateOfOriginalPaymentDueDTD = NULL, FirstDueDate = NULL WHERE acctId = 19037231

DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 19037231 AND ATID = 51 AND IdentityField = 2329206324
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 19037231 AND ATID = 51 AND IdentityField = 2329206325


UPDATE TOP(1) BSegment_Primary SET AmtofPayCurrDue = AmtofPayCurrDue + 8.26 WHERE acctId = 755201

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 8.26, RemainingMinimumDue = RemainingMinimumDue + 8.26,
RunningMinimumDue = RunningMinimumDue + 8.26 WHERE acctId = 755201

UPDATE TOP(1) CurrentBalanceAudit SET Newvalue = '65.48' WHERE AID = 755201 AND ATID = 51 AND IdentityField = 2321873885



UPDATE TOP(1) BSegment_Primary SET AmtofPayCurrDue = AmtofPayCurrDue + 24.65 WHERE acctId = 136240

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 24.65, RemainingMinimumDue = RemainingMinimumDue + 24.65,
RunningMinimumDue = RunningMinimumDue + 24.65 WHERE acctId = 136240

DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 136240 AND ATID = 51 AND IdentityField = 2313519813



UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2 WHERE acctId = 16564141

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 8.04, AmtofPayXDLate = AmtofPayXDLate - 8.04, 
RemainingMinimumDue = RemainingMinimumDue - 8.04, RunningMinimumDue = RunningMinimumDue - 8.04,
DateOfOriginalPaymentDueDTD = NULL, FirstDueDate = NULL, DtOfLastDelinqCTD = NULL, DaysDelinquent = 0, NoPayDaysDelinquent = 0 WHERE acctId = 16564141




--UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 7.30, AmtofPayCurrDue = AmtofPayCurrDue - 7.30, CycleDueDTD = 0 WHERE acctId = 16741 --BS: 14271

--INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
--VALUES
--(50219739267, '2021-11-20 05:53:03.000', 52, 16741, 115, '1', '0'),
--(50219739267, '2021-11-20 05:53:03.000', 52, 16741, 200, '7.30', '0.00')



-------Fixes by Piyush Garg Start

UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 16.73 WHERE acctId = 20195

UPDATE Top(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 16.73, 
RunningMinimumDue = RunningMinimumDue - 16.73, RemainingMinimumDue = RemainingMinimumDue - 16.73, FirstDueDate = NULL, DateOfOriginalPaymentDueDTD = NULL WHERE acctId = 20195

UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '0.00' WHERE AID = 20195 AND ATID = 51 AND dename = 200 AND tid =49549578293 and IdentityField = 2264499700
INSERT INTO CurrentBalanceAudit(tid, businessday, atid, aid, dename, oldvalue, newvalue) VALUES
(49549578293, '2021-11-06 18:55:23.000', 51, 20195, 115, '1', '0')

---------------------------

  UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = AmountOfTotalDue - 12.55, AmtOfPayCurrDue =AmtOfPayCurrDue - 12.55 WHERE acctId = 19796 

 Insert into currentbalanceauditPS (tid, businessday, atid, aid, dename, oldvalue, newvalue) 
 Values (49612778016, '2021-11-08 11:34:35.000', 52, 19796, 200, '12.55', '0.00'),
		(49612778016, '2021-11-08 11:34:35.000', 52, 19796, 115, '1', '0')

 ---------------------------------

 UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, AmtOfPayCurrDue = AmtOfPayCurrDue + 113.95 WHERE acctId = 888490

  UPDATE Top(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 113.95,
RunningMinimumDue = RunningMinimumDue + 113.95, RemainingMinimumDue = RemainingMinimumDue + 113.95, FirstDueDate = '2021-11-30 23:59:57.000', 
DateOfOriginalPaymentDueDTD ='2021-11-30 23:59:57.000' WHERE acctId = 888490

Delete from currentbalanceaudit where IdentityField = 2327915588 and dename = 115 and aid = 888490 and oldvalue = 1 and newvalue = 0
Delete from currentbalanceaudit where IdentityField = 2327915589 and dename = 200 and aid = 888490 and oldvalue = '113.95' and newvalue = '0.00'

----------------------------------


UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 3.07 WHERE acctID = 2105008

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 3.07, RunningMinimumDue = RunningMinimumDue - 3.07,
RemainingMinimumDue = RemainingMinimumDue - 3.07, FirstDueDate = NULL, DateOfOriginalPaymentDueDTD = NULL WHERE acctID = 2105008


INSERT INTO CurrentBalanceAudit(tid, businessday, atid, aid, dename, oldvalue, newvalue) VALUES
(49223440995, '2021-11-01 20:24:39.000', 51, 2105008, 200, '3.07', '0.00'),
(49223440995, '2021-11-01 20:24:39.000', 51, 2105008, 115, '1', '0')


-------------------------------------



UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, AmtOfPayCurrDue = AmtOfPayCurrDue + 1.24 WHERE acctID = 21571891

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 1.24, RunningMinimumDue = RunningMinimumDue + 1.24,
RemainingMinimumDue = RemainingMinimumDue + 1.24, FirstDueDate = '2021-11-30 23:59:57.000', DateOfOriginalPaymentDueDTD = '2021-11-30 23:59:57.000' WHERE acctID = 21571891


UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '1' WHERE AID = 21571891 AND ATID = 51 AND dename = 115 AND IdentityField = 2238171604
UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '1.24' WHERE AID = 21571891 AND ATID = 51 AND dename = 200 AND IdentityField = 2238171605


-------------------------------------
-------------------------------------


UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, AmtOfPayCurrDue = AmtOfPayCurrDue + 52.82 WHERE acctID = 13047225

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 52.82, RunningMinimumDue = RunningMinimumDue + 52.82,
RemainingMinimumDue = RemainingMinimumDue + 52.82, FirstDueDate = '2021-11-30 23:59:57.000', DateOfOriginalPaymentDueDTD = '2021-11-30 23:59:57.000' WHERE acctID = 13047225


Delete from currentbalanceaudit where IdentityField = 2328062699 and dename = 115 and aid = 13047225 and oldvalue = 1 and newvalue = 0
Delete from currentbalanceaudit where IdentityField = 2328062700 and dename = 200 and aid = 13047225 and oldvalue = '52.82' and newvalue = '0.00'

--------------------------------------------

UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 2, SystemStatus = 3  WHERE acctID = 20156734

UPDATE TOP(1) BSegmentCreditCard SET AmtOfPayXDLate = AmtOfPayXDLate + 41.62, AmountOfTotalDue = AmountOfTotalDue + 41.62, RunningMinimumDue = RunningMinimumDue + 41.62,
RemainingMinimumDue = RemainingMinimumDue + 41.62, DtOfLastDelinqCTD = '2021-10-31 23:59:57.000', DaysDelinquent = 3, NoPayDaysDelinquent = 3, FirstDueDate = '2021-10-31 23:59:57.000', DateOfOriginalPaymentDueDTD = '2021-10-31 23:59:57.000' WHERE acctID = 20156734

INSERT INTO CurrentBalanceAudit(tid, businessday, atid, aid, dename, oldvalue, newvalue) VALUES
(48863485584, '2021-11-01 00:01:02.000', 51, 20156734, 200, '0.00', '41.62'),
(48863485584, '2021-11-01 00:01:02.000', 51, 20156734, 115, '0', '2')

-------Fixes by Piyush Garg END

-----------Fixes by SGangil Start 

UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1, AmtofPayCurrDue = AmtofPayCurrDue + 8.25 WHERE acctId = 2021886

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 8.25, RemainingMinimumDue = RemainingMinimumDue + 8.25, RunningMinimumDue = RunningMinimumDue + 8.25,
DateOfOriginalPaymentDueDTD = '2021-11-30 23:59:57.000', FirstDueDate = '2021-11-30 23:59:57.000' WHERE acctId = 2021886

DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 2021886 AND ATID = 51 AND IdentityField = 2327919161
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 2021886 AND ATID = 51 AND IdentityField = 2327919162


UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0,  AmtofPayCurrDue = AmtofPayCurrDue - 2.76 WHERE acctId = 6842737

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 2.76, RemainingMinimumDue = RemainingMinimumDue - 2.76, RunningMinimumDue = RunningMinimumDue - 2.76,
DateOfOriginalPaymentDueDTD = NULL, FirstDueDate = NULL WHERE acctId = 6842737

	
INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(49748166504, '2021-11-10 14:50:04.000', 51, 6842737, 115, '1', '0'),
(49748166504, '2021-11-10 14:50:04.000', 51, 6842737, 200, '2.76', '0.00')


UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 1,AmtofPayCurrDue = AmtofPayCurrDue + 51.16 WHERE acctId = 12445926

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 51.16, RemainingMinimumDue = RemainingMinimumDue + 51.16,
RunningMinimumDue = RunningMinimumDue + 51.16,DateOfOriginalPaymentDueDTD = '2021-11-30 23:59:57.000', FirstDueDate = '2021-11-30 23:59:57.000'  WHERE acctId = 12445926

DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 12445926 AND ATID = 51 AND IdentityField = 2327906966
DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 12445926 AND ATID = 51 AND IdentityField = 2327906964

---------Fixes by SGangil Start 