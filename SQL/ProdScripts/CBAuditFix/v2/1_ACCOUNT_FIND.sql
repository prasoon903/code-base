DROP TABLE IF EXISTS #LastManualStatus
;WITH CTE
AS
(
SELECT *, ROW_NUMBER() OVER (PARTITION BY AID ORDER BY IdentityField DESC) StatusCount
FROM CurrentBalanceAudit WITH (NOLOCK)
WHERE dename = 114
)
SELECT AID, BusinessDay, IdentityField, TRY_CAST(OldValue AS INT) OldValue, TRY_CAST(NewValue AS INT) NewValue
INTO #LastManualStatus
FROM CTE
WHERE StatusCount = 1

DROP TABLE IF EXISTS #StatusMismatch
SELECT T.*, BP.ccinhparent125AID ManualStatusAccount
INTO #StatusMismatch
FROM BSegment_Primary BP WITH (NOLOCK)
JOIN #LastManualStatus T ON (BP.acctID  = T.AID)
WHERE T.NewValue <> BP.ccinhparent125AID

SELECT * FROM #StatusMismatch ORDER BY BusinessDay DESC

SELECT NewValue, ManualStatusAccount, COUNT(1) [Count] FROM #StatusMismatch GROUP BY NewValue, ManualStatusAccount

--CASE 1: Entry is not present in CBA -- Make insert (Need to check with JPJain sir)
--CASE 2: Latest entry is MLA on CBA and Active on account -- 


SELECT * FROM #StatusMismatch WHERE AID = 1048372
SELECT ccinhparent125AID, AccountNumber, CurrentBalance, DateAcctClosed,* FROM BSegment_Primary BP WITH (NOLOCK) WHERE acctId = 1048372
--SELECT ccinhparent125AID, AccountNumber,tpyBlob,* FROM LS_P1MARProddb01.CCGS_CoreIssue.DBO.BSegment_Primary BP WITH (NOLOCK) WHERE acctId = 1048372

SELECT * FROM CurrentBalanceAudit WITH (NOLOCK) WHERE AID = 1048372 AND DENAME = 114 ORDER BY  IdentityField DESC


SELECT * FROM CurrentBalanceAudit WITH (NOLOCK) WHERE AID = 1048372 AND DENAME = 114 ORDER BY IdentityField DESC

SELECT * FROM LS_P1MARProddb01.CCGS_CoreIssue.DBO.CurrentBalanceAudit WITH (NOLOCK) WHERE AID = 18433002 AND DENAME = 114 ORDER BY BusinessDay DESC, IdentityField DESC

SELECT FeesAcctID, CPMGroup, HostMachineName,*
FROM CCard_Primary WITH (NOLOCK)
WHERE AccountNumber = '1100011128528241'
--AND CMTTranType = '*SCR'
ORDER BY PostTime DESC