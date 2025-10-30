-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO


BEGIN TRANSACTION
--COMMIT TRANSACTION
-- ROLLBACK TRANSACTION




--UPDATE LoyaltyStatementHeader SET 
--de_LtyPrgSeg_CurrentBalance		=	de_LtyPrgSeg_CurrentBalance - 687.00
--WHERE AcctId = 114162964
---- 1 Row



--UPDATE TOP(1) BSegment_Primary SET Principal = Principal - 35.86 WHERE acctId = 20453980

--UPDATE TOP(1) BSegmentCreditCard SET NEWTRANSACTIONSBSFC = NEWTRANSACTIONSBSFC - 35.86 WHERE acctId = 20453980



--UPDATE TOP(1) CPSgmentAccounts SET Principal = Principal - 35.86, CurrentBalance = CurrentBalance - 35.86, decurrentbalance_trantime_ps = decurrentbalance_trantime_ps - 35.86 WHERE acctId = 63086428



--UPDATE LpSegmentAccounts SET de_LtyPrgSeg_CurrentBalance =  de_LtyPrgSeg_CurrentBalance - 108  where acctid  = 114133125
--UPDATE LpSegmentAccounts SET de_LtyPrgSeg_CurrentBalance =  de_LtyPrgSeg_CurrentBalance - 2220  where acctid  = 114173000


--UPDATE LoyaltyInfoForReport SET Points  = 0 WHERE SKey IN(2499427534,2493307971,2487197467,2481092686,2475000931,2468919053,2462849137,2456780112,2450727786)
--UPDATE LoyaltyInfoForReport SET Points  = 0 WHERE SKey IN(2499439188,2493315011,2487210055,2481106644,2475017831,2468934904,2462857313,2456787785,2450727956)


--UPDATE  LoyaltyStatementHeader  SET de_LtyPrgSeg_CurrentBalance = 0.00 WHERE acctid  = 114173000

--UPDATE LpSegmentAccounts SET 
--de_LtyPrgSeg_CurrentBalance		=	de_LtyPrgSeg_CurrentBalance - 687.00
--WHERE AcctId = 114162964
---- 1 Row

--UPDATE LoyaltyStatementHeader SET 
--de_LytPrgSeg_CTD_CreditsAmount	=	de_LytPrgSeg_CTD_CreditsAmount	- 687.00,
--de_LytPrgSeg_CTD_CreditsCount	=	de_LytPrgSeg_CTD_CreditsCount	- 1,
--de_LytPrgSeg_YTD_CreditsAmount	=	de_LytPrgSeg_YTD_CreditsAmount	- 687.00,
--de_LytPrgSeg_YTD_CreditsCount	=	de_LytPrgSeg_YTD_CreditsCount	- 1,
--de_LytPrgSeg_LTD_CreditsAmount	=	de_LytPrgSeg_LTD_CreditsAmount	- 687.00,
--de_LytPrgSeg_LTD_CreditsCount	=	de_LytPrgSeg_LTD_CreditsCount	- 1
--WHERE AcctId = 114162964
---- 1 Row

--UPDATE CustLytStmtHeader SET 
--CurrentBalance = CurrentBalance - 687.00,
--CreditAmountCTD	=	CreditAmountCTD	- 687.00,
--CreditCountCTD	=	CreditCountCTD	- 1,
--CreditAmountLTD	=	CreditAmountLTD	- 687.00,
--CreditCountLTD	=	CreditCountLTD	-  1
--WHERE  bsacctid = 20456776
---- 1 Row
----1100011194908830
--UPDATE LpsCustomerDetails SET 
--CurrentBalance	=	CurrentBalance	- 687.00,
--CreditAmountCTD	=	CreditAmountCTD	- 687.00,
--CreditCountCTD	=	CreditCountCTD	- 1,
--CreditAmountLTD	=	CreditAmountLTD	- 687.00,
--CreditCountLTD	=	CreditCountLTD	-  1
--WHERE  SKey = 20166893

--UPDATE LoyaltyInfoForReport SET Points  = 0 WHERE SKey IN(2499437832,
--2493322292,2487206541,2481111899,2475016464,2468932836,2462856020,2456786119,2450729248)


--UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 31 WHERE acctId = 9327331

UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 31 WHERE acctId = 277855
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 31 WHERE acctId = 282409
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 31 WHERE acctId = 344335
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 31 WHERE acctId = 404922
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 31 WHERE acctId = 1140904
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 31 WHERE acctId = 1156616
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 31 WHERE acctId = 1440067
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 31 WHERE acctId = 1992621
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 31 WHERE acctId = 2000702
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 31 WHERE acctId = 2502423
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 31 WHERE acctId = 2551588
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 31 WHERE acctId = 2637636
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 31 WHERE acctId = 2639620
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 31 WHERE acctId = 2645992
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 31 WHERE acctId = 2660880
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 31 WHERE acctId = 2676140
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 31 WHERE acctId = 2908817
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 31 WHERE acctId = 4451408
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 31 WHERE acctId = 4621064
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 31 WHERE acctId = 4853815
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 31 WHERE acctId = 4909611
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 31 WHERE acctId = 4913824
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 31 WHERE acctId = 6408687
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 31 WHERE acctId = 6805783
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 31 WHERE acctId = 7895161
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 31 WHERE acctId = 9437465
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 31 WHERE acctId = 9855690
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 31 WHERE acctId = 10234517
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 31 WHERE acctId = 10302152
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 31 WHERE acctId = 10648648
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 31 WHERE acctId = 10890281
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 31 WHERE acctId = 11862323
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 31 WHERE acctId = 11957840
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 31 WHERE acctId = 13175282
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 31 WHERE acctId = 13543464
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 31 WHERE acctId = 15307427
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 31 WHERE acctId = 15567575
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 31 WHERE acctId = 15945625
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 31 WHERE acctId = 17323865
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 31 WHERE acctId = 17516388
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 31 WHERE acctId = 17996163
UPDATE TOP(1) BSegmentCreditCard SET NoPayDaysDelinquent = 0 WHERE acctId = 19385355