-- TO BE RUN ON PRIMARY SERVER ONLY



USE CCGS_CoreIssue
GO


BEGIN TRANSACTION
COMMIT TRANSACTION
-- ROLLBACK TRANSACTION

UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = '21.44' WHERE AID = 745279 AND ATID = 52 AND IdentityField = 2752947995

UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = '32.47' WHERE AID = 576777 AND ATID = 52 AND IdentityField = 2751903082

UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = '24.93' WHERE AID = 514290 AND ATID = 52 AND IdentityField = 2751474951

UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = '24.77' WHERE AID = 1377978 AND ATID = 52 AND IdentityField = 2756352417

UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = '47.74' WHERE AID = 1643942 AND ATID = 52 AND IdentityField = 2757736697

UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = '23.91' WHERE AID = 1687039 AND ATID = 52 AND IdentityField = 2757964614

UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = '37.83' WHERE AID = 1869157 AND ATID = 52 AND IdentityField = 2758760692

UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = '24.73' WHERE AID = 2563075 AND ATID = 52 AND IdentityField = 2762286362

UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = '22.44' WHERE AID = 8228378 AND ATID = 52 AND IdentityField = 2767080524

UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = '15.62' WHERE AID = 10227247 AND ATID = 52 AND IdentityField = 2768403224

UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = '0.87' WHERE AID = 10477343 AND ATID = 52 AND IdentityField = 2768748442

UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = '24.97' WHERE AID = 24116367 AND ATID = 52 AND IdentityField = 2771700138

UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = '21.42' WHERE AID = 33182621 AND ATID = 52 AND IdentityField = 2774446554

UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = '8.67' WHERE AID = 37073205 AND ATID = 52 AND IdentityField = 2777205144

DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 1742986 AND ATID = 51 AND IdentityField = 1638177692

DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 10895026 AND ATID = 51 AND IdentityField = 1648355814
UPDATE TOP(1) CurrentBalanceAudit SET OldValue = '0.00', NewValue = '278.32' WHERE AID = 10895026 AND ATID = 51 AND IdentityField = 1648355815
UPDATE TOP(1) CurrentBalanceAudit SET OldValue = '0', NewValue = '1' WHERE AID = 10895026 AND ATID = 51 AND IdentityField = 1648355816


DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 13004403 AND ATID = 51 AND IdentityField = 1650513558
UPDATE TOP(1) CurrentBalanceAudit SET OldValue = '2', NewValue = '3' WHERE AID = 13004403 AND ATID = 51 AND IdentityField = 1650513557

UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = '3' WHERE AID = 37085917 AND ATID = 52 AND IdentityField = 2776315829


DELETE TOP(1) FROM CurrentBalanceAudit WHERE AID = 13566557 AND ATID = 51 AND IdentityField = 1651164588


UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '30.80' WHERE AID = 15709599 AND ATID = 51 AND IdentityField = 1652643391
UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '30.80' WHERE AID = 15709599 AND ATID = 51 AND IdentityField = 1652643393
UPDATE TOP(1) CurrentBalanceAudit SET NewValue = '30.80' WHERE AID = 15709599 AND ATID = 51 AND IdentityField = 1652643394

UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = '5.85' WHERE AID = 47264603 AND ATID = 52 AND IdentityField = 2779421184
UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = '5.85' WHERE AID = 47264603 AND ATID = 52 AND IdentityField = 2779421186
UPDATE TOP(1) CurrentBalanceAuditPS SET NewValue = '5.85' WHERE AID = 47264603 AND ATID = 52 AND IdentityField = 2779421187

DELETE TOP(1) FROM CurrentBalanceAuditPS WHERE AID = 47566268 AND ATID = 52 AND IdentityField = 2779421197




/*

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
