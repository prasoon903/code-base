-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION
--COMMIT TRANSACTION
--ROLLBACK TRANSACTION

UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2020-09-11 23:50:08' WHERE AccountNumber =  '1100011119320798' AND Skey = 36871

UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2020-09-11 06:12:37' WHERE AccountNumber =  '1100011119320798' AND Skey = 36855
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2020-09-11 05:57:36' WHERE AccountNumber =  '1100011119320798' AND Skey = 36856
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2020-09-11 05:42:31' WHERE AccountNumber =  '1100011119320798' AND Skey = 36857
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2020-09-11 05:27:29' WHERE AccountNumber =  '1100011119320798' AND Skey = 36858
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2020-09-11 05:12:24' WHERE AccountNumber =  '1100011119320798' AND Skey = 36859
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2020-09-11 04:42:16' WHERE AccountNumber =  '1100011119320798' AND Skey = 36861
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2020-09-11 04:27:11' WHERE AccountNumber =  '1100011119320798' AND Skey = 36862
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2020-09-11 03:57:02' WHERE AccountNumber =  '1100011119320798' AND Skey = 36863
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2020-09-11 03:11:51' WHERE AccountNumber =  '1100011119320798' AND Skey = 36864
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2020-09-11 02:41:45' WHERE AccountNumber =  '1100011119320798' AND Skey = 36865
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2020-09-11 01:39:41' WHERE AccountNumber =  '1100011119320798' AND Skey = 36866
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2020-09-11 01:09:20' WHERE AccountNumber =  '1100011119320798' AND Skey = 36867
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2020-09-11 00:54:10' WHERE AccountNumber =  '1100011119320798' AND Skey = 36868
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2020-09-10 23:50:17' WHERE AccountNumber =  '1100011119320798' AND Skey = 36869
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2020-09-10 23:50:07' WHERE AccountNumber =  '1100011119320798' AND Skey = 36870
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2020-09-10 23:50:01' WHERE AccountNumber =  '1100011119320798' AND Skey = 36872
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2020-09-10 23:49:57' WHERE AccountNumber =  '1100011119320798' AND Skey = 36873
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2020-09-10 23:49:53' WHERE AccountNumber =  '1100011119320798' AND Skey = 36874
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2020-09-10 23:35:12' WHERE AccountNumber =  '1100011119320798' AND Skey = 36875
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2020-09-10 23:34:53' WHERE AccountNumber =  '1100011119320798' AND Skey = 36876

/*
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2019-06-03 07:30:07' WHERE AccountNumber =  '1100000100229787' AND TransactionStatus = 1 AND Transactionamount = 31.50
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2019-08-25 02:23:07' WHERE AccountNumber =  '1100011100311459' AND TransactionStatus = 1 AND Transactionamount = 379.75
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2019-05-24 05:19:18' WHERE AccountNumber =  '1100011100358153' AND TransactionStatus = 1 AND Transactionamount = 59.18
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2020-08-25 13:56:06' WHERE AccountNumber =  '1100011101074452' AND TransactionStatus = 1 AND Transactionamount = 420.00
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2020-07-02 04:01:45' WHERE AccountNumber =  '1100011101972754' AND TransactionStatus = 1 AND Transactionamount = 8.49
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2020-06-05 05:12:42' WHERE AccountNumber =  '1100011101977761' AND TransactionStatus = 1 AND Transactionamount = 84.00
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2020-07-05 19:56:11' WHERE AccountNumber =  '1100011102739624' AND TransactionStatus = 1 AND Transactionamount = 37.01
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2020-07-11 05:10:18' WHERE AccountNumber =  '1100011104780303' AND TransactionStatus = 1 AND Transactionamount = 16.47
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2020-06-28 20:38:41' WHERE AccountNumber =  '1100011104843556' AND TransactionStatus = 1 AND Transactionamount = 35.51
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2020-05-27 20:08:27' WHERE AccountNumber =  '1100011104963784' AND TransactionStatus = 1 AND Transactionamount = 5.00
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2020-06-29 05:38:46' WHERE AccountNumber =  '1100011107024873' AND TransactionStatus = 1 AND Transactionamount = 11.99
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2020-06-23 18:38:23' WHERE AccountNumber =  '1100011107615910' AND TransactionStatus = 1 AND Transactionamount = 0.11
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2020-07-01 17:38:27' WHERE AccountNumber =  '1100011108078761' AND TransactionStatus = 1 AND Transactionamount = 1.50
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2020-06-30 05:21:17' WHERE AccountNumber =  '1100011109125975' AND TransactionStatus = 1 AND Transactionamount = 2.10
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2020-07-15 05:11:54' WHERE AccountNumber =  '1100011111815951' AND TransactionStatus = 1 AND Transactionamount = 49.73
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2020-07-08 05:11:27' WHERE AccountNumber =  '1100011112882547' AND TransactionStatus = 1 AND Transactionamount = 8.35
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2020-06-28 14:21:00' WHERE AccountNumber =  '1100011115534509' AND TransactionStatus = 1 AND Transactionamount = 10.53
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2020-08-07 05:23:38' WHERE AccountNumber =  '1100011117055040' AND TransactionStatus = 1 AND Transactionamount = 12.99
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2020-12-09 04:46:01' WHERE AccountNumber =  '1100011118191422' AND TransactionStatus = 1 AND Transactionamount = 572.45
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2019-09-24 07:27:59' WHERE AccountNumber =  '1100011119263295' AND TransactionStatus = 1 AND Transactionamount = 44.99
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2020-09-12 03:10:33' WHERE AccountNumber =  '1100011119320798' AND TransactionStatus = 1 AND Transactionamount = 52.24
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2020-09-11 15:05:31' WHERE AccountNumber =  '1100011119320798' AND TransactionStatus = 1 AND Transactionamount = 104.49
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2020-06-23 20:20:16' WHERE AccountNumber =  '1100011119636524' AND TransactionStatus = 1 AND Transactionamount = 12.99
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2020-07-18 08:23:14' WHERE AccountNumber =  '1100011121370856' AND TransactionStatus = 1 AND Transactionamount = 35.69
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2020-07-15 20:23:38' WHERE AccountNumber =  '1100011122203684' AND TransactionStatus = 1 AND Transactionamount = 44.19
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2020-10-05 01:41:26' WHERE AccountNumber =  '1100011123183315' AND TransactionStatus = 1 AND Transactionamount = 12.49
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2020-01-04 05:28:54' WHERE AccountNumber =  '1100011124499793' AND TransactionStatus = 1 AND Transactionamount = 1.00
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2020-06-28 21:11:00' WHERE AccountNumber =  '1100011124733001' AND TransactionStatus = 1 AND Transactionamount = 41.98
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2020-07-11 10:00:51' WHERE AccountNumber =  '1100011127325052' AND TransactionStatus = 1 AND Transactionamount = 10.69
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2019-12-26 20:31:30' WHERE AccountNumber =  '1100011128486531' AND TransactionStatus = 1 AND Transactionamount = 4.95
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2020-06-06 05:27:14' WHERE AccountNumber =  '1100011128489139' AND TransactionStatus = 1 AND Transactionamount = 75.87
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2020-07-07 06:43:34' WHERE AccountNumber =  '1100011128524885' AND TransactionStatus = 1 AND Transactionamount = 3.00
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2020-08-08 05:39:07' WHERE AccountNumber =  '1100011129186841' AND TransactionStatus = 1 AND Transactionamount = 40.39
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2020-05-28 05:11:36' WHERE AccountNumber =  '1100011133702609' AND TransactionStatus = 1 AND Transactionamount = 29.00
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-02-02 00:02:45' WHERE AccountNumber =  '1100011133875652' AND TransactionStatus = 1 AND Transactionamount = 34.40
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2020-07-12 21:48:07' WHERE AccountNumber =  '1100011134301674' AND TransactionStatus = 1 AND Transactionamount = 40.73
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2020-06-05 20:24:01' WHERE AccountNumber =  '1100011138752849' AND TransactionStatus = 1 AND Transactionamount = 38.99
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2020-06-25 10:01:41' WHERE AccountNumber =  '1100011139341162' AND TransactionStatus = 1 AND Transactionamount = 10.54
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2020-07-22 08:35:53' WHERE AccountNumber =  '1100011139715399' AND TransactionStatus = 1 AND Transactionamount = 73.38
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2020-11-20 07:08:55' WHERE AccountNumber =  '1100011140454707' AND TransactionStatus = 1 AND Transactionamount = 450.00
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-01-05 06:08:53' WHERE AccountNumber =  '1100011141386668' AND TransactionStatus = 1 AND Transactionamount = 899.00
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2020-06-25 04:24:25' WHERE AccountNumber =  '1100011141515621' AND TransactionStatus = 1 AND Transactionamount = 159.00
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2020-06-16 19:04:32' WHERE AccountNumber =  '1100011141607782' AND TransactionStatus = 1 AND Transactionamount = 9.54
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2020-07-04 17:29:49' WHERE AccountNumber =  '1100011144217639' AND TransactionStatus = 1 AND Transactionamount = 164.15
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2020-06-24 13:56:45' WHERE AccountNumber =  '1100011144261926' AND TransactionStatus = 1 AND Transactionamount = 12.32
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2020-07-12 14:39:53' WHERE AccountNumber =  '1100011144925520' AND TransactionStatus = 1 AND Transactionamount = 11.13
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2020-08-13 08:44:52' WHERE AccountNumber =  '1100011145427906' AND TransactionStatus = 1 AND Transactionamount = 62.40
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-01-30 09:06:53' WHERE AccountNumber =  '1100011145518464' AND TransactionStatus = 1 AND Transactionamount = 9.99
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2020-10-02 07:40:38' WHERE AccountNumber =  '1100011145671800' AND TransactionStatus = 1 AND Transactionamount = 17.66
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2020-10-17 17:04:50' WHERE AccountNumber =  '1100011146535509' AND TransactionStatus = 1 AND Transactionamount = 1100.00
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2020-10-31 08:50:37' WHERE AccountNumber =  '1100011150975757' AND TransactionStatus = 1 AND Transactionamount = 29.99

*/