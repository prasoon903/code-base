DROP TABLE IF EXISTS #TempCSV
CREATE TABLE #TempCSV(Skey int,PlanUUID varchar(64),Activity int)

INSERT INTO #TempCSV VALUES
(1,'4adb5a9d-7558-4a7d-a7aa-a2cff0426ff9',2),
(2,'ccab02bb-bb98-4a60-9eeb-810977c04198',4),
(3,'eb7e5651-469c-46ed-841b-523ac36b7f89',1),
(4,'905d2d49-2918-4d30-a32f-1897ef7d47f8',3),
(5,'72bb7213-0f3d-4927-8b79-a49778449df3',1),
(6,'dfc04cb1-2e14-495e-a709-635d5870ac4f',3),
(7,'5a47c214-7564-4021-ba6c-6203c6e3e93d',3),
(8,'8375c5c9-400b-4b1f-b2ba-505595e02784',2),
(9,'a4a3265d-72d0-466f-957f-f9f58524fbf9',1),
(10,'4904b13d-41fb-4664-a981-26ed8b2e90ec',3),
(11,'b6f3439f-3cc6-4115-9c75-771c0a1a0caa',1),
(12,'6561fe3e-579e-4b06-b64a-dc3e1f7f02bd',6),
(13,'d15ef523-1676-4329-9c42-7f8880f43f74',4),
(14,'a24d437c-184e-4230-ad12-fcc0eff56229',4),
(15,'baeb7629-3c5c-4e9a-b4c0-9ef6880e8475',3),
(16,'df9a9759-4709-4b7f-a31c-55dbb7a57d54',2),
(17,'0c481809-834d-4ffa-961b-99df2247f43d',1),
(18,'4db155d7-e545-482a-bc1b-a53fcf9a896d',2),
(19,'4c50b8f4-1035-43d5-8576-5d5931175e47',2),
(20,'0ffd19c8-22e7-4198-9374-6e79915e0eba',1),
(21,'f3429769-8b9d-4d92-9b18-4f1c9f38aab2',3),
(22,'288dae74-9520-4525-b759-01fa4ce06ca6',2),
(23,'8a55cb97-3fc2-445c-8892-1ff84b7120ea',2),
(24,'fa217e5a-7c5f-4e15-9623-5cf3ad35d700',2),
(25,'3092f897-a617-4d89-9ccd-346e71b9766c',3),
(26,'ffd9a48b-0b3e-4c5c-b9b8-485ca39b897e',1),
(27,'038c0aa4-3192-4318-a0f9-76474d67aaa5',2),
(28,'dfc04cb1-2e14-495e-a709-635d5870ac4f',2),
(29,'81143e03-aa1c-47ce-b5cd-0f50a17bcc59',3),
(30,'4c2c27a1-13c0-4a89-a7a2-715d3ad95df2',4),
(31,'a11631d8-d472-451a-9fb6-a49fac1b9f66',6),
(32,'efa20f20-dac8-4a56-924a-c538033c1576',3),
(33,'5a47c214-7564-4021-ba6c-6203c6e3e93d',4),
(34,'5976336f-7ef5-4802-9691-24aa498ab844',2),
(35,'7caca357-1ca3-4f71-bc94-71d5b5364985',3),
(36,'4adb5a9d-7558-4a7d-a7aa-a2cff0426ff9',3),
(37,'be68b52e-c839-4330-8e6d-4ed9743a4ba6',6),
(38,'288dae74-9520-4525-b759-01fa4ce06ca6',3),
(39,'f5ff05ff-98a5-4db1-9550-5d1942b62faf',3),
(40,'217dab8b-f7ce-4b9f-a5b1-5449f18b9b68',2),
(41,'d61e0dd7-23b2-4d88-9833-dfc0b9c4aed5',2),
(42,'87a5be85-839e-442a-ab1e-317fbe58e878',4),
(43,'72bb7213-0f3d-4927-8b79-a49778449df3',2),
(44,'b9ff89a6-54b0-46be-951f-9b351be0ed61',3),
(45,'4904b13d-41fb-4664-a981-26ed8b2e90ec',4),
(46,'6076a29b-8a40-4b64-81a6-7e73c1f2f73d',3),
(47,'b9ff89a6-54b0-46be-951f-9b351be0ed61',4),
(48,'7caca357-1ca3-4f71-bc94-71d5b5364985',2),
(49,'886605a7-8c94-4a4b-9ecf-fdfc17bf0609',2),
(50,'f823a899-988e-4eb5-9636-0f8b110c8a63',3),
(51,'b1dcd72d-76be-4147-96e0-0344686c6d66',2),
(52,'ccab02bb-bb98-4a60-9eeb-810977c04198',3),
(53,'baeb7629-3c5c-4e9a-b4c0-9ef6880e8475',4),
(54,'22ae93bb-00e9-47e3-99e5-55e807041cf2',2),
(55,'1d392ea8-fcd2-4a9e-8efc-b24335206626',3),
(56,'5a6af6df-3b8c-4f08-a14e-e290e6fa85b6',2),
(57,'4c2c27a1-13c0-4a89-a7a2-715d3ad95df2',3),
(58,'9dee2ecf-61a2-45b7-930e-080ba1c9b8f3',2),
(59,'9436b65c-4f8e-40f1-9007-bd12eb4618cf',3),
(60,'1275623e-514c-4f94-a405-f3492ac1bc13',3),
(61,'288dae74-9520-4525-b759-01fa4ce06ca6',1),
(62,'d61e0dd7-23b2-4d88-9833-dfc0b9c4aed5',1),
(63,'038c0aa4-3192-4318-a0f9-76474d67aaa5',3),
(64,'3ad7f2ca-747b-4cb8-bba5-ef8a5bc5224d',3),
(65,'a4485bf6-4133-4b4c-bb6f-9611e74a255b',2),
(66,'eb7e5651-469c-46ed-841b-523ac36b7f89',2),
(67,'4c659fa8-bc69-4807-94c5-127cdb23ce5f',3),
(68,'5062e9af-8a90-4d66-8d17-589a4c1417dc',6),
(69,'288dae74-9520-4525-b759-01fa4ce06ca6',4),
(70,'b6f3439f-3cc6-4115-9c75-771c0a1a0caa',2),
(71,'44e2aba8-0f8d-48c1-910c-50d94405d2d4',2),
(72,'f857dbd1-69f7-4c78-8c6d-5a2ea1178e47',2),
(73,'eb7e5651-469c-46ed-841b-523ac36b7f89',3),
(74,'0282b77b-bbe0-4b51-bfb6-cb3a6411bb96',1),
(75,'fd285a2b-5367-46a6-8845-7e5963e6917a',2),
(76,'a4485bf6-4133-4b4c-bb6f-9611e74a255b',3),
(77,'ffd9a48b-0b3e-4c5c-b9b8-485ca39b897e',2),
(78,'3e6f3db1-ec1b-45f4-be3a-fdaa733e8806',3),
(79,'905d2d49-2918-4d30-a32f-1897ef7d47f8',4),
(80,'4f16a5e4-adee-4820-b83a-6bc7a0d1c2e2',3),
(81,'c16a497f-9ef1-48f7-a1c7-a70a286aee40',3)


;WITH HighestActivity
AS
(
	SELECT ILPS.Skey,ILPS.PlanUUID, ILPS.Activity, RANK() OVER(PARTITION BY ILPS.PlanUUID ORDER BY ILPS.Activity DESC) AS Ranking  FROM #TempCSV ILPS
)
--SELECT * FROM HighestActivity ORDER BY PlanUUID
, CTE
AS
(
	SELECT ILPS.Skey,ILPS.PlanUUID, ILPS.Activity, RANK() OVER(PARTITION BY ILPS.PlanUUID, ILPS.Activity ORDER BY ILPS.Skey DESC) AS Ranking  FROM HighestActivity ILPS
	WHERE Ranking = 1
)
--SELECT * FROM CTE ORDER BY PlanUUID
,ILPSDetails
AS
(
	SELECT TT.Skey, ILPS.PlanUUID, ILPS.ActivityAmount, ILPS.OriginalLoanAmount, ILPS.CurrentBalance, TT.Activity AS ActivityReported, ILPS.ActivityOrder AS ActivityOrder,
	CASE WHEN TC.Activity >= ILPS.ActivityOrder THEN 'YES' ELSE 'NO' END AS ActivityToInclude
	FROM LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.ILPScheduleDetailSummary AS ILPS WITH (NOLOCK)
	JOIN #TempCSV TT ON (ILPS.PlanUUID = TT.PlanUUID)
	LEFT JOIN CTE TC ON (TT.PlanUUID = TC.PlanUUID)
	WHERE TC.Ranking = 1
)
--SELECT * FROM ILPSDetails
----WHERE ActivityToInclude = 'YES'
----GROUP BY Skey
--ORDER BY Skey
,
GroupingDetails
AS
(
	SELECT Skey,PlanUUID, SUM(ActivityAmount) AS ActivityAmount, ActivityReported, OriginalLoanAmount
	FROM ILPSDetails ILP
	WHERE ActivityToInclude = 'YES' AND ActivityOrder <= ActivityReported
	GROUP BY Skey, PlanUUID, ActivityReported, OriginalLoanAmount
)
--SELECT * FROM GroupingDetails ORDER BY PlanUUID, ActivityReported

SELECT ILPS.PlanUUID, GD.ActivityAmount AS TotalActivityAmount, GD.OriginalLoanAmount, ILPS.CurrentBalance, 
GD.ActivityAmount + ILPS.CurrentBalance - GD.OriginalLoanAmount AS Diff, ILPS.Activity AS ActivityReported, LTRIM(RTRIM(CL.LutDescription)) AS ActivityDescription 
FROM GroupingDetails GD
JOIN LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.ILPScheduleDetailSummary ILPS ON (ILPS.PlanUUID = GD.PlanUUID AND ILPS.ActivityOrder = GD.ActivityReported)
LEFT OUTER JOIN LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.CCardLookUp AS CL WITH (NOLOCK) ON (CAST(ILPS.Activity AS VARCHAR) = CL.LutCode)
WHERE CL.LUTid = 'EPPReasonCode'
ORDER BY GD.Skey



