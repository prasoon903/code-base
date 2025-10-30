-- 1st remediation is done for 1/31/2022 cycle. Upto this all accounts are fixed.

DROP TABLE IF EXISTS #Temp1
SELECT acctId, StatementDate, SRBWithInstallmentDue, CurrentBalance + CurrentBalanceCO CBCO, SystemStatus, CycleDueDTD, DisputesAmtNS 
INTO #Temp1 
FROM StatementHeader WITH(NOLOCK) 
WHERE SRBWithInstallmentDue > CurrentBalance + CurrentBalanceCO AND SRBWithInstallmentDue > 0
AND SystemStatus <> 14 
AND CurrentBalance + CurrentBalanceCO <=  0 
AND CycleDueDTD > 1 
AND StatementDate >= '2022-04-30 23:59:57'
ORDER BY StatementDate DESC

--SELECT * FROM #Temp1 ORDER BY statementdate

DROP TABLE IF EXISTS #StatementHistory
;WITH StatementDetails
AS
(
	SELECT acctId, StatementDate, ROW_NUMBER() OVER (PARTITION BY acctId ORDER BY StatementDate) [Row] FROM #Temp1
)
SELECT 
ST.acctId, RTRIM(ST.AccountNumber) AccountNumber, ST.CurrentBalance, ST.SRBWithInstallmentDue, T1.StatementDate IssueFrom, ST.StatementDate,
ST.AmountOfTotalDue, ST.AmtOfPayCurrDue CurrentDue, ST.AmtOfPayXDLate PastDue, ST.AmountOfPayment30DLate AS '1CPD', ST.AmountOfPayment60DLate '2CPD', ST.AmountOfPayment90DLate '3CPD', 
ST.AmountOfPayment120DLate '4CPD', ST.AmountOfPayment150DLate '5CPD', ST.AmountOfPayment180DLate '6CPD', ST.CycleDueDTD,
CASE 
	WHEN ST.CycleDueDTD = 0 THEN 'Nothing Due'
	WHEN ST.CycleDueDTD = 1 THEN 'Current Due'
	WHEN ST.CycleDueDTD = 2 THEN 'Past Due'
	WHEN ST.CycleDueDTD = 3 THEN '1 Cycle Past Due'
	WHEN ST.CycleDueDTD = 4 THEN '2 Cycle Past Due'
	WHEN ST.CycleDueDTD = 5 THEN '3 Cycle Past Due'
	WHEN ST.CycleDueDTD = 6 THEN '4 Cycle Past Due'
	WHEN ST.CycleDueDTD = 7 THEN '5 Cycle Past Due'
	ELSE 'NA'
END Delinquency
, CASE 
	WHEN ST.SystemStatus = 2 THEN 'Active'
	WHEN ST.SystemStatus = 3 THEN 'Delinquent'
	WHEN ST.SystemStatus = 4 THEN 'Overlimit'
	WHEN ST.SystemStatus = 15991 THEN 'Delinquent_NoAuth'
	WHEN ST.SystemStatus = 14 THEN 'Charge-Off'
	ELSE 'NA'
END SystemStatusAtStmt
, CASE WHEN ST.CycleDueDTD >= 3 THEN 'YES'	ELSE 'NO' END CBRImpact
INTO #StatementHistory
FROM StatementHeader ST WITH (NOLOCK)
JOIN StatementDetails T1 ON (ST.acctId = T1.acctId)
WHERE [Row] = 1
AND ST.StatementDate >= T1.StatementDate


--SELECT * FROM #StatementHistory ORDER BY AccountNumber

--SELECT * FROM #StatementHistory WHERE acctID = 4902639

--SELECT * FROM #StatementHistory WHERE SystemStatusAtStmt = 'Charge-off'


DROP TABLE IF EXISTS #AccountDetails
;WITH AccountDetails
AS
(
	SELECT acctId, ROW_NUMBER() OVER (PARTITION BY acctId ORDER BY StatementDate) [Row] FROM #Temp1
)
SELECT 
A.acctId, RTRIM(BP.AccountNumber) AccountNumber, BP.UniversalUniqueID AccountUUID, BP.CurrentBalance, BCC.SRBWithInstallmentDue MSBAtPresent, BS.DisputesAmtNS DisputeAmtAtPresent, BP.CycleDueDTD,
BCC.AmountOfTotalDue, BP.AmtOfPayCurrDue CurrentDue, BCC.AmtOfPayXDLate PastDue, BCC.AmountOfPayment30DLate AS '1CPD', BCC.AmountOfPayment60DLate '2CPD', BCC.AmountOfPayment90DLate '3CPD', 
BCC.AmountOfPayment120DLate '4CPD', BCC.AmountOfPayment150DLate '5CPD', BCC.AmountOfPayment180DLate '6CPD',
CASE 
	WHEN BP.CycleDueDTD = 0 THEN 'Nothing Due'
	WHEN BP.CycleDueDTD = 1 THEN 'Current Due'
	WHEN BP.CycleDueDTD = 2 THEN 'Past Due'
	WHEN BP.CycleDueDTD = 3 THEN '1 Cycle Past Due'
	WHEN BP.CycleDueDTD = 4 THEN '2 Cycle Past Due'
	WHEN BP.CycleDueDTD = 5 THEN '3 Cycle Past Due'
	WHEN BP.CycleDueDTD = 6 THEN '4 Cycle Past Due'
	WHEN BP.CycleDueDTD = 7 THEN '5 Cycle Past Due'
	ELSE 'NA'
END DelinquencyAtPresent
, CASE 
	WHEN BP.SystemStatus = 2 THEN 'Active'
	WHEN BP.SystemStatus = 3 THEN 'Delinquent'
	WHEN BP.SystemStatus = 4 THEN 'Overlimit'
	WHEN BP.SystemStatus = 15991 THEN 'Delinquent_NoAuth'
	WHEN BP.SystemStatus = 14 THEN 'Charge-Off'
	ELSE 'NA'
END SystemStatusAtPresent
INTO #AccountDetails
FROM AccountDetails  A
JOIN BSegment_Primary BP WITH (NOLOCK) ON (A.acctId = BP.acctId)
JOIN BSegmentCreditCard BCC WITH (NOLOCK) ON (BCC.acctId = BP.acctId)
JOIN BSegment_Secondary BS WITH (NOLOCK) ON (BCC.acctId = BS.acctId)
WHERE [Row] = 1
ORDER BY A.acctId

--SELECT * FROM #AccountDetails ORDER BY AccountNumber



----PIVOT


--SELECT AccountNumber,CurrentBalance,SRBWithInstallmentDue,IssueFrom,StatementDate,AmountOfTotalDue,CycleDueDTD,
--CurrentDue,PastDue,[1CPD],[2CPD],[3CPD],[4CPD],[5CPD],[6CPD],Delinquency,SystemStatusAtStmt,CBRImpact 
--FROM #StatementHistory 
----WHERE AccountNumber = '1100011107584165'
--ORDER BY AccountNumber



DROP TABLE IF EXISTS #DQHistory
SELECT AccountNumber,
--[2021-02-28 23:59:57],
--[2021-03-31 23:59:57],
--[2021-04-30 23:59:57],
--[2021-05-31 23:59:57],
--[2021-06-30 23:59:57],
--[2021-07-31 23:59:57],
--[2021-08-31 23:59:57],
--[2021-09-30 23:59:57],
--[2021-10-31 23:59:57],
--[2021-11-30 23:59:57],
--[2021-12-31 23:59:57],
[2022-01-31 23:59:57],
[2022-02-28 23:59:57],
[2022-03-31 23:59:57],
[2022-04-30 23:59:57]
INTO #DQHistory/*,
CurrentDue,PastDue,[1CPD],[2CPD],[3CPD],[4CPD],[5CPD],[6CPD]*/ FROM
(SELECT StatementDate, AccountNumber,Delinquency/*,PastDue,[1CPD],[2CPD],[3CPD],[4CPD],[5CPD],[6CPD]*/
FROM #StatementHistory) Tab1
PIVOT(
MAX(Delinquency)/*,SUM(PastDue),SUM([1CPD]),SUM([2CPD]),SUM([3CPD]),SUM([4CPD]),SUM([5CPD]),SUM([6CPD])*/
FOR StatementDate IN (
--[2021-02-28 23:59:57],
--[2021-03-31 23:59:57],
--[2021-04-30 23:59:57],
--[2021-05-31 23:59:57],
--[2021-06-30 23:59:57],
--[2021-07-31 23:59:57],
--[2021-08-31 23:59:57],
--[2021-09-30 23:59:57],
--[2021-10-31 23:59:57],
--[2021-11-30 23:59:57],
--[2021-12-31 23:59:57],
[2022-01-31 23:59:57],
[2022-02-28 23:59:57],
[2022-03-31 23:59:57],
[2022-04-30 23:59:57])) AS Tab2
ORDER BY Tab2.AccountNumber
--FROM #StatementHistory 

--SELECT * FROM #DQHistory WHERE AccountNumber = '1100011110842667'

--SELECT * FROM #StatementHistory WHERE AccountNumber = '1100011110842667'

--CREATE TABLE #CTDMapping(CTD INT, CTDName VARCHAR(50))
--INSERT INTO #CTDMapping VALUES 
--(0, 'Nothing Due'),
--(1, 'Current Due'),
--(2, 'Past Due'),
--(3, '1 Cycle Past Due'),
--(4, '2 Cycle Past Due'),
--(5, '3 Cycle Past Due'),
--(6, '4 Cycle Past Due'),
--(7, '5 Cycle Past Due'),
--(8, '6 Cycle Past Due'),
--(9, '7 Cycle Past Due')

--SELECT * FROM #CTDMapping

/*

--Account_CurrentState
SELECT A.AccountNumber,AccountUUID, CurrentBalance,MSBAtPresent,DisputeAmtAtPresent,DelinquencyAtPresent,
SystemStatusAtPresent,AmountOfTotalDue,CurrentDue,PastDue,[1CPD],[2CPD],[3CPD],[4CPD],[5CPD],[6CPD]
FROM #AccountDetails A
ORDER BY A.AccountNumber

--DQ_History
SELECT A.AccountNumber,AccountUUID,MSBAtPresent,DisputeAmtAtPresent,DelinquencyAtPresent, SystemStatusAtPresent, 
--[2021-02-28 23:59:57],
--[2021-03-31 23:59:57],
--[2021-04-30 23:59:57],
--[2021-05-31 23:59:57],
--[2021-06-30 23:59:57],
--[2021-07-31 23:59:57],
--[2021-08-31 23:59:57],
--[2021-09-30 23:59:57],
--[2021-10-31 23:59:57],
--[2021-11-30 23:59:57],
--[2021-12-31 23:59:57],
[2022-01-31 23:59:57],
[2022-02-28 23:59:57],
[2022-03-31 23:59:57],
[2022-04-30 23:59:57]
FROM #AccountDetails A
JOIN #DQHistory D ON (A.AccountNumber = D.AccountNumber)
ORDER BY A.AccountNumber

--PHPUpdate
;WITH CBRImpact
AS
(
	SELECT *, ROW_NUMBER() OVER (PARTITION BY AccountNumber ORDER BY StatementDate) [Rank]
	FROM #StatementHistory 
	WHERE CBRImpact = 'YES'
	--ORDER BY AccountNumber
)
SELECT A.AccountNumber,AccountUUID,MSBAtPresent,DisputeAmtAtPresent, DelinquencyAtPresent, SystemStatusAtPresent, C.IssueFrom,
--[2021-02-28 23:59:57],
--[2021-03-31 23:59:57],
--[2021-04-30 23:59:57],
--[2021-05-31 23:59:57],
--[2021-06-30 23:59:57],
--[2021-07-31 23:59:57],
--[2021-08-31 23:59:57],
--[2021-09-30 23:59:57],
--[2021-10-31 23:59:57],
--[2021-11-30 23:59:57],
--[2021-12-31 23:59:57],
[2022-01-31 23:59:57],
[2022-02-28 23:59:57],
[2022-03-31 23:59:57],
[2022-04-30 23:59:57]
FROM #AccountDetails A
JOIN #DQHistory D ON (A.AccountNumber = D.AccountNumber)
JOIN CBRImpact C ON (C.AccountNumber = D.AccountNumber)
WHERE C.[Rank] = 1
ORDER BY A.AccountNumber


--AccountDetailsByCycle
SELECT S.AccountNumber, A.AccountUUID,S.CurrentBalance,S.SRBWithInstallmentDue,S.IssueFrom,S.StatementDate,S.AmountOfTotalDue,
S.CurrentDue,S.PastDue,S.[1CPD],S.[2CPD],S.[3CPD],S.[4CPD],S.[5CPD],S.[6CPD],S.Delinquency,S.SystemStatusAtStmt,S.CBRImpact
FROM #StatementHistory S
JOIN #AccountDetails A ON (S.AccountNumber = A.AccountNumber)
ORDER BY S.AccountNumber, S.StatementDate


--AccountToReage
SELECT A.AccountNumber,AccountUUID, CurrentBalance,MSBAtPresent,DisputeAmtAtPresent,DelinquencyAtPresent,
SystemStatusAtPresent,AmountOfTotalDue,CurrentDue,PastDue,[1CPD],[2CPD],[3CPD],[4CPD],[5CPD],[6CPD]
FROM #AccountDetails A
WHERE CycleDueDTD >= 2
ORDER BY A.AccountNumber


-------- DATA FIXES ------

;WITH StatementRecords
AS
(
	SELECT SH.*, ROW_NUMBER() OVER (PARTITION BY SH.AccountNumber ORDER BY SH.StatementDate) [Rank],
	DATEDIFF(MM,SH.StatementDate,GETDATE()) - 1 CtrToUpdate
	FROM #StatementHistory SH
	WHERE CBRImpact = 'YES' 
	--AND SystemStatusAtStmt <> 'Charge-Off'
	--ORDER BY AccountNumber
)
, CBRImpacted
AS
(
	SELECT * 
	--INTO #TempCTE
	FROM StatementRecords 
	WHERE [Rank] = 1
	--WHERE CtrToUpdate <> 0
)
, PHP
AS
(
	SELECT S.*, DATEDIFF(MM,S.StatementDate,GETDATE()) - 1 CtrToUpdate
	FROM #StatementHistory S
	--WHERE acctId IN (SELECT acctId FROM CBRImpacted)
	JOIN CBRImpacted C ON (S.acctId = C.acctId)
	--ORDER BY S.acctId
)
SELECT 
CASE WHEN CtrToUpdate < 10 THEN 'UPDATE TOP(1) BSegment_Balances SET ReportHistoryCtrCC0' + TRY_CAST(CtrToUpdate AS VARCHAR) + ' = 0 WHERE acctId = ' + TRY_CAST(acctId AS VARCHAR)
WHEN CtrToUpdate >= 10 AND CtrToUpdate <= 24 THEN 'UPDATE TOP(1) BSegment_Balances SET ReportHistoryCtrCC' + TRY_CAST(CtrToUpdate AS VARCHAR) + ' = 0 WHERE acctId = ' + TRY_CAST(acctId AS VARCHAR)
ELSE NULL
END AS PHPUpdate,
* 
FROM PHP 
WHERE CtrToUpdate <> 0
AND SystemStatusAtStmt <> 'Charge-Off'


SELECT 0 TypeOfManualReage, A.AccountNumber,'' TotalDueMethod
FROM #AccountDetails A
WHERE CycleDueDTD >= 2
AND SystemStatusAtPresent <> 'Charge-Off'
ORDER BY A.AccountNumber

SELECT 
ReportHistoryCtrCC01,
ReportHistoryCtrCC02,
ReportHistoryCtrCC03,
ReportHistoryCtrCC04,
ReportHistoryCtrCC05,
ReportHistoryCtrCC06,
ReportHistoryCtrCC07,
ReportHistoryCtrCC08,
ReportHistoryCtrCC09,
ReportHistoryCtrCC10,
ReportHistoryCtrCC11,
ReportHistoryCtrCC12,
ReportHistoryCtrCC13,
ReportHistoryCtrCC14,
ReportHistoryCtrCC15,
ReportHistoryCtrCC16,
ReportHistoryCtrCC17,
ReportHistoryCtrCC18,
ReportHistoryCtrCC19,
ReportHistoryCtrCC20,
ReportHistoryCtrCC21,
ReportHistoryCtrCC22,
ReportHistoryCtrCC23,
ReportHistoryCtrCC24 
FROM BSegment_balances WITH (NOLOCK)
WHERE acctId = 4902639

SELECT paymentHistProfile,* FROm CBReportingDetail WITh (NOLOCk) WHERE acctId = 4902639 ORDER By StatementDate DESC

SELECT  StatementDate,
ReportHistoryCtrCC01,
ReportHistoryCtrCC02,
ReportHistoryCtrCC03,
ReportHistoryCtrCC04,
ReportHistoryCtrCC05,
ReportHistoryCtrCC06,
ReportHistoryCtrCC07,
ReportHistoryCtrCC08,
ReportHistoryCtrCC09,
ReportHistoryCtrCC10,
ReportHistoryCtrCC11,
ReportHistoryCtrCC12,
ReportHistoryCtrCC13,
ReportHistoryCtrCC14,
ReportHistoryCtrCC15,
ReportHistoryCtrCC16,
ReportHistoryCtrCC17,
ReportHistoryCtrCC18,
ReportHistoryCtrCC19,
ReportHistoryCtrCC20,
ReportHistoryCtrCC21,
ReportHistoryCtrCC22,
ReportHistoryCtrCC23,
ReportHistoryCtrCC24
FROm CBRStatementDetails WITh (NOLOCk) 
WHERE acctId = 4902639 
AND StatementDate IN ('2022-02-28 23:59:57', '2022-03-31 23:59:57')
--ORDER By StatementDate DESC



*/