


BEGIN TRY 
	BEGIN TRAN
		
		UPDATE BSegment_MStatuses SET EffectiveEndDate_MS = '2026-01-31 23:59:59.000' WHERE AcctID = 4724714 AND MStatusCode = 16038 AND IsDeleted = '0'
		UPDATE BSegment_MStatuses SET EffectiveEndDate_MS = '2028-03-31 23:59:59.000' WHERE AcctID = 14155576 AND MStatusCode = 16038 AND IsDeleted = '0'
		UPDATE BSegment_MStatuses SET EffectiveEndDate_MS = '2028-04-30 23:59:59.000' WHERE AcctID = 2155152 AND MStatusCode = 16038 AND IsDeleted = '0'

		UPDATE BSegment_Secondary SET NearestEffectiveEndDate = '2026-01-31 23:59:59.000' WHERE AcctID = 4724714  
		UPDATE BSegment_Secondary SET NearestEffectiveEndDate = '2028-03-31 23:59:59.000' WHERE AcctID = 14155576 
		UPDATE BSegment_Secondary SET NearestEffectiveEndDate = '2028-04-30 23:59:59.000' WHERE AcctID = 2155152 

		UPDATE BSegmentCreditCard SET SCRAEndDate = '2026-01-31 23:59:59.000' WHERE AcctID = 4724714  
		UPDATE BSegmentCreditCard SET SCRAEndDate = '2028-03-31 23:59:59.000' WHERE AcctID = 14155576 
		UPDATE BSegmentCreditCard SET SCRAEndDate = '2028-04-30 23:59:59.000' WHERE AcctID = 2155152 

		UPDATE CCGS_CoreAuth..Bsegment_Primary SET CurrentBalanceCO = CurrentBalanceCO + (-530.00) WHERE AcctID = 997657
		UPDATE CCGS_CoreAuth..Bsegment_Primary SET CurrentBalanceCO = CurrentBalanceCO + (53.23) WHERE AcctID = 1218976
		UPDATE CCGS_CoreAuth..Bsegment_Primary SET CurrentBalanceCO = CurrentBalanceCO + (44.84) WHERE AcctID = 1262336
		UPDATE CCGS_CoreAuth..Bsegment_Primary SET CurrentBalanceCO = CurrentBalanceCO + (139.78) WHERE AcctID = 2459219
		UPDATE CCGS_CoreAuth..Bsegment_Primary SET CurrentBalanceCO = CurrentBalanceCO + (269.42) WHERE AcctID = 5609407
		UPDATE CCGS_CoreAuth..Bsegment_Primary SET CurrentBalanceCO = CurrentBalanceCO + (21.02) WHERE AcctID = 10344465
		UPDATE CCGS_CoreAuth..Bsegment_Primary SET CurrentBalanceCO = CurrentBalanceCO + (759.00) WHERE AcctID = 11518718
		UPDATE CCGS_CoreAuth..Bsegment_Primary SET CurrentBalanceCO = CurrentBalanceCO + (120.18) WHERE AcctID = 13595064
		UPDATE CCGS_CoreAuth..Bsegment_Primary SET CurrentBalanceCO = CurrentBalanceCO + (160.00) WHERE AcctID = 17723665
		UPDATE CCGS_CoreAuth..Bsegment_Primary SET CurrentBalanceCO = CurrentBalanceCO + (84.90) WHERE AcctID = 17983215
		UPDATE CCGS_CoreAuth..Bsegment_Primary SET CurrentBalanceCO = CurrentBalanceCO + (-342.40) WHERE AcctID = 18525433


		UPDATE CCGS_CoreAuth..Bsegment_Primary SET ccinhparent127aid = 10388 WHERE AcctID = 559315

		UPDATE CCGS_CoreAuth..Bsegment_Primary SET ccinhparent125aid = 2 WHERE AcctID = 9845682

		UPDATE BSegmentCreditCard SET DtOfLastDelinqCTD = '2020-02-29 00:00:00', daysdelinquent = 0 WHERE AcctID = 1843287

		UPDATE BSegmentCreditCard SET SRBWithInstallmentDue = SRBWithInstallmentDue - 12 WHERE AcctID = 1659023

		UPDATE BSegmentCreditCard SET SRBWithInstallmentDue = SRBWithInstallmentDue - 107.56  WHERE AcctID = 15287786

		UPDATE CCard_primary SET NoblobIndicator = '5' WHERE tranID = 92658368650

		UPDATE CCard_primary SET NoblobIndicator = '5' WHERE tranID = 92658368646

		UPDATE BSegmentCreditCard SET PrincipalCO = PrincipalCO + 89.3  WHERE AcctID = 1645591
	
		UPDATE CPSgmentCreditCard SET PrincipalCO = PrincipalCO + 89.3  WHERE AcctID = 44117100

		UPDATE  CurrentBalanceAuditPS SET NewValue = '9166.58' WHERE IdentityField = 9758817533 AND ATID = 52 AND AID = 44117100

		UPDATE BsegmentCreditCard SET AutoInitialChargeoffStartDate = '2024-11-30 23:59:57.000', ChargeOffDateParam = '2024-12-31 23:59:55.000' WHERE AcctID = 4358159

		UPDATE BsegmentCreditCard SET RemainingMinimumDue = AmountOfTotalDue, RunningMinimumDue = AmountOfTotalDue WHERE AcctID IN ( 187193, 301934, 415094, 695857, 862216, 1121650, 1188546, 1522162, 1917474, 2103132, 2353189, 2425993, 2468447, 2504572, 4118474, 4262888, 4736965, 5523908, 7796362, 9355198, 9445457, 9850515, 10237439, 11113848, 12432014, 12492208, 13566755, 13711584, 14017096, 15297546, 15685070, 17331865, 17865516, 19086152, 20274978, 20447289, 21148083, 21897621, 21906414, 21920106)

	COMMIT  TRAN
END TRY
BEGIN CATCH

	IF @@TRANCOUNT > 0
		ROLLBACK TRAN
	SELECT ERROR_MESSAGE(), ERROR_LINE(), ERROR_NUMBER()
	RAISERROR('ERROR OCCURED :-', 16, 1);
END CATCH