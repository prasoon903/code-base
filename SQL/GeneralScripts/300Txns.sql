SELECT BSAcctid, CP.CMTTRANTYPE,CP.TxnAcctId, txnsource, CP.creditplanmaster, CP.TransactionAmount, CP.RMATranUUID,
CP.TranId,CP.TranRef,CP.tranorig,CP.TransmissionDateTime,CP.atid,Trantime,CP.PostTime,CP.RevTgt,
CP.PostingRef,CS.CardAcceptorNameLocation,CP.MemoIndicator, Transactionidentifier,
CP.TxnCode_Internal,CP.ARTxnType,CP.NoBlobIndicator,CP.CaseID, CP.RMATranUUID, CP.CardAcceptorIdCode, CP.TransactionDescription, 
CP.ClientId, Transactionidentifier, NetFeeAmount, WarehouseTxnDate, CP.FleetRepricing, InterchangeFeeAmount, PaymentScheduleUUID,
FeesAcctID, CP.CPMgroup, CS.InvoiceNumber, CP.MessageIdentifier, CP.MergeActivityFlag, CP.ClaimID,CentSiteProcDateOMess, CS.BillingMethodCT,
CS.ReconciliationDate, CS.AdditionalResponseData
--,CP.*
FROM CCard_Primary CP WITH (NOLOCK)
LEFT JOIN CCard_Secondary CS WITH (NOLOCK) ON (CP.TranId = CS.TranId)
WHERE CP.AccountNumber IN (SELECT AccountNumber FROM BSegment_Primary WITH(NOLOCK) WHERE acctId = 5004) 
--AND CP.TxnAcctId = 5098 --AND CP.MemoIndicator IS NULL
ORDER BY CP.PostTime DESC

SELECT PostingFlag,* FROM CCard_Primary WITH (NOLOCK) WHERE BSAcctid = 5004 ORDER BY PostTime

SELECT * FROM CCard_Primary WITH (UPDLOCK) WHERE BSAcctid = 5004 AND TranID 
IN (81067,81068,81069,81070,81071,81072,81073,81074,81075,81076,81077,81078,81079)

SELECT PostingFlag,* FROM CCard_Primary WITH (NOLOCK) WHERE BSAcctid = 5004 AND TranID 
IN (81067,81068,81069,81070,81071,81072,81073,81074,81075,81076,81077,81078,81079)
AND PostingFlag = '1'


SELECT * 
FROM CCard_Primary CP WITH (NOLOCK)
LEFT JOIN trans_in_acct TIA WITH (NOLOCK) ON (CP.TranId = TIA.tran_id_index)
LEFT JOIN CurrentBalanceAudit CBA WITH (NOLOCK) ON (CP.TranId = CBA.tid AND CP.BSAcctid = CBA.AID)



SELECT * FROM trans_in_acct WITH (NOLOCK) WHERE tran_id_index = 81069

SELECT * FROM CurrentBalanceAudit WITH (NOLOCK) WHERE tid = 81069 AND AID = 5004
SELECT * FROM CurrentBalanceAuditPS WITH (NOLOCK) WHERE tid = 81069 AND AID = 5004

SELECT * FROM ErrorTNP WITH (NOLOCK) WHERE TranID = 81069

SELECT * FROM CommonTNP WITH (NOLOCK) WHERE ATID = 60

SELECT COUNT(1), ATID, priority
FROM CommonTNP WITH(NOLOCK)
GROUP BY ATID, priority
ORDER BY priority, ATID DESC

SELECT C.* FROM CommonTNP C WITH (NOLOCK)
JOIN ErrorTNP E WITH (NOLOCK) ON (C.TranId = E.TranId)



select BSAcctid, CMTTRANTYPE, TranId, TranRef, tranorig, RevTgt, TransactionAmount, creditplanmaster,PaymentScheduleUUID, PaymentReferenceId, 
MessageIdentifier, Transactionidentifier, ClientId, CustomerId, MergeActivityFlag, * 
from CCard_Primary with(nolock)  
--where TxnacctId = 5110
WHERE CMTTRANTYPE IN ('40')
ORDER BY PostTime DESC

SELECT       bp.SystemStatus, bp.CurrentBalance,ccinhparent125aid, ccinhparent125ATID,bp.parent05AID, bp.acctId,bcc.DtOfLastDelinqCTD,bcc.AmountOfTotalDue, bcc.RemainingMinimumDue,SystemStatus,bcc.AmtOfInterestYTD,
				bcc.ReageStatus, bcc.ReageNoOfPymts,bcc.ReageDate1,bp.BillingCycle,bp.LastStatementDate,bcc.AccountOpenDate,CreatedTime,
				bp.AmountOfReturnsLTD,bp.AmountOfCreditsLTD, bp.AmountOfCreditsRevCTD,CurrentBalance, CurrentBalanceCO, bp.BeginningBalance,bp.CycleDueDTD, DRPSkipDate, 
				bp.CurrentBalance,bcc.SRBWithInstallmentDue,AmountofTotalDue, bp.AccountNumber,bs.ClientId,PaymentLevel, bcc.ChargeOffDate,bcc.ChargeOffDateParam,bs.DebitWriteOffDate,
				bcc.DateOfTotalDue,bcc.DateOfOriginalPaymentDueDTD,bs.EffectiveEndDate_Acct,bcc.FirstDueDate,bp.DateOfNextStmt,
				bp.ccinhparent125AID,bp.SystemStatus, bp.CurrentBalance, bcc.AmountOfTotalDue, bcc.ChargeOffDate, bcc.SystemChargeOffStatus, bp.LastStatementDate, bp.BeginningBalance, bp.ccinhparent125AID, bp.SystemStatus, bp.Principal, 
					bs.latefeesbnp, bcc.ChargeOffDateParam, bcc.ManualInitialChargeOffReason, bcc.IntBilledNotPaid, bp.CycleDueDTD, bp.AmtOfPayCurrDue, bp.LastPaymentRevDate, bp.BillingCycle, bcc.currentbalanceco, bcc.principalco, 
					bs.NearestEffectiveEndDate, bcc.SBWithInstallmentDue, bcc.SRBWithInstallmentDue, bp.UniversalUniqueID,bcc.AmtOfPayXDLate, ActualDRPStartDate, bcc.daysdelinquent
FROM            BSegment_Primary AS bp WITH (nolock) INNER JOIN
					BSegment_Secondary AS bs WITH (nolock) ON bp.acctId = bs.acctId INNER JOIN
					BSegmentCreditCard AS bcc WITH (nolock) ON bp.acctId = bcc.acctId INNER JOIN
					BSegment_Balances AS bsb WITH (nolock) ON bp.acctId = bsb.acctId
WHERE        (bp.acctId IN (5004))


SELECT       bp.acctId,bp.CurrentBalance, bp.parent02AID,PaymentStartDate, bp.AmountOfCreditsCTD, bp.AmountOfCreditsRevCTD,bcc.OrigEqualPmtAmt, bp.AmountOfReturnsLTD, bp.AmountOfReturnsCTD, bp.AmountOfPaymentsCTD,BeginningBalance, bp.CurrentBalance, CurrentBalanceCO, bp.Principal,bcc.principalco,bcc.SRBWithInstallmentDue, bcc.AmountOfTotalDue, bp.AmountOfCreditsLTD, bcc.AmountOfCreditsRevLTD,bcc.CardAcceptorNameLocation,
              bcc.AmtOfPayCurrDue, bcc.CoreAuthTranID, bcc.AmountOfCreditsAsPmtCTD,bp.AmountOfPaymentsCTD, bp.AmountOfDebitsRevCTD, bcc.IntBilledNotPaid, bcc.PlanUUID, bcc.CPSUniversalUniqueID, bp.InvoiceNumber, bcc.DateOfTotalDue, 
              bcc.InterestRate4, bp.parent01AID AS Expr2, bp.cpsinterestplan, bcc.AuthTranId AS Expr3, bp.CurrentBalance AS Expr4, bp.Principal, bp.latefeesbnp, bcc.IntBilledNotPaid AS Expr5, bp.recoveryfeesbnp, 
              bp.NSFFeesBilledNotPaid, bcc.CycleDueDTD, bp.MembershipFeesBNP, bp.creditplantype, bcc.PurchaseRevCTD_InCycle, bp.AmountOfDebitsRevCTD AS Expr6, bp.AmountOfCreditsRevCTD, bp.CounterForEqualPayment, 
              bcc.SRBWithInstallmentDue AS Expr7, bcc.SBWithInstallmentDue AS Expr8
FROM            CPSgmentAccounts AS bp WITH (nolock) INNER JOIN
                         CPSgmentCreditCard AS bcc WITH (nolock) ON bp.acctId = bcc.acctId
WHERE        (bp.parent02AID IN (5004)) --and bcc.acctId = 5100
ORDER BY bp.parent02AID

--UPDATE CPSgmentAccounts SET CurrentBalance = CurrentBalance - 2 WHERE acctID = 5004

SELECT @@spid