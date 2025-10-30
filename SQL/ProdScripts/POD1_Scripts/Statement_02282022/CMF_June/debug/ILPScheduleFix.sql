BEGIN TRAN
--COMMIT TRAN
--ROLLBACK TRAN


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