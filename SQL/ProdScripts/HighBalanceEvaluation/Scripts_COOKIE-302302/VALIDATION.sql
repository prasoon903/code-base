SELECT JobStatus , COUNT(1)
FROM ##CBRAccounts
GROUP BY JobStatus