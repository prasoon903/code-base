SELECT * FROM CommonTNP WITH (NOLOCK) WHERE TranTime < GETDATE()

DROP TABLE IF EXISTS #TempTable
GO
SELECT BP.acctId, RTRIM(BP.AccountNumber) AccountNumber, BP.TempCreditLimit, BP.SystemStatus, BP.CycleDueDTD
--INTO #TempTable
FROM BSegment_Primary BP WITH (NOLOCK)
JOIN CCard_Primary CP WITH (NOLOCK) ON BP.AccountNumber = CP.AccountNumber
WHERE BP.SystemStatus <> 14 AND CP.CMTTRANTYPE = '52' AND BP.CreditLimit = 0

SELECT SystemStatus, CycleDueDTD, COUNT(1) AS RecordCount
FROM #TempTable 
GROUP BY SystemStatus, CycleDueDTD


SELECT ExcludeFlag, * FROM LogArTxnAddl WITH (NOLOCK) WHERE TranID IN (29660123317, 29660171876) AND ArTxnType = '93'

SELECT bsacctid, hostmachinename, institutionid,PostingRef,ArTxnType,txnsource,transactionamount,BSAcctid,* FROM CCard_Primary WITH (NOLOCK) WHERE TranID IN (29660123317, 29660171876)

--Transaction Rejected. Duplicate TIA Reject

SELECT PostingRef,ArTxnType,* FROM CCard_Primary WITH (NOLOCK) WHERE TranRef IN (29459391344, 29463669012)

--UPDATE CCard_Primary SET PostingRef = 'Transaction posted successfully', ArTxnType = '91' WHERE TranID IN (29074699354, 29118618780)

--UPDATE LogArTxnAddl SET ExcludeFlag = 1 WHERE TranID IN (29074699354, 29118618780) AND ArTxnType = '93'

--Update Logartxnaddl set excludeflag = 1 where tranid in (29360815627,29360833389,29360690529,29157763966,29157768425,29157883055,115104718,115104727)

--Transaction posted successfully

INSERT INTO CommonTNP (tnpdate,priority,TranTime,TranId,ATID,acctId,ttid,NADandROOFlag,GetAllTNPJobsFlag,Retries) 
SELECT tnpdate,priority,GETDATE(),TranId,ATID,acctId,ttid,NADandROOFlag,GetAllTNPJobsFlag,0 FROM ErrorTNP WITH (NOLOCK) WHERE TranID > 0 AND ATID = 51



SELECT TOP 10 * FROM CurrentBalanceAudit WITH (NOLOCK) WHERE AID = 7700246 AND TID IN (29444039321) 

SELECT * FROM trans_in_acct WITH (NOLOCK) WHERE tran_id_index IN (29459391344, 29463669012)

DELETE FROM CurrentBalanceAudit WHERE AID = 7700246 AND TID = 29444039321
-- 6 rows

DELETE FROM trans_in_acct WHERE tran_id_index IN (29459391344, 29463669012)
-- 10 rows

select COUNT(1), JobStatus
from Temp_bsegment_DelinqDays
group by JobStatus




select top 5 * from accountinfoforreport with (nolock) order by businessday desc

select * from errortnp with (nolock)

SELECT
	BP.acctId, FirstDueDate, NoPayDaysDelinquent, DaysDelinquent, DtOfLastDelinqCTD, DateOfOriginalPaymentDueDTD, LAD, DeAcctActivityDate, ccinhparent125AID, ActualDRPStartDate, 0
FROM BsegmentCreditCard BCC WITH (NOLOCK)
INNER JOIN BSegment_Primary BP WITH (NOLOCK) ON (BP.acctId = BCC.acctId)
WHERE BCC.DaysDelinquent > BCC.NoPayDaysDelinquent
AND BP.SystemStatus <> 14 And BillingCycle <>'LTD'
AND DtOfLastDelinqCTD <> DateOfOriginalPaymentDueDTD

;WITH DelinquentAccts
AS
(
	SELECT
		BP.acctId, DateOfOriginalPaymentDueDTD, NoPayDaysDelinquent, DaysDelinquent, DtOfLastDelinqCTD, LAD, DeAcctActivityDate, ccinhparent125AID, ActualDRPStartDate, CycleDueDTD
	FROM BsegmentCreditCard BCC WITH (NOLOCK)
	INNER JOIN BSegment_Primary BP WITH (NOLOCK) ON (BP.acctId = BCC.acctId)
	WHERE BCC.DaysDelinquent > BCC.NoPayDaysDelinquent
	AND BP.SystemStatus <> 14 And BillingCycle <>'LTD'
	AND DtOfLastDelinqCTD <> DateOfOriginalPaymentDueDTD
)
, CalculatedDD
AS
(
	SELECT
		acctId, 
		CASE WHEN CCINHPARENT125AID IN (15996, 16000) THEN DATEDIFF(DAY, DateOfOriginalPaymentDueDTD, ActualDRPStartDate) ELSE DATEDIFF(DAY, DateOfOriginalPaymentDueDTD, DeAcctActivityDate) + 1 END AS CALC_NoPayDaysDelinquent,
		CASE WHEN CCINHPARENT125AID IN (15996, 16000) THEN DATEDIFF(DAY, DtOfLastDelinqCTD, ActualDRPStartDate) ELSE DATEDIFF(DAY, DtOfLastDelinqCTD, DeAcctActivityDate) + 1 END AS CALC_DaysDelinquent,
		NoPayDaysDelinquent, DaysDelinquent, DateOfOriginalPaymentDueDTD, DtOfLastDelinqCTD, DeAcctActivityDate, ccinhparent125AID, ActualDRPStartDate, CycleDueDTD
	FROM DelinquentAccts
)
SELECT 
*
FROM CalculatedDD
WHERE ccinhparent125AID IN (15996, 16000)
--WHERE CALC_DaysDelinquent <> DaysDelinquent



SELECT BP.acctId, RTRIM(BP.AccountNumber) As AccountNumber, DaysDelinquent, NoPayDaysDelinquent, DtOfLastDelinqCTD, DateOfOriginalPaymentDueDTD
FROM BSegment_Primary BP WITH (NOLOCK)
JOIN BSegmentCreditCard BCC WITH (NOLOCK) ON (BP.acctId = BCC.acctId)
WHERE DaysDelinquent > NoPayDaysDelinquent



SELECT BP.acctId, BP.CycleDueDTD, BP.SystemStatus, BP.AccountNumber
FROM PROD1GSDB01.CCGS_CoreIssue.dbo.BSegment_Primary BP WITH (NOLOCK)
JOIN PROD1GSDB01.CCGS_CoreIssue.dbo.BSegmentCreditCard BCC WITH (NOLOCK) ON (BP.acctId = BCC.acctId)
WHERE BP.CycleDueDTD < 2 
AND SystemStatus IN (3, 15991)
--AND SystemStatus <> 2
ORDER BY acctId

SELECT BP.acctId, BP.CycleDueDTD, BP.SystemStatus
FROM PROD1GSDB01.CCGS_CoreAuth.dbo.BSegment_Primary BP WITH (NOLOCK)
WHERE BP.CycleDueDTD < 2 AND SystemStatus IN (3, 15991)

SELECT TOP 20 * FROM CurrentBalanceAudit WITH (NOLOCK) WHERE AID = 302632 ORDER BY BusinessDay DESC

select * from sys.servers

--PROD1GSDB01

select * from PROD1GSDB01.CCGS_CoreIssue.dbo.errortnp with (nolock)

SELECT A.CBRStatusGroup,C.LutDescription AS StatusGroup, A.StatusDescription,A.WaiveMinDue,A.WaiveMinDueFor,A.Priority,A.* 
FROM PROD1GSDB01.CCGS_CoreIssue.dbo.AStatusAccounts A WITH (NOLOCK)
JOIN PROD1GSDB01.CCGS_CoreIssue.dbo.CCardLookUp C WITH (NOLOCK) ON (A.parent01AID = C.LutCode)
WHERE C.LUTid = 'AsstPlan' AND C.LutLanguage = 'dbb' AND A.MerchantAID = 14992
ORDER BY A.Priority



SELECT  bsacctid,CREDITPLANTYPE,txnsource,accountnumber,CP.CMTTRANTYPE,CP.TRANSACTIONAMOUNT,revtgt,CP.POSTTIME,CP.TRANTIME,CP.TRANID,CASEID,CP.TxnAcctId,
	memoindicator,transactiondescription,CP.TRANORIG,CP.TRANREF,noblobindicator
	,T.* FROM PROD1GSDB01.ccgs_coreissue.dbo.CCARD_PRIMARY CP WITH(NOLOCK) 
	LEFT OUTER JOIN PROD1GSDB01.ccgs_coreissue.dbo.NoBlobTransactionBSFC T WITH(NOLOCK) ON (CP.TRANID = T.TRANID)
	LEFT OUTER JOIN PROD1GSDB01.ccgs_coreissue.dbo.CPSGMENTACCOUNTS CPS WITH(NOLOCK) ON (CP.BSACCTID = CPS.PARENT02AID AND CP.TXNACCTID = CPS.ACCTID)
WHERE ACCOUNTNUMBER = (SELECT AccountNumber FROM PROD1GSDB01.ccgs_coreissue.dbo.BSEGMENT_PRIMARY BP WITH(NOLOCK) WHERE acctId = 1770565) 
AND CMTTRANTYPE NOT IN ('PPR','MRR') 
--AND memoindicator IS NULL
ORDER BY CP.POSTTIME DESC

SELECT COUNT(1), CMTTRANTYPE
FROM PROD1GSDB01.ccgs_coreissue.dbo.CCard_Primary CP WITH (nolock) WHERE AccountNumber IN (
SELECT AccountNumber From PROD1GSDB01.ccgs_coreissue.dbo.Bsegment_Primary BP WITH (NOLOCk) JOIN
PROD1GSDB01.ccgs_coreissue.dbo.ErrorTNP ET WITH (NOLOCK) ON (BP.acctID = ET.acctID))
AND CP.TranTIme > '2020-05-01' AND TxnSource <> 4
GROUP BY CMTTranTYPE

select * from PROD1GSDB01.CCGS_CoreIssue.dbo.commontnp with (nolock) where acctid = 2410479 and tranid = 0

select DaysDelinquent,CycleDueDTD,* from datavalidationrecords with (nolock) where businessday = '2020-04-30 23:59:57' 
and SystemStatus <> 14 and CycleDueDTD < 8
--and bsacctid not in (297249,403824,1139596,1979606,2107173,2270701)
ORDER BY Skey

select * from datavalidationrecords with (nolock) where businessday = '2020-06-14 23:59:57' --and bsacctid = 3544612


select BSAcctid from datavalidationrecords with (nolock) where businessday = '2020-04-06 23:59:57' 
and SystemStatus <> 14 --and CycleDueDTD < 8
EXCEPT
select BSAcctid from datavalidationrecords with (nolock) where businessday = '2020-04-05 23:59:57' 
and SystemStatus <> 14 --and CycleDueDTD < 8


select s.currentdue ,round(currentdue,2),sh.acctid  from PROD1GSDB01.ccgs_coreissue.dbo.Summaryheadercreditcard s  with(nolock)
	 join  PROD1GSDB01.ccgs_coreissue_secondary.dbo.Summaryheader  sh with(nolock) 
	 on (s.acctid = sh.acctid and s.statementid = sh.statementid )
	  where statementdate = '2020-03-31 23:59:57.000'   and   (((abs(currentdue)*100) - CONVERT(INT,(abs(currentdue)*100))) <> 0) and sh.parent02aid in ( select bsacctid from datavalidationrecords  with(nolock) where businessday = '2020-03-31 23:59:57.000' )

select DISTINCT SH.Parent02AID  from PROD1GSDB01.ccgs_coreissue.dbo.Summaryheadercreditcard s  with(nolock)
	 join  PROD1GSDB01.ccgs_coreissue_secondary.dbo.Summaryheader  sh with(nolock) 
	 on (s.acctid = sh.acctid and s.statementid = sh.statementid )
	  where statementdate = '2020-03-31 23:59:57.000'   and   (((abs(currentdue)*100) - CONVERT(INT,(abs(currentdue)*100))) <> 0) and sh.parent02aid in ( select bsacctid from datavalidationrecords  with(nolock) where businessday = '2020-03-31 23:59:57.000' )



--select s.AmtOfPayCurrDue , round(AmtOfPayCurrDue,2) from dbo.planinfoforreport s with(nolock)
--	  where businessday = '2020-03-31 23:59:57.000' 	  and   (((abs(AmtOfPayCurrDue)*100) - CONVERT(INT,(abs(AmtOfPayCurrDue)*100))) <> 0)

SELECT LoanDate,* FROM ILPScheduleDetailSummary WITH (NOLOCK) WHERE Activity = 2 AND ActivityAmount = 0


select count(1) from commontnp with (nolock) where trantime < getdate()





select * from datavalidationrecords with (nolock) where businessday = '2020-02-29 23:59:57' and Bsacctid = 3544612


select * from datavalidationrecords with (nolock) where businessday = '2020-02-10 23:59:57'

select top 10 * from accountinfoforreport with (nolock) where businessday = '2020-02-29 23:59:57'

select TOP 4 * from PROD1GSDB01.CCGS_CoreIssue.dbo.EODControlData with (nolock) ORDER BY BusinessDay DESC
select TOP 4 * from EODControlData with (nolock) ORDER BY BusinessDay DESC

SELECT DV.BSAcctid, DV.BusinessDay,DV.CycleDueDTD AS DVCycleDueDTD,DV.AmountOfTotalDue AS DVAmountOfTotalDue 
FROM DataValidationRecords DV WITH (NOLOCK)
JOIN AccountInfoForReport AIR WITH (NOLOCK) ON (DV.BSAcctid = AIR.BSAcctid AND DV.BusinessDay = AIR.BusinessDay)
WHERE BusinessDay >= '2020-02-01 23:59:57' AND ValidationType = 1 AND AmountOfTotalDue <= 0

select AccountNumber,Principal,institutionid,* from bsegment_primary with (nolock) where acctid = 2432211
select AccountNumber,Principal,institutionid,* from bsegment_primary with (nolock) where acctid = 2138965

select * from PROD1GSDB01.CCGS_CoreIssue.dbo.version with (nolock) order by entryid desc

select * from commontnp with (nolock) where acctid = 2041723 and tranid = 0

--PRODDRTNP68.4540(01/01/20 12:14:26) posting.cpp(3464) : Account 51:2432211 tranid 23914566084 : Posting constraints (rrBSCPSAlways_BNP_Balance) failed.

select AccountNumber,TranRef,TransactionLifeCycleUniqueID,AuthTranId,messagetypeidentifier,CardNumber4Digits,pan_hash,* from CCard_Primary with (nolock) where tranid IN (23370121386)
select AccountNumber,TransactionAmount, TxnSource,* from CCard_Primary with (nolock)
 where AccountNumber = '1100011134796105' 
 --AND tranid IN( 23130903104,23130903101 )
 order by PostTime desc


 select top 10 * from EmbossingAccounts with (nolock) where CardNumber4Digits = 6327 and pan_hash = -603919335

 select COUNT(1) from EmbossingAccounts with (nolock) where CardNumber4Digits = 6327

 select * from PROD1GSDB01.CCGS_CoreIssue.dbo.Auth_Primary with (nolock) where coreauthtranid = 

   
   SELECT jobID,AccountNumber,TransactionLifeCycleUniqueID,TraceID,AuthTranId,* FROM IPMMaster WITH(NOLOCK) WHERE CCardTranid IN(23370121386)

select * from CCard_Secondary with (nolock) where tranid IN(23914566084)

/*TranID - 23070404804, 23070404861
Transaction Description and TxnCode_internal I is NULL

TranID - 23127800590
CMTTrantype and MTCgrpName is NULL.

Pls populate in ccard and LogAr tables accordingly.
2679138

*/


select COUNT(1) from commontnp with (nolock) where trantime < getdate()

select AccountNumber,Principal,institutionid,* from bsegment_primary with (nolock) where acctid = 4311715

select principal,creditplantype,* from cpsgmentaccounts with (nolock) where parent02aid = 2679138

select AccountNumber,TransactionAmount, TxnSource,RevTgt,* from CCard_Primary with (nolock)
 where AccountNumber = '1100011100382112' order by PostTime desc

 select 849.00 + 299.00 + 112.41

 select principal,creditplantype,* from cpsgmentaccounts with (nolock) where parent02aid = 2679138
 select * from currentbalanceauditps with (nolock) where aid = 2821668 and dename = 120
 select * from currentbalanceauditps with (nolock) where aid = 8964820 and dename = 120
 select * from currentbalanceauditps with (nolock) where aid = 8978978 and dename = 120

 
 select * from currentbalanceaudit with (nolock) where aid = 2679138 and dename = 120



select TransactionDescription, TxnCode_internal,* from CCard_Primary with (nolock) where tranid IN(23157838159, 23157838160, 23157838161,23144959420)

select  MTCGrpName,TxnCode_internal,CMTTRANTYPE,* from LogArTxnAddl with (nolock) where tranid IN(23806451565)



select TransactionDescription, CMTTRANTYPE, TxnCode_internal,* from CCard_Primary with (nolock) where tranid IN(23127800590)

select  MTCGrpName,TxnCode_internal,CMTTRANTYPE,* from LogArTxnAddl with (nolock) where tranid IN(23370121386)




SELECT TxnCode_Internal, CMTTRANTYPE,TransactionDescription from CCard_Primary WITH (NOLOCK) WHERE TranID IN (23806451565)
SELECT TxnCode_Internal, CMTTRANTYPE from LogArTxnAddl WITH (NOLOCK) WHERE TranID IN (23806451565)
SELECT MTCGrpName, CMTTRANTYPE from LogArTxnAddl WITH (NOLOCK) WHERE TranID IN (23806451565)

SELECT COALESCE(Environment_Name,@@SERVERNAME) FROM CPS_Environment WITH(NOLOCK)

SELECT ClientName,ProcessName,ISNULL(Mail_recipients ,''),ISNULL(Mail_copy_recipients ,'')	FROM CPS_Emails with (nolock)

SELECT 
cast(
	 (select
	 ClientName as 'td'
	 , ''
	 , ProcessName as 'td'
	 , ''
	 , ISNULL(Mail_recipients ,'') as 'td'
	 , ''
	 , ISNULL(Mail_copy_recipients ,'') as 'td'
	 FROM CPS_Emails with (nolock)
	 --order by rank
	 for xml path('tr')
	 , elements)
	 as NVARCHAR(MAX)
	 )




Query 						SHAmtOfInterestYTD AIAmtOfInterestYTD 	SHAcountnumber 			AIAccountnumber 	Statementdate
Q14 AmtOfInterestYTD Mismatch 			16.82				10.41 	1100011101353815 		1100011101353815 	2020-04-30 23:59:57.000
Q14 AmtOfInterestYTD Mismatch 			52.64 				52.49 	1100011104379528 		1100011104379528 	2020-04-30 23:59:57.000
Q14 AmtOfInterestYTD Mismatch 			38.71 				34.07 	1100011101365165 		1100011101365165 	2020-04-30 23:59:57.000
Q14 AmtOfInterestYTD Mismatch 			326.51 				322.40 	1100011103941815 		1100011103941815 	2020-04-30 23:59:57.000
Q14 AmtOfInterestYTD Mismatch 			180.96 				139.61 	1100011105436210 		1100011105436210 	2020-04-30 23:59:57.000
Q14 AmtOfInterestYTD Mismatch 			166.98 				166.89 	1100011105438190 		1100011105438190 	2020-04-30 23:59:57.000
Q14 AmtOfInterestYTD Mismatch 			151.65 				151.31 	1100011105438653 		1100011105438653 	2020-04-30 23:59:57.000
Q14 AmtOfInterestYTD Mismatch 			47.55 				45.55 	1100011105438950 		1100011105438950 	2020-04-30 23:59:57.000
