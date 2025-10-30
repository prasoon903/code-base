Begin Tran
--commit
--rollback

--1.26
UPDATE TOP(1) StatementHeader SET amountoftotaldue = (amountoftotaldue - 1.26),AmtOfPayXDLate = (AmtOfPayXDLate - 1.26),AmtOfPayPastDue = AmtOfPayPastDue - 1.26 WHERE 
acctId = 2024356 AND StatementID = 105461413

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue =(AmountOfTotalDue - 1.26) WHERE acctId = 2055616 AND StatementID = 105461413

UPDATE TOP(1) SummaryHeaderCreditCard SET  AmtOfPayXDLate = ( AmtOfPayXDLate - 1.26)  WHERE acctId = 2055616 AND StatementID = 105461413




-------------------------------------------------------------------

--0.08
UPDATE TOP(1) StatementHeader SET amountoftotaldue = (amountoftotaldue - 0.08),AmtOfPayXDLate = (AmtOfPayXDLate -0.08),AmtOfPayPastDue = AmtOfPayPastDue - 0.08 WHERE 
acctId = 161145 AND StatementID = 103835936

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue =(AmountOfTotalDue - 0.08) WHERE acctId = 2743845 AND StatementID = 103835936

UPDATE TOP(1) SummaryHeaderCreditCard SET  AmtOfPayXDLate = ( AmtOfPayXDLate - 0.08)  WHERE acctId = 2743845 AND StatementID = 103835936





-------------------------------------------------

--8.08
UPDATE TOP(1) StatementHeader SET amountoftotaldue = (amountoftotaldue - 8.08),AmtOfPayXDLate = (AmtOfPayXDLate -8.08),AmtOfPayPastDue = AmtOfPayPastDue - 8.08 WHERE 
acctId = 2074418 AND StatementID = 105507365

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue =(AmountOfTotalDue - 8.08) WHERE acctId = 4497560 AND StatementID = 105507365

UPDATE TOP(1) SummaryHeaderCreditCard SET  AmtOfPayXDLate = ( AmtOfPayXDLate - 8.08)  WHERE acctId = 4497560 AND StatementID = 105507365

