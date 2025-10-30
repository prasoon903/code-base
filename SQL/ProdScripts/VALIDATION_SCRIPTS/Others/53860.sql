; WITH MaxLastTermDate
AS
(SELECT MAX(LastTermDate) LastTermDate, PlanID FROM ILPScheduleDetailSummary WITH (NOLOCK) GROUP BY PlanID)
, LatestLastTermDate
AS
(SELECT RANK() OVER (PARTITION BY PlanID ORDER BY ActivityOrder DESC) RankSchedule, PlanID, LastTermDate, LoanDate, Activity FROM ILPScheduleDetailSummary WITH (NOLOCK))
SELECT *
FROM LatestLastTermDate C1
JOIN MaxLastTermDate C2 ON (C1.PlanID = C2.PlanID AND C1.RankSchedule = 1)
WHERE C1.LastTermDate < C2.LastTermDate
--ORDER BY LoanDate DESC