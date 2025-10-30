

SELECT BP.acctID, AccountNumber, UniversalUniqueID, ccinhparent125AID, SystemStatus, ManualInitialChargeOffReason, ChargeOffDateParam
FROM BSegment_Primary BP WITH (NOLOCK) 
JOIN BSegmentCreditCard BC WITH (NOLOCK) ON (BP.acctID = BC.acctID)
WHERE BP.acctID IN (446036,489655,2251218,2811762,8266735,11162416,113113371,17736591)

SELECT BP.acctID, AccountNumber, UniversalUniqueID, ccinhparent125AID, SystemStatus, ManualInitialChargeOffReason, ChargeOffDateParam
FROM BSegment_Primary BP WITH (NOLOCK) 
JOIN BSegmentCreditCard BC WITH (NOLOCK) ON (BP.acctID = BC.acctID)
WHERE BP.acctID IN (17304137, 21776320)

--acctID	AccountNumber	UniversalUniqueID	ccinhparent125AID	SystemStatus	ManualInitialChargeOffReason	ChargeOffDateParam
--446036	1100011104418490   	4e3da579-d4bd-4da9-97fc-f87fae452159	5211	2	NULL	2023-02-28 23:59:55.000
--489655	1100011104854686   	db308f50-97df-4d28-aeeb-3b8b10e02ba9	5211	2	NULL	2023-02-28 23:59:55.000
--2251218	1100011122461969   	b2dc1a9c-4ca7-44ca-b013-80c9a06019e0	5211	2	NULL	2022-05-31 23:59:55.000
--2811762	1100011128249871   	c1c591f3-cdf0-4c67-8655-b48a1f959f27	5211	2	NULL	2022-05-31 23:59:55.000 -----------------------------------------------need to check
--8266735	1100011142868631   	072ea922-bf26-4465-b37a-ae0a680d4634	16022	15991	3    	2024-02-29 23:59:55.000
--11162416	1100011148501350   	51586a8e-f36c-4137-a2e5-93641633477e	5211	2	NULL	2022-08-31 23:59:55.000
--17736591	1100011179076710   	a7bb7929-90b0-4645-bae4-d3fc4411e868	5211	2	NULL	2022-08-31 23:59:55.000


--acctID	AccountNumber	UniversalUniqueID	ccinhparent125AID	SystemStatus	ManualInitialChargeOffReason	ChargeOffDateParam
--17304137	1100011175262694   	6c59e970-a4ff-460f-b982-5ac2173924b3	5211	2	NULL	NULL
--21776320	1100011204260149   	580fbc34-b509-4d2b-8d40-87d936f4b593	5211	15991	NULL	NULL

SELECT CMTTranType, TranTime, PostTime, FeesAcctID, CPMGroup, TransactionDescription, TransactionIdentifier
FROM CCArd_Primary WITH (NOLOCK)
WHERE AccountNumber = '1100011204260149'
AND CMTTranType IN ('*SCR','51', '52', '54', 'RCLS')
ORDER BY postTime DESC