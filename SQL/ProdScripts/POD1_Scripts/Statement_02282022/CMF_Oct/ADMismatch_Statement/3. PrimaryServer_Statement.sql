-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO


BEGIN TRANSACTION
--COMMIT TRANSACTION
-- ROLLBACK TRANSACTION


update StatementHeader set CycleDueDTD = 1, AmtOfPayCurrDue = 46.67,AmtOfPayXDLate = 0,systemstatus = 2 where acctid = 21644933 and statementid = 110254270
update SummaryHeader set AmountOfTotalDue = 0 where acctid in (67639682,67677141,67677142,67677143)  and statementid = 110254270
update SummaryHeaderCreditCard set CycleDueDTD = 0, AmtOfPayXDLate = 0 where acctid in (67639682,67677141,67677142,67677143)  and statementid = 110254270
update SummaryHeader set AmountOfTotalDue = 46.67 where acctid in (68367664)  and statementid = 110254270
update SummaryHeaderCreditCard set CycleDueDTD = 1, CurrentDue = 46.67 where acctid in (68367664)  and statementid = 110254270

update StatementHeader set CycleDueDTD = 1, AmtOfPayCurrDue = 92.73,AmtOfPayXDLate = 0,systemstatus = 2 where acctid = 21559947 and statementid = 110188940
update SummaryHeader set AmountOfTotalDue = 0 where acctid in (67667741)  and statementid = 110188940
update SummaryHeaderCreditCard set CycleDueDTD = 0, AmtOfPayXDLate = 0 where acctid in (67667741)  and statementid = 110188940
update SummaryHeader set AmountOfTotalDue = 92.73 where acctid in (68093426)  and statementid = 110188940
update SummaryHeaderCreditCard set CycleDueDTD = 1, CurrentDue = 92.73 where acctid in (68093426)  and statementid = 110188940

update StatementHeader set CycleDueDTD = 0, AmtOfPayCurrDue = 0,AmtOfPayXDLate = 0,systemstatus = 2 where acctid = 21398996 and statementid = 110070383
update SummaryHeader set AmountOfTotalDue = 0 where acctid in (66461063,66461064,66617650,67720005)  and statementid = 110070383
update SummaryHeaderCreditCard set CycleDueDTD = 0, AmtOfPayXDLate = 0 where acctid in (66461063,66461064,66617650,67720005)   and statementid = 110070383



UPDATE TOP(1) StatementHeader SET AmtOfPayCurrDue = AmtOfPayCurrDue + 3.23, AmtOfPayXDLate = AmtOfPayXDLate - 3.23,
AmtOfPayPastDue = AmtOfPayPastDue - 3.23, SRBWithInstallmentDue = SRBWithInstallmentDue + 30.44, 
SBWithInstallmentDue = SBWithInstallmentDue + 30.44, CycleDueDTD = 1, SystemStatus = 2 WHERE acctId = 14886219 AND StatementID = 108557017

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = 0 WHERE acctId = 45925730 AND StatementID = 108557017
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0, CurrentDue = 0, AmtOfPayXDLate = 0 WHERE acctId = 45925730 AND StatementID = 108557017

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue + 154.94 WHERE acctId = 63292415 AND StatementID = 108557017
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 1, CurrentDue = CurrentDue + 154.94, SRBWithInstallmentDue = SRBWithInstallmentDue + 154.94, 
SBWithInstallmentDue = SBWithInstallmentDue + 154.94 WHERE acctId = 63292415 AND StatementID = 108557017



UPDATE TOP(1) StatementHeader SET AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmtOfPayPastDue = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0, , AmountOfTotalDue = 0,MinimumPaymentDue = 0,
CycleDueDTD = 0, SystemStatus = 2 WHERE acctId = 16564141 AND StatementID = 108942906



UPDATE TOP(1) StatementHeader SET AmtOfPayCurrDue = AmtOfPayCurrDue + 88.16, AmtOfPayXDLate = AmtOfPayXDLate - 88.16,
AmtOfPayPastDue = AmtOfPayPastDue - 88.16, SRBWithInstallmentDue = SRBWithInstallmentDue - 88.16, 
SBWithInstallmentDue = SBWithInstallmentDue - 88.16 WHERE acctId = 18074751 AND StatementID = 108819515

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = 0 WHERE acctId = 67273308 AND StatementID = 108819515
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0, CurrentDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, 
SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 67273308 AND StatementID = 108819515

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = 0 WHERE acctId = 67273309 AND StatementID = 108819515
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0, CurrentDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, 
SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 67273309 AND StatementID = 108819515



UPDATE TOP(1) StatementHeader SET AmtOfPayCurrDue = AmtOfPayCurrDue + 22.04, AmtOfPayXDLate = AmtOfPayXDLate - 22.04,
AmtOfPayPastDue = AmtOfPayPastDue - 22.04, SRBWithInstallmentDue = SRBWithInstallmentDue - 22.04, 
SBWithInstallmentDue = SBWithInstallmentDue - 22.04, CycleDueDTD = 1, SystemStatus = 2 WHERE acctId = 18310493 AND StatementID = 108909968

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = 0 WHERE acctId = 67431627 AND StatementID = 108909968
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0, CurrentDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, 
SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 67431627 AND StatementID = 108909968

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue + 16.35 WHERE acctId = 68410214 AND StatementID = 108909968
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 1, CurrentDue = CurrentDue + 16.35 WHERE acctId = 68410214 AND StatementID = 108909968



UPDATE TOP(1) StatementHeader SET AmtOfPayCurrDue = AmtOfPayCurrDue + 0.03, AmtOfPayXDLate = AmtOfPayXDLate - 0.03,
AmtOfPayPastDue = AmtOfPayPastDue - 0.03, SRBWithInstallmentDue = SRBWithInstallmentDue + 32.04, 
SBWithInstallmentDue = SBWithInstallmentDue + 32.04, CycleDueDTD = 1, SystemStatus = 2 WHERE acctId = 18533310 AND StatementID = 109484449

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = 0 WHERE acctId = 57747124 AND StatementID = 109484449
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0, CurrentDue = 0, AmtOfPayXDLate = 0 WHERE acctId = 57747124 AND StatementID = 109484449

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue + 672.86 WHERE acctId = 58404925 AND StatementID = 109484449
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 1, CurrentDue = CurrentDue + 672.86, SRBWithInstallmentDue = SRBWithInstallmentDue + 672.86, 
SBWithInstallmentDue = SBWithInstallmentDue + 672.86 WHERE acctId = 58404925 AND StatementID = 109484449

