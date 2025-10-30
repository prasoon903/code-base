-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION
-- COMMIT TRANSACTION
-- ROLLBACK TRANSACTION

UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = 0, CycleDueDTD = 0 WHERE acctId = 16925749 -- AccountNumber = 1100011172463857
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DateOfOriginalPaymentDueDTD = NULL, 
FirstDueDate = NULL, NoPayDaysDelinquent = 0 WHERE acctId = 16925749 -- AccountNumber = 1100011172463857
UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, CycleDueDTD = 0 WHERE acctId = 51347692 -- AccountNumber = 1100011172463857


UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = 0, CycleDueDTD = 0 WHERE acctId = 2677113 -- AccountNumber = 1100011126828619
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DateOfOriginalPaymentDueDTD = NULL, 
FirstDueDate = NULL, NoPayDaysDelinquent = 0 WHERE acctId = 2677113 -- AccountNumber = 1100011126828619

INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue) VALUES
(44868938739,'2021-08-26 10:02:18.000',51,2677113,200,'25.00','0.00'),
(44868938739,'2021-08-26 10:02:18.000',51,2677113,115,'1','0')



UPDATE TOP(1) DelinquencyRecord SET AmountOfTotalDue = 0, AmtOfPayCurrDue = 0 WHERE TranID = 44358929832 -- AccountNumber = 1100011119509440
UPDATE TOP(1) PlanDelinquencyRecord SET TransactionAmount = 2.99, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0 WHERE TranRef = 44358929837 AND TranID = 44358929837 -- AccountNumber = 1100011119509440
UPDATE TOP(1) CCard_Primary SET TransactionAmount = 0 WHERE TranID = 44358929832 AND AccountNumber = '1100011119509440' -- AccountNumber = 1100011119509440
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = 0, CycleDueDTD = 0 WHERE acctId = 1958156 -- AccountNumber = 1100011119509440
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DateOfOriginalPaymentDueDTD = NULL, 
FirstDueDate = NULL, NoPayDaysDelinquent = 0 WHERE acctId = 1958156 -- AccountNumber = 1100011119509440
UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, CycleDueDTD = 0 WHERE acctId = 1987816 -- AccountNumber = 1100011119509440

UPDATE TOP(1) DelinquencyRecord SET AmountOfTotalDue = 0, AmtOfPayCurrDue = 0 WHERE TranID = 44365855836 -- AccountNumber = 1100011120831817
UPDATE TOP(1) PlanDelinquencyRecord SET TransactionAmount = 25.00, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0 WHERE TranRef = 44365855843 AND TranID = 44365855843 -- AccountNumber = 1100011120831817
UPDATE TOP(1) CCard_Primary SET TransactionAmount = 0 WHERE TranID = 44365855836 AND AccountNumber = '1100011120831817' -- AccountNumber = 1100011120831817
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = 0, CycleDueDTD = 0 WHERE acctId = 2091013 -- AccountNumber = 1100011120831817
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DateOfOriginalPaymentDueDTD = NULL, 
FirstDueDate = NULL, NoPayDaysDelinquent = 0 WHERE acctId = 2091013 -- AccountNumber = 1100011120831817
UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, CycleDueDTD = 0 WHERE acctId = 2122733 -- AccountNumber = 1100011120831817

UPDATE TOP(1) DelinquencyRecord SET AmountOfTotalDue = 0, AmtOfPayCurrDue = 0 WHERE TranID = 44387329700 -- AccountNumber = 1100011111041707
UPDATE TOP(1) PlanDelinquencyRecord SET TransactionAmount = 23.34, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0 WHERE TranRef = 44387329706 AND TranID = 44387329706 -- AccountNumber = 1100011111041707
UPDATE TOP(1) CCard_Primary SET TransactionAmount = 0 WHERE TranID = 44387329700 AND AccountNumber = '1100011111041707' -- AccountNumber = 1100011111041707
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = 0, CycleDueDTD = 0 WHERE acctId = 1108127 -- AccountNumber = 1100011111041707
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DateOfOriginalPaymentDueDTD = NULL, 
FirstDueDate = NULL, NoPayDaysDelinquent = 0 WHERE acctId = 1108127 -- AccountNumber = 1100011111041707
UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, CycleDueDTD = 0 WHERE acctId = 1120547 -- AccountNumber = 1100011111041707
UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, CycleDueDTD = 0 WHERE acctId = 58971976 -- AccountNumber = 1100011111041707

UPDATE TOP(1) DelinquencyRecord SET AmountOfTotalDue = 0, AmtOfPayCurrDue = 0 WHERE TranID = 44387310731 -- AccountNumber = 1100011148976206
UPDATE TOP(1) PlanDelinquencyRecord SET TransactionAmount = 25.00, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0 WHERE TranRef = 44387310736 AND TranID = 44387310736 -- AccountNumber = 1100011148976206
UPDATE TOP(1) CCard_Primary SET TransactionAmount = 0 WHERE TranID = 44387310731 AND AccountNumber = '1100011148976206' -- AccountNumber = 1100011148976206

UPDATE TOP(1) DelinquencyRecord SET AmountOfTotalDue = 0, AmtOfPayCurrDue = 0 WHERE TranID = 44652376564 -- AccountNumber = 1100011125558258
UPDATE TOP(1) PlanDelinquencyRecord SET TransactionAmount = 25.00, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0 WHERE TranRef = 44652376569 AND TranID = 44652376569 -- AccountNumber = 1100011125558258
UPDATE TOP(1) CCard_Primary SET TransactionAmount = 0 WHERE TranID = 44652376564 AND AccountNumber = '1100011125558258' -- AccountNumber = 1100011125558258

UPDATE TOP(1) DelinquencyRecord SET AmountOfTotalDue = 0, AmtOfPayCurrDue = 0 WHERE TranID = 44391335861 -- AccountNumber = 1100011116709183
UPDATE TOP(1) PlanDelinquencyRecord SET TransactionAmount = 41.00, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0 WHERE TranRef = 44391335865 AND TranID = 44391335865 -- AccountNumber = 1100011116709183
UPDATE TOP(1) CCard_Primary SET TransactionAmount = 0 WHERE TranID = 44391335861 AND AccountNumber = '1100011116709183' -- AccountNumber = 1100011116709183
UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = 0, CycleDueDTD = 0 WHERE acctId = 1666485 -- AccountNumber = 1100011116709183
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, RunningMinimumDue = 0, RemainingMinimumDue = 0, DateOfOriginalPaymentDueDTD = NULL, 
FirstDueDate = NULL, NoPayDaysDelinquent = 0 WHERE acctId = 1666485 -- AccountNumber = 1100011116709183
UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, CycleDueDTD = 0 WHERE acctId = 1681315 -- AccountNumber = 1100011116709183