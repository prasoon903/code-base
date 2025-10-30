select bsacctid,accountnumber,tranid,transactionamount,trantime,posttime,txnsource,transactiondescription,postingref, datediff(month,trantime,posttime) DIFFCycle
into #pmt
From ccard_primary cp with(nolock) 
join trans_in_acct tia on tia.tran_id_index = cp.tranid
where cmttrantype = '21' 
and posttime > '2021-12-31 23:59:57.000' 
--and posttime > '2022-12-31 23:59:57.000' 
and tia.atid = 51
and datediff(month,trantime,posttime) > 0 --47267

select revtgt 
into #rev
From ccard_primary with(nolock) where revtgt in (select tranid from #pmt)

delete from #pmt where tranid in (select revtgt from #rev)

select sum(transactionamount) amt,bsacctid, TRY_CAST(MONTH(trantime) AS VARCHAR)+'-'+TRY_CAST(YEAR(trantime) AS VARCHAR) mo
--,month(trantime) mo 
into #byMO 
from #pmt group by bsacctid,TRY_CAST(MONTH(trantime) AS VARCHAR)+'-'+TRY_CAST(YEAR(trantime) AS VARCHAR)

select * from #byMO--26641

update #pmt set transactionamount = amt from #pmt p join #byMO b on b.bsacctid = p.bsacctid and b.mo = TRY_CAST(MONTH(trantime) AS VARCHAR)+'-'+TRY_CAST(YEAR(trantime) AS VARCHAR)

select row_number() over (partition by bsacctid,TRY_CAST(MONTH(trantime) AS VARCHAR)+'-'+TRY_CAST(YEAR(trantime) AS VARCHAR) order by bsacctid,TRY_CAST(MONTH(trantime) AS VARCHAR)+'-'+TRY_CAST(YEAR(trantime) AS VARCHAR)) RN,* 
into #Pmt1
from #pmt

select * 
into #Pmtfinal
From #Pmt1 
where rn = 1


SELECT bsacctid, AccountNumber, MIN(TranTime) TranTime, MAX(PostTime) PostTime
--INTO #Pmtfinal1
FROM #Pmtfinal
GROUP BY bsacctid, AccountNumber

DROP TABLE IF EXISTS #stmt
selecT p.*,acctid,statementdate,chargeoffdate,cycleduedtd,ccinhparent125aid,systemstatus,currentbalance,amountoftotaldue,AmtOfPayCurrDue,AmtOfPayXDLate,AmountOfPayment30DLate,AmountOfPayment60DLate,
AmountOfPayment90DLate,AmountOfPayment120DLate,AmountOfPayment150DLate,AmountOfPayment180DLate,AmountOfPayment210DLate
intO #stmt
from STATEMentHEADER sh with(nolock) 
join #Pmtfinal p on p.bsacctid = sh.acctid
WHERE sh.statementdate > p.trantime

SELECT * FROM #stmt WHERE BSAcctID = 15934880 ORDER BY statementdate

DROP TABLE IF EXISTS #stmt30DPD
SELECT *
INTO #stmt30DPD 
FROM #stmt
WHERE BSAcctID IN (
SELECT BSAcctID FROM #stmt GROUP BY BSAcctID HAVING MAX(CycleDueDTD) > 2
)
AND statementdate < posttime order by acctid,statementdate

--DROP TABLE IF EXISTS #stmt30DPD
--select * 
--into #stmt30DPD 
--from #stmt 
----where cycleduedtd > 2 and 
--WHERE statementdate < posttime order by acctid,statementdate

DROP TABLE IF EXISTS #phpTID
select b.tranid,b.acctid
into #phpTID
from #stmt30dpd s join LS_P1MARPRODDB01.CCgs_corEisSUE.DBO.bscbrphphistory b with(nolock) on b.acctid = s.bsacctid

update #stmt30DPD set accountnumber = 'DD' where tranid in (select tranid from #phpTID)

DROP TABLE IF EXISTS #temp30dpd
select * into 
#temp30dpd 
from #stmt30DPD
WHERE accountnumber <> 'DD'

SELECT * FROM #temp30dpd WHERE BSAcctID = 17731939 ORDER BY statementdate

SELECT BSAcctID, AccountNumber, TranTime, StatementDate, TransactionAmount, CycleDueDTD, CurrentBalance, AmountOfTotalDue,
AmtOfPayCurrDue, AmtOfPayXDLate, AmountOfPayment30DLate, AmountOfPayment60DLate, AmountOfPayment90DLate, AmountOfPayment120DLate,
AmountOfPayment150DLate, AmountOfPayment180DLate, AmountOfPayment210DLate
FROM #temp30dpd 
WHERE BSAcctID = 15934880 ORDER BY statementdate


DECLARE @AmountOfTotalDue MONEY,@AmtOfPayCurrDue MONEY, @AmtOfPayXDLate MONEY, @AmountOfPayment30DLate MONEY, @AmountOfPayment60DLate MONEY, @AmountOfPayment90DLate MONEY, @AmountOfPayment120DLate MONEY,
@AmountOfPayment150DLate MONEY, @AmountOfPayment180DLate MONEY, @AmountOfPayment210DLate MONEY


SELECT BSAcctID, AccountNumber, TranTime, StatementDate, TransactionAmount, CycleDueDTD, CurrentBalance, AmountOfTotalDue, AmtOfPayCurrDue, AmtOfPayXDLate, 
CASE WHEN TransactionAmount-AmountOfTotalDue>0 THEN TransactionAmount-AmountOfTotalDue ELSE 0 END TxnAmt,
SUM(TransactionAmount-AmountOfTotalDue) OVER(PARTITION BY NULL ORDER BY StatementDate ROWS UNBOUNDED PRECEDING) TransactionAmount_Cumulative,
SUM(AmountOfTotalDue) OVER(PARTITION BY NULL ORDER BY StatementDate ROWS UNBOUNDED PRECEDING) AmountOfTotalDue_Cumulative,
SUM(AmtOfPayCurrDue) OVER(PARTITION BY NULL ORDER BY StatementDate ROWS UNBOUNDED PRECEDING) AmtOfPayCurrDue_Cumulative,
SUM(AmtOfPayXDLate) OVER(PARTITION BY NULL ORDER BY StatementDate ROWS UNBOUNDED PRECEDING) AmtOfPayXDLate_Cumulative
FROM #temp30dpd 
WHERE BSAcctID = 15934880 
ORDER BY statementdate




DROP TABLE IF EXISTS #Multi
SELECT BSAcctID, TranID, COUNT(1) MonthCount INTO #Multi FROM #temp30dpd GROUP BY BSAcctID, TranID HAVING COUNT(1) > 1

DROP TABLE IF EXISTS #TempCompute
SELECT *
INTO #TempCompute
FROM #temp30dpd
WHERE BSAcctID NOT IN (SELECT BSAcctID FROM #Multi)


DROP TABLE IF EXISTS #TempComputedData1Cycle
SELECT * ,
CASE	WHEN AmountOfPayment210DLate > TransactionAmount THEN 9
		WHEN AmountOfPayment210DLate+AmountOfPayment180DLate > TransactionAmount THEN 8
		WHEN AmountOfPayment210DLate+AmountOfPayment180DLate+AmountOfPayment150DLate > TransactionAmount THEN 7
		WHEN AmountOfPayment210DLate+AmountOfPayment180DLate+AmountOfPayment150DLate+AmountOfPayment120DLate > TransactionAmount THEN 6
		WHEN AmountOfPayment210DLate+AmountOfPayment180DLate+AmountOfPayment150DLate+AmountOfPayment120DLate+AmountOfPayment90DLate > TransactionAmount THEN 5
		WHEN AmountOfPayment210DLate+AmountOfPayment180DLate+AmountOfPayment150DLate+AmountOfPayment120DLate+AmountOfPayment90DLate+AmountOfPayment60DLate > TransactionAmount THEN 4
		WHEN AmountOfPayment210DLate+AmountOfPayment180DLate+AmountOfPayment150DLate+AmountOfPayment120DLate+AmountOfPayment90DLate+AmountOfPayment60DLate+AmountOfPayment30DLate > TransactionAmount THEN 3
		WHEN AmountOfPayment210DLate+AmountOfPayment180DLate+AmountOfPayment150DLate+AmountOfPayment120DLate+AmountOfPayment90DLate+AmountOfPayment60DLate+AmountOfPayment30DLate+AmtOfPayXDLate > TransactionAmount THEN 2
		WHEN AmountOfPayment210DLate+AmountOfPayment180DLate+AmountOfPayment150DLate+AmountOfPayment120DLate+AmountOfPayment90DLate+AmountOfPayment60DLate+AmountOfPayment30DLate+AmtOfPayXDLate+AmtOfPayCurrDue > TransactionAmount THEN 1
		ELSE 0
		END
		AS ComputedCycleDueDTD
INTO #TempComputedData1Cycle
FROM #TempCompute

SELECT * FROM #TempComputedData1Cycle 
WHERE CycleDueDTD > ComputedCycleDueDTD 
AND (ChargeOffDate >= TranTime OR ChargeOffDate IS NULL)
AND CycleDueDTD > 2


SELECT * FROM #Multi

DROP TABLE IF EXISTS #MultiCycle
SELECT T1.*, RANK() OVER(PARTITION BY T1.BSAcctID, T1.TranID ORDER BY T1.StatementDate) [Rank], TRY_CAST(0 AS INT) AdjustedCycle
INTO #MultiCycle
FROM #temp30dpd T1 
JOIN #Multi M ON (T1.BSAcctId = M.BSAcctID AND T1.TranID = M.TranID)


SELECT *
FROM #MultiCycle
WHERE [Rank] = 1


UPDATE M
SET AdjustedCycle = 
CycleDueDTD - 
CASE	WHEN AmountOfPayment210DLate > TransactionAmount THEN 9
		WHEN AmountOfPayment210DLate+AmountOfPayment180DLate > TransactionAmount THEN 8
		WHEN AmountOfPayment210DLate+AmountOfPayment180DLate+AmountOfPayment150DLate > TransactionAmount THEN 7
		WHEN AmountOfPayment210DLate+AmountOfPayment180DLate+AmountOfPayment150DLate+AmountOfPayment120DLate > TransactionAmount THEN 6
		WHEN AmountOfPayment210DLate+AmountOfPayment180DLate+AmountOfPayment150DLate+AmountOfPayment120DLate+AmountOfPayment90DLate > TransactionAmount THEN 5
		WHEN AmountOfPayment210DLate+AmountOfPayment180DLate+AmountOfPayment150DLate+AmountOfPayment120DLate+AmountOfPayment90DLate+AmountOfPayment60DLate > TransactionAmount THEN 4
		WHEN AmountOfPayment210DLate+AmountOfPayment180DLate+AmountOfPayment150DLate+AmountOfPayment120DLate+AmountOfPayment90DLate+AmountOfPayment60DLate+AmountOfPayment30DLate > TransactionAmount THEN 3
		WHEN AmountOfPayment210DLate+AmountOfPayment180DLate+AmountOfPayment150DLate+AmountOfPayment120DLate+AmountOfPayment90DLate+AmountOfPayment60DLate+AmountOfPayment30DLate+AmtOfPayXDLate > TransactionAmount THEN 2
		WHEN AmountOfPayment210DLate+AmountOfPayment180DLate+AmountOfPayment150DLate+AmountOfPayment120DLate+AmountOfPayment90DLate+AmountOfPayment60DLate+AmountOfPayment30DLate+AmtOfPayXDLate+AmtOfPayCurrDue > TransactionAmount THEN 1
		ELSE 0
		END
FROM #MultiCycle M
WHERE [Rank] = 1


SELECT M1.AdjustedCycle, M2.*
FROM #MultiCycle M1
JOIN #MultiCycle M2 ON (M1.BSAcctID = M2.BSAcctId AND M1.TranID = M2.TranID AND M1.[Rank] = 1 AND M2.[Rank] > 1)


UPDATE M2
SET M2.AdjustedCycle = M1.AdjustedCycle
FROM #MultiCycle M1
JOIN #MultiCycle M2 ON (M1.BSAcctID = M2.BSAcctId AND M1.TranID = M2.TranID AND M1.[Rank] = 1 AND M2.[Rank] > 1)

SELECT CASE WHEN CycleDueDTD-AdjustedCycle > 0 THEN CycleDueDTD-AdjustedCycle ELSE 0 END ComputedCycleDueDTD, CycleDueDTD, AdjustedCycle, * 
FROM #MultiCycle


DROP TABLE IF EXISTS #TempComputedDataMultiCycle
SELECT *, CASE WHEN CycleDueDTD-AdjustedCycle > 0 THEN CycleDueDTD-AdjustedCycle ELSE 0 END ComputedCycleDueDTD
INTO #TempComputedDataMultiCycle
FROM #MultiCycle

SELECT ComputedCycleDueDTD,* FROm #TempComputedDataMultiCycle


DROP TABLE IF EXISTS #TempComputedData1CycleCBRCorrected
SELECT CSH.CurrentBalance CSH_CB, CASE WHEN T1.CurrentBalance-CSH.CurrentBalance <=0 THEN 1 ELSE 0 END ReportingCorrected,T1.* 
INTO #TempComputedData1CycleCBRCorrected
FROM #TempComputedData1Cycle  T1
JOIN CurrentStatementHeader CSH WITH (NOLOCK) ON (T1.BSAcctID = CSH.acctId AND T1.STatementDate = CSH.STatementDate)
ORDER BY T1.BSacctId, T1.StatementDate


DROP TABLE IF EXISTS #TempComputedDataMultiCycleCBRCorrected
SELECT CSH.CurrentBalance CSH_CB, CASE WHEN T1.CurrentBalance-CSH.CurrentBalance <=0 THEN 1 ELSE 0 END ReportingCorrected,T1.* 
INTO #TempComputedDataMultiCycleCBRCorrected
FROM #TempComputedDataMultiCycle  T1
JOIN CurrentStatementHeader CSH WITH (NOLOCK) ON (T1.BSAcctID = CSH.acctId AND T1.STatementDate = CSH.STatementDate)
ORDER BY T1.BSacctId, T1.StatementDate



--ComputedCycleDueDTD

SELECT * FROM #TempComputedData1CycleCBRCorrected
WHERE CycleDueDTD > ComputedCycleDueDTD 
AND (ChargeOffDate >= TranTime OR ChargeOffDate IS NULL)
AND CycleDueDTD > 2

SELECT StatementDate, CycleDueDTD, ComputedCycleDueDTD, *--, DATEDIFF(MM,StatementDate,GETDATE()) CtrToUpdate,* 
FROM #TempComputedDataMultiCycleCBRCorrected 
WHERE CycleDueDTD > ComputedCycleDueDTD 
AND (ChargeOffDate >= TranTime OR ChargeOffDate IS NULL)
AND CycleDueDTD > 2
AND ReportingCorrected = 0 
order by bsacctid


DROP TABLE IF EXISTS #Combined
SELECT BSAcctID, AccountNumber, TranID, TransactionAmount, TranTime, PostTime, StatementDate, SystemStatus, CurrentBalance, CSH_CB, CycleDueDTD, ComputedCycleDueDTD, ReportingCorrected
INTO #Combined
FROM #TempComputedData1CycleCBRCorrected
WHERE CycleDueDTD > ComputedCycleDueDTD 
AND (ChargeOffDate >= TranTime OR ChargeOffDate IS NULL)
AND CycleDueDTD > 2
INSERT INTO #Combined
SELECT BSAcctID, AccountNumber, TranID, TransactionAmount, TranTime, PostTime, StatementDate, SystemStatus, CurrentBalance, CSH_CB, CycleDueDTD, ComputedCycleDueDTD, ReportingCorrected
FROM #TempComputedDataMultiCycleCBRCorrected
WHERE CycleDueDTD > ComputedCycleDueDTD 
AND (ChargeOffDate >= TranTime OR ChargeOffDate IS NULL)
AND CycleDueDTD > 2

SELECT * FROM #Combined
WHERE BSAcctID = 2606897
ORDER BY BSAcctId, StatementDate

DROP TABLE IF EXISTS #CombinedUnique
;WITH CTE
AS
(
SELECT *, RANK() OVER(PARTITION BY BSAcctid, StatementDate ORDER BY ComputedCycleDueDTD)  [RANK]
FROM #Combined
)
SELECT BSAcctID, AccountNumber, TranID, TransactionAmount, TranTime, PostTime, StatementDate, SystemStatus, CurrentBalance, CSH_CB, CycleDueDTD, ComputedCycleDueDTD, ReportingCorrected,
CASE WHEN ComputedCycleDueDTD-1 > 0 THEN ComputedCycleDueDTD-1 ELSE 0 END PHPValue, DATEDIFF(MM,StatementDate,GETDATE()) CtrToUpdate
INTO #CombinedUnique
FROM CTE WHERE [Rank] = 1

SELECT * FROM #CombinedUnique ORDER BY StatementDate

SELECT 
CASE WHEN CtrToUpdate < 10 THEN 'UPDATE TOP(1) BSegment_Balances SET ReportHistoryCtrCC0' + TRY_CAST(CtrToUpdate AS VARCHAR) + ' = ' + TRY_CAST(PHPValue AS VARCHAR) + ' WHERE acctId = ' + TRY_CAST(BSacctId AS VARCHAR)
WHEN CtrToUpdate >= 10 AND CtrToUpdate <= 24 THEN 'UPDATE TOP(1) BSegment_Balances SET ReportHistoryCtrCC' + TRY_CAST(CtrToUpdate AS VARCHAR) + ' = ' + TRY_CAST(PHPValue AS VARCHAR) + ' WHERE acctId = ' + TRY_CAST(BSacctId AS VARCHAR)
ELSE NULL
END AS PHPUpdate,
* 
FROM #CombinedUnique 
WHERE CtrToUpdate <> 0

-- SELECT ReportHistoryCtrCC02, CASE WHEN ReportHistoryCtrCC02 <= 2 THEN NULL ELSE 'UPDATE TOP(1) BSegment_Balances SET ReportHistoryCtrCC02 = 2 WHERE acctId = 362140' END FROM BSegment_Balances WITH (NOLOCK) WHERE acctId = 362140

SELECT 
CASE WHEN CtrToUpdate < 10 THEN 'SELECT ReportHistoryCtrCC0' + TRY_CAST(CtrToUpdate AS VARCHAR) + ' FROM BSegment_Balances WITH (NOLOCK) WHERE acctId = ' + TRY_CAST(BSacctId AS VARCHAR)
WHEN CtrToUpdate >= 10 AND CtrToUpdate <= 24 THEN 'SELECT ReportHistoryCtrCC' + TRY_CAST(CtrToUpdate AS VARCHAR) + ' FROM BSegment_Balances WITH (NOLOCK) WHERE acctId = ' + TRY_CAST(BSacctId AS VARCHAR)
ELSE NULL
END AS PHPUpdate,
* 
FROM #CombinedUnique 
WHERE CtrToUpdate <> 0


SELECT 
CASE WHEN CtrToUpdate < 10 THEN 'SELECT ReportHistoryCtrCC0' + TRY_CAST(CtrToUpdate AS VARCHAR) + ', ' + TRY_CAST(PHPValue AS VARCHAR) + ' PHPValue, CASE WHEN ReportHistoryCtrCC0' + TRY_CAST(CtrToUpdate AS VARCHAR) + ' <= '+ TRY_CAST(PHPValue AS VARCHAR) + ' THEN NULL ELSE ''UPDATE TOP(1) BSegment_Balances SET ReportHistoryCtrCC0' + TRY_CAST(CtrToUpdate AS VARCHAR) + ' = ' + TRY_CAST(PHPValue AS VARCHAR) + ' WHERE acctId = ' + TRY_CAST(BSacctId AS VARCHAR) + ''' END FROM BSegment_Balances WITH (NOLOCK) WHERE acctId = ' + TRY_CAST(BSacctId AS VARCHAR)
WHEN CtrToUpdate >= 10 AND CtrToUpdate <= 24 THEN 'SELECT ReportHistoryCtrCC' + TRY_CAST(CtrToUpdate AS VARCHAR) + ', ' + TRY_CAST(PHPValue AS VARCHAR) + ' PHPValue, CASE WHEN ReportHistoryCtrCC' + TRY_CAST(CtrToUpdate AS VARCHAR) + ' <= '+ TRY_CAST(PHPValue AS VARCHAR) + ' THEN NULL ELSE ''UPDATE TOP(1) BSegment_Balances SET ReportHistoryCtrCC' + TRY_CAST(CtrToUpdate AS VARCHAR) + ' = ' + TRY_CAST(PHPValue AS VARCHAR) + ' WHERE acctId = ' + TRY_CAST(BSacctId AS VARCHAR) + ''' END FROM BSegment_Balances WITH (NOLOCK) WHERE acctId = ' + TRY_CAST(BSacctId AS VARCHAR)
ELSE NULL
END AS PHPUpdate,
* 
FROM #CombinedUnique 
WHERE CtrToUpdate <> 0

SELECT ReportHistoryCtrCC02, 2 PHPValue, CASE WHEN ReportHistoryCtrCC02 <= 2 THEN NULL ELSE 'UPDATE TOP(1) BSegment_Balances SET ReportHistoryCtrCC02 = 2 WHERE acctId = 362140' END FROM BSegment_Balances WITH (NOLOCK) WHERE acctId = 362140
SELECT ReportHistoryCtrCC01, 3 PHPValue, CASE WHEN ReportHistoryCtrCC01 <= 3 THEN NULL ELSE 'UPDATE TOP(1) BSegment_Balances SET ReportHistoryCtrCC01 = 3 WHERE acctId = 362140' END FROM BSegment_Balances WITH (NOLOCK) WHERE acctId = 362140
SELECT ReportHistoryCtrCC01, 0 PHPValue, CASE WHEN ReportHistoryCtrCC01 <= 0 THEN NULL ELSE 'UPDATE TOP(1) BSegment_Balances SET ReportHistoryCtrCC01 = 0 WHERE acctId = 2164229' END FROM BSegment_Balances WITH (NOLOCK) WHERE acctId = 2164229
SELECT ReportHistoryCtrCC03, 2 PHPValue, CASE WHEN ReportHistoryCtrCC03 <= 2 THEN NULL ELSE 'UPDATE TOP(1) BSegment_Balances SET ReportHistoryCtrCC03 = 2 WHERE acctId = 13565918' END FROM BSegment_Balances WITH (NOLOCK) WHERE acctId = 13565918
SELECT ReportHistoryCtrCC01, 0 PHPValue, CASE WHEN ReportHistoryCtrCC01 <= 0 THEN NULL ELSE 'UPDATE TOP(1) BSegment_Balances SET ReportHistoryCtrCC01 = 0 WHERE acctId = 17026027' END FROM BSegment_Balances WITH (NOLOCK) WHERE acctId = 17026027

SELECT AccountNumber, COUNT(1) FROM #CombinedUnique GROUP BY AccountNumber


--UPDATE TOP(1) BSegment_Balances SET ReportHistoryCtrCC02 = 1 WHERE acctId = 298037

SELECT * FROm BSegment_Balances WITH (NOLOCK) WHERE acctID = 282736

SELECT * FROM #CombinedUnique ORDER BY BSAcctID, StatementDate

--SELECT CMTTRanType, TransactionAmount, TranTime, PostTime,* FROM CCard_Primary WITH (NOLOCK) WHERE TranID = 75340523644

--75340523644




SELECT ReportHistoryCtrCC01,ReportHistoryCtrCC02,ReportHistoryCtrCC03,ReportHistoryCtrCC04,ReportHistoryCtrCC05,ReportHistoryCtrCC06,
ReportHistoryCtrCC07,ReportHistoryCtrCC08,ReportHistoryCtrCC09,ReportHistoryCtrCC10,ReportHistoryCtrCC11,ReportHistoryCtrCC12,
ReportHistoryCtrCC13,ReportHistoryCtrCC14,ReportHistoryCtrCC15,ReportHistoryCtrCC16,ReportHistoryCtrCC17,ReportHistoryCtrCC18,
ReportHistoryCtrCC19,ReportHistoryCtrCC20,ReportHistoryCtrCC21,ReportHistoryCtrCC22,ReportHistoryCtrCC23,ReportHistoryCtrCC24 
FROM BSegment_balances WITH (NOLOCK)
WHERE acctId = 362140



select paymenthistprofile,* From LS_P1MARPRODDB01.ccgs_coreissue.dbo.cbreportingdetail with(nolock) where acctid = 362140
order by statementdate desc

select * From LS_P1MARPRODDB01.ccgs_coreissue.dbo.BSCBRPHPHistory with(nolock) where acctid = 362140
order by statementdate desc

select sh.currentbalance,csh.currentbalance, CycleDueDTD,* 
from statementheader sh with(nolock) 
join currentstatementheader csh with(nolock) on csh.acctid = sh.acctid and csh.statementdate = sh.statementdate
where sh.acctid = 362140
order by sh.statementdate desc


SELECT CMTTranType,* FROM CCArd_Primary WITH (NOLOCK) WHERE TranID IN (78298369119, 78298369158)