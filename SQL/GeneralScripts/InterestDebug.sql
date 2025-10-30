
SELECT TOP(1) 'TNP Time===> ' [Table], tnpdate FROM CommonTNP WITH(NOLOCK) WHERE ATID = 60 --AND InstitutionID = 6969


SELECT BP.acctId, AccountNumber, BP.CurrentBalance, BP.CycleDueDTD, BP.BeginningBalance, BC.AmountOfTotalDue, BB.TotalTrailingInterest,
BB.TotalNonTrailingInterest, BC.IntBilledNotPaid, BP.DaysInCycle, BC.SRBWithInstallmentDue,
BC.AccountGraceStatus, BP.GraceDaysStatus, BC.NewTransactionsAccrued, BC.NewTransactionsAgg, BC.NewTransactionsBSFC,
BC.RevolvingAccrued, BC.RevolvingAgg, BC.RevolvingBSFC, BC.AfterCycleRevolvBSFC
FROM BSegment_Primary BP WITH (NOLOCK)
JOIN BSegment_Secondary BS WITH (NOLOCK) ON (BP.acctID = BS.acctId)
JOIN BSegmentCreditCard BC WITH (NOLOCK) ON (BS.acctID = BC.acctId)
JOIN BSegment_Balances BB WITH (NOLOCK) ON (BC.acctID = BB.acctId)
WHERE BP.acctId = 14551608

SELECT CP.acctId, CP.parent02AID, CP.creditplantype, CP.CurrentBalance, CC.CycleDueDTD, CC.AmountOfTotalDue, CC.SRBWithInstallmentDue, CC.TrailingInterestDate,
CP.Principal, CC.IntBilledNotPaid,
CC.NewTransactionsAccrued, CC.NewTransactionsAgg, CC.NewTransactionsBSFC, CC.RevolvingAccrued, CC.RevolvingAgg, CC.AfterCycleRevolvBSFC
FROM CPSgmentAccounts CP WITH (NOLOCK)
JOIN CPSgmentCreditCard CC WITH (NOLOCK) ON (CP.acctID = CC.acctID)
WHERE CP.parent02AID = 14551608