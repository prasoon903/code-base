
SELECT * 
FROM LS_P1MARPRODDB01.ccgs_coreissue.dbo.CCardLookUp with (nolock) 
WHERE LutId = 'EPPReasonCode' 
ORDER BY DisplayOrdr

SELECT DISTINCT PlanUUID 
FROM ILPScheduleDetailSummary with (nolock) 
WHERE Activity = 2 
AND LoanDate > '2022-01-01'
GROUP BY PlanUUID

SELECT PlanID, PlanUUID RMATranUUID, EqualPaymentAmountCalc, CurrentBalance, LoanTerm, OriginalLoanAmount, PaidOffDate, ActivityAmount
FROM ILPScheduleDetailSummary with (nolock) 
WHERE PlanUUID = '3d65eb6a-363c-4cd3-9e46-b8bb9230d17b'
ORDER BY Activity


SELECT PlanID, Parent02AID, PlanUUID RMATranUUID, ScheduleID, EqualPaymentAmountCalc, CurrentBalance, LoanTerm, OriginalLoanAmount, PaidOffDate, ActivityAmount, LoanDate
INTO #TempOverpayment
FROM ILPScheduleDetailSummary with (nolock) 
WHERE Activity = 2 
AND LoanDate > '2022-01-01'
ORDER BY PlanID

select * FROM #TempOverpayment

DROP TABLE IF EXISTS #StatementData
select T1.*, SH.StatementDate, SH.AmountOfTotalDue, SH.AmountOfPaymentsCTD,
ROW_NUMBER() OVER (PARTITION BY T1.parent02AID, T1.PlanID, ScheduleID ORDER BY SH.StatementDate DESC) [Rank]
INTO #StatementData
FROM #TempOverpayment T1
JOIN SummaryHeader SH ON (T1.parent02AID = SH.PArent02AID AND T1.PlanID = SH.acctID AND SH.StatementDate >= '2021-12-31 23:59:57')
WHERE SH.StatementDate < T1.LoanDate


SELECT * FROM #StatementData WHERE Rank = 1 ORDER BY PlanID, StatementDate


select T1.*, StatementDate, AmountOfTotalDue 
INTO #FilteredOverPaymentsData
FROM #TempOverpayment T1
LEFT JOIN #StatementData S1 ON (T1.ScheduleID = S1.ScheduleID AND S1.Rank = 1)

SELECt * FROM #FilteredOverPaymentsData ORDER BY PlanID, LoanDAte, ScheduleID

SELECt DISTINCT PlanID FROM #FilteredOverPaymentsData 



--TotalRevisions: 1569303
--TotalPlans: 1006381
