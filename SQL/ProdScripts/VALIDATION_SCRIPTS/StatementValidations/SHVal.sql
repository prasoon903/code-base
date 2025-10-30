--Q28
SELECT SH.acctId, SH.StatementID, SH.StatementDate, AIR.BusinessDay, SH.ccinhParent127AID, AIR.ccinhParent127AID,
'UPDATE TOP(1) AccountInfoForReport SET ccinhParent127AID = ' + TRY_CAST(ccinhParent127AID AS VARCHAR) + ' WHERE BSAcctID = ' + TRY_CAST(BSAcctID AS VARCHAR) + ' AND BusinessDay = ''2022-08-31 23:59:57.000'''
FROM LS_P1MARPRODDB01.ccgs_coreissue_secondary.dbo.StatementHeader SH WITH (NOLOCK)
JOIN AccountInfoForReport AIR WITH (NOLOCK) 
ON (SH.acctID = AIR.BSAcctID AND SH.StatementDate = AIR.BusinessDay)
WHERE SH.StatementDate = '2022-08-31 23:59:57.000'
AND SH.ccinhParent127AID <> AIR.ccinhParent127AID
AND SH.acctId IN (693342,1293939,3584765,16428051,21118035,21368093,21402456,21525621,21634812,21646308)

SELECT BSAcctID, AIR.BusinessDay, AIR.ccinhParent127AID
FROM AccountInfoForReport AIR WITH (NOLOCK) 
WHERE AIR.BusinessDay = '2022-08-31 23:59:57.000'
AND BSAcctId IN (693342,1293939,3584765,16428051,21118035,21368093,21402456,21525621,21634812,21646308)

-- Q18

SELECT BSAcctID, CycleDueDTD, TotalDaysDelinquent, DaysDelinquent, DateOfOriginalPaymentDueDTD, DateOfDelinquency, 
'UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = ' + TRY_CAST(DaysDelinquent AS VARCHAR) + ' WHERE BSAcctID = ' + TRY_CAST(BSAcctID AS VARCHAR) + ' AND BusinessDay = ''2022-08-31 23:59:57.000'''
FROM LS_P1MARPRODDB01.ccgs_coreissue_secondary.dbo.AccountInfoForReport AIR WITH (NOLOCK) 
WHERE AIR.BusinessDay = '2022-08-31 23:59:57.000'
AND TotalDaysDelinquent < 0
AND BSAcctId IN (277948,2080569,2116841,2301281,4520648,7909910,1035017,2215724,2234687,13947697,14122228,17743380)


--Q26
SELECT BSAcctID, CycleDueDTD, TotalDaysDelinquent, DaysDelinquent, DateOfOriginalPaymentDueDTD, DateOfDelinquency, 
'UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = ' + TRY_CAST(DaysDelinquent AS VARCHAR) + ' WHERE BSAcctID = ' + TRY_CAST(BSAcctID AS VARCHAR) + ' AND BusinessDay = ''2022-08-31 23:59:57.000''' AccountInfoForReport,
'UPDATE TOP(1) StatementHeaderEX SET NoPayDaysDelinquent = ' + TRY_CAST(DaysDelinquent AS VARCHAR) + ' WHERE AcctID = ' + TRY_CAST(BSAcctID AS VARCHAR) + ' AND StatementDate = ''2022-08-31 23:59:57.000''' StatementHeaderEX
FROM LS_P1MARPRODDB01.ccgs_coreissue_secondary.dbo.AccountInfoForReport AIR WITH (NOLOCK) 
WHERE AIR.BusinessDay = '2022-08-31 23:59:57.000'
AND TotalDaysDelinquent < DaysDelinquent
--AND BSAcctId NOT IN (277948,2080569,2116841,2301281,4520648,7909910,1035017,2215724,2234687,13947697,14122228,17743380
--,1440067,2908817,4853815,4909611,4913824,6805783,13543464,15945625,17323865,277855,404922,1140904,1156616,1992621,2639620,2645992,2676140,4346940,6408687,7895161,10234517,10890281,11862323,11957840,17996163)
AND SystemStatus <> 14

--Q25
SELECT BSAcctID, CurrentBalance, CycleDueDTD, TotalDaysDelinquent, DaysDelinquent, DateOfOriginalPaymentDueDTD, DateOfDelinquency, 
'UPDATE TOP(1) AccountInfoForReport SET DaysDelinquent = ' + TRY_CAST(DaysDelinquent AS VARCHAR) + ' WHERE BSAcctID = ' + TRY_CAST(BSAcctID AS VARCHAR) + ' AND BusinessDay = ''2022-08-31 23:59:57.000''',
'UPDATE TOP(1) StatementHeaderEX SET NoPayDaysDelinquent = ' + TRY_CAST(DaysDelinquent AS VARCHAR) + ' WHERE AcctID = ' + TRY_CAST(BSAcctID AS VARCHAR) + ' AND StatementDate = ''2022-08-31 23:59:57.000''' StatementHeaderEX
FROM LS_P1MARPRODDB01.ccgs_coreissue_secondary.dbo.AccountInfoForReport AIR WITH (NOLOCK) 
WHERE AIR.BusinessDay = '2022-08-31 23:59:57.000'
AND CurrentBalance <= 0 AND DaysDelinquent > 0
--AND BSAcctId IN (1133683,2300825,12882410,17301694,762543,3222312,11029938)
AND SystemStatus <> 14

SELECT AcctID, CurrentBalance, CycleDueDTD, DateOfOriginalPaymentDueDTD
FROM LS_P1MARPRODDB01.ccgs_coreissue_secondary.dbo.StatementHeader AIR WITH (NOLOCK) 
WHERE AIR.StatementDate = '2022-08-31 23:59:57.000'
AND CurrentBalance <= 0 
AND AcctId IN (1133683,2300825,12882410,17301694,762543,3222312,11029938)
AND SystemStatus <> 14


--Q20
SELECT BSAcctID, CycleDueDTD, TotalDaysDelinquent, DaysDelinquent, DateOfOriginalPaymentDueDTD, DateOfDelinquency, 
'UPDATE TOP(1) AccountInfoForReport SET TotalDaysDelinquent = 1, DaysDelinquent = 1, DateOfOriginalPaymentDueDTD = ''2022-08-31 23:59:57.000'' WHERE BSAcctID = ' + TRY_CAST(BSAcctID AS VARCHAR) + ' AND BusinessDay = ''2022-08-31 23:59:57.000''' AccountInfoForReport,
'UPDATE TOP(1) StatementHeader SET DateOfOriginalPaymentDueDTD = ''2022-08-31 23:59:57.000'' WHERE AcctID = ' + TRY_CAST(BSAcctID AS VARCHAR) + ' AND StatementDate = ''2022-08-31 23:59:57.000''' StatementHeader,
'UPDATE TOP(1) StatementHeaderEx SET NoPayDaysDelinquent = 1, DaysDelinquent = 1 WHERE AcctID = ' + TRY_CAST(BSAcctID AS VARCHAR) + ' AND StatementDate = ''2022-08-31 23:59:57.000''' StatementHeaderEX
FROM LS_P1MARPRODDB01.ccgs_coreissue_secondary.dbo.AccountInfoForReport AIR WITH (NOLOCK) 
WHERE AIR.BusinessDay = '2022-08-31 23:59:57.000'
AND CycleDueDTD > 1 AND DateOfOriginalPaymentDueDTD IS NULL
--AND BSAcctId In (1075129,1860208,4620669,4725201,15129357,241303,442759,9591604,13382512)

SELECT AcctID, CurrentBalance, CycleDueDTD, DateOfOriginalPaymentDueDTD
FROM LS_P1MARPRODDB01.ccgs_coreissue_secondary.dbo.StatementHeader AIR WITH (NOLOCK) 
WHERE AIR.StatementDate = '2022-08-31 23:59:57.000'
--AND CurrentBalance <= 0 
--AND AcctId IN (1075129,1860208,4620669,4725201,15129357,241303,442759,9591604,13382512)
AND SystemStatus <> 14


SELECT BSAcctID, CycleDueDTD, SystemStatus, TotalDaysDelinquent, DaysDelinquent, DateOfOriginalPaymentDueDTD, DateOfDelinquency, ChargeOffDate
FROM AccountInfoForReport AIR WITH (NOLOCK) 
WHERE AIR.BusinessDay = '2023-07-30 23:59:57.000'
AND CycleDueDTD <= 1 AND DaysDelinquent > 0



SELECT SH.AcctID, CurrentBalance, CycleDueDTD, DateOfOriginalPaymentDueDTD, SE.DaysDelinquent, SE.NoPayDaysDelinquent
FROM LS_P1MARPRODDB01.ccgs_coreissue_secondary.dbo.StatementHeader SH WITH (NOLOCK) 
JOIN LS_P1MARPRODDB01.ccgs_coreissue.dbo.StatementHeaderEX SE WITH (NOLOCK)  ON (SH.acctId = SE.acctId AND SH.STatementID = SE.StatementID)
WHERE SH.StatementDate = '2023-07-31 23:59:57.000'
AND CycleDueDTD <= 1 AND DaysDelinquent > 0
AND SH.acctID In 
(

--AND CurrentBalance <= 0 
--AND SH.AcctId IN (2296309)
--AND SystemStatus <> 14


SELECT AcctID, DaysDelinquent, NoPayDaysDelinquent
FROM LS_P1MARPRODDB01.ccgs_coreissue.dbo.StatementHeaderEX SE WITH (NOLOCK) 
WHERE StatementDate = '2023-07-31 23:59:57.000'
AND DaysDelinquent > NoPayDaysDelinquent
--AND DaysDelinquent < 0
--AND CurrentBalance <= 0 
--AND SH.AcctId IN (2296309)
--AND SystemStatus <> 14









