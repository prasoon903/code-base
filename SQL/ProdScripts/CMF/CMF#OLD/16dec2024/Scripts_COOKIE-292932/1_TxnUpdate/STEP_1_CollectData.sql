
DROP TABLE IF EXISTS #CorrectedPlans
SELECT B.acctID, B.AccountNumber, C.SingleSaleTranID, T.* 
INTO #CorrectedPlans
FROM TEMP_PlanToChangeCPM T
JOIN CPSgmentAccounts C WITH (NOLOCK) ON (T.PlanID = C.acctID)
JOIN BSegment_Primary B WITH (NOLOCK) ON (B.acctId = C.parent02AID)


DROP TABLE IF EXISTS #AllPurchases
SELECT C.*, CP.TxnAcctID, CP.TransactionAmount, CP.CreditPlanMaster, CP.RMATranUUID, CP.ClaimID
INTO #AllPurchases
FROM CCArd_Primary Cp WITH (NOLOCK)
JOIN #CorrectedPlans C ON (CP.AccountNumber = C.AccountNumber AND CP.TranID = C.SingleSaleTranID)


DROP TABLE IF EXISTS TEMP_IncorrectCPMCorrection
SELECT ROW_NUMBER() OVER(PARTITION BY Cp.AccountNumber, Cp.TranId ORDER BY CP.PostTime) SN, C.acctID, CP.AccountNumber, CP.TranID, CP.CMTTRANTYPE, CP.TxnAcctID, 
CP.TransactionAmount, CP.CreditPlanMaster, CP.RMATranUUID, CP.ClaimID, C.PlanID, 
C.ExistingCPM, C.NewCPM, 0 JobStatus
INTO TEMP_IncorrectCPMCorrection
FROM CCArd_Primary Cp WITH (NOLOCK)
JOIN #AllPurchases C ON (CP.AccountNumber = C.AccountNumber AND CP.TxnAcctID = C.PlanID)


--SELECT * FROM #AllPurchases
--SELECT * FROM #AllTxns

--SELECT * FROM TEMP_IncorrectCPMCorrection

