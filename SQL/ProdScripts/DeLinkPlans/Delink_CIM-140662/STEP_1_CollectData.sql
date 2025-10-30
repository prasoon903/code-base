
DROP TABLE IF EXISTS TempData_Delink_CIM_140662
SELECT AccountNumber, BP.acctID BSAcctID, BP.LastStatementDate, CP.acctID, CP.DisputesAmtNS, CP.CurrentBalance+CPC.CurrentbalanceCO CurrentBalance, CPC.PaidOutDate, BP.LastStatementDate
INTO TempData_Delink_CIM_140662
FROM CPSgmentAccounts CP with (NOLOCK)
JOIN CPSgmentCreditcard CPC WITH (NOLOCK) ON (CP.acctID = CPC.acctID)
JOIN BSegment_Primary BP WITH (NOLOCK) ON (BP.acctID = CP.Parent02AID)
WHERE CP.acctID IN (988423932)
 

 
DROP TABLE IF EXISTS TempXRef_Delink_CIM_140662
SELECT X.*
INTO TempXRef_Delink_CIM_140662
FROM XRefTable X WITH (NOLOCK)
JOIN TempData_DelinkDebitPlans T ON (X.ParentATID = 51 AND X.parentAID = T.BSAcctID AND ChildATID = 52 AND X.ChildAID = T.acctID)


/*


SELECT C.BSAcctID, C.AccountNumber, CP.acctID, CP.SingleSaleTranID, C.RMATranUUID
FROM CPSgmentAccounts CP WITH (NOLOCK)
JOIN CCArd_Primary C WITH (NOLOCK) ON (CP.SingleSaleTranID = C.TranID)
WHERE C.CMTTRanType = '48'
AND C.MergeActivityFlag IS NULL 

*/
