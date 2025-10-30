SELECT * FROM MergeAccountJob WITH (NOLOCK) WHERE DestAccountNumber = '1100011121513166   '

SELECT * FROM MergeAccountJob WITH (NOLOCK)
ORDER BY Skey DESC


SELECT TxnSource, SrcPriority, DestPriority, PostTime, MergeStatus, SrcTxnAcctID, DestTxnAcctID, creditplantype, SrcCMTTranType, DestCMTTranType, SrcCCardAction, DestCCardAction, PlanUUID, 
SrcTransactionAmount, DestTransactionAmount, InvoiceNumber, CardAcceptorNameLocation, * 
FROM LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.MrgActCCardLog WITH (NOLOCK) 
--WHERE JobID = 2543053599
WHERE DestCCardAcctId = 19359130
AND TxnSource IN ('29', '39') 


SELECT TxnSource, OriginalPurchaseAmount, SrcPriority, DestPriority, PostTime, MergeStatus, SrcTxnAcctID, DestTxnAcctID, creditplantype, SrcCMTTranType, DestCMTTranType, SrcCCardAction, DestCCardAction, PlanUUID, 
SrcTransactionAmount, DestTransactionAmount, InvoiceNumber, CardAcceptorNameLocation, * 
FROM LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.MrgActCCardLog WITH (NOLOCK) 
--WHERE JobID = 2543053599
WHERE DestCMTTranType = '41' AND CreditPlanType = '16' --AND PlanUUID IS NULL
--WHERE RetailGroupId = '53c371e2-87d5-4217-814e-00e36078af30'


SELECT TOP(10) * FROM LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.ServiceCallResponseDataCI WITH (NOLOCK) WHERE TranID IN (44387328455,44387328492,44387328354)

SELECT AccountNumber, MergeActivityFlag, TxnSource, * FROM LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.CCard_Primary WITH (NOLOCK) WHERE TranID IN (44387328455,44387328492,44387328354)

SELECT XRequestIDNew, * FROM LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.AlertNotificationLog_Processed WITH (NOLOCK) 
WHERE AccountNumber = '1100011107782256' 
AND Category LIKE 'Merge%'
ORDER by Skey DESC

SELECT ILPS.ActivityOrder, MergeIndicator, ILPS.LoanTerm, ILPS.LasttermDate, ILPS.PlanUUID, BP.AccountNumber, JobStatus,ILPS.ActivityAmount,CL.LutDescription AS ActivityDescription, ILPS.parent02AID, ILPS.CreditPlanMaster, ILPS.PlanID, ILPS.ScheduleID, ILPS.TranId, ILPS.AuthTranId, ILPS.TotalPrincipal, ILPS.Principal, ILPS.CurrentBalance, 
ILPS.OriginalLoanAmount, ILPS.LoanDate, ILPS.OriginalLoanEndDate, ILPS.LoanEndDate, ILPS.LoanTerm, ILPS.RevisedLoanTerm, ILPS.EqualPaymentAmountCalc, ILPS.EqualPaymentAmountPassed, ILPS.FirstMonthPayment, 
ILPS.LastMonthPayment, ILPS.ScheduleIndicator, ILPS.ScheduleDate, ILPS.PlanUUID, ILPS.CaseID, ILPS.Activity, ILPS.LoanReversedDate, ILPS.ActivityAmount, ILPS.LastStatementDate,
ILPS.DrCrIndicator_MTC,ILPS.TransactionUniqueID,ILPS.PaidOffDate, ILPS.MaturityDate, ILPS.ActivityOrder, FileDueToError, LoanStartDate, LastTermDate, waiveminduecycle, CorrectionDate, ILPS.PaidOffDate
FROM PROD1GSDB01.CCGS_CoreIssue.dbo.ILPScheduleDetailSummary AS ILPS WITH (NOLOCK) INNER JOIN
PROD1GSDB01.CCGS_CoreIssue.dbo.BSegment_Primary AS BP WITH (nolock) ON (ILPS.parent02AID = BP.acctId) LEFT OUTER JOIN
PROD1GSDB01.CCGS_CoreIssue.dbo.CCardLookUp AS CL WITH (NOLOCK) ON (ILPS.Activity = CL.LutCode)
WHERE CL.LUTid = 'EPPReasonCode' 
--AND BP.AccountNumber = '1100011103659854'
--AND ILPS.parent02AID = 2406557 
--AND BP.UniversalUniqueID = '7fac5943-2bbd-4f32-ab5a-26ef48148c27'
AND ILPS.PlanID IN (46168869)
--AND ILPS.PlanUUID = '83ddc3a3-52e5-4e50-b1a7-3661c43757af'
--AND ActivityOrder = 1
ORDER BY ILPS.LoanDate


SELECT BSAcctid, RMATranUUID, OrderNumber,RetailInvoiceNumber, MergeActivityFlag, CP.CMTTRANTYPE, CP.TxnSource,CP.TxnAcctId, CP.creditplanmaster, CP.TransactionAmount, CP.PaymentCreditFlag,
CP.TranId,CP.TranRef,CP.tranorig,CP.TransmissionDateTime,CP.atid,Trantime,CP.PostTime,CP.RevTgt,
CP.PostingRef,CS.CardAcceptorNameLocation,CP.MemoIndicator, Transactionidentifier,
CP.TxnCode_Internal,CP.ARTxnType,CP.NoBlobIndicator,CP.CaseID, CP.RMATranUUID, CP.TransactionDescription, 
CP.MergeActivityFlag, CP.HostMachineName, CP.ClaimID, CP.EmbAcctID, CP.ClientId, CP.PartnerId
--,CP.*
FROM CCard_Primary CP WITH (NOLOCK)
LEFT JOIN CCard_Secondary CS WITH (NOLOCK) ON (CP.TranId = CS.TranId)
WHERE CP.AccountNumber IN ('1100011189227527') 
--AND CP.TxnAcctId = 46168869 --AND CP.MemoIndicator IS NULL
--AND CP.TranID IN (9877921888337920, 9596445650452480)
AND MergeActivityFlag IS NOT NULL
AND TxnSource IN ('39', '29')
ORDER BY CP.PostTime DESC

--1100011121513166   