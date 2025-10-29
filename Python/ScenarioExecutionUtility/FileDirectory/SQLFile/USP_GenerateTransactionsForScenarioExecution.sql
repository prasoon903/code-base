DROP PROCEDURE IF EXISTS USP_GenerateTransactionsForScenarioExecution
GO
CREATE PROCEDURE USP_GenerateTransactionsForScenarioExecution(@AccountNumber VARCHAR(19), @FileName VARCHAR(200))
AS
BEGIN
	UPDATE ScenarioExecution SET AccountNumber = @AccountNumber, FileName = @FileName, JobStatus = 'NEW' WHERE JobStatus IS NULL

	UPDATE SE
	SET TransactionAPI = CASE 
							WHEN SE.LogicModule IN ('40', '41', '42', '43', '48', '49', '03', '21', '22', '23', '26', '52', '54') THEN 'CLEARING'
							WHEN SE.LogicModule IN ('110') THEN 'INITIATE DISPUTE'
							WHEN SE.LogicModule IN ('111', '113', '114', '117', '116', '115', '118', '119', '120', '1111', '1131', '1133') THEN 'RESOLVE DISPUTE'
							ELSE 'NA'
						END
	FROM ScenarioExecution SE 
	WHERE JobStatus = 'NEW' AND FileName = @FileName

	SELECT COUNT(1) AS TotalRecords FROM ScenarioExecution WITH (NOLOCK) WHERE JobStatus = 'NEW' AND FileName = @FileName

END