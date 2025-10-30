-- Need to execute in coreissue primary     database plat production pod1
Begin  Tran 
--Commit 
--rollback 

--------UPDATE TOP(1) CCard_Primary SET ClientID = 'a842d360-b7b9-41f8-85e9-e60ac2c985a9'  WHERE TranID = 52056995369
--------UPDATE TOP(1) CCard_Primary SET ClientID = 'e5a4143f-508f-4d26-9fb7-5eade9639880'  WHERE TranID = 52673632751
--------UPDATE TOP(1) CCard_Primary SET ClientID = '5265019a-6a97-49cf-9019-142ce142cd67'  WHERE TranID = 54426355870
--------UPDATE TOP(1) CCard_Primary SET ClientID = 'e0b72b58-188d-4cab-9d95-404e03b952e2'  WHERE TranID = 54426355885
--------UPDATE TOP(1) CCard_Primary SET ClientID = '75d3456a-80a1-42d6-b44b-23ac95535353'  WHERE TranID = 54164297225



UPDATE TOP(1) CCard_Primary SET EmbAcctId = 2145206		WHERE TranID = 52056995369  AND AccountNumber = '1100011110366691'
UPDATE TOP(1) CCard_Primary SET EmbAcctId = 22924255	WHERE TranID = 52673632751  AND AccountNumber = '1100011173298823'
UPDATE TOP(1) CCard_Primary SET EmbAcctId = 654179		WHERE TranID = 54164297225  AND AccountNumber = '1100011102912916'
UPDATE TOP(1) CCard_Primary SET EmbAcctId = 15481295	WHERE TranID = 54426355870  AND AccountNumber = '1100011145708065'
UPDATE TOP(1) CCard_Primary SET EmbAcctId = 2193489		WHERE TranID = 54426355885  AND AccountNumber = '1100011110609421'
