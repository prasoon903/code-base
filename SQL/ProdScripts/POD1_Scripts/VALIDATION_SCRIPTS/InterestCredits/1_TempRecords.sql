
SELECT SystemStatus, BP.acctID, RTRIM(BP.AccountNumber) AccountNumber, BP.CurrentBalance, CurrentBalanceCO, TT.Amount
FROM BSegment_Primary BP WITH (NOLOCK)
JOIN BSegmentCreditCard BCC WITH (NOLOCK) ON (BP.acctId = BCC.acctId)
JOIN #TempRecords TT ON (BP.UniversalUniqueID = TT.AccountUUID)
WHERE BP.CurrentBalance+CurrentBalanceCO < TT.Amount --AND SystemStatus = 14



SELECT SystemStatus, COUNT(1) RecordCount
FROM BSegment_Primary BP WITH (NOLOCK)
JOIN BSegmentCreditCard BCC WITH (NOLOCK) ON (BP.acctId = BCC.acctId)
JOIN #TempRecords TT ON (BP.UniversalUniqueID = TT.AccountUUID)
WHERE BP.CurrentBalance+CurrentBalanceCO < TT.Amount --AND SystemStatus = 14
GROUP BY SystemStatus


/*
CREATE TABLE #TempRecords (AccountUUID VARCHAR(64), Amount MONEY)
GO
INSERT INTO #TempRecords VALUES
('dbe0bfe8-d7b2-4695-91d0-f830b95b182c',167.45),
('00920c1a-b4bd-4365-9f11-fa76c20ea8d0',145.78),
('586e4f1d-8692-4e77-868d-b3ab64c36461',167.02),
('32640e94-b879-4e39-a4a8-fe689b204c31',5.94),
('3660a9a9-c7e8-411b-8311-6bc9fdc97bfe',0.33),
('52706d05-77c2-4fb0-96d7-ac78d9d7391a',0.69),
('e49b04df-9015-4180-89e6-eb90d2fc7aaf',2.93),
('497c470f-35fb-4a0e-bac9-dd8ad328a451',53.3),
('89e5dc2d-eefc-4588-9e0b-0db6615326ce',299.58),
('df9897e0-460c-48a6-8961-f8e38992566e',109.1),
('9027e90f-d4f3-4b1a-aae7-f27263838238',11.64),
('9c54b412-220f-4efc-8a54-a49466a062e6',206.44),
('264a90aa-7fd5-4185-88b2-bcd442b05996',1.13),
('81ed3775-7f63-4258-a98c-ca7f015ef166',1.44),
('e3536d45-718c-4508-85d6-4508488e157d',0.5),
('c8a3663a-b1e6-4d13-abc6-29f731df535d',1.06),
('84ab11a3-a296-490d-87eb-5dd975d32760',13.64),
('556773d1-398c-4f16-b65b-62d95e103cfe',128.45),
('1af8963f-7096-462f-a0a9-5600830f508c',0.54),
('7ca75058-8b5a-4440-9d66-937bd18cfbab',1.37),
('02724bd7-b51a-414a-9d10-32fd3b1500db',5.12),
('aa178d71-4fb3-49b5-b419-e0329a72cf86',108.26),
('95f1b6ff-a3fa-4464-93bd-ee3d4274b668',14.06),
('9e3706a0-5e67-47b5-96a6-21a9e138b7db',1.03),
('8340cb53-229f-494a-923e-8786cfaee3e0',38.53),
('89176604-7b6b-4127-a8ee-760e99b9354e',2.2),
('9f0359c1-d34d-491e-b09a-5b3a5f6723f7',8.63),
('71f6df11-20ac-4332-9faf-60f30538a8fe',15.48),
('3b713b14-4a4d-4ec5-95e7-8d8214599546',76.78),
('369ff9ba-0ace-486f-b3d5-d99ea5273d7e',0.29),
('3f593fa3-6051-47a4-abba-763668eaf37a',2.61),
('74baa4db-f138-4779-a00e-af7ea12e0cbc',373.85),
('7b5ecd49-37bb-4285-9efd-4f212d6734f8',244.67),
('a11d156f-550b-4c6b-bcd1-65ca80fc4191',212.86),
('53c10a2a-4547-49d3-bfa1-1886eb6da09c',91.01),
('7b6a51c9-3d36-469e-907c-279fe3db90b2',68.44),
('86fdc91f-d05b-4b21-9896-cc22d489b224',64.94),
('c12ff0fd-95dd-4dc7-8fd3-24a7a2d3a272',43.99),
('e20f6167-f049-4182-9093-6e63738ccf3b',40.48),
('dd8a66c5-e600-462c-a2f1-36e3e16efaee',40.34),
('4f1b3147-3c00-493c-b89e-877f05289413',30.77),
('9e7a80e7-1cfe-42e9-a09b-c2dce23e903a',24.41),
('1601f431-bd1d-4c14-88e3-a983d261024f',19.99),
('361a4a4b-5c8f-415e-9c9e-f3dd73a9041f',10.21),
('7dc16ea0-52ea-46b5-9195-f4b38fe61c4f',3.85),
('aee637aa-6988-4f51-8f23-60e0522ad782',0.5),
('71e6d0bb-96d3-46d3-b242-c94b6b274b25',28.04),
('65423ba9-c3cb-48bb-a8a2-aeda6fe961be',3.74),
('024995cc-b105-48bf-bd38-d6eb7ca23c20',1.1),
('a51b4041-77f3-4125-a0c7-57d7ed9054de',173.48),
('b6a9aa09-24bc-4308-880f-f2d0ebedf218',89.85),
('87122e24-4f60-46cb-9177-e5654e1c154f',19.64),
('0b3ef238-ed4a-45d2-8a2b-5c3a3dc33d69',5.68),
('9aa03332-2e84-44f1-b1ac-7893624cd6d7',83.32),
('bfe604df-509f-4528-b8b5-8e4e1acea6ee',176.81),
('26a28104-6b51-41e7-9079-f53f9c49072b',143.82),
('89c4ed1e-2fd1-4791-ba68-ab819a83b6d8',24.7),
('4f33ea2f-7648-497c-83d4-4f3dccf59718',18.95),
('c9c7112e-c111-4074-b5f1-443e47af61d4',566.71),
('52716509-0ba7-42e8-86c1-9e1e760476db',289.22),
('eb125a51-8a17-4b9e-a9a9-8a9a29658bf7',136.54),
('61c0c298-0008-4a05-ac24-d70506d85f91',1.06),
('2d5479c0-ef88-4db7-9879-6f690c96a872',3.37),
('54142e0a-b218-454e-af8a-4b1d3135508d',3.86),
('df8ac26e-f597-48d6-b655-59d55b82e317',41.21),
('7602617c-f494-4458-af03-9a0ec92d4299',473.21),
('e82784ee-9d28-49a3-a95e-358aeeccd7ef',3.37),
('eca03a06-072a-40ba-9659-e8e8bb314a8e',18.43),
('d8e55c3e-0f80-438c-8d5d-885d39cd56b6',72.08),
('957ca368-907e-4606-91f8-464e64736c9b',23.37),
('c84f2ce6-15f4-4930-a212-3712f82baf57',128.02),
('d1260a11-780e-4dc0-8e46-4a5b15af56dc',71.2),
('e2ad503a-13c4-40b8-b9c8-4827ff29951a',153.08),
('f5822540-4094-4359-b1ed-554b4db0dca7',562.69),
('917db0ff-cd28-4004-8007-67d7e35d6ce0',567.98),
('b3fd192f-d35e-4580-8b32-1cdd5641c47c',19.86),
('d3a29453-a4b6-4cd1-8f29-475f1a5d8427',34.99),
('7ecfc634-3afa-45d1-b77c-50b91e22ec35',0.31),
('dd04b959-f4a3-410a-b2ef-47f0eea564e9',13.54),
('cd51b883-982e-4583-8ff1-72ee07570821',93.96),
('c185b2f2-55ca-43f5-93da-45084278fa34',219.82)