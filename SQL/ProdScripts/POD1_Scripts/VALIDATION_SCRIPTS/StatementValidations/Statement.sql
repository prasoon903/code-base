
DECLARE @BSacctId INT , @LastSatementDate DATETIME, @Businessday DATETIME, @CPSAcctID INT, @CCARD INT = 0, @EOD INT = 0, @Statement INT = 0
-- 4733586, 12887, 3783604, 10772, 284978, 3748505, 2259429, 4640763, 275808, 4337624, 10667
--1255358
SET @BSacctId =  244248
--SELECT @BSacctId = acctID FROM Bsegment_Primary WITH (NOLOCK) WHERE AccountNumber = '1100011125083372'
--SELECT @BSacctId = acctID FROM Bsegment_Primary WITH (NOLOCK) WHERE UniversalUniqueID = '2c1d795a-f876-4519-9af5-02e930a6dfee'
SET @LastSatementDate = '2021-10-31 23:59:57.000'
SET @Businessday = '2021-10-31 23:59:57.000'
SET @CCARD = 1
SET @EOD = 0
SET @Statement = 1

SELECT TOP 100 'Statement====>', acctId, SystemStatus, ccinhparent125AID, CycleDueDTD, SH.StatementID, StatementDate, Principal, MinimumPaymentDue, AmtOfPayPastDue, AmountOFPaymentsCTD, IntBilledNotPaid, SBWithInstallmentDue, SRBWithInstallmentDue, SH.AmountOfTotalDue,amtofpaycurrdue,AmtOfPayXDLate,AmountOfPayment30DLate, AmountOfPayment60DLate, 
AmountOfPayment90DLate, AmountOfPayment120DLate, AmountOfPayment150DLate, AmountOfPayment180DLate,AmountOfPayment210DLate,
(amtofpaycurrdue+AmtOfPayXDLate+AmountOfPayment30DLate+ AmountOfPayment60DLate+ AmountOfPayment90DLate+ AmountOfPayment120DLate+ AmountOfPayment150DLate+ AmountOfPayment180DLate+ AmountOfPayment210DLate) AS CalculatedAD,
SH.CycleDueDTD, DateOfOriginalPaymentDUeDTD, SystemStatus, CCInhParent125AID, BeginningBalance, CurrentBalance, CurrentBalanceCO, ManualInitialChargeOffReason, AutoInitialChargeOffReason, WaiveMinDue
FROM LS_PRODDRGSDB01.ccgs_coreissue_secondary.dbo.StatementHeader SH WITH (NOLOCK)
WHERE SH.acctID = @BSacctId AND StatementDate = @LastSatementDate
ORDER BY StatementDate DESC


SELECT 'Summary====>',SH.acctId, SH.StatementID, StatementDate, CreditPlanType, DisputesAmtNS, SHCC.CycleDueDTD, CurrentBalance, CurrentBalanceCO,Principal, PrincipalCO, OriginalPurchaseAmount, 
AmountOfCreditsLTD, AmountOfCreditsRevLTD, srbwithinstallmentdue, srbwithinstallmentduecc1, SHCC.sbwithinstallmentdue,
SH.AmountOfTotalDue, shcc.CurrentDue,SHCC.AmtOfPayXDLate,SHCC.AmountOfPayment30DLate, SHCC.AmountOfPayment60DLate, SHCC.AmountOfPayment90DLate, AmountOfPayment120DLate, AmountOfPayment150DLate, AmountOfPayment180DLate, AmountOfPayment210DLate,
(CurrentDue+AmtOfPayXDLate+AmountOfPayment30DLate+ AmountOfPayment60DLate+ AmountOfPayment90DLate+ AmountOfPayment120DLate+ AmountOfPayment150DLate+ AmountOfPayment180DLate + AmountOfPayment210DLate) AS CalculatedAD, 
CreditBalanceMovement, EqualPaymentAmt,beginningbalance
FROM LS_PRODDRGSDB01.ccgs_coreissue_secondary.dbo.SummaryHeader SH WITH (NOLOCK)
JOIN LS_PRODDRGSDB01.ccgs_coreissue.dbo.SummaryHeaderCreditCard SHCC WITH (NOLOCK) ON (SH.acctId = SHCC.acctId AND SH.StatementID = SHCC.StatementID)
WHERE SH.parent02AID = @BSacctId AND StatementDate = @LastSatementDate
ORDER BY StatementDate DESC

--select * from  mergeaccountjob  with(nolock) where  srcbsacctid = @BSacctId  or destbsacctid = @BSacctId


--Declare @AmounttoAdjust money = '108.25' ,@currentDuesummaryAdjust  money = '8.08' ,@cycleDTDAdj int  =2

--SELECT 'update  top(1) SummaryHeaderCreditCard  set  amountoftotaldue  = amountoftotaldue - ''' + cast( @AmounttoAdjust as varchar)  +  ''' 
--, srbwithinstallmentdue = srbwithinstallmentdue  - ''' +  cast( @AmounttoAdjust as varchar)   +  ''',
--, sbwithinstallmentdue = sbwithinstallmentdue  - ''' +  cast( @AmounttoAdjust as varchar)   +  ''',
--, amtofpayxdlate = amtofpayxdlate  - ''' +  cast( @AmounttoAdjust as varchar)   +  ''',
--, cycleduedtd  = cycleduedtd  - ''' +  cast (@cycleDTDAdj  as varchar ) +  ''

--FROM LS_PRODDRGSDB01.ccgs_coreissue_secondary.dbo.SummaryHeader SH WITH (NOLOCK)
--JOIN LS_PRODDRGSDB01.ccgs_coreissue.dbo.SummaryHeaderCreditCard SHCC WITH (NOLOCK) ON (SH.acctId = SHCC.acctId AND SH.StatementID = SHCC.StatementID)
--WHERE SH.parent02AID = @BSacctId AND StatementDate = @LastSatementDate
--ORDER BY StatementDate DESC  


--update  top(1) SummaryHeaderCreditCard  set  amountoftotaldue  = amountoftotaldue - '108.25'   , srbwithinstallmentdue = srbwithinstallmentdue  - '108.25',  , sbwithinstallmentdue = sbwithinstallmentdue  - '108.25',  , amtofpayxdlate = amtofpayxdlate  - '108.25',  , cycleduedtd  = cycleduedtd  - '2
--update  top(1) SummaryHeaderCreditCard  set  amountoftotaldue  = amountoftotaldue - '108.25'   , srbwithinstallmentdue = srbwithinstallmentdue  - '108.25',  , sbwithinstallmentdue = sbwithinstallmentdue  - '108.25',  , amtofpayxdlate = amtofpayxdlate  - '108.25',  , cycleduedtd  = cycleduedtd  - '2
--update  top(1) SummaryHeaderCreditCard  set  amountoftotaldue  = amountoftotaldue - '108.25'   , srbwithinstallmentdue = srbwithinstallmentdue  - '108.25',  , sbwithinstallmentdue = sbwithinstallmentdue  - '108.25',  , amtofpayxdlate = amtofpayxdlate  - '108.25',  , cycleduedtd  = cycleduedtd  - '2



--SELECT TOP 100 'Statement====>', acctId, SystemStatus, CycleDueDTD, SH.StatementID, StatementDate, Principal, MinimumPaymentDue, AmtOfPayPastDue, AmountOFPaymentsCTD, IntBilledNotPaid, SBWithInstallmentDue, SRBWithInstallmentDue, SH.AmountOfTotalDue,amtofpaycurrdue,AmtOfPayXDLate,AmountOfPayment30DLate, AmountOfPayment60DLate, 
--AmountOfPayment90DLate, AmountOfPayment120DLate, AmountOfPayment150DLate, AmountOfPayment180DLate,AmountOfPayment210DLate,
--(amtofpaycurrdue+AmtOfPayXDLate+AmountOfPayment30DLate+ AmountOfPayment60DLate+ AmountOfPayment90DLate+ AmountOfPayment120DLate+ AmountOfPayment150DLate+ AmountOfPayment180DLate+ AmountOfPayment210DLate) AS CalculatedAD,
--SH.CycleDueDTD, DateOfOriginalPaymentDUeDTD, SystemStatus, CCInhParent125AID, BeginningBalance, CurrentBalance, CurrentBalanceCO, ManualInitialChargeOffReason, AutoInitialChargeOffReason, WaiveMinDue
--FROM LS_PRODDRGSDB01.ccgs_coreissue_secondary.dbo.StatementHeader SH WITH (NOLOCK)
--WHERE SH.acctID IN
--(12415, 13524, 14117, 47850, 52711, 115716, 122810, 244248, 417786, 588281, 659234, 883659, 1240951, 
--1255358, 1344799, 1356278, 1378174, 1392139, 1508643, 1722050, 1841625, 1845697, 2105008, 2706267, 2724147, 2837196, 2983913,
--3996361, 7853217, 8940606, 9806096, 10655987, 11089488, 11520974, 13572797, 13611044, 18041996, 18390195, 13071394, 20602937, 
--14886219, 16564141, 18074751, 18310493, 18533310)
--AND SystemStatus = 2
--AND StatementDate = '2021-10-31 23:59:57.000'
--ORDER BY StatementDate DESC


--12415,13524,14117,47850,52711,115716,122810,244248,417786,588281,659234,883659,1240951,1255358,1344799,1356278,1378174,
--1508643,1722050,1841625,1845697,2105008,2706267,2724147,2837196,3996361,7853217,8940606,
--9806096
--10655987
--11089488
--11520974
--13071394
--13572797
--13611044
--14886219
--16564141
--18041996
--18310493
--18390195
--18533310
--20602937