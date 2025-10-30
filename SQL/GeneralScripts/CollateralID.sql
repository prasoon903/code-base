
SELECT * FROM CollateralIDMapping WITH (NOLOCK)
SELECT * FROM CPSCollateralInfo WITH (NOLOCK) where bsacctid = 167413

SELECT * FROM CPSCollateralInfo WITH (NOLOCK) 
WHERE CPSID IN (101240)
AND EffectiveEndDate > CIDEffectiveDate
ORDER BY EffectiveEndDate,skey DESC


SELECT CollateralID,* FROM LogArTxnAddl WITH (NOLOCK) WHERE collateralid is not null

SELECT * FROM LogArTxnAddl WITH (NOLOCK) WHERE TranType IN (401,402)

SELECT acctid FROM CPSgmentAccounts with (NOLOCK) WHERE parent02AID =167413

SELECT CollateralID,bp.acctid,bp.accountnumber FROM BSegmentCreditCard bcc WITH (NOLOCK)
JOIN bsegment_primary bp with (nolock)
on (bcc.acctId = bp.acctid)
WHERE bp.acctid IN (167413,167414,167415,167416,167417,167422,167421,167420,167419,167418)

UPDATE BSegmentCreditCard SET CollateralID = 'Midland States Bank of Effingham, IL' WHERE acctid IN (167413,167414,167415,167416,167417,167422,167421,167420,167419,167418)
UPDATE AccountInfoForReport SET CollateralID = 'Midland States Bank of Effingham, IL' WHERE bsacctid IN (167413,167414,167415,167416,167417,167422,167421,167420,167419,167418)
UPDATE PlanInfoForReport SET CollateralID = 'Midland States Bank of Effingham, IL' WHERE bsacctid IN (167413,167414,167415,167416,167417,167422,167421,167420,167419,167418)
UPDATE CPSCollateralInfo SET CollateralID = 'Midland States Bank of Effingham, IL' WHERE bsacctid IN (167413,167414,167415,167416,167417,167422,167421,167420,167419,167418)

UPDATE LogArTxnAddl SET CollateralID = 'Midland States Bank of Effingham, IL', InstitutionID = 3235



SELECT * FROM collateralID_BulkUpdate
SELECT * FROM collateralID_BulkUpdate_Insert
SELECT * FROM Collateral_BulkUpdate_Processed

select CollateralID,* from planinfoforreport with (nolock) where bsacctid = 167413 order by businessday desc
select CollateralID,* from accountinfoforreport with (nolock) where bsacctid = 167413 order by businessday desc

UPDATE ClearingFiles set filestatus = 'Error' where filestatus IN ('Processing', 'TNP','NEW') and fileid=@fileid and  filesource = 'CollateralID'

SELECT * FROM ClearingFiles WHERE filesource = 'CollateralID'

SELECT * FROM commontnp with (nolock) 

select * from ClearingFiles where filesource = 'CollateralID'

select bsacctid,MemoIndicator,TransactionAmount,MessageIdentifier,CMTTRANTYPE,NoBlobIndicator,txnacctid,TransactionDescription,* From ccard_primary with(nolock) 
where AccountNumber in (select accountnumber from bsegment_primary with(nolock) where acctid = 167413) --and cmttrantype in ('301','302')
order by PostTime desc


select bp.acctId,bp.CurrentBalance,bp.NAD,bp.LAD
From BSegment_Primary bp with(nolock) join
BSegment_Secondary bs with(nolock) on bp.acctId = bs.acctId join
BSegmentCreditCard bcc with(nolock) on bp.acctId = bcc.acctId  join
BSegment_Balances bsb with(nolock) on bp.acctId = bsb.acctId
where bp.acctId in (167413)

select  bp.acctId,bp.CurrentBalance,bp.NAD,bp.LAD
From CPSgmentAccounts bp with(nolock) join
CPSgmentCreditCard bcc with(nolock) on bp.acctId = bcc.acctId
where bp.parent02AID in (167413) 
order by bp.parent02AID


select  top 1 CollateralID, CIDEffectiveDate
from PARASHAR_CB_CI..CPSCollateralInfo with ( nolock )
where
((PARASHAR_CB_CI..CPSCollateralInfo.CPSID = 101240) AND (PARASHAR_CB_CI..CPSCollateralInfo.EffectiveEndDate > PARASHAR_CB_CI..CPSCollateralInfo.CIDEffectiveDate))
order by PARASHAR_CB_CI..CPSCollateralInfo.EffectiveEndDate asc, PARASHAR_CB_CI..CPSCollateralInfo.SKEY desc

SELECT top 1 CollateralID, CIDEffectiveDate FROM CPSCollateralInfo WITH (NOLOCK) 
WHERE CPSID IN (101240)
AND EffectiveEndDate > CIDEffectiveDate
ORDER BY EffectiveEndDate ,SKEY DESC
