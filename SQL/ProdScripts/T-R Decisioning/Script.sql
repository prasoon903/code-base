--SET Statistics IO ON

--Approach 1

;WITH CTE
AS
(
SELECT StatementDate, CASE WHEN AccountGraceStatus = 'R' THEN 1 ELSE 0 END Grace
FROM CurrentSummaryHeader WITH (NOLOCK)
WHERE acctID IN (58979895,74467889)
AND StatementDate > '2023-12-31 23:59:57.000'
)
SELECT TOP 1 StatementDate, CASE WHEN SUM(Grace) > 0 THEN 'R' ELSE 'T' END AccountGraceStatus
FROM CTE
GROUP BY StatementDate
HAVING SUM(Grace) = 0
ORDER BY StatementDate 



--Approach 2

DECLARE @StatementData AS TABLE
(
	StatementDate DATETIME, Grace INT
)

INSERT INTO @StatementData
SELECT StatementDate, CASE WHEN AccountGraceStatus = 'R' THEN 1 ELSE 0 END Grace
FROM CurrentSummaryHeader WITH (NOLOCK)
WHERE acctID IN (1142017, 40448332, 77014538, 106879713, 106961032, 106961033, 107081902, 107145800, 107145801, 107145802)
AND StatementDate > '2023-12-31 23:59:57.000'

SELECT TOP 1 StatementDate, CASE WHEN SUM(Grace) > 0 THEN 'R' ELSE 'T' END AccountGraceStatus
FROM @StatementData
GROUP BY StatementDate
HAVING SUM(Grace) = 0
ORDER BY StatementDate 