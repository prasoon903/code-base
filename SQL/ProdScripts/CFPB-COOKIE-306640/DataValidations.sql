SELECT * FROM ##TempRawData

SELECT * FROM ##TempRawData WHERE AccountUUID = 'b4050d26-1599-43c5-af81-f4ca3412fb6f'

SELECT * FROM DisputeLog WITH (NOLOCK) WHERE DisputeID = 3282757 AND BSAcctID = 1113521

SELECT COUNT(DISTINCT acctID) FROM ##Final_AllAccounts

SELECT MAX(RecordNumber) FROM ##Final_AllAccounts

;WITH CTE
AS
(
SELECT DISTINCT acctID, ImpactedStatement, PHPImpact 
FROM ##Final_AllAccounts
WHERE 
ImpactedStatement = 'YES' OR 
PHPImpact = 'YES'
)
SELECT ImpactedStatement, PHPImpact , COUNT(1)
FROM CTE 
GROUP BY ImpactedStatement, PHPImpact


SELECT COUNT(Distinct T1.acctID)
FROM ##Final_AllAccounts T1
WHERE SystemStatus <> 14 AND ProjectedDQ = 7

SELECT COUNT(1)
FROM BSegment_Primary BP WITH (NOLOCK)
JOIN (
SELECT Distinct acctID
FROM ##Final_AllAccounts) T1 ON (BP.acctID = T1.acctId)
WHERE BP.SystemStatus <> 14

SELECT * FROM ##Final_AllAccounts  WHERE PHPImpact = 'YES' AND SystemStatus = 14 AND ManualStatus NOT IN (15996, 16000, 16326, 16330)

SELECT 'ImpactedStatement' Validation, COUNT(DISTINCT acctID) FROM ##Final_AllAccounts WHERE ImpactedStatement = 'YES'
SELECT 'PHPImpact' Validation, COUNT(DISTINCT acctID) FROM ##Final_AllAccounts WHERE PHPImpact = 'YES'


SELECT 'ImpactedStatement' Validation, COUNT(DISTINCT acctID) FROM ##Final_AllAccounts WHERE ImpactedStatement = 'YES' AND SystemStatus <> 14 AND ManualStatus NOT IN (15996, 16000, 16326, 16330)
SELECT 'PHPImpact' Validation, COUNT(DISTINCT acctID) FROM ##Final_AllAccounts WHERE PHPImpact = 'YES' AND SystemStatus <> 14 AND ManualStatus NOT IN (15996, 16000, 16326, 16330)


--Manual Validations

-------------Q1 - SRB>0 and CD=0

SELECT COUNT(DISTINCT acctID) 
FROM ##Final_AllAccounts 
WHERE SRB_Calc > 0 
AND AmtOfPayCurrDue_Proj <= 0 
AND AmountOfTotalDue_Proj < SRB_Calc 
AND SystemStatus <> 14
AND OriginalDQ > 0 
AND RecordNumber > 1
AND ManualStatus NOT IN (15996, 16000, 16326, 16330)

-------------Q2 - SRB>0 and Int=0

SELECT COUNT(DISTINCT acctID) 
FROM ##Final_AllAccounts 
WHERE SRB_Calc > 0 
AND SystemStatus <> 14
--AND ManualStatus NOT IN (15996, 16000, 16326, 16330)
AND (interestatcycle - InterestCreditsCTD) = 0

-----------Q4 - SRB = 0 AND Int > 0
-----------Q5 - TotalDue_Proj<>Sum of DQ buckets
-----------Q6 - Proj_CD check
-----------Q7 - Proj_CD>Original_CD
-----------Q8 - Proj_TD>Original_TD
-----------Q9 - Proj_PD>Original_PD
-----------Q10 - Proj_1CPD>Original_1CPD
-----------Q11 - Proj_2CPD>Original_2CPD
-----------Q12 - Proj_3CPD>Original_3CPD
-----------Q13 - Proj_4CPD>Original_4CPD
-----------Q14 - Proj_5CPD>Original_5CPD
-----------Q15 - Proj_6CPD>Original_6CPD
-----------Q16 - Proj_7CPD>Original_7CPD
-----------Q17 - Int Credit check

-----------Q18 - Payment > Last cycle min due but account is past due

SELECT COUNT(Distinct T1.acctID)
FROM ##Final_AllAccounts T1
JOIN ##Final_AllAccounts T2 ON (T1.acctID = T2.acctID AND T1.RecordNumber+1 = T2.RecordNumber)
WHERE T2.RecordType = 'ImpactedRecords'
AND T1.AmountOfPaymentsCTD > T1.AmountOftotalDue_Proj
AND T2.ProjectedDQ > 1
AND T2.OriginalDQ-T1.OriginalDQ <= 1
AND T2.SystemStatus <> 14
AND T2.ManualStatus NOT IN (15996, 16000, 16326, 16330)


SELECT Distinct T1.acctID
FROM ##Final_AllAccounts T1
JOIN ##Final_AllAccounts T2 ON (T1.acctID = T2.acctID AND T1.RecordNumber+1 = T2.RecordNumber)
WHERE T2.RecordType = 'ImpactedRecords'
AND T1.AmountOfPaymentsCTD > T1.AmountOftotalDue_Proj
AND T2.ProjectedDQ > 1
AND T2.OriginalDQ-T1.OriginalDQ <= 1
AND T2.SystemStatus <> 14
AND T2.ManualStatus NOT IN (15996, 16000, 16326, 16330)

SELECT *
FROM ##Final_AllAccounts
WHERE OriginalDQ > 2 
AND ProjectedDQ <= 2






















-------------Q5 - Due_previous cycle - Payments + CD_CurrentCycle <> Due_CurrentCycle

SELECT T2.*
FROM ##Final_AllAccounts T1
JOIN ##Final_AllAccounts T2 ON (T1.acctID = T2.acctID AND T1.RecordNumber+1 = T2.RecordNumber)
WHERE T2.RecordType = 'ImpactedRecords' AND T1.RecordType = 'ImpactedRecords'
AND CASE 
		WHEN T1.AmountOfTotalDue_Proj-(T2.AmountOfPaymentsCTD + CASE WHEN T2.AmountToAdjustWithDQ-T2.AmountOfPaymentsCTD > 0 THEN T2.AmountToAdjustWithDQ-T2.AmountOfPaymentsCTD ELSE 0 END) >= 0 
		THEN T1.AmountOfTotalDue_Proj-(T2.AmountOfPaymentsCTD + CASE WHEN T2.AmountToAdjustWithDQ-T2.AmountOfPaymentsCTD > 0 THEN T2.AmountToAdjustWithDQ-T2.AmountOfPaymentsCTD ELSE 0 END) ELSE 0 END 
		+T2.AmtOfPayCurrDue_Proj <> T2.AmountOfTotalDue_Proj
AND T2.ProjectedDQ-T1.ProjectedDQ <= 1
AND T2.SystemStatus <> 14
AND T2.AmountOfPaymentsCTD > 0
AND T2.ProjectedDQ > 1
AND T2.PHPImpact = 'YES'

--- Q6 Current Due validation

SELECT COUNT(1) FROM ##Final_AllAccounts WHERE AmtOfPayCurrDue_Proj > AmtOfPayCurrDue_Original

--- Q7 Total Due validation

SELECT COUNT(1) FROM ##Final_AllAccounts WHERE AmountOfTotalDue_Proj > AmountOfTotalDue_Original

--- Q8 Sum of DQ buckets

SELECT COUNT(1) FROM ##Final_AllAccounts WHERE AmountOfTotalDue_Proj <> (AmtOfPayCurrDue_Proj+AmtOfPayXDLate_Proj+AmountOfPayment30DLate_Proj+AmountOfPayment60DLate_Proj+AmountOfPayment90DLate_Proj+AmountOfPayment120DLate_Proj+AmountOfPayment150DLate_Proj+AmountOfPayment180DLate_Proj+AmountOfPayment210DLate_Proj)



SELECT COUNT(DISTINCT acctID) 
FROM ##Final_AllAccounts 
WHERE SRB_Calc < AmountOfTotalDue_Proj 
AND SystemStatus <> 14


SELECT SystemStatus, ProjectedDQ, OriginalDQ,* 
FROM ##Final_AllAccounts 
WHERE acctID = 13548087 
--AND ProjectedDQ > OriginalDQ
--AND AmountOfPayment210DLate_Proj > AmountOfPayment210DLate_Original
ORDER BY acctID, RecordNumber

SELECT SystemStatus, OriginalDQ, CalculatedDQ, ProjectedDQ, * 
FROM ##Final_AllAccounts 
WHERE acctID = 287204 
--AND ProjectedDQ > OriginalDQ
--AND AmountOfPayment210DLate_Proj > AmountOfPayment210DLate_calc
ORDER BY acctID, RecordNumber