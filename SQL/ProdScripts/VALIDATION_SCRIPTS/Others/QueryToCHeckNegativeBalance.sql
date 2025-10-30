WITH AllReturns
AS
(
	SELECT RANK() OVER(PARTITION BY ILPS.PlanUUID ORDER BY ILPS.Skey DESC) AS Ranking,BP.AccountNumber,LTRIM(RTRIM(CL.LutDescription)) AS ActivityDescription, ILPS.PlanUUID, ILPS.parent02AID, ILPS.PlanID, ILPS.ScheduleID, ILPS.TranId, ILPS.AuthTranId, ILPS.TotalPrincipal, ILPS.Principal, ILPS.CurrentBalance, 
	ILPS.OriginalLoanAmount, ILPS.LoanDate, ILPS.OriginalLoanEndDate, ILPS.LoanEndDate, ILPS.LoanTerm, ILPS.RevisedLoanTerm, ILPS.EqualPaymentAmountCalc, ILPS.EqualPaymentAmountPassed, ILPS.FirstMonthPayment, 
	ILPS.LastMonthPayment, ILPS.ScheduleIndicator, ILPS.ScheduleDate, ILPS.CaseID, ILPS.Activity, ILPS.LoanReversedDate, ILPS.ActivityAmount, ILPS.LastStatementDate,
	ILPS.DrCrIndicator_MTC,ILPS.TransactionUniqueID,ILPS.PaidOffDate, ILPS.MaturityDate, ILPS.ActivityOrder, ILPS.CardAcceptorNameLocation, ILPS.LastTermDate
	FROM LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.ILPScheduleDetailSummary AS ILPS WITH (NOLOCK) INNER JOIN
	LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.BSegment_Primary AS BP WITH (nolock) ON (ILPS.parent02AID = BP.acctId) LEFT OUTER JOIN
	LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.CCardLookUp AS CL WITH (NOLOCK) ON (ILPS.Activity = CL.LutCode)
	WHERE CL.LUTid = 'EPPReasonCode' 
	AND Activity = 3
)
, ActivityBeforeReturn
AS
(
	SELECT ILPS.* FROM LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.ILPScheduleDetailSummary ILPS WITH (NOLOCK) 
	JOIN AllReturns AR ON (ILPS.PlanID = AR.PlanID)
	WHERE ILPS.ActivityOrder = AR.ActivityOrder - 1
	AND AR.Ranking = 1
)
SELECT * FROM AllReturns AR WITH (NOLOCK)
JOIN ActivityBeforeReturn ABR WITH (NOLOCK) ON (AR.PlanID = ABR.PlanID)
WHERE AR.ActivityAmount > ABR.CurrentBalance
AND AR.Ranking = 1
ORDER BY AR.LoanDate DESC


--SELECT * FROM LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.Version ORDER BY 1 DESC






--SELECT COUNT(1) FROM ILPScheduleDetailSummary ILPS WITH (NOLOCK) WHERE Activity = 3
