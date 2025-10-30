SELECT HighBalanceRecalculation,* FROM Org_Balances
SELECT * FROM version order by 1 desc
--UPDATE Org_Balances SET HighBalanceRecalculation = '1' WHERE acctId <> 1

SELECT * FROM Logo_Balances

--UPDATE Logo_Balances SET TNPPDFXmlGeneration = NULL

SELECT *
FROM AStatusAccounts WITH (NOLOCK)
WHERE StatusDescription LIKE '%SCRA%'


SELECT object_name(object_id),* FROM sys.columns WHERE name LIKE 'MTC%' and object_name(object_id) LIKE '%ccard%'

SELECT acctId, LastStatementDate 
FROM BSegment_Primary WITH (NOLOCK) 
WHERE AccountNumber = '1100001000006697' --5122300000002325

SELECT 
	BP.acctId, BP.SCRAEffectiveDate, BP.AccountNumber, BP.CreatedTime, BP.LastStatementDate, BP.DateOfNextStmt, CurrentBalance, BP.AmtOfAcctHighBalLTD,
	BB.CBRAmountOfCurrentBalance, BB.CBRAmountOfCurrentBalanceBP1, BB.CBRAmountOfCurrentBalanceBP2, BB.CBRAmountOfCurrentBalanceBP3, BB.CBRAmountOfCurrentBalanceBP4,
	BB.CBRAmountOfHighBalance, BB.CBRAmountOfHighBalanceBP1, BB.CBRAmountOfHighBalanceBP2, BB.CBRAmountOfHighBalanceBP3, BB.CBRAmountOfHighBalanceBP4,
	BB.CBRBreakPoint1, BB.CBRBreakPoint2, BB.CBRBreakPoint3, BB.CBRBreakPoint4, BB.CBRLastCalculatedDate
FROM BSegment_Primary BP WITH (NOLOCK)
JOIN BSegment_Secondary BS WITH (NOLOCK) ON (BP.acctId = BS.acctId)
JOIN BSegmentCreditCard BCC WITH (NOLOCK) ON (BS.acctID = BCC.acctID)
JOIN BSegment_Balances BB WITH (NOLOCK) ON (BCC.acctId = BB.acctID)
WHERE BP.acctID = 2830393

SELECT AccountNumber, TranTime, PostTime, TransmissionDateTime
FROM CCard_Primary WITH (NOLOCK)
WHERE AccountNumber = '1100001000006697'
AND CMTTRANTYPE IN ('ADDSCRA', 'ADDBK', 'ECD')



SELECT CBRAmountOfCurrentBalance, CBRAmountOfHighBalance, *
FROM CurrentStatementHeader WITH (NOLOCK)
WHERE acctID = 14551609
ORDER BY StatementDate DESC

--UPDATE CurrentStatementHeader SET CBRAmountOfCurrentBalance = 0, CBRAmountOfHighBalance = 0 WHERE acctID = 2830393 AND StatementDate = '2022-03-10 23:59:57.000'

--UPDATE BB SET
--	BB.CBRAmountOfCurrentBalance = NULL,
--	BB.CBRAmountOfCurrentBalanceBP1 = NULL,
--	BB.CBRAmountOfCurrentBalanceBP2 = NULL,
--	BB.CBRAmountOfCurrentBalanceBP3 = NULL,
--	BB.CBRAmountOfCurrentBalanceBP4 =NULL,
--	BB.CBRAmountOfHighBalance = NULL,
--	BB.CBRAmountOfHighBalanceBP1 = NULL,
--	BB.CBRAmountOfHighBalanceBP2 = NULL,
--	BB.CBRAmountOfHighBalanceBP3 = NULL,
--	BB.CBRAmountOfHighBalanceBP4 =NULL,
--	BB.CBRBreakPoint1 = NULL,
--	BB.CBRBreakPoint2 = NULL,
--	BB.CBRBreakPoint3 = NULL,
--	BB.CBRBreakPoint4 = NULL,
--	BB.CBRLastCalculatedDate = NULL
--FROM 
-- BSegment_Balances BB 
--WHERE acctID = 2830393


SELECT IntBilledNotPaid,*
FROM CurrentSummaryHeader WITH (NOLOCK)
WHERE acctID = 3104713
ORDER BY StatementDate DESC


DECLARE @AccountID INT = 14551609

--DROP TABLE IF EXISTS #Plans
--CREATE TABLE #Plans (acctID INT)

--INSERT INTO #Plans
--SELECT acctId
--FROM CPSgmentAccounts WITH (NOLOCK)
--WHERE parent02AID = @AccountID

--INSERT INTO #TempData (TranId, AccountNumber, TransactionAmount, Trantime, PostTime)
--SELECT 0, @AccountNumber, IntBilledNotPaid, CS.StatementDate, CS.StatementDate
--FROM CurrentSummaryHeader CS WITH (NOLOCK)
--JOIN #Plans P ON (CS.acctID = P.acctID)
--WHERE acctID = 40755710
--AND StatementDate > ''

--DELETE FROM #TempData WHERE CMTTranType IN ('03') AND TxnSource = '4'

SELECT * FROM AStatusAccounts WHERE StatusDescription LIKE '%Pending de%'


SELECT 
	CP.BSAcctid, CP.CMTTRANTYPE, CP.TxnSource, CP.TransactionAmount, CP.TranTime, CP.PostTime, 
	CP.TranId, CP.TranRef, CP.tranorig, CP.RevTgt, CP.NoBlobIndicator, CP.NoBlobIndicatorGEN,
	CP.DateTimeLocalTransaction
FROM CCard_Primary CP WITH (NOLOCK)
--LEFT JOIN CCard_Secondary CS WITH (NOLOCK) ON (CP.TranID = CS.TranId)
WHERE CP.AccountNumber = (SELECT AccountNumber FROM BSegment_Primary WITH (NOLOCK) WHERE acctID = 14551609)
ORDER BY CP.PostTime DESC

--22.72+1.34

SELECT IntBilledNotPaid, AmtOfInterestCTD,*
FROM CurrentSummaryHeader WITH (NOLOCK)
WHERE acctID = 3104713
ORDER BY StatementDate DESC

SELECT 0, CASE 
		WHEN SH.IntBilledNotPaid-CS.IntBilledNotPaid > 0 
		THEN '03' 
		ELSE '02' 
	END, SH.IntBilledNotPaid-CS.IntBilledNotPaid, CS.IntBilledNotPaid, CS.IntBilledNotPaid, 
SH.IntBilledNotPaid, CS.StatementDate, CS.StatementDate, 2
FROM CurrentSummaryHeader CS WITH (NOLOCK)
JOIN SummaryHeader SH WITH (NOLOCK) ON (CS.acctId = SH.acctId AND CS.StatementDate = SH.StatementDate)
WHERE SH.acctID = 3104713
AND SH.StatementDate > '01/06/2021 16:08:35:000'

SELECT CurrentBalance, SRBWithInstallmentDue, AmountOfTotalDue, AmtOfAcctHighBalLTD,*
FROM StatementHeader WITH (NOLOCK)
WHERE acctID = 14551609
ORDER BY StatementDate DESC


SELECT * FROM Org_Balances

SELECT *
FROM LateFeeDeterminant WITH (NOLOCK)
WHERE acctId = 14551609





--14551609|1100001000006697|4071.8|4071.8|200|02/06/2018 16:04:05:000|00/00/0 00:00:00:000|00/00/0 00:00:00:000|00/00/0 00:00:00:000|00/00/0 00:00:00:000|0.00000|0.00000|0.00000|0.00000|0.00000|0.00000|0.00000|0.00000|0.00000|0.00000|03/10/2018 16:30:53:000|04/10/2018 19:07:40:000|


--exec PP_CI..USP_ReCalculateHighBalance 14551609,'1100001000006697','4273.5','4273.5','600','2018-02-06 16:04:05','2018-03-31 23:59:57','2017-12-31 23:59:57','2017-09-30 23:59:57','2017-06-30 23:59:57','4973.50000','3571.80000','0.00000','0.00000','0.00000','4973.50000','3571.80000','0.00000','0.00000','0.00000','2018-03-15 16:37:27','2018-04-15 16:54:30'