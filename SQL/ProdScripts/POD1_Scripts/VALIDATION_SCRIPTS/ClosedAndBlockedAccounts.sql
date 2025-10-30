
SELECT UniversalUniqueID,acctId, 
RTRIM(AccountNumber) AccountNumber
--, 16024 Status
, SystemStatus, ccinhparent125AID 
FROM BSegment_Primary WITH (NOLOCK)
WHERE UniversalUniqueID IN
('dd04b959-f4a3-410a-b2ef-47f0eea564e9',
'd1260a11-780e-4dc0-8e46-4a5b15af56dc',
'c84f2ce6-15f4-4930-a212-3712f82baf57',
'ad0e3591-fbdd-48b8-b1be-dd11296edd5c',
'6a4a9f86-8213-4da9-9a6e-cbaba16070f6',
'cd51b883-982e-4583-8ff1-72ee07570821',
'f5822540-4094-4359-b1ed-554b4db0dca7',
'd8e55c3e-0f80-438c-8d5d-885d39cd56b6',
'28ad85cb-ccf3-4f6b-9cee-9054b7f4b720',
'a475ff2d-8085-47f5-ace7-3ab81ee06691',
'54142e0a-b218-454e-af8a-4b1d3135508d',
'f6a8d632-d916-442b-9b4c-b2737bf7f68b',
'8617c596-4e58-48fb-8357-3cda072596d6',
'e2ad503a-13c4-40b8-b9c8-4827ff29951a',
'c9c7112e-c111-4074-b5f1-443e47af61d4',
'52716509-0ba7-42e8-86c1-9e1e760476db',
'c185b2f2-55ca-43f5-93da-45084278fa34',
'89c4ed1e-2fd1-4791-ba68-ab819a83b6d8',
'26a28104-6b51-41e7-9079-f53f9c49072b',
'df8ac26e-f597-48d6-b655-59d55b82e317',
'4f33ea2f-7648-497c-83d4-4f3dccf59718')
--AND ccinhparent125AID = 16026
--AND ccinhparent125AID <> 16032
AND ccinhparent125AID = 16032




SELECT ccinhparent125AID, COUNT(1) RecorCount FROM BSegment_Primary WITH (NOLOCK)
WHERE UniversalUniqueID IN
('dd04b959-f4a3-410a-b2ef-47f0eea564e9',
'd1260a11-780e-4dc0-8e46-4a5b15af56dc',
'c84f2ce6-15f4-4930-a212-3712f82baf57',
'ad0e3591-fbdd-48b8-b1be-dd11296edd5c',
'6a4a9f86-8213-4da9-9a6e-cbaba16070f6',
'cd51b883-982e-4583-8ff1-72ee07570821',
'f5822540-4094-4359-b1ed-554b4db0dca7',
'd8e55c3e-0f80-438c-8d5d-885d39cd56b6',
'28ad85cb-ccf3-4f6b-9cee-9054b7f4b720',
'a475ff2d-8085-47f5-ace7-3ab81ee06691',
'54142e0a-b218-454e-af8a-4b1d3135508d',
'f6a8d632-d916-442b-9b4c-b2737bf7f68b',
'8617c596-4e58-48fb-8357-3cda072596d6',
'e2ad503a-13c4-40b8-b9c8-4827ff29951a',
'c9c7112e-c111-4074-b5f1-443e47af61d4',
'52716509-0ba7-42e8-86c1-9e1e760476db',
'c185b2f2-55ca-43f5-93da-45084278fa34',
'89c4ed1e-2fd1-4791-ba68-ab819a83b6d8',
'26a28104-6b51-41e7-9079-f53f9c49072b',
'df8ac26e-f597-48d6-b655-59d55b82e317',
'4f33ea2f-7648-497c-83d4-4f3dccf59718')
GROUP BY ccinhparent125AID



SELECT A.Parent01AID,A.StatusDescription, A.Priority
FROM AStatusAccounts A WITH (NOLOCK)
JOIN CCardLookUp C WITH (NOLOCK) ON (A.parent01AID = C.LutCode)
WHERE C.LUTid = 'AsstPlan' AND C.LutLanguage = 'dbb' AND A.MerchantAID = 14992 AND A.Parent01AID IN (2, 16024,16026,16032,16094)
ORDER BY A.Priority