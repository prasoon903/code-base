SELECT * FROM InterestRateUpdateJob
SELECT * FROM InterestRateUpdateLog
SELECT * FROM IndexRate

--DELETE FROM InterestRateUpdateJob WHERE acctID between 2985 AND 2990
--DELETE FROM IndexRate WHERE acctID between 2985 AND 2990


;WITH CTE
AS
(
SELECT acctId, IndexRateInterestParent, ROW_NUMBER() OVER(PARTITION BY IndexRateInterestParent ORDER BY DateEffective DESC) [Row]
FROM IndexRate WITH (NOLOCK)
)
SELECT acctId, IndexRateInterestParent FROM CTE WHERE [Row] = 1




DECLARE @CurrentTime DATE = dbo.PR_ISOGetBusinessTime()
DECLARE @acctId INT
DECLARE @IndexRateInterestParent VARCHAR(8)
DECLARE @Value MONEY = 3.75
DECLARE @InterestRateUser VARCHAR(18) = 'BCAdmin'
DECLARE @Gap INT = 6

DECLARE db_cursor CURSOR FOR
WITH CTE
AS
(
SELECT acctId, IndexRateInterestParent, ROW_NUMBER() OVER(PARTITION BY IndexRateInterestParent ORDER BY DateEffective DESC) [Row]
FROM IndexRate WITH (NOLOCK)
)
SELECT acctId, IndexRateInterestParent FROM CTE WHERE [Row] = 1

OPEN db_cursor
FETCH NEXT FROM db_cursor INTO @acctId, @IndexRateInterestParent

WHILE @@FETCH_STATUS = 0
BEGIN
	INSERT INTO IndexRate
	SELECT @acctId+@Gap, @IndexRateInterestParent, @CurrentTime, @CurrentTime, @Value, @InterestRateUser, 1

	INSERT INTO InterestRateUpdateJob (acctId,RateInterestParent,DateCreated,DateEffective,Value,InterestRateUser,JobStatus,IntType,JobCreationDate)
	SELECT @acctId+@Gap, @IndexRateInterestParent, @CurrentTime, @CurrentTime, @Value, @InterestRateUser, 'New', 'IndexRate', @CurrentTime


	FETCH NEXT FROM db_cursor INTO @acctId, @IndexRateInterestParent
END

CLOSE db_cursor
DEALLOCATE db_cursor
