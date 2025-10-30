-- TO BE RUN ON REPLICATION SERVER ONLY


USE CCGS_RPT_CoreIssue
GO


BEGIN TRANSACTION
--COMMIT TRANSACTION
-- ROLLBACK TRANSACTION


UPDATE TOP(1) PlanInfoForReport SET AmtOfPayCurrDue = AmtOfPayCurrDue - 0.01, AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE CPSacctId = 745279 AND BusinessDay = '2021-06-30 23:59:57.000' -- BSAcctId = 732869

UPDATE TOP(1) PlanInfoForReport SET AmtOfPayCurrDue = AmtOfPayCurrDue - 0.01, AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE CPSacctId = 576777 AND BusinessDay = '2021-06-30 23:59:57.000' -- BSAcctId = 564557

UPDATE TOP(1) PlanInfoForReport SET AmtOfPayCurrDue = AmtOfPayCurrDue - 0.01, AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE CPSacctId = 514290 AND BusinessDay = '2021-06-30 23:59:57.000' -- BSAcctId = 502070

UPDATE TOP(1) PlanInfoForReport SET AmtOfPayCurrDue = AmtOfPayCurrDue - 0.01, AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE CPSacctId = 1377978 AND BusinessDay = '2021-06-30 23:59:57.000' -- BSAcctId = 1365558

UPDATE TOP(1) PlanInfoForReport SET AmtOfPayCurrDue = AmtOfPayCurrDue - 0.01, AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE CPSacctId = 1643942 AND BusinessDay = '2021-06-30 23:59:57.000' -- BSAcctId = 1631522

UPDATE TOP(1) PlanInfoForReport SET AmtOfPayCurrDue = AmtOfPayCurrDue - 0.01, AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE CPSacctId = 1687039 AND BusinessDay = '2021-06-30 23:59:57.000' -- BSAcctId = 1672059

UPDATE TOP(1) PlanInfoForReport SET AmtOfPayCurrDue = AmtOfPayCurrDue - 0.01, AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE CPSacctId = 1869157 AND BusinessDay = '2021-06-30 23:59:57.000' -- BSAcctId = 1848767

UPDATE TOP(1) PlanInfoForReport SET AmtOfPayCurrDue = AmtOfPayCurrDue - 0.01, AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE CPSacctId = 2563075 AND BusinessDay = '2021-06-30 23:59:57.000' -- BSAcctId = 2477135

UPDATE TOP(1) PlanInfoForReport SET AmtOfPayCurrDue = AmtOfPayCurrDue - 0.01, AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE CPSacctId = 8228378 AND BusinessDay = '2021-06-30 23:59:57.000' -- BSAcctId = 4492220

UPDATE TOP(1) PlanInfoForReport SET AmtOfPayCurrDue = AmtOfPayCurrDue - 0.01, AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE CPSacctId = 10227247 AND BusinessDay = '2021-06-30 23:59:57.000' -- BSAcctId = 4881089

UPDATE TOP(1) PlanInfoForReport SET AmtOfPayCurrDue = AmtOfPayCurrDue - 0.01, AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE CPSacctId = 10477343 AND BusinessDay = '2021-06-30 23:59:57.000' -- BSAcctId = 4941185

UPDATE TOP(1) PlanInfoForReport SET AmtOfPayCurrDue = AmtOfPayCurrDue - 0.01, AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE CPSacctId = 24116367 AND BusinessDay = '2021-06-30 23:59:57.000' -- BSAcctId = 9816209

UPDATE TOP(1) PlanInfoForReport SET AmtOfPayCurrDue = AmtOfPayCurrDue - 0.01, AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE CPSacctId = 33182621 AND BusinessDay = '2021-06-30 23:59:57.000' -- BSAcctId = 12366511

UPDATE TOP(1) PlanInfoForReport SET AmtOfPayCurrDue = AmtOfPayCurrDue - 0.01, AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE CPSacctId = 37073205 AND BusinessDay = '2021-06-30 23:59:57.000' -- BSAcctId = 13538031


UPDATE TOP(1) AccountInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 175.40, AmtOfPayCurrDue = AmtOfPayCurrDue + 175.40, 
RunningMinimumDue = RunningMinimumDue + 175.40, RemainingMinimumDue = RemainingMinimumDue + 175.40 WHERE BSacctId = 1742986 AND BusinessDay = '2021-06-30 23:59:57.000'

UPDATE TOP(1) PlanInfoForReport SET AmountOfPayment30DLate = AmountOfPayment30DLate + 4.66, AmountOfPayment60DLate = AmountOfPayment60DLate - 4.66 WHERE CPSacctId = 26055371 AND BusinessDay = '2021-06-30 23:59:57.000'


UPDATE TOP(1) AccountInfoForReport SET AmountOfTotalDue = AmountOfTotalDue - 278.32, AmtOfPayXDLate = AmtOfPayXDLate - 278.32, CycleDueDTD = 1, 
SystemStatus = 2, RunningMinimumDue = RunningMinimumDue - 278.32, RemainingMinimumDue = RemainingMinimumDue - 278.32 WHERE BSacctId = 10895026 AND BusinessDay = '2021-06-30 23:59:57.000'

UPDATE TOP(1) AccountInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 25, AmtOfPayCurrDue = AmtOfPayCurrDue + 25 WHERE BSacctId = 12125607 AND BusinessDay = '2021-06-30 23:59:57.000'

UPDATE TOP(1) PlanInfoForReport SET AmtOfPayCurrDue = AmtOfPayCurrDue + 25 WHERE CPSacctId = 32487735 AND BusinessDay = '2021-06-30 23:59:57.000'

UPDATE TOP(1) AccountInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 32.19, RunningMinimumDue = RunningMinimumDue + 32.19, RemainingMinimumDue = RemainingMinimumDue + 32.19,
CycleDueDTD = 3, AmtOfPayCurrDue = AmtOfPayCurrDue + 32.19 WHERE BSacctId = 13004403 AND BusinessDay = '2021-06-30 23:59:57.000'

UPDATE TOP(1) PlanInfoForReport SET AmountOfPayment30DLate = AmountOfPayment30DLate + 32.19, AmountOfPayment60DLate = AmountOfPayment60DLate - 32.19,
CycleDueDTD = 3 WHERE CPSacctId = 37085917 AND BusinessDay = '2021-06-30 23:59:57.000'

UPDATE TOP(1) AccountInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 16.91, AmtOfPayCurrDue = AmtOfPayCurrDue + 16.91, 
DateOfOriginalPaymentDueDTD = '2021-06-30 23:59:57', RunningMinimumDue = RunningMinimumDue + 16.91, RemainingMinimumDue = RemainingMinimumDue + 16.91,
DateOfDelinquency = '2021-06-30 23:59:57' WHERE BSacctId = 13566557 AND BusinessDay = '2021-06-30 23:59:57.000'


UPDATE TOP(1) AccountInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 0.5, AmtOfPayCurrDue = AmtOfPayCurrDue + 0.5, RunningMinimumDue = RunningMinimumDue + 0.5, 
RemainingMinimumDue = RemainingMinimumDue + 0.5, SRBWithInstallmentDue = SRBWithInstallmentDue + 5.85, 
SBWithInstallmentDue = SBWithInstallmentDue + 5.85 WHERE BSacctId = 15709599 AND BusinessDay = '2021-06-30 23:59:57.000'

UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue + 130.05, AmtOfPayCurrDue = AmtOfPayCurrDue + 130.05, SRBWithInstallmentDue = SRBWithInstallmentDue + 130.05, 
SBWithInstallmentDue = SBWithInstallmentDue + 130.05 WHERE CPSacctId = 47264603 AND BusinessDay = '2021-06-30 23:59:57.000'

UPDATE TOP(1) PlanInfoForReport SET AmountOfTotalDue = AmountOfTotalDue - 0.5, AmtOfPayXDLate = AmtOfPayXDLate - 0.5, CycleDueDTD = 0 WHERE CPSacctId = 47566268 AND BusinessDay = '2021-06-30 23:59:57.000'



------------------------------------------STATEMENT DATA ---------------------------------



UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE acctId = 745279 AND StatementID = 79938517

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE acctId = 576777 AND StatementID = 79673402

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE acctId = 514290 AND StatementID = 79252912

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE acctId = 1377978 AND StatementID = 80173598

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE acctId = 1643942 AND StatementID = 80382091

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE acctId = 1687039 AND StatementID = 80418496

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE acctId = 1869157 AND StatementID = 80539763

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE acctId = 2563075 AND StatementID = 81130857

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE acctId = 8228378 AND StatementID = 81939520

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE acctId = 10227247 AND StatementID = 82151722

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE acctId = 10477343 AND StatementID = 82214581

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE acctId = 24116367 AND StatementID = 82687034

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE acctId = 33182621 AND StatementID = 83089293

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE acctId = 37073205 AND StatementID = 83487640


UPDATE TOP(1) StatementHeader SET AmountOfTotalDue = AmountOfTotalDue + 175.40, AmtOfPayCurrDue = AmtOfPayCurrDue + 175.40, 
MinimumPaymentDue = MinimumPaymentDue + 175.40 WHERE acctId = 1742986 AND StatementID = 80480002


UPDATE TOP(1) StatementHeader SET AmountOfTotalDue = AmountOfTotalDue - 278.32, AmtOfPayXDLate = AmtOfPayXDLate - 278.32, 
CycleDueDTD = 1, SystemStatus = 2, MinimumPaymentDue = MinimumPaymentDue - 278.32 WHERE acctId = 10895026 AND StatementID = 82825176


UPDATE TOP(1) StatementHeader SET AmountOfTotalDue = AmountOfTotalDue + 25, AmtOfPayCurrDue = AmtOfPayCurrDue + 25 WHERE acctId = 12125607 AND StatementID = 83054708



UPDATE TOP(1) StatementHeader SET MinimumPaymentDue = MinimumPaymentDue + 32.19, AmountOfTotalDue = AmountOfTotalDue + 32.19, 
CycleDueDTD = 3, AmtOfPayCurrDue = AmtOfPayCurrDue + 32.19 WHERE acctId = 13004403 AND StatementID = 83351600



UPDATE TOP(1) StatementHeader SET AmountOfTotalDue = AmountOfTotalDue + 16.91, AmtOfPayCurrDue = AmtOfPayCurrDue + 16.91, 
MinimumPaymentDue = MinimumPaymentDue + 16.91, DateOfOriginalPaymentDueDTD = '2021-06-30 23:59:57' WHERE acctId = 13566557 AND StatementID = 83506176


UPDATE TOP(1) StatementHeader SET AmountOfTotalDue = AmountOfTotalDue + 0.5, AmtOfPayCurrDue = AmtOfPayCurrDue + 0.5, MinimumPaymentDue = MinimumPaymentDue + 0.5, 
SRBWithInstallmentDue = SRBWithInstallmentDue + 5.85, SBWithInstallmentDue = SBWithInstallmentDue + 5.85 WHERE acctId = 15709599 AND StatementID = 83873102

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue + 130.05 WHERE acctId = 47264603 AND StatementID = 83873102

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue - 0.5 WHERE acctId = 47566268 AND StatementID = 83873102

