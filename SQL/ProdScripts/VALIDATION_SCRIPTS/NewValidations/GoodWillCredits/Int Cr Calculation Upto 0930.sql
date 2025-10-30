---STEP 1 - Data Fill.

CREATE TABLE #TEMP_InterestCreditRemediation
(
	skey  int identity(1,1) not null,
	uuid varchar(100),
	clientid varchar(100),
	acctid INT,
	accountnumber varchar(30),
	statementdate datetime,
	interestamount money,
	JobStatus INT,
	APR money ,
	totaldays int,
	FinalInterestCrAmt money
)

INSERT INTO #TEMP_InterestCreditRemediation(acctid,accountnumber,interestamount,statementdate,JobStatus)
SELECT SrcBsAcctId, SrcAccountNumber, Amount, TranTime_Src, 0
FROM ##PostWithInterestCredit



update tic set tic.acctid = bp.acctid,tic.accountnumber = bp.accountnumber, tic.uuid = bp.universaluniqueid,tic.clientid = bs.clientid
from bsegment_primary bp with(nolock) 
join bsegment_secondary bs with(nolock) on bp.acctid = bs.acctid
join #TEMP_InterestCreditRemediation tic with(nolock) on bp.acctid = tic.acctid

---STEP 2 - Additional Interest for following cycles

CREATE TABLE #TEMP_InterestCreditRemediationStmt
(
	acctid INT,
	accountnumber varchar(30),
	statementdate datetime,
	APR money ,
	daysincycle int,
	skey int ,
	jobstatus int
)

insert into #TEMP_InterestCreditRemediationStmt(acctid,accountnumber,statementdate,APR,daysincycle,skey,jobstatus)
select icr.acctid,accountnumber,sh.statementdate,sh.apr,case when (ISNULL(CSH.InterestAtCycle,0.00) - ISNULL(CSH.AmtOfInterestCTD,0.00)) >0 then sh.daysincycle else 0 end,icr.skey,0
from #TEMP_InterestCreditRemediation icr with(nolock)
join summaryheader sh with(nolock) on sh.parent02aid=icr.acctid and sh.creditplantype=0 and sh.statementdate > icr.statementdate
join currentsummaryheader csh with(nolock) on sh.statementid=csh.statementid and sh.acctid=csh.acctid
Where icr.jobstatus=0

update icr
set totaldays=totaldaysincycle,apr=T.apr
from #TEMP_InterestCreditRemediation icr
JOIN (select  SUM(IsNull(daysincycle,0)) AS totaldaysincycle, Acctid,skey,max(apr) as apr  
	from #TEMP_InterestCreditRemediationStmt with(nolock) where jobstatus=0
		group by acctid,skey
	) T on icr.acctid=T.acctid and icr.skey=T.skey

update icr
set FinalInterestCrAmt= icr.interestamount + round((icr.interestamount * POWER (1 + (round(cast (apr as float)/cast(100 as float),10)) * (round(cast (1 as float)/cast(365 as float),10)),totaldays) - icr.interestamount),2),
jobstatus=1
from #TEMP_InterestCreditRemediation icr
where jobstatus=0

--THE LIST

--since interest amount in this script is dispute amount so subtract this amount from FinalInterestCrAmt to get the actual interest credit.

update #TEMP_InterestCreditRemediation set FinalInterestCrAmt = FinalInterestCrAmt - interestamount 

select * From #TEMP_InterestCreditRemediation with(nolock) order by acctid


DROP TABLE IF EXISTS #TempFinalCredits
select ACCTID ACCOUNT_ID,ACCOUNTNUMBER ACCOUNT_NUMBER,UUID ACCOUNT_UUID,CLIENTID ACCOUNT_CID,SUM(FINALINTERESTCRAMT) FINAL_INT_CR_AMT
INTO #TempFinalCredits
from #TEMP_InterestCreditRemediation with(nolock) GROUP BY ACCTID,ACCOUNTNUMBER,UUID,CLIENTID
ORDER BY ACCTID

select round((304.05 * POWER (1 + (round(cast (17.74 as float)/cast(100 as float),10)) * (round(cast (1 as float)/cast(365 as float),10)),
546) - 304.05),2)

UPDATE T1
SET FINAL_INT_CR_AMT = T2.FINAL_INT_CR_AMT
FROM ##PostWithInterestCredit T1
JOIN #TempFinalCredits T2 ON (T1.SrcBSacctId = T2.ACCOUNT_ID)


