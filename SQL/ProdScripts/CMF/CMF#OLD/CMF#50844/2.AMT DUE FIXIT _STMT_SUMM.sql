
BEGIN TRANSACTION
--commit
--rollback

update  StatementHeader set CycleDueDTD = 0 where acctid = 4839430  and statementid in (56522749,61281758,66053206)
update  StatementHeader set CycleDueDTD = 0,AmountOfTotalDue = AmountOfTotalDue - 0.15, AmtOfPayXDLate = AmtOfPayXDLate - 0.15 where acctid = 7700555 and statementdate = '2021-03-31 23:59:57.000' 

update  SummaryHeaderCreditCard set CycleDueDTD = 0 where acctid = 10059588 and statementid in (56522749,61281758,66053206)
update  SummaryHeaderCreditCard set CycleDueDTD = 0,AmtOfPayXDLate = AmtOfPayXDLate - 0.15 where acctid = 20515804 and statementid = 66372007
update  SummaryHeaderCreditCard set CycleDueDTD = 1,AmtOfPayXDLate = AmtOfPayXDLate - 24.83 where acctid = 34730680 and statementid = 67168424

update  SummaryHeader set AmountOfTotalDue = AmountOfTotalDue - 0.15  where acctid = 20515804 and statementid = 66372007
update  SummaryHeader set AmountOfTotalDue = AmountOfTotalDue - 24.83 where acctid = 34730680 and statementid = 67168424
 
 