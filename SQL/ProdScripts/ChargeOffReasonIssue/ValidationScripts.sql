
SELECT TOP 10 * FROM SPExecutionLog WITH (NOLOCK) ORDER BY BusinessDay DESC

DROP TABLE IF EXISTS #ChargeOffAccounts
SELECT BSAcctID, AccountNumber, CycleDueDTD, SystemStatus, ccinhparent125AID, AutoInitialChargeOffReason, 
ManualInitialChargeOffReason, ChargeOffDate, SystemChargeOffStatus, UserChargeOffStatus
INTO #ChargeOffAccounts
FROM AccountInfoForReport WITH (NOLOCK)
WHERE BusinessDay = '2024-01-31 23:59:57'
AND SystemStatus = 14

SELECT AutoInitialChargeOffReason, ManualInitialChargeOffReason, COUNT(1)
FROM #ChargeOffAccounts
GROUP BY AutoInitialChargeOffReason, ManualInitialChargeOffReason

DROP TABLE IF EXISTS #ManualChargeOff
SELECT *, DATEADD(SS, 86397, TRY_CAST(TRY_CAST(ChargeOffDate AS DATE) AS DATETIME)) NextBusinessDay
INTO #ManualChargeOff
FROM #ChargeOffAccounts
WHERE ManualInitialChargeOffReason IS NOT NULL AND ManualInitialChargeOffReason <> '0'

DROP TABLE IF EXISTS #IssueAccounts_WithStatus
SELECT T.*, A.ccinhparent125AID StatusAtCO, A.ManualInitialChargeOffReason ReasonAtCO, A.CycleDueDTD CycleDueDTDAtCO
INTO #IssueAccounts_WithStatus
FROM #ManualChargeOff T
LEFT JOIN AccountInfoForReport A WITH (NOLOCK) ON (T.NextBusinessDay = A.BusinessDay AND T.BSAcctID = A.BSAcctId)

UPDATE T
SET StatusAtCO = A.ccinhparent125AID, ReasonAtCO = A.ManualInitialChargeOffReason, CycleDueDTDAtCO = A.CycleDueDTD
FROM #IssueAccounts_WithStatus T
JOIN AccountInfoForReport_NCPartitioned A WITH (NOLOCK) ON (T.NextBusinessDay = A.BusinessDay AND T.BSAcctID = A.BSAcctId)
WHERE StatusAtCO IS NULL

UPDATE T
SET StatusAtCO = A.ccinhparent125AID, ReasonAtCO = A.ManualInitialChargeOffReason, CycleDueDTDAtCO = A.CycleDueDTD
FROM #IssueAccounts_WithStatus T
JOIN AccountInfoForReport_SwitchOut A WITH (NOLOCK) ON (T.NextBusinessDay = A.BusinessDay AND T.BSAcctID = A.BSAcctId)
WHERE StatusAtCO IS NULL

DROP TABLE IF EXISTS #IssueAccounts
SELECT M.*, S.COReasonCode, S.parent01AID, S.StatusDescription
INTO #IssueAccounts
FROM #IssueAccounts_WithStatus M
LEFT JOIN AstatusAccounts S WITH (NOLOCK) ON (M.StatusAtCO = S.parent01AID AND MerchantAID = 14992)
WHERE COReasonCode <> ReasonAtCO OR COReasonCode IS NULL

--SELECT ManualInitialChargeOffReason, COUNT(1)
--FROM #ManualChargeOff
--GROUP BY ManualInitialChargeOffReason  

--SELECT COReasonCode, parent01AID, StatusDescription INTO #Status FROM AstatusAccounts WITH (NOLOCK) WHERE COReasonCode IS NOT NULL AND MerchantAID = 14992

--SELECT COReasonCode, parent01AID, StatusDescription FROM AstatusAccounts WITH (NOLOCK) WHERE parent01AID = 16008 AND MerchantAID = 14992

--SELECT * FROM #ManualChargeOff WHERE AccountNumber = '1100011104940212'

--SELECT * FROM #Status

--DROP TABLE IF EXISTS #IssueAccounts
--SELECT M.*, DATEADD(SS, 86397, TRY_CAST(TRY_CAST(ChargeOffDate AS DATE) AS DATETIME)) NextBusinessDay, S.COReasonCode, S.parent01AID, S.StatusDescription
--INTO #IssueAccounts
--FROM #ManualChargeOff M
--LEFT JOIN AstatusAccounts S WITH (NOLOCK) ON (M.ccinhparent125AID = S.parent01AID AND MerchantAID = 14992)
--WHERE COReasonCode <> ManualInitialChargeOffReason OR COReasonCode IS NULL

SELECT * FROM #IssueAccounts WHERE CycleDueDTDAtCO < 7
AND AccountNumber = '1100011125635940' 
ORDER BY ChargeOffdate DESC

SELECT * FROM #IssueAccounts WHERE BSAcctID = 446036

SELECT * 
FROM #ManualChargeOff M
LEFT JOIN #Status S ON (M.ccinhparent125AID = S.parent01AID)
WHERE COReasonCode <> ManualInitialChargeOffReason OR COReasonCode IS NULL
--AND AccountNumber = '1100011113092856'

SELECT * FROM CurrentBalanceAudit WITH (NOLOCK) WHERE AID = 1312882 AND DENAME = 114 ORDER BY IdentityField DESC

SELECT * FROM AttributeUpdateLog WITH (NOLOCK) WHERE AccountNumber = '1100011113092856'

SELECT * FROM Customer WITH (NOLOCK) WHERE BSAcctID = 1312882

SELECT TransactionDescription,*
FROM CCard_Primary WITH (NOLOCK)
WHERE AccountNumber = '1100011113092856'
AND CMTTranType = '51'
ORDER BY PostTime DESC


SELECT FeesAcctId, CPMGroup, TransactionDescription, TransactionIdentifier,*
FROM CCard_Primary WITH (NOLOCK)
WHERE AccountNumber = '1100011125635940'
AND CMTTranType IN ('*SCR', '51', '52', 'RCLS')
ORDER BY PostTime DESC

SELECT ManualInitialChargeOffReason, ccinhparent125AID, SystemStatus, ChargeOffDate, CycleDueDTD, ChargeOffDateparam, * 
FROM AccountInfoForReport WITH (NOLOCK) WHERE BSacctID = 17527073 AND BusinessDay = '2023-09-30 23:59:57.000' ORDER BY BusinessDay DESC

SELECT * FROM sys.tables WHERE Name LIKE '%AccountInfoForReport%'

--AccountInfoForReport_SwitchOut
--AccountInfoForReport_NCPartitioned

--COReasonCode	parent01AID	StatusDescription
--2	5202	Bankruptcy with Payments                          
--6	5211	Deceased                                          
--2	16010	Bankruptcy No Payments                            
--3	16022	ID-Theft Fraud                                    
--3	16030	Closed by Partner Fraud                           

--1100011104940212

--DROP TABLE IF EXISTS #IssueAccounts_WithStatus
--SELECT T.*, A.ccinhparent125AID StatusAtCO
--INTO #IssueAccounts_WithStatus
--FROM #IssueAccounts T
--LEFT JOIN AccountInfoForReport A WITH (NOLOCK) ON (T.NextBusinessDay = A.BusinessDay AND T.BSAcctID = A.BSAcctId)

--UPDATE T
--SET StatusAtCO = A.ccinhparent125AID
--FROM #IssueAccounts_WithStatus T
--JOIN AccountInfoForReport_NCPartitioned A WITH (NOLOCK) ON (T.NextBusinessDay = A.BusinessDay AND T.BSAcctID = A.BSAcctId)
--WHERE StatusAtCO IS NULL

--UPDATE T
--SET StatusAtCO = A.ccinhparent125AID
--FROM #IssueAccounts_WithStatus T
--JOIN AccountInfoForReport_SwitchOut A WITH (NOLOCK) ON (T.NextBusinessDay = A.BusinessDay AND T.BSAcctID = A.BSAcctId)
--WHERE StatusAtCO IS NULL

SELECT * FROM #IssueAccounts_WithStatus WHERE StatusAtCO IS NOT NULL

SELECT ManualInitialChargeOffReason, ccinhparent125AID, SystemStatus, ChargeOffDate, * 
FROM AccountInfoForReport WITH (NOLOCK) WHERE BSacctID = 1051089 AND BusinessDay = '2022-10-31 23:59:57.000' --ORDER BY BusinessDay DESC

SELECT ManualInitialChargeOffReason, ccinhparent125AID, SystemStatus, ChargeOffDate, * 
FROM AccountInfoForReport_NCPartitioned WITH (NOLOCK) WHERE BSacctID = 1051089 AND BusinessDay = '2022-10-31 23:59:57.000' --ORDER BY BusinessDay DESC

SELECT ManualInitialChargeOffReason, ccinhparent125AID, SystemStatus, ChargeOffDate, * 
FROM AccountInfoForReport_SwitchOut WITH (NOLOCK) WHERE BSacctID = 1051089 AND BusinessDay = '2022-10-31 23:59:57.000'-- ORDER BY BusinessDay DESC