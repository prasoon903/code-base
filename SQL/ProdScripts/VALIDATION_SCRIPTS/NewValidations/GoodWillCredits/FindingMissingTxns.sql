SELECT * FROm LS_PRODDRGSDB01.ccgs_coreauth.dbo.CoreAuthTransactions WITH (NOLOCK) WHERE TransactionUUID IN

('cbd2cd4e-d752-4565-8fa5-16e98617637e',
'00adce36-da19-44ff-a2b5-bda765bbfd7f',
'f54b5629-b6a2-4e31-a5c9-2f3629a93d7a',
'1ac06b74-bf3a-4378-b643-4f0e8b99245b',
'fe1ef685-b446-4b6a-9769-57d65c4405bd',
'd17f9d72-94b3-49d5-a335-ffaf9d76c317',
'f670ea23-acbc-42e5-ad6e-a502b32803a0',
'96aceb1d-b78c-4c54-be52-59328495039d',
'5a937111-b32b-44a9-88fd-2bec93f3990f',
'b3cf398e-f5f3-4187-b38c-159eba98957f',
'8e336c84-1867-44df-8932-405ca429dad4',
'6e4ed0b9-294e-4398-9e15-fbf083f8fe2b',
'2c600a18-ddc5-4a97-8386-df4a2d924cc4',
'530f8555-adc1-428f-bd87-0eb683270ea7',
'8167179b-0511-4052-9bbb-62636ca6033a',
'd02b02e3-9d00-4c49-aa3e-13c78d0be013',
'bdc9e8ca-801f-42f5-a1cf-c6af1f58a3a2',
'1e7bd3c1-f39e-4aed-a7ed-8df27bbe2ef2')


SELECT * FROm Auth_Primary WITH (NOLOCK) WHERE TransactionUUID IN

('cbd2cd4e-d752-4565-8fa5-16e98617637e',
'00adce36-da19-44ff-a2b5-bda765bbfd7f',
'f54b5629-b6a2-4e31-a5c9-2f3629a93d7a',
'1ac06b74-bf3a-4378-b643-4f0e8b99245b',
'fe1ef685-b446-4b6a-9769-57d65c4405bd',
'd17f9d72-94b3-49d5-a335-ffaf9d76c317',
'f670ea23-acbc-42e5-ad6e-a502b32803a0',
'96aceb1d-b78c-4c54-be52-59328495039d',
'5a937111-b32b-44a9-88fd-2bec93f3990f',
'b3cf398e-f5f3-4187-b38c-159eba98957f',
'8e336c84-1867-44df-8932-405ca429dad4',
'6e4ed0b9-294e-4398-9e15-fbf083f8fe2b',
'2c600a18-ddc5-4a97-8386-df4a2d924cc4',
'530f8555-adc1-428f-bd87-0eb683270ea7',
'8167179b-0511-4052-9bbb-62636ca6033a',
'd02b02e3-9d00-4c49-aa3e-13c78d0be013',
'bdc9e8ca-801f-42f5-a1cf-c6af1f58a3a2',
'1e7bd3c1-f39e-4aed-a7ed-8df27bbe2ef2')



SELECT * FROm CCard_Primary WITH (NOLOCK) WHERE UniversalUniqueId IN

('cbd2cd4e-d752-4565-8fa5-16e98617637e',
'00adce36-da19-44ff-a2b5-bda765bbfd7f',
'f54b5629-b6a2-4e31-a5c9-2f3629a93d7a',
'1ac06b74-bf3a-4378-b643-4f0e8b99245b',
'fe1ef685-b446-4b6a-9769-57d65c4405bd',
'd17f9d72-94b3-49d5-a335-ffaf9d76c317',
'f670ea23-acbc-42e5-ad6e-a502b32803a0',
'96aceb1d-b78c-4c54-be52-59328495039d',
'5a937111-b32b-44a9-88fd-2bec93f3990f',
'b3cf398e-f5f3-4187-b38c-159eba98957f',
'8e336c84-1867-44df-8932-405ca429dad4',
'6e4ed0b9-294e-4398-9e15-fbf083f8fe2b',
'2c600a18-ddc5-4a97-8386-df4a2d924cc4',
'530f8555-adc1-428f-bd87-0eb683270ea7',
'8167179b-0511-4052-9bbb-62636ca6033a',
'd02b02e3-9d00-4c49-aa3e-13c78d0be013',
'bdc9e8ca-801f-42f5-a1cf-c6af1f58a3a2',
'1e7bd3c1-f39e-4aed-a7ed-8df27bbe2ef2')
AND CMTTranType = '40'

SELECT * 
FROM ##TempRecords t
JOIN CCard_Primary C ON (t.TransactionLifeCycleUUID = c.UniversalUniqueId)
WHERE c.CMTTRANTYPE = '40'