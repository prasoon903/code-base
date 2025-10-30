select  
'UPDATE TOP(1) BSegmentCreditCard SET ManualInitialChargeOffReason  =  ''' + coreasoncode + ''' WHERE acctId  ='  +   cast  (bp.acctid  as varchar ),
'UPDATE TOP(1) BSegment_Primary SET tpyblob  =  NULL, tpynad = NULL, tpylad = NULL WHERE acctId  ='  +  cast  (bp.acctid  as varchar ),
--'UPDATE TOP(1) AccountInfoForReport SET ManualInitialChargeOffReason = ''' + coreasoncode + ''' WHERE BSAcctId  ='  +   cast  (bp.acctid  as varchar ) + ' AND BusinessDay = ''2021-12-02 23:59:57''' AIR,
autoinitialchargeoffreason,manualinitialchargeoffreason,b.acctid,ccinhparent125aid,coreasoncode,statusdescription  
FROM LS_P1MARPRODDB01.ccgs_coreissue.dbo.BSegmentCreditCard  b  WITH(NOLOCK)  
JOIN LS_P1MARPRODDB01.ccgs_coreissue.dbo.BSegment_Primary  bp  WITH(NOLOCK) ON (b.acctid = bp.acctid )
JOIN LS_P1MARPRODDB01.ccgs_coreissue.dbo.AStatusAccounts a WITH(NOLOCK)  ON (a.merchantaid =  bp.parent05aid  and   a.parent01aid  = bp.ccinhparent125aid )
WHERE  bp.systemstatus = 14 
AND ((ISNULL(ManualInitialChargeOffReason, '0') = '0' OR ManualInitialChargeOffReason = '')
AND (ISNULL(AutoInitialChargeOffReason, '0') = '0' OR AutoInitialChargeOffReason = ''))