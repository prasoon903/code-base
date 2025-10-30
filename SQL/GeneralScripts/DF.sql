BEGIN TRANSACTION

	-- UPDATE WILL BE 1 ROW EACH STATEMENT
	

	UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 6.20 WHERE acctId = 5037
	UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = AmountOfTotalDue - 6.20, RunningMinimumDue = RunningMinimumDue - 6.20, 
	RemainingMinimumDue = RemainingMinimumDue - 6.20, DateOfOriginalPaymentDueDTD = NULL, FirstDueDate = NULL  WHERE acctId = 5037

	UPDATE TOP(1) BSegmentCreditCard SET SBWithInstallmentDue = SBWithInstallmentDue - 6.20, SRBWithInstallmentDue = SRBWithInstallmentDue - 6.20
	WHERE acctId = 5037

	UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 6.20, AmountOfTotalDue = AmountOfTotalDue - 6.20 
	WHERE acctId = 5087

	UPDATE TOP(1) CPSgmentCreditCard SET SBWithInstallmentDue = SBWithInstallmentDue - 6.20, SRBWithInstallmentDue = SRBWithInstallmentDue - 6.20 
	WHERE acctId = 5087


COMMIT TRANSACTION
--ROLLBACK TRANSACTION