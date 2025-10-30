IF EXISTS (SELECT TOP 1 1 FROM CPS_Environment WITH(NOLOCK) WHERE Environment_Name IN ('PLAT_LOCAL'))
BEGIN
	UPDATE Logo_Secondary SET
		ReturnCr_Due_On = 2,
		RetrunCr_InterestGrace = 1,
		InterestGraceDecisionOn = 3
END