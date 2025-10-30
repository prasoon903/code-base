-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreAuth
GO


SELECT DaysDelinquent, DateOfLastDelinquent, SystemStatus, * FROM BSegment_Primary WITH (NOLOCK) WHERE 
acctId IN (1667578)