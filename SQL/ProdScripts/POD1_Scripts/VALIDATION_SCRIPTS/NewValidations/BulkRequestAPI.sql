
SELECT * FROM LS_PRODDRGSDB01.ccgs_coreissue.dbo.COMMONTNP T WITH (NOLOCK) WHERE ACCTID in (2281174)  ORDER BY TranTime


SELECT * FROM LS_PRODDRGSDB01.ccgs_coreissue.dbo.Version T WITH (NOLOCK)  ORDER BY 1 DESC


SELECT * FROM LS_PRODDRGSDB01.ccgs_coreissue.dbo.BulkRequestResposeSetUp WITH (NOLOCK)
--ORDER BY FileID DESC


SELECT * FROM LS_PRODDRGSDB01.ccgs_coreissue.dbo.BulkRequestResposeFiles WITH (NOLOCK)
ORDER BY FileID DESC



SELECT * FROM LS_PRODDRGSDB01.ccgs_coreissue.dbo.BulkRequestResposeRecords WITH (NOLOCK)
WHERE FileID = 212 -- AND APIResponse = 'Re-age posted successfully'


SELECT * FROM LS_PRODDRGSDB01.ccgs_coreissue.dbo.BulkRequestResposeRecords WITH (NOLOCK)
WHERE Column1 = '1100011113374502'



SELECT APIResponse, COUNT(1) RecordCount
FROM LS_PRODDRGSDB01.ccgs_coreissue.dbo.BulkRequestResposeRecords WITH (NOLOCK)
WHERE FileID = 168
GROUP BY APIResponse

'1100011119509440'