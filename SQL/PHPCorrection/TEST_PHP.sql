SELECT Skey, JobStatus,AccountNumber,acctId,StatementDate,PHPCounter,
CurrentCounterValue,UpdatedCounterValue,RowCreatedDate,RowChangedDate 
FROM PHPCorrectionData WITH (NOLOCK)
WHERE JobStatus = 'NEW'

SELECT Skey, JobStatus,AccountNumber,acctId,StatementDate,PHPCounter,
CurrentCounterValue,UpdatedCounterValue,RowCreatedDate,RowChangedDate 
FROM PP_JAZZ_TEST..PHPCorrectionData WITH (NOLOCK)

--TRUNCATE TABLE PHPCorrectionData



--UPDATE PHPCorrectionData SET PHPCounter = 'ReportHistoryCtrCC02' WHERE Skey = 2
--UPDATE PHPCorrectionData SET JobStatus = 'NEW'

SELECT C.*,
CASE PHPCounter	
		WHEN 'ReportHistoryCtrCC01' THEN b.ReportHistoryCtrCC01	
		WHEN 'ReportHistoryCtrCC02' THEN B.ReportHistoryCtrCC02	
		WHEN 'ReportHistoryCtrCC03' THEN B.ReportHistoryCtrCC03	
		WHEN 'ReportHistoryCtrCC04' THEN B.ReportHistoryCtrCC04	
		WHEN 'ReportHistoryCtrCC05' THEN B.ReportHistoryCtrCC05	
		WHEN 'ReportHistoryCtrCC06' THEN B.ReportHistoryCtrCC06	
		WHEN 'ReportHistoryCtrCC07' THEN B.ReportHistoryCtrCC07	
		WHEN 'ReportHistoryCtrCC08' THEN B.ReportHistoryCtrCC08	
		WHEN 'ReportHistoryCtrCC09' THEN B.ReportHistoryCtrCC09	
		WHEN 'ReportHistoryCtrCC10' THEN B.ReportHistoryCtrCC10	
		WHEN 'ReportHistoryCtrCC11' THEN B.ReportHistoryCtrCC11	
		WHEN 'ReportHistoryCtrCC12' THEN B.ReportHistoryCtrCC12	
		WHEN 'ReportHistoryCtrCC13' THEN B.ReportHistoryCtrCC13	
		WHEN 'ReportHistoryCtrCC14' THEN B.ReportHistoryCtrCC14	
		WHEN 'ReportHistoryCtrCC15' THEN B.ReportHistoryCtrCC15	
		WHEN 'ReportHistoryCtrCC16' THEN B.ReportHistoryCtrCC16	
		WHEN 'ReportHistoryCtrCC17' THEN B.ReportHistoryCtrCC17	
		WHEN 'ReportHistoryCtrCC18' THEN B.ReportHistoryCtrCC18	
		WHEN 'ReportHistoryCtrCC19' THEN B.ReportHistoryCtrCC19	
		WHEN 'ReportHistoryCtrCC20' THEN B.ReportHistoryCtrCC20	
		WHEN 'ReportHistoryCtrCC21' THEN B.ReportHistoryCtrCC21	
		WHEN 'ReportHistoryCtrCC22' THEN B.ReportHistoryCtrCC22	
		WHEN 'ReportHistoryCtrCC23' THEN B.ReportHistoryCtrCC23	
		WHEN 'ReportHistoryCtrCC24' THEN B.ReportHistoryCtrCC24
END AS CurrentPHPBit
FROM PHPCorrectionData C
JOIN BSegment_Balances B WITH (NOLOCK) ON (C.Acctid = B.acctId)



SELECT B.acctID,ReportHistoryCtrCC01,ReportHistoryCtrCC02,ReportHistoryCtrCC03,ReportHistoryCtrCC04--,ReportHistoryCtrCC05,ReportHistoryCtrCC06,
--ReportHistoryCtrCC07,ReportHistoryCtrCC08,ReportHistoryCtrCC09,ReportHistoryCtrCC10,ReportHistoryCtrCC11,ReportHistoryCtrCC12,
--ReportHistoryCtrCC13,ReportHistoryCtrCC14,ReportHistoryCtrCC15,ReportHistoryCtrCC16,ReportHistoryCtrCC17,ReportHistoryCtrCC18,
--ReportHistoryCtrCC19,ReportHistoryCtrCC20,ReportHistoryCtrCC21,ReportHistoryCtrCC22,ReportHistoryCtrCC23,ReportHistoryCtrCC24 
, C.*
FROM PHPCorrectionData C
JOIN BSegment_Balances B WITH (NOLOCK) ON (C.Acctid = B.acctId)

SELECT ReportHistoryCtrCC01,ReportHistoryCtrCC02,ReportHistoryCtrCC03,ReportHistoryCtrCC04,ReportHistoryCtrCC05,ReportHistoryCtrCC06,
ReportHistoryCtrCC07,ReportHistoryCtrCC08,ReportHistoryCtrCC09,ReportHistoryCtrCC10,ReportHistoryCtrCC11,ReportHistoryCtrCC12,
ReportHistoryCtrCC13,ReportHistoryCtrCC14,ReportHistoryCtrCC15,ReportHistoryCtrCC16,ReportHistoryCtrCC17,ReportHistoryCtrCC18,
ReportHistoryCtrCC19,ReportHistoryCtrCC20,ReportHistoryCtrCC21,ReportHistoryCtrCC22,ReportHistoryCtrCC23,ReportHistoryCtrCC24 
FROM PP_JAZZ_TEST..BSegment_Balances B WITH (NOLOCK) 
WHERE acctID IN (2830360, 2830361, 2830362, 2830363, 2830364, 2830365, 2830366, 2830367)

SELECT ReportHistoryCtrCC01,ReportHistoryCtrCC02,ReportHistoryCtrCC03,ReportHistoryCtrCC04,ReportHistoryCtrCC05,ReportHistoryCtrCC06,
ReportHistoryCtrCC07,ReportHistoryCtrCC08,ReportHistoryCtrCC09,ReportHistoryCtrCC10,ReportHistoryCtrCC11,ReportHistoryCtrCC12,
ReportHistoryCtrCC13,ReportHistoryCtrCC14,ReportHistoryCtrCC15,ReportHistoryCtrCC16,ReportHistoryCtrCC17,ReportHistoryCtrCC18,
ReportHistoryCtrCC19,ReportHistoryCtrCC20,ReportHistoryCtrCC21,ReportHistoryCtrCC22,ReportHistoryCtrCC23,ReportHistoryCtrCC24 
FROM BSegment_Balances B WITH (NOLOCK) 
WHERE acctID IN (2830360, 2830361, 2830362, 2830363, 2830364, 2830365, 2830366, 2830367)


--UPDATE PP_JAZZ_TEST..BSegment_Balances SET ReportHistoryCtrCC01 = 4, ReportHistoryCtrCC02 = 3, ReportHistoryCtrCC03 = 2 WHERE acctID IN (2830360, 2830361, 2830362, 2830363, 2830364, 2830365, 2830366, 2830367)

--UPDATE B
--SET 
--    B.ReportHistoryCtrCC01 = CASE WHEN PHPCounter = 'ReportHistoryCtrCC01' THEN C.UpdatedCounterValue ELSE B.ReportHistoryCtrCC01 END,
--    B.ReportHistoryCtrCC02 = CASE WHEN PHPCounter = 'ReportHistoryCtrCC02' THEN C.UpdatedCounterValue ELSE B.ReportHistoryCtrCC02 END,
--    B.ReportHistoryCtrCC03 = CASE WHEN PHPCounter = 'ReportHistoryCtrCC03' THEN C.UpdatedCounterValue ELSE B.ReportHistoryCtrCC03 END,
--    B.ReportHistoryCtrCC04 = CASE WHEN PHPCounter = 'ReportHistoryCtrCC04' THEN C.UpdatedCounterValue ELSE B.ReportHistoryCtrCC04 END,
--    B.ReportHistoryCtrCC05 = CASE WHEN PHPCounter = 'ReportHistoryCtrCC05' THEN C.UpdatedCounterValue ELSE B.ReportHistoryCtrCC05 END,
--    B.ReportHistoryCtrCC06 = CASE WHEN PHPCounter = 'ReportHistoryCtrCC06' THEN C.UpdatedCounterValue ELSE B.ReportHistoryCtrCC06 END,
--    B.ReportHistoryCtrCC07 = CASE WHEN PHPCounter = 'ReportHistoryCtrCC07' THEN C.UpdatedCounterValue ELSE B.ReportHistoryCtrCC07 END,
--    B.ReportHistoryCtrCC08 = CASE WHEN PHPCounter = 'ReportHistoryCtrCC08' THEN C.UpdatedCounterValue ELSE B.ReportHistoryCtrCC08 END,
--    B.ReportHistoryCtrCC09 = CASE WHEN PHPCounter = 'ReportHistoryCtrCC09' THEN C.UpdatedCounterValue ELSE B.ReportHistoryCtrCC09 END,
--    B.ReportHistoryCtrCC10 = CASE WHEN PHPCounter = 'ReportHistoryCtrCC10' THEN C.UpdatedCounterValue ELSE B.ReportHistoryCtrCC10 END,
--    B.ReportHistoryCtrCC11 = CASE WHEN PHPCounter = 'ReportHistoryCtrCC11' THEN C.UpdatedCounterValue ELSE B.ReportHistoryCtrCC11 END,
--    B.ReportHistoryCtrCC12 = CASE WHEN PHPCounter = 'ReportHistoryCtrCC12' THEN C.UpdatedCounterValue ELSE B.ReportHistoryCtrCC12 END,
--    B.ReportHistoryCtrCC13 = CASE WHEN PHPCounter = 'ReportHistoryCtrCC13' THEN C.UpdatedCounterValue ELSE B.ReportHistoryCtrCC13 END,
--    B.ReportHistoryCtrCC14 = CASE WHEN PHPCounter = 'ReportHistoryCtrCC14' THEN C.UpdatedCounterValue ELSE B.ReportHistoryCtrCC14 END,
--    B.ReportHistoryCtrCC15 = CASE WHEN PHPCounter = 'ReportHistoryCtrCC15' THEN C.UpdatedCounterValue ELSE B.ReportHistoryCtrCC15 END,
--    B.ReportHistoryCtrCC16 = CASE WHEN PHPCounter = 'ReportHistoryCtrCC16' THEN C.UpdatedCounterValue ELSE B.ReportHistoryCtrCC16 END,
--    B.ReportHistoryCtrCC17 = CASE WHEN PHPCounter = 'ReportHistoryCtrCC17' THEN C.UpdatedCounterValue ELSE B.ReportHistoryCtrCC17 END,
--    B.ReportHistoryCtrCC18 = CASE WHEN PHPCounter = 'ReportHistoryCtrCC18' THEN C.UpdatedCounterValue ELSE B.ReportHistoryCtrCC18 END,
--    B.ReportHistoryCtrCC19 = CASE WHEN PHPCounter = 'ReportHistoryCtrCC19' THEN C.UpdatedCounterValue ELSE B.ReportHistoryCtrCC19 END,
--    B.ReportHistoryCtrCC20 = CASE WHEN PHPCounter = 'ReportHistoryCtrCC20' THEN C.UpdatedCounterValue ELSE B.ReportHistoryCtrCC20 END,
--    B.ReportHistoryCtrCC21 = CASE WHEN PHPCounter = 'ReportHistoryCtrCC21' THEN C.UpdatedCounterValue ELSE B.ReportHistoryCtrCC21 END,
--    B.ReportHistoryCtrCC22 = CASE WHEN PHPCounter = 'ReportHistoryCtrCC22' THEN C.UpdatedCounterValue ELSE B.ReportHistoryCtrCC22 END,
--    B.ReportHistoryCtrCC23 = CASE WHEN PHPCounter = 'ReportHistoryCtrCC23' THEN C.UpdatedCounterValue ELSE B.ReportHistoryCtrCC23 END,
--    B.ReportHistoryCtrCC24 = CASE WHEN PHPCounter = 'ReportHistoryCtrCC24' THEN C.UpdatedCounterValue ELSE B.ReportHistoryCtrCC24 END
--FROM PHPCorrectionData C
--JOIN BSegment_Balances B WITH (NOLOCK) ON (C.Acctid = B.acctId)


SELECT 
    CASE WHEN PHPCounter = 'ReportHistoryCtrCC01' THEN C.UpdatedCounterValue ELSE B.ReportHistoryCtrCC01 END,
    CASE WHEN PHPCounter = 'ReportHistoryCtrCC02' THEN C.UpdatedCounterValue ELSE B.ReportHistoryCtrCC02 END,
    CASE WHEN PHPCounter = 'ReportHistoryCtrCC03' THEN C.UpdatedCounterValue ELSE B.ReportHistoryCtrCC03 END,
    CASE WHEN PHPCounter = 'ReportHistoryCtrCC04' THEN C.UpdatedCounterValue ELSE B.ReportHistoryCtrCC04 END,
    CASE WHEN PHPCounter = 'ReportHistoryCtrCC05' THEN C.UpdatedCounterValue ELSE B.ReportHistoryCtrCC05 END,
    CASE WHEN PHPCounter = 'ReportHistoryCtrCC06' THEN C.UpdatedCounterValue ELSE B.ReportHistoryCtrCC06 END,
    CASE WHEN PHPCounter = 'ReportHistoryCtrCC07' THEN C.UpdatedCounterValue ELSE B.ReportHistoryCtrCC07 END,
    CASE WHEN PHPCounter = 'ReportHistoryCtrCC08' THEN C.UpdatedCounterValue ELSE B.ReportHistoryCtrCC08 END,
    CASE WHEN PHPCounter = 'ReportHistoryCtrCC09' THEN C.UpdatedCounterValue ELSE B.ReportHistoryCtrCC09 END,
    CASE WHEN PHPCounter = 'ReportHistoryCtrCC10' THEN C.UpdatedCounterValue ELSE B.ReportHistoryCtrCC10 END,
    CASE WHEN PHPCounter = 'ReportHistoryCtrCC11' THEN C.UpdatedCounterValue ELSE B.ReportHistoryCtrCC11 END,
    CASE WHEN PHPCounter = 'ReportHistoryCtrCC12' THEN C.UpdatedCounterValue ELSE B.ReportHistoryCtrCC12 END,
    CASE WHEN PHPCounter = 'ReportHistoryCtrCC13' THEN C.UpdatedCounterValue ELSE B.ReportHistoryCtrCC13 END,
    CASE WHEN PHPCounter = 'ReportHistoryCtrCC14' THEN C.UpdatedCounterValue ELSE B.ReportHistoryCtrCC14 END,
    CASE WHEN PHPCounter = 'ReportHistoryCtrCC15' THEN C.UpdatedCounterValue ELSE B.ReportHistoryCtrCC15 END,
    CASE WHEN PHPCounter = 'ReportHistoryCtrCC16' THEN C.UpdatedCounterValue ELSE B.ReportHistoryCtrCC16 END,
    CASE WHEN PHPCounter = 'ReportHistoryCtrCC17' THEN C.UpdatedCounterValue ELSE B.ReportHistoryCtrCC17 END,
    CASE WHEN PHPCounter = 'ReportHistoryCtrCC18' THEN C.UpdatedCounterValue ELSE B.ReportHistoryCtrCC18 END,
    CASE WHEN PHPCounter = 'ReportHistoryCtrCC19' THEN C.UpdatedCounterValue ELSE B.ReportHistoryCtrCC19 END,
    CASE WHEN PHPCounter = 'ReportHistoryCtrCC20' THEN C.UpdatedCounterValue ELSE B.ReportHistoryCtrCC20 END,
    CASE WHEN PHPCounter = 'ReportHistoryCtrCC21' THEN C.UpdatedCounterValue ELSE B.ReportHistoryCtrCC21 END,
    CASE WHEN PHPCounter = 'ReportHistoryCtrCC22' THEN C.UpdatedCounterValue ELSE B.ReportHistoryCtrCC22 END,
    CASE WHEN PHPCounter = 'ReportHistoryCtrCC23' THEN C.UpdatedCounterValue ELSE B.ReportHistoryCtrCC23 END,
    CASE WHEN PHPCounter = 'ReportHistoryCtrCC24' THEN C.UpdatedCounterValue ELSE B.ReportHistoryCtrCC24 END
FROM PHPCorrectionData C
JOIN BSegment_Balances B WITH (NOLOCK) ON (C.Acctid = B.acctId)

