/*
1. Created by Tlim on 08/15/2023 for Plat-130827.
*/

DECLARE @BusinessDay DATETIME 
SET @BusinessDay = '2023-08-16 23:59:57.000'

DROP TABLE

IF EXISTS #Temp_RawCBA_NewValue;
	WITH RawCBA_NewValue
	AS (
		SELECT row_number() OVER (PARTITION BY AID ORDER BY IdentityField DESC) AS RecordCount
			,IdentityField	--,tid	
			,businessday	,atid	,aid	,dename	,oldvalue	,newvalue	--,RowCreatedDate

		FROM CurrentBalanceaudit C WITH (NOLOCK)
		WHERE dename IN (114)
		AND atid = 51
		AND C.IdentityField > 0
		AND C.BusinessDay <= @BusinessDay
		)
	SELECT IdentityField,	--,tid	
	businessday	,atid	,aid	,dename	,oldvalue	,newvalue	--,RowCreatedDate
	INTO #Temp_RawCBA_NewValue
	FROM RawCBA_NewValue
	WHERE RecordCount = 1
		--AND NewValue='16040'

--		select * from #Temp_RawCBA_NewValue where AID IN (16585, 419228, 1049429)

--		select * from CurrentBalanceAudit with (nolock)
--	where AID IN (16585, 419228, 1049429)
--	and dename = '114'
----and DATEDIFF(MONTH, BusinessDay, '2023-08-31 23:59:57.000')=0
--order by AID, IdentityField

DROP TABLE

IF EXISTS #Temp_AI_ManualStatus
	CREATE TABLE #Temp_AI_ManualStatus (
		acctid INT
		,accountnumber VARCHAR(20)
		,InstitutionID INT
		,ProductID INT
		,BusinessDay DATETIME
		,EODStatus INT
		)

INSERT INTO #Temp_AI_ManualStatus
SELECT b.bsacctid
	,b.accountnumber
	,b.InstitutionID
	,b.ProductID
	,B.BusinessDay
	,B.ccinhparent125AID AS EODStatus
FROM Bsegment_primary BP WITH (INDEX (csPk_BSegment_Primary) NOLOCK)
JOIN AccountInfoForReport B WITH (NOLOCK) ON B.BSAcctID = BP.AcctID
WHERE B.BusinessDay = @BusinessDay	-- '2023-08-14 23:59:57.000'	

DROP TABLE IF EXISTS #TempData
select T.Acctid
	,T.accountnumber
	,T.InstitutionID
	,T.ProductID
	,T.BusinessDay EODBusinessDay
	,T.EODStatus
	,C.LutDescription EODDesc
	,N.NewValue CBAStatus
	,C1.LutDescription CBADesc
	,N.BusinessDay CBABusinessDay
	,N.IdentityField
INTO #TempData
	from #Temp_RawCBA_NewValue N 
join #Temp_AI_ManualStatus T ON N.AID = T.AcctID 
JOIN Ccardlookup C WITH (NOLOCK) ON T.EODStatus = C.Lutcode
	AND C.Lutid = 'Asstplan'
	AND lutlanguage = 'dbb'
	AND module = 'BC'
JOIN Ccardlookup C1 WITH (NOLOCK) ON N.NewValue = C1.Lutcode
	AND C1.Lutid = 'Asstplan'
	AND c1.lutlanguage = 'dbb'
	AND c1.module = 'BC'
--WHERE LTRIM(RTRIM(C1.LutDescription)) <> LTRIM(RTRIM(C.LutDescription))
WHERE T.EODStatus <> N.NewValue
--AND EODStatus = 16

--select COUNT(AcctID) TotalMismatch
--	from #Temp_RawCBA_NewValue N 
--join #Temp_AI_ManualStatus T ON N.AID = T.AcctID 
--JOIN Ccardlookup C WITH (NOLOCK) ON T.EODStatus = C.Lutcode
--	AND C.Lutid = 'Asstplan'
--	AND lutlanguage = 'dbb'
--	AND module = 'BC'
--JOIN Ccardlookup C1 WITH (NOLOCK) ON N.NewValue = C1.Lutcode
--	AND C1.Lutid = 'Asstplan'
--	AND c1.lutlanguage = 'dbb'
--	AND c1.module = 'BC'
----WHERE LTRIM(RTRIM(C1.LutDescription)) <> LTRIM(RTRIM(C.LutDescription))
--WHERE T.EODStatus <> N.NewValue


--select T.EODStatus
--	,C.LutDescription EODDesc
--	,N.NewValue CBAStatus
--	,C1.LutDescription CBADesc
--	,COUNT(AcctID) Count
--	from #Temp_RawCBA_NewValue N 
--join #Temp_AI_ManualStatus T ON N.AID = T.AcctID 
--JOIN Ccardlookup C WITH (NOLOCK) ON T.EODStatus = C.Lutcode
--	AND C.Lutid = 'Asstplan'
--	AND lutlanguage = 'dbb'
--	AND module = 'BC'
--JOIN Ccardlookup C1 WITH (NOLOCK) ON N.NewValue = C1.Lutcode
--	AND C1.Lutid = 'Asstplan'
--	AND c1.lutlanguage = 'dbb'
--	AND c1.module = 'BC'
----WHERE LTRIM(RTRIM(C1.LutDescription)) <> LTRIM(RTRIM(C.LutDescription))
--WHERE T.EODStatus <> N.NewValue
--GROUP BY T.EODStatus
--	,C.LutDescription
--	,N.NewValue
--	,C1.LutDescription
--ORDER BY T.EODStatus

--select * from #Temp_AI_ManualStatus
--where AcctID=1049429

--select * from #Temp_AI_ManualStatus
--where EODStatus=16

--select * from #Temp_RawCBA_NewValue
--where NewValue<>'16040'


--SELECT COUNT(1) FROM #TempData

DROP TABLE IF EXISTS ##TempCBA
SELECT ROW_NUMBER() OVER(ORDER BY IdentityField, EODBusinessDay) Skey,*, 0 JobStatus
INTO ##TempCBA 
FROM #TempData WHERE EODStatus <> 16