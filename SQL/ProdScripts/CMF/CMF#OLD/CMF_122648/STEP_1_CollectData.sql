
DROP TABLE IF EXISTS TempData_DelinkDebitPlans
SELECT AccountNumber, BP.acctID, BP.LastStatementDate, CP.acctID, CP.DisputesAmtNS, CP.CurrentBalance+CPC.CurrentbalanceCO CurrentBalance, CPC.PaidOutDate 
INTO TempData_DelinkDebitPlans
FROM CPSgmentAccounts CP with (NOLOCK)
JOIN CPSgmentCreditcard CPC WITH (NOLOCK) ON (CP.acctID = CPC.acctID)
JOIN BSegment_Primary BP WITH (NOLOCK) ON (BP.acctID = CP.Parent02AID)
WHERE CP.acctID IN (77131286,98230386,110725137,110815135)
 

 
DROP TABLE IF EXISTS TempXRef_DelinkDebitPlans
SELECT X.*
INTO TempXRef_DelinkDebitPlans
FROM XRefTable X WITH (NOLOCK)
JOIN TempData_DelinkDebitPlans T ON (X.ParentATID = 51 AND X.parentAID = T.BSAcctID AND ChildATID = 52 AND X.ChildAID = T.acctID)


/*


SELECT C.BSAcctID, C.AccountNumber, CP.acctID PlanID, CP.SingleSaleTranID, C.RMATranUUID, CPC.PaidOutDate, Currentbalance+CurrentbalanceCO Currentbalance
FROM CPSgmentAccounts CP WITH (NOLOCK)
JOIN CCArd_Primary C WITH (NOLOCK) ON (CP.SingleSaleTranID = C.TranID)
JOIN CPSgmentCreditcard CPC WITH (NOLOCK) ON (CP.acctID = CPC.acctID)
WHERE C.CMTTRanType = '48'
AND C.MergeActivityFlag IS NULL 

*/
