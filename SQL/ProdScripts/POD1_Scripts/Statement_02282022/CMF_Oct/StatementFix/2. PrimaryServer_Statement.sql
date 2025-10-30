-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO


BEGIN TRANSACTION
--COMMIT TRANSACTION
-- ROLLBACK TRANSACTION

Update TOP(1) ccard_primary set artxntype = '93' where trnaid = 48181220807  -- 1 row
Update TOP(1) logartxnaddl set artxntype = '93' where trnaid = 48181220807  -- 1 row


update StatementHeader set CycleDueDTD = 1, AmtOfPayCurrDue = 46.67,AmtOfPayXDLate = 0,systemstatus = 2 where acctid = 21644933 and statementid = 110254270
update SummaryHeader set AmountOfTotalDue = 0 where acctid in (67639682,67677141,67677142,67677143)  and statementid = 110254270
update SummaryHeaderCreditCard set CycleDueDTD = 0, AmtOfPayXDLate = 0 where acctid in (67639682,67677141,67677142,67677143)  and statementid = 110254270
update SummaryHeader set AmountOfTotalDue = 46.67 where acctid in (68367664)  and statementid = 110254270
update SummaryHeaderCreditCard set CycleDueDTD = 1, CurrentDue = 46.67 where acctid in (68367664)  and statementid = 110254270

update StatementHeader set CycleDueDTD = 1, AmtOfPayCurrDue = 92.73,AmtOfPayXDLate = 0,systemstatus = 2 where acctid = 21559947 and statementid = 110188940
update SummaryHeader set AmountOfTotalDue = 0 where acctid in (67667741)  and statementid = 110188940
update SummaryHeaderCreditCard set CycleDueDTD = 0, AmtOfPayXDLate = 0 where acctid in (67667741)  and statementid = 110188940
update SummaryHeader set AmountOfTotalDue = 92.73 where acctid in (68093426)  and statementid = 110188940
update SummaryHeaderCreditCard set CycleDueDTD = 1, CurrentDue = 92.73 where acctid in (68093426)  and statementid = 110188940

update StatementHeader set CycleDueDTD = 0, AmtOfPayCurrDue = 0,AmtOfPayXDLate = 0,systemstatus = 2 where acctid = 21398996 and statementid = 110070383
update SummaryHeader set AmountOfTotalDue = 0 where acctid in (66461063,66461064,66617650,67720005)  and statementid = 110070383
update SummaryHeaderCreditCard set CycleDueDTD = 0, AmtOfPayXDLate = 0 where acctid in (66461063,66461064,66617650,67720005)   and statementid = 110070383



UPDATE TOP(1) StatementHeader SET AmtOfPayCurrDue = AmtOfPayCurrDue + 3.23, AmtOfPayXDLate = AmtOfPayXDLate - 3.23,
AmtOfPayPastDue = AmtOfPayPastDue - 3.23, SRBWithInstallmentDue = SRBWithInstallmentDue + 30.44, 
SBWithInstallmentDue = SBWithInstallmentDue + 30.44, CycleDueDTD = 1, SystemStatus = 2 WHERE acctId = 14886219 AND StatementID = 108557017

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = 0 WHERE acctId = 45925730 AND StatementID = 108557017
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0, CurrentDue = 0, AmtOfPayXDLate = 0 WHERE acctId = 45925730 AND StatementID = 108557017

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue + 154.94 WHERE acctId = 63292415 AND StatementID = 108557017
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 1, CurrentDue = CurrentDue + 154.94, SRBWithInstallmentDue = SRBWithInstallmentDue + 154.94, 
SBWithInstallmentDue = SBWithInstallmentDue + 154.94 WHERE acctId = 63292415 AND StatementID = 108557017



UPDATE TOP(1) StatementHeader SET AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmtOfPayPastDue = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0, , AmountOfTotalDue = 0,MinimumPaymentDue = 0,
CycleDueDTD = 0, SystemStatus = 2 WHERE acctId = 16564141 AND StatementID = 108942906



UPDATE TOP(1) StatementHeader SET AmtOfPayCurrDue = AmtOfPayCurrDue + 88.16, AmtOfPayXDLate = AmtOfPayXDLate - 88.16,
AmtOfPayPastDue = AmtOfPayPastDue - 88.16, SRBWithInstallmentDue = SRBWithInstallmentDue - 88.16, 
SBWithInstallmentDue = SBWithInstallmentDue - 88.16 WHERE acctId = 18074751 AND StatementID = 108819515

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = 0 WHERE acctId = 67273308 AND StatementID = 108819515
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0, CurrentDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, 
SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 67273308 AND StatementID = 108819515

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = 0 WHERE acctId = 67273309 AND StatementID = 108819515
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0, CurrentDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, 
SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 67273309 AND StatementID = 108819515



UPDATE TOP(1) StatementHeader SET AmtOfPayCurrDue = AmtOfPayCurrDue + 22.04, AmtOfPayXDLate = AmtOfPayXDLate - 22.04,
AmtOfPayPastDue = AmtOfPayPastDue - 22.04, SRBWithInstallmentDue = SRBWithInstallmentDue - 22.04, 
SBWithInstallmentDue = SBWithInstallmentDue - 22.04, CycleDueDTD = 1, SystemStatus = 2 WHERE acctId = 18310493 AND StatementID = 108909968

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = 0 WHERE acctId = 67431627 AND StatementID = 108909968
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0, CurrentDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, 
SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 67431627 AND StatementID = 108909968

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue + 16.35 WHERE acctId = 68410214 AND StatementID = 108909968
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 1, CurrentDue = CurrentDue + 16.35 WHERE acctId = 68410214 AND StatementID = 108909968



UPDATE TOP(1) StatementHeader SET AmtOfPayCurrDue = AmtOfPayCurrDue + 0.03, AmtOfPayXDLate = AmtOfPayXDLate - 0.03,
AmtOfPayPastDue = AmtOfPayPastDue - 0.03, SRBWithInstallmentDue = SRBWithInstallmentDue + 32.04, 
SBWithInstallmentDue = SBWithInstallmentDue + 32.04, CycleDueDTD = 1, SystemStatus = 2 WHERE acctId = 18533310 AND StatementID = 109484449

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = 0 WHERE acctId = 57747124 AND StatementID = 109484449
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0, CurrentDue = 0, AmtOfPayXDLate = 0 WHERE acctId = 57747124 AND StatementID = 109484449

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue + 672.86 WHERE acctId = 58404925 AND StatementID = 109484449
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 1, CurrentDue = CurrentDue + 672.86, SRBWithInstallmentDue = SRBWithInstallmentDue + 672.86, 
SBWithInstallmentDue = SBWithInstallmentDue + 672.86 WHERE acctId = 58404925 AND StatementID = 109484449



UPDATE TOP(1) StatementHeader SET AmtOfPayCurrDue = AmtOfPayCurrDue + 146.41, AmtOfPayXDLate = AmtOfPayXDLate - 146.41,
AmtOfPayPastDue = AmtOfPayPastDue - 146.41, SRBWithInstallmentDue = SRBWithInstallmentDue - 146.41, 
SBWithInstallmentDue = SBWithInstallmentDue - 146.41, CycleDueDTD = 1, SystemStatus = 2 WHERE acctId = 21398959 AND StatementID = 110071881

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = 0 WHERE acctId = 67325735 AND StatementID = 110071881
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0, CurrentDue = 0, AmtOfPayXDLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 67325735 AND StatementID = 110071881

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = 0 WHERE acctId = 67325734 AND StatementID = 110071881
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0, CurrentDue = 0, AmtOfPayXDLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 67325734 AND StatementID = 110071881

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = 0 WHERE acctId = 67325733 AND StatementID = 110071881
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0, CurrentDue = 0, AmtOfPayXDLate = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 67325733 AND StatementID = 110071881

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue + 49.94 WHERE acctId = 67074334 AND StatementID = 110071881
UPDATE TOP(1) SummaryHeaderCreditCard SET CurrentDue = CurrentDue + 49.94, CycleDueDTD = 1 WHERE acctId = 67074334 AND StatementID = 110071881

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue + 133.47 WHERE acctId = 66617613 AND StatementID = 110071881
UPDATE TOP(1) SummaryHeaderCreditCard SET CurrentDue = CurrentDue + 133.47 WHERE acctId = 66617613 AND StatementID = 110071881



update  top(1) summaryheader  set  amountoftotaldue  = amountoftotaldue  - 108.25  where  acctid   = 66251264 and  statementid  = 109741400
	update  top(1) SummaryHeaderCreditCard  set   
	 amtofpayxdlate = amtofpayxdlate  - 108.25  , cycleduedtd  = cycleduedtd  - 2  where  acctid   = 66251264 and  statementid  = 109741400

	 update  top(1) summaryheader  set  amountoftotaldue  = amountoftotaldue  + 38.97  where  acctid   = 67937761 and  statementid  = 109741400
update  top(1) SummaryHeaderCreditCard  set      currentdue = currentdue  + 38.97   , cycleduedtd  = cycleduedtd  + 1  
where  acctid   = 67937761 and  statementid  = 109741400


	update  top(1) summaryheader  set  amountoftotaldue  = amountoftotaldue  + 8.08  where  acctid   = 61130944 and  statementid  = 109741400
	update  top(1) SummaryHeaderCreditCard  set  
	 currentdue = currentdue  + 8.08    where  acctid   = 61130944 and  statementid  = 109741400

	 update  top(1) statementheader  set  AmtOfPayPastDue  = AmtOfPayPastDue  - 108.25   ,
	 srbwithinstallmentdue = srbwithinstallmentdue  - 108.25  , sbwithinstallmentdue = sbwithinstallmentdue  - 108.25 
	  , amtofpaycurrdue = amtofpaycurrdue + 108.25  , amtofpayxdlate = amtofpayxdlate  - 108.25 
	   where  acctid   = 19628952 and  statementid  = 109741400


	  update  top(1) summaryheader  set  amountoftotaldue  = amountoftotaldue  + 1.01  where  acctid   = 63449589 and  statementid  = 109881012
update  top(1) SummaryHeaderCreditCard  set    currentdue = currentdue  + 1.01  where  acctid   = 63449589 and  statementid  = 109881012


update  top(1) summaryheader  set  amountoftotaldue  = amountoftotaldue  - 41.62  where  acctid   = 66820565 and  statementid  = 109881012
update  top(1) SummaryHeaderCreditCard  set     srbwithinstallmentdue = srbwithinstallmentdue  - 41.62  , sbwithinstallmentdue = sbwithinstallmentdue  - 41.62 
 , currentdue = currentdue  - 41.62  , cycleduedtd  = cycleduedtd  - 2  where  acctid   = 66820565 and  statementid  = 109881012



 update  top(1) summaryheader  set  amountoftotaldue  = amountoftotaldue  +  7.38  where  acctid   = 69347016 and  statementid  = 109881012
 	update  top(1) SummaryHeaderCreditCard  set     srbwithinstallmentdue = srbwithinstallmentdue  + 7.38  
	, sbwithinstallmentdue = sbwithinstallmentdue  + 7.38  , currentdue = currentdue  + 7.38 
	where  acctid   = 69347016 and  statementid  = 109881012



	update  top(1) statementheader  set   MinimumPaymentDue  = MinimumPaymentDue  - 3.30  ,AmtOfPayPastDue  = AmtOfPayPastDue  - 41.62  
	 ,srbwithinstallmentdue = srbwithinstallmentdue  - 37.54  , sbwithinstallmentdue = sbwithinstallmentdue  - 37.54  
	 , amtofpaycurrdue = amtofpaycurrdue  + 38.32  , amtofpayxdlate = amtofpayxdlate  - 41.62  , cycleduedtd  = cycleduedtd  - 1 , systemstatus =2 
	 , DateOfOriginalPaymentDueDTD = null  where  acctid   = 19628952 and  statementid  = 109741400

	  

	  update  top(1) summaryheader  set  amountoftotaldue  = amountoftotaldue  - 33.70  where  acctid   = 67656519 and  statementid  = 109961293
	update  top(1) SummaryHeaderCreditCard  set   
	 amtofpayxdlate = amtofpayxdlate  - 33.70  , cycleduedtd  = cycleduedtd  - 2 ,
	 srbwithinstallmentdue = srbwithinstallmentdue  - 33.70  , sbwithinstallmentdue = sbwithinstallmentdue  - 33.70  
	  where  acctid   = 67656519 and  statementid  = 109961293



	  

	  update  top(1) summaryheader  set  amountoftotaldue  = amountoftotaldue  - 8.29  where  acctid   = 67656520 and  statementid  = 109961293
	update  top(1) SummaryHeaderCreditCard  set   
	 amtofpayxdlate = amtofpayxdlate  - 8.29  , cycleduedtd  = cycleduedtd  - 2 ,
	 srbwithinstallmentdue = srbwithinstallmentdue  - 8.29  , sbwithinstallmentdue = sbwithinstallmentdue  - 8.29  
	  where  acctid   = 67656520 and  statementid  = 109961293



	  
	  update  top(1) summaryheader  set  amountoftotaldue  = amountoftotaldue  - 32.36  where  acctid   = 68406221 and  statementid  = 109961293
	update  top(1) SummaryHeaderCreditCard  set   
	 amtofpayxdlate = amtofpayxdlate  - 32.36  , cycleduedtd  = cycleduedtd  +1  	  where  acctid   = 68406221 and  statementid  = 109961293


	 
	 update  top(1) statementheader  set  AmtOfPayPastDue  = AmtOfPayPastDue -41.99,
	 srbwithinstallmentdue = srbwithinstallmentdue - 41.99  , sbwithinstallmentdue = sbwithinstallmentdue -  41.99 
	  , amtofpaycurrdue = amtofpaycurrdue  + 41.99  , amtofpayxdlate = amtofpayxdlate  - 41.99 
	  , cycleduedtd  = cycleduedtd  - 1, systemstatus =2   where  acctid   = 21091933 and  statementid  = 109961293

	  --------


	  
	  update  top(1) summaryheader  set  amountoftotaldue  = amountoftotaldue  + 1088.91 where  acctid   = 69880756 and  statementid  = 110034466
	update  top(1) SummaryHeaderCreditCard  set   
	 CurrentDue = CurrentDue  + 1088.91  , cycleduedtd  = cycleduedtd  - 2 ,
	 srbwithinstallmentdue = srbwithinstallmentdue  + 1088.91  , sbwithinstallmentdue = sbwithinstallmentdue + 1088.91
	  where  acctid   = 69880756 and  statementid  = 110034466



	  
	  update  top(1) summaryheader  set  amountoftotaldue  = amountoftotaldue  - 25  where  acctid   = 66584366 and  statementid  = 110034466
	update  top(1) SummaryHeaderCreditCard  set   
	 amtofpayxdlate = amtofpayxdlate  - 25 , cycleduedtd  = cycleduedtd  -2  	  where  acctid   = 66584366 and  statementid  = 110034466


	 
	 update  top(1) statementheader  set  AmtOfPayPastDue  = AmtOfPayPastDue - 25 ,
	 srbwithinstallmentdue = srbwithinstallmentdue  +45.37 , sbwithinstallmentdue = sbwithinstallmentdue  +45.37
	  , amtofpaycurrdue = amtofpaycurrdue +25 , amtofpayxdlate = amtofpayxdlate  - 25
	  , cycleduedtd  = cycleduedtd  - 1, systemstatus =2   where  acctid   = 21365712 and  statementid  = 110034466
