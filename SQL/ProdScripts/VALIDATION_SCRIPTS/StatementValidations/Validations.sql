--To check Percentage--

SELECT 6816425 as TotalSTMTCount, 
Count(1) TotalSTMTRemaining, --CONVERT(VARCHAR(10), Round( ((TOTALCOUNT *100.0)/ (SELECT SUM(TOTALCOUNT) FROM T)),2)) + '%' as Per
Round( ((Count(1) *100.0)/ 6816425),2) RemainingSTMTPercentage
FROM commontnp with(nolock)  
where trantime  ='2025-07-31 23:59:57'

SELECT COUNT(1) FROM StatementHeader WITH (NOLOCK) WHERE StatementDate ='2025-07-31 23:59:57' 

SELECT COUNT(1) FROM BSegment_Primary WITH (NOLOCK) WHERE BillingCycle = '31'

SELECT COUNT(1) FROM CommonTNP WITH (NOLOCK) WHERE ATID = 51 AND TranID = 0

SELECT * FROM CCard_Primary WITH (NOLOCK) WHERE CMTTRanType = '21' AND ARTXNTYPE IS NULL AND PostTime BETWEEN '2025-04-30 23:29:00.000' AND '2025-07-31 23:59:57'

SELECT * FROM Trans_In_Acct WITH (NOLOCK) WHERE Tran_Id_Index = 126790990464


--To check TNP Count **********
Select 'TNP COUNT', Count(1) FROM CommonTNP with(nolock) where trantime ='2025-07-31 23:59:57' 

Select 'TNP COUNT', Count(1) FROM CommonTNP with(nolock) where trantime <'2025-07-31 23:59:57'

Select 'TNP COUNT', Count(1) FROM CommonTNP with(nolock) where trantime >'2025-07-31 23:59:57'

Select 'TNP COUNT', Count(1) FROM CommonTNP with(nolock) where trantime < GETDATE()
Select 'AP COUNT', Count(1) FROM CommonAP with(nolock) where trantime < GETDATE()

SELECT * FROM CommonTNP WITH (NOLOCK) WHERE Acctid = 4323407 AND trantime ='2025-04-30 23:59:58.000' 

SELECT * FROM ArSystemAccounts WITH (NOLOCK)

SELECT * FROM ArSystemHSAccounts WITH (NOLOCK)

SELECT * FROM CommonTNP WITH (NOLOCK) 
WHERE Acctid IN (7819098, 2986959, 12125607, 4346940, 6404696, 12400964, 18251859, 18683978, 19385355) 
AND trantime ='2025-04-30 23:59:58.000'


SELECT * FROM CommonTNP WITH (NOLOCK) WHERE Acctid IN (2251171, 4323407, 7603336, 9812311, 
783052, 593694, 2236184, 1964069, 4228637, 1714616, 4858998, 13354616) 
AND trantime ='2025-04-30 23:59:58.000'

SELECT * FROM ErrorTNP WITH (NOLOCK)

SELECT * FROM ErrorAP WITH (NOLOCK)

--73295299360,73422227995,73436534725
select * FROM arsystemaccounts with(nolock)


SELECT * FROM CommonTNP WITH (NOLOCK) WHERE Acctid IN (12946127) 
AND trantime ='2025-04-30 23:59:58.000'

SELECT TOP 10 * FROM CommonTNP WITH(NOLOCK) ORDER BY TranTime 

SELECT BP.LastStatementDate, BP.LAD, BP.LAPD, BP.NAD, E.* FROM ErrorTNP E WITH (NOLOCK) 
JOIN Bsegment_Primary BP WITH(NOLOCK) ON(E.AcctID = BP.AcctID)

SELECT  E.* FROM ErrorTNP E WITH (NOLOCK) 

SELECT * FROM SPExecutionLog WITH (NOLOCK) WHERE BusinessDay = '2025-07-31 23:59:57'

SELECT *, ROUND((DATEDIFF(SS, StartTime, EndTime)/60.0),2) TimeElapsedInMinutes FROM SPExecutionLog WITH (NOLOCK) WHERE BusinessDay = '2025-07-31 23:59:57'

SELECT * FROM EODControlData WITH (NOLOCK) WHERE BusinessDay = '2025-07-31 23:59:57'

SELECT * FROM EODSelectIntoJob WITH (NOLOCK) WHERE BusinessDay = '2025-07-31 23:59:57' ORDER BY Skey DESC

SELECT * FROM EODSelectIntoJob WITH (NOLOCK) WHERE BusinessDay = '2025-05-31 23:59:57' ORDER BY Skey DESC

SELECT * FROM ArSystemAccounts WITH (NOLOCK)
SELECT * FROM ArSystemHSAccounts WITH (NOLOCK)

SELECT COUNT(1) FROM AccountInfoForReport WITH(NOLOCK) WHERE BusinessDay = '2025-07-31 23:59:57'

SELECT * FROM eodintermediatedata WITH (NOLOCK) WHERE BusinessDay = '2025-07-31 23:59:57'



SELECT BSacctID, AccountNumber,* FROM CCArd_Primary WITH (NOLOCK) WHERE PostTime = '2025-07-31 23:59:57' AND CMTtRanType = '51'

SELECT 'UPDATE TOP(1) StatementHeader SET TempCreditLimit = ' + TRY_CAST(TempCreditLimit AS VARCHAR) + ' WHERE acctID = ' + TRY_CAST(acctID AS VARCHAR) + ' AND StatementDate = ''2025-04-30 23:59:57'''
,TempCreditLimit, acctId 
FROM BSegment_Primary WITH (NOLOCK)
WHERE acctID IN (2287990,17964617,18725568,20755944)

SELECT TempCreditLimit, acctID 
FROM LS_P1MARPRODDB01.ccgs_CoreIssue_Secondary.dbo.StatementHeader WITH (NOLOCK)
WHERE acctID IN (2287990,17964617,18725568,20755944)
AND StatementDate = '2025-07-31 23:59:57'

--81577998077,81791356456,81807698177,81825584694

SELECT DATEDIFF(MINUTE, '2024-11-01 13:40:27.293', '2024-11-01 14:28:49.293')


SELECT DATEADD(MINUTE, 630, '2024-12-01 14:15:38.067')


--To check TNP TPS **********

DECLARE @ISTDelta INT = 60*9+30, @count1 int, @count2 int , @TPSTime DECIMAL = 30.0, @ETA DATETIME, @ETASeconds INT, @TPS DECIMAL
select @count1= COUNT(1) FROM CommonTNP WITH(NOLOCK) WHERE TranTime  ='2025-07-31 23:59:57'
--SELECT @Count1, GETDATE()
WAITFOR DELAY '00:00:30'
SELECT @count2= COUNT(1) FROM CommonTNP WITH(NOLOCK) WHERE TranTime  ='2025-07-31 23:59:57'
--SELECT @Count2, GETDATE()
SET @TPS = (@count1 - @count2) /@TPSTime
SET @ETASeconds = @Count2/@TPS
SET @ETA = DATEADD(SECOND, @ETASeconds, GETDATE())
SELECT @count1 JobsBefore, @count2 JobsLeft, 6816425-@count2 JobsCompleted, ROUND(((6816425-@count2)/6816425.0)*100, 2) '% Completed', @TPS TPS, 
@ETASeconds/60.0/60.0 HoursRemaining, @ETA ETA, DATEADD(MINUTE, @ISTDelta, @ETA) ETA_IST
--, ROUND((@count2*1.0)/((@count1 - @count2) /30.0)/60/60, 2) EstimatedHoursRemaining

--select 'TNP TPS', (@count1 - @count2) /30.0

--SELECT @count1 JobsBefore, @count2 JobsLeft, 6816425-@count2 JobsCompleted,(@count1 - @count2) /30.0 TPS
--, ROUND((@count2*1.0)/((@count1 - @count2) /30.0)/60/60, 2) EstimatedHoursRemaining
----, TRY_CAST(TRY_CAST((@count2/(@count1 - @count2) /30.0)/60/60 AS INT) AS VARCHAR) + 'H' + TRY_CAST(TRY_CAST((@count2/((@count1 - @count2) /30.0)/60)%60 AS INT) AS VARCHAR) + 'Min'




--To check TNP TPS **********
declare  @count1 int 
declare  @count2 int 
select @count1= count(1) FROM commontnp with(nolock)  where trantime  < GetDate()
SELECT @Count1
waitfor delay  '00:00:30'
select @count2= count(2) FROM commontnp with(nolock)  where trantime  < GetDate()
SELECT @Count2
select 'TNP TPS', (@count1 - @count2) /30.0


--12976604, 499372, 2779857

SELECT * FROM StatementValidation SV WITH (NOLOCK) WHERE StatementDate = '2025-07-31 23:59:57.000' AND ValidationFail = 'Q1'

SELECT BS.SystemStatus, SV.* 
FROM StatementValidation SV WITH (NOLOCK) 
JOIN bSegment_Primary BS WITH (NOLOCK)  ON (SV.acctId = BS.acctId AND SV.StatementDate = '2025-07-31 23:59:57')
JOIN StatementJobs SJ WITH (NOLOCK)  ON (SJ.acctId = BS.acctId AND SJ.StatementDate = '2025-07-31 23:59:57')
WHERE SV.StatementDate = '2025-07-31 23:59:57' AND ValidationFail = 'Q6'
--AND SV.acctid not in (10801039,4260196,4955353,4321453,2761449,2432280,1169475)
--AND BS.SystemStatus <> 14 --AND BS.acctId = 9852666

SELECT BS.SystemStatus, SV.* 
FROM StatementValidation SV WITH (NOLOCK) 
JOIN bSegment_Primary BS WITH (NOLOCK)  ON (SV.acctId = BS.acctId AND SV.StatementDate = '2025-07-31 23:59:57')
JOIN StatementJobs SJ WITH (NOLOCK)  ON (SJ.acctId = BS.acctId AND SJ.StatementDate = '2025-07-31 23:59:57')
WHERE SV.StatementDate = '2025-07-31 23:59:57' AND ValidationFail = 'Q9'
AND SV.acctid not in (10801039,4260196,4955353,4321453,2761449,2432280,1169475)
AND BS.SystemStatus = 14 --AND BS.acctId = 9852666

SELECT BS.SystemStatus, SV.* 
FROM StatementValidation SV WITH (NOLOCK) 
JOIN bSegment_Primary BS WITH (NOLOCK)  ON (SV.acctId = BS.acctId AND SV.StatementDate = '2025-07-31 23:59:57')
JOIN StatementJobs SJ WITH (NOLOCK)  ON (SJ.acctId = BS.acctId AND SJ.StatementDate = '2025-07-31 23:59:57')
WHERE SV.StatementDate = '2025-07-31 23:59:57' --AND ValidationFail = 'Q20'
AND SV.acctid in (906917)

SELECT BS.SystemStatus, SV.* 
FROM StatementValidation SV WITH (NOLOCK) 
JOIN bSegment_Primary BS WITH (NOLOCK)  ON (SV.acctId = BS.acctId AND SV.StatementDate = '2025-07-31 23:59:57')
WHERE SV.StatementDate = '2025-07-31 23:59:57' AND ValidationFail = 'Q29'
AND SV.acctid not in (10801039,4260196,4955353,4321453,2761449,2432280,1169475)
AND BS.SystemStatus <> 14 
ORDER BY SV.AcctID DESC
--AND SV.MergeCycle IS NULL
--AND SV.MergeCycle = 1
--AND SV.acctId NOT IN (12415, 13524, 14117, 47850, 52711, 115716, 122810, 244248, 417786, 588281, 659234, 883659, 1240951, 
--1255358, 1344799, 1356278, 1378174, 1392139, 1508643, 1722050, 1841625, 1845697, 2105008, 2706267, 2724147, 2837196, 2983913,
--3996361, 7853217, 8940606, 9806096, 10655987, 11089488, 11520974, 13572797, 13611044, 18041996, 18390195, 13071394, 20602937, 
--14886219, 16564141, 18074751, 18310493, 18533310)


SELECT ValidationFail, SVL.ValidationDescription FailureReason, COUNT(1) RecordCount
FROM StatementValidation SV WITH (NOLOCK) 
--JOIN StatementJobs SJ WITH (NOLOCK)  ON (SJ.acctId = SV.acctId AND SJ.StatementDate = '2025-07-31 23:59:57')
LEFT OUTER JOIN StatementValidationLookup SVL WITH (NOLOCK) ON (SVL.ValidationNumber = SV.ValidationFail)
WHERE SV.StatementDate = '2025-07-31 23:59:57' 
GROUP BY ValidationFail, SVL.ValidationDescription
ORDER BY COUNT(1) DESC, ValidationFail, SVL.ValidationDescription



SELECT ValidationFail, SVL.ValidationDescription FailureReason, COUNT(1) RecordCount
FROM StatementValidation SV WITH (NOLOCK) 
JOIN StatementJobs SJ WITH (NOLOCK)  ON (SJ.acctId = SV.acctId AND SJ.StatementDate = '2025-07-31 23:59:57')
LEFT OUTER JOIN StatementValidationLookup SVL WITH (NOLOCK) ON (SVL.ValidationNumber = SV.ValidationFail)
WHERE SV.StatementDate = '2025-07-31 23:59:57' 
GROUP BY ValidationFail, SVL.ValidationDescription
ORDER BY COUNT(1) DESC, ValidationFail, SVL.ValidationDescription




SELECT * FROM StatementValidationLookup CL WITH (NOLOCK) 


SELECT Status, COUNT(1) 
FROM StatementJobs WITH (NOLOCK)  
WHERE StatementDate = '2025-07-31 23:59:57'
GROUP BY Status

SELECT Status, * 
FROM StatementJobs WITH (NOLOCK)  
WHERE StatementDate = '2025-07-31 23:59:57'
AND acctId IN (11491085, 542149, 15475831, 12911559, 5600113, 18085300, 1342040)

SELECT NewCardStatus, *
FROM Customer WITH (NOLOCK)
WHERE BSAcctID = 853493


SELECT BSacctId, AccountNumber, SystemStatus, ManualInitialChargeOffReason, AutoInitialChargeOffReason, ccinhparent125AID, Chargeoffdate
FROM AccountInfoForReport WITH (NOLOCK)
WHERE SystemStatus = 14 
AND BusinessDay = '2025-04-30 23:59:57' 
AND (ISNULL(ManualInitialChargeOffReason, '0') = '0' OR ManualInitialChargeOffReason = '')
AND (ISNULL(AutoInitialChargeOffReason, '0') = '0' OR AutoInitialChargeOffReason = '')


SELECT acctId, AccountNumber, SystemStatus, ManualInitialChargeOffReason, AutoInitialChargeOffReason, ccinhparent125AID, Chargeoffdate
FROM StatementHeader BP WITH (NOLOCK)
WHERE SystemStatus = 14 
AND StatementDate = '2025-04-30 23:59:57' 
AND (ISNULL(ManualInitialChargeOffReason, '0') = '0' OR ManualInitialChargeOffReason = '')
AND (ISNULL(AutoInitialChargeOffReason, '0') = '0' OR AutoInitialChargeOffReason = '')


SELECT * FROM ErrorTNP WITH (NOLOCK) WHERE acctID = 4277019

SELECT * FROM CCard_Primary WITH (NOLOCK) WHERE TranID = 69080722552

SELECT COUNT(1), TranTime, ATID, priority
FROM CommonTNP WITH(NOLOCK)
GROUP BY TranTime, ATID, priority
ORDER BY TranTime, priority, ATID DESC

SELECT JobStatus, Posttime,* FROM LS_P1MARPRODDB01.ccgs_CoreAuth.dbo.RetailAuthJobs WITH (NOLOCK) WHERE JobStatus = 'New' AND Posttime <GetDate()

SELECT A.CBRStatusGroup,C.LutDescription AS StatusGroup, A.StatusDescription,A.WaiveMinDue,A.WaiveMinDueFor,A.Priority,A.* 
FROM AStatusAccounts A WITH (NOLOCK)
JOIN CCardLookUp C WITH (NOLOCK) ON (A.parent01AID = C.LutCode)
WHERE C.LUTid = 'AsstPlan' AND C.LutLanguage = 'dbb' AND A.MerchantAID = 14992 AND Parent01AID = 16010
ORDER BY A.Priority

SELECT * FROM CCardLookUp WITH (NOLOCK)
WHERE Lutid = 'BSCoReason'

SELECT BP.AccountNumber, BP.UniversalUniqueID, BS.ClientID
FROM BSegment_Primary BP WITH (NOLOCK)
JOIN BSegment_Secondary BS WITH (NOLOCK) ON (BP.acctId = BS.acctId)
WHERE BP.acctId IN (577636,9747038,493329,1878778,1987209,2121557,2210876,2805995,3634910,3922688,4421477,4638731,
7700392,8171272,8176949,9841530,10196589,10656913,11208697,1875442,11368001,1667578)


SELECT CPS.acctId, CurrentBalance, CurrentBalanceCo, CPS.DeCurrentBalance_TranTime_PS 
FROM CPSgmentAccounts CPS WITH (NOLOCK)
JOIN CPSgmentCreditCard CPCC WITH (NOLOCK) ON (CPS.acctId = CPCC.acctID)
WHERE CPS.Parent02AID = 2434626

--SELECT CPS.acctId, CurrentBalance, CurrentBalanceCo, CPS.DeCurrentBalance_TranTime_PS 
--FROM LS_P1MARPRODDB01.ccgs_CoreIssue_Secondary.dbo.SummaryHeader CPS WITH (NOLOCK)
--JOIN SummaryHeaderCreditCard CPCC WITH (NOLOCK) ON (CPS.acctId = CPCC.acctID)
--WHERE CPS.Parent02AID = 2434626
--AND StatementDate = '2025-07-31 23:59:57'

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
FROM LS_P1MARPRODDB01.ccgs_coreissue_secondary.dbo.SummaryHeader SH WITH (NOLOCK)
JOIN SummaryHeaderCreditCard SHCC WITH (NOLOCK) ON (SH.acctId = SHCC.acctId AND SH.StatementID = SHCC.StatementID)
WHERE SH.parent02AID = 2434626
ORDER BY StatementDate DESC

SELECT TOP 10 AmountOfCreditsRevCTD,AmountOfDebitsRevCTD,SH.StatementID,CurrentBalanceCO, StatementDate, SH.AmountOfTotalDue,amtofpaycurrdue,AmtOfPayXDLate,AmountOfPayment30DLate, AmountOfPayment60DLate, AmountOfPayment90DLate, AmountOfPayment120DLate,
SH.CycleDueDTD, DateOfOriginalPaymentDUeDTD, SystemStatus, CCInhParent125AID
FROM LS_P1MARPRODDB01.ccgs_coreissue_secondary.dbo.StatementHeader SH WITH (NOLOCK)
WHERE SH.acctID = 2805178
ORDER BY StatementDate DESC


SELECT NAD, LAD, LAPD FROM BSegment_Primary WITH (NOLOCK) WHERE acctId = 6645903

SELECT NAD, LAD, LAPD  FROM CPSgmentAccounts WITH (NOLOCK) WHERE Parent02AID = 6645903

SELECT NAD, LAD, LAPD  FROM LPSegmentAccounts WITH (NOLOCK) WHERE Parent02AID = 6645903

--UPDATE BSegment_Primary SET LAD = '2025-04-30 23:59:56.000', LAPD = '2025-04-30 23:59:56.000' WHERE acctId = 6645903

SELECT LastStatementDate, DateofNextStmt,BP.AmountOfPurchasesCTD, BP.AmountOfDebitsCTD,LAD,LAPD,dtoflastdelinqctd,daysdelinquent,runningminimumdue,remainingminimumdue,ltrim(rtrim(accountnumber)) AS accountnumber,chargeoffdate, DateAcctClosed,
cycleduedtd,amountoftotaldue,amtofpaycurrdue,AmtOfPayXDLate,AmountOfPayment30DLate, AmountOfPayment60DLate, AmountOfPayment90DLate, AmountOfPayment120DLate,
daysdelinquent,nopaydaysdelinquent,BS.firstduedate,dateoforiginalpaymentduedtd
,Statementremainingbalance, sbwithinstallmentdue, srbwithinstallmentdue,amountofcreditsctd,BP.SYSTEMSTATUS,CCINHPARENT125AID,accountnumber,BP.ACCTID,amtofpaycurrdue,
amountoftotaldue,BP.CURRENTBALANCE,CURRENTBALANCECO,BP.PRINCIPAL,NEWTRANSACTIONSBSFC,NEWTRANSACTIONSAGG,
	NEWTRANSACTIONSACCRUED,REVOLVINGBSFC,REVOLVINGAGG,REVOLVINGACCRUED,AfterCycleRevolvBSFC
FROM BSEGMENT_PRIMARY BP WITH(NOLOCK)
	JOIN BSEGMENTCREDITCARD BS WITH(NOLOCK) ON (BP.ACCTID = BS.ACCTID)
WHERE  bp.acctid = 6645903

SELECT COUNT(1) FROM AccountInfoForReport WITH (NOLOCK) WHERE BSacctid = 6645903 AND BusinessDay = '2025-07-31 23:59:57'

SELECT * FROM PlanInfoForReport WITH (NOLOCK) WHERE BSacctid = 6645903 AND BusinessDay = '2025-07-31 23:59:57'

SELECT * FROM ArSystemAccounts WITH (NOLOCK)

SELECT AccountNumber,* FROM CCArd_Primary WITH (NOLOCK) WHERE TranID = 29507687252
SELECT AccountNumber,* FROM CCArd_Primary WITH (NOLOCK) WHERE TranRef = 29507687252

--UPDATE CCard_Primary SET TranTime = '2021-08-10 01:03:44.000', PostTime = '2021-08-10 01:03:44.000' WHERE TranID = 29507687252

--UPDATE CCard_Primary SET AccountNumber = '1100011125910459' WHERE TranID = 30251400111
--UPDATE CCard_Primary SET AccountNumber = '1100011125910459' WHERE TranID = 30378357286

--1100011123534525 11515878

SELECT COUNT(1), TranTime, ATID, priority
FROM CommonTNP WITH(NOLOCK)
GROUP BY TranTime, ATID, priority
ORDER BY TranTime, priority, ATID DESC

SELECT TOP 10 * FROM EODControlData WITH (NOLOCK) ORDER BY BusinessDay DESC

SELECT TOP 10 * FROM EODControlData WITH (NOLOCK) ORDER BY BusinessDay DESC

SELECT TOP 10 * FROM PROD1GSDB02.EODControlData WITH (NOLOCK) ORDER BY BusinessDay DESC

SELECT * FROM SPExecutionLog WITH (NOLOCK) WHERE BusinessDay = '2021-08-01 23:59:57.000'

SELECT * FROM ErrorTNP WITH (NOLOCK) 



SELECT * FROM SYS.Servers

--UPDATE StatementJobs SET Status = 'WAIT' WHERE StatementDate = '2025-07-31 23:59:57' AND acctId IN (7118911, 6695882, 2735002)

select * FROM datavalidationrecords  with(nolock) where businessday = '2025-04-30 23:59:57'

select ManualInitialChargeOffReason, Chargeoffdate, bp.acctid 
FROM bsegment_primary bp with (nolock)
JOIN bsegmentcreditcard bcc with (nolock) on (bp.acctid = bcc.acctid)
where systemstatus = 14 and ManualInitialChargeOffReason = '0' --AND Chargeoffdate = '2025-04-30 23:59:55.000'
ORDER BY BP.acctId

select COUNT(1) FROM bsegment_primary bp with (nolock) JOIN bsegmentcreditcard bcc with (nolock) on (bp.acctid = bcc.acctid)
where systemstatus = 14 and ManualInitialChargeOffReason = '0'

select ManualInitialChargeOffReason, Chargeoffdate, bp.acctid 
FROM bsegment_primary bp with (nolock)
JOIN bsegmentcreditcard bcc with (nolock) on (bp.acctid = bcc.acctid)
where systemstatus = 14 and ManualInitialChargeOffReason = '0' --AND Chargeoffdate = '2025-04-30 23:59:55.000'


select s.currentdue ,round(currentdue,2),sh.acctid, sh.Parent02AID  
FROM Summaryheadercreditcard s  with(nolock)
JOIN  LS_P1MARPRODDB01.ccgs_coreissue_secondary.dbo.Summaryheader  sh with(nolock) on (s.acctid = sh.acctid and s.statementid = sh.statementid )
where statementdate = '2025-07-31 23:59:57'   and   (((abs(currentdue)*100) - CONVERT(INT,(abs(currentdue)*100))) <> 0) 
and sh.parent02aid in ( select bsacctid FROM datavalidationrecords  with(nolock) where businessday = '2025-07-31 23:59:57' )

select s.AmtOfPayCurrDue , round(AmtOfPayCurrDue,2) 
FROM planinfoforreport s with(nolock)
where businessday = '2025-07-31 23:59:57'
and (((abs(AmtOfPayCurrDue)*100) - CONVERT(INT,(abs(AmtOfPayCurrDue)*100))) <> 0)

select s.AmtOfPayCurrDue , round(AmtOfPayCurrDue,2) FROM dbo.planinfoforreport s with(nolock)
where businessday = '2025-07-31 23:59:57'
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
FROM LS_P1MARPRODDB01.ccgs_coreissue_secondary.dbo.StatementHeader SH1 WITH (NOLOCK)
JOIN LS_P1MARPRODDB01.ccgs_coreissue_secondary.dbo.StatementHeader SH2 WITH (NOLOCK) 
ON (SH1.acctId = SH2.acctId AND SH1.StatementDate = '2025-07-31 23:59:57' AND SH2.StatementDate = '2025-07-31 23:59:57')
WHERE SH1.acctID = 2684128


SELECT SH1.StatementDate, SH1.AmountOfTotalDue,SH1.amtofpaycurrdue,SH1.AmtOfPayXDLate,SH1.AmountOfPayment30DLate, SH1.AmountOfPayment60DLate, SH1.AmountOfPayment90DLate, SH1.AmountOfPayment120DLate,SH1.CycleDueDTD, 
SH2.StatementDate, SH2.AmountOfTotalDue,SH2.amtofpaycurrdue,SH2.AmtOfPayXDLate,SH2.AmountOfPayment30DLate, SH2.AmountOfPayment60DLate, SH2.AmountOfPayment90DLate, SH2.AmountOfPayment120DLate,SH2.CycleDueDTD
FROM LS_P1MARPRODDB01.ccgs_coreissue_secondary.dbo.StatementHeader SH1 WITH (NOLOCK)
JOIN LS_P1MARPRODDB01.ccgs_coreissue_secondary.dbo.StatementHeader SH2 WITH (NOLOCK) 
ON (SH1.acctId = SH2.acctId AND SH1.StatementDate = '2025-07-31 23:59:57' AND SH2.StatementDate = '2025-07-31 23:59:57')
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
