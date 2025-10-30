Begin Tran
--commit
--rollback

--1.26
UPDATE TOP(1) bsegmentcreditcard SET amountoftotaldue = (amountoftotaldue - 1.26),AmtOfPayXDLate = (AmtOfPayXDLate - 1.26) WHERE 
acctId = 2024356

UPDATE TOP(1) cpsgmentCreditCard SET  AmtOfPayXDLate = ( AmtOfPayXDLate - 1.26), AmountOfTotalDue =(AmountOfTotalDue - 1.26)  WHERE acctId = 2055616 

-------------------------------------------------------------------

--0.08
UPDATE TOP(1) bsegmentcreditcard SET amountoftotaldue = (amountoftotaldue - 0.08),AmtOfPayXDLate = (AmtOfPayXDLate -0.08) WHERE 
acctId = 161145 

UPDATE TOP(1) cpsgmentCreditCard SET  AmtOfPayXDLate = ( AmtOfPayXDLate - 0.08) , AmountOfTotalDue =(AmountOfTotalDue - 0.08) WHERE acctId = 2743845 

-------------------------------------------------

--8.08
UPDATE TOP(1) bsegmentcreditcard SET amountoftotaldue = (amountoftotaldue - 8.08),AmtOfPayXDLate = (AmtOfPayXDLate -8.08) WHERE 
acctId = 2074418

UPDATE TOP(1) cpsgmentCreditCard SET  AmtOfPayXDLate = ( AmtOfPayXDLate - 8.08),AmountOfTotalDue =(AmountOfTotalDue - 8.08)  WHERE acctId = 4497560 

/*
select amountoftotaldue,AmtOfPayXDLate,* from bsegmentcreditcard with(nolock) where acctid=2074418
select AmtOfPayXDLate,AmountOfTotalDue,* from cpsgmentcreditcard with(nolock) where acctid=4497560

*/

