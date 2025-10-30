

SELECT HighBalanceRecalculation, TSDBOActive, TSDBOActiveDate, TSDBOAllowedMonths,* FROM Org_Balances

--UPDATE Org_Balances SET TSDBOAllowedMonths = 2

SELECT tpyblob,* FROM OrgAccounts

SELECT * FROM ErrorTNP

SELECT *
FROM CurrentStatementHeader WITH (NOLOCK)
WHERE acctID = 14551618
ORDER BY StatementDate

SELECT *
FROM BSegment_MStatuses WITH (NOLOCK)
WHERE acctID = 14551618

SELECT AccountNumber, BillingCycle, tpyBlob, *
FROM BSegment_Primary WITH (NOLOCK)
WHERE acctID = 14551618

SELECT * FROM HighBalanceErrorLog WITH (NOLOCK)

SELECT * FROM CCardLookUp WITH (NOLOCK) WHERE LutId = 'BalanceAudit'

SELECT * 
FROM ProductLytTxnMapping WITH (NOLOCK)
--WHERE LogicModule = '16'

SELECT ActualTranCode, LogicModuleType, M.TransactionDescription, * 
FROM ProductLytTxnMapping P WITH (NOLOCK)
JOIN MonetaryTxnControl M WITH (NOLOCK) ON (P.MonetaryTransactionCode = M.TransactionCode)
WHERE M.LogicModule IN ('40', '43')

--UPDATE MonetaryTxnControl SET LogicModuleType = '11' WHERE ActualTranCode = '4301'


SELECT EqualPayments, CPMDescription, *
FROM CPMAccounts WITH (NOLOCK)
WHERE CreditPlanType = '16'



SELECT LogicModuleType, Status, * 
FROM MonetaryTxnControl WITH (NOLOCK)
WHERE LogicModule = '43'
--AND ActualTranCode IN ('4001', '4005')
AND TransactionCode = '17591'

SELECT diversionindicator, *
FROM monetarytxncontrol a WITH(nolock)    
JOIN trancodelookup b WITH(nolock)    
ON b.lutcode = a.transactioncode    
AND b.lutid = 'TranCode'
AND a.ActualTranCode IN ('4001', '4005')

SELECT *
FROM TranCodeLookUp WITH (NOLOCK)
WHERE LutId = 'TranCode'
AND LutCode = '17591'

--UPDATE T
--SET diversionindicator = 2
--FROM TranCodeLookUp T
--WHERE LutId = 'TranCode'
--AND LutCode = '17591'

SELECT * FROM version order by 1 desc
--UPDATE Org_Balances SET HighBalanceRecalculation = '1' WHERE acctId <> 1

SELECT * FROM Logo_Balances

SELECT StatusDescription, *
FROM AStatusAccounts WITH (NOLOCK)
WHERE StatusDescription LIKE '%SCRA%'

SELECT * FROM sys.synonyms WHERE name = 'StatementHeader'

SELECT DISTINCT LogicModule, DrCrIndicator_MTC
FROM MonetaryTxnControl WITH (NOLOCK)
WHERE (LEN(LogicModule) = 3 AND TRY_CAST(LogicModule AS INT) BETWEEN 110 AND 120) 
OR (LEN(LogicModule) = 4 AND TRY_CAST(LogicModule AS INT) BETWEEN 1100 AND 1200)

SELECT DISTINCT RTRIM(LogicModule) LogicModule, DrCrIndicator_MTC
FROM MonetaryTxnControl WITH (NOLOCK)
WHERE ((LEN(LogicModule) = 3 AND TRY_CAST(LogicModule AS INT) BETWEEN 110 AND 120) 
OR (LEN(LogicModule) = 4 AND TRY_CAST(LogicModule AS INT) BETWEEN 1100 AND 1200))
AND DrCrIndicator_MTC = '1'

SELECT DISTINCT RTRIM(LogicModule) LogicModule, DrCrIndicator_MTC
FROM MonetaryTxnControl WITH (NOLOCK)
WHERE ((LEN(LogicModule) = 3 AND TRY_CAST(LogicModule AS INT) BETWEEN 110 AND 120) 
OR (LEN(LogicModule) = 4 AND TRY_CAST(LogicModule AS INT) BETWEEN 1100 AND 1200))
AND DrCrIndicator_MTC = '-1'




SELECT SH.acctId, SH.StatementDate, SH.CycleDueDTD, SH.CurrentBalance, SH.CurrentBalanceCO, 
CSH.CurrentBalance, SH.CurrentBalance + SH.CurrentBalanceCO - CSH.CurrentBalance ActualCB,
AdjustedCurrentBalance, AdjustedHighBalance, AdjustedTransactionAmount, SH.IsAcctSCRA, CSH.IsAcctSCRA, SH.ccinhparent125AID
--, AdjustedCurrentBalance-AdjustedTransactionAmount AdjustedBalance
FROM StatementHeader SH WITH (NOLOCK)
JOIN CurrentStatementHeader CSH WITH (NOLOCK) ON (SH.acctID = CSH.acctId AND SH.StatementDate = CSH.StatementDate)
WHERE SH.acctID = 14551618
ORDER BY SH.StatementDate

--UPDATE Logo_Balances SET TNPPDFXmlGeneration = NULL

--UPDATE BSegment_Balances SET TSDBOActive = '1', TSDBOActiveDate = dbo.PR_ISOGetBusinessTime() WHERE acctID = 14551618

SELECT * FROM TSDBOHBConversion

--UPDATE TSDBOHBConversion SET JobStatus = 1 WHERE acctID = 14551618

SELECT * FROM TSDBOHBConversion_MetaData

SELECT * FROM TSDBOHBConversion_Account

--TRUNCATE TABLE TSDBOHBConversion_MetaData
--TRUNCATE TABLE TSDBOHBConversion_Account

SELECT * FROM CommonTNP WITH (NOLOCK) where atid = 60


SELECT object_name(object_id),* FROM sys.columns WHERE name LIKE 'TransmissionDateTime%' and object_name(object_id) LIKE '%ccard%'

SELECT CMTTRANTYPE, TransactionAmount, NoBlobIndicator, TxnIsFor, FeesAcctID, CPMGroup, ClaimID, ArtxnType
--, DateTimeLocalTransaction, CP.TransmissionDateTime, WarehouseTxnDate, EffectiveDate, hostmachinename, Transactionidentifier
--,MerchantCountryCode, MerchantID
--,HostMachineName
, *
FROM CCArd_Primary CP WITH (NOLOCK) 
--LEFT JOIN CCard_Secondary CS WITH (NOLOCK) ON (CP.TranID = CS.TranID)
WHERE AccountNumber = '1100000100200259' 
--AND ARTxnType = '91'
--AND CMTTRANTYPE IN ('02', '03')
--AND CMTTRANTYPE IN ('ECD', '*SCR', 'ADDBK')
--AND (PostTime = '2022-02-28 23:59:57.000' OR DateTimeLocalTransaction = '2022-02-28 23:59:57.000')
--AND ArTxnType = '91'
--WHERE TranID = 1387981880908709889
ORDER BY PostTime DESC

SELECT TransactionAmount, *
FROM LoyaltyTransactionMessage WITH (NOLOCK)
WHERE AccountNumber = '1100000100200242' 
ORDER BY PostTime DESC

SELECT *
FROM LPSegmentAccounts WITH (NOLOCK)
WHERE parent02AID = 14551618

SELECT StatementDate, SUM(TransactionAmount) TransactionAmount
FROM ConsolidatedCreditRecords WITH (NOLOCK)
WHERE parent02AID = 14551618
AND StatementDate = '2022-02-28 23:59:57.000'
GROUP BY StatementDate 

SELECT *
FROM ConsolidatedCreditRecords WITH (NOLOCK)
WHERE parent02AID = 14551618
AND StatementDate = '2022-02-28 23:59:57.000'
ORDER BY StatementDate


SELECT acctId, LastStatementDate, AmtOfAcctHighBalLTD, CurrentBalance
FROM BSegment_Primary WITH (NOLOCK) 
WHERE AccountNumber = '1100000100200259'

SELECT IsAcctSCRA, *
FROM CurrentStatementHeader WITH (NOLOCK)
WHERE acctID = 14551618
ORDER BY StatementDate DESC

SELECT Principal, RecoveryFeesBNP, IntBilledNotPaid, *
FROM CurrentSummaryHeader WITH (NOLOCK)
WHERE acctID = 40755720
ORDER BY StatementDate DESC

SELECT Principal, RecoveryFeesBNP, IntBilledNotPaid, *
FROM SummaryHeader WITH (NOLOCK)
WHERE acctID = 40755720
ORDER BY StatementDate DESC

SELECT CurrentBalance, IsAcctSCRA,*
FROM StatementHeader WITH (NOLOCK)
WHERE acctID = 14551618
ORDER BY StatementDate DESC

SELECT *
FROM CCardLookUp WITH (NOLOCK)
WHERE LUTid = 'LgRCFrequency'



SELECT 
	BP.acctId, BCC.ChargeOffDate, TSDBOActive, TSDBOActiveDate, HBRecalcStatus, HBRecalcRequired, BP.AccountNumber, BCC.TNPPDFXmlGeneration, BP.CreatedTime, 
	BP.LastStatementDate, BP.DateOfNextStmt, CurrentBalance + CurrentBalanceCO CurrentBalance, BP.AmtOfAcctHighBalLTD,
	BB.CBRAmountOfCurrentBalance, BB.CBRAmountOfCurrentBalanceBP1, BB.CBRAmountOfCurrentBalanceBP2, BB.CBRAmountOfCurrentBalanceBP3, BB.CBRAmountOfCurrentBalanceBP4,
	BB.CBRAmountOfHighBalance, BB.CBRAmountOfHighBalanceBP1, BB.CBRAmountOfHighBalanceBP2, BB.CBRAmountOfHighBalanceBP3, BB.CBRAmountOfHighBalanceBP4,
	BB.CBRBreakPoint1, BB.CBRBreakPoint2, BB.CBRBreakPoint3, BB.CBRBreakPoint4, BB.CBRLastCalculatedDate
FROM BSegment_Primary BP WITH (NOLOCK)
JOIN BSegment_Secondary BS WITH (NOLOCK) ON (BP.acctId = BS.acctId)
JOIN BSegmentCreditCard BCC WITH (NOLOCK) ON (BS.acctID = BCC.acctID)
JOIN BSegment_Balances BB WITH (NOLOCK) ON (BCC.acctId = BB.acctID)
WHERE BP.acctID = 14551618


SELECT AdjustedCurrentBalance, AdjustedHighBalance, IsAcctSCRA, *
FROM CurrentStatementHeader WITH (NOLOCK)
WHERE acctID = 14551618
ORDER BY StatementDate DESC

SELECT SH.StatementDate, SUM(SH.CurrentBalance + SHC.CurrentBalanceCO - CSH.CurrentBalance) CurrentBalance
FROM SummaryHeader SH WITH (NOLOCK)
JOIN SummaryHeaderCreditcard SHC WITH (NOLOCK) ON (SH.acctID = SHC.acctID AND SH.StatementID = SHC.StatementID) 
JOIN CurrentSummaryHeader CSH WITH (NOLOCK) ON (SH.acctID = CSH.acctID AND SH.StatementID = CSH.StatementID)
WHERE SH.parent02AID = 14551618
--AND SH.StatementDate IN ('2021-12-31 23:59:57.000', '2022-01-31 23:59:57.000') 
GROUP BY SH.StatementDate
ORDER BY SH.StatementDate

SELECT SH.parent02AID, SH.StatementDate, SH.CreditPlanType, 
SH.AmtOfInterestCTD, CSH.AmtOfInterestCTD, CSH.InterestAtCycle, SH.AmtOfInterestCTD-CSH.AmtOfInterestCTD TotalInterest
, SH.CurrentBalance, SHC.CurrentBalanceCO, CSH.CurrentBalance, CSH.*
FROM SummaryHeader SH WITH (NOLOCK)
JOIN SummaryHeaderCreditcard SHC WITH (NOLOCK) ON (SH.acctID = SHC.acctID AND SH.StatementID = SHC.StatementID) 
JOIN CurrentSummaryHeader CSH WITH (NOLOCK) ON (SH.acctID = CSH.acctID AND SH.StatementID = CSH.StatementID)
WHERE SH.parent02AID = 14551618
--AND SH.CreditPlanType = '0'
--AND SH.AmtOfInterestCTD+CSH.AmtOfInterestCTD <> 0
--AND SH.StatementDate IN ('2021-12-31 23:59:57.000', '2022-01-31 23:59:57.000')
ORDER BY SH.StatementDate DESC

--UPDATE CurrentStatementHeader SET CBRAmountOfCurrentBalance = 0, CBRAmountOfHighBalance = 0 WHERE acctID = 14551609 AND StatementDate = '2018-04-30 23:59:57.000'

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

SELECT StatusDescription, * FROM AStatusAccounts WHERE StatusDescription LIKE '%Closed%'


SELECT 
	CP.BSAcctid, CP.CMTTRANTYPE, CP.TxnSource, CP.TransactionAmount, CP.TranTime, CP.PostTime, 
	CP.TranId, CP.TranRef, CP.tranorig, CP.RevTgt, CP.NoBlobIndicator, CP.NoBlobIndicatorGEN,
	CP.DateTimeLocalTransaction
FROM CCard_Primary CP WITH (NOLOCK)
LEFT JOIN CCard_Secondary CS WITH (NOLOCK) ON (CP.TranID = CS.TranId)
WHERE CP.AccountNumber = (SELECT AccountNumber FROM BSegment_Primary WITH (NOLOCK) WHERE acctID = 14551618)
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