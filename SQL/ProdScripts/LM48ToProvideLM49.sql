DROP TABLE IF EXISTS #InstallmentsWithNoSchedules
;WITH CCARD
AS
(
SELECT AccountNumber, TranID, TxnAcctId, TransactionAmount, TransactionIdentifier, TranTime, PostTime
FROM CCard_Primary WITH (NOLOCK)
WHERE CMTTranType = '48'
--AND TxnSource = '29'
AND MergeActivityFlag IS NULL
),
CPS AS
(
SELECT C.*, CP.parent02AID AccountID, CP.CurrentBalance, CP.Parent01AID CPMID, CPMDescription, CPC.PlanUUID, OriginalPurchaseAmount, InvoiceNumber
FROM CCArd C
JOIN CPSgmentAccounts CP WITH (NOLOCK) ON C.TxnAcctID = CP.acctID
JOIN CPSgmentCreditCard CPC WITH (NOLOCK) ON CP.acctID = CPC.acctId
LEFT JOIN CPMAccounts CPM WITH (NOLOCK) ON (CP.parent01AID = CPM.acctID)
WHERE CP.CreditPlanType = '16'
)
SELECT C.*
INTO #InstallmentsWithNoSchedules
FROM CPS C
LEFT JOIN ILPScheduleDetailSummary ILPS WITH (NOLOCK) ON (C.TxnAcctID = ILPS.PlanID AND ILPS.Activity = 1)
WHERE ILPS.PlanID IS NULL

--SELECT *
--FROM #InstallmentsWithNoSchedules

DROP TABLE IF EXISTS #LM49Details
SELECT I.*, CP.RMATranUUID,CP.TransactionAmount LM49_TxnAmount, CS.InvoiceNumber LM49_InvoiceNumber
INTO #LM49Details
FROM CCard_Primary CP WITH (NOLOCK)
LEFT JOIN CCard_Secondary CS WITH (NOLOCK) ON CP.TranID = CS.TranID
JOIN #InstallmentsWithNoSchedules I ON (I.AccountNumber = CP.AccountNumber AND CP.CMTTrantype = '49')

SELECT I.*  
FROM #LM49Details C 
RIGHT JOIN #InstallmentsWithNoSchedules I ON (C.AccountNumber = I.AccountNumber AND C.LM49_InvoiceNumber = I.InvoiceNumber)
WHERE C.AccountNumber IS NULL AND C.LM49_InvoiceNumber IS NULL

--SELECT * 
--FROM CCard_Primary CP WITH (NOLOCK)
--WHERE AccountNumber = ''



--SELECT * FROM ILPScheduleDetailSummary WITH (NOLOCK) WHERE PlanID = 10005245