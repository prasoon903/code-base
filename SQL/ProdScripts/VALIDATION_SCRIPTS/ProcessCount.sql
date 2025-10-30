;WITH CTE
AS
(
SELECT Program_name
FROM sysprocesses
--WHERE Program_name = 'APP_wfTnpNad'
WHERE Program_name LIKE 'APP%'
GROUP BY Program_name, hostname
)
SELECT Program_name, COUNT(1) TotalCount 
FROM CTE 
GROUP BY Program_name
ORDER BY COUNT(1) DESC