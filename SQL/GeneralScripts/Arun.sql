with CTE
AS
(
SELECT DISTINCT AccountNumber FROM CoreAuthTransactions WITH (NOLOCK)
)
SELECT * from BSegment_Primary BS WITH (NOLOCK)
join CTE AS Acc ON (Acc.AccountNumber = BS.AccountNumber)

with CTE
AS
(
	SELECT DISTINCT AccountNumber FROM CoreAuthTransactions WITH (NOLOCK)
)
SELECT
 EA.tpyBlob, BS.tpyBlob,bs.acctId, EA.parent01AID
FROM BSegment_Primary BS WITH (NOLOCK)
JOIN EmbossingAccounts EA WITH (NOLOCK) ON (BS.acctId = EA.parent01AID)
JOIN CTE ON (BS.AccountNumber = CTE.AccountNumber)
WHERE EA.tpyBlob IS NOT NULL





with CTE
AS
(
	SELECT DISTINCT AccountNumber FROM CoreAuthTransactions WITH (NOLOCK) WHERE PhysicalSource = 'RA'
)
UPDATE BS
	SET tpyBlob = NULL
FROM BSegment_Primary BS WITH (NOLOCK)
JOIN CTE ON (BS.AccountNumber = CTE.AccountNumber)
WHERE BS.tpyBlob IS NOT NULL

with CTE
AS
(
	SELECT DISTINCT AccountNumber FROM CoreAuthTransactions WITH (NOLOCK) WHERE PhysicalSource = 'RA'
)
UPDATE EA
	SET tpyBlob = NULL
FROM BSegment_Primary BS WITH (NOLOCK)
JOIN EmbossingAccounts EA WITH (NOLOCK) ON (BS.acctId = EA.parent01AID)
JOIN CTE ON (BS.AccountNumber = CTE.AccountNumber)
WHERE EA.tpyBlob IS NOT NULL