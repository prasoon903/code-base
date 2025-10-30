select COUNT(1) from LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.IntradayAccountOTBRule_archieve WITH (NOLOCK)
WHERE ProcessingTime IS NULL

select * from sys.servers

SELECT COUNT(1) FROM LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.CommonTNP WITH (NOLOCK) WHERE TranTime < GETDATE()

select TOP 10 * from LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.IntradayAccountOTBRule_Internal WITH (NOLOCK) order by skey desc

select TOP 10 * from LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.paymentholdfileprocessing with (nolock) order by skey desc

select TOP 10 * from LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.IntradayAccountOTBRule_Internal WITH (NOLOCK) where filename = 'IntraDayAccountOTBRule_20200812.csv' order by startdate desc

select COUNT(1) from LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.IntradayAccountOTBRule_Internal WITH (NOLOCK) where filename = 'IntraDayAccountOTBRule_20200812.csv'

select COUNT(1), filename from LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.IntradayAccountOTBRule_Internal WITH (NOLOCK) group by filename order by filename desc

select COUNT(1) from LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.intradayaccountotbrule_external_g2 WITH (NOLOCK) where filename = 'IntraDayAccountOTBRule_20210329_1.csv'


select TOP 10 * from LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.intradayaccountotbrule_external_g2 WITH (NOLOCK)

select COUNT(1) from LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.IntradayAccountOTBRule_Internal WITH (NOLOCK) where filename = 'IntraDayAccountOTBRule_20210329.csv'




select TOP 10 * from LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.IntradayAccountOTBRule_archieve WITH (NOLOCK) where filename = 'IntraDayAccountOTBRule_20191229.csv' order by startdate desc
select TOP 10 * from LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.IntradayAccountOTBRule_archieve WITH (NOLOCK) where filename = 'IntraDayAccountOTBRule_20191228.csv' order by startdate desc

select COUNT(1), HeldDays_LessThanIntradayThreshhold, HeldDays_GreaterThanIntradayThreshhold 
from LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.IntradayAccountOTBRule_Internal WITH (NOLOCK) 
where filename = 'IntraDayAccountOTBRule_20191229.csv'
group by HeldDays_LessThanIntradayThreshhold, HeldDays_GreaterThanIntradayThreshhold

select COUNT(1), HeldDays_LessThanIntradayThreshhold, HeldDays_GreaterThanIntradayThreshhold 
from LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.IntradayAccountOTBRule_archieve WITH (NOLOCK) 
where filename = 'IntraDayAccountOTBRule_20191229.csv'
group by HeldDays_LessThanIntradayThreshhold, HeldDays_GreaterThanIntradayThreshhold

select ITA.IntradayThreshholdAmount, CP.TransactionAmount, ITA.HeldDays_LessThanIntradayThreshhold, ITA.HeldDays_GreaterThanIntradayThreshhold
from LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.IntradayAccountOTBRule_archieve ITA WITH (NOLOCK)
JOIN LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.CCard_Primary CP WITH (NOLOCK) ON (CP.AccountNumber = ITA.AccountNumber)
WHERE ITA.filename = 'IntraDayAccountOTBRule_20191229.csv' AND CP.cmttrantype = '21' and CP.posttime >= '2020-12-29 05:59:00' and CP.posttime < '2020-12-30 06:54:00'
--AND CP.TransactionAmount < ITA.IntradayThreshholdAmount
--AND (CP.TransactionAmount < ITA.IntradayThreshholdAmount AND ITA.HeldDays_LessThanIntradayThreshhold = 2) 
AND (CP.TransactionAmount > ITA.IntradayThreshholdAmount AND ITA.HeldDays_GreaterThanIntradayThreshhold = 2)



select COUNT(1)
from LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.IntradayAccountOTBRule_Internal ITA WITH (NOLOCK)
JOIN LS_PRODDRGSDB01.CCGS_CoreIssue.dbo.CCard_Primary CP WITH (NOLOCK) ON (CP.AccountNumber = ITA.AccountNumber)
WHERE ITA.filename = 'IntraDayAccountOTBRule_20191229.csv' AND CP.cmttrantype = '21' and CP.posttime >= '2020-12-29 05:59:00' and CP.posttime < '2020-12-30 06:54:00'
--AND CP.TransactionAmount < ITA.IntradayThreshholdAmount
AND (CP.TransactionAmount < ITA.IntradayThreshholdAmount AND ITA.HeldDays_LessThanIntradayThreshhold = 2) 
--AND (CP.TransactionAmount > ITA.IntradayThreshholdAmount AND ITA.HeldDays_GreaterThanIntradayThreshhold = 2)





select Transactionamount,* from ccard_primary with (nolock) where cmttrantype = '21' and posttime >= '2019-12-29' and posttime < '2019-12-30'

--IntraDayAccountOTBRule_20191230.csv
-- 28326 + 9

IntradayThreshholdAmount
7500.00