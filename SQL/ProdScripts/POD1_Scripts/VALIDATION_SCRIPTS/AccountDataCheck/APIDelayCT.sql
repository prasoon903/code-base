SELECT ILPS.ActivityOrder, TranID, ILPS.LoanDate, ILPS.ScheduleDate, ILPS.OriginalLoanEndDate, ILPS.LoanEndDate, ILPS.MaturityDate, ILPS.PaidOffDate, ILPS.LoanTerm, ILPS.RevisedLoanTerm, ILPS.PlanUUID, BP.AccountNumber,
CL.LutDescription AS ActivityDescription, ILPS.parent02AID, ILPS.CreditPlanMaster, ILPS.PlanID, ILPS.ScheduleID, ILPS.TranId, ILPS.AuthTranId, ILPS.TotalPrincipal, ILPS.Principal, ILPS.CurrentBalance, 
ILPS.OriginalLoanAmount, ILPS.LoanTerm, ILPS.RevisedLoanTerm, ILPS.EqualPaymentAmountCalc, ILPS.EqualPaymentAmountPassed, ILPS.FirstMonthPayment, 
ILPS.LastMonthPayment, ILPS.ScheduleIndicator, ILPS.ScheduleDate, ILPS.PlanUUID, ILPS.CaseID, ILPS.Activity, ILPS.LoanReversedDate, ILPS.ActivityAmount, ILPS.LastStatementDate,
ILPS.DrCrIndicator_MTC,ILPS.TransactionUniqueID,ILPS.PaidOffDate, ILPS.ActivityOrder, FileDueToError, LoanStartDate, LastTermDate, waiveminduecycle, CorrectionDate, ILPS.PaidOffDate,
ILPS.ClientId, MergeSourceAccountID, MergeSourcePlanID, MergeDestinationPlanID, MergeDate
FROM LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.ILPScheduleDetailSummary AS ILPS WITH (NOLOCK) INNER JOIN
LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.BSegment_Primary AS BP WITH (nolock) ON (ILPS.parent02AID = BP.acctId) LEFT OUTER JOIN
LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.CCardLookUp AS CL WITH (NOLOCK) ON (ILPS.Activity = CL.LutCode)
WHERE CL.LUTid = 'EPPReasonCode' 
--AND BP.AccountNumber = '1100011189227527'
--AND ILPS.parent02AID = 17002822  -- 4351385
--AND BP.UniversalUniqueID = '9ee4459b-1d4c-4018-ac7d-32471c771ab2'
--AND ILPS.PlanID IN (42687738) -- 31067224
AND ILPS.PlanUUID IN ('7ab2a77e-e393-4928-9138-1a4a52a47cb0',
'5c9fe891-940e-40c0-ba3c-8f96f9b47e99',
'95b5cb50-da8c-4c14-8c92-959b5ebb8dcb',
'a163f413-1dd0-48d9-9845-72c0214be74f',
'0de86acc-bc51-4a93-b348-1f1d9fb531b4',
'56f79314-c525-44fd-acb5-291e7fad7d5d',
'27ec0622-bb45-4972-88d1-494adc68c327',
'ff447aa8-fd30-42ad-94df-3821ea5e6bb2')
--AND ActivityOrder = 1
--AND Activity = 24
ORDER BY ILPS.LoanDate

SELECT R.MTI,R.UUID RMATranUUID, Request_ID, R.ClientID,TransmissionDateTime,Amount 
FROM LS_PRODDRGSDB01.CCGS_CoreAuth.dbo.RetailAPILineItems R WITH (NOLOCK) 
WHERE UUID IN (
'7ab2a77e-e393-4928-9138-1a4a52a47cb0',
'a163f413-1dd0-48d9-9845-72c0214be74f',
'0de86acc-bc51-4a93-b348-1f1d9fb531b4',
'27ec0622-bb45-4972-88d1-494adc68c327'
)
ORDER BY UUID, R.MTI





--9a058daf-a3c0-4699-9899-b95dc4308eb0
--accc4a43-cc7a-44c1-b21c-483fc69ac1b2

--7ab2a77e-e393-4928-9138-1a4a52a47cb0
/*
'7ab2a77e-e393-4928-9138-1a4a52a47cb0',
'5c9fe891-940e-40c0-ba3c-8f96f9b47e99',--
'95b5cb50-da8c-4c14-8c92-959b5ebb8dcb',--
'a163f413-1dd0-48d9-9845-72c0214be74f',
'0de86acc-bc51-4a93-b348-1f1d9fb531b4',
'56f79314-c525-44fd-acb5-291e7fad7d5d',--
'27ec0622-bb45-4972-88d1-494adc68c327', 
'ff447aa8-fd30-42ad-94df-3821ea5e6bb2'--

27ec0622-bb45-4972-88d1-494adc68c327
0de86acc-bc51-4a93-b348-1f1d9fb531b4
7ab2a77e-e393-4928-9138-1a4a52a47cb0
a163f413-1dd0-48d9-9845-72c0214be74f

'7ab2a77e-e393-4928-9138-1a4a52a47cb0',
'a163f413-1dd0-48d9-9845-72c0214be74f',
'0de86acc-bc51-4a93-b348-1f1d9fb531b4',
'27ec0622-bb45-4972-88d1-494adc68c327', 

*/

/*


SELECT transactionuuid,TransactionLifeCycleUUID, *
FROM Auth_Primary WITH (NOLOCK)
WHERE AccountNumber IN (SELECT AccountNumber FROM BSegment_Primary WITH(NOLOCK) WHERE acctId = 541408) 
AND TransactionLifeCycleUniqueID = 9617327
AND transactionuuid = '16fa4d08-8744-41b1-a207-adef597700de'

SELECT TransactionLifeCycleUUID, DisputeIndicator, *
FROM ccard_Primary WITH (NOLOCK)
WHERE AccountNumber IN (SELECT AccountNumber FROM BSegment_Primary WITH(NOLOCK) WHERE acctId = 1914100) 
AND TransactionLifeCycleUniqueID = 139891084
--AND TransactionLifeCycleUUID = '16fa4d08-8744-41b1-a207-adef597700de'

*/