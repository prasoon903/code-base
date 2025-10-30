
SELECT TransactionDescription,* FROM MonetaryTxnControl WITH (NOLOCK) WHERE LogicModule = '43'

--UPDATE MonetaryTxnControl SET LogicModuleType = '11' WHERE ActualTranCode = '4001'

SELECT parent02AID, FirstCycleOverride, CurrentCyclePurchases, AppOfPMethod, PlanPMethod, CurrentCycleFees, ARPendingPrincipal, COPendingPrincipal, OverPaymentMethod, S.*
FROM Logo_Primary P with (nolock)
JOIN Logo_Secondary S with (nolock) on (P.acctId = S.acctId)
--WHERE P.acctId = 7250
WHERE P.parent02AID = 7202

SELECT * FROM CCardLookUp WITH (NOLOCK) WHERE LUTid = 'YESNO'

SELECT * FROM Institutions

select * from sys.synonyms


SELECT CurrentCycleFees, ARPendingPrincipal, COPendingPrincipal, * 
FROM Logo_Secondary WITH (NOLOCK) WHERE acctId = 7250

--UPDATE Logo_Secondary SET CurrentCyclePurchases = '2' WHERE acctId = 7250
--UPDATE Logo_Secondary SET CurrentCycleFees = '1' WHERE acctId = 7250
--UPDATE Logo_Secondary SET ARPendingPrincipal = '20' WHERE acctId = 7250
--UPDATE Logo_Secondary SET COPendingPrincipal = '1' WHERE acctId = 7250

SELECT ARPrincipal, CoPrincipal, * FROM Logo_Primary WITH (NOLOCK) WHERE parent02AID = 7206

SELECT MPLMerchantDesc,* FROM MerchantPLAccounts WHERE parent02AID = 7202

SELECT * FROm Institutions

SELECT * FROM UsrServiceMappingDetails

SELECT * FROM UsrServiceMappingMaster

SELECt * FROM BSegment_Primary WITH (NOLOCK) WHERE AccountNumber = '1200081000000006'

SELECT        BP.acctId, BC.ChargeOffDateParam, BC.ChargeOffDate,BS.ClientId, BS.RatificationMethod1, BP.BillingCycle, BP.CustomerId,RTRIM(BP.AccountNumber) AccountNumber, SystemChargeOffStatus, BP.UniversalUniqueID, BP.SystemStatus, BP.ccinhparent125AID, ccinhparent125ATID, BP.CycleDueDTD, BP.CurrentBalance, BC.FirstDueDate, BC.DateOfOriginalPaymentDueDTD, BC.DtofLastDelinqCTD, BC.DaysDelinquent, BC.NoPayDaysDelinquent,
                         BP.BeginningBalance, BP.acctId, BC.DateOfTotalDue, BC.AmountOfTotalDue, BP.AmtOfPayCurrDue, BC.AmtOfPayXDLate, BC.AmountOfPayment30DLate, BC.AmountOfPayment60DLate, BC.AmountOfPayment90DLate, 
                         BC.AmountOfPayment120DLate, BC.AmountOfPayment150DLate, BC.AmountOfPayment180DLate, BC.AmountOfPayment210DLate, BP.LastStatementDate, BP.AmountOfDebitsCTD, BP.AmountOfPurchasesCTD, BP.BillingCycle, 
                         BP.AccountNumber, BP.CurrentBalance AS Expr2, BP.Principal, BS.servicefeesbnp, BS.latefeesbnp, AccountProperty, LAD, NAD, LAPD, DeAcctActivityDate, BP.DateOfNextStmt, AmountOfPendingPrincipal
FROM            BSegment_Primary AS BP WITH (nolock) INNER JOIN
                         BSegmentCreditCard AS BC WITH (nolock) ON BP.acctId = BC.acctId INNER JOIN
                         BSegment_Secondary AS BS WITH (nolock) ON BP.acctId = BS.acctId INNER JOIN
                         BSegment_Balances AS bb WITH (NOLOCK) ON BP.acctId = bb.acctId
WHERE        (BP.acctId IN (2812265))


SELECT CPA.acctId,
CASE 
	WHEN CPA.creditplantype = '16' THEN 'RETAIL'
	WHEN CPA.creditplantype = '10' THEN 'RRC'
	ELSE 'Normal Plan' END AS PlanType, 
CPCC.PlanUUID, CPA.CurrentBalance, CPCC.EqualPaymentAmt, CPCC.OrigEqualPmtAmt, CPCC.AmountOfTotalDue, CPA.Principal, CPCC.AmountOfPendingPrincipal,
CPCC.MergeIndicator, CPA.CounterForEqualPayment, EqualPayments, 
TermCmplDate, CPA.DisputesAmtNS, CPA.InvoiceNumber, CPA.SingleSaleTranID, CPCC.OriginalPurchaseAmount,
CPA.parent02AID, CPA.parent01AID,
CPCC.FirstDueDate,
CPCC.AmountOfTotalDue AS [Payment due],
CPCC.CycleDueDTD,
CPCC.AmtOfPayCurrDue,
CPA.AmountOfPaymentsCTD, CPCC.AmtOfInterestLTD,
CASE WHEN ISNULL(CPCC.CycleDueDTD, 0) < 2 THEN 'Current' ELSE 'Delinquent' END AS Delinquency,
CPCC.RetailAniversaryDate, CPA.plansegcreatedate, CPCC.MergeDate
FROM CPSgmentAccounts CPA WITH (NOLOCK)
JOIN CPSgmentCreditCard CPCC WITH (NOLOCK) ON (CPA.acctId = CPCC.acctId)
--WHERE CPA.acctId = 5040
WHERE CPA.parent02AID = 2812265

SELECT CPA.acctId, CPA.parent02AID,
CASE 
	WHEN CPA.creditplantype = '2' THEN 'CASH'
	WHEN CPA.creditplantype = '10' THEN 'RRC'
	ELSE 'Normal Plan' END AS PlanType, creditplantype, 
CPA.CurrentBalance, CPCC.AmountOfTotalDue, 
CPA.Principal, CPB.AmountOfPendingPrincipal,
IntBilledNotPaid, CPB.InterestPBNP, 
CPA.NSFFeesBilledNotPaid, CPB.NSFFeePBNP, 
CPA.servicefeesbnp, CPB.ServiceChargeFeePBNP, 
CPA.latefeesbnp, CPB.LateFeePBNP, 
CPA.MembershipFeesBNP, CPB.MembershipFeePBNP, 
CPA.recoveryfeesbnp, CPB.RecoveryFeePBNP, 
CPA.overlimitbnp, CPB.OverlimitFeePBNP
FROM CPSgmentAccounts CPA WITH (NOLOCK)
JOIN CPSgmentCreditCard CPCC WITH (NOLOCK) ON (CPA.acctId = CPCC.acctId)
JOIN CPSgment_Balances CPB WITH (NOLOCK) ON (CPCC.acctId = CPB.acctId)
--WHERE CPA.acctId = 5040
WHERE CPA.parent02AID = 2812265
ORDER BY CPA.acctId


SELECT CPA.acctId, CPA.parent02AID,
CASE 
	WHEN CPA.creditplantype = '2' THEN 'CASH'
	WHEN CPA.creditplantype = '10' THEN 'RRC'
	ELSE 'Normal Plan' END AS PlanType, creditplantype, LastStatementAPR,
CPA.CurrentBalance, CPCC.AmountOfTotalDue, 
CPA.Principal, CPB.AmountOfPendingPrincipal,
IntBilledNotPaid, CPB.InterestPBNP, 
CPA.servicefeesbnp, CPB.ServiceChargeFeePBNP, 
CPA.latefeesbnp, CPB.LateFeePBNP
FROM CPSgmentAccounts CPA WITH (NOLOCK)
JOIN CPSgmentCreditCard CPCC WITH (NOLOCK) ON (CPA.acctId = CPCC.acctId)
JOIN CPSgment_Balances CPB WITH (NOLOCK) ON (CPCC.acctId = CPB.acctId)
--WHERE CPA.acctId = 5040
WHERE CPA.parent02AID = 2812265
ORDER BY CPA.acctId


SELECT SH.acctId, SH.parent02AID, SH.StatementDate, SH.CurrentBalance, SH.AmountOfTotalDue, SH.APR
FROM SummaryHeader SH WITH (NOLOCK)
JOIN SummaryHeaderCreditCard SHCC WITH (NOLOCK) ON (SH.acctId = SHCC.acctId AND SH.StatementID = SHCC.StatementID)
WHERE SH.parent02AID = 2812266
ORDER BY SH.StatementDate DESC


SELECT BSAcctid, CP.CMTTRANTYPE, CP.ARTxnType, CP.TxnSource, CP.CardholderBillingAmount,CP.TxnAcctId, CP.creditplanmaster, CP.TransactionAmount, CP.PaymentCreditFlag,
CP.TranId,CP.TranRef,CP.tranorig,CP.TransmissionDateTime,CP.atid,Trantime,CP.PostTime,CP.RevTgt,
CP.PostingRef,CS.CardAcceptorNameLocation,CP.MemoIndicator, Transactionidentifier,
CP.TxnCode_Internal,CP.NoBlobIndicator,CP.CaseID, CP.RMATranUUID, CP.TransactionDescription, 
CP.MergeActivityFlag, CP.HostMachineName, CP.ClaimID, CP.EmbAcctID, CP.ClientId, CP.PartnerId, CS.ProfileIDatAutoReage, CS.FileName
--,CP.*
FROM CCard_Primary CP WITH (NOLOCK)
LEFT JOIN CCard_Secondary CS WITH (NOLOCK) ON (CP.TranId = CS.TranId)
WHERE CP.AccountNumber IN (SELECT AccountNumber FROM BSegment_Primary WITH(NOLOCK) WHERE acctId = 2812265) 
--AND CP.TxnAcctId = 5088 --AND CP.MemoIndicator IS NULL
--AND CP.TranID IN (9877921888337920, 9596445650452480)
ORDER BY CP.PostTime DESC

--UPDATE CPSgmentCreditCard SET AmountOfPendingPrincipal = 0
--UPDATE BSegmentCreditCard SET AmountOfPendingPrincipal = 0

SELECT * FROM CPSgmentCreditCard


SELECT * FROM CommonTNP WITH (NOLOCK) WHERE ATID = 60
SELECT * FROM CommonTNP WITH (NOLOCK) WHERE TranId > 0
SELECT * FROM ErrorTNP






/*
1200081000000006
1200081000000014
1200081000000022
1200081000000030
*/

DECLARE @BSAcctId INT

SELECT @BSAcctId = acctId FROM BSegment_Primary WITH (NOLOCK) WHERE AccountNumber = '1150001100084791'

SELECT BP.acctId, RTRIM(BP.AccountNumber) AccountNumber, BP.BillingCycle, BP.CycleDueDTD, BC.DateOfTotalDue
, BC.AmountOfTotalDue, BC.SRBWithInstallmentDue, BP.CurrentBalance, BP.Principal, AmountOfPendingPrincipal
FROM BSegment_Primary AS BP WITH (nolock) 
INNER JOIN BSegmentCreditCard AS BC WITH (nolock) ON BP.acctId = BC.acctId 
INNER JOIN BSegment_Secondary AS BS WITH (nolock) ON BP.acctId = BS.acctId 
INNER JOIN BSegment_Balances AS bb WITH (NOLOCK) ON BP.acctId = bb.acctId
WHERE BP.acctId IN (@BSAcctId)

SELECT CPA.acctId, CPA.parent02AID,
CASE 
	WHEN CPA.creditplantype = '2' THEN 'CASH'
	WHEN CPA.creditplantype = '15' THEN 'BT'
	ELSE 'Normal Plan' END AS PlanType, 
CPA.CurrentBalance, 
CPA.Principal, CPB.AmountOfPendingPrincipal,
IntBilledNotPaid, CPB.InterestPBNP, 
CPA.servicefeesbnp, CPB.ServiceChargeFeePBNP, 
CPA.latefeesbnp, CPB.LateFeePBNP
FROM CPSgmentAccounts CPA WITH (NOLOCK)
JOIN CPSgmentCreditCard CPCC WITH (NOLOCK) ON (CPA.acctId = CPCC.acctId)
JOIN CPSgment_Balances CPB WITH (NOLOCK) ON (CPCC.acctId = CPB.acctId)
--WHERE CPA.acctId = 5040
WHERE CPA.parent02AID IN (@BSAcctId)
ORDER BY CPA.acctId