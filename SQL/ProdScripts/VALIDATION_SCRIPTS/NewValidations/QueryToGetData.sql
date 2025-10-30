--a342c422-f35e-4ffc-bb64-4cdd1daea671

--e4844511-625d-483f-9961-3cdf11d6f237

--f9d73427-33b0-4802-883d-966a35e5daf5

-- not charged off account where current balance  < 0 
select srbwithinstallmentdue,currentbalance + currentbalanceco cbco,acctid ,systemstatus,cycleduedtd,statementdate,disputesamtns into #temp1 
from  statementheader with(nolock) 
 where srbwithinstallmentdue > currentbalance  and systemstatus <>14   and  currentbalance <=  0 
 and   cycleduedtd > 1    
  order by statementdate  desc

  SELECT * FROM #Temp1 WHERE acctId = 11412924
  
  SELECT * FROM #Temp1 order BY AcctId
 

 --drop table #temp2

 DROP TABLE IF EXISTS #temp2
 SELECT T.acctId,Scheduledeletedon,statementdate,SchedulecreatedOn,ScheduleId INTO #temp2 FROM PaymentSchedule PS WITH (NOLOCK)
JOIN #temp1 T WITH (NOLOCk) ON (PS.Acctid = T.Acctid) WHERE PS.frequency not in (4)

SELECT * FROM #Temp2 ORDER BY ScheduleId

SELECT * FROM #Temp2 WHERE acctId = 11412924

SELECT T.acctId,Scheduledeletedon,statementdate,SchedulecreatedOn,ScheduleId, PS.frequency FROM PaymentSchedule PS WITH (NOLOCK)
JOIN #temp1 T WITH (NOLOCk) ON (PS.Acctid = T.Acctid)
WHERE T.acctId = 11412924


Select  OriginalPaymentAmount,accountnumber,* from #temp2 T JOIN achintermediate AI with (nolock) ON (AI.PymtScheduleId = T.scheduleid)
 where PaymentAmount >0 and sendflag=4

 SELECT sendflag, * FROm ACHIntermediate WITH (NOLOCK) WHERE acctId = 11412924 ORDER BY UniqueID DESC

 SELECT SchedulecreatedOn, * FROm PaymentSchedule WITH (NOLOCK) WHERE acctId = 11412924 ORDER BY ScheduleId DESC



 DROP TABLE IF EXISTS #final
 Select  T.StatementDate, BP.acctId, AI.AccountNumber,AI.PymtScheduleId AS PaymentScheduleId,AI.ACHPaymentDate,PaymentAmount
 ,CASE WHEN AI.Frequency  =0 THEN 'Monthly Specific Day'
      WHEN AI.Frequency  =1 THEN 'Payment Due Date'
	  WHEN AI.Frequency  =3 THEN 'Weekly'
	  WHEN AI.Frequency  =6 THEN 'Bi-Weekly'
	  WHEN AI.Frequency  =7 THEN 'Semi-Monthly'
	   WHEN AI.Frequency  =2 THEN 'One Time' 
	  END AS Frequency
 --,A.srbwithinstallmentdue,A.currentbalance
 ,BP.UniversalUniqueId AS AccountUUID 
 ,ST.disputesamtns DisputeAmtAtStmt, BS.DisputesAmtNS DisputeAmtAtPresent, ST.SRBWithInstallmentDue MSBAtStmt
 ,BCC.SRBWithInstallmentDue MSBAtPresent, ST.AmountOfTotalDue DueAtStmt, BCC.AmountOfTotalDue DueAtPresent
 , CASE 
	WHEN ST.CycleDueDTD = 0 THEN 'Nothing Due'
	WHEN ST.CycleDueDTD = 1 THEN 'Current Due'
	WHEN ST.CycleDueDTD = 2 THEN 'Past Due'
	WHEN ST.CycleDueDTD = 3 THEN '1 Cycle Past Due'
	WHEN ST.CycleDueDTD = 4 THEN '2 Cycle Past Due'
	WHEN ST.CycleDueDTD = 5 THEN '3 Cycle Past Due'
	WHEN ST.CycleDueDTD = 6 THEN '4 Cycle Past Due'
	WHEN ST.CycleDueDTD = 7 THEN '5 Cycle Past Due'
	ELSE 'NA'
  END DelinquencyAtStmt
, CASE 
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
	WHEN ST.SystemStatus = 2 THEN 'Active'
	WHEN ST.SystemStatus = 3 THEN 'Delinquent'
	WHEN ST.SystemStatus = 15991 THEN 'Delinquent_NoAuth'
	ELSE 'NA'
END SystemStatusAtStmt
, CASE 
	WHEN BP.SystemStatus = 2 THEN 'Active'
	WHEN BP.SystemStatus = 3 THEN 'Delinquent'
	WHEN BP.SystemStatus = 15991 THEN 'Delinquent_NoAuth'
	ELSE 'NA'
END SystemStatusAtPresent
, BP.CurrentBalance, BCC.SRBWithInstallmentDue
, CASE WHEN ST.CycleDueDTD >= 3 THEN 'YES'	ELSE 'NO' END CBRImpact
 into #final
 from #temp2 T JOIN achintermediate AI with (nolock) ON (AI.PymtScheduleId = T.scheduleid)
 JOIN AccountInfoforReport A WITH (NOLOCK)  ON (A.AccountNumber = AI.AccountNumber AND AI.ACHPaymentDate = CAST ((A.Businessday-1) AS DATE))
 JOIN Bsegment_Primary BP (NOLOCK) ON (BP.Acctid = AI.Acctid)
 JOIN Bsegment_Secondary BS (NOLOCK) ON (BP.Acctid = BS.Acctid)
 JOIN BsegmentCreditCard BCC (NOLOCK) ON (BCC.Acctid = BS.Acctid)
 JOIN StatementHeader ST (NOLOCK) ON (ST.Acctid = T.AcctId AND ST.StatementDate = T.StatementDate)
 where PaymentAmount >0 and sendflag=4 AND A.srbwithinstallmentdue >0 and A.currentbalance <= 0
 order  by  ACHPaymentDate

 SELECT * FROM #final ORDER BY acctId, StatementDate

 SELECT * FROM #final WHERE acctId = 3211712

 SELECT AccountNumber, AccountUUID, StatementDate, MSBAtStmt, SUM(PaymentAmount) PaymentAmount
 FROM #final 
 GROUP BY AccountNumber, AccountUUID, StatementDate, MSBAtStmt
 ORDER BY AccountNumber

 SELECT AccountNumber, AccountUUID, StatementDate, DueAtStmt, SUM(PaymentAmount) PaymentAmount
 FROM #final 
 GROUP BY AccountNumber, AccountUUID, StatementDate, DueAtStmt
 ORDER BY AccountNumber

;WITH AccountDetails
AS
(
	SELECT 
	acctId, RTRIM(AccountNumber) AccountNumber, AccountUUID, DisputeAmtAtPresent, DelinquencyAtPresent, SystemStatusAtPresent
	, ROW_NUMBER() OVER (PARTITION BY acctId ORDER BY StatementDate) [Row] FROM #final
)
SELECT 
A.acctId, A.AccountNumber, A.AccountUUID, A.DisputeAmtAtPresent, A.DelinquencyAtPresent, A.SystemStatusAtPresent,
BP.AmtOfPayCurrDue CurrentDue, BCC.AmtOfPayXDLate PastDue, BCC.AmountOfPayment30DLate AS '1CPD', BCC.AmountOfPayment60DLate '2CPD', BCC.AmountOfPayment90DLate '3CPD', 
BCC.AmountOfPayment120DLate '4CPD', BCC.AmountOfPayment150DLate '5CPD', BCC.AmountOfPayment180DLate '6CPD'
FROM AccountDetails  A
JOIN BSegment_Primary BP WITH (NOLOCK) ON (A.acctId = BP.acctId)
JOIN BSegmentCreditCard BCC WITH (NOLOCK) ON (BCC.acctId = BP.acctId)
WHERE [Row] = 1
ORDER BY A.acctId

;WITH AccountDetails
AS
(
	SELECT 
	acctId, RTRIM(AccountNumber) AccountNumber, AccountUUID, DisputeAmtAtPresent, DelinquencyAtPresent, SystemStatusAtPresent, CBRImpact
	, ROW_NUMBER() OVER (PARTITION BY acctId ORDER BY StatementDate) [Row] FROM #final
)
SELECT 
A.acctId, A.AccountNumber, A.AccountUUID, A.DisputeAmtAtPresent, A.DelinquencyAtPresent, A.SystemStatusAtPresent, A.CBRImpact, [Row]--,
--BP.AmtOfPayCurrDue CurrentDue, BCC.AmtOfPayXDLate PastDue, BCC.AmountOfPayment30DLate AS '1CPD', BCC.AmountOfPayment60DLate '2CPD', BCC.AmountOfPayment90DLate '3CPD', 
--BCC.AmountOfPayment120DLate '4CPD', BCC.AmountOfPayment150DLate '5CPD', BCC.AmountOfPayment180DLate '6CPD'
FROM AccountDetails  A
--JOIN BSegment_Primary BP WITH (NOLOCK) ON (A.acctId = BP.acctId)
--JOIN BSegmentCreditCard BCC WITH (NOLOCK) ON (BCC.acctId = BP.acctId)
--WHERE [Row] = 1
WHERE CBRImpact = 'YES'

 DROP TABLE IF EXISTS ##PHPUpdate
 SELECT *, ROW_NUMBER() OVER (PARTITION BY acctId, StatementDate ORDER BY StatementDate) [Row] INTO ##PHPUpdate FROM #final WHERE CBRImpact = 'YES'

 SELECT * FROM ##PHPUpdate

 SELECT *, ROW_NUMBER() OVER (PARTITION BY acctId ORDER BY StatementDate) [Row]  FROM #final WHERE CBRImpact = 'YES'


 SELECT * FROM #final WHERE AccountUUID IN ('a342c422-f35e-4ffc-bb64-4cdd1daea671', 'e4844511-625d-483f-9961-3cdf11d6f237')


 select  transactionamount,claimid ,transactiondescription,posttime,trantime,c.accountnumber, f.AccountUUID from   ccard_primary c with(nolock)
 join  #final f on  (c.accountnumber  = f.accountnumber)
 where artxntype = '99' order  by c.accountnumber,posttime  desc


 
;WITH AccountDetails
AS
(
	SELECT 
	acctId, RTRIM(AccountNumber) AccountNumber, AccountUUID, DisputeAmtAtPresent, DelinquencyAtPresent, SystemStatusAtPresent, StatementDate
	, ROW_NUMBER() OVER (PARTITION BY acctId ORDER BY StatementDate) [Row] FROM #final
)
SELECT 
RTRIM(A.AccountNumber) AccountNumber, A.AccountUUID, DisputeAmtAtPresent, DelinquencyAtPresent, SystemStatusAtPresent, A.StatementDate IssueFrom, ST.StatementDate,
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
END Delinquency--, M.[Row]
FROM AccountDetails  A
JOIN StatementHeader ST WITH (NOLOCK) ON (A.acctId = ST.acctId)
JOIN ##Months M ON (M.[Value] = TRY_CAST(ST.StatementDate AS DATE))
WHERE A.[Row] = 1
AND ST.StatementDate >= A.StatementDate
AND ST.CycleDueDTD >= 3
ORDER BY A.acctId


;WITH AccountDetails
AS
(
	SELECT 
	acctId, RTRIM(AccountNumber) AccountNumber, AccountUUID, DisputeAmtAtPresent, DelinquencyAtPresent, SystemStatusAtPresent, StatementDate
	, ROW_NUMBER() OVER (PARTITION BY acctId ORDER BY StatementDate) [Row] FROM #final
)
SELECT 
DISTINCT A.*
FROM AccountDetails  A
JOIN StatementHeader ST WITH (NOLOCK) ON (A.acctId = ST.acctId)
JOIN ##Months M ON (M.[Value] = TRY_CAST(ST.StatementDate AS DATE))
WHERE A.[Row] = 1
AND ST.StatementDate >= A.StatementDate
ORDER BY A.acctId

 
 ---/**/ --- 
 SELECT * FROM Ccardlookup with (nolock) where lutid='PSFrequency'


SELECT top 1 CAST(Businessday-1 AS DATE), * FROM AccountInfoforReport WITH (nolock) where accountnumber ='1100011115907184'
134.79
SELECT ACHErrorreason,* FROM achintermediate with (nolock) where pymtscheduleId =79146726
-- not charged off account where current balance  > 0 

  
select srbwithinstallmentdue,currentbalance + currentbalanceco cbco,acctid ,systemstatus,cycleduedtd,statementdate,disputesamtns INto #Temp3 from  statementheader with(nolock) 
 where srbwithinstallmentdue > currentbalance  and systemstatus <>14   and  currentbalance > 0 
 and   cycleduedtd > 1    --and acctid not in (select parent02aid  from cpsgmentaccounts with(nolock)  where creditplantype = '16')
  order by statementdate  desc

   SELECT Scheduledeletedon,statementdate,SchedulecreatedOn,ScheduleId INTO #temp4 FROM PaymentSchedule PS WITH (NOLOCK)
JOIN #temp3 T WITH (NOLOCk) ON (PS.Acctid = T.Acctid) WHERE PS.frequency not in (2,4)

  

 Select  AI.accountnumber,AI.PymtScheduleId,ACHPaymentDate,PaymentAmount,OriginalPaymentAmount,srbwithinstallmentdue,currentbalance from #temp4 T JOIN achintermediate AI with (nolock) ON (AI.PymtScheduleId = T.scheduleid)

 JOIN AccountInfoforReport A WITH (NOLOCK) ON (A.AccountNumber = AI.AccountNumber AND AI.ACHPaymentDate = CAST ((A.Businessday-1) AS DATE))
 where PaymentAmount >0 and sendflag=1 AND A.srbwithinstallmentdue >0 and srbwithinstallmentdue > currentbalance 



--select  distinct  acctid  from  statementheader with(nolock) 
-- where srbwithinstallmentdue > currentbalance  and systemstatus <>14   and  currentbalance > 0 
-- and   cycleduedtd > 1    --and acctid not in (select parent02aid  from cpsgmentaccounts with(nolock)  where creditplantype = '16')
--  order by statementdate  desc


 --select distinct acctid  from  statementheader with(nolock) 
 --where srbwithinstallmentdue > currentbalance  and systemstatus <>14   and  currentbalance <= 0 
 --and   cycleduedtd > 1    
 -- order by statementdate  desc