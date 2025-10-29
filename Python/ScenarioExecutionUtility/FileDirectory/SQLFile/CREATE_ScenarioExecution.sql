DROP TABLE IF EXISTS dbo.ScenarioExecution
GO
CREATE TABLE dbo.ScenarioExecution
(
	CMTTRANTYPE CHAR(8) NULL,
	TransactionAmount MONEY NULL,
	Trantime DATETIME NULL,
	PostTime DATETIME NULL,
	CreditPlanMaster INT NULL,
	RMATranUUID VARCHAR(64) NULL,
	RevTgt DECIMAL(19,0) NULL,
	CaseID DECIMAL(19,0) NULL,
	TxnSource CHAR(4) NULL,
	TxnCode_Internal CHAR(8) NULL,
	InstitutionID INT NULL,
	ActualTranCode VARCHAR(20) NULL,
	LogicModule VARCHAR(5) NULL,
	Skey DECIMAL(19,0) IDENTITY(1, 1) NOT NULL,
	FileName VARCHAR(200) NULL,
	AccountNumber VARCHAR(19) NULL,
	TransactionAPI VARCHAR(50),
	JobStatus VARCHAR(10) NULL
)


/*
SELECT BSAcctid, CP.ARTxnType, CP.CMTTRANTYPE,CP.TxnAcctId, txnsource, CP.creditplanmaster, CP.TransactionAmount,CP.TranId,CP.TranRef,CP.tranorig,CP.TransmissionDateTime,CP.atid,Trantime,CP.PostTime,
CP.PostingRef,CS.CardAcceptorNameLocation,CP.MemoIndicator,CP.RevTgt,CP.CaseID,CP.TxnCode_Internal,
CP.TxnCode_Internal,CP.ARTxnType,CP.NoBlobIndicator,CP.CaseID, CS.Amount5,CS.InvoiceNumber, InstitutionID
--, CP.*
FROM CCard_Primary CP WITH (NOLOCK)
LEFT JOIN CCard_Secondary CS WITH (NOLOCK) ON (CP.TranId = CS.TranId)
WHERE CP.AccountNumber IN (SELECT AccountNumber FROM BSegment_Primary WITH(NOLOCK) WHERE acctId = 5000) 
AND CP.CMTTRANTYPE NOT IN ('HPOTB','PPR','MMR')
AND (LEN(CP.CMTTRANTYPE) = 2 OR TRY_CAST(CP.CMTTRANTYPE AS INT) < 120 OR TRY_CAST(CP.CMTTRANTYPE AS INT) > 1000 OR CP.CMTTRANTYPE IN ('QNA'))
AND CP.TxnSource NOT IN ('4','10')
AND CP.MemoIndicator IS NULL
ORDER BY CP.PostTime DESC

SELECT TransactionDescription,* FROM MonetaryTxnControl WITH (NOLOCK) --WHERE TransactionDescription LIKE '%DISPUTE%'

*/