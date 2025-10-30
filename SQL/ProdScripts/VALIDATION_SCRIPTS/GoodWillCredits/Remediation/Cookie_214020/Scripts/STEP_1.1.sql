
--DROP TABLE IF EXISTS TransactionCreationTempData
--CREATE TABLE TransactionCreationTempData (SN INT IDENTITY(1, 1), TxnAcctId INT, AccountNumber VARCHAR(19), TransactionAmount MONEY, CMTTranType VARCHAR(10), ActualTranCode VARCHAR(20), TranTime DATETIME, JobStatus INT DEFAULT(0))

BEGIN TRANSACTION
--COMMIT TRANSACTION
--ROLLBACK TRANSACTION



--1 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2148396, '1100011121437648', 200.00, '49', '4907', '2019-09-14 00:00:00')
--1 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (4133235, '1100011133544639', 7.99, '49', '4907', '2020-02-05 00:00:00')
--2 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2148396, '1100011121437648', 0.99, '49', '4907', '2019-09-15 00:00:00')
--2 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (4133235, '1100011133544639', 1.29, '49', '4907', '2020-02-07 00:00:00')
--3 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2148396, '1100011121437648', 188.99, '49', '4907', '2019-10-01 00:00:00')
--3 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (4133235, '1100011133544639', 2.58, '49', '4907', '2020-02-07 00:00:00')
--4 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2148396, '1100011121437648', 128.98, '49', '4907', '2019-10-03 00:00:00')
--4 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (4133235, '1100011133544639', 24.44, '49', '4907', '2020-02-09 00:00:00')
--5 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2148396, '1100011121437648', 22.40, '49', '4907', '2019-10-05 00:00:00')
--5 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (4133235, '1100011133544639', 11.19, '49', '4907', '2020-02-09 00:00:00')
--6 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2148396, '1100011121437648', 51.07, '49', '4907', '2019-10-05 00:00:00')
--6 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (4133235, '1100011133544639', 5.00, '49', '4907', '2020-02-09 00:00:00')
--7 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2148396, '1100011121437648', 135.83, '49', '4907', '2019-10-06 00:00:00')
--7 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (4133235, '1100011133544639', 37.23, '49', '4907', '2020-02-15 00:00:00')
--8 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2148396, '1100011121437648', 52.44, '49', '4907', '2019-10-06 00:00:00')
--8 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (4133235, '1100011133544639', 51.08, '49', '4907', '2020-02-15 00:00:00')
--9 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2148396, '1100011121437648', 43.60, '49', '4907', '2019-10-06 00:00:00')
--9 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (4133235, '1100011133544639', 8.29, '49', '4907', '2020-02-17 00:00:00')
--10 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2148396, '1100011121437648', 82.49, '49', '4907', '2019-10-06 00:00:00')
--10 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (4133235, '1100011133544639', 2.99, '49', '4907', '2020-02-21 00:00:00')
--11 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2148396, '1100011121437648', 42.02, '49', '4907', '2019-10-07 00:00:00')
--11 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (4133235, '1100011133544639', 27.23, '49', '4907', '2020-02-23 00:00:00')
--12 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2148396, '1100011121437648', 43.29, '49', '4907', '2019-10-07 00:00:00')
--12 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (4133235, '1100011133544639', 52.95, '49', '4907', '2020-02-24 00:00:00')
--13 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2148396, '1100011121437648', 43.52, '49', '4907', '2019-10-08 00:00:00')
--13 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (4133235, '1100011133544639', 31.10, '49', '4907', '2020-02-26 00:00:00')
--14 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2148396, '1100011121437648', 74.13, '49', '4907', '2019-10-11 00:00:00')
--14 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (4133235, '1100011133544639', 2.00, '49', '4907', '2020-02-27 00:00:00')
--15 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2148396, '1100011121437648', 34.11, '49', '4907', '2019-10-12 00:00:00')
--15 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (4133235, '1100011133544639', 36.55, '49', '4907', '2020-02-29 00:00:00')
--16 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2148396, '1100011121437648', 81.46, '49', '4907', '2019-10-12 00:00:00')
--16 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (4133235, '1100011133544639', 20.00, '49', '4907', '2020-03-02 00:00:00')
--17 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2148396, '1100011121437648', 32.31, '49', '4907', '2019-10-13 00:00:00')
--17 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (4133235, '1100011133544639', 36.06, '49', '4907', '2020-03-04 00:00:00')
--18 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2148396, '1100011121437648', 25.43, '49', '4907', '2019-10-13 00:00:00')
--18 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (4133235, '1100011133544639', 2.99, '49', '4907', '2020-03-21 00:00:00')
--19 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2148396, '1100011121437648', 53.85, '49', '4907', '2019-10-13 00:00:00')
--19 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (4133235, '1100011133544639', 40.05, '49', '4907', '2020-03-21 00:00:00')
--20 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2148396, '1100011121437648', 82.43, '49', '4907', '2019-10-16 00:00:00')
--20 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (4133235, '1100011133544639', 2.00, '49', '4907', '2020-03-21 00:00:00')
--21 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2148396, '1100011121437648', 97.06, '49', '4907', '2019-10-21 00:00:00')
--21 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (4133235, '1100011133544639', 2.00, '49', '4907', '2020-03-27 00:00:00')
--22 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2148396, '1100011121437648', 123.86, '49', '4907', '2019-10-23 00:00:00')
--22 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (4133235, '1100011133544639', 37.66, '49', '4907', '2020-03-27 00:00:00')
--23 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2148396, '1100011121437648', 161.61, '49', '4907', '2019-10-23 00:00:00')
--23 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (4133235, '1100011133544639', 48.02, '49', '4907', '2020-03-31 00:00:00')
--24 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2148396, '1100011121437648', 33.40, '49', '4907', '2019-10-25 00:00:00')
--24 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (4133235, '1100011133544639', 2.00, '49', '4907', '2020-03-31 00:00:00')
--25 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2148396, '1100011121437648', 71.80, '49', '4907', '2019-10-26 00:00:00')
--25 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (4133235, '1100011133544639', 21.92, '49', '4907', '2020-04-01 00:00:00')
--26 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2148396, '1100011121437648', 76.29, '49', '4907', '2019-10-26 00:00:00')
--26 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (4133235, '1100011133544639', 5.58, '49', '4907', '2020-04-02 00:00:00')
--27 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2148396, '1100011121437648', 12.39, '49', '4907', '2019-10-27 00:00:00')
--27 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (4133235, '1100011133544639', 40.00, '49', '4907', '2020-04-04 00:00:00')
--28 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2148396, '1100011121437648', 15.00, '49', '4907', '2019-10-28 00:00:00')
--28 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (4133235, '1100011133544639', 111.42, '49', '4907', '2020-04-05 00:00:00')
--29 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2148396, '1100011121437648', 22.98, '49', '4907', '2019-10-28 00:00:00')
--29 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (4133235, '1100011133544639', 146.98, '49', '4907', '2020-04-08 00:00:00')
--30 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2148396, '1100011121437648', 29.34, '49', '4907', '2019-10-30 00:00:00')
--30 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (4133235, '1100011133544639', 1.50, '49', '4907', '2020-04-11 00:00:00')
--31 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2148396, '1100011121437648', 11.44, '49', '4907', '2019-10-30 00:00:00')
--31 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (4133235, '1100011133544639', 2.00, '49', '4907', '2020-04-11 00:00:00')
--32 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2148396, '1100011121437648', 13.95, '49', '4907', '2019-10-31 00:00:00')
--32 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (4133235, '1100011133544639', 305.66, '49', '4907', '2020-04-26 00:00:00')
--33 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2148396, '1100011121437648', 9.50, '49', '4907', '2019-10-31 00:00:00')
--33 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (4133235, '1100011133544639', 84.66, '49', '4907', '2020-04-26 00:00:00')
--34 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2148396, '1100011121437648', 117.65, '49', '4907', '2019-11-01 00:00:00')
--34 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (4133235, '1100011133544639', 207.88, '49', '4907', '2020-04-26 00:00:00')
--35 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (4133235, '1100011133544639', 1.50, '49', '4907', '2020-04-26 00:00:00')
--36 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (4133235, '1100011133544639', 37.04, '49', '4907', '2020-04-29 00:00:00')
--37 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (4133235, '1100011133544639', 21.90, '49', '4907', '2020-05-10 00:00:00')
--38 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (4133235, '1100011133544639', 33.64, '49', '4907', '2020-05-10 00:00:00')
--39 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (4133235, '1100011133544639', 19.36, '49', '4907', '2020-05-10 00:00:00')
--40 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (4133235, '1100011133544639', 23.96, '49', '4907', '2020-05-11 00:00:00')