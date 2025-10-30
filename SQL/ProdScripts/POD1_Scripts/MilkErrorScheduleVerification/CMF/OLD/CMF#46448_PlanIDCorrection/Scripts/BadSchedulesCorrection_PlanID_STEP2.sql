/*
Fill the job table to move the schedules to Corrected schedules table as well marking them correct in ILPScheduleDetailSummary table
*/
IF EXISTS (SELECT 1 FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'dbo.TEMP_PlanToMove') AND TYPE = 'U') 
BEGIN

	TRUNCATE TABLE TEMP_PlanToMove

	INSERT INTO TEMP_PlanToMove
	SELECT
		 PlanUUID, 0 AS JobStatus
	FROM ILPScheduleDetailsBAD WITH (NOLOCK)
	WHERE JobStatus = 1
	AND PlanUUID IN
	(
	'ee05d6c7-fdb0-418c-873d-eeb9bcdc81d6',
	'7abd7920-0d8e-4f33-8ab7-5d961501620a',
	'0bf8baaf-ece1-4431-a6f5-17c3080c4a57',
	'9501cfee-7847-44fc-8c02-06951f5dc664',
	'626a51db-b901-454a-8a9a-7d15c91d2566',
	'469a5a08-a8b4-467e-80b5-ca8aa2250aaf',
	'2c37a023-ef60-443b-8963-c07c6720b1b0',
	'db88a07d-97f3-4614-8d08-8f5d34b31651',
	'8fa507c1-bc45-4e1e-bb0b-7017bc03810a',
	'33645d61-28db-43f5-a2c9-c87f19598c40',
	'84a20f94-5b51-41b0-b607-121ac44179c9',
	'5100d2c9-e64d-4862-adb9-446ebe22dd97',
	'958cd9af-d8d3-4bc6-92e2-c12a5f7487c9',
	'5bc103fe-0b15-4850-864b-e2474661ee05',
	'79efb239-cd23-4eeb-a288-8537afcaaa1a',
	'50b8d3f4-6f89-4b43-8ac0-56e00626e6b1',
	'd8aec6f0-b42c-4cd1-802e-02b7d63c52c9',
	'7bc064b6-6341-4e3e-9724-d42e5cd54a46',
	'e2265052-56b8-4fe6-84a4-ecd4bd8939e4',
	'db31cc1c-43ac-451d-a1ae-f9ef82e1ea75',
	'0d2dc18f-e390-487b-9a89-ca56bcb0d144',
	'85377b54-8010-41d7-96b4-6bfecb7b077f'
	)
	GROUP BY PlanUUID

END
ELSE
BEGIN 
	PRINT 'TEMP_PlanToMove table does not exist, please execute the Supporting table script.'
END