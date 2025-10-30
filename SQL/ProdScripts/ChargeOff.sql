SELECT acctId, AccountNumber, UniversalUniqueID, CycleDueDTD
FROM BSegment_Primary WITH (NOLOCK)
WHERE UniversalUniqueID IN (
'54642eaf-e46c-4f3a-b471-d67c1e606385',
'f1442bbc-a0dd-4cef-af3f-3a8ec0e52131')

--4495723	1100011135054512   	54642eaf-e46c-4f3a-b471-d67c1e606385	8
--4727853	1100011136638818   	f1442bbc-a0dd-4cef-af3f-3a8ec0e52131	7  

SELECT AccountNumber, BusinessDay, ChargeOffDate, ChargeOffDateParam, ccinhParent125AID, SystemStatus, CycleDueDTD, DaysDelinquent
FROM AccountInfoForreport WITH (NOLOCK)
WHERE BSacctId = 4495723
AND BusinessDay BETWEEN '2022-12-21 23:59:57' AND '2023-02-22 23:59:57'
ORDER BY BusinessDay

SELECT BSAcctID, FeesAcctID, CPMGroup, TranTime, PostTime, CMTTranType
FROM CCard_Primary WITH (NOLOCK)
WHERE AccountNumber= '1100011120103290'
--AND CMTTranType IN ('*SCR', '51')
ORDER By PostTime DESC


SELECT AccountNumber, BusinessDay, ChargeOffDate, ChargeOffDateParam, ccinhParent125AID, SystemStatus, CycleDueDTD, DaysDelinquent
FROM AccountInfoForreport WITH (NOLOCK)
WHERE BSacctId = 4727853
AND BusinessDay BETWEEN '2022-01-08 23:59:57' AND '2023-05-31 23:59:57'
ORDER BY BusinessDay

SELECT BSAcctID, FeesAcctID, CPMGroup, TranTime, PostTime, CMTTranType
FROM CCard_Primary WITH (NOLOCK)
WHERE AccountNumber= '1100011136638818'
AND CMTTranType IN ('*SCR', '51', '*RCLS')
ORDER By PostTime


SELECT Parent01AID, StatusDescription, Priority, COReasonCode, AfterNumberOfCycles 
FROM AStatusAccounts WITH (NOLOCK)
WHERE MerchantAID= 14992 
AND Parent01AID IN (5202, 16010, 16002, 16014,16022, 16008)

SELECT Parent01AID, StatusDescription, Priority, COReasonCode, AfterNumberOfCycles 
FROM AStatusAccounts WITH (NOLOCK)
WHERE MerchantAID= 14992 
AND COReasonCode IS NOT NULL

SELECT Parent01AID, StatusDescription, Priority, COReasonCode, AfterNumberOfCycles 
FROM AStatusAccounts WITH (NOLOCK)
WHERE MerchantAID= 14992 
AND Parent01AID IN (16, 16100, 16392, 16384, 16304, 16000)