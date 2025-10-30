BEGIN TRAN
--COMMIT TRAN
--ROLLBACK TRAN

DECLARE @AccountId INT = 3629687

DECLARE @AccountNumber VARCHAR(19)

SELECT @AccountNumber = AccountNumber FROM BSegment_Primary WITH (NOLOCK) WHERE acctID = @AccountId

DROP TABLE IF EXISTS #TempData
SELECT * INTO #TempData FROM DisputeCreditInCycle WITH (NOLOCK) WHERE AccountNumber = @AccountNumber

;WITH CTE
AS
(
	SELECT *,
	ROW_NUMBER() OVER (PARTITION BY acctId, TranID, TranRef, ClaimID ORDER BY Skey) TxnCount
	FROM #TempData
	WHERE ReversalFlag = 0
)
, ExtraTxns
AS
(
	SELECT AccountNumber, Skey FROM CTE WHERE TxnCount > 1
)
UPDATE D
SET ReversalFlag = 1
--SELECT D.ReversalFlag
FROM DisputeCreditInCycle D
JOIN ExtraTxns E ON (D.Skey = E.Skey)




--SELECT COUNT(1) FROM #TempData WITH (NOLOCK) WHERE ReversalFlag = 0

--;WITH CTE
--AS
--(
--SELECT *,
--ROW_NUMBER() OVER (PARTITION BY acctId, TranID, TranRef, ClaimID ORDER BY Skey) TxnCount
--FROM #TempData
--WHERE ReversalFlag = 0
--)
--SELECT COUNT(1) FROM CTE WHERE TxnCount = 1