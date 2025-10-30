/*
Fill the job table for correcting the activity order of the plans
*/

DROP TABLE IF EXISTS TEMP_BadSchedulesCorrection_ActivityOrder
GO

CREATE TABLE TEMP_BadSchedulesCorrection_ActivityOrder
(
	Skey DECIMAL(19,0) IDENTITY(1,1) NOT NULL,
	SkeyOnILP DECIMAL(19,0),
	PlanUUID VARCHAR(64),
	PlanID INT,
	ActivityOrder INT,
	JobStatus INT
)

DROP INDEX IF EXISTS IX_TEMP_BadSchedulesCorrection_ActivityOrder_Skey ON TEMP_BadSchedulesCorrection_ActivityOrder

CREATE CLUSTERED INDEX IX_TEMP_BadSchedulesCorrection_ActivityOrder_Skey ON TEMP_BadSchedulesCorrection_ActivityOrder 
(
	Skey
) 

DROP INDEX IF EXISTS IDX_TEMP_BadSchedulesCorrection_ActivityOrder_JobStatus ON TEMP_BadSchedulesCorrection_ActivityOrder

CREATE NONCLUSTERED INDEX IDX_TEMP_BadSchedulesCorrection_ActivityOrder_JobStatus ON TEMP_BadSchedulesCorrection_ActivityOrder
(
	JobStatus
)

;WITH CTE
AS 
(
	SELECT PlanID
	FROM TEMP_BadSchedulesCorrection TB WITH (NOLOCK)
	GROUP BY PlanID
)
INSERT INTO TEMP_BadSchedulesCorrection_ActivityOrder
SELECT 
	ILPS.Skey, ILPS.PlanUUID, ILPS.PlanID, RANK() OVER(PARTITION BY ILPS.parent02AID, ILPS.PlanID ORDER BY ILPS.ActivityOrder ASC) AS ActivityOrder, 0 AS JobStatus
FROM ILPScheduleDetailSummary ILPS WITH (NOLOCK)
JOIN CTE TT WITH (NOLOCK) ON (ILPS.PlanID = TT.PlanID)