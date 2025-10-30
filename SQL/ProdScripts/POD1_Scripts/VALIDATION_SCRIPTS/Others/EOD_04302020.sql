SELECT  bsacctid,CREDITPLANTYPE,accountnumber,CP.CMTTRANTYPE,CP.TRANSACTIONAMOUNT,revtgt, CP.ArtxnType,CP.POSTTIME,CP.TRANTIME,CP.TRANID,CASEID,
	memoindicator,transactiondescription,CP.TRANORIG,CP.TRANREF,noblobindicator
	,T.* FROM ls_proddrgsdb01.ccgs_coreissue.dbo.CCARD_PRIMARY CP WITH(NOLOCK) 
	LEFT OUTER JOIN ls_proddrgsdb01.ccgs_coreissue.dbo.NoBlobTransactionBSFC T WITH(NOLOCK) ON (CP.TRANID = T.TRANID)
	LEFT OUTER JOIN ls_proddrgsdb01.ccgs_coreissue.dbo.CPSGMENTACCOUNTS CPS WITH(NOLOCK) ON (CP.BSACCTID = CPS.PARENT02AID AND CP.TXNACCTID = CPS.ACCTID)
WHERE ACCOUNTNUMBER = (SELECT AccountNumber FROM ls_proddrgsdb01.ccgs_coreissue.dbo.BSEGMENT_PRIMARY BP WITH(NOLOCK) WHERE acctId = 1218755) 
AND CMTTRANTYPE IN ('21', '22', '26') AND MemoIndicator IS NULL
--AND CP.POSTTIME >= '2020-03-31 23:59:57.000'
ORDER BY CP.POSTTIME DESC

SELECT TRANSACTIONAMOUNT, CMTTRANTYPE, RevTGT FROM CCard_Primary WITH (NOLOCK) WHERE AccountNumber = '1100011112148881' AND CMTTRANTYPE = '21' AND ArtxnType <> 93
SELECT TRANSACTIONAMOUNT, CMTTRANTYPE, RevTGT FROM CCard_Primary WITH (NOLOCK) WHERE AccountNumber = '1100011112148881' AND CMTTRANTYPE IN ('22', '26') AND ArtxnType <> 93

SELECT TRANSACTIONAMOUNT, CMTTRANTYPE, RevTGT FROM CCard_Primary WITH (NOLOCK) WHERE AccountNumber = '1100011112148881' AND CMTTRANTYPE = '21' AND ArtxnType <> 93 AND TranID NOT IN (
SELECT RevTGT FROM CCard_Primary WITH (NOLOCK) WHERE AccountNumber = '1100011112148881' AND CMTTRANTYPE IN ('22', '26') AND ArtxnType <> 93)



SELECT TRANSACTIONAMOUNT, CMTTRANTYPE, RevTGT FROM CCard_Primary WITH (NOLOCK) WHERE AccountNumber = '1100011111817338' AND CMTTRANTYPE = '21' AND ArtxnType <> 93
SELECT TRANSACTIONAMOUNT, CMTTRANTYPE, RevTGT FROM CCard_Primary WITH (NOLOCK) WHERE AccountNumber = '1100011111817338' AND CMTTRANTYPE IN ('22', '26') AND ArtxnType <> 93

SELECT TRANSACTIONAMOUNT, CMTTRANTYPE, RevTGT FROM CCard_Primary WITH (NOLOCK) WHERE AccountNumber = '1100011111817338' AND CMTTRANTYPE = '21' AND ArtxnType <> 93 AND TranID NOT IN (
SELECT RevTGT FROM CCard_Primary WITH (NOLOCK) WHERE AccountNumber = '1100011111817338' AND CMTTRANTYPE IN ('22', '26') AND ArtxnType <> 93)

select ManualInitialChargeOffReason, Chargeoffdate, bp.acctid 
from ls_proddrgsdb01.ccgs_coreissue.dbo.bsegment_primary bp with (nolock)
join ls_proddrgsdb01.ccgs_coreissue.dbo.bsegmentcreditcard bcc with (nolock) on (bp.acctid = bcc.acctid)
where systemstatus = 14 and ManualInitialChargeOffReason = '0' --AND Chargeoffdate = '2020-04-30 23:59:55.000'

select ManualInitialChargeOffReason, Chargeoffdate, bp.acctid 
from bsegment_primary bp with (nolock)
join bsegmentcreditcard bcc with (nolock) on (bp.acctid = bcc.acctid)
where systemstatus = 14 and ManualInitialChargeOffReason = '0' --AND Chargeoffdate = '2020-04-30 23:59:55.000'


SELECT SystemStatus,ManualInitialChargeOffReason,* FROM ls_proddrgsdb01.ccgs_coreissue.dbo.AccountInfoForReport WITH (NOLOCK) WHERE 
	BSacctid IN (411784, 918954, 2299088)
	AND Businessday = '2020-04-30 23:59:57.000'

SELECT SystemStatus,ManualInitialChargeOffReason,* 
FROM ls_proddrgsdb01.ccgs_coreissue.dbo.AccountInfoForReport WITH (NOLOCK) 
WHERE 
--BSacctid = 774627 AND 
Businessday = '2020-04-30 23:59:57.000'  AND 
ManualInitialChargeOffReason = '0' AND
SystemStatus = 14

SELECT SystemStatus,ManualInitialChargeOffReason,* 
FROM AccountInfoForReport WITH (NOLOCK) 
WHERE 
BSacctid IN (346639, 421277, 554463, 1142488, 1710674, 2096678, 2243906, 2429607, 2533873) AND 
Businessday = '2020-04-30 23:59:57.000'  AND 
ManualInitialChargeOffReason = '0' AND
SystemStatus = 14



SELECT SystemStatus, ChargeOffDate, CurrentBalance, CurrentBalanceCO, ManualInitialChargeOffReason, parent05aid
FROM ls_proddrgsdb01.ccgs_coreissue.dbo.BSegment_Primary BP WITH (NOLOCK)
JOIN ls_proddrgsdb01.ccgs_coreissue.dbo.BSegmentCreditCard BCC WITH (NOLOCK) ON (BP.acctId = BCC.acctID)
WHERE BP.acctId IN (346639, 421277, 554463, 1142488, 1710674, 2096678, 2243906, 2429607, 2533873)

SELECT A.CBRStatusGroup,RTRIM(A.StatusDescription),A.WaiveMinDue,A.WaiveMinDueFor,A.Priority 
FROM ls_proddrgsdb01.ccgs_coreissue.dbo.AStatusAccounts A WITH (NOLOCK)
JOIN ls_proddrgsdb01.ccgs_coreissue.dbo.CCardLookUp C WITH (NOLOCK) ON (A.parent01AID = C.LutCode)
WHERE C.LUTid = 'AsstPlan' AND C.LutLanguage = 'dbb' AND A.MerchantAID = 14994
ORDER BY A.Priority


SELECT SystemStatus, ChargeOffDate, CurrentBalance, CurrentBalanceCO, * 
FROM ls_proddrgsdb01.ccgs_coreissue_secondary.dbo.StatementHEader WITH (NOLOCK)
WHERE acctid IN (346639, 421277, 554463, 1142488, 1710674, 2096678, 2243906, 2429607, 2533873)
AND STatementDate = '2020-04-30 23:59:57.000'

SELECT AmtOfInterestYTD,SystemStatus,* 
FROM ls_proddrgsdb01.ccgs_coreissue.dbo.AccountInfoForReport WITH (NOLOCK) 
WHERE 
AccountNumber IN ('1100011101353815', 
'1100011104379528', 
'1100011101365165', 
'1100011103941815', 
'1100011105436210', 
'1100011105438190', 
'1100011105438653', 
'1100011105438950') AND 
Businessday = '2020-04-30 23:59:57.000' 

SELECT acctId,AmtOfInterestYTD,SystemStatus, ChargeOffDate, CurrentBalance, CurrentBalanceCO, * 
FROM ls_proddrgsdb01.ccgs_coreissue_secondary.dbo.StatementHEader WITH (NOLOCK)
WHERE AccountNumber IN ('1100011101353815', 
'1100011104379528', 
'1100011101365165', 
'1100011103941815', 
'1100011105436210', 
'1100011105438190', 
'1100011105438653', 
'1100011105438950')
AND STatementDate = '2020-04-30 23:59:57.000'


SELECT BCC.acctId, SH.AccountNumber,SH.AmtOfInterestYTD AS SH_AmtOfInterestYTD, BCC.AmtOfInterestYTD AS BCC_AmtOfInterestYTD, SH.AmtOfInterestYTD - BCC.AmtOfInterestYTD AS DIFF 
FROM BsegmentCreditCard BCC WITH (Nolock) JOIN
ls_proddrgsdb01.ccgs_coreissue_secondary.dbo.StatementHEader SH WITH (NOLOCK) ON (BCC.acctId = SH.acctId AND SH.STatementDate = '2020-04-30 23:59:57.000')
WHERE SH.AccountNumber IN ('1100011101353815', 
'1100011104379528', 
'1100011101365165', 
'1100011103941815', 
'1100011105436210', 
'1100011105438190', 
'1100011105438653', 
'1100011105438950')

SELECT BCC.acctId, SH.AccountNumber,SH.AmtOfInterestYTD AS SH_AmtOfInterestYTD, BCC.AmtOfInterestYTD AS BCC_AmtOfInterestYTD, SH.AmtOfInterestYTD - BCC.AmtOfInterestYTD AS DIFF 
FROM BsegmentCreditCard BCC WITH (Nolock) JOIN
StatementHEader SH WITH (NOLOCK) ON (BCC.acctId = SH.acctId AND SH.STatementDate = '2020-04-30 23:59:57.000')
WHERE SH.AccountNumber IN ('1100011101353815', 
'1100011104379528', 
'1100011101365165', 
'1100011103941815', 
'1100011105436210', 
'1100011105438190', 
'1100011105438653', 
'1100011105438950')



SELECT AccountNumber, SUM(TransactionAmount) AS TransactionAmount, CMTTRANTYPE 
FROM CCard_Primary WITH (NOLOCK) 
WHERE AccountNumber IN ('1100011101353815', 
'1100011104379528', 
'1100011101365165', 
'1100011103941815', 
'1100011105436210', 
'1100011105438190', 
'1100011105438653', 
'1100011105438950')
AND CMTTRANTYPE IN ('03') 
AND PostTime > '2020-01-01'
GROUP BY AccountNumber, CMTTRANTYPE
ORDER BY AccountNumber, CMTTRANTYPE

WITH CTE
AS
(
	SELECT AccountNumber, CASE WHEN CMTTRANTYPE = '03' THEN -1*TransactionAmount ELSE TransactionAmount END AS TransactionAmount, CMTTRANTYPE 
	FROM CCard_Primary WITH (NOLOCK) 
	WHERE AccountNumber IN ('1100011101353815', 
	'1100011104379528', 
	'1100011101365165', 
	'1100011103941815', 
	'1100011105436210', 
	'1100011105438190', 
	'1100011105438653', 
	'1100011105438950')
	AND CMTTRANTYPE IN ('02', '03') 
	AND PostTime > '2020-01-01'
	--GROUP BY AccountNumber, CMTTRANTYPE
	--ORDER BY AccountNumber, CMTTRANTYPE
)
SELECT AccountNumber, SUM(TransactionAmount)
FROM CTE 
GROUP BY AccountNumber



UPDATE StatementHeader SET AmtOfInterestYTD = AmtOfInterestYTD - 6.41 WHERE acctID = 120123 AND StatementDate = '2020-04-30 23:59:57.000'
UPDATE StatementHeader SET AmtOfInterestYTD = AmtOfInterestYTD - 4.64 WHERE acctID = 120508 AND StatementDate = '2020-04-30 23:59:57.000'
UPDATE StatementHeader SET AmtOfInterestYTD = AmtOfInterestYTD - 4.11 WHERE acctID = 398358 AND StatementDate = '2020-04-30 23:59:57.000'
UPDATE StatementHeader SET AmtOfInterestYTD = AmtOfInterestYTD - 0.15 WHERE acctID = 442139 AND StatementDate = '2020-04-30 23:59:57.000'
UPDATE StatementHeader SET AmtOfInterestYTD = AmtOfInterestYTD - 41.35 WHERE acctID = 547808 AND StatementDate = '2020-04-30 23:59:57.000'
UPDATE StatementHeader SET AmtOfInterestYTD = AmtOfInterestYTD - 0.09 WHERE acctID = 548006 AND StatementDate = '2020-04-30 23:59:57.000'
UPDATE StatementHeader SET AmtOfInterestYTD = AmtOfInterestYTD - 0.34 WHERE acctID = 548052 AND StatementDate = '2020-04-30 23:59:57.000'
UPDATE StatementHeader SET AmtOfInterestYTD = AmtOfInterestYTD - 2.00 WHERE acctID = 548082 AND StatementDate = '2020-04-30 23:59:57.000'

SELECT AmtOfInterestYTD, AmtOfInterestYTD - 6.41 FROM StatementHeader WITH (NOLOCK) WHERE acctID = 120123 AND StatementDate = '2020-04-30 23:59:57.000'
SELECT AmtOfInterestYTD, AmtOfInterestYTD - 6.41 FROM LS_PRODDRGSDB01.CCGS_CoreIssue_Secondary.DBO.StatementHeader WITH (NOLOCK) WHERE acctID = 120123 AND StatementDate = '2020-04-30 23:59:57.000'

select * from sys.servers

select * from sys.synonyms where name like '%StatementHeader%'


SELECT AmtOfInterestCTD,AmtOfInterestCC2, AmtOfInterestCC3, AmtOfInterestCC4,AmtOfInterestCC5,AmtOfInterestCC6,AmtOfInterestCC7, AmtOfInterestCC8, AmtOfInterestCC9, * 
FROM BSegment_Primary BP WITH (NOLOCK) 
JOIN BsegmentCreditCard BCC WITH (NOLOCK) ON (BP.acctId = BCC.acctId)
WHERE AccountNumber IN ('1100011105851830')


SHAcountnumber 	
('1100011101353815', 
'1100011104379528', 
'1100011101365165', 
'1100011103941815', 
'1100011105436210', 
'1100011105438190', 
'1100011105438653', 
'1100011105438950')