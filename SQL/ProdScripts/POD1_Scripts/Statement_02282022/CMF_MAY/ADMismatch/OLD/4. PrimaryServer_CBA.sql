-- TO BE RUN ON PRIMARY SERVER ONLY



USE CCGS_CoreIssue
GO


BEGIN TRANSACTION
COMMIT TRANSACTION
-- ROLLBACK TRANSACTION

UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = '3.10' WHERE AID = 53511881 AND ATID = 52 AND IdentityField = 2530157772

UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '4.66' WHERE AID = 1742986 AND ATID = 51 AND IdentityField = 1511530255

UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = '1.36' WHERE AID = 53525762 AND ATID = 52 AND IdentityField = 2535546113

UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = '0.52' WHERE AID = 53566038 AND ATID = 52 AND IdentityField = 2538967687

UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '19.97' WHERE AID = 3211712 AND ATID = 51 AND IdentityField = 1516453896

UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '3' WHERE AID = 311669 AND ATID = 51 AND IdentityField = 1505929757
UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '187.64' WHERE AID = 311669 AND ATID = 51 AND IdentityField = 1505929758
INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue) VALUES
(0,'2021-05-31 23:59:57.000',51,311669,'112','2','15991')


UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = '1.18' WHERE AID = 53517848 AND ATID = 52 AND IdentityField = 2543943388

UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = '0.52' WHERE AID = 53543938 AND ATID = 52 AND IdentityField = 2549177261


UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '32.19' WHERE AID = 13004403 AND ATID = 51 AND IdentityField = 1523797824


INSERT INTO CurrentBalanceAuditPS (tid,businessday,atid,aid,dename,oldvalue,newvalue) VALUES
(0,'2021-05-31 23:59:57.000',52,10449489,'200','0.00','58.73'),
(0,'2021-05-31 23:59:57.000',52,10449489,'115','0','1')


UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '432.41' WHERE AID = 7493132 AND ATID = 51 AND IdentityField = 1519998183
INSERT INTO CurrentBalanceAudit (tid,businessday,atid,aid,dename,oldvalue,newvalue) VALUES
(0,'2021-05-31 23:59:57.000',51,7493132,'115','0','1')
