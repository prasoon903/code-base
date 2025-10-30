-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION
--COMMIT TRANSACTION
--ROLLBACK TRANSACTION


UPDATE CreateNewSingleTransactionData SET TranTime = '2021-03-31 13:05:22' WHERE AccountNumber =  '1100011101694283' AND TransactionStatus = 1

UPDATE CreateNewSingleTransactionData SET TranTime = '2021-03-30 10:50:36' WHERE AccountNumber =  '1100011111231464' AND TransactionStatus = 1

UPDATE CreateNewSingleTransactionData SET TranTime = '2021-04-22 16:18:38' WHERE AccountNumber =  '1100011111256180' AND TransactionStatus = 1

UPDATE CreateNewSingleTransactionData SET TranTime = '2021-04-27 12:15:28' WHERE AccountNumber =  '1100011114648656' AND TransactionStatus = 1

UPDATE CreateNewSingleTransactionData SET TranTime = '2021-02-04 18:44:46' WHERE AccountNumber =  '1100011135061319' AND TransactionStatus = 1

UPDATE CreateNewSingleTransactionData SET TranTime = '2021-02-08 16:12:23' WHERE AccountNumber =  '1100011135061319' AND TransactionStatus = 1 AND Skey = 36478

UPDATE CreateNewSingleTransactionData SET TranTime = '2021-02-08 16:12:23' WHERE AccountNumber =  '1100011135061319' AND TransactionStatus = 1 AND Skey = 36480

UPDATE CreateNewSingleTransactionData SET TranTime = '2021-04-01 13:26:08.000' WHERE AccountNumber =  '1100011116402961' AND TransactionStatus = 1

UPDATE CreateNewSingleTransactionData SET TranTime = '2021-04-21 07:39:23.000' WHERE AccountNumber =  '1100011116798525' AND TransactionStatus = 1

UPDATE CreateNewSingleTransactionData SET TranTime = '2021-04-21 07:39:23.000' WHERE AccountNumber =  '1100011119406175' AND TransactionStatus = 1

UPDATE CreateNewSingleTransactionData SET TranTime = '2021-04-29 18:12:14.000' WHERE AccountNumber =  '1100011119533713' AND TransactionStatus = 1

UPDATE CreateNewSingleTransactionData SET TranTime = '2021-04-13 16:28:05.000' WHERE AccountNumber =  '1100011120331479' AND TransactionStatus = 1

UPDATE CreateNewSingleTransactionData SET TranTime = '2021-03-27 15:54:19.000' WHERE AccountNumber =  '1100011126597107' AND TransactionStatus = 1

UPDATE CreateNewSingleTransactionData SET TranTime = '2021-04-20 15:40:48.000' WHERE AccountNumber =  '1100011131648085' AND TransactionStatus = 1

UPDATE CreateNewSingleTransactionData SET TranTime = '2021-04-02 10:18:17.000' WHERE AccountNumber =  '1100011132015714' AND TransactionStatus = 1

UPDATE CreateNewSingleTransactionData SET TranTime = '2021-03-29 18:02:18.000' WHERE AccountNumber =  '1100011133155840' AND TransactionStatus = 1

UPDATE CreateNewSingleTransactionData SET TranTime = '2021-03-31 13:21:47.000' WHERE AccountNumber =  '1100011136946682' AND TransactionStatus = 1

UPDATE CreateNewSingleTransactionData SET TranTime = '2021-03-29 10:11:34.000' WHERE AccountNumber =  '1100011136946682' AND TransactionStatus = 1 AND Skey = 36498

UPDATE CreateNewSingleTransactionData SET TranTime = '2021-04-24 06:26:48.000' WHERE AccountNumber =  '1100011143738874' AND TransactionStatus = 1



/*
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-03-31 13:05:22' WHERE AccountNumber =  '1100011101694283' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-01 13:21:52' WHERE AccountNumber =  '1100011102303595' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-21 20:57:58' WHERE AccountNumber =  '1100011102436536' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-12 00:02:45' WHERE AccountNumber =  '1100011102812397' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-01-06 20:42:26' WHERE AccountNumber =  '1100011103001222' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-07 09:46:07' WHERE AccountNumber =  '1100011103608760' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-03 11:58:37' WHERE AccountNumber =  '1100011103962639' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-01 05:46:36' WHERE AccountNumber =  '1100011103964569' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-27 05:47:12' WHERE AccountNumber =  '1100011104131564' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-30 17:21:55' WHERE AccountNumber =  '1100011104271733' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2020-12-20 22:30:25' WHERE AccountNumber =  '1100011104400571' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-26 21:47:35' WHERE AccountNumber =  '1100011104558949' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-29 07:27:22' WHERE AccountNumber =  '1100011104817584' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-26 21:12:34' WHERE AccountNumber =  '1100011105042174' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-11 22:10:35' WHERE AccountNumber =  '1100011105055796' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-21 09:00:39' WHERE AccountNumber =  '1100011105358372' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-03-29 12:34:35' WHERE AccountNumber =  '1100011105385045' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-27 21:50:52' WHERE AccountNumber =  '1100011105480218' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-29 12:26:53' WHERE AccountNumber =  '1100011105485795' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-01 13:37:11' WHERE AccountNumber =  '1100011105507457' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-02-23 05:48:44' WHERE AccountNumber =  '1100011105610376' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-26 21:13:47' WHERE AccountNumber =  '1100011105899482' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-03-09 09:08:08' WHERE AccountNumber =  '1100011107119939' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-22 10:40:49' WHERE AccountNumber =  '1100011107144549' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-02 06:25:49' WHERE AccountNumber =  '1100011107173423' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-03-29 12:58:16' WHERE AccountNumber =  '1100011107464939' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-03-23 14:31:37' WHERE AccountNumber =  '1100011107884326' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-27 12:18:14' WHERE AccountNumber =  '1100011107983169' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-29 14:11:44' WHERE AccountNumber =  '1100011108394614' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-30 18:25:53' WHERE AccountNumber =  '1100011108893839' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-08 15:46:05' WHERE AccountNumber =  '1100011109262141' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-13 17:48:32' WHERE AccountNumber =  '1100011109964969' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-15 09:40:32' WHERE AccountNumber =  '1100011110461229' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-03-22 09:33:03' WHERE AccountNumber =  '1100011110473216' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-21 08:41:52' WHERE AccountNumber =  '1100011110579202' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-22 12:55:11' WHERE AccountNumber =  '1100011110633728' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-03-30 10:55:32' WHERE AccountNumber =  '1100011111231464' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-22 16:18:38' WHERE AccountNumber =  '1100011111256180' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-03 06:40:27' WHERE AccountNumber =  '1100011112392356' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-28 07:02:11' WHERE AccountNumber =  '1100011112594969' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-06 09:49:48' WHERE AccountNumber =  '1100011112986900' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-01 22:11:01' WHERE AccountNumber =  '1100011113168557' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-21 05:56:51' WHERE AccountNumber =  '1100011113223824' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-03-31 20:58:05' WHERE AccountNumber =  '1100011113266641' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-26 22:13:30' WHERE AccountNumber =  '1100011113554657' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-01-01 07:46:57' WHERE AccountNumber =  '1100011113559789' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-24 10:14:24' WHERE AccountNumber =  '1100011113623437' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-12 00:02:45' WHERE AccountNumber =  '1100011114060456' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-10 15:23:33' WHERE AccountNumber =  '1100011114284114' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-28 08:23:35' WHERE AccountNumber =  '1100011114570785' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-27 13:10:48' WHERE AccountNumber =  '1100011114648656' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-27 13:13:43' WHERE AccountNumber =  '1100011114777935' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-20 13:34:35' WHERE AccountNumber =  '1100011114784196' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-19 18:07:01' WHERE AccountNumber =  '1100011115215943' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-20 13:26:00' WHERE AccountNumber =  '1100011115924999' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-01 13:33:22' WHERE AccountNumber =  '1100011116402961' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-02 14:09:41' WHERE AccountNumber =  '1100011116424494' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-21 17:44:30' WHERE AccountNumber =  '1100011116798525' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-28 12:50:16' WHERE AccountNumber =  '1100011116868526' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-03-12 05:51:32' WHERE AccountNumber =  '1100011116882071' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-29 16:36:22' WHERE AccountNumber =  '1100011117133102' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-19 09:39:04' WHERE AccountNumber =  '1100011117282883' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-25 05:11:09' WHERE AccountNumber =  '1100011117485783' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-13 15:40:53' WHERE AccountNumber =  '1100011117979082' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-08 15:44:32' WHERE AccountNumber =  '1100011118390024' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-29 13:09:24' WHERE AccountNumber =  '1100011118752173' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-03-31 16:13:39' WHERE AccountNumber =  '1100011118967375' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-22 15:25:37' WHERE AccountNumber =  '1100011119027872' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-23 06:16:13' WHERE AccountNumber =  '1100011119229130' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-30 21:16:00' WHERE AccountNumber =  '1100011119310831' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-11 18:30:15' WHERE AccountNumber =  '1100011119406175' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-30 18:59:22' WHERE AccountNumber =  '1100011119451106' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-28 20:25:17' WHERE AccountNumber =  '1100011119478463' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-05-18 16:12:05' WHERE AccountNumber =  '1100011119533713' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-13 20:47:39' WHERE AccountNumber =  '1100011119741548' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-13 16:28:05' WHERE AccountNumber =  '1100011120331479' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-01 13:52:03' WHERE AccountNumber =  '1100011121784072' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-26 22:22:09' WHERE AccountNumber =  '1100011121872794' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2020-12-17 06:07:05' WHERE AccountNumber =  '1100011122273414' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-26 17:40:25' WHERE AccountNumber =  '1100011122347523' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-02 07:10:06' WHERE AccountNumber =  '1100011122553583' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-22 14:08:21' WHERE AccountNumber =  '1100011122757036' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-30 12:25:40' WHERE AccountNumber =  '1100011123780888' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-12 14:38:10' WHERE AccountNumber =  '1100011124226303' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-29 14:09:57' WHERE AccountNumber =  '1100011124457353' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-02-10 05:33:18' WHERE AccountNumber =  '1100011124638077' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-21 05:54:20' WHERE AccountNumber =  '1100011124789631' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-12 00:02:45' WHERE AccountNumber =  '1100011124955877' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-01 12:56:14' WHERE AccountNumber =  '1100011125354427' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-05 00:58:41' WHERE AccountNumber =  '1100011126139587' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-03-28 12:36:40' WHERE AccountNumber =  '1100011126597107' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-26 18:44:37' WHERE AccountNumber =  '1100011126639842' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-03-24 16:42:40' WHERE AccountNumber =  '1100011128164427' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-03-24 20:53:03' WHERE AccountNumber =  '1100011128185901' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-29 07:22:35' WHERE AccountNumber =  '1100011128724279' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-02 06:20:08' WHERE AccountNumber =  '1100011128887191' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-21 22:08:33' WHERE AccountNumber =  '1100011129009399' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-02 06:07:32' WHERE AccountNumber =  '1100011129278721' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-03 18:55:57' WHERE AccountNumber =  '1100011129462226' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-20 15:40:48' WHERE AccountNumber =  '1100011131648085' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-01 08:00:14' WHERE AccountNumber =  '1100011132196332' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-02 10:18:17' WHERE AccountNumber =  '1100011132015714' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-29 15:58:20' WHERE AccountNumber =  '1100011132398359' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-06 10:18:50' WHERE AccountNumber =  '1100011132422829' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-16 12:36:05' WHERE AccountNumber =  '1100011133041560' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-03-29 18:02:20' WHERE AccountNumber =  '1100011133155840' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-03-22 14:51:11' WHERE AccountNumber =  '1100011133238760' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-27 11:47:22' WHERE AccountNumber =  '1100011134162282' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-03-31 11:10:24' WHERE AccountNumber =  '1100011134360274' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-19 22:10:00' WHERE AccountNumber =  '1100011134390909' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-01-03 22:36:47' WHERE AccountNumber =  '1100011134408727' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-03-27 18:58:05' WHERE AccountNumber =  '1100011134700750' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-26 21:41:41' WHERE AccountNumber =  '1100011135340507' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-29 11:19:33' WHERE AccountNumber =  '1100011135446817' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-02-08 17:20:28' WHERE AccountNumber =  '1100011135061319' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-03 08:45:46' WHERE AccountNumber =  '1100011135135014' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-03-31 14:10:28' WHERE AccountNumber =  '1100011135242299' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-28 14:01:20' WHERE AccountNumber =  '1100011135900524' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-28 12:46:21' WHERE AccountNumber =  '1100011135846370' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-09 12:46:41' WHERE AccountNumber =  '1100011135623456' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-30 12:06:18' WHERE AccountNumber =  '1100011135980948' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-03-30 16:28:13' WHERE AccountNumber =  '1100011136020959' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-20 06:11:21' WHERE AccountNumber =  '1100011136110073' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-28 14:20:42' WHERE AccountNumber =  '1100011136514928' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-28 12:55:04' WHERE AccountNumber =  '1100011136639055' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-01 19:55:25' WHERE AccountNumber =  '1100011138116011' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-28 14:56:41' WHERE AccountNumber =  '1100011138058791' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-05-25 14:40:47' WHERE AccountNumber =  '1100011136891771' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-03-31 13:22:15' WHERE AccountNumber =  '1100011136946682' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-26 15:42:06' WHERE AccountNumber =  '1100011137188326' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-23 10:58:13' WHERE AccountNumber =  '1100011139074342' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-01 14:58:40' WHERE AccountNumber =  '1100011140126446' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-22 08:43:04' WHERE AccountNumber =  '1100011140233119' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-03-23 09:56:26' WHERE AccountNumber =  '1100011140526108' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-28 16:34:41' WHERE AccountNumber =  '1100011140828405' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-01 09:54:40' WHERE AccountNumber =  '1100011141147631' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-07 11:43:04' WHERE AccountNumber =  '1100011141504625' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-24 06:26:48' WHERE AccountNumber =  '1100011143738874' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-13 18:20:50' WHERE AccountNumber =  '1100011144744475' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-26 11:27:13' WHERE AccountNumber =  '1100011145787697' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-03-22 20:59:05' WHERE AccountNumber =  '1100011146059773' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-20 20:44:25' WHERE AccountNumber =  '1100011147048833' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-27 17:30:45' WHERE AccountNumber =  '1100011147058329' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-03-17 05:44:47' WHERE AccountNumber =  '1100011147963254' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-27 13:03:38' WHERE AccountNumber =  '1100011148511268' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-20 21:25:13' WHERE AccountNumber =  '1100011148895232' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-29 14:51:53' WHERE AccountNumber =  '1100011148845476' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-13 17:15:49' WHERE AccountNumber =  '1100011149253365' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-07 09:38:33' WHERE AccountNumber =  '1100011151254863' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-17 07:42:27' WHERE AccountNumber =  '1100011152382358' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-10 13:34:17' WHERE AccountNumber =  '1100011154411502' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-11 22:11:08' WHERE AccountNumber =  '1100011155059912' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-01 18:09:28' WHERE AccountNumber =  '1100011155807526' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-15 12:12:53' WHERE AccountNumber =  '1100011156481933' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-07 08:20:20' WHERE AccountNumber =  '1100011157376843' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-29 15:53:48' WHERE AccountNumber =  '1100011157502000' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-03-29 12:32:59' WHERE AccountNumber =  '1100011157836150' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2020-12-26 14:14:07' WHERE AccountNumber =  '1100011157942701' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-29 03:55:10' WHERE AccountNumber =  '1100011158146724' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-30 17:28:23' WHERE AccountNumber =  '1100011158181374' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-07 05:56:47' WHERE AccountNumber =  '1100011158618326' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-26 16:10:33' WHERE AccountNumber =  '1100011159126535' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-04-16 12:43:07' WHERE AccountNumber =  '1100011162452506' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-03-31 06:27:11' WHERE AccountNumber =  '1100011167224330' AND TransactionStatus = 1
UPDATE TOP(1) CreateNewSingleTransactionData SET TranTime = '2021-03-29 06:12:08' WHERE AccountNumber =  '1100011168819658' AND TransactionStatus = 1*/