
--DROP TABLE IF EXISTS ##TempRawData
--CREATE TABLE ##TempRawData (AccountUUID VARCHAR(64), ClientID VARCHAR(64), ClearingDate DATETIME, DisputeAmount MONEY)

DROP TABLE IF EXISTS ##TempRawData
CREATE TABLE ##TempRawData (DisputeID VARCHAR(64), DisputeAmount MONEY, AccountUUID VARCHAR(64), ClientID VARCHAR(64), px_create_date_time DATETIME, TransactionAmount MONEY, 
TransactionDate DATETIME, ClearingDate DATETIME, PCDate DATETIME, PCAmount MONEY, PCResolvedDate DATETIME)

--SELECT COUNT(1) FROM ##TempRawData
--SELECT COUNT(DISTINCT AccountUUID) FROM ##TempRawData



INSERT INTO ##TempRawData (AccountUUID, ClientID, ClearingDate, DisputeAmount) VALUES ('b27de62d-cb0f-43e9-ad2b-4f412e517660', '381887f1-59e1-4b58-9516-2983ca5c5fd1', '2021-12-07', 74.0)
INSERT INTO ##TempRawData (AccountUUID, ClientID, ClearingDate, DisputeAmount) VALUES ('b27de62d-cb0f-43e9-ad2b-4f412e517660', '381887f1-59e1-4b58-9516-2983ca5c5fd1', '2022-01-07', 82.0)
INSERT INTO ##TempRawData (AccountUUID, ClientID, ClearingDate, DisputeAmount) VALUES ('b27de62d-cb0f-43e9-ad2b-4f412e517660', '381887f1-59e1-4b58-9516-2983ca5c5fd1', '2022-02-08', 78.0)
INSERT INTO ##TempRawData (AccountUUID, ClientID, ClearingDate, DisputeAmount) VALUES ('b27de62d-cb0f-43e9-ad2b-4f412e517660', '381887f1-59e1-4b58-9516-2983ca5c5fd1', '2022-03-06', 78.0)
INSERT INTO ##TempRawData (AccountUUID, ClientID, ClearingDate, DisputeAmount) VALUES ('b27de62d-cb0f-43e9-ad2b-4f412e517660', '381887f1-59e1-4b58-9516-2983ca5c5fd1', '2022-04-08', 78.0)
INSERT INTO ##TempRawData (AccountUUID, ClientID, ClearingDate, DisputeAmount) VALUES ('b27de62d-cb0f-43e9-ad2b-4f412e517660', '381887f1-59e1-4b58-9516-2983ca5c5fd1', '2022-06-03', 78.0)
INSERT INTO ##TempRawData (AccountUUID, ClientID, ClearingDate, DisputeAmount) VALUES ('b27de62d-cb0f-43e9-ad2b-4f412e517660', '381887f1-59e1-4b58-9516-2983ca5c5fd1', '2022-07-06', 78.0)
INSERT INTO ##TempRawData (AccountUUID, ClientID, ClearingDate, DisputeAmount) VALUES ('b27de62d-cb0f-43e9-ad2b-4f412e517660', '381887f1-59e1-4b58-9516-2983ca5c5fd1', '2022-08-09', 78.0)
INSERT INTO ##TempRawData (AccountUUID, ClientID, ClearingDate, DisputeAmount) VALUES ('b27de62d-cb0f-43e9-ad2b-4f412e517660', '381887f1-59e1-4b58-9516-2983ca5c5fd1', '2022-09-08', 78.0)
INSERT INTO ##TempRawData (AccountUUID, ClientID, ClearingDate, DisputeAmount) VALUES ('04c54fa0-e410-4f72-a8b0-346647225077', 'e9bdf780-f3b4-4165-87aa-0d2a5a278c39', '2021-09-04', 329.7)
INSERT INTO ##TempRawData (AccountUUID, ClientID, ClearingDate, DisputeAmount) VALUES ('167b8715-cb7d-43a1-8dc9-69b4d8d90552', '0a71366b-b278-46a0-b1fd-abc19f989691', '2021-05-15', 210.49)
INSERT INTO ##TempRawData (AccountUUID, ClientID, ClearingDate, DisputeAmount) VALUES ('1cac3d42-15c8-4080-9c26-c6ec34134855', '142a0ae2-f5a3-4ea5-922b-1e89e2cf01a9', '2020-07-29', 3890.0)
INSERT INTO ##TempRawData (AccountUUID, ClientID, ClearingDate, DisputeAmount) VALUES ('b3874db1-fe5b-4751-bd36-fbd626f87bd8', 'ee4c61b0-7284-42ca-b7e5-da55b7048cab', '2022-12-30', 29.67)
INSERT INTO ##TempRawData (AccountUUID, ClientID, ClearingDate, DisputeAmount) VALUES ('80e0a3fc-8d91-4782-8d31-17869ca35d95', 'deae8405-f071-4e59-9114-55d299fa7c6c', '2022-04-29', 130.0)
INSERT INTO ##TempRawData (AccountUUID, ClientID, ClearingDate, DisputeAmount) VALUES ('9dfa9efe-0c7b-420f-ad1a-0e9691b234fc', '3aad5cc1-a118-466b-b24a-bfc00b6f38b0', '2024-03-10', 4772.92)
INSERT INTO ##TempRawData (AccountUUID, ClientID, ClearingDate, DisputeAmount) VALUES ('a6870ff2-029a-4fe3-9f10-09941133c313', 'ba7f5f7b-d158-4d25-8d49-54eb25b49994', '2021-12-23', 2152.45)


