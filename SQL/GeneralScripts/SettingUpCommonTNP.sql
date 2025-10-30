use PARASHAR_CB_CI
USE PRASOON_CB_CI
USE PARASHAR_TEST
select * from version order by entryid desc


select COUNT(1),InstitutionID, BillingCycle from bsegment_primary with (nolock)
group by InstitutionID, BillingCycle
order by InstitutionID, BillingCycle 

select * from arsystemaccounts with (nolock) order by ProcDayEnd DESC

select * from arsystemhsaccounts with (nolock)

UPDATE arsystemhsaccounts SET InstitutionID = NULL

SELECT * from errortnp

SELECT * from Institutions

select * from  commontnp  with(nolock) where TranId <> 0

select * from  commontnp  with(nolock) 
where acctId = 167443--atid =60 
--and 
InstitutionID =3235 order by trantime desc

select count(1),trantime ,atid,priority from commontnp  with(nolock)
group by trantime ,atid,priority
order by trantime,priority,atid desc

--UPDATE commontnp SET tnpdate = '2017-08-16 00:00:00.000', TranTime = '2017-08-16 23:59:57.000' WHERE acctId = 167413 and TranId = 0
--DELETE FROM CommonTNP WHERE TranId = 123372036854777618

select * from XrefTable WHERE ChildATID = 13 and ChildAID = 30014

select * from XrefTable WHERE ParentATID = 13 and ParentAID = 2 and ChildATID = 16000

select * from sys.synonyms

--delete from commontnp where atid <>60 and acctid<>167447
--delete from commontnp where InstitutionID NOT IN (3189)
--Enable TRIGGER TR_PreventATID60Deletion ON commontnp
--Disable TRIGGER TR_PreventATID60Deletion ON commontnp

and acctid <>7435

use PARASHAR_CB_CI