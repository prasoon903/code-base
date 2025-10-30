-- TO BE EXECUTED ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO


begin Tran
---commit 
---Rollback Tran

--UPDATE TOP(1) BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue - 210.78 WHERE acctId = 12215406

UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 21 WHERE acctId = 12215406

--UPDATE TOP(1) AccountInfoForReport SET AmtOfPayCurrDue = AmtOfPayCurrDue - 210.78 WHERE BSacctId = 12215406 AND Businessday = '2021-11-15 23:59:57.000'

UPDATE TOP(1) AccountInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 21 WHERE BSacctId = 12215406 AND Businessday = '2021-11-15 23:59:57.000'


