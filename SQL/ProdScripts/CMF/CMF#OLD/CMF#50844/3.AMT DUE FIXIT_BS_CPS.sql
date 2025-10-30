
BEGIN TRANSACTION
--COMMIT
--ROLLBACK

update  BSegment_Primary set CycleDueDTD = 0 where acctid = 4839430
update  BSegment_Primary set CycleDueDTD = 0 where acctid = 7700555
update  BSegment_Primary set CycleDueDTD = CycleDueDTD - 1,systemstatus = 2 where acctid = 12833157

update  BSegmentCreditCard set AmountOfTotalDue = AmountOfTotalDue - 0.15, AmtOfPayXDLate = AmtOfPayXDLate - 0.15 where acctid = 7700555
update  BSegmentCreditCard set AmountOfTotalDue = AmountOfTotalDue - 24.83, AmtOfPayXDLate = AmtOfPayXDLate - 24.83,
daysdelinquent = 0, NoPayDaysDelinquent = 0, DateOfOriginalPaymentDueDTD = '2021-04-30 00:00:00.000',  FirstDueDate = '2021-04-30 00:00:00.000', DtOfLastDelinqCTD = NULL where acctid = 12833157


update  CPSgmentCreditCard set CycleDueDTD = 0 where acctid = 10059588
update  CPSgmentCreditCard set CycleDueDTD = 0 where acctid = 43728875
update  CPSgmentCreditCard set CycleDueDTD = 0 where acctid = 34660331
update  CPSgmentCreditCard set CycleDueDTD = 0, AmountOfTotalDue = AmountOfTotalDue - 0.15, AmtOfPayXDLate = AmtOfPayXDLate - 0.15 where acctid = 20515804
update  CPSgmentCreditCard set CycleDueDTD = 0, AmountOfTotalDue = AmountOfTotalDue - 24.83, AmtOfPayXDLate = AmtOfPayXDLate - 24.83 where acctid = 34730680


