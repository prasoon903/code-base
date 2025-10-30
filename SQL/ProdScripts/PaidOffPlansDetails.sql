SELECT BP.acctID, CP.acctID CPSID, CC.PaidOutDate, TRY_CAST(CC.PaidOutDate AS DATE) PaidOutDate_Date
INTO #TempRecords
FROM CPSgmentAccounts CP WITH (NOLOCK)
JOIN CPSgmentCreditCard CC WITH (nOLOCK) ON (CP.acctId = CC.acctId) 
JOIN BSegment_Primary BP WITH (NOLOCK) ON (BP.acctId = CP.parent02AID)
WHERE CC.paidoutdate IS NOT NULL
AND CP.creditplantype = '16'
AND BP.MergeInProcessPH IS NULL

SELECT COUNT(1) FROM #TempRecords

SELECT PaidOutDate_Date, COUNT(1) RecordCount
FROM #TempRecords
GROUP BY PaidOutDate_Date
ORDER BY PaidOutDate_Date DESC

SELECT COUNT(1)
FROM CPSgmentAccounts CP WITH (NOLOCK)
JOIN CPSgmentCreditCard CC WITH (nOLOCK) ON (CP.acctId = CC.acctId) 
JOIN BSegment_Primary BP WITH (NOLOCK) ON (BP.acctId = CP.parent02AID)
WHERE CP.creditplantype = '16'
AND BP.MergeInProcessPH IS NULL

--11149228