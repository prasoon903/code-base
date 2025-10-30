
SELECT CPS.Parent02AID, DisputesAmtNS, currentbalance, creditPlanType, CPS.acctId, MergeIndicator, MergeDate, PlanSegCreateDate, PlanUUID,
COALESCE(CPC.MergeDate, MA.MergeJobCreateDate) MergeProcessedDate
FROM LS_PRODDRGSDB01.ccgs_coreissue.dbo.CPSGMENTACCOUNTS CPS WITH(NOLOCK)
JOIN LS_PRODDRGSDB01.ccgs_coreissue.dbo.CPSGMENTCREDITCARD CPC WITH(NOLOCK) ON (CPS.ACCTID = CPC.ACCTID)
JOIN LS_PRODDRGSDB01.ccgs_coreissue.dbo.MergeAccountJob MA WITH (NOLOCK) ON (cps.PARENT02AID = MA.DestBSAcctId)
WHERE MergeIndicator = 1
AND mergedate IS  NULL


SELECT *
FROM LS_PRODDRGSDB01.ccgs_coreissue.dbo.CCard_Primary WITH (NOLOCK)
WHERE BSAcctid = 903333 AND TxnAcctId = 59058572 AND CMTTranType = '40' AND MergeActivityFlag = 1



SELECT CPS.Parent02AID, DisputesAmtNS, currentbalance, creditPlanType, CPS.acctId, MergeIndicator, MergeDate, PlanSegCreateDate, CP.PostTime, PlanUUID
FROM LS_PRODDRGSDB01.ccgs_coreissue.dbo.CPSGMENTACCOUNTS CPS WITH(NOLOCK)
JOIN LS_PRODDRGSDB01.ccgs_coreissue.dbo.CPSGMENTCREDITCARD CPC WITH(NOLOCK) ON (CPS.ACCTID = CPC.ACCTID)
JOIN LS_PRODDRGSDB01.ccgs_coreissue.dbo.CCard_Primary CP WITH (NOLOCK) ON (CP.BSAcctid = CPS.Parent02AID AND CP.TxnAcctId = CPS.acctId AND CP.CMTTranType = '40' AND CP.MergeActivityFlag = 1)
WHERE MergeIndicator = 1
AND mergedate IS  NULL


;WITH CPSDetails
AS
(
	SELECT CPS.Parent02AID, DisputesAmtNS, currentbalance, creditPlanType, CPS.acctId, MergeIndicator, MergeDate, PlanSegCreateDate, PlanUUID
	FROM LS_PRODDRGSDB01.ccgs_coreissue.dbo.CPSGMENTACCOUNTS CPS WITH(NOLOCK)
	JOIN LS_PRODDRGSDB01.ccgs_coreissue.dbo.CPSGMENTCREDITCARD CPC WITH(NOLOCK) ON (CPS.ACCTID = CPC.ACCTID)
	WHERE MergeIndicator = 1
	AND mergedate IS  NULL
)
SELECT CPS.*, CP.PostTime, 'UPDATE TOP(1) CPSGMENTCREDITCARD SET MergeDate = ''' + TRY_CONVERT(VARCHAR(50), CP.PostTime, 20) + ''' WHERE acctId = ' + TRY_CONVERT(VARCHAR(10), CPS.acctId)
FROM CPSDetails CPS
JOIN LS_PRODDRGSDB01.ccgs_coreissue.dbo.CCard_Primary CP WITH (NOLOCK) ON (CP.BSAcctid = CPS.Parent02AID AND CP.TxnAcctId = CPS.acctId AND CP.CMTTranType = '40' AND CP.MergeActivityFlag = 1)


SELECT * FROM LS_PRODDRGSDB01.ccgs_coreissue.dbo.MergeAccountJob WITH (NOLOCK)
WHERE DestBsAcctId = 17643501
Order by Skey DESC

SELECT * FROM LS_PRODDRGSDB01.ccgs_coreissue.dbo.MergeAccountJob WITH (NOLOCK)
WHERE JobStatus = 'PROCESSING'
Order by Skey DESC

--UPDATE TOP(7) MergeAccountJob SET RetryFlag = 2 WHERE JobID IN (3436083257,3435977914,3435964129,3435754864,3435438883,3435369366,3434945509)



SELECT * FROM LS_PRODDRGSDB01.ccgs_coreissue.dbo.MergeAcctCCardLog WITH (NOLOCK) WHERE JobID = 3331762475 ORDER BY Skey 