SELECT CMTTRanType, SUM(TransactionAmount) TransactionAmount
FROM LS_P1MARPRODDB01.ccgs_CoreIssue.dbo.CCard_Primary WITH (NOLOCK) 
WHERE AccountNumber = '1100011116419544' 
AND PostTime > '2023-07-31 23:59:57.000' 
AND PostTime <= '2023-08-31 23:59:57.000'
--AND LEN(CMTTRanType) = 2
--AND (MemoIndicator IS NULL OR (MemoIndicator IS NOT NULL AND CMTTRanType = '43'))
--AND ArTxnType IN ('91', '99', '96')
GROUP BY CMTTRanType

SELECT * FROM CPSgmentAccounts WITH (NOLOCK) WHERE parent02AID = -1645591

--21943042


BB = 6713.70

--UPDATE TOP(1) StatementHeader SET 
--AmountOFPaymentsCTD= 7316.74,
--AmountOfPurchasesCTD = 8871.17,
--AmountOfDebitsCTD = 9159.4,
--AmountOfReturnsCTD = 510.27,
--AmountOfCreditsCTD = 7826.98
--WHERE acctID = 21943042
--AND StatementDate = '2023-05-31 23:59:57.000'

SELECT AmountOFPaymentsCTD, AmountOfPurchasesCTD, AmountOfDebitsCTD, AmountOfReturnsCTD, AmountOfCreditsCTD, * 
FROM LS_P1MARPRODDB01.ccgs_CoreIssue_Secondary.dbo.StatementHeader WITH (NOLOCK) 
WHERE acctID = 21943042

SELECT BeginningBalance, CurrentBalance,AmountOFPaymentsCTD, AmountOfPurchasesCTD, AmountOfDebitsCTD, AmountOfReturnsCTD, AmountOfCreditsCTD, * 
FROM LS_P1MARPRODDB01.ccgs_CoreIssue_Secondary.dbo.StatementHeader WITH (NOLOCK) 
WHERE acctID = 21943042
AND StatementDate = '2023-05-31 23:59:57.000'

SELECT AmountOFPaymentsCTD, AmountOfPurchasesCTD, AmountOfDebitsCTD, AmountOfReturnsCTD, AmountOfCreditsCTD, * 
FROM StatementHeader WITH (NOLOCK) 
WHERE acctID = 21943042
AND StatementDate = '2023-05-31 23:59:57.000'

SELECT AIR.*
   FROM   AccountInfoForReport AIR
             JOIN LS_P1MARPRODDB01.ccgs_CoreIssue_Secondary.dbo.StatementHeader SH WITH(NOLOCK)
               ON ( AIR.Businessday = '2023-05-31 23:59:57.000'
                    AND AIR.BSAcctid = SH.acctId)
			JOIN LS_P1MARPRODDB01.ccgs_CoreIssue.dbo.StatementHeaderEx SE WITH(NOLOCK)
			  ON (SH.acctId = SE.acctId
                    AND SH.StatementID = SE.StatementID)
					where   SH.acctid in (21943042) 
					 		AND SH.StatementDate = '2023-05-31 23:59:57.000'




SELECT AIR.*
   FROM   LS_P1MARPRODDB01.ccgs_CoreIssue_Secondary.dbo.AccountInfoForReport AIR
             JOIN LS_P1MARPRODDB01.ccgs_CoreIssue_Secondary.dbo.StatementHeader SH WITH(NOLOCK)
               ON ( AIR.Businessday = '2023-05-31 23:59:57.000'
                    AND AIR.BSAcctid = SH.acctId)
			JOIN LS_P1MARPRODDB01.ccgs_CoreIssue.dbo.StatementHeaderEx SE WITH(NOLOCK)
			  ON (SH.acctId = SE.acctId
                    AND SH.StatementID = SE.StatementID)
					where   SH.acctid in (21943042) 
					 		AND SH.StatementDate = '2023-05-31 23:59:57.000'

SELECT PIR.*
							FROM   LS_P1MARPRODDB01.ccgs_CoreIssue_Secondary.dbo.PlanInfoForReport PIR
             JOIN LS_P1MARPRODDB01.ccgs_CoreIssue_Secondary.dbo.SummaryHeader SH WITH(NOLOCK)
               ON ( 
                     PIR.CPSAcctid = SH.acctId
                    AND SH.StatementDate = '2023-05-31 23:59:57.000' )
             JOIN LS_P1MARPRODDB01.ccgs_CoreIssue.dbo.SummaryHeaderCreditCard SHCC WITH(NOLOCK)
               ON ( SH.acctId = SHCC.acctId
                    AND SH.StatementID = SHCC.StatementID )
					where  sh.parent02aid in  (21943042) and PIR.BusinessDay  = '2023-05-31 23:59:57.000'

