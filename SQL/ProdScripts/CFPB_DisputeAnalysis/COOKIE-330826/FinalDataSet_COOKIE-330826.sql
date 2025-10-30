
DROP TABLE IF EXISTS ##TempRawData
CREATE TABLE ##TempRawData (DisputeID VARCHAR(64), DisputeAmount MONEY, AccountUUID VARCHAR(64), px_create_date_time DATETIME, TransactionAmount MONEY, 
TransactionDate DATETIME, ClearingDate DATETIME, PCDate DATETIME, PCAmount MONEY, PCResolvedDate DATETIME)

INSERT INTO ##TempRawData (DisputeID, DisputeAmount, AccountUUID, px_create_date_time, TransactionAmount, TransactionDate, ClearingDate, PCDate, PCAmount, PCResolvedDate) VALUES ('17689648', 1196.54, '275b2f7f-212e-49aa-9591-443c3b33fa83', '2025-05-31', 1196.54, '2021-12-22', NULL, NULL, NULL, '2025-06-02')
INSERT INTO ##TempRawData (DisputeID, DisputeAmount, AccountUUID, px_create_date_time, TransactionAmount, TransactionDate, ClearingDate, PCDate, PCAmount, PCResolvedDate) VALUES ('17749492', 14.9, '81d8f9dd-258e-4a4f-9ecc-60d97d305d16', '2025-06-03', 14.9, '2022-02-17', NULL, NULL, NULL, '2025-06-05')
INSERT INTO ##TempRawData (DisputeID, DisputeAmount, AccountUUID, px_create_date_time, TransactionAmount, TransactionDate, ClearingDate, PCDate, PCAmount, PCResolvedDate) VALUES ('17946309', 76.07, '599acffc-7ac8-48dd-b835-a313dff7a2e0', '2025-06-17', 76.07, '2021-09-21', NULL, NULL, NULL, '2025-06-25')
INSERT INTO ##TempRawData (DisputeID, DisputeAmount, AccountUUID, px_create_date_time, TransactionAmount, TransactionDate, ClearingDate, PCDate, PCAmount, PCResolvedDate) VALUES ('17947318', 45.0, '599acffc-7ac8-48dd-b835-a313dff7a2e0', '2025-06-17', 45.0, '2021-09-30', NULL, NULL, NULL, '2025-06-25')
