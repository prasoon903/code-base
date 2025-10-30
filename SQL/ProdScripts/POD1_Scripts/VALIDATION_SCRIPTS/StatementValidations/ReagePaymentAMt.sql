SELECT SH.ReagePaymentAMt , AIR.ReagePaymentAmt, AIR.BSacctID,
'UPDATE TOP(1) AccountInfoForReport SET ReagePaymentAmt = ' + TRY_CAST(SH.ReagePaymentAmt AS VARCHAR) + ' WHERE BSAcctID = ' + TRY_CAST(BSAcctID AS VARCHAR) + ' AND BusinessDay = ''2022-11-30 23:59:57.000'''
FROM StatementHeader SH WITH (NOLOCK)
JOIN AccountInfoForReport AIR WITH (NOLOCK) ON (SH.acctID = AIR.BSacctID AND SH.STatementDate = '2022-11-30 23:59:57' AND AIR.BusinessDay = '2022-11-30 23:59:57')
WHERE SH.ReagePaymentAMt <> AIR.ReagePaymentAmt

SELECT SH.ReageStatus , AIR.ReageStatus, AIR.BSacctID,
'UPDATE TOP(1) AccountInfoForReport SET ReageStatus = ' + TRY_CAST(SH.ReageStatus AS VARCHAR) + ' WHERE BSAcctID = ' + TRY_CAST(BSAcctID AS VARCHAR) + ' AND BusinessDay = ''2022-11-30 23:59:57.000'''
FROM StatementHeader SH WITH (NOLOCK)
JOIN AccountInfoForReport AIR WITH (NOLOCK) ON (SH.acctID = AIR.BSacctID AND SH.STatementDate = '2022-11-30 23:59:57' AND AIR.BusinessDay = '2022-11-30 23:59:57')
WHERE SH.ReageStatus <> AIR.ReageStatus


SELECT SH.TCAPStatus , AIR.TCAPStatus, AIR.BSacctID,
'UPDATE TOP(1) AccountInfoForReport SET TCAPStatus = ' + TRY_CAST(SH.TCAPStatus AS VARCHAR) + ' WHERE BSAcctID = ' + TRY_CAST(BSAcctID AS VARCHAR) + ' AND BusinessDay = ''2022-11-30 23:59:57.000'''
FROM StatementHeader SH WITH (NOLOCK)
JOIN AccountInfoForReport AIR WITH (NOLOCK) ON (SH.acctID = AIR.BSacctID AND SH.STatementDate = '2022-11-30 23:59:57' AND AIR.BusinessDay = '2022-11-30 23:59:57')
WHERE SH.TCAPStatus <> AIR.TCAPStatus

SELECT SH.InteragencyEligible , AIR.InteragencyEligible, AIR.BSacctID,
'UPDATE TOP(1) AccountInfoForReport SET InteragencyEligible = ' + TRY_CAST(SH.InteragencyEligible AS VARCHAR) + ' WHERE BSAcctID = ' + TRY_CAST(BSAcctID AS VARCHAR) + ' AND BusinessDay = ''2022-11-30 23:59:57.000'''
FROM StatementHeader SH WITH (NOLOCK)
JOIN AccountInfoForReport AIR WITH (NOLOCK) ON (SH.acctID = AIR.BSacctID AND SH.STatementDate = '2022-11-30 23:59:57' AND AIR.BusinessDay = '2022-11-30 23:59:57')
WHERE SH.InteragencyEligible <> AIR.InteragencyEligible
