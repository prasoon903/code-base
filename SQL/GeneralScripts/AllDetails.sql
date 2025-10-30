SELECT ccinhparent127aid,* from BSegment_Primary
WHERE acctId='167413'

SELECT * FROM Logo_Primary
WHERE acctId='3327'

SELECT * FROM OrgAccounts
WHERE acctId='3235'

SELECT * FROM AStatusAccounts
WHERE acctId='2'

SELECT BillingTableName,* FROM BillingTableAccounts
WHERE acctId='2057'

SELECT InstitutionID,Description,* FROM Institutions
WHERE InstitutionID='3235'

SELECT * FROM CPSgmentAccounts
WHERE parent02AID = '167423'

SELECT * FROM CPSgmentCreditCard
WHERE acctId = '101260'

SELECT * FROM Customer
WHERE CustomerId= '167278'

SELECT * FROM BSegment_Balances
WHERE CustomerId= '167278'

SELECT bp.acctid,ct.FirstName, ct.LastName, bp.AccountNumber,ins.Institutionid, ins.Description as Institution, lp.acctId as Product_ID, bp.ccinhparent127aid AS BillingTable, bta.BillingTableName, cps.acctid as CPSegmentID, cc.InterestRate1 AS InterestRate
FROM BSegment_Primary bp
JOIN Customer ct
ON ct.CustomerId = bp.CustomerId
JOIN Logo_Primary lp
ON bp.parent02AID = lp.acctId
JOIN BillingTableAccounts bta
ON bta.acctId = bp.ccinhparent127AID
JOIN Institutions ins
ON ins.InstitutionID = lp.parent02AID
JOIN CPSgmentAccounts cps
ON cps.parent02AID = bp.acctId
JOIN CPSgmentCreditCard cc
ON cc.acctId = cps.acctId
WHERE bp.acctId=5000

use PARASHAR_CB_CI
USE PARASHAR_TEST

USE parashar_CB_CC

