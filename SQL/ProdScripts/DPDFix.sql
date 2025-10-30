SELECT
	BP.acctId, TRY_CONVERT(DATETIME, CONVERT(VARCHAR, CAST(DateOfOriginalPaymentDueDTD AS DATE)) + ' 23:59:57'), NoPayDaysDelinquent, DaysDelinquent, DPDFreezeDays, DtOfLastDelinqCTD, 
	TRY_CONVERT(DATETIME, CONVERT(VARCHAR, CAST(DateOfOriginalPaymentDueDTD AS DATE)) + ' 23:59:57'), LAD, DeAcctActivityDate, ccinhparent125AID, 
	ActualDRPStartDate, CycleDueDTD, SystemStatus, DaysDelinquent, NoPayDaysDelinquent
FROM LS_PRODDRGSDB01.ccgs_coreissue.dbo.BsegmentCreditCard BCC WITH (NOLOCK)
INNER JOIN LS_PRODDRGSDB01.ccgs_coreissue.dbo.BSegment_Primary BP WITH (NOLOCK) ON (BP.acctId = BCC.acctId)
WHERE BCC.DaysDelinquent > BCC.NoPayDaysDelinquent
AND BP.SystemStatus <> 14 And BillingCycle <>'LTD'

--417786, 1255358, 8934233


SELECT
	BP.acctId, TRY_CONVERT(DATETIME, CONVERT(VARCHAR, CAST(DateOfOriginalPaymentDueDTD AS DATE)) + ' 23:59:57') DateOfOriginalPaymentDueDTD, 
	NoPayDaysDelinquent, DaysDelinquent, DPDFreezeDays, DtOfLastDelinqCTD, LAD, DeAcctActivityDate, ccinhparent125AID, 
	ActualDRPStartDate, CycleDueDTD, SystemStatus
FROM LS_PRODDRGSDB01.ccgs_coreissue.dbo.BsegmentCreditCard BCC WITH (NOLOCK)
INNER JOIN LS_PRODDRGSDB01.ccgs_coreissue.dbo.BSegment_Primary BP WITH (NOLOCK) ON (BP.acctId = BCC.acctId)
INNER JOIN LS_PRODDRGSDB01.ccgs_coreissue.dbo.BSegment_Balances BB WITH (NOLOCK) ON (BP.acctId = BB.acctId)
WHERE CycleDueDTD = 2 AND DaysDelinquent > 3
AND BP.SystemStatus <> 14 And BillingCycle <>'LTD'

SELECT
	BP.acctId, TRY_CONVERT(DATETIME, CONVERT(VARCHAR, CAST(DateOfOriginalPaymentDueDTD AS DATE)) + ' 23:59:57') DateOfOriginalPaymentDueDTD, 
	NoPayDaysDelinquent, DaysDelinquent, DPDFreezeDays, DtOfLastDelinqCTD, LAD, DeAcctActivityDate, ccinhparent125AID, 
	ActualDRPStartDate, CycleDueDTD, SystemStatus
FROM BsegmentCreditCard BCC WITH (NOLOCK)
INNER JOIN BSegment_Primary BP WITH (NOLOCK) ON (BP.acctId = BCC.acctId)
INNER JOIN BSegment_Balances BB WITH (NOLOCK) ON (BP.acctId = BB.acctId)
WHERE CycleDueDTD = 2 AND DaysDelinquent > 3
AND BP.SystemStatus <> 14 And BillingCycle <>'LTD'

SELECT
	BSAcctId, DateOfOriginalPaymentDueDTD, TotalDaysDelinquent, DaysDelinquent, DateOfDelinquency, ccinhparent125AID, 
	ActualDRPStartDate, CycleDueDTD, SystemStatus
FROM AccountInfoForReport WITH (NOLOCK)
WHERE BusinessDay >= '2021-10-31 23:59:57.000'
AND BSAcctId = 5623450

--UPDATE TOP(1) BSegmentCreditCard SET DaysDelinquent = 1, NoPayDaysDelinquent = 1 WHERE acctId = 5623450
--UPDATE TOP(2) AccountInfoForReport SET DaysDelinquent = 1, TotalDaysDelinquent = 1 WHERE BSacctId = 5623450 AND BusinessDay > '2021-10-31 23:59:57.000'

SELECT * FROM PastDueAgingReportData WITH (NOLOCK)
WHERE ReportDate = '2021-11-02 23:59:57.000'
AND CurrentDue + PastDueBalance > AmountOfTotalDue


SELECT
	BSAcctId, AmountOfTotalDue, amtofpaycurrdue,AmtOfPayXDLate,AmountOfPayment30DLate, AmountOfPayment60DLate, 
AmountOfPayment90DLate, AmountOfPayment120DLate, AmountOfPayment150DLate, AmountOfPayment180DLate, AmountOfPayment210DLate,
(amtofpaycurrdue+AmtOfPayXDLate+AmountOfPayment30DLate+ AmountOfPayment60DLate+ AmountOfPayment90DLate+ AmountOfPayment120DLate+ AmountOfPayment150DLate+ AmountOfPayment180DLate + AmountOfPayment210DLate) AS CalculatedAD,
 CycleDueDTD, SystemStatus
FROM AccountInfoForReport WITH (NOLOCK)
WHERE BusinessDay = '2021-11-02 23:59:57.000'
AND BSAcctId IN (
SELECT acctId FROM PastDueAgingReportData WITH (NOLOCK)
WHERE ReportDate = '2021-11-02 23:59:57.000'
AND CurrentDue + PastDueBalance > AmountOfTotalDue)

UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0, CycleDueDTD = 0 WHERE acctId = 67249738
UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 20.98, AmtOfPayCurrDue = AmtOfPayCurrDue + 20.98 WHERE acctId = 19159375
UPDATE BSegment_Primary SET CycleDueDTD = 1, SystemStatus = 2, AmtOfPayCurrDue = AmtOfPayCurrDue + 10.97 WHERE acctID = 7853217
UPDATE BSegmentCreditCard SET SRBWithInstallmentDue = SRBWithInstallmentDue - 41.62, SBWithInstallmentDue = SBWithInstallmentDue - 41.62, AmtOfPayXDLate = 0 WHERE acctID = 7853217


UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0, CycleDueDTD = 0 WHERE acctId = 66251264
UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 8.08, AmtOfPayCurrDue = AmtOfPayCurrDue + 8.08 WHERE acctId = 61130944
UPDATE TOP(1) CPSgmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue + 38.97, AmtOfPayCurrDue = AmtOfPayCurrDue + 38.97 WHERE acctId = 67937761
UPDATE BSegment_Primary SET AmtOfPayCurrDue = AmtOfPayCurrDue + 47.05 WHERE acctID = 19628952
UPDATE BSegmentCreditCard SET SRBWithInstallmentDue = SRBWithInstallmentDue - 108.25, SBWithInstallmentDue = SBWithInstallmentDue - 108.25, AmtOfPayXDLate = AmtOfPayXDLate - 108.25 WHERE acctID = 19628952

--21398996, 21644933, 18310493, 19628952, 18074751

SELECT
	BP.acctId, AmountOfTotalDue, amtofpaycurrdue,AmtOfPayXDLate,AmountOfPayment30DLate, AmountOfPayment60DLate, 
AmountOfPayment90DLate, AmountOfPayment120DLate, AmountOfPayment150DLate, AmountOfPayment180DLate, AmountOfPayment210DLate,
(amtofpaycurrdue+AmtOfPayXDLate+AmountOfPayment30DLate+ AmountOfPayment60DLate+ AmountOfPayment90DLate+ 
AmountOfPayment120DLate+ AmountOfPayment150DLate+ AmountOfPayment180DLate + AmountOfPayment210DLate) AS CalculatedAD,
 CycleDueDTD, SystemStatus, 'UPDATE TOP(1) #BSegmentCreditCard SET AmountOfTotalDue = ' + TRY_CAST(AmtOfPayXDLate AS varchar) + ' WHERE acctId = ' + TRY_CAST(BP.acctId AS VARCHAR),
 'UPDATE TOP(1) AccountInfoForReport SET AmountOfTotalDue = ' + TRY_CAST(AmtOfPayXDLate AS varchar) + ' WHERE BSacctId = ' + TRY_CAST(BP.acctId AS VARCHAR) + ' AND BusinessDay = ''2021-11-02 23:59:57.000'''
FROM BsegmentCreditCard BCC WITH (NOLOCK)
INNER JOIN BSegment_Primary BP WITH (NOLOCK) ON (BP.acctId = BCC.acctId)
WHERE BP.AcctId IN (
SELECT acctId FROM PastDueAgingReportData WITH (NOLOCK)
WHERE ReportDate = '2021-11-02 23:59:57.000'
AND CurrentDue + PastDueBalance > AmountOfTotalDue)


