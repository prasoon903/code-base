DECLARE @BusinessDay DATETIME = '2018-03-31 23:59:57.000'
;WITH AIR
AS
(
	SELECT BSAcctid, AmountOfTotalDue 
	FROM AccountInfoForReport WITH (NOLOCK) 
	WHERE BusinessDay = @BusinessDay
)
, PIR
AS
(
	SELECT BSAcctid, SUM(ISNULL(AmountOfTotalDue, 0)) AmountOfTotalDue
	FROM PlanInfoForReport WITH (NOLOCK) 
	WHERE BusinessDay = @BusinessDay
	GROUP BY BSAcctid
)
SELECT COUNT(1) AS RecordCount
FROM AIR A JOIN PIR P ON (A.BSAcctid = P.BSAcctid)
WHERE A.AmountOfTotalDue <> P.AmountOfTotalDue


DECLARE @StatementDate DATETIME = '2018-11-30 23:59:57'
SELECT COUNT(1) RecordCount
FROM BSegment_Primary WITH (NOLOCK)
WHERE LastStatementDate < @StatementDate AND LAD >= @StatementDate