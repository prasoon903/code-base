
UPDATE T
SET 
	acctId = BP.acctId,
	AccountNumber = BP.AccountNumber,
	TotalAmountCO_Before = TotalAmountCO,
	TotalAmountCO_After = TotalAmountCO - T.ForgivenAmount,
	TotalPrincipalCO_Before = BCC.TotalPrincipalCO,
	TotalPrincipalCO_After = TotalAmountCO - T.ForgivenAmount - (BCC.TotalInterestCO+BCC.TotalLateFeesCO+BCC.recoveryfeesbnpco),
	RCLSDateOnAccount = ChargeOffReclassDate
FROM BSegment_Primary BP WITH (NOLOCK)
JOIN BSegmentCreditCard BCC WITH (NOLOCK) ON (BP.acctID = BCC.acctID)
JOIN COOKIE_257478_ChargeOffAccount T ON (T.AccountUUID = BP.UniversalUniqueID)