SELECT CP.AmountOfCreditsLTD, CPC.AmountOfCreditsRevLTD, PostMergeDisputeLTD, 
DisputesAmtNS, DispRCHFavororWriteoff, ManualPurchaseReversal_LTD,
CP.AmountOfCreditsLTD - CPC.AmountOfCreditsRevLTD - PostMergeDisputeLTD + DisputesAmtNS + DispRCHFavororWriteoff + ManualPurchaseReversal_LTD TotalPaid, *
FROM CPSgmentAccounts CP WITH (NOLOCK)
JOIN CPSgmentCreditCard CPC WITH (NOLOCK) ON (CP.acctID = CPC.acctId)
WHERE CP.parent02AID = 54563773


;WITH CTE
AS
(
SELECT SUM(CP.CurrentBalance) TotalRemaining, SUM(CPC.OriginalPurchaseAmount) TotalFinanced,
SUM(CP.AmountOfCreditsLTD - CPC.AmountOfCreditsRevLTD - PostMergeDisputeLTD + DisputesAmtNS + DispRCHFavororWriteoff + ManualPurchaseReversal_LTD) TotalPaid
FROM CPSgmentAccounts CP WITH (NOLOCK)
JOIN CPSgmentCreditCard CPC WITH (NOLOCK) ON (CP.acctID = CPC.acctId)
WHERE CP.parent02AID = 54563773
AND CreditPlanType = '16'
GROUP BY CP.parent02AID
)
SELECT *,  TotalRemaining - (TotalFinanced - TotalPaid) NetBalance
FROM CTE 