--DROP TABLE IF EXISTS ##CBRAccounts
--SELECT BP.acctID, AccountNumber, CreatedTime, LastStatementDate, AcquisitionDate, 
--CurrentBalance+CurrentBalanceCO CurrentBalance, AmtOfAcctHighBalLTD, CBRLastCalculatedDate,
--TRY_CAST(NULL AS MONEY) CB_Calc, TRY_CAST(NULL AS MONEY) HB_Calc, TRY_CAST(NULL AS MONEY) CB_Stmt_Calc, TRY_CAST(NULL AS MONEY) HB_Stmt_Calc, 0 JobStatus
--INTO ##CBRAccounts
--FROM BSegment_Primary BP WITH (NOLOCK)
--JOIN BSegment_Balances BB WITH (NOLOCK) ON (BP.acctID = BB.acctID)
--JOIN BSegmentCreditCard BC WITH (NOLOCK) ON (BB.acctID = BC.acctID)
--WHERE BB.CBRLastCalculatedDate IS NOT NULL

--SELECT * FROM sys.servers


DROP TABLE IF EXISTS ##CBRAccounts
SELECT BSAcctID acctID, AccountNumber, DateAcctOpened CreatedTime, LastStatementDate, 
CurrentBalance+CurrentBalanceCO CurrentBalance, AmtOfAcctHighBalLTD,
TRY_CAST(NULL AS MONEY) CB_Calc, TRY_CAST(NULL AS MONEY) HB_Calc, TRY_CAST(NULL AS MONEY) CB_Stmt_Calc, TRY_CAST(NULL AS MONEY) HB_Stmt_Calc, 0 JobStatus
INTO ##CBRAccounts
FROM LINK_Automation.CCGS_RPT_CoreIssue.DBO.AccountInfoForReport WITH (NOLOCK)
WHERE BusinessDay = '2025-04-29 23:59:57'
AND CurrentBalance+CurrentBalanceCO > AmtOfAcctHighBalLTD

UPDATE T
SET JobStatus = 5
FROM ##CBRAccounts T
WHERE CurrentBalance <= AmtOfAcctHighBalLTD

--UPDATE ##CBRAccounts SET JobStatus = 0 WHERE JobStatus = 1

--SELECT * FROM ##CBRAccounts WHERE JobStatus = 1 AND CurrentBalance < CB_Calc

--SELECT COUNT(1) ImpactedAccounts FROM ##CBRAccounts WHERE CurrentBalance > AmtOfAcctHighBalLTD


