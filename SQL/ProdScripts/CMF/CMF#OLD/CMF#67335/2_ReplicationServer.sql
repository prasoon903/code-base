-- TO BE RUN ON REPLICATION SERVER COREISSUE DATABASE

BEGIN TRANSACTION
--COMMIT TRANSACTION
--ROLLBACK TRANSACTION

--SELECT * FROM LS_PRODDRGSDB01.CCGS_Coreissue.dbo.tempPlans_Corrected_20220430

----SELECT DISTINCT BSAcctId FROM LS_PRODDRGSDB01.CCGS_Coreissue.dbo.tempPlans_Corrected_20220430

--SELECT * FROM LS_PRODDRGSDB01.CCGS_Coreissue.dbo.tempAccounts_Corrected_20220430

--SELECT * FROM SYS.Servers

--SELECT * FROM LS_PRODDRGSDB01.CCGS_Coreissue.dbo.tempAccounts_Corrected_20220430
--SELECT * FROM LS_PRODDRGSDB01.CCGS_Coreissue.dbo.tempPlans_Corrected_20220430


UPDATE SH
SET SRBWithInstallmentDue = SH.SRBWithInstallmentDue - SRBToAdjust
FROM StatementHeader SH
JOIN LS_PRODDRGSDB01.CCGS_Coreissue.dbo.tempAccounts_Corrected_20220430 T1 ON (T1.BSAcctId = SH.acctId AND T1.BusinessDay = SH.StatementDate)

UPDATE SH
SET AmountOfTotalDue = SH.AmountOfTotalDue + AdjustedRRDue - AdjustedRetailDue
FROM SummaryHeader SH 
JOIN LS_PRODDRGSDB01.CCGS_Coreissue.dbo.tempPlans_Corrected_20220430 T1 ON (SH.acctId = T1.CPSAcctId AND T1.BusinessDay = SH.StatementDate)

UPDATE AIR
SET SRBWithInstallmentDue = AIR.SRBWithInstallmentDue - SRBToAdjust
FROM AccountInfoForReport AIR
JOIN LS_PRODDRGSDB01.CCGS_Coreissue.dbo.tempAccounts_Corrected_20220430 T1 ON (T1.BSAcctId = AIR.BSacctId AND T1.BusinessDay = AIR.BusinessDay)

UPDATE PIR
SET AmountOfTotalDue = PIR.AmountOfTotalDue + AdjustedRRDue - AdjustedRetailDue,
AmtOfPayCurrDue = PIR.AmtOfPayCurrDue + AdjustedRRDue - AdjustedRetailDue,
SRBWithInstallmentDue = PIR.SRBWithInstallmentDue - SRBToAdjust,
CycleDueDTD = 1
FROM PlanInfoForreport PIR
JOIN LS_PRODDRGSDB01.CCGS_Coreissue.dbo.tempPlans_Corrected_20220430 T1 ON (PIR.CPSacctId = T1.CPSAcctId AND T1.BusinessDay = PIR.BusinessDay)
