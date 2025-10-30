
Begin Tran 
-- Rollback 
--- Commit 
update CPSgmentCreditCard set srbwithinstallmentdue = srbwithinstallmentdue + 19.45 , sbwithinstallmentdue = sbwithinstallmentdue + 1945 where acctid = 2986678
--1 Row 
update CPSgmentCreditCard set srbwithinstallmentdue = srbwithinstallmentdue - 19.45 where acctid = 9634150
-- 1 row 
update BSegmentCreditCard set statementremainingbalance = statementremainingbalance + 1945, sbwithinstallmentdue = sbwithinstallmentdue + 204.29 where acctid = 2805178
-- 1 row 
update bsegment_secondary  set  recoveryfeesbnp =recoveryfeesbnp - 19.45 where acctid = 2805178
-- 1 row 
update bsegment_primary  set principal = principal +19.45  where acctid = 2805178
-- 1 row 
update cpsgmentaccounts  set DeCurrentBalance_TranTime_PS = (DeCurrentBalance_TranTime_PS + 19.45)- 1945,  principal = principal +19.45 ,currentbalance = (currentbalance  + 19.45)- 1945   where acctid = 2986678
-- 1 row 
update cpsgmentaccounts  set DeCurrentBalance_TranTime_PS = DeCurrentBalance_TranTime_PS - 19.45,  recoveryfeesbnp = recoveryfeesbnp-19.45 ,currentbalance = currentbalance - 19.45    where acctid = 9634150
-- 1 row 

update currentbalanceauditps  set newvalue =  (newvalue + 19.45)- 1945 where dename = '111' and aid = 2986678  and identityfield = 734665665
-- 1 row 
update currentbalanceauditps  set newvalue =  newvalue + 19.45 where dename = '120' and aid = 2986678  and identityfield = 734665664
-- 1 row 
update currentbalanceauditps  set newvalue =  newvalue - 19.45  where dename = '111' and aid = 9634150  and identityfield = 734665668
-- 1 row 

Delete from currentbalanceaudit where identityfield in (458404224,458404236) and aid = 2805178
-- 2 Row 


--select srbwithinstallmentdue,sbwithinstallmentdue  from CPSgmentCreditCard with(nolock)  where acctid = 2986678
--select srbwithinstallmentdue,sbwithinstallmentdue  from CPSgmentCreditCard with(nolock)  where acctid = 9634150
--select statementremainingbalance,sbwithinstallmentdue,srbwithinstallmentdue  from BSegmentCreditCard with(nolock)  where acctid = 2805178
--select currentbalance,principal,principal +19.45  from bsegment_primary with(nolock)  where acctid = 2805178
--select recoveryfeesbnp,recoveryfeesbnp - 19.45  from bsegment_secondary with(nolock)  where acctid = 2805178
--select DeCurrentBalance_TranTime_PS,principal,currentbalance, (DeCurrentBalance_TranTime_PS + 19.45)- 1945, principal +19.45  from cpsgmentaccounts with(nolock)  where acctid = 2986678
--select DeCurrentBalance_TranTime_PS,principal,currentbalance, DeCurrentBalance_TranTime_PS - 19.45,recoveryfeesbnp-19.45  from cpsgmentaccounts with(nolock)  where acctid = 9634150


--select * from currentbalanceauditps with (nolock) where aid = 9634150 order by businessday desc --27921892298
--select * from currentbalanceauditps with (nolock)where dename = '111' and aid = 2986678  and identityfield = 734665665
--select * from currentbalanceauditps with (nolock)where dename = '120' and aid = 2986678  and identityfield = 734665664
--select * from currentbalanceauditps with (nolock) where dename = '111' and aid = 9634150  and identityfield = 734665668

