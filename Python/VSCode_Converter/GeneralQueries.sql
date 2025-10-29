

SELECT * FROM VersionDetails WITH (NOLOCK)

--DROP TABLE VersionDetails
--TRUNCATE TABLE VersionDetails

--DELETE FROM VersionDetails WHERE Skey = 2

INSERT INTO VersionDetails (Project, Environment, Version, TimeStamp) VALUES
('PLAT', 'Production', '15.00.13.02', '2019-12-19'),
('PLAT', 'DEV', '15.00.13.03', '2019-12-18 07:50:00'),
('PLAT', 'QA', '15.00.13.02', '2019-12-05 02:56:00'),
('PLAT', 'PTR', '15.00.13.02', '2019-12-12 04:45:00'),
('PLAT', 'INT', '15.00.10.06', '2019-07-25 04:23:00'),
('PLAT', 'TRN', ' 15.00.08.01', '2019-04-15 04:18:00'),
('PLAT', 'UAT', '15.00.13.01', '2019-11-28 05:07:00'),
('PLAT', 'UATP', '15.00.13.02', '2019-12-13 13:39:00')


INSERT INTO VersionDetails (Project, Environment, Version, TimeStamp) VALUES
('PLAT', 'Production', '15.00.13.01', '2019-12-03'),
('PLAT', 'DEV', '15.00.13.02', '2019-12-05 07:50:00')

INSERT INTO VersionDetails (Project, Environment, Version, TimeStamp) VALUES
('CREDIT', 'Production', '15.00.13.02', '2019-11-26'),
('CREDIT', 'TEST', '15.00.13.02', '2019-11-11')



SELECT TOP 1 Project, Environment, Version, TimeStamp FROM VersionDetails WITH (NOLOCK) 
WHERE Project = 'PLAT' AND Environment = 'DEV' ORDER BY TimeStamp DESC

SELECT Project, Environment, Version, TimeStamp FROM VersionDetails WITH (NOLOCK) WHERE Project = 'PLAT' 
--AND Environment = 'DEV' 
ORDER BY TimeStamp DESC


SELECT CONVERT(VARCHAR, TimeStamp, 23) + ' ' + CONVERT(VARCHAR, TimeStamp, 8) AS TimeStamp FROM VersionDetails WITH (NOLOCK) WHERE Project = 'PLAT' AND Environment = 'DEV'

SELECT Project, Environment 
FROM VersionDetails WITH (NOLOCK)
WHERE Project = 'PLAT'
GROUP BY Project, Environment


SELECT * FROM UserDetails
--TRUNCATE TABLE UserDetails
--DROP TABLE UserDetails

INSERT INTO UserDetails (Project, Username, UserIP, UserAccess, DateAdded) VALUES 
('PLAT', 'Prasoon Parashar', '10.206.2.217', 3, GETDATE()),
('CREDIT', 'Prasoon Parashar', '10.206.2.217', 3, GETDATE())

SELECT UserAccess FROM UserDetails WITH (NOLOCK) WHERE Project = 'PLAT' AND UserIP = '10.206.2.217'

SELECT * FROM VersionDetailsModificationLog
--TRUNCATE TABLE VersionDetailsModificationLog

SELECT COUNT(1) AS Counter FROM DETAIL..VersionDetails WITH (NOLOCK) WHERE Project = 'PLAT' AND Environment = 'DEV' AND Version = '15000001'AND TimeStamp >= '2019-12-23 07:50:00'

SELECT COUNT(1) AS UserID FROM UserDetails WITH (NOLOCK) 
WHERE Project = 'PLAT' AND UserIP = '1223'