
BEGIN TRANSACTION

SELECT * INTO #TempCommonTNP FROM COMMONTNP T WITH (NOLOCK) WHERE ACCTID in (2281174)  

DELETE T FROM #TempCommonTNP T 
	LEFT OUTER JOIN  CCard_Primary CP WITH(NOLOCK) ON (T.TRANID = CP.TRANID AND CP.CMTTranType = '110')
WHERE CP.TranId IS NULL


;WITH CTE AS 
(
	SELECT ROW_NUMBER() OVER (ORDER BY trantime) AS rno,tranid,trantime FROM #TempCommonTNP
)
UPDATE CTE SET TranTime = DATEADD(minute,rno*5,getdate())
	  
UPDATE CT SET trantime = T.trantime 
FROM CommonTNP CT with(nolock)
	join #TempCommonTNP T with(nolock) ON (CT.TranId = T.TranID)

UPDATE CT SET trantime = T.trantime ,PostTime = T.TranTime
FROM CCard_Primary CT with(nolock)
	join #TempCommonTNP T with(nolock) ON (CT.TranId = T.TranID)

--COMMIT TRANSACTION
--ROLLBACK TRANSACTION


/*
select CT.trantime , T.trantime 
FROM CommonTNP CT with(nolock)
	join #TempCommonTNP T ON (CT.TranId = T.TranID)

select CT.trantime , T.trantime ,PostTime
FROM CCard_Primary CT  with(nolock)
	join #TempCommonTNP T ON (CT.TranId = T.TranID)

*/