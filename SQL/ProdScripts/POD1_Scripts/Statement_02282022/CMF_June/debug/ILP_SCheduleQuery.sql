
select  case  when   laststatementdate is null   then  null else  dateadd(month,1,laststatementdate)  end laststatementdate  , 
  dateadd(month,1,dateofnextstmt) dateofnextstmt,
  dateadd(month,1,statementdate) statementdate, 
  dateadd(month,1,dateoftotaldue) dateoftotaldue,
  dateadd(month,1,originalloanenddate) originalloanenddate,
  dateadd(month,1,loanenddate) loanenddate,* from 
  PROD1GSDB01.ccgs_coreissue.dbo.ILPScheduleDetails   with(nolock)  where  ScheduleID  =8781002

  --OriginalLoanEndDate, LoanEndDate, MaturityDate, ActualLoanEndDate, LastTermDate, LoanStartDate
  select   dateadd(month,1,originalloanenddate) originalloanenddate,
  dateadd(month,1,originalloanenddate) loanenddate,
  dateadd(month,1,ActualLoanEndDate)  ActualLoanEndDate	,
dateadd(month,1,lasttermdate)  lasttermdate	,
dateadd(month,1,MaturityDate)  MaturityDate	,
dateadd(month,1,LoanStartDate)  LoanStartDate	,
  *  from  PROD1GSDB01.ccgs_coreissue.dbo.ILPScheduleDetailsummary   with(nolock)  where  ScheduleID  =8781002


  select  dateadd(month,1,MaturityDate)  MaturityDate	,  dateadd(month,1,loanenddate) loanenddate,RetailAniversaryDate, *   
  from  PROD1GSDB01.ccgs_coreissue.dbo.cpsgmentcreditcard   with(nolock)where acctid=56616684



UPDATE ILPScheduleDetails
SET 
	dateofnextstmt = dateadd(month,1,dateofnextstmt),
	statementdate = dateadd(month,1,statementdate),
	dateoftotaldue = dateadd(month,1,dateoftotaldue),
	originalloanenddate = dateadd(month,1,originalloanenddate),
	loanenddate = dateadd(month,1,loanenddate)
WHERE ScheduleID IN (8781002, 8781003)

UPDATE ILPScheduleDetailsummary
SET 
	originalloanenddate = dateadd(month,1,originalloanenddate),
	ActualLoanEndDate = dateadd(month,1,ActualLoanEndDate),
	lasttermdate = dateadd(month,1,lasttermdate),
	MaturityDate = dateadd(month,1,MaturityDate),
	LoanStartDate = dateadd(month,1,LoanStartDate)
WHERE ScheduleID IN (8781002, 8781003)

UPDATE cpsgmentcreditcard
SET 
	MaturityDate = dateadd(month,1,MaturityDate),
	loanenddate = dateadd(month,1,loanenddate)
WHERE acctid IN (56616684, 56616685)
