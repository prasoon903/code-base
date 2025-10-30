SELECT CP.acctId, CP.parent02AID, CP.CreditPlanType, CP.Parent01AID, CM.CreditPlanType
, 'UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = ''0'' WHERE acctId = ' + TRY_CAST(CP.acctId AS VARCHAR)
FROM CPSgmentAccounts CP WITH (NOLOCK)
JOIN CPMAccounts CM WITH (NOLOCK) ON (CP.Parent01AID = CM.acctId)
WHERE CP.CreditPlanType = ''

--UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 83259657
--UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 83295792
--UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 81959312
--UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 81190768
--UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 82271542
--UPDATE TOP(1) CCard_Primary SET AccountNumber = '1100011173823067', ClientID = '3ea11168-5310-468b-8334-9976a0b1bab1', TxnAcctID = 17006796, EmbAcctId = 23037222 WHERE TranID = 59375432334
