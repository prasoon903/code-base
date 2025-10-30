
BEGIN TRAN
--COMMIT TRAN
--ROLLBACK TRAN


INSERT INTO CurrentBalanceaudit (tid,businessday, atid,aid, dename, oldvalue, newvalue)
                         VALUES (91512886506, '2023-07-21 10:38:03.000', 51, 18310733,112,'15991','2')
INSERT INTO CurrentBalanceaudit (tid,businessday, atid,aid, dename, oldvalue, newvalue)
                         VALUES (91512886506, '2023-07-21 10:38:03.000', 51, 18310733,115,'3','1')
UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '44.29' WHERE AID = 18310733 AND ATID = 51 AND IdentityField = 5513091369



INSERT INTO CurrentBalanceaudit (tid,businessday, atid,aid, dename, oldvalue, newvalue)
                         VALUES (90920879704, '2023-07-10 10:21:05.000', 51, 21471284,112,'3','2')
INSERT INTO CurrentBalanceaudit (tid,businessday, atid,aid, dename, oldvalue, newvalue)
                         VALUES (90920879704, '2023-07-10 10:21:05.000', 51, 21471284,115,'2','0')



