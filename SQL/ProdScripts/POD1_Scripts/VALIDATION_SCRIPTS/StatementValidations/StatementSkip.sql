SELECT CMTTRanType, SUM(TransactionAmount) TransactionAmount
FROM LS_P1MARPRODDB01.ccgs_CoreIssue.dbo.CCard_Primary WITH (NOLOCK) 
WHERE AccountNumber = '1100011156559399' 
AND PostTime > '2022-09-30 23:59:57.000' 
AND PostTime <= '2022-10-31 23:59:57.000'
AND LEN(CMTTRanType) = 2
AND MemoIndicator IS NULL
GROUP BY CMTTRanType


BB = 6713.70

--UPDATE TOP(1) StatementHeader SET 
--AmountOFPaymentsCTD= 6598.79,
--AmountOfPurchasesCTD = 5546.94,
--AmountOfDebitsCTD = 5547.1,
--AmountOfReturnsCTD = 15.98,
--AmountOfCreditsCTD = 6614.77
--WHERE acctID = 12946127
--AND StatementDate = '2022-10-31 23:59:57.000'

SELECT AmountOFPaymentsCTD, AmountOfPurchasesCTD, AmountOfDebitsCTD, AmountOfReturnsCTD, AmountOfCreditsCTD, * 
FROM LS_P1MARPRODDB01.ccgs_CoreIssue_Secondary.dbo.StatementHeader WITH (NOLOCK) 
WHERE acctID = 12946127
AND StatementDate = '2022-10-31 23:59:57.000'

SELECT AmountOFPaymentsCTD, AmountOfPurchasesCTD, AmountOfDebitsCTD, AmountOfReturnsCTD, AmountOfCreditsCTD, * 
FROM StatementHeader WITH (NOLOCK) 
WHERE acctID = 12946127
AND StatementDate = '2022-10-31 23:59:57.000'

SELECT AIR.*
   FROM   AccountInfoForReport AIR
             JOIN LS_P1MARPRODDB01.ccgs_CoreIssue_Secondary.dbo.StatementHeader SH WITH(NOLOCK)
               ON ( AIR.Businessday = '2022-10-31 23:59:57.000'
                    AND AIR.BSAcctid = SH.acctId)
			JOIN LS_P1MARPRODDB01.ccgs_CoreIssue.dbo.StatementHeaderEx SE WITH(NOLOCK)
			  ON (SH.acctId = SE.acctId
                    AND SH.StatementID = SE.StatementID)
					where   SH.acctid in (12946127) 
					 		AND SH.StatementDate = '2022-10-31 23:59:57.000'




SELECT AIR.*
   FROM   LS_P1MARPRODDB01.ccgs_CoreIssue_Secondary.dbo.AccountInfoForReport AIR
             JOIN LS_P1MARPRODDB01.ccgs_CoreIssue_Secondary.dbo.StatementHeader SH WITH(NOLOCK)
               ON ( AIR.Businessday = '2022-10-31 23:59:57.000'
                    AND AIR.BSAcctid = SH.acctId)
			JOIN LS_P1MARPRODDB01.ccgs_CoreIssue.dbo.StatementHeaderEx SE WITH(NOLOCK)
			  ON (SH.acctId = SE.acctId
                    AND SH.StatementID = SE.StatementID)
					where   SH.acctid in (12946127) 
					 		AND SH.StatementDate = '2022-10-31 23:59:57.000'

SELECT PIR.*
							FROM   LS_P1MARPRODDB01.ccgs_CoreIssue_Secondary.dbo.PlanInfoForReport PIR
             JOIN LS_P1MARPRODDB01.ccgs_CoreIssue_Secondary.dbo.SummaryHeader SH WITH(NOLOCK)
               ON ( 
                     PIR.CPSAcctid = SH.acctId
                    AND SH.StatementDate = '2022-10-31 23:59:57.000' )
             JOIN LS_P1MARPRODDB01.ccgs_CoreIssue.dbo.SummaryHeaderCreditCard SHCC WITH(NOLOCK)
               ON ( SH.acctId = SHCC.acctId
                    AND SH.StatementID = SHCC.StatementID )
					where  sh.parent02aid in  (12946127) and PIR.BusinessDay  = '2022-10-31 23:59:57.000'

