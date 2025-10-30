SELECT AccountNumber,ILPS.ActivityOrder, MergeIndicator, ILPS.LoanDate, ILPS.OriginalLoanEndDate, ILPS.LoanEndDate, ILPS.PaidOffDate, ILPS.LoanTerm, ILPS.RevisedLoanTerm, LoanStartDate, ILPS.LasttermDate, ILPS.PlanUUID, BP.AccountNumber, JobStatus,ILPS.ActivityAmount,
CL.LutDescription AS ActivityDescription, ILPS.parent02AID, ILPS.CreditPlanMaster, ILPS.PlanID, ILPS.ScheduleID, ILPS.TranId, ILPS.AuthTranId, ILPS.TotalPrincipal, ILPS.Principal, ILPS.CurrentBalance, 
ILPS.OriginalLoanAmount, ILPS.LoanTerm, ILPS.RevisedLoanTerm, ILPS.EqualPaymentAmountCalc, ILPS.EqualPaymentAmountPassed, ILPS.FirstMonthPayment, 
ILPS.LastMonthPayment, ILPS.ScheduleIndicator, ILPS.ScheduleDate, ILPS.PlanUUID, ILPS.CaseID, ILPS.Activity, ILPS.LoanReversedDate, ILPS.ActivityAmount, ILPS.LastStatementDate,
ILPS.DrCrIndicator_MTC,ILPS.TransactionUniqueID,ILPS.PaidOffDate, ILPS.MaturityDate, ILPS.ActivityOrder, FileDueToError, LoanStartDate, LastTermDate, waiveminduecycle, CorrectionDate, ILPS.PaidOffDate,
 MergeSourceAccountID, MergeSourcePlanID, MergeDestinationPlanID, MergeDate
FROM ILPScheduleDetailSummary AS ILPS WITH (NOLOCK) INNER JOIN
BSegment_Primary AS BP WITH (nolock) ON (ILPS.parent02AID = BP.acctId) LEFT OUTER JOIN
CCardLookUp AS CL WITH (NOLOCK) ON (ILPS.Activity = CL.LutCode)
WHERE CL.LUTid = 'EPPReasonCode' 
--AND BP.AccountNumber = '1100011189227527'
AND ILPS.parent02AID = 36908  -- 4351385
--AND BP.UniversalUniqueID = '9ee4459b-1d4c-4018-ac7d-32471c771ab2'
AND ILPS.PlanID IN (33839672) -- 31067224
--AND ILPS.PlanUUID = '9401936f-fbe4-412a-ba22-c21f64f31a64'
--AND ActivityOrder = 1
--AND Activity NOT IN (1, 3)
ORDER BY ILPS.LoanDate



SELECT parent02AID, COUNT(1) [Count]
FROM CPSgmentAccounts WITH (NOLOCK)
WHERE CreditPlanType = '16'
GROUP BY parent02AID
HAVING COUNT(1) > 100
ORDER BY COUNT(1) DESC


SELECT mergeactivityflag,BSAcctid, HostmachineName, CP.CMTTRANTYPE, CP.TransactionDescription, 
CP.TxnSource,CP.TxnAcctId,Trantime,CP.PostTime, CP.creditplanmaster, CP.TransactionAmount, CP.PaymentCreditFlag,
CP.TranId,CP.TranRef,CP.tranorig,CP.TransmissionDateTime,CP.atid,CP.RevTgt,CP.MemoIndicator, NoblobIndicator, InvoiceNumber,
CP.PostingRef,CS.CardAcceptorNameLocation, Transactionidentifier,
CP.TxnCode_Internal,CP.ARTxnType,CP.NoBlobIndicator,CP.CaseID, CP.RMATranUUID, CP.TransactionDescription, 
CP.MergeActivityFlag, CP.HostMachineName, CP.ClaimID, CP.EmbAcctID, CP.ClientId, CP.PartnerId, DisputeIndicator, TransactionLifeCycleUUID
--,CP.*
FROM LS_PRODDRGSDB01.ccgs_coreissue.dbo.CCard_Primary CP WITH (NOLOCK)
LEFT JOIN LS_PRODDRGSDB01.ccgs_coreissue.dbo.CCard_Secondary CS WITH (NOLOCK) ON (CP.TranId = CS.TranId)
WHERE CP.AccountNumber IN (SELECT AccountNumber FROM LS_PRODDRGSDB01.ccgs_coreissue.dbo.BSegment_Primary WITH(NOLOCK) WHERE acctId = 2649763) 
--AND CP.TxnAcctId = 47245123 --AND CP.MemoIndicator IS NULL
--AND CP.TranID IN (40722692955)
and tranref =40722692955
--AND CMTTranType IN ('40', '49')
--AND TransactionLifeCycleUniqueID = 9617327
--AND RMATranUUID = '3bab2bfb-c584-4764-9ee8-f450fdd59588'
AND CP.PostTime BETWEEN '2021-05-31 23:59:57.000' AND '2021-06-30 23:59:57.000'
ORDER BY CP.PostTime DESC





SELECT ILPS.PlanID, CL.LutDescription AS ActivityDescription
FROM ILPScheduleDetailSummary AS ILPS WITH (NOLOCK) INNER JOIN
BSegment_Primary AS BP WITH (nolock) ON (ILPS.parent02AID = BP.acctId) LEFT OUTER JOIN
CCardLookUp AS CL WITH (NOLOCK) ON (ILPS.Activity = CL.LutCode)
WHERE CL.LUTid = 'EPPReasonCode' 
--AND BP.AccountNumber = '1100011189227527'
--AND ILPS.parent02AID = 1678239  -- 4351385
--AND BP.UniversalUniqueID = '9ee4459b-1d4c-4018-ac7d-32471c771ab2'
AND ILPS.PlanID IN (47245123) -- 31067224
--AND ILPS.PlanUUID = '9401936f-fbe4-412a-ba22-c21f64f31a64'
--AND ActivityOrder = 1
--AND Activity = 24
GROUP BY ILPS.PlanID, CL.LutDescription
ORDER BY ILPS.PlanID


SELECT CL.LutDescription AS ActivityDescription, COUNT(1) 
FROM ILPScheduleDetailSummary AS ILPS WITH (NOLOCK) INNER JOIN
BSegment_Primary AS BP WITH (nolock) ON (ILPS.parent02AID = BP.acctId) LEFT OUTER JOIN
CCardLookUp AS CL WITH (NOLOCK) ON (ILPS.Activity = CL.LutCode)
WHERE CL.LUTid = 'EPPReasonCode' 
--AND BP.AccountNumber = '1100011189227527'
AND ILPS.parent02AID = 1678239  -- 4351385
--AND BP.UniversalUniqueID = '9ee4459b-1d4c-4018-ac7d-32471c771ab2'
--AND ILPS.PlanID IN (77776306) -- 31067224
--AND ILPS.PlanUUID = '9401936f-fbe4-412a-ba22-c21f64f31a64'
--AND ActivityOrder = 1
--AND Activity = 24
GROUP BY CL.LutDescription





SELECT ILPS.*
FROM ILPScheduleDetailSummary AS ILPS WITH (NOLOCK) 
--AND BP.AccountNumber = '1100011189227527'
--AND ILPS.parent02AID = 1678239  -- 4351385
--AND BP.UniversalUniqueID = '9ee4459b-1d4c-4018-ac7d-32471c771ab2'
WHERE ILPS.PlanID IN (47245123) -- 31067224