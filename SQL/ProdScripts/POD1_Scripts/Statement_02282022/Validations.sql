--To check Percentage--

SELECT 4810624 as TotalSTMTCount, Count(1) TotalSTMTRemaining, --CONVERT(VARCHAR(10), Round( ((TOTALCOUNT *100.0)/ (SELECT SUM(TOTALCOUNT) FROM T)),2)) + '%' as Per
 Round( ((Count(1) *100.0)/ 4810624),2) 
as STMTPercentage
FROM LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.commontnp with(nolock)  where trantime  ='2021-07-31 23:59:57.000'

--To check TNP Count **********
Select 'TNP COUNT', Count(1) From LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.CommonTNP with(nolock) where trantime ='2021-07-31 23:59:58.000' 

Select 'TNP COUNT', Count(1) From LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.CommonTNP with(nolock) where trantime <'2021-07-31 23:59:57.000'

Select 'TNP COUNT', Count(1) From LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.CommonTNP with(nolock) where trantime >'2021-07-31 23:59:57.000'

SELECT * FROM LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.CommonTNP WITH (NOLOCK) WHERE Acctid = 4323407 AND trantime ='2021-07-31 23:59:58.000' 

SELECT * FROM LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.CommonTNP WITH (NOLOCK) WHERE Acctid IN (275748, 783052, 593694, 2236184, 1964069, 4228637, 1714616, 
4858998, 1020873, 1873390, 2251171, 2619108, 2734971, 3530330, 4323407, 7603336, 9812311, 13354616) 
AND trantime ='2021-07-31 23:59:58.000'


SELECT * FROM LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.CommonTNP WITH (NOLOCK) WHERE Acctid IN (2251171, 4323407, 7603336, 9812311, 
783052, 593694, 2236184, 1964069, 4228637, 1714616, 4858998, 13354616) 
AND trantime ='2021-07-31 23:59:58.000'



SELECT * FROM LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.CommonTNP WITH (NOLOCK) WHERE Acctid IN (2251171, 4323407, 7603336, 9812311) 
AND trantime ='2021-07-31 23:59:58.000'




SELECT * FROM LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.SPExecutionLog WITH (NOLOCK) WHERE BusinessDay = '2021-07-31 23:59:57.000'


--To check TNP TPS **********
declare  @count1 int 
declare  @count2 int 
select @count1= count(1) from commontnp with(nolock)  where trantime  ='2021-07-31 23:59:57.000'
waitfor delay  '00:00:30'
select @count2= count(2) from commontnp with(nolock)  where trantime  ='2021-07-31 23:59:57.00'
select 'TNP TPS', (@count1 - @count2) /30.0




SELECT BS.SystemStatus, SV.* 
FROM LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.StatementValidation SV WITH (NOLOCK) 
JOIN LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.bSegment_Primary BS WITH (NOLOCK)  ON (SV.acctId = BS.acctId AND SV.StatementDate = '2021-07-31 23:59:57.000')
WHERE SV.StatementDate = '2021-07-31 23:59:57.000' AND ValidationFail = 'Q10'
AND BS.SystemStatus <> 14
AND SV.acctId NOT IN (275748, 783052, 593694, 2236184, 1964069, 4228637, 1714616, 4858998, 1020873, 1873390, 2251171, 2619108, 2734971, 3530330
, 4323407, 7603336, 9812311, 13354616)


SELECT ValidationFail, COUNT(1) RecordCount
FROM LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.StatementValidation WITH (NOLOCK) 
WHERE StatementDate = '2021-07-31 23:59:57.000' 
GROUP BY ValidationFail
ORDER BY ValidationFail



SELECT Status, COUNT(1) 
FROM LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.StatementJobs WITH (NOLOCK)  
WHERE StatementDate = '2021-07-31 23:59:57.000'
GROUP BY Status

SELECT * 
FROM LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.StatementJobs WITH (NOLOCK)  
WHERE StatementDate = '2021-07-31 23:59:57.000'
AND acctId = 5963


SELECT BSacctId, AccountNumber, SystemStatus, ManualInitialChargeOffReason, AutoInitialChargeOffReason, ccinhparent125AID, Chargeoffdate
FROM AccountInfoForReport WITH (NOLOCK)
WHERE SystemStatus = 14 
AND BusinessDay = '2021-07-31 23:59:57' 
AND (ISNULL(ManualInitialChargeOffReason, '0') = '0' OR ManualInitialChargeOffReason = '')
AND (ISNULL(AutoInitialChargeOffReason, '0') = '0' OR AutoInitialChargeOffReason = '')


SELECT acctId, AccountNumber, SystemStatus, ManualInitialChargeOffReason, AutoInitialChargeOffReason, ccinhparent125AID, Chargeoffdate
FROM StatementHeader BP WITH (NOLOCK)
WHERE SystemStatus = 14 
AND StatementDate = '2021-07-31 23:59:57' 
AND (ISNULL(ManualInitialChargeOffReason, '0') = '0' OR ManualInitialChargeOffReason = '')
AND (ISNULL(AutoInitialChargeOffReason, '0') = '0' OR AutoInitialChargeOffReason = '')


SELECT * FROM LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.ErrorTNP WITH (NOLOCK)

SELECT COUNT(1), TranTime, ATID, priority
FROM LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.CommonTNP WITH(NOLOCK)
GROUP BY TranTime, ATID, priority
ORDER BY TranTime, priority, ATID DESC

SELECT A.CBRStatusGroup,C.LutDescription AS StatusGroup, A.StatusDescription,A.WaiveMinDue,A.WaiveMinDueFor,A.Priority,A.* 
FROM AStatusAccounts A WITH (NOLOCK)
JOIN CCardLookUp C WITH (NOLOCK) ON (A.parent01AID = C.LutCode)
WHERE C.LUTid = 'AsstPlan' AND C.LutLanguage = 'dbb' AND A.MerchantAID = 14992 AND Parent01AID = 16010
ORDER BY A.Priority

SELECT * FROM CCardLookUp WITH (NOLOCK)
WHERE Lutid = 'BSCoReason'

SELECT BP.AccountNumber, BP.UniversalUniqueID, BS.ClientID
FROM LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.BSegment_Primary BP WITH (NOLOCK)
JOIN LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.BSegment_Secondary BS WITH (NOLOCK) ON (BP.acctId = BS.acctId)
WHERE BP.acctId IN (577636,9747038,493329,1878778,1987209,2121557,2210876,2805995,3634910,3922688,4421477,4638731,
7700392,8171272,8176949,9841530,10196589,10656913,11208697,1875442,11368001,1667578)


SELECT CPS.acctId, CurrentBalance, CurrentBalanceCo, CPS.DeCurrentBalance_TranTime_PS 
FROM LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.CPSgmentAccounts CPS WITH (NOLOCK)
JOIN LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.CPSgmentCreditCard CPCC WITH (NOLOCK) ON (CPS.acctId = CPCC.acctID)
WHERE CPS.Parent02AID = 2434626

--SELECT CPS.acctId, CurrentBalance, CurrentBalanceCo, CPS.DeCurrentBalance_TranTime_PS 
--FROM LS_PRODDRGSDB01.CCGS_CoreIssue_Secondary.dbo.SummaryHeader CPS WITH (NOLOCK)
--JOIN LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.SummaryHeaderCreditCard CPCC WITH (NOLOCK) ON (CPS.acctId = CPCC.acctID)
--WHERE CPS.Parent02AID = 2434626
--AND StatementDate = '2021-07-31 23:59:57.000'

SELECT BP.acctId, BCC.AmountOfTotalDue, CycleDueDTD, SystemStatus
FROM BSegment_Primary BP WITH (NOLOCK)
JOIN BSegmentCreditCard BCC WITH (NOLOCK) ON (BP.acctId = BCC.acctId)
WHERE BCC.AmountOfTotalDue > 0 
AND BP.CycleDueDTD = 0
AND SystemStatus <> 14
AND BillingCycle <> 'LTD'


SELECT BP.acctId, BCC.AmountOfTotalDue, CycleDueDTD, SystemStatus
FROM BSegment_Primary BP WITH (NOLOCK)
JOIN BSegmentCreditCard BCC WITH (NOLOCK) ON (BP.acctId = BCC.acctId)
WHERE BCC.AmountOfTotalDue > CurrentBalance
AND CurrentBalance > 0
--AND BP.CycleDueDTD = 0
AND SystemStatus <> 14
AND BillingCycle <> 'LTD'

SELECT SH.acctId, SH.StatementID, StatementDate, CurrentBalance, SHCC.CurrentBalanceCo, SH.DeCurrentBalance_TranTime_PS , SHCC.currentdue
FROM LS_PRODDRGSDB01.ccgs_coreissue_secondary.dbo.SummaryHeader SH WITH (NOLOCK)
JOIN LS_PRODDRGSDB01.ccgs_coreissue.dbo.SummaryHeaderCreditCard SHCC WITH (NOLOCK) ON (SH.acctId = SHCC.acctId AND SH.StatementID = SHCC.StatementID)
WHERE SH.parent02AID = 2434626
ORDER BY StatementDate DESC

SELECT TOP 10 AmountOfCreditsRevCTD,AmountOfDebitsRevCTD,SH.StatementID,CurrentBalanceCO, StatementDate, SH.AmountOfTotalDue,amtofpaycurrdue,AmtOfPayXDLate,AmountOfPayment30DLate, AmountOfPayment60DLate, AmountOfPayment90DLate, AmountOfPayment120DLate,
SH.CycleDueDTD, DateOfOriginalPaymentDUeDTD, SystemStatus, CCInhParent125AID
FROM LS_PRODDRGSDB01.ccgs_coreissue_secondary.dbo.StatementHeader SH WITH (NOLOCK)
WHERE SH.acctID = 2805178
ORDER BY StatementDate DESC


SELECT NAD, LAD, LAPD FROM LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.BSegment_Primary WITH (NOLOCK) WHERE acctId = 6645903

SELECT NAD, LAD, LAPD  FROM LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.CPSgmentAccounts WITH (NOLOCK) WHERE Parent02AID = 6645903

SELECT NAD, LAD, LAPD  FROM LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.LPSegmentAccounts WITH (NOLOCK) WHERE Parent02AID = 6645903

--UPDATE BSegment_Primary SET LAD = '2021-07-31 23:59:56.000', LAPD = '2021-07-31 23:59:56.000' WHERE acctId = 6645903

SELECT LastStatementDate, DateofNextStmt,BP.AmountOfPurchasesCTD, BP.AmountOfDebitsCTD,LAD,LAPD,dtoflastdelinqctd,daysdelinquent,runningminimumdue,remainingminimumdue,ltrim(rtrim(accountnumber)) AS accountnumber,chargeoffdate, DateAcctClosed,
cycleduedtd,amountoftotaldue,amtofpaycurrdue,AmtOfPayXDLate,AmountOfPayment30DLate, AmountOfPayment60DLate, AmountOfPayment90DLate, AmountOfPayment120DLate,
daysdelinquent,nopaydaysdelinquent,BS.firstduedate,dateoforiginalpaymentduedtd
,Statementremainingbalance, sbwithinstallmentdue, srbwithinstallmentdue,amountofcreditsctd,BP.SYSTEMSTATUS,CCINHPARENT125AID,accountnumber,BP.ACCTID,amtofpaycurrdue,
amountoftotaldue,BP.CURRENTBALANCE,CURRENTBALANCECO,BP.PRINCIPAL,NEWTRANSACTIONSBSFC,NEWTRANSACTIONSAGG,
	NEWTRANSACTIONSACCRUED,REVOLVINGBSFC,REVOLVINGAGG,REVOLVINGACCRUED,AfterCycleRevolvBSFC
FROM LS_PRODDRGSDB01.ccgs_coreissue.dbo.BSEGMENT_PRIMARY BP WITH(NOLOCK)
	JOIN LS_PRODDRGSDB01.ccgs_coreissue.dbo.BSEGMENTCREDITCARD BS WITH(NOLOCK) ON (BP.ACCTID = BS.ACCTID)
WHERE  bp.acctid = 6645903

SELECT COUNT(1) FROM LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.AccountInfoForReport WITH (NOLOCK) WHERE BSacctid = 6645903 AND BusinessDay = '2021-07-31 23:59:57.000'

SELECT * FROM LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.PlanInfoForReport WITH (NOLOCK) WHERE BSacctid = 6645903 AND BusinessDay = '2021-07-31 23:59:57.000'

SELECT * FROM ArSystemAccounts WITH (NOLOCK)

SELECT AccountNumber,* FROM CCArd_Primary WITH (NOLOCK) WHERE TranID = 29507687252
SELECT AccountNumber,* FROM CCArd_Primary WITH (NOLOCK) WHERE TranRef = 29507687252

--UPDATE CCard_Primary SET TranTime = '2021-08-10 01:03:44.000', PostTime = '2021-08-10 01:03:44.000' WHERE TranID = 29507687252

--UPDATE CCard_Primary SET AccountNumber = '1100011125910459' WHERE TranID = 30251400111
--UPDATE CCard_Primary SET AccountNumber = '1100011125910459' WHERE TranID = 30378357286

--1100011123534525 11515878

SELECT COUNT(1), TranTime, ATID, priority
FROM LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.CommonTNP WITH(NOLOCK)
GROUP BY TranTime, ATID, priority
ORDER BY TranTime, priority, ATID DESC

SELECT TOP 10 * FROM EODControlData WITH (NOLOCK) ORDER BY BusinessDay DESC

SELECT TOP 10 * FROM LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.EODControlData WITH (NOLOCK) ORDER BY BusinessDay DESC

SELECT TOP 10 * FROM PROD1GSDB02.CCGS_CoreIssue.dbo.EODControlData WITH (NOLOCK) ORDER BY BusinessDay DESC

SELECT * FROM LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.SPExecutionLog WITH (NOLOCK) WHERE BusinessDay = '2021-08-01 23:59:57.000'

SELECT * FROM LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.ErrorTNP WITH (NOLOCK) 



SELECT * FROM SYS.Servers

--UPDATE StatementJobs SET Status = 'WAIT' WHERE StatementDate = '2021-08-31 23:59:57.000' AND acctId IN (7118911, 6695882, 2735002)

select * from datavalidationrecords  with(nolock) where businessday = '2021-07-31 23:59:57'

select ManualInitialChargeOffReason, Chargeoffdate, bp.acctid 
from LS_PRODDRGSDB01.ccgs_coreissue.dbo.bsegment_primary bp with (nolock)
join LS_PRODDRGSDB01.ccgs_coreissue.dbo.bsegmentcreditcard bcc with (nolock) on (bp.acctid = bcc.acctid)
where systemstatus = 14 and ManualInitialChargeOffReason = '0' --AND Chargeoffdate = '2021-07-31 23:59:55.000'
ORDER BY BP.acctId

select COUNT(1) from bsegment_primary bp with (nolock) join bsegmentcreditcard bcc with (nolock) on (bp.acctid = bcc.acctid)
where systemstatus = 14 and ManualInitialChargeOffReason = '0'

select ManualInitialChargeOffReason, Chargeoffdate, bp.acctid 
from bsegment_primary bp with (nolock)
join bsegmentcreditcard bcc with (nolock) on (bp.acctid = bcc.acctid)
where systemstatus = 14 and ManualInitialChargeOffReason = '0' --AND Chargeoffdate = '2021-07-31 23:59:55.000'


select s.currentdue ,round(currentdue,2),sh.acctid, sh.Parent02AID  
from LS_PRODDRGSDB01.ccgs_coreissue.dbo.Summaryheadercreditcard s  with(nolock)
join  LS_PRODDRGSDB01.ccgs_coreissue_secondary.dbo.Summaryheader  sh with(nolock) on (s.acctid = sh.acctid and s.statementid = sh.statementid )
where statementdate = '2021-07-31 23:59:57.000'   and   (((abs(currentdue)*100) - CONVERT(INT,(abs(currentdue)*100))) <> 0) 
and sh.parent02aid in ( select bsacctid from datavalidationrecords  with(nolock) where businessday = '2021-07-31 23:59:57.000' )

select s.AmtOfPayCurrDue , round(AmtOfPayCurrDue,2) 
from LS_PRODDRGSDB01.ccgs_coreissue.dbo.planinfoforreport s with(nolock)
where businessday = '2021-07-31 23:59:57.000'
and (((abs(AmtOfPayCurrDue)*100) - CONVERT(INT,(abs(AmtOfPayCurrDue)*100))) <> 0)

select s.AmtOfPayCurrDue , round(AmtOfPayCurrDue,2) from dbo.planinfoforreport s with(nolock)
where businessday = '2021-07-31 23:59:57.000'
and (((abs(AmtOfPayCurrDue)*100) - CONVERT(INT,(abs(AmtOfPayCurrDue)*100))) <> 0)

SELECT acctId, AccountNumber 
FROM Bsegment_Primary WITH (NOLOCK)
WHERE AccountNumber IN ('1100011140400312' ,'1100011117751069' ,'1100011122652195' ,'1100011104323906' ,'1100011124146568' ,'1100011105609907')

SELECT acctId, AccountNumber 
FROM Bsegment_Primary WITH (NOLOCK)
WHERE AccountNumber IN ('1100011146134667 ')



SELECT SH1.StatementDate, 
SH2.AmountOfTotalDue - SH1.AmountOfTotalDue AS AmountOfTotalDue,
SH2.AmtofPayCurrDue - SH1.AmtofPayCurrDue AS AmtofPayCurrDue,
SH2.AmtOfPayXDLate - SH1.AmtOfPayXDLate AS AmtOfPayXDLate,
SH2.AmountOfPayment30DLate - SH1.AmountOfPayment30DLate AS AmountOfPayment30DLate, 
SH2.AmountOfPayment60DLate -SH1.AmountOfPayment60DLate AS AmountOfPayment60DLate, 
SH2.AmountOfPayment90DLate - SH1.AmountOfPayment90DLate AS AmountOfPayment90DLate, 
SH2.AmountOfPayment120DLate - SH1.AmountOfPayment120DLate AS AmountOfPayment120DLate,
SH1.CycleDueDTD
FROM LS_PRODDRGSDB01.ccgs_coreissue_secondary.dbo.StatementHeader SH1 WITH (NOLOCK)
JOIN LS_PRODDRGSDB01.ccgs_coreissue_secondary.dbo.StatementHeader SH2 WITH (NOLOCK) 
ON (SH1.acctId = SH2.acctId AND SH1.StatementDate = '2021-07-31 23:59:57.000' AND SH2.StatementDate = '2021-07-31 23:59:57.000')
WHERE SH1.acctID = 2684128


SELECT SH1.StatementDate, SH1.AmountOfTotalDue,SH1.amtofpaycurrdue,SH1.AmtOfPayXDLate,SH1.AmountOfPayment30DLate, SH1.AmountOfPayment60DLate, SH1.AmountOfPayment90DLate, SH1.AmountOfPayment120DLate,SH1.CycleDueDTD, 
SH2.StatementDate, SH2.AmountOfTotalDue,SH2.amtofpaycurrdue,SH2.AmtOfPayXDLate,SH2.AmountOfPayment30DLate, SH2.AmountOfPayment60DLate, SH2.AmountOfPayment90DLate, SH2.AmountOfPayment120DLate,SH2.CycleDueDTD
FROM LS_PRODDRGSDB01.ccgs_coreissue_secondary.dbo.StatementHeader SH1 WITH (NOLOCK)
JOIN LS_PRODDRGSDB01.ccgs_coreissue_secondary.dbo.StatementHeader SH2 WITH (NOLOCK) 
ON (SH1.acctId = SH2.acctId AND SH1.StatementDate = '2021-07-31 23:59:57.000' AND SH2.StatementDate = '2021-07-31 23:59:57.000')
WHERE SH1.acctID = 2684128

Begin Tran
	Update ErrorTnp  set Trantime = getdate()  where tranid =0  and atid =51
	-- 569 row update 
Commit Tran 

---step 2

BEGIN TRANSACTION


	INSERT INTO TempErrortnp(tnpdate,priority,TranTime,TranId,ATID,acctId,ttid,NADandROOFlag,GetAllTNPJobsFlag,Errorreason)
	SELECT E.tnpdate,E.priority,E.TranTime,E.TranId,E.ATID,E.acctId,E.ttid,E.NADandROOFlag,E.GetAllTNPJobsFlag,E.Errorreason 
	FROM ErrorTNP E WITH (NOLOCK)
	LEFT JOIN CommonTNP C WITH (NOLOCK) ON (E.acctId = C.acctId AND C.TranID = 0)
	WHERE C.acctID IS NOT NULL
	--14  row insert 
	
	INSERT INTO CommonTNP(tnpdate,priority,TranTime,TranId,ATID,acctId,ttid,NADandROOFlag,GetAllTNPJobsFlag,Retries,InstitutionID)
	SELECT E.tnpdate,E.priority,E.TranTime,E.TranId,E.ATID,E.acctId,E.ttid,E.NADandROOFlag,E.GetAllTNPJobsFlag,0,6981 
	FROM ErrorTNP E WITH (NOLOCK)
	LEFT JOIN CommonTNP C WITH (NOLOCK) ON (E.acctId = C.acctId AND C.TranID = 0)
	WHERE C.acctID IS NULL AND E.ATID = 51 AND E.TranID = 0
	---555 Row insert

	DELETE FROM ErrorTNP  where  atid =51  and Tranid = 0 
	--569 row delete 
				
COMMIT
