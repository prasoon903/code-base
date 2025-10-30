DROP TABLE IF EXISTS ##TempRawData
CREATE TABLE ##TempRawData (DisputeID VARCHAR(64), DisputeAmount MONEY, AccountUUID VARCHAR(64), px_create_date_time DATETIME, TransactionAmount MONEY, 
TransactionDate DATETIME, ClearingDate DATETIME, PCDate DATETIME, PCAmount MONEY, PCResolvedDate DATETIME)

INSERT INTO ##TempRawData (AccountUUID, DisputeAmount, ClearingDate, PCDate, PCAmount, PCResolvedDate) VALUES ('b27de62d-cb0f-43e9-ad2b-4f412e517660', 74, '2021-12-07', NULL, NULL, NULL)
INSERT INTO ##TempRawData (AccountUUID, DisputeAmount, ClearingDate, PCDate, PCAmount, PCResolvedDate) VALUES ('b27de62d-cb0f-43e9-ad2b-4f412e517660', 82, '2022-01-07', NULL, NULL, NULL)
INSERT INTO ##TempRawData (AccountUUID, DisputeAmount, ClearingDate, PCDate, PCAmount, PCResolvedDate) VALUES ('b27de62d-cb0f-43e9-ad2b-4f412e517660', 78, '2022-02-08', NULL, NULL, NULL)
INSERT INTO ##TempRawData (AccountUUID, DisputeAmount, ClearingDate, PCDate, PCAmount, PCResolvedDate) VALUES ('b27de62d-cb0f-43e9-ad2b-4f412e517660', 78, '2022-03-06', NULL, NULL, NULL)
INSERT INTO ##TempRawData (AccountUUID, DisputeAmount, ClearingDate, PCDate, PCAmount, PCResolvedDate) VALUES ('b27de62d-cb0f-43e9-ad2b-4f412e517660', 78, '2022-04-08', NULL, NULL, NULL)
INSERT INTO ##TempRawData (AccountUUID, DisputeAmount, ClearingDate, PCDate, PCAmount, PCResolvedDate) VALUES ('b27de62d-cb0f-43e9-ad2b-4f412e517660', 78, '2022-06-03', NULL, NULL, NULL)
INSERT INTO ##TempRawData (AccountUUID, DisputeAmount, ClearingDate, PCDate, PCAmount, PCResolvedDate) VALUES ('b27de62d-cb0f-43e9-ad2b-4f412e517660', 78, '2022-07-06', NULL, NULL, NULL)
INSERT INTO ##TempRawData (AccountUUID, DisputeAmount, ClearingDate, PCDate, PCAmount, PCResolvedDate) VALUES ('b27de62d-cb0f-43e9-ad2b-4f412e517660', 78, '2022-08-09', NULL, NULL, NULL)
INSERT INTO ##TempRawData (AccountUUID, DisputeAmount, ClearingDate, PCDate, PCAmount, PCResolvedDate) VALUES ('b27de62d-cb0f-43e9-ad2b-4f412e517660', 78, '2022-09-08', NULL, NULL, NULL)
