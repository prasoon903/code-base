
SELECT TOP 10 acctId, SystemStatus, CycleDueDTD, SH.StatementID, StatementDate, MinimumPaymentDue, AmountOfPaymentsCTD, Principal, CurrentBalance, CurrentBalanceCO, SH.AmountOfTotalDue,amtofpaycurrdue,AmtOfPayXDLate,AmountOfPayment30DLate, AmountOfPayment60DLate, 
AmountOfPayment90DLate, AmountOfPayment120DLate, AmountOfPayment150DLate, AmountOfPayment180DLate,AmountOfPayment210DLate,
(amtofpaycurrdue+AmtOfPayXDLate+AmountOfPayment30DLate+ AmountOfPayment60DLate+ AmountOfPayment90DLate+ AmountOfPayment120DLate+ AmountOfPayment150DLate+ AmountOfPayment180DLate+ AmountOfPayment210DLate) AS CalculatedAD,
SH.CycleDueDTD, DateOfOriginalPaymentDUeDTD, SystemStatus, CCInhParent125AID, CurrentBalance, CurrentBalanceCO, ManualInitialChargeOffReason, AutoInitialChargeOffReason
FROM PROD1GSDB01.ccgs_coreissue_secondary.dbo.StatementHeader SH WITH (NOLOCK)
WHERE SH.acctID = 4839430 
ORDER BY StatementDate DESC



SELECT TOP 10 SH.acctId, SH.StatementID, StatementDate, SHCC.CycleDueDTD,Principal, PrincipalCO, srbwithinstallmentdue, SHCC.sbwithinstallmentdue,
SH.AmountOfTotalDue, shcc.CurrentDue,SHCC.AmtOfPayXDLate,SHCC.AmountOfPayment30DLate, SHCC.AmountOfPayment60DLate, SHCC.AmountOfPayment90DLate, AmountOfPayment120DLate, AmountOfPayment150DLate, AmountOfPayment180DLate, AmountOfPayment210DLate,
(CurrentDue+AmtOfPayXDLate+AmountOfPayment30DLate+ AmountOfPayment60DLate+ AmountOfPayment90DLate+ AmountOfPayment120DLate+ AmountOfPayment150DLate+ AmountOfPayment180DLate + AmountOfPayment210DLate) AS CalculatedAD, CreditBalanceMovement
FROM PROD1GSDB01.ccgs_coreissue_secondary.dbo.SummaryHeader SH WITH (NOLOCK)
JOIN PROD1GSDB01.ccgs_coreissue.dbo.SummaryHeaderCreditCard SHCC WITH (NOLOCK) ON (SH.acctId = SHCC.acctId AND SH.StatementID = SHCC.StatementID)
WHERE SH.parent02AID = 794590 --AND SH.acctId = 33706671
ORDER BY StatementDate DESC


UPDATE StatementHeader SET
	AmtOfPayXDLate = 142 ,
	AmountOfPayment30DLate = AmtOfPayXDLate, 
	AmountOfPayment60DLate = AmountOfPayment30DLate, 
	AmountOfPayment90DLate = AmountOfPayment60DLate, 
	AmountOfPayment120DLate = AmountOfPayment90DLate, 
	AmountOfPayment150DLate = AmountOfPayment120DLate, 
	AmountOfPayment180DLate = AmountOfPayment180DLate + AmountOfPayment150DLate WHERE
acctId = 794590 AND StatementID = 54070229


SELECT  amtofpaycurrdue,
	142 AmtOfPayXDLate,
	AmtOfPayXDLate AmountOfPayment30DLate, 
	AmountOfPayment30DLate AmountOfPayment60DLate, 
	AmountOfPayment60DLate AmountOfPayment90DLate, 
	AmountOfPayment90DLate AmountOfPayment120DLate, 
	AmountOfPayment120DLate AmountOfPayment150DLate, 
	AmountOfPayment180DLate + AmountOfPayment150DLate AmountOfPayment180DLate ,
	(amtofpaycurrdue+AmtOfPayXDLate+AmountOfPayment30DLate+ AmountOfPayment60DLate+ AmountOfPayment90DLate+ AmountOfPayment120DLate+ AmountOfPayment150DLate+ AmountOfPayment180DLate+ 142)  CalculatedAD
	FROM StatementHeader WITH (NOLOCK)	WHERE acctId = 794590 AND StatementID = 54070229


SELECT  amtofpaycurrdue,
	142 AmtOfPayXDLate,
	AmtOfPayXDLate AmountOfPayment30DLate, 
	AmountOfPayment30DLate AmountOfPayment60DLate, 
	AmountOfPayment60DLate AmountOfPayment90DLate, 
	AmountOfPayment90DLate AmountOfPayment120DLate, 
	AmountOfPayment120DLate AmountOfPayment150DLate, 
	AmountOfPayment180DLate + AmountOfPayment150DLate AmountOfPayment180DLate ,
	(amtofpaycurrdue+AmtOfPayXDLate+AmountOfPayment30DLate+ AmountOfPayment60DLate+ AmountOfPayment90DLate+ AmountOfPayment120DLate+ AmountOfPayment150DLate+ AmountOfPayment180DLate+ 142)  CalculatedAD
	FROM BSegmentCreditCard BCC WITH (NOLOCK)	
	JOIN BSegment_Primary BP WITH (NOLOCK) ON (BP.acctId = BCC.acctId)
	WHERE BP.acctId = 794590 


SELECT  amtofpaycurrdue,
	142 AmtOfPayXDLate,
	AmtOfPayXDLate AmountOfPayment30DLate, 
	AmountOfPayment30DLate AmountOfPayment60DLate, 
	AmountOfPayment60DLate AmountOfPayment90DLate, 
	AmountOfPayment90DLate AmountOfPayment120DLate, 
	AmountOfPayment120DLate AmountOfPayment150DLate, 
	AmountOfPayment180DLate + AmountOfPayment150DLate AmountOfPayment180DLate ,
	(amtofpaycurrdue+AmtOfPayXDLate+AmountOfPayment30DLate+ AmountOfPayment60DLate+ AmountOfPayment90DLate+ AmountOfPayment120DLate+ AmountOfPayment150DLate+ AmountOfPayment180DLate+ 142)  CalculatedAD
	FROM AccountInfoForReport WITH (NOLOCK)	WHERE BSacctId = 794590 AND Businessday = '2021-01-31 23:59:57.000'





SELECT  
	AmountOfTotalDue,
	amtofpaycurrdue,
	AmtOfPayXDLate,
	AmtOfPayXDLate , 
	AmountOfPayment30DLate , 
	AmountOfPayment60DLate , 
	AmountOfPayment90DLate , 
	AmountOfPayment120DLate ,
	AmountOfPayment150DLate, 
	AmountOfPayment180DLate  
FROM BSegmentCreditCard BCC WITH (NOLOCK)	
JOIN BSegment_Primary BP WITH (NOLOCK) ON (BP.acctId = BCC.acctId)
WHERE BP.acctId = 4839430

SELECT  
	'AmountOfTotalDue = AmountOfTotalDue - ' + CAST(AmountOfTotalDue AS VARCHAR) 
	+ ', AmtOfPayCurrDue = AmtOfPayCurrDue - ' + CAST(AmtOfPayCurrDue AS VARCHAR)
	+ ', AmtOfPayXDLate = AmtOfPayXDLate - ' + CAST(AmtOfPayXDLate AS VARCHAR)
	+ ', AmountOfPayment30DLate = AmountOfPayment30DLate - ' + CAST(AmountOfPayment30DLate AS VARCHAR)
	+ ', AmountOfPayment60DLate = AmountOfPayment60DLate - ' + CAST(AmountOfPayment60DLate AS VARCHAR)
	+ ', AmountOfPayment90DLate = AmountOfPayment90DLate - ' + CAST(AmountOfPayment90DLate AS VARCHAR)
	+ ', AmountOfPayment120DLate = AmountOfPayment120DLate - ' + CAST(AmountOfPayment120DLate AS VARCHAR)
	+ ', AmountOfPayment150DLate = AmountOfPayment150DLate - ' + CAST(AmountOfPayment150DLate AS VARCHAR)
	+ ', AmountOfPayment180DLate = AmountOfPayment180DLate - ' + CAST(AmountOfPayment180DLate AS VARCHAR) 
FROM BSegmentCreditCard BCC WITH (NOLOCK)	
JOIN BSegment_Primary BP WITH (NOLOCK) ON (BP.acctId = BCC.acctId)
WHERE BP.acctId = 4839430


SELECT 'UPDATE CPSgmentCreditCard SET '  +
	'AmountOfTotalDue = AmountOfTotalDue - ' + CAST(AmountOfTotalDue AS VARCHAR) 
	+ ', AmtOfPayCurrDue = AmtOfPayCurrDue - ' + CAST(AmtOfPayCurrDue AS VARCHAR)
	+ ', AmtOfPayXDLate = AmtOfPayXDLate - ' + CAST(AmtOfPayXDLate AS VARCHAR)
	+ ', AmountOfPayment30DLate = AmountOfPayment30DLate - ' + CAST(AmountOfPayment30DLate AS VARCHAR)
	+ ', AmountOfPayment60DLate = AmountOfPayment60DLate - ' + CAST(AmountOfPayment60DLate AS VARCHAR)
	+ ', AmountOfPayment90DLate = AmountOfPayment90DLate - ' + CAST(AmountOfPayment90DLate AS VARCHAR)
	+ ', AmountOfPayment120DLate = AmountOfPayment120DLate - ' + CAST(AmountOfPayment120DLate AS VARCHAR)
	+ ', AmountOfPayment150DLate = AmountOfPayment150DLate - ' + CAST(AmountOfPayment150DLate AS VARCHAR)
	+ ', AmountOfPayment180DLate = AmountOfPayment180DLate - ' + CAST(AmountOfPayment180DLate AS VARCHAR) 
	+ ' WHERE acctId = 10059588'
FROM CPSgmentCreditCard  WITH (NOLOCK)	
WHERE acctId = 10059588


SELECT 'UPDATE SummaryHeaderCreditCard SET ' 
	--+ 'AmountOfTotalDue = AmountOfTotalDue - ' + CAST(AmountOfTotalDue AS VARCHAR) 
	+ ', CurrentDue = CurrentDue - ' + CAST(CurrentDue AS VARCHAR)
	+ ', AmtOfPayXDLate = AmtOfPayXDLate - ' + CAST(AmtOfPayXDLate AS VARCHAR)
	+ ', AmountOfPayment30DLate = AmountOfPayment30DLate - ' + CAST(AmountOfPayment30DLate AS VARCHAR)
	+ ', AmountOfPayment60DLate = AmountOfPayment60DLate - ' + CAST(AmountOfPayment60DLate AS VARCHAR)
	+ ', AmountOfPayment90DLate = AmountOfPayment90DLate - ' + CAST(AmountOfPayment90DLate AS VARCHAR)
	+ ', AmountOfPayment120DLate = AmountOfPayment120DLate - ' + CAST(AmountOfPayment120DLate AS VARCHAR)
	+ ', AmountOfPayment150DLate = AmountOfPayment150DLate - ' + CAST(AmountOfPayment150DLate AS VARCHAR)
	+ ', AmountOfPayment180DLate = AmountOfPayment180DLate - ' + CAST(AmountOfPayment180DLate AS VARCHAR) 
	+ ' WHERE acctId = 10059588 AND StatementID = 56522749'
FROM SummaryHeaderCreditCard  WITH (NOLOCK)	
WHERE acctId = 10059588 AND StatementID = 56522749


SELECT 'UPDATE StatementHeader SET ' 
	+ 'AmountOfTotalDue = AmountOfTotalDue - ' + CAST(AmountOfTotalDue AS VARCHAR) 
	+ ', AmtOfPayCurrDue = AmtOfPayCurrDue - ' + CAST(AmtOfPayCurrDue AS VARCHAR)
	+ ', AmtOfPayXDLate = AmtOfPayXDLate - ' + CAST(AmtOfPayXDLate AS VARCHAR)
	+ ', AmountOfPayment30DLate = AmountOfPayment30DLate - ' + CAST(AmountOfPayment30DLate AS VARCHAR)
	+ ', AmountOfPayment60DLate = AmountOfPayment60DLate - ' + CAST(AmountOfPayment60DLate AS VARCHAR)
	+ ', AmountOfPayment90DLate = AmountOfPayment90DLate - ' + CAST(AmountOfPayment90DLate AS VARCHAR)
	+ ', AmountOfPayment120DLate = AmountOfPayment120DLate - ' + CAST(AmountOfPayment120DLate AS VARCHAR)
	+ ', AmountOfPayment150DLate = AmountOfPayment150DLate - ' + CAST(AmountOfPayment150DLate AS VARCHAR)
	+ ', AmountOfPayment180DLate = AmountOfPayment180DLate - ' + CAST(AmountOfPayment180DLate AS VARCHAR) 
	+ ' WHERE acctId = 4839430 AND StatementID = 56522749'
FROM StatementHeader  WITH (NOLOCK)	
WHERE acctId = 4839430 AND StatementID = 56522749


SELECT 'UPDATE AccountInfoForReport SET ' 
	+ 'AmountOfTotalDue = AmountOfTotalDue - ' + CAST(AmountOfTotalDue AS VARCHAR) 
	+ ', AmtOfPayCurrDue = AmtOfPayCurrDue - ' + CAST(AmtOfPayCurrDue AS VARCHAR)
	+ ', AmtOfPayXDLate = AmtOfPayXDLate - ' + CAST(AmtOfPayXDLate AS VARCHAR)
	+ ', AmountOfPayment30DLate = AmountOfPayment30DLate - ' + CAST(AmountOfPayment30DLate AS VARCHAR)
	+ ', AmountOfPayment60DLate = AmountOfPayment60DLate - ' + CAST(AmountOfPayment60DLate AS VARCHAR)
	+ ', AmountOfPayment90DLate = AmountOfPayment90DLate - ' + CAST(AmountOfPayment90DLate AS VARCHAR)
	+ ', AmountOfPayment120DLate = AmountOfPayment120DLate - ' + CAST(AmountOfPayment120DLate AS VARCHAR)
	+ ', AmountOfPayment150DLate = AmountOfPayment150DLate - ' + CAST(AmountOfPayment150DLate AS VARCHAR)
	+ ', AmountOfPayment180DLate = AmountOfPayment180DLate - ' + CAST(AmountOfPayment180DLate AS VARCHAR) 
	+ ' WHERE BSacctId = 4839430 AND Businessday = ''2021-01-31 23:59:57.000'''
FROM AccountInfoForReport  WITH (NOLOCK)	
WHERE BSacctId = 4839430 AND Businessday = '2021-01-31 23:59:57.000'


SELECT 'UPDATE PlanInfoForReport SET ' 
	+ 'AmountOfTotalDue = AmountOfTotalDue - ' + CAST(AmountOfTotalDue AS VARCHAR) 
	+ ', AmtOfPayCurrDue = AmtOfPayCurrDue - ' + CAST(AmtOfPayCurrDue AS VARCHAR)
	+ ', AmtOfPayXDLate = AmtOfPayXDLate - ' + CAST(AmtOfPayXDLate AS VARCHAR)
	+ ', AmountOfPayment30DLate = AmountOfPayment30DLate - ' + CAST(AmountOfPayment30DLate AS VARCHAR)
	+ ', AmountOfPayment60DLate = AmountOfPayment60DLate - ' + CAST(AmountOfPayment60DLate AS VARCHAR)
	+ ', AmountOfPayment90DLate = AmountOfPayment90DLate - ' + CAST(AmountOfPayment90DLate AS VARCHAR)
	+ ', AmountOfPayment120DLate = AmountOfPayment120DLate - ' + CAST(AmountOfPayment120DLate AS VARCHAR)
	+ ', AmountOfPayment150DLate = AmountOfPayment150DLate - ' + CAST(AmountOfPayment150DLate AS VARCHAR)
	+ ', AmountOfPayment180DLate = AmountOfPayment180DLate - ' + CAST(AmountOfPayment180DLate AS VARCHAR) 
	+ ' WHERE CPSacctId = 10059588 AND Businessday = ''2021-01-31 23:59:57.000'''
FROM PlanInfoForReport  WITH (NOLOCK)	
WHERE CPSacctId = 10059588 AND Businessday = '2021-01-31 23:59:57.000'