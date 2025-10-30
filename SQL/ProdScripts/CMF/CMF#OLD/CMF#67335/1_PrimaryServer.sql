-- TO BE RUN ON PRIMARY SERVER COREISSUE DATABASE

BEGIN TRANSACTION
--COMMIT TRANSACTION
--ROLLBACK TRANSACTION

--SELECT * FROM ##tempPlans_Corrected

----SELECT DISTINCT BSAcctId FROM ##tempPlans_Corrected

--SELECT * FROM ##tempAccounts_Corrected

UPDATE CPS
SET AmountOfTotalDue = CPS.AmountOfTotalDue + AdjustedRRDue - AdjustedRetailDue, 
AmtOfPayCurrDue = CPS.AmtOfPayCurrDue + AdjustedRRDue - AdjustedRetailDue,
SRBWithInstallmentDue = CPS.SRBWithInstallmentDue - SRBToAdjust,
CycleDueDTD = 1
FROM CPSgmentCreditCard CPS
JOIN ##tempPlans_Corrected T1 ON (CPS.acctId = T1.CPSAcctId)

UPDATE BS
SET SRBWithInstallmentDue = BS.SRBWithInstallmentDue - SRBToAdjust
FROM BSegmentCreditCard BS
JOIN ##tempAccounts_Corrected T1 ON (T1.BSAcctId = BS.acctId)

UPDATE SH
SET SRBWithInstallmentDue = SH.SRBWithInstallmentDue - SRBToAdjust
FROM StatementHeader SH
JOIN ##tempAccounts_Corrected T1 ON (T1.BSAcctId = SH.acctId AND T1.BusinessDay = SH.StatementDate)

UPDATE SH
SET AmountOfTotalDue = SH.AmountOfTotalDue + AdjustedRRDue - AdjustedRetailDue
FROM SummaryHeader SH 
JOIN ##tempPlans_Corrected T1 ON (SH.acctId = T1.CPSAcctId AND T1.BusinessDay = SH.StatementDate)

UPDATE SHCC
SET CurrentDue = SHCC.CurrentDue + AdjustedRRDue - AdjustedRetailDue,
SRBWithInstallmentDue = SHCC.SRBWithInstallmentDue - SRBToAdjust,
CycleDueDTD = 1
FROM SummaryHeaderCreditCard SHCC
JOIN SummaryHeader SH ON (SH.acctId = SHCC.acctID AND SH.StatementID = SHCC.acctId)
JOIN ##tempPlans_Corrected T1 ON (SH.acctId = T1.CPSAcctId AND T1.BusinessDay = SH.StatementDate)

UPDATE AIR
SET SRBWithInstallmentDue = AIR.SRBWithInstallmentDue - SRBToAdjust
FROM AccountInfoForReport AIR
JOIN ##tempAccounts_Corrected T1 ON (T1.BSAcctId = AIR.BSacctId AND T1.BusinessDay = AIR.BusinessDay)

UPDATE PIR
SET AmountOfTotalDue = PIR.AmountOfTotalDue + AdjustedRRDue - AdjustedRetailDue,
AmtOfPayCurrDue = PIR.AmtOfPayCurrDue + AdjustedRRDue - AdjustedRetailDue,
SRBWithInstallmentDue = PIR.SRBWithInstallmentDue - SRBToAdjust,
CycleDueDTD = 1
FROM PlanInfoForreport PIR
JOIN ##tempPlans_Corrected T1 ON (PIR.CPSacctId = T1.CPSAcctId AND T1.BusinessDay = PIR.BusinessDay)
