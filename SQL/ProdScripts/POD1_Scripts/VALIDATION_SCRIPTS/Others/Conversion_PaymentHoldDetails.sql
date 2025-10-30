BEGIN TRAN

	UPDATE PaymentHoldDetails
	SET DynamicRuleID_MedRiskRule = DynamicRuleID
	WHERE RiskType = 2 AND PostTime > '2020-01-01'

--COMMIT TRAN
--ROLLBACK TRAN

BEGIN TRAN

	UPDATE PaymentHoldDetails
	SET DynamicRuleID = NULL
	WHERE RiskType = 2 AND PostTime > '2020-01-01'

--COMMIT TRAN
--ROLLBACK TRAN


/*
DROP TABLE IF EXISTS #PaymentHoldDetails

SELECT * INTO #PaymentHoldDetails FROM PaymentHoldDetails WITH (NOLOCK) where posttime > '2020-01-01' AND RiskType = 2


UPDATE #PaymentHoldDetails
SET DynamicRuleID_MedRiskRule = DynamicRuleID
WHERE RiskType = 2 AND PostTime > '2020-01-01'

UPDATE #PaymentHoldDetails
SET DynamicRuleID = NULL
WHERE RiskType = 2 AND PostTime > '2020-01-01'


select TOP 100 * from #PaymentHoldDetails with (nolock) 
where posttime > '2020-01-01' AND RiskType = 2
*/