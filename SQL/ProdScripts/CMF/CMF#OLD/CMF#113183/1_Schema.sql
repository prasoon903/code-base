--RUN ON BOTH PRIMARY AND REPLICATION

IF NOT EXISTS(SELECT TOP 1 1 FROM SYS.TABLES WITH (NOLOCK) WHERE NAME = 'TempAI_Records') 
BEGIN
	CREATE TABLE TempAI_Records
	(
		SN Decimal(19,0) identity(1,1),
		BSAcctid int,
		AI_Businessday Datetime,
		AI_ChargeOffDate Datetime,
		CBA_ChargeOffDate Datetime,
		JobStatus Tinyint default 0
	)
END

IF NOT EXISTS(SELECT TOP 1 1 FROM SYS.TABLES WITH (NOLOCK) WHERE NAME = 'TempBsegmentChargeoffUpdate') 
BEGIN
	CREATE TABLE TempBsegmentChargeoffUpdate
	(
		SN decimal(19,0) identity (1,1),
		Acctid INT, 
		WrongChargeOffdate DATETIME, 
		CBA_ChargeoffDate DATETIME,
		JobStatus Tinyint default 0
	)
END

