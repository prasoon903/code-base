DROP TABLE IF EXISTS #Missingccard
select tranid,'New' as status into #Missingccard  from coreissue_snapshot_snap_221001.dbo.ccard_primary with(nolock) 
where posttime >'2022-09-29 05:59:57'  and posttime <  '2022-09-30 11:59:57'
Except
select tranid,'New' as status  from Temp_P1MarProdDb02.CCGS_RPT_CoreIssue.dbo.ccard_primary with(nolock) 
where posttime >'2022-09-29 05:59:57'  and posttime <  '2022-09-30 11:59:57'

SELECT COUNT(1) FROM #Missingccard

SELECT * FROM #Missingccard


SELECT CMTTranType, COUNT(1) FROM #Missingccard GROUP BY CMTTranType 

SELECT txnprocesstime,bsacctid,accountnumber,* FROM dbo.CCard_Primary WITH (NOLOCK) WHERE TranID IN (70872067310)

SELECT txnprocesstime,bsacctid,accountnumber,* FROM Temp_P1MarProdDb02.CCGS_RPT_CoreIssue.dbo.CCard_Primary WITH (NOLOCK) WHERE TranID IN (70872067310)


SELECT txnprocesstime,bsacctid,accountnumber,* FROM Temp_P1MarProdDb02.CCGS_RPT_CoreIssue.dbo.CCard_Primary WITH (NOLOCK) WHERE TranRef IN (70872067310)

SELECT txnprocesstime,bsacctid,accountnumber,* FROM Temp_P1MarProdDb02.CCGS_RPT_CoreIssue.dbo.CCard_Primary WITH (NOLOCK) WHERE TranID IN (SELECT TranID FROM #Missingccard)


SELECT txnprocesstime,bsacctid,accountnumber,* 
FROM Temp_P1MarProdDb02.CCGS_RPT_CoreIssue.dbo.CCard_Primary WITH (NOLOCK) 
WHERE TranID IN (SELECT TranID FROM #Missingccard)


SELECT CMTTranType, COUNT(1)  [Count]
FROM CCard_Primary WITH (NOLOCK) 
WHERE TranID IN (SELECT TranID FROM #Missingccard)
GROUP BY CMTTranType


SELECT * FROM Staging_RPT_DB.dbo.CCard_Primary WITH (NOLOCK) WHERE TranID IN (SELECT TranID FROM #Missingccard)

SELECT * FROM Staging_RPT_DB.dbo.CCard_Primary_Reassert WITH (NOLOCK)


--DELETE C1
--FROM CCard_Primary C1 
--JOIN CCard_Primary_Reassert C2 WITH (NOLOCK) ON (C1.TranID = C2.TranID)



SELECT *
INTO Staging_RPT_DB.dbo.CCard_Primary_Reassert
FROM CCard_Primary WITH (NOLOCK) 
WHERE TranID IN (SELECT TranID FROM #Missingccard)
AND CMTTranType = '21'



