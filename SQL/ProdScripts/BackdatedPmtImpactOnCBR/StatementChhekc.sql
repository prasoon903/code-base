select accountnumber,paymenthistprofile,* From cbreportingdetail with(nolock) where acctid = 879699
order by statementdate desc

select * From BSCBRPHPHistory with(nolock) where acctid = 879699
order by statementdate desc

select SH.AccountNumber, sh.currentbalance, csh.currentbalance, CycleDueDTD, SH.AmountOfTotalDue,* 
from statementheader sh with(nolock) 
join currentstatementheader csh with(nolock) on csh.acctid = sh.acctid and csh.statementdate = sh.statementdate
where sh.acctid = 879699
order by sh.statementdate desc

SELECT * FROM CurrentBalanceAudit WITH (NOLOCK) WHERE AID = 879699 AND DENAME = 115 ORDER BY BusinessDay DESC


SELECT ReportHistoryCtrCC01,ReportHistoryCtrCC02,ReportHistoryCtrCC03,ReportHistoryCtrCC04,ReportHistoryCtrCC05,ReportHistoryCtrCC06,
ReportHistoryCtrCC07,ReportHistoryCtrCC08,ReportHistoryCtrCC09,ReportHistoryCtrCC10,ReportHistoryCtrCC11,ReportHistoryCtrCC12,
ReportHistoryCtrCC13,ReportHistoryCtrCC14,ReportHistoryCtrCC15,ReportHistoryCtrCC16,ReportHistoryCtrCC17,ReportHistoryCtrCC18,
ReportHistoryCtrCC19,ReportHistoryCtrCC20,ReportHistoryCtrCC21,ReportHistoryCtrCC22,ReportHistoryCtrCC23,ReportHistoryCtrCC24 
FROM BSegment_balances WITH (NOLOCK)
WHERE acctId = 879699
