----EOD Skip

SELECT * FROM CommonTNP ct WITH (NOLOCK) WHERE ct.ATID = 60

SELECT DATEDIFF(SECOND, aa.ProcDayStart, aa.ProcDayEnd) ,* FROM ARSystemAccounts aa WITH (NOLOCK) 

SELECT DATEDIFF(SECOND, ah.ProcDayStart, ah.ProcDayEnd) ,* FROM ARSystemHSAccounts ah WITH (NOLOCK) 



--update commontnp set TranTime = '2018-05-01 23:59:57.000' , tnpdate = '2018-05-01 00:00:00.000', priority = 99999 where atid = 60 

--UPDATE ARSYSTEMACCOUNTS SET LAD = '2018-05-01 23:59:58.000', LAPD = '2018-05-01 23:59:58.000', NAD = '2018-05-02 23:59:57.000', ProcDayStart = '2018-05-01 23:59:58.000', ProcDayEnd = '2018-05-02 23:59:57.000' 


--UPDATE ARSystemHSAccounts SET LAD = '2018-05-01 23:59:37.000', LAPD = '2018-05-01 23:59:37.000',
--ProcDayStart = '2018-05-01 23:59:48.000', ProcDayEnd = '2018-02-01 23:59:47.000' 

-- to age normally
-- update only ARSystemHSAccounts

--use kk_ci


DECLARE @ProcDay DATETIME = '2018-02-28'

UPDATE ARSystemHSAccounts SET LAD = DATEADD(SECOND, -5, @ProcDay), LAPD = DATEADD(SECOND, -5, @ProcDay), 
ProcDayStart = DATEADD(SECOND, -5, @ProcDay), ProcDayEnd = DATEADD(SECOND, 86394, @ProcDay)
