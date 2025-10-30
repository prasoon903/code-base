USE PARASHAR_CB_CI
delete from cbreportingdetail
delete from cbrjobsdetail
delete from cbreportingcontrol

select * From cbreportingdetail with(nolock)  where  acctId = 167414
select * From cbrjobsdetail with(nolock) WHERE jobstatus=0
select * From cbreportingcontrol with(nolock) where jobstatus=0 
SELECT * from orgaccounts with(nolock)
SELECT AccountNumber,* from BSegment_Primary WHERE acctId IN (5000,5001)

CBR_Extract CBR
CBR_Credit Bureau Reporting

use master

searchcolumn CIDEffectiveDate