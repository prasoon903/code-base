
--DROP TABLE IF EXISTS TransactionCreationTempData
--CREATE TABLE TransactionCreationTempData (SN INT IDENTITY(1, 1), TxnAcctId INT, AccountNumber VARCHAR(19), TransactionAmount MONEY, CMTTranType VARCHAR(10), ActualTranCode VARCHAR(20), TranTime DATETIME, JobStatus INT DEFAULT(0))

BEGIN TRANSACTION
--COMMIT TRANSACTION
--ROLLBACK TRANSACTION



--1 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 9.99, '49', '4907', '2019-10-06 21:00:00')
--1 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 30.91, '49', '4907', '2019-10-18 21:00:00')
--2 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2019-10-11 21:00:00')
--2 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 110.76, '49', '4907', '2019-10-24 21:00:00')
--3 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 12.75, '49', '4907', '2019-10-16 21:00:00')
--3 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 2.99, '49', '4907', '2019-10-24 21:00:00')
--4 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 19.13, '49', '4907', '2019-10-21 21:00:00')
--4 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 391.33, '49', '4907', '2019-11-03 21:00:00')
--5 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 14.87, '49', '4907', '2019-10-25 21:00:00')
--5 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 9.99, '49', '4907', '2019-11-03 21:00:00')
--6 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 6.37, '49', '4907', '2019-11-01 21:00:00')
--6 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 186.55, '49', '4907', '2019-11-17 21:00:00')
--7 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 7.45, '49', '4907', '2019-11-01 21:00:00')
--7 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 222.60, '49', '4907', '2019-11-20 21:00:00')
--8 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 7.45, '49', '4907', '2019-11-01 21:00:00')
--8 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 34.87, '49', '4907', '2019-11-24 21:00:00')
--9 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 6.37, '49', '4907', '2019-11-01 21:00:00')
--9 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 19.93, '49', '4907', '2019-11-25 21:00:00')
--10 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 4.24, '49', '4907', '2019-11-05 21:00:00')
--10 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 2.99, '49', '4907', '2019-11-25 21:00:00')
--11 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 9.99, '49', '4907', '2019-11-06 21:00:00')
--11 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 130.53, '49', '4907', '2019-12-03 21:00:00')
--12 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 25.53, '49', '4907', '2019-11-07 21:00:00')
--12 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 9.99, '49', '4907', '2019-12-03 21:00:00')
--13 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 23.38, '49', '4907', '2019-11-10 21:00:00')
--13 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 230.34, '49', '4907', '2019-12-11 21:00:00')
--14 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 18.05, '49', '4907', '2019-11-17 21:00:00')
--14 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 452.41, '49', '4907', '2019-12-20 21:00:00')
--15 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 18.05, '49', '4907', '2019-11-18 21:00:00')
--15 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 118.96, '49', '4907', '2019-12-24 21:00:00')
--16 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 5.32, '49', '4907', '2019-11-18 21:00:00')
--16 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 2.99, '49', '4907', '2019-12-24 21:00:00')
--17 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 128.93, '49', '4907', '2019-11-20 21:00:00')
--17 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 114.80, '49', '4907', '2019-12-31 21:00:00')
--18 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 5.32, '49', '4907', '2019-11-22 21:00:00')
--18 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 9.99, '49', '4907', '2020-01-02 21:00:00')
--19 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 7.44, '49', '4907', '2019-11-22 21:00:00')
--19 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 50.88, '49', '4907', '2020-01-02 21:00:00')
--20 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2019-11-25 21:00:00')
--20 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 52.88, '49', '4907', '2020-01-06 21:00:00')
--21 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 17.02, '49', '4907', '2019-11-25 21:00:00')
--21 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 410.15, '49', '4907', '2020-01-14 21:00:00')
--22 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2019-11-26 21:00:00')
--22 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-16 21:00:00')
--23 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2019-11-26 21:00:00')
--23 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 12.95, '49', '4907', '2020-01-16 21:00:00')
--24 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2019-11-26 21:00:00')
--24 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-16 21:00:00')
--25 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2019-11-27 21:00:00')
--25 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 11.99, '49', '4907', '2020-01-16 21:00:00')
--26 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 7.45, '49', '4907', '2019-11-27 21:00:00')
--26 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 2.99, '49', '4907', '2020-01-16 21:00:00')
--27 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 5.32, '49', '4907', '2019-11-27 21:00:00')
--27 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-16 21:00:00')
--28 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 7.45, '49', '4907', '2019-11-27 21:00:00')
--28 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 4.99, '49', '4907', '2020-01-16 21:00:00')
--29 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 5.32, '49', '4907', '2019-11-27 21:00:00')
--29 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-16 21:00:00')
--30 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2019-11-27 21:00:00')
--30 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-16 21:00:00')
--31 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2019-12-03 21:00:00')
--31 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 4.99, '49', '4907', '2020-01-17 21:00:00')
--32 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2019-12-03 21:00:00')
--32 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 5.99, '49', '4907', '2020-01-17 21:00:00')
--33 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2019-12-04 21:00:00')
--33 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 4.99, '49', '4907', '2020-01-17 21:00:00')
--34 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2019-12-04 21:00:00')
--34 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 4.99, '49', '4907', '2020-01-17 21:00:00')
--35 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 9.99, '49', '4907', '2019-12-06 21:00:00')
--35 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-17 21:00:00')
--36 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2019-12-09 21:00:00')
--36 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-17 21:00:00')
--37 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2019-12-10 21:00:00')
--37 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-17 21:00:00')
--38 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-01-02 21:00:00')
--38 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-17 21:00:00')
--39 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 5.32, '49', '4907', '2020-01-02 21:00:00')
--39 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 2.99, '49', '4907', '2020-01-17 21:00:00')
--40 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-01-03 21:00:00')
--40 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-17 21:00:00')
--41 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-01-03 21:00:00')
--41 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-17 21:00:00')
--42 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-01-03 21:00:00')
--42 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-17 21:00:00')
--43 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 9.99, '49', '4907', '2020-01-06 21:00:00')
--43 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-17 21:00:00')
--44 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-01-08 21:00:00')
--44 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-17 21:00:00')
--45 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 4.25, '49', '4907', '2020-01-08 21:00:00')
--45 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-18 21:00:00')
--46 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 7.45, '49', '4907', '2020-01-08 21:00:00')
--46 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-19 21:00:00')
--47 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-01-08 21:00:00')
--47 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 4.99, '49', '4907', '2020-01-19 21:00:00')
--48 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-01-12 21:00:00')
--48 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 4.99, '49', '4907', '2020-01-19 21:00:00')
--49 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 5.32, '49', '4907', '2020-01-12 21:00:00')
--49 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 5.99, '49', '4907', '2020-01-19 21:00:00')
--50 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-01-12 21:00:00')
--50 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 5.99, '49', '4907', '2020-01-19 21:00:00')
--51 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 5.32, '49', '4907', '2020-01-12 21:00:00')
--51 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-20 21:00:00')
--52 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-01-13 21:00:00')
--52 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 4.99, '49', '4907', '2020-01-20 21:00:00')
--53 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-01-13 21:00:00')
--53 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-20 21:00:00')
--54 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-01-13 21:00:00')
--54 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-20 21:00:00')
--55 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-01-15 21:00:00')
--55 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 4.99, '49', '4907', '2020-01-20 21:00:00')
--56 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 5.32, '49', '4907', '2020-01-15 21:00:00')
--56 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-20 21:00:00')
--57 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 6.39, '49', '4907', '2020-01-16 21:00:00')
--57 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 9.99, '49', '4907', '2020-01-20 21:00:00')
--58 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 7.45, '49', '4907', '2020-01-16 21:00:00')
--58 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-20 21:00:00')
--59 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-01-16 21:00:00')
--59 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 5.99, '49', '4907', '2020-01-20 21:00:00')
--60 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-01-16 21:00:00')
--60 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-20 21:00:00')
--61 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 6.39, '49', '4907', '2020-01-16 21:00:00')
--61 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 2.99, '49', '4907', '2020-01-20 21:00:00')
--62 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-01-16 21:00:00')
--62 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 99.99, '49', '4907', '2020-01-20 21:00:00')
--63 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 6.39, '49', '4907', '2020-01-16 21:00:00')
--63 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-20 21:00:00')
--64 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 6.39, '49', '4907', '2020-01-16 21:00:00')
--64 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-20 21:00:00')
--65 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 6.39, '49', '4907', '2020-01-16 21:00:00')
--65 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-20 21:00:00')
--66 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-01-16 21:00:00')
--66 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-20 21:00:00')
--67 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-01-16 21:00:00')
--67 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 4.99, '49', '4907', '2020-01-20 21:00:00')
--68 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 6.39, '49', '4907', '2020-01-16 21:00:00')
--68 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-20 21:00:00')
--69 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 6.39, '49', '4907', '2020-01-16 21:00:00')
--69 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 4.99, '49', '4907', '2020-01-21 21:00:00')
--70 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-01-16 21:00:00')
--70 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-24 21:00:00')
--71 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 6.39, '49', '4907', '2020-01-20 21:00:00')
--71 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-24 21:00:00')
--72 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-01-20 21:00:00')
--72 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 2.99, '49', '4907', '2020-01-24 21:00:00')
--73 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 6.39, '49', '4907', '2020-01-20 21:00:00')
--73 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-25 21:00:00')
--74 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 6.39, '49', '4907', '2020-01-20 21:00:00')
--74 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-25 21:00:00')
--75 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-01-20 21:00:00')
--75 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-25 21:00:00')
--76 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-01-20 21:00:00')
--76 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 2.99, '49', '4907', '2020-01-26 21:00:00')
--77 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-26 21:00:00')
--77 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-02-05 21:00:00')
--78 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-26 21:00:00')
--78 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-02-05 21:00:00')
--79 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 8.99, '49', '4907', '2020-01-27 21:00:00')
--79 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-02-05 21:00:00')
--80 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 5.99, '49', '4907', '2020-01-27 21:00:00')
--80 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 6.39, '49', '4907', '2020-02-05 21:00:00')
--81 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 8.99, '49', '4907', '2020-01-27 21:00:00')
--81 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-02-06 21:00:00')
--82 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 19.99, '49', '4907', '2020-01-27 21:00:00')
--82 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-02-06 21:00:00')
--83 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 19.99, '49', '4907', '2020-01-27 21:00:00')
--83 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 9.99, '49', '4907', '2020-02-06 21:00:00')
--84 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 19.99, '49', '4907', '2020-01-27 21:00:00')
--84 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 6.39, '49', '4907', '2020-02-09 21:00:00')
--85 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 5.99, '49', '4907', '2020-01-27 21:00:00')
--85 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-02-09 21:00:00')
--86 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-27 21:00:00')
--86 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-02-09 21:00:00')
--87 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 8.99, '49', '4907', '2020-01-27 21:00:00')
--87 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-02-09 21:00:00')
--88 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 49.99, '49', '4907', '2020-01-27 21:00:00')
--88 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-02-09 21:00:00')
--89 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 49.99, '49', '4907', '2020-01-27 21:00:00')
--89 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-02-11 21:00:00')
--90 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 2.99, '49', '4907', '2020-01-27 21:00:00')
--90 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 6.39, '49', '4907', '2020-02-11 21:00:00')
--91 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 5.99, '49', '4907', '2020-01-27 21:00:00')
--91 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-02-11 21:00:00')
--92 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-27 21:00:00')
--92 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-02-12 21:00:00')
--93 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 8.99, '49', '4907', '2020-01-27 21:00:00')
--93 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-02-12 21:00:00')
--94 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 49.99, '49', '4907', '2020-01-27 21:00:00')
--94 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-02-12 21:00:00')
--95 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 19.99, '49', '4907', '2020-01-27 21:00:00')
--95 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-02-12 21:00:00')
--96 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 5.99, '49', '4907', '2020-01-27 21:00:00')
--96 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-02-12 21:00:00')
--97 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 2.99, '49', '4907', '2020-01-28 21:00:00')
--97 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-02-12 21:00:00')
--98 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 2.99, '49', '4907', '2020-01-28 21:00:00')
--98 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-02-12 21:00:00')
--99 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 2.99, '49', '4907', '2020-01-28 21:00:00')
--99 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 6.39, '49', '4907', '2020-02-12 21:00:00')
--100 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-28 21:00:00')
--100 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-02-12 21:00:00')
--101 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-28 21:00:00')
--101 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-02-12 21:00:00')
--102 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-28 21:00:00')
--102 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-02-12 21:00:00')
--103 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-28 21:00:00')
--103 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-02-12 21:00:00')
--104 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-28 21:00:00')
--104 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-02-12 21:00:00')
--105 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-28 21:00:00')
--105 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-02-12 21:00:00')
--106 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-28 21:00:00')
--106 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-02-12 21:00:00')
--107 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 2.99, '49', '4907', '2020-01-28 21:00:00')
--107 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-02-13 21:00:00')
--108 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 2.99, '49', '4907', '2020-01-28 21:00:00')
--108 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-02-13 21:00:00')
--109 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-28 21:00:00')
--109 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-02-13 21:00:00')
--110 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-28 21:00:00')
--110 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 6.39, '49', '4907', '2020-02-13 21:00:00')
--111 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-28 21:00:00')
--111 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-02-13 21:00:00')
--112 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-28 21:00:00')
--112 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 7.45, '49', '4907', '2020-02-13 21:00:00')
--113 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-28 21:00:00')
--113 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-02-13 21:00:00')
--114 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-28 21:00:00')
--114 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-02-19 21:00:00')
--115 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-28 21:00:00')
--115 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-02-19 21:00:00')
--116 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 2.99, '49', '4907', '2020-01-28 21:00:00')
--116 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 5.32, '49', '4907', '2020-02-20 21:00:00')
--117 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-28 21:00:00')
--117 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-02-20 21:00:00')
--118 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-28 21:00:00')
--118 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 7.45, '49', '4907', '2020-02-21 21:00:00')
--119 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-28 21:00:00')
--119 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 5.32, '49', '4907', '2020-02-23 21:00:00')
--120 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-28 21:00:00')
--120 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-02-23 21:00:00')
--121 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-28 21:00:00')
--121 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 7.45, '49', '4907', '2020-02-23 21:00:00')
--122 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-28 21:00:00')
--122 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-02-23 21:00:00')
--123 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 2.99, '49', '4907', '2020-01-28 21:00:00')
--123 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-02-23 21:00:00')
--124 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-28 21:00:00')
--124 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 5.32, '49', '4907', '2020-02-23 21:00:00')
--125 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-28 21:00:00')
--125 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-02-23 21:00:00')
--126 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 2.99, '49', '4907', '2020-01-28 21:00:00')
--126 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 5.32, '49', '4907', '2020-02-23 21:00:00')
--127 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-28 21:00:00')
--127 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-02-23 21:00:00')
--128 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-28 21:00:00')
--128 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 6.39, '49', '4907', '2020-02-23 21:00:00')
--129 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-28 21:00:00')
--129 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-02-23 21:00:00')
--130 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-28 21:00:00')
--130 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 7.45, '49', '4907', '2020-02-25 21:00:00')
--131 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-28 21:00:00')
--131 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-02-25 21:00:00')
--132 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-28 21:00:00')
--132 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 7.45, '49', '4907', '2020-02-25 21:00:00')
--133 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-28 21:00:00')
--133 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-02-25 21:00:00')
--134 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-28 21:00:00')
--134 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-02-25 21:00:00')
--135 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-28 21:00:00')
--135 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-02-25 21:00:00')
--136 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-28 21:00:00')
--136 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-02-26 21:00:00')
--137 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-28 21:00:00')
--137 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-02-26 21:00:00')
--138 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-28 21:00:00')
--138 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-02-26 21:00:00')
--139 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-28 21:00:00')
--139 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-02-26 21:00:00')
--140 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-28 21:00:00')
--140 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-02-26 21:00:00')
--141 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-28 21:00:00')
--141 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 5.32, '49', '4907', '2020-02-26 21:00:00')
--142 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-28 21:00:00')
--142 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 5.32, '49', '4907', '2020-02-26 21:00:00')
--143 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 2.99, '49', '4907', '2020-01-28 21:00:00')
--143 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 3.19, '49', '4907', '2020-02-26 21:00:00')
--144 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-28 21:00:00')
--144 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-02-26 21:00:00')
--145 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-28 21:00:00')
--145 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 5.32, '49', '4907', '2020-02-26 21:00:00')
--146 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-28 21:00:00')
--146 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 8.52, '49', '4907', '2020-02-26 21:00:00')
--147 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-28 21:00:00')
--147 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 7.45, '49', '4907', '2020-02-28 21:00:00')
--148 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-28 21:00:00')
--148 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 9.99, '49', '4907', '2020-03-06 21:00:00')
--149 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-28 21:00:00')
--149 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-03-06 21:00:00')
--150 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-29 21:00:00')
--150 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-03-06 21:00:00')
--151 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 2.99, '49', '4907', '2020-01-29 21:00:00')
--151 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-03-06 21:00:00')
--152 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-29 21:00:00')
--152 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-03-06 21:00:00')
--153 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-29 21:00:00')
--153 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-03-07 21:00:00')
--154 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-29 21:00:00')
--154 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-03-07 21:00:00')
--155 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-29 21:00:00')
--155 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 8.52, '49', '4907', '2020-03-08 21:00:00')
--156 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-29 21:00:00')
--156 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-03-09 21:00:00')
--157 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-29 21:00:00')
--157 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-03-10 21:00:00')
--158 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-29 21:00:00')
--158 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-03-10 21:00:00')
--159 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 2.99, '49', '4907', '2020-01-29 21:00:00')
--159 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-03-10 21:00:00')
--160 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 2.99, '49', '4907', '2020-01-29 21:00:00')
--160 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 5.32, '49', '4907', '2020-03-10 21:00:00')
--161 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-29 21:00:00')
--161 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 8.52, '49', '4907', '2020-03-10 21:00:00')
--162 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-29 21:00:00')
--162 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-03-10 21:00:00')
--163 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-29 21:00:00')
--163 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-03-10 21:00:00')
--164 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-29 21:00:00')
--164 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 5.32, '49', '4907', '2020-03-14 21:00:00')
--165 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 2.99, '49', '4907', '2020-01-29 21:00:00')
--165 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-03-15 21:00:00')
--166 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-29 21:00:00')
--166 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-03-15 21:00:00')
--167 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-29 21:00:00')
--167 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-03-15 21:00:00')
--168 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 2.99, '49', '4907', '2020-01-29 21:00:00')
--168 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 10.65, '49', '4907', '2020-03-15 21:00:00')
--169 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-29 21:00:00')
--169 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-03-15 21:00:00')
--170 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-29 21:00:00')
--170 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 13.85, '49', '4907', '2020-03-15 21:00:00')
--171 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-29 21:00:00')
--171 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-03-18 21:00:00')
--172 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-29 21:00:00')
--172 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-03-18 21:00:00')
--173 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-29 21:00:00')
--173 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 8.52, '49', '4907', '2020-03-19 21:00:00')
--174 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-29 21:00:00')
--174 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-03-19 21:00:00')
--175 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-29 21:00:00')
--175 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-03-19 21:00:00')
--176 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-29 21:00:00')
--176 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 8.52, '49', '4907', '2020-03-19 21:00:00')
--177 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-29 21:00:00')
--177 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-03-20 21:00:00')
--178 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-29 21:00:00')
--178 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-03-20 21:00:00')
--179 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-29 21:00:00')
--179 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-03-23 21:00:00')
--180 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-29 21:00:00')
--180 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-03-23 21:00:00')
--181 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 2.99, '49', '4907', '2020-01-29 21:00:00')
--181 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-03-23 21:00:00')
--182 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 2.99, '49', '4907', '2020-01-29 21:00:00')
--182 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-03-23 21:00:00')
--183 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-29 21:00:00')
--183 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 10.65, '49', '4907', '2020-03-23 21:00:00')
--184 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 2.99, '49', '4907', '2020-01-29 21:00:00')
--184 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-03-23 21:00:00')
--185 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-29 21:00:00')
--185 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-03-24 21:00:00')
--186 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-29 21:00:00')
--186 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-03-24 21:00:00')
--187 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-29 21:00:00')
--187 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-03-24 21:00:00')
--188 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-29 21:00:00')
--188 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-03-25 21:00:00')
--189 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-29 21:00:00')
--189 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-03-25 21:00:00')
--190 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 2.99, '49', '4907', '2020-01-30 21:00:00')
--190 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-03-25 21:00:00')
--191 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-30 21:00:00')
--191 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-03-25 21:00:00')
--192 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-30 21:00:00')
--192 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-03-25 21:00:00')
--193 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 2.99, '49', '4907', '2020-01-30 21:00:00')
--193 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 8.52, '49', '4907', '2020-03-25 21:00:00')
--194 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 4.99, '49', '4907', '2020-01-30 21:00:00')
--194 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-04-02 21:00:00')
--195 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-30 21:00:00')
--195 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-04-02 21:00:00')
--196 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-30 21:00:00')
--196 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-04-02 21:00:00')
--197 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-30 21:00:00')
--197 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-04-02 21:00:00')
--198 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 2.99, '49', '4907', '2020-01-30 21:00:00')
--198 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-04-02 21:00:00')
--199 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 2.99, '49', '4907', '2020-01-30 21:00:00')
--199 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-04-02 21:00:00')
--200 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-30 21:00:00')
--200 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-04-02 21:00:00')
--201 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-30 21:00:00')
--201 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-04-02 21:00:00')
--202 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-30 21:00:00')
--202 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-04-02 21:00:00')
--203 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 2.99, '49', '4907', '2020-01-30 21:00:00')
--203 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-04-02 21:00:00')
--204 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 2.99, '49', '4907', '2020-01-30 21:00:00')
--204 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-04-02 21:00:00')
--205 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-30 21:00:00')
--205 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-04-02 21:00:00')
--206 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-30 21:00:00')
--206 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-04-02 21:00:00')
--207 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 2.99, '49', '4907', '2020-01-30 21:00:00')
--207 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 9.99, '49', '4907', '2020-04-06 21:00:00')
--208 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 4.99, '49', '4907', '2020-01-30 21:00:00')
--208 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-04-07 21:00:00')
--209 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-30 21:00:00')
--209 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-04-07 21:00:00')
--210 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-30 21:00:00')
--210 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-04-07 21:00:00')
--211 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-30 21:00:00')
--211 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-04-09 21:00:00')
--212 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-30 21:00:00')
--212 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-04-09 21:00:00')
--213 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 4.99, '49', '4907', '2020-01-30 21:00:00')
--213 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-05-08 21:00:00')
--214 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 2.99, '49', '4907', '2020-01-30 21:00:00')
--214 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-05-08 21:00:00')
--215 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-30 21:00:00')
--215 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-05-15 21:00:00')
--216 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 2.99, '49', '4907', '2020-01-30 21:00:00')
--216 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-05-15 21:00:00')
--217 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-30 21:00:00')
--217 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-05-15 21:00:00')
--218 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-30 21:00:00')
--218 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-05-15 21:00:00')
--219 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-30 21:00:00')
--219 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 6.39, '49', '4907', '2020-05-15 21:00:00')
--220 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-30 21:00:00')
--220 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-05-18 21:00:00')
--221 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 4.99, '49', '4907', '2020-01-30 21:00:00')
--221 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-05-18 21:00:00')
--222 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 2.99, '49', '4907', '2020-01-30 21:00:00')
--222 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-05-19 21:00:00')
--223 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-30 21:00:00')
--223 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-05-19 21:00:00')
--224 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 2.99, '49', '4907', '2020-01-30 21:00:00')
--224 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-05-19 21:00:00')
--225 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-30 21:00:00')
--225 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-05-19 21:00:00')
--226 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-30 21:00:00')
--226 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-05-19 21:00:00')
--227 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-30 21:00:00')
--227 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 5.32, '49', '4907', '2020-05-19 21:00:00')
--228 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 2.99, '49', '4907', '2020-01-30 21:00:00')
--228 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-05-19 21:00:00')
--229 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-30 21:00:00')
--229 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-05-19 21:00:00')
--230 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 2.99, '49', '4907', '2020-01-30 21:00:00')
--230 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-05-21 21:00:00')
--231 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-30 21:00:00')
--231 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-05-24 21:00:00')
--232 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-30 21:00:00')
--232 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-05-24 21:00:00')
--233 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 4.99, '49', '4907', '2020-01-30 21:00:00')
--233 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-05-24 21:00:00')
--234 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-30 21:00:00')
--234 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-05-24 21:00:00')
--235 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 2.99, '49', '4907', '2020-01-30 21:00:00')
--235 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-05-24 21:00:00')
--236 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-31 21:00:00')
--236 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-05-24 21:00:00')
--237 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 2.99, '49', '4907', '2020-01-31 21:00:00')
--237 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-05-24 21:00:00')
--238 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-31 21:00:00')
--238 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 5.32, '49', '4907', '2020-05-24 21:00:00')
--239 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-31 21:00:00')
--239 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-05-24 21:00:00')
--240 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-31 21:00:00')
--240 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-05-26 21:00:00')
--241 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-31 21:00:00')
--241 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-05-26 21:00:00')
--242 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-31 21:00:00')
--242 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-05-26 21:00:00')
--243 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 5.99, '49', '4907', '2020-01-31 21:00:00')
--243 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-05-26 21:00:00')
--244 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-31 21:00:00')
--244 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-05-26 21:00:00')
--245 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-31 21:00:00')
--245 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-05-26 21:00:00')
--246 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 2.99, '49', '4907', '2020-01-31 21:00:00')
--246 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-05-27 21:00:00')
--247 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-31 21:00:00')
--247 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-05-27 21:00:00')
--248 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-31 21:00:00')
--248 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-05-27 21:00:00')
--249 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-31 21:00:00')
--249 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-05-28 21:00:00')
--250 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-31 21:00:00')
--250 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-05-28 21:00:00')
--251 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-31 21:00:00')
--251 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-05-28 21:00:00')
--252 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-31 21:00:00')
--252 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-05-28 21:00:00')
--253 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-31 21:00:00')
--253 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-05-28 21:00:00')
--254 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-31 21:00:00')
--254 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-05-28 21:00:00')
--255 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-31 21:00:00')
--255 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-05-28 21:00:00')
--256 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 5.99, '49', '4907', '2020-01-31 21:00:00')
--256 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-06-05 21:00:00')
--257 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-31 21:00:00')
--257 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 9.99, '49', '4907', '2020-06-07 21:00:00')
--258 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-31 21:00:00')
--258 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-06-14 21:00:00')
--259 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 5.99, '49', '4907', '2020-01-31 21:00:00')
--259 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-06-14 21:00:00')
--260 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 5.99, '49', '4907', '2020-01-31 21:00:00')
--260 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-06-15 21:00:00')
--261 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-31 21:00:00')
--261 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-06-15 21:00:00')
--262 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-31 21:00:00')
--262 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 6.39, '49', '4907', '2020-06-18 21:00:00')
--263 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-31 21:00:00')
--263 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-06-18 21:00:00')
--264 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 2.99, '49', '4907', '2020-01-31 21:00:00')
--264 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-06-18 21:00:00')
--265 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 5.99, '49', '4907', '2020-01-31 21:00:00')
--265 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-06-18 21:00:00')
--266 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-31 21:00:00')
--266 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-06-18 21:00:00')
--267 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-31 21:00:00')
--267 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-06-18 21:00:00')
--268 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-31 21:00:00')
--268 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-06-18 21:00:00')
--269 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 2.99, '49', '4907', '2020-01-31 21:00:00')
--269 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-06-18 21:00:00')
--270 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-31 21:00:00')
--270 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-06-18 21:00:00')
--271 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-31 21:00:00')
--271 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-06-18 21:00:00')
--272 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-31 21:00:00')
--272 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2246270, '1100011122407285', 2.12, '49', '4907', '2020-06-19 21:00:00')
--273 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-31 21:00:00')
--274 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-31 21:00:00')
--275 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 2.99, '49', '4907', '2020-01-31 21:00:00')
--276 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-31 21:00:00')
--277 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-31 21:00:00')
--278 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-31 21:00:00')
--279 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-31 21:00:00')
--280 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-01-31 21:00:00')
--281 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-01 21:00:00')
--282 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-01 21:00:00')
--283 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-01 21:00:00')
--284 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-01 21:00:00')
--285 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-01 21:00:00')
--286 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-01 21:00:00')
--287 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-01 21:00:00')
--288 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-01 21:00:00')
--289 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-01 21:00:00')
--290 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-01 21:00:00')
--291 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-01 21:00:00')
--292 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-01 21:00:00')
--293 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-01 21:00:00')
--294 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-01 21:00:00')
--295 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-01 21:00:00')
--296 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-01 21:00:00')
--297 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-01 21:00:00')
--298 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-01 21:00:00')
--299 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-01 21:00:00')
--300 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-01 21:00:00')
--301 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-01 21:00:00')
--302 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-01 21:00:00')
--303 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-01 21:00:00')
--304 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-01 21:00:00')
--305 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-01 21:00:00')
--306 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-01 21:00:00')
--307 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-01 21:00:00')
--308 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-01 21:00:00')
--309 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-01 21:00:00')
--310 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 2.99, '49', '4907', '2020-02-01 21:00:00')
--311 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-01 21:00:00')
--312 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-01 21:00:00')
--313 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 9.99, '49', '4907', '2020-02-01 21:00:00')
--314 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-01 21:00:00')
--315 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-01 21:00:00')
--316 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-01 21:00:00')
--317 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 2.99, '49', '4907', '2020-02-01 21:00:00')
--318 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-01 21:00:00')
--319 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-01 21:00:00')
--320 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-01 21:00:00')
--321 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-01 21:00:00')
--322 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 9.99, '49', '4907', '2020-02-01 21:00:00')
--323 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-01 21:00:00')
--324 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 2.99, '49', '4907', '2020-02-01 21:00:00')
--325 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 9.99, '49', '4907', '2020-02-01 21:00:00')
--326 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-01 21:00:00')
--327 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-01 21:00:00')
--328 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-01 21:00:00')
--329 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 9.99, '49', '4907', '2020-02-01 21:00:00')
--330 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-01 21:00:00')
--331 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-01 21:00:00')
--332 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-01 21:00:00')
--333 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-01 21:00:00')
--334 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-01 21:00:00')
--335 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-01 21:00:00')
--336 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-01 21:00:00')
--337 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-01 21:00:00')
--338 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-01 21:00:00')
--339 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-01 21:00:00')
--340 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 2.99, '49', '4907', '2020-02-01 21:00:00')
--341 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-01 21:00:00')
--342 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-01 21:00:00')
--343 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-01 21:00:00')
--344 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-01 21:00:00')
--345 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-02 21:00:00')
--346 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-02 21:00:00')
--347 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-02 21:00:00')
--348 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 5.99, '49', '4907', '2020-02-02 21:00:00')
--349 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-02 21:00:00')
--350 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 5.99, '49', '4907', '2020-02-02 21:00:00')
--351 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-02 21:00:00')
--352 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-02 21:00:00')
--353 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 2.99, '49', '4907', '2020-02-02 21:00:00')
--354 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 2.99, '49', '4907', '2020-02-02 21:00:00')
--355 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-02 21:00:00')
--356 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-02 21:00:00')
--357 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 2.99, '49', '4907', '2020-02-03 21:00:00')
--358 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-03 21:00:00')
--359 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-03 21:00:00')
--360 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-03 21:00:00')
--361 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-03 21:00:00')
--362 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-03 21:00:00')
--363 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-03 21:00:00')
--364 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 2.99, '49', '4907', '2020-02-03 21:00:00')
--365 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-03 21:00:00')
--366 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 9.99, '49', '4907', '2020-02-03 21:00:00')
--367 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 4.99, '49', '4907', '2020-02-03 21:00:00')
--368 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 9.99, '49', '4907', '2020-02-03 21:00:00')
--369 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-03 21:00:00')
--370 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 4.99, '49', '4907', '2020-02-03 21:00:00')
--371 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-03 21:00:00')
--372 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-03 21:00:00')
--373 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-03 21:00:00')
--374 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-03 21:00:00')
--375 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-04 21:00:00')
--376 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 2.99, '49', '4907', '2020-02-04 21:00:00')
--377 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-04 21:00:00')
--378 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 2.99, '49', '4907', '2020-02-04 21:00:00')
--379 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 2.99, '49', '4907', '2020-02-04 21:00:00')
--380 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 2.99, '49', '4907', '2020-02-04 21:00:00')
--381 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 2.99, '49', '4907', '2020-02-04 21:00:00')
--382 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-04 21:00:00')
--383 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-04 21:00:00')
--384 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-05 21:00:00')
--385 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 4.99, '49', '4907', '2020-02-06 21:00:00')
--386 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-06 21:00:00')
--387 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-06 21:00:00')
--388 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 2.99, '49', '4907', '2020-02-07 21:00:00')
--389 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-07 21:00:00')
--390 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-07 21:00:00')
--391 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-07 21:00:00')
--392 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-07 21:00:00')
--393 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 7.99, '49', '4907', '2020-02-07 21:00:00')
--394 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 5.99, '49', '4907', '2020-02-10 21:00:00')
--395 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 7.99, '49', '4907', '2020-02-14 21:00:00')
--396 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-14 21:00:00')
--397 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-17 21:00:00')
--398 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-17 21:00:00')
--399 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 5.99, '49', '4907', '2020-02-17 21:00:00')
--400 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 4.99, '49', '4907', '2020-02-17 21:00:00')
--401 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-17 21:00:00')
--402 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-18 21:00:00')
--403 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 4.99, '49', '4907', '2020-02-18 21:00:00')
--404 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-18 21:00:00')
--405 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-18 21:00:00')
--406 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-18 21:00:00')
--407 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-18 21:00:00')
--408 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-18 21:00:00')
--409 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-18 21:00:00')
--410 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 5.99, '49', '4907', '2020-02-19 21:00:00')
--411 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-19 21:00:00')
--412 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 4.99, '49', '4907', '2020-02-19 21:00:00')
--413 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-19 21:00:00')
--414 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 4.99, '49', '4907', '2020-02-19 21:00:00')
--415 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 4.99, '49', '4907', '2020-02-19 21:00:00')
--416 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-19 21:00:00')
--417 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-19 21:00:00')
--418 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-19 21:00:00')
--419 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-20 21:00:00')
--420 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-20 21:00:00')
--421 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 5.99, '49', '4907', '2020-02-20 21:00:00')
--422 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-21 21:00:00')
--423 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 5.99, '49', '4907', '2020-02-21 21:00:00')
--424 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-21 21:00:00')
--425 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 4.99, '49', '4907', '2020-02-21 21:00:00')
--426 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 12.99, '49', '4907', '2020-02-21 21:00:00')
--427 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-21 21:00:00')
--428 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-21 21:00:00')
--429 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-21 21:00:00')
--430 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-21 21:00:00')
--431 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 4.99, '49', '4907', '2020-02-21 21:00:00')
--432 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-21 21:00:00')
--433 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-21 21:00:00')
--434 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-21 21:00:00')
--435 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-21 21:00:00')
--436 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-21 21:00:00')
--437 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 5.99, '49', '4907', '2020-02-21 21:00:00')
--438 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 7.99, '49', '4907', '2020-02-21 21:00:00')
--439 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-23 21:00:00')
--440 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-23 21:00:00')
--441 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 5.99, '49', '4907', '2020-02-23 21:00:00')
--442 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-23 21:00:00')
--443 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-24 21:00:00')
--444 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 5.99, '49', '4907', '2020-02-24 21:00:00')
--445 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 2.99, '49', '4907', '2020-02-24 21:00:00')
--446 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 4.99, '49', '4907', '2020-02-24 21:00:00')
--447 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 9.99, '49', '4907', '2020-02-24 21:00:00')
--448 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 4.99, '49', '4907', '2020-02-24 21:00:00')
--449 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-24 21:00:00')
--450 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-24 21:00:00')
--451 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 5.99, '49', '4907', '2020-02-24 21:00:00')
--452 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 7.99, '49', '4907', '2020-02-24 21:00:00')
--453 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-24 21:00:00')
--454 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-24 21:00:00')
--455 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 0.99, '49', '4907', '2020-02-24 21:00:00')
--456 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-24 21:00:00')
--457 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 9.99, '49', '4907', '2020-02-24 21:00:00')
--458 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 4.99, '49', '4907', '2020-02-24 21:00:00')
--459 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-24 21:00:00')
--460 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-24 21:00:00')
--461 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 5.99, '49', '4907', '2020-02-24 21:00:00')
--462 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-24 21:00:00')
--463 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-24 21:00:00')
--464 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-24 21:00:00')
--465 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-24 21:00:00')
--466 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 7.99, '49', '4907', '2020-02-24 21:00:00')
--467 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-25 21:00:00')
--468 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 9.99, '49', '4907', '2020-02-25 21:00:00')
--469 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-25 21:00:00')
--470 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 2.99, '49', '4907', '2020-02-25 21:00:00')
--471 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 9.99, '49', '4907', '2020-02-25 21:00:00')
--472 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-25 21:00:00')
--473 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 7.99, '49', '4907', '2020-02-25 21:00:00')
--474 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 2.99, '49', '4907', '2020-02-26 21:00:00')
--475 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 19.99, '49', '4907', '2020-02-26 21:00:00')
--476 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-26 21:00:00')
--477 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-26 21:00:00')
--478 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 8.99, '49', '4907', '2020-02-27 21:00:00')
--479 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 7.99, '49', '4907', '2020-02-27 21:00:00')
--480 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-28 21:00:00')
--481 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 2.99, '49', '4907', '2020-02-28 21:00:00')
--482 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 9.99, '49', '4907', '2020-02-28 21:00:00')
--483 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 2.99, '49', '4907', '2020-02-28 21:00:00')
--484 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-28 21:00:00')
--485 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 2.99, '49', '4907', '2020-02-28 21:00:00')
--486 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 4.99, '49', '4907', '2020-02-28 21:00:00')
--487 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-28 21:00:00')
--488 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 7.99, '49', '4907', '2020-02-28 21:00:00')
--489 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-28 21:00:00')
--490 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-28 21:00:00')
--491 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 3.99, '49', '4907', '2020-02-28 21:00:00')
--492 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-28 21:00:00')
--493 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-28 21:00:00')
--494 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 9.99, '49', '4907', '2020-02-28 21:00:00')
--495 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-28 21:00:00')
--496 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 9.99, '49', '4907', '2020-02-28 21:00:00')
--497 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-28 21:00:00')
--498 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 3.99, '49', '4907', '2020-02-28 21:00:00')
--499 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 7.99, '49', '4907', '2020-02-28 21:00:00')
--500 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-28 21:00:00')
--501 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 5.99, '49', '4907', '2020-02-28 21:00:00')
--502 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 0.99, '49', '4907', '2020-02-28 21:00:00')
--503 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-28 21:00:00')
--504 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 3.99, '49', '4907', '2020-02-28 21:00:00')
--505 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-29 21:00:00')
--506 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-02-29 21:00:00')
--507 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 3.99, '49', '4907', '2020-02-29 21:00:00')
--508 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 3.99, '49', '4907', '2020-02-29 21:00:00')
--509 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-03-01 21:00:00')
--510 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-03-01 21:00:00')
--511 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-03-01 21:00:00')
--512 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-03-01 21:00:00')
--513 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-03-01 21:00:00')
--514 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-03-01 21:00:00')
--515 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 5.99, '49', '4907', '2020-03-01 21:00:00')
--516 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-03-01 21:00:00')
--517 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-03-01 21:00:00')
--518 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-03-01 21:00:00')
--519 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 7.99, '49', '4907', '2020-03-02 21:00:00')
--520 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-03-02 21:00:00')
--521 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 9.99, '49', '4907', '2020-03-02 21:00:00')
--522 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-03-02 21:00:00')
--523 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-03-02 21:00:00')
--524 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-03-02 21:00:00')
--525 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 4.99, '49', '4907', '2020-03-02 21:00:00')
--526 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-03-02 21:00:00')
--527 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-03-02 21:00:00')
--528 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-03-02 21:00:00')
--529 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 3.99, '49', '4907', '2020-03-02 21:00:00')
--530 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 3.99, '49', '4907', '2020-03-02 21:00:00')
--531 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-03-02 21:00:00')
--532 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-03-03 21:00:00')
--533 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-03-03 21:00:00')
--534 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-03-03 21:00:00')
--535 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 9.99, '49', '4907', '2020-03-03 21:00:00')
--536 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-03-03 21:00:00')
--537 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 5.99, '49', '4907', '2020-03-03 21:00:00')
--538 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-03-03 21:00:00')
--539 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 14.99, '49', '4907', '2020-03-03 21:00:00')
--540 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-03-03 21:00:00')
--541 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-03-03 21:00:00')
--542 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 9.99, '49', '4907', '2020-03-03 21:00:00')
--543 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 3.99, '49', '4907', '2020-03-04 21:00:00')
--544 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 9.99, '49', '4907', '2020-03-04 21:00:00')
--545 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 19.99, '49', '4907', '2020-03-04 21:00:00')
--546 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 14.99, '49', '4907', '2020-03-04 21:00:00')
--547 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 3.99, '49', '4907', '2020-03-04 21:00:00')
--548 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-03-04 21:00:00')
--549 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 7.99, '49', '4907', '2020-03-04 21:00:00')
--550 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 3.99, '49', '4907', '2020-03-04 21:00:00')
--551 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-03-04 21:00:00')
--552 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-03-04 21:00:00')
--553 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 2.99, '49', '4907', '2020-03-04 21:00:00')
--554 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 3.99, '49', '4907', '2020-03-04 21:00:00')
--555 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 19.99, '49', '4907', '2020-03-04 21:00:00')
--556 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 2.99, '49', '4907', '2020-03-04 21:00:00')
--557 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 3.99, '49', '4907', '2020-03-04 21:00:00')
--558 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 14.99, '49', '4907', '2020-03-04 21:00:00')
--559 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 14.99, '49', '4907', '2020-03-04 21:00:00')
--560 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 2.99, '49', '4907', '2020-03-04 21:00:00')
--561 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 9.99, '49', '4907', '2020-03-04 21:00:00')
--562 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 2.99, '49', '4907', '2020-03-04 21:00:00')
--563 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 14.99, '49', '4907', '2020-03-04 21:00:00')
--564 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-03-04 21:00:00')
--565 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 9.99, '49', '4907', '2020-03-05 21:00:00')
--566 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 5.99, '49', '4907', '2020-03-05 21:00:00')
--567 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 3.99, '49', '4907', '2020-03-05 21:00:00')
--568 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 7.99, '49', '4907', '2020-03-06 21:00:00')
--569 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 7.99, '49', '4907', '2020-03-13 21:00:00')
--570 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 7.99, '49', '4907', '2020-03-20 21:00:00')
--571 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 2.99, '49', '4907', '2020-03-24 21:00:00')
--572 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 19.99, '49', '4907', '2020-03-26 21:00:00')
--573 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 14.99, '49', '4907', '2020-03-26 21:00:00')
--574 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 8.99, '49', '4907', '2020-03-27 21:00:00')
--575 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 7.99, '49', '4907', '2020-03-27 21:00:00')
--576 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 2.99, '49', '4907', '2020-04-24 21:00:00')
--577 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 8.99, '49', '4907', '2020-04-27 21:00:00')
--578 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 14.99, '49', '4907', '2020-05-06 21:00:00')
--579 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-05-06 21:00:00')
--580 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 14.99, '49', '4907', '2020-05-10 21:00:00')
--581 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 14.99, '49', '4907', '2020-05-11 21:00:00')
--582 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 14.99, '49', '4907', '2020-05-11 21:00:00')
--583 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 29.99, '49', '4907', '2020-05-13 21:00:00')
--584 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 14.99, '49', '4907', '2020-05-14 21:00:00')
--585 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-05-14 21:00:00')
--586 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 14.99, '49', '4907', '2020-05-14 21:00:00')
--587 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 1.99, '49', '4907', '2020-05-14 21:00:00')
--588 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 29.99, '49', '4907', '2020-05-15 21:00:00')
--589 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 14.99, '49', '4907', '2020-05-18 21:00:00')
--590 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 14.99, '49', '4907', '2020-05-18 21:00:00')
--591 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 4.99, '49', '4907', '2020-05-19 21:00:00')
--592 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 14.99, '49', '4907', '2020-05-19 21:00:00')
--593 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 14.99, '49', '4907', '2020-05-19 21:00:00')
--594 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 4.99, '49', '4907', '2020-05-19 21:00:00')
--595 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 9.99, '49', '4907', '2020-05-20 21:00:00')
--596 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 9.99, '49', '4907', '2020-05-20 21:00:00')
--597 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 19.99, '49', '4907', '2020-05-20 21:00:00')
--598 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 19.99, '49', '4907', '2020-05-20 21:00:00')
--599 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 19.99, '49', '4907', '2020-05-21 21:00:00')
--600 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 4.99, '49', '4907', '2020-05-21 21:00:00')
--601 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 9.99, '49', '4907', '2020-05-22 21:00:00')
--602 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 2.99, '49', '4907', '2020-05-24 21:00:00')
--603 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 8.99, '49', '4907', '2020-05-27 21:00:00')
--604 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 9.99, '49', '4907', '2020-05-27 21:00:00')
--605 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 4.99, '49', '4907', '2020-05-28 21:00:00')
--606 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 14.99, '49', '4907', '2020-05-28 21:00:00')
--607 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 4.99, '49', '4907', '2020-05-28 21:00:00')
--608 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 6.99, '49', '4907', '2020-05-28 21:00:00')
--609 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 19.99, '49', '4907', '2020-05-28 21:00:00')
--610 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 2.99, '49', '4907', '2020-05-28 21:00:00')
--611 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 9.99, '49', '4907', '2020-05-28 21:00:00')
--612 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 9.99, '49', '4907', '2020-05-28 21:00:00')
--613 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 4.99, '49', '4907', '2020-05-28 21:00:00')
--614 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 8.99, '49', '4907', '2020-05-29 21:00:00')
--615 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 4.99, '49', '4907', '2020-05-29 21:00:00')
--616 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 9.99, '49', '4907', '2020-05-30 21:00:00')
--617 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 4.99, '49', '4907', '2020-05-31 21:00:00')
--618 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 9.99, '49', '4907', '2020-05-31 21:00:00')
--619 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 4.99, '49', '4907', '2020-05-31 21:00:00')
--620 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 4.99, '49', '4907', '2020-05-31 21:00:00')
--621 
INSERT INTO TransactionCreationTempData (TxnAcctId, AccountNumber, TransactionAmount, CMTTranType, ActualTranCode, TranTime) VALUES (2436874, '1100011124369822', 4.99, '49', '4907', '2020-05-31 21:00:00')
