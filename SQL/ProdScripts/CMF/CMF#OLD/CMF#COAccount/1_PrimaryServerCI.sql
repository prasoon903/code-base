BEGIN TRAN
--COMMIT TRAN
--ROLLBACK TRAN


UPDATE TOP(1) BSegment_balances SET  
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
WHERE acctId = 16996133


/*
SELECT 
ReportHistoryCtrCC01,
ReportHistoryCtrCC02,
ReportHistoryCtrCC03,
ReportHistoryCtrCC04,
ReportHistoryCtrCC05,
ReportHistoryCtrCC06,
ReportHistoryCtrCC07,
ReportHistoryCtrCC08,
ReportHistoryCtrCC09,
ReportHistoryCtrCC10,
ReportHistoryCtrCC11,
ReportHistoryCtrCC12,
ReportHistoryCtrCC13,
ReportHistoryCtrCC14,
ReportHistoryCtrCC15,
ReportHistoryCtrCC16,
ReportHistoryCtrCC17,
ReportHistoryCtrCC18,
ReportHistoryCtrCC19,
ReportHistoryCtrCC20,
ReportHistoryCtrCC21,
ReportHistoryCtrCC22,
ReportHistoryCtrCC23,
ReportHistoryCtrCC24 
FROM BSegment_balances WITH (NOLOCK)
WHERE acctId = 16996133
*/