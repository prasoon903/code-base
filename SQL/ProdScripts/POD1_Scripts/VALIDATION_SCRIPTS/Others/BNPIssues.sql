SELECT COUNT(1) 
FROM CurrentSummaryHeader CSH WITH (NOLOCK)
JOIN SummaryHeader SH WITH (NOLOCK) ON (SH.acctId = CSH.acctId AND SH.StatementID = CSH.StatementID)
WHERE /*SH.StatementDate = '2020-12-31 23:59:57' AND*/ CSH.insurancefeesbnp <> 0 --AND SH.CreditPlanType = '10'

SELECT COUNT(1) 
FROM CurrentSummaryHeader CSH WITH (NOLOCK)
JOIN SummaryHeader SH WITH (NOLOCK) ON (SH.acctId = CSH.acctId AND SH.StatementID = CSH.StatementID)
WHERE /*SH.StatementDate = '2020-12-31 23:59:57' AND*/ CSH.IntBilledNotPaid <> 0 AND SH.CreditPlanType = '16'


SELECT SH.StatementDate, COUNT(1) Records
FROM CurrentSummaryHeader CSH WITH (NOLOCK)
JOIN SummaryHeader SH WITH (NOLOCK) ON (SH.acctId = CSH.acctId AND SH.StatementID = CSH.StatementID)
WHERE /*SH.StatementDate >= '2020-08-31 23:59:57' AND*/ SH.StatementDate <= '2020-12-31 23:59:57'
AND CSH.insurancefeesbnp <> 0 AND SH.CreditPlanType = '10'
GROUP BY SH.StatementDate

SELECT SH.StatementDate, COUNT(1) Records 
FROM CurrentSummaryHeader CSH WITH (NOLOCK)
JOIN SummaryHeader SH WITH (NOLOCK) ON (SH.acctId = CSH.acctId AND SH.StatementID = CSH.StatementID)
WHERE /*SH.StatementDate = '2020-12-31 23:59:57' AND*/ CSH.IntBilledNotPaid <> 0 AND SH.CreditPlanType = '16'
GROUP BY SH.StatementDate

