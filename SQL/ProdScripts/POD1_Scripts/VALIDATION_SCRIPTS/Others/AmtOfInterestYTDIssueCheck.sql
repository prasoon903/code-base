SELECT 'BSegment==> ',BP.acctId, AccountNumber, AmtOfInterestYTD,YTDIntTotalsOnly
FROM PROD1GSDB01.CCGS_CoreIssue.dbo.Bsegment_Primary BP WITH (NOLOCK)
JOIN PROD1GSDB01.CCGS_CoreIssue.dbo.BsegmentCreditCard BCC WITH (NOLOCK) ON (BP.acctId = BCC.acctId)
WHERE AccountNumber IN ('1100011113787653')

DECLARE @YTDCalculated MONEY
;WITH CCardRecords
AS
(
	SELECT CMTTRANTYPE, CASE WHEN CMTTRANTYPE = '02' THEN TransactionAmount ELSE -TransactionAmount END AS TransactionAmount
	FROM PROD1GSDB01.CCGS_CoreIssue.dbo.CCard_Primary CP WITH (NOLOCK)	
	WHERE AccountNumber IN ('1100011113787653') 
	AND CMTTRANTYPE IN ('02', '03')
	AND Posttime > '01/01/2020'
)
SELECT @YTDCalculated = SUM(TransactionAmount)
FROM CCardRecords

SELECT TOP 1 'StatementHeader==> ', SH.StatementDate, YTDTotalINT, @YTDCalculated AS YTDCalculated, @YTDCalculated - YTDTotalINT AS DiffAmount
FROM StatementHeader SH WITH (NOLOCK)
WHERE AccountNumber IN ('1100011113787653') 
ORDER BY StatementDate DESC

---------------------------------------------------

SELECT 'BSegment==> ',BP.acctId, AccountNumber, AmtOfInterestYTD 
FROM PROD1GSDB01.CCGS_CoreIssue.dbo.Bsegment_Primary BP WITH (NOLOCK)
JOIN PROD1GSDB01.CCGS_CoreIssue.dbo.BsegmentCreditCard BCC WITH (NOLOCK) ON (BP.acctId = BCC.acctId)
WHERE AccountNumber IN ('1100011112113042')

--DECLARE @YTDCalculated MONEY
;WITH CCardRecords
AS
(
	SELECT CMTTRANTYPE, CASE WHEN CMTTRANTYPE = '02' THEN TransactionAmount ELSE -TransactionAmount END AS TransactionAmount
	FROM PROD1GSDB01.CCGS_CoreIssue.dbo.CCard_Primary CP WITH (NOLOCK)
	WHERE AccountNumber IN ('1100011112113042') 
	AND CMTTRANTYPE IN ('02', '03')
	AND Posttime > '01/01/2020'
)
SELECT @YTDCalculated = SUM(TransactionAmount)
FROM CCardRecords

SELECT TOP 1 SH.StatementDate, YTDTotalINT, @YTDCalculated AS YTDCalculated, @YTDCalculated - YTDTotalINT AS DiffAmount
FROM StatementHeader SH WITH (NOLOCK)
WHERE AccountNumber IN ('1100011112113042') 
ORDER BY StatementDate DESC

--UPDATE StatementHeader SET YTDTotalINT = YTDTotalINT + 0.26 WHERE AccountNumber = '1100000100225835' AND StatementDate = '2020-07-31 23:59:57.000'
--UPDATE StatementHeader SET YTDTotalINT = YTDTotalINT - 9.81 WHERE AccountNumber = '1100011112113042' AND StatementDate = '2020-07-31 23:59:57.000'