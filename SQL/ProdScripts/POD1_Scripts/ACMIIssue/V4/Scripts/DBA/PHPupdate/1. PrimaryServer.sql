-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION
--COMMIT TRANSACTION
-- ROLLBACK TRANSACTION


UPDATE BSegment_balances
SET 
	ReportHistoryCtrCC01 = 0,
	ReportHistoryCtrCC02 = 0,
	ReportHistoryCtrCC03 = 0,
	ReportHistoryCtrCC04 = 0,
	ReportHistoryCtrCC05 = 0,
	ReportHistoryCtrCC06 = 0,
	ReportHistoryCtrCC07 = 0,
	ReportHistoryCtrCC08 = 0,
	ReportHistoryCtrCC09 = 0,
	ReportHistoryCtrCC10 = 0,
	ReportHistoryCtrCC11 = 0,
	ReportHistoryCtrCC12 = 0,
	ReportHistoryCtrCC13 = 0,
	ReportHistoryCtrCC14 = 0,
	ReportHistoryCtrCC15 = 0,
	ReportHistoryCtrCC16 = 0,
	ReportHistoryCtrCC17 = 0,
	ReportHistoryCtrCC18 = 0,
	ReportHistoryCtrCC19 = 0,
	ReportHistoryCtrCC20 = 0,
	ReportHistoryCtrCC21 = 0,
	ReportHistoryCtrCC22 = 0,
	ReportHistoryCtrCC23 = 0,
	ReportHistoryCtrCC24 = 0 
WHERE acctId IN
(510922, 731451, 1330656, 1624337, 2203842, 2531517, 4902639, 16072203, 17344275, 18323880, 18545361, 18787040, 21834456)