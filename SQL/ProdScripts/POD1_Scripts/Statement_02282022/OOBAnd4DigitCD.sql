SELECT 	plansegcreatedate,s.statementdate, OriginalPurchaseAmount - 
(CurrentBalance + CurrentBalanceCO +  (ISNULL(AmountOfCreditsLTD,0) - isnull(AmountOfCreditsRevLTD,0)) + isnull(DisputesAmtNS,0) + isnull (DispRCHFavororWriteoff,0) + isnull(ManualPurchaseReversal_LTD,0) ) 
as  diff , OriginalPurchaseAmount,CurrentBalance,CurrentBalanceCO,AmountOfCreditsLTD,AmountOfCreditsRevLTD,DisputesAmtNS,DispRCHFavororWriteoff,ManualPurchaseReversal_LTD ,s.acctid ,s.parent02aid
FROM  dbo.cpsgmentaccounts   s  with(nolock)  join dbo.cpsgmentcreditcard  shcc with(nolock) on (s.acctid = shcc.acctid   )
WHERE CreditPlanType = '16'
AND OriginalPurchaseAmount <> 
(CurrentBalance + CurrentBalanceCO + (ISNULL(AmountOfCreditsLTD,0) - isnull(AmountOfCreditsRevLTD,0)) + isnull(DisputesAmtNS,0) + isnull (DispRCHFavororWriteoff,0) + isnull(ManualPurchaseReversal_LTD,0) ) 
AND parent02aid = 4377152
order by s.acctID


SELECT 	plansegcreatedate,s.statementdate, OriginalPurchaseAmount - 
(CurrentBalance + CurrentBalanceCO +  (ISNULL(AmountOfCreditsLTD,0) - isnull(AmountOfCreditsRevLTD,0)) + isnull(DisputesAmtNS,0) + isnull (DispRCHFavororWriteoff,0) + isnull(ManualPurchaseReversal_LTD,0) ) 
as  diff , OriginalPurchaseAmount,CurrentBalance,CurrentBalanceCO,AmountOfCreditsLTD,AmountOfCreditsRevLTD,DisputesAmtNS,DispRCHFavororWriteoff,ManualPurchaseReversal_LTD ,s.acctid ,s.parent02aid
FROM  LS_PRODDRGSDB01.ccgs_coreissue_Secondary.dbo.SummaryHeader   s  with(nolock)  
join LS_PRODDRGSDB01.ccgs_coreissue.dbo.SummaryHeadercreditcard  shcc with(nolock) on (s.acctid = shcc.acctid   )
WHERE CreditPlanType = '16'
AND OriginalPurchaseAmount <> 
(CurrentBalance + CurrentBalanceCO + (ISNULL(AmountOfCreditsLTD,0) - isnull(AmountOfCreditsRevLTD,0)) + isnull(DisputesAmtNS,0) + isnull (DispRCHFavororWriteoff,0) + isnull(ManualPurchaseReversal_LTD,0) ) 
AND parent02aid = 4377152 AND S.StatementID = 100092964
order by s.acctID



  select accountnumber, transactionamount, postingref, * from LS_PRODDRGSDB01.ccgs_coreissue.dbo.ccard_primary with (nolock) where tranid = 44897057125
  select accountnumber, transactionamount,postingref,* from LS_PRODDRGSDB01.ccgs_coreissue.dbo.ccard_primary with (nolock) where TranRef = 44897057125

   select transactionamount,postingref,* from ccard_primary with (nolock) where accountnumber = '1100011113567881' order by posttime desc

   --update TOP(1) ccard_primary set accountnumber = '1100011113567881', txnacctid = 1360385 where tranid = 44897057125

   SELECT * FROm BSegment_Primary WITH (NOLOCK) WHERE AccountNumber = '1100011113567881'

   SELECT * FROm LS_PRODDRGSDB01.ccgs_coreissue.dbo.DoDetailTxns WITH (NOLOCK) 
   WHERE acctId = 1360385
   AND TranID = 44897057125
   ORDER BY StatementDate DESC

   --INSERT INTO DoDetailTxns (TranId,ATID,acctId,StatementDate,StatementID,StatementHID)
   --VALUES
   --(44897057125, 51,1360385,'2021-10-31 23:59:57.000',98243481,98227536)

   SELECT StatementID, StatementHID, * 
   FROm LS_PRODDRGSDB01.ccgs_coreissue_secondary.dbo.StatementHeader WITH (NOLOCK) 
   WHERE acctId = 1360385
   AND TranID = 44897057125
   AND StatementDate = '2021-10-31 23:59:57.000'




select s.currentdue ,round(currentdue,2),sh.acctid, sh.Parent02AID, 
'UPDATE TOP(1) SummaryheaderCreditCard SET currentdue = ' + TRY_CAST(round(currentdue,2) AS VARCHAR) + ' WHERE acctId = ' + TRY_CAST(S.acctId AS VARCHAR) + ' AND StatementID = ' + TRY_CAST(S.StatementID AS varchar),
'UPDATE TOP(1) PlanInfoForReport SET AmtOfPayCurrDue = ' + TRY_CAST(round(currentdue,2) AS VARCHAR) + ' WHERE CPSacctId = ' + TRY_CAST(S.acctId AS VARCHAR) + ' AND BusinessDay = ''2021-12-31 23:59:57.000'''
from LS_PRODDRGSDB01.ccgs_coreissue.dbo.Summaryheadercreditcard s  with(nolock)
join  LS_PRODDRGSDB01.ccgs_coreissue_secondary.dbo.Summaryheader  sh with(nolock) on (s.acctid = sh.acctid and s.statementid = sh.statementid )
where statementdate = '2021-12-31 23:59:57.000'  
and   (((abs(currentdue)*100) - CONVERT(INT,(abs(currentdue)*100))) <> 0) 

SELECT '''2021-10-31 23:59:57.000'''


select s.AmtOfPayCurrDue , round(AmtOfPayCurrDue,2) from PROD1GSDB01.ccgs_coreissue.dbo.planinfoforreport s with(nolock)
	  where businessday = '2021-08-31 23:59:57.000' 	  and   (((abs(AmtOfPayCurrDue)*100) - CONVERT(INT,(abs(AmtOfPayCurrDue)*100))) <> 0)


SELECT SH.acctId, SH.StatementID, SH.StatementDate, AIR.BusinessDay, SH.ccinhParent127AID, AIR.ccinhParent127AID
FROM LS_PRODDRGSDB01.ccgs_coreissue_secondary.dbo.StatementHeader SH WITH (NOLOCK)
JOIN LS_PRODDRGSDB01.ccgs_coreissue_secondary.dbo.AccountInfoForReport AIR WITH (NOLOCK) 
ON (SH.acctID = AIR.BSAcctID AND SH.StatementDate = AIR.BusinessDay)
WHERE SH.StatementDate = '2021-10-31 23:59:57.000'
AND SH.ccinhParent127AID <> AIR.ccinhParent127AID
AND SH.acctId IN (693342,1293939,3584765,16428051,21118035,21368093,21402456,21525621,21634812,21646308)
