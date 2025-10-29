IF NOT EXISTS (SELECT TOP 1 1 FROM SYS.TABLES WHERE NAME = 'MaxExecutionValue')
BEGIN
CREATE TABLE MaxExecutionValue (
    ID INT IDENTITY(1,1),
    Name VARCHAR(50),
    Value INT,
    StepSize INT
    )
INSERT INTO MaxExecutionValue(Name,Value,StepSize)
SELECT 'ExecutionID',2,2

END