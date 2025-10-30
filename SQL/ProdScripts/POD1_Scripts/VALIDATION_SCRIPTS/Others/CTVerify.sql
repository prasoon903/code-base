select * from version with (nolock) order by entryid desc

SELECT        bp.AccountNumber,ActivityAmount,CL.LutDescription AS ActivityDescription, ILPS.parent02AID, ILPS.PlanID, ILPS.ScheduleID, ILPS.TranId, ILPS.AuthTranId, ILPS.TotalPrincipal, ILPS.Principal, ILPS.CurrentBalance, 
                         ILPS.OriginalLoanAmount, ILPS.LoanDate, ILPS.OriginalLoanEndDate, ILPS.LoanEndDate, ILPS.LoanTerm, ILPS.RevisedLoanTerm, ILPS.EqualPaymentAmountCalc, ILPS.EqualPaymentAmountPassed, ILPS.FirstMonthPayment, 
                         ILPS.LastMonthPayment, ILPS.ScheduleIndicator, ILPS.ScheduleDate, ILPS.PlanUUID, ILPS.CaseID, ILPS.Activity, ILPS.LoanReversedDate, ILPS.ActivityAmount, ILPS.LastStatementDate, ILPS.ActivityAmount,
                         ILPS.DrCrIndicator_MTC,ILPS.TransactionUniqueID,ILPS.PaidOffDate, ILPS.MaturityDate, ILPS.ActivityOrder, ILPS.CardAcceptorNameLocation
FROM            ILPScheduleDetailSummary AS ILPS WITH (NOLOCK) INNER JOIN
                         BSegment_Primary AS bp WITH (nolock) ON ILPS.parent02AID = bp.acctId LEFT OUTER JOIN
                         CCardLookUp AS CL WITH (NOLOCK) ON ILPS.Activity = CL.LutCode
WHERE        (CL.LUTid = 'EPPReasonCode') AND (bp.AccountNumber = '1200011302439099') --AND ILPS.PlanID = 5010
ORDER BY ILPS.LoanDate


SELECT BSAcctid, C.TxnIsFor,MessageReversalInd, C.creditplanmaster,C.TxnAcctId,C.TranId,C.TranRef,C.TransmissionDateTime,C.PostingRef,C.CardAcceptNameLocation,CMTTRANTYPE,C.TxnCode_Internal,C.TransactionAmount,txnsource,C.ARTxnType,C.atid,Trantime,C.PostTime,noblobindicator,
C.TranRef,C.TranId,txnacctid,C.tranorig,C.TransactionDescription,C.TxnCode_Internal,C.GroupId,PaymentReferenceId,C.creditplanmaster,
MessageReasonCode,TransactionAmount,FeesAcctID,accountnumber,TranId,UniversalUniqueID,CaseID,PaymentCreditFlag,MessageIdentifier,TranRef,txnacctid,* 
FROM CCard_Primary C WITH (NOLOCK)  --where C.CMTTRANTYPE = '43'
where AccountNumber in (select accountnumber from bsegment_primary with(nolock) where acctid = 272864) 
AND CMTTRANTYPE = '40' AND TxnSource = '29'
ORDER BY C.posttime desc

SELECT CS.CardAcceptorNameLocation, BCC.CardAcceptorNameLocation, BP.acctId, BP.Parent02AID, BCC.PlanUUID, PlanSegCreateDate
FROM CPSgmentAccounts AS bp WITH (nolock) INNER JOIN
CPSgmentCreditCard AS bcc WITH (nolock) ON (bp.acctId = bcc.acctId)
JOIN CCard_Secondary CS WITH (NOLOCK) ON (BP.SingleSaleTranID = CS.TranID)
WHERE CS.CardAcceptorNameLocation IS NOT NULL AND BCC.CardAcceptorNameLocation IS NULL
AND BP.CreditPlanType = '16'


SELECT        bp.acctId,bcc.CardAcceptorNameLocation,bcc.OriginalPurchaseAmount, bcc.PlanUUID,bp.parent02AID, bp.CurrentBalance,bcc.InterestRate1,bcc.DateOfTotalDue, bcc.FirstDueDate,bcc.PayOffDate,bcc.OrigEqualPmtAmt, bcc.SRBWithInstallmentDue, bcc.SRBWithInstallmentDueCC1,bp.SingleSaleTranID,bcc.CardAcceptorNameLocation,bcc.LoanEndDate,bcc.MaturityDate, 
						bcc.AuthTranId, bp.DisputesAmtNS, bcc.RetailInvoiceNumber, bcc.RetailOrderNumber, bp.parent01AID, bcc.PlanUUID, bcc.currentbalanceco, bcc.AmountOfTotalDue, 
                         bcc.AmtOfPayCurrDue, bcc.CoreAuthTranID, bcc.AmountOfCreditsAsPmtCTD,bp.AmountOfPaymentsCTD, bp.AmountOfDebitsRevCTD, bcc.IntBilledNotPaid, bcc.CPSUniversalUniqueID, bp.InvoiceNumber, bcc.DateOfTotalDue, 
                         bcc.InterestRate4, bp.parent01AID AS Expr2, bp.cpsinterestplan, bcc.AuthTranId AS Expr3, bp.CurrentBalance AS Expr4, bp.Principal, bp.latefeesbnp, bcc.IntBilledNotPaid AS Expr5, bp.recoveryfeesbnp, 
                         bp.NSFFeesBilledNotPaid, bcc.CycleDueDTD, bp.MembershipFeesBNP, bp.creditplantype, bcc.PurchaseRevCTD_InCycle, bp.AmountOfDebitsRevCTD AS Expr6, bp.AmountOfCreditsRevCTD, bp.CounterForEqualPayment, 
                         bcc.SRBWithInstallmentDue AS Expr7, bcc.SBWithInstallmentDue AS Expr8
FROM            CPSgmentAccounts AS bp WITH (nolock) INNER JOIN
                         CPSgmentCreditCard AS bcc WITH (nolock) ON bp.acctId = bcc.acctId
WHERE        (bp.parent02AID IN (272864)) --and bcc.acctId = 5100
ORDER BY bp.parent02AID


SELECT CardAcceptorNameLocation,* FROM CCard_Secondary WITH (NOLOCK)
WHERE TranID IN 
(
SELECT TranID
FROM CCard_Primary C WITH (NOLOCK)  --where C.CMTTRANTYPE = '43'
where AccountNumber in (select accountnumber from bsegment_primary with(nolock) where acctid = 272864) 
AND CMTTRANTYPE = '40' AND TxnSource = '29'
)


SELECT * FROM SYN_CoreAuth_RetailAPILineItems A WITH (NOLOCK)
JOIN SYN_CoreAuth_RetailAPILog B WITH (NOLOCK) ON (A.request_id = B.request_id)
WHERE 
--A.request_id = '3a890d44-72b8-4b4d-97f8-1d0a3d8e109e' AND
B.AccountNumber = '1200011302439099'