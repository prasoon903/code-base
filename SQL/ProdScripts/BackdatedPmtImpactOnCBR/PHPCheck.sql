SELECT PaymentHistProfile,* FROM CBReportingDetail WITH (NOLOCK) WHERE acctID IN ( 13002817) AND StatementDate = '2024-06-30 23:59:57.000'

SELECT ReportHistoryCtrCC01,ReportHistoryCtrCC02,ReportHistoryCtrCC03,ReportHistoryCtrCC04,ReportHistoryCtrCC05,ReportHistoryCtrCC06,
ReportHistoryCtrCC07,ReportHistoryCtrCC08,ReportHistoryCtrCC09,ReportHistoryCtrCC10,ReportHistoryCtrCC11,ReportHistoryCtrCC12,
ReportHistoryCtrCC13,ReportHistoryCtrCC14,ReportHistoryCtrCC15,ReportHistoryCtrCC16,ReportHistoryCtrCC17,ReportHistoryCtrCC18,
ReportHistoryCtrCC19,ReportHistoryCtrCC20,ReportHistoryCtrCC21,ReportHistoryCtrCC22,ReportHistoryCtrCC23,ReportHistoryCtrCC24 
FROM BSegment_balances WITH (NOLOCK)
WHERE acctId = 13002817

--SELECT * FROM ccard_primary WITH (NOLOCK) WHERE AccountNumber = '1100011125947865' ORDER BY posttime DESC

SELECT CycleDueDTD, * FROm StatementHeader WITH (NOLOCK) WHERE acctID IN (13002817) 
--AND StatementDate = '2024-05-31 23:59:57.000'
order by statementdate desc

SELECT * FROM BSCBRPHPHistory WITH (NOLOCK) WHERE acctID = 13002817

SELECT * FROM BSegment_Balances WITH (NOLOCK) WHERE acctID = 2588948

SELECT ReportHistoryCtrCC01,ReportHistoryCtrCC02,ReportHistoryCtrCC03,ReportHistoryCtrCC04,ReportHistoryCtrCC05,ReportHistoryCtrCC06,
ReportHistoryCtrCC07,ReportHistoryCtrCC08,ReportHistoryCtrCC09,ReportHistoryCtrCC10,ReportHistoryCtrCC11,ReportHistoryCtrCC12,
ReportHistoryCtrCC13,ReportHistoryCtrCC14,ReportHistoryCtrCC15,ReportHistoryCtrCC16,ReportHistoryCtrCC17,ReportHistoryCtrCC18,
ReportHistoryCtrCC19,ReportHistoryCtrCC20,ReportHistoryCtrCC21,ReportHistoryCtrCC22,ReportHistoryCtrCC23,ReportHistoryCtrCC24 
FROM BSegment_balances WITH (NOLOCK)
WHERE acctId = 2588948