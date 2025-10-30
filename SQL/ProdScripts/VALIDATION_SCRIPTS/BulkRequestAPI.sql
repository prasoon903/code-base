select * from sys.servers
SELECT * FROM COMMONTNP T WITH (NOLOCK) WHERE ACCTID in (2281174)  ORDER BY TranTime


SELECT * FROM Version T WITH (NOLOCK)  ORDER BY 1 DESC

SELECT * FROM ConfigStore WITH (NOLOCK)WHERE BlockName LIKE '%Loyalty%'


SELECT * FROM BulkRequestResposeSetUp WITH (NOLOCK)
--ORDER BY FileID DESC

--262, 244


SELECT TOP 100 * FROM BulkRequestResposeFiles WITH (NOLOCK)
ORDER BY FileID DESC



SELECT * FROM BulkRequestResposeRecords WITH (NOLOCK)
WHERE FileID = 508  AND APIResponse = 'Insufficient Redeem Points'


SELECT * FROM BulkRequestResposeRecords WITH (NOLOCK)
WHERE Column1 = '1100011113374502'

SELECT * FROM BulkRequestResposeFiles WITH (NOLOCK) WHERE FileID = 500


SELECT APIResponse, COUNT(1) RecordCount
FROM BulkRequestResposeRecords WITH (NOLOCK)
WHERE FileID IN (542)
GROUP BY APIResponse

'1100011119509440'