DROP TABLE IF EXISTS #Tempdata
SELECT BP.acctID, AccountNumber, LastReageDate, ReageDate1, ReageDate2, ReageDate3, ReageDate4, ReageDate5, ReageDate6
INTO #Tempdata
FROM BSegment_Primary BP WITH (NOLOCK)
JOIN BSegmentCreditcard BC WITH (NOLOCK) ON (BP.acctID = BC.acctID)

DROP TABLE IF EXISTS #TempRecords
SELECT *,
CASE
	WHEN ReageDate6 IS NOT NULL THEN ReageDate6
	WHEN ReageDate5 IS NOT NULL THEN ReageDate5
	WHEN ReageDate4 IS NOT NULL THEN ReageDate4
	WHEN ReageDate3 IS NOT NULL THEN ReageDate3
	WHEN ReageDate2 IS NOT NULL THEN ReageDate2
	WHEN ReageDate1 IS NOT NULL THEN ReageDate1
ELSE NULL END MaxReageDate
INTO #TempRecords
FROM #TempData

SELECT COUNT(1)
FROM #TempRecords
WHERE MaxReageDate IS NOT NULL
AND (LastReageDate IS NULL OR LastReageDate <> MaxReageDate)

SELECT LastReageDate FROM BSegment_Primary WITH (NOLOCK) WHERE acctID IN (18013575, 14118936)