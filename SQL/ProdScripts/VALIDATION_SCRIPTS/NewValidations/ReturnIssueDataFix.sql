DECLARE @BSacctId INT , @LastSatementDate DATETIME, @Businessday DATETIME, @CPSAcctID INT, @CBAPID DECIMAL(19, 0) = 0, 
@Due MONEY = 0, @StatementID DECIMAL(19,0) = 0, @TranID DECIMAL(19, 0) = 0, @CBATranTime DATETIME

SET @BSacctId = 13354616
SET @LastSatementDate = '2021-08-31 23:59:57.000'

SELECT TOP 1 @CPSAcctID = acctId 
FROM LS_PRODDRGSDB01.ccgs_coreissue.dbo.CPSgmentAccounts WITH (NOLOCK)
WHERE parent02AID = @BSacctId
AND CreditPlanType IN ('0', '10') AND CurrentBalance > 0
ORDER BY acctId

SELECT @Due = AmountOfTotalDue
FROM LS_PRODDRGSDB01.ccgs_coreissue.dbo.CPSgmentCreditCard WITH (NOLOCK)
WHERE acctId = @CPSAcctID

--SELECT @StatementID = StatementID 
--FROM LS_PRODDRGSDB01.ccgs_coreissue_secondary.dbo.StatementHeader WITH (NOLOCK)
--WHERE acctId = @BSacctId AND StatementDate = @LastSatementDate



SELECT TOP 1 @TranID = TID , @CBATranTime = BusinessDAy
FROM LS_PRODDRGSDB01.ccgs_coreissue.dbo.CurrentBalanceAudit WITH (NOLOCK)
WHERE AID = @BSacctId
AND DENAME IN (210)
AND NewValue = '0.00'
AND Businessday > @LastSatementDate

SELECT @CBAPID = IdentityField 
FROM LS_PRODDRGSDB01.ccgs_coreissue.dbo.CurrentBalanceAuditPS WITH (NOLOCK)
WHERE AID = @CPSAcctID
AND DENAME IN (200)
AND TID = @TranID
AND Businessday > @LastSatementDate


SELECT 'UPDATE TOP(1) CPSgmentCreditCard SET AmtOfPayCurrDue = AmtOfPayCurrDue - ' + AmtOfPayCurrDue + ', AmountOfTotalDue = AmountOfTotalDue - ' + AmountOfTotalDue + ', CycleDueDTD = 0 WHERE acctId = ' + TRY_CAST(@CPSAcctID AS VARCHAR) + ' -- BS: ' + TRY_CAST(@BSAcctID AS VARCHAR)

SELECT '
INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue)
VALUES
(TRY_CAST(@TranID AS VARCHAR), 'TRY_CAST(@CBATranTime AS VARCHAR)', 52, TRY_CAST(@CPSAcctID AS VARCHAR), 115, ''1',' '0'),
(TRY_CAST(@TranID AS VARCHAR), 'TRY_CAST(@CBATranTime AS VARCHAR)', 52, TRY_CAST(@CPSAcctID AS VARCHAR), 200, 'TRY_CAST(@Due AS VARCHAR)', '0.00')


SELECT 'UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE acctId = ' + TRY_CAST(@CPSAcctID AS VARCHAR) + ' AND StatementID =  ' + TRY_CAST(@StatementID AS VARCHAR)
SELECT 'UPDATE TOP(1) SummaryHeaderCreditCard SET CurrentDue = CurrentDue - 0.01 WHERE acctId = ' + TRY_CAST(@CPSAcctID AS VARCHAR) + ' AND StatementID =  ' + TRY_CAST(@StatementID AS VARCHAR)
SELECT 'UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = ''' + TRY_CAST(@Due AS VARCHAR) + ''' WHERE AID = ' + TRY_CAST(@CPSAcctID AS VARCHAR) + '  AND ATID = 52 AND IdentityField =  ' + TRY_CAST(@CBAPID AS VARCHAR)