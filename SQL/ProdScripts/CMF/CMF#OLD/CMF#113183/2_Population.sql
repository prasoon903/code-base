--RUN ON REPLICATION SERVER ONLY

DROP TABLE IF EXISTS ##TempBsegment
Select BP.acctid, CONVERT(DATETIME, CONVERT(VARCHAR(20), chargeoffdate, 120)) as ChargeOffdate,Bp.SystemStatus
Into ##TempBsegment
from BSegment_Primary Bp with(NOLOCK)
JOIN BSegmentCreditCard BCC with(NOLOCK) ON(BP.acctid = BCC.acctId)
where systemstatus = 14

DROP TABLE IF EXISTS ##TempChargeOffRecords
;with CTE AS
(
select T.*,CONVERT(DATETIME, CONVERT(VARCHAR(20), CBA.businessday, 120)) as CBA_chargeoffdate,ROW_NUMBER() over(Partition by aid order by businessday) as row_num
from ##TempBsegment T with(NOLOCK)
JOIN CurrentbalanceAudit CBA with(NOLOCK) ON(T.acctid = CBA.aid and CBA.dename = 112 and CBA.newvalue = '14')
)
Select * Into ##TempChargeOffRecords From CTE With(NOLOCK) where row_num =1


INSERT INTO TempBsegmentChargeoffUpdate(Acctid, WrongChargeOffdate, CBA_ChargeoffDate)
SELECT T.acctid, chargeoffdate ,CBA_Chargeoffdate from ##TempChargeOffRecords  T
where chargeOffdate <> CBA_Chargeoffdate 


INSERT INTO TempAI_Records(BSAcctID, AI_Businessday, AI_ChargeOffDate, CBA_ChargeOffDate)
select  BSAcctid,businessday,AI.chargeoffdate, CBA_Chargeoffdate 
FROM TempBsegmentChargeoffUpdate T
JOIN  AccountInfoForReport AI with(NOLOCK) 
ON(T.acctid = AI.bsacctid  and  CBA_Chargeoffdate <= AI.businessday  and CONVERT(VARCHAR(20), AI.chargeoffdate, 120) <> CBA_Chargeoffdate )


/*
--Verification Query
Select * from TempAI_Records with (nolock) where JobStatus = 0
Select * from TempAI_Records with (nolock) where JobStatus = 1
*/
