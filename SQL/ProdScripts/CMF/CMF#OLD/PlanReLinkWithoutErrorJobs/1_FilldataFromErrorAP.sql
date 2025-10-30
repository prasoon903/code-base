

INSERT INTO AccountsOfPlanToReLink (acctID) VALUES (11409681)
INSERT INTO AccountsOfPlanToReLink (acctID) VALUES (2437629)
INSERT INTO AccountsOfPlanToReLink (acctID) VALUES (847405)
INSERT INTO AccountsOfPlanToReLink (acctID) VALUES (2757430)


UPDATE AccountsOfPlanToReLink SET FromStatement = '2023-08-31 23:59:57.000', ToStatement = '2025-04-30 23:59:57' WHERE acctID = 847405 AND JobStatus = 0
UPDATE AccountsOfPlanToReLink SET FromStatement = '2023-08-31 23:59:57.000', ToStatement = '2025-04-30 23:59:57' WHERE acctID = 2437629 AND JobStatus = 0
UPDATE AccountsOfPlanToReLink SET FromStatement = '2023-08-31 23:59:57.000', ToStatement = '2025-04-30 23:59:57' WHERE acctID = 2757430 AND JobStatus = 0
UPDATE AccountsOfPlanToReLink SET FromStatement = '2023-08-31 23:59:57.000', ToStatement = '2025-04-30 23:59:57' WHERE acctID = 11409681 AND JobStatus = 0





--SELECT * FROM ##AccountsOfPlanToReLink

--847405
--11409681
--2757430
--2437629


SELECT StatementDate, COUNT(1)
FROM SummaryHeader WITH (NOLOCK)
WHERE parent02AID = -11409681
GROUP BY StatementDate
ORDER BY StatementDate DESC


--SELECT *
--FROM CommonAP WITH (NOLOCK) 
--WHERE ATID=51
--AND TranID IN
--(121217425748)

--SELECT *
--FROM CCard_Primary WITH (NOLOCK) 
--WHERE TranID IN
--(121217425748)

--SELECT *
--FROM CommonAP WITH (NOLOCK)
--WHERE TranTime < GETDATE() 