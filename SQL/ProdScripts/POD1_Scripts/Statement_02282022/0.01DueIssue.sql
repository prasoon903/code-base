DECLARE @BSacctId INT , @LastSatementDate DATETIME, @Businessday DATETIME, @CPSAcctID INT, @CBAPID DECIMAL(19, 0) = 0, @Due MONEY = 0, @StatementID DECIMAL(19,0) = 0

SET @BSacctId = 13354616
SET @LastSatementDate = '2021-08-31 23:59:57.000'

SELECT TOP 1 @CPSAcctID = acctId 
FROM LS_PRODDRGSDB01.ccgs_coreissue.dbo.CPSgmentAccounts WITH (NOLOCK)
WHERE parent02AID = @BSacctId
AND CreditPlanType = '0' AND CurrentBalance > 0.01
ORDER BY acctId

SELECT @Due = AmountOfTotalDue - 0.01 
FROM LS_PRODDRGSDB01.ccgs_coreissue.dbo.CPSgmentCreditCard WITH (NOLOCK)
WHERE acctId = @CPSAcctID

SELECT @StatementID = StatementID 
FROM LS_PRODDRGSDB01.ccgs_coreissue_secondary.dbo.StatementHeader WITH (NOLOCK)
WHERE acctId = @BSacctId AND StatementDate = @LastSatementDate



SELECT @CBAPID = IdentityField 
FROM LS_PRODDRGSDB01.ccgs_coreissue.dbo.CurrentBalanceAuditPS WITH (NOLOCK)
WHERE AID = @CPSAcctID
AND DENAME IN (200)
AND Businessday = @LastSatementDate


SELECT 'UPDATE TOP(1) CPSgmentCreditCard SET AmtOfPayCurrDue = AmtOfPayCurrDue - 0.01, AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE acctId = ' + TRY_CAST(@CPSAcctID AS VARCHAR)
SELECT 'UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue - 0.01 WHERE acctId = ' + TRY_CAST(@CPSAcctID AS VARCHAR) + ' AND StatementID =  ' + TRY_CAST(@StatementID AS VARCHAR)
SELECT 'UPDATE TOP(1) SummaryHeaderCreditCard SET CurrentDue = CurrentDue - 0.01 WHERE acctId = ' + TRY_CAST(@CPSAcctID AS VARCHAR) + ' AND StatementID =  ' + TRY_CAST(@StatementID AS VARCHAR)
SELECT 'UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = ''' + TRY_CAST(@Due AS VARCHAR) + ''' WHERE AID = ' + TRY_CAST(@CPSAcctID AS VARCHAR) + '  AND ATID = 52 AND IdentityField =  ' + TRY_CAST(@CBAPID AS VARCHAR)