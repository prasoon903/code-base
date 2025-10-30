
BEGIN TRANSACTION

INSERT INTO currentbalanceaudit (tid, businessday,atid ,aid, dename, oldvalue, newvalue)
VALUES (34544192648,'2021-01-14 10:05:04.000',51,4839430, '115','8','0')
INSERT INTO currentbalanceaudit (tid, businessday,atid ,aid, dename, oldvalue, newvalue)
VALUES (37476640878,'2021-03-31 20:21:54.000',51,7700555, '115','1','0')

INSERT INTO currentbalanceauditps (tid, businessday,atid ,aid, dename, oldvalue, newvalue)
VALUES (34544192648,'2021-01-14 10:05:04.000',52,10059588, '115','8','0')
INSERT INTO currentbalanceauditps (tid, businessday,atid ,aid, dename, oldvalue, newvalue)
VALUES (37476640878,'2021-03-31 20:21:54.000',52,20515804, '115','1','0')
INSERT INTO currentbalanceauditps (tid, businessday,atid ,aid, dename, oldvalue, newvalue)
VALUES (35442311575,'2021-02-05 09:00:41.000',52,34730680, '115','1','0')

--commit
--rollback

BEGIN TRANSACTION

update currentbalanceauditps set newvalue = '0.00' where identityfield = 2113313705 and atid = 52 and aid = 20515804 and dename = '200'
update currentbalanceaudit set newvalue = '0.00' where aid = 7700555 and atid = 51 and identityfield = 1270544319 and dename = '200'
update currentbalanceaudit set oldvalue = '0.00', newvalue = '68.07' where aid = 12833157 and atid = 51 and identityfield = 1289447302 and dename = '200'
update currentbalanceaudit set oldvalue = '0', newvalue = '1' where aid = 12833157 and atid = 51 and identityfield = 1289447301 and dename = '115'

--commit
--rollback

BEGIN TRANSACTION

delete from currentbalanceauditps where identityfield = 2135104068 and atid = 52 and aid = 20515804 and dename = '115' and tid = 0
delete from currentbalanceauditps where identityfield in (2140366653,2094104512,1945584261,1784329889) and atid = 52 and aid = 34730680 and dename = '115'
delete from currentbalanceaudit where aid = 7700555 and tid = 51 and identityfield in (1286218032,1271289833) and dename in ('115','200')

--commit
--rollback





