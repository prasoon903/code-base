DROP TABLE IF EXISTS #TempRecords
SELECT SH.acctID, SH.parent02AID, PlanUUID, CreditPlanType, EqualPaymentAmt, SH.StatementDate, CurrentBalance, CycleDueDTD, AmountOfTotalDue, CurrentDue, CurrentBalanceCO, PayoffDate, CreditBalanceMovement
INTO #TempRecords
FROM SummaryHeaderCreditCard SHC WITH (NOLOCK)
JOIN SummaryHeader Sh WITH (NOLOCK) ON (SH.acctID = SHC.acctID AND SH.StatementID = SHC.StatementID)
WHERE SH.StatementDate IN ('2023-02-28 23:59:57', '2023-03-31 23:59:57')
--AND CurrentBalance+CurrentBalanceCO > 0

DROP TABLE IF EXISTS #RetailPlans
SELECT * 
INTO #RetailPlans
FROM #TempRecords
WHERE CreditPlanType = '16'

SELECT StatementDate, COUNT(1)
FROM #RetailPlans
GROUP BY StatementDate

DROP TABLE IF EXISTS #TempFebStmts
SELECT * INTO #TempFebStmts FROM #RetailPlans WHERE StatementDate = '2023-02-28 23:59:57'

DROP TABLE IF EXISTS #TempMarchStmts
SELECT * INTO #TempMarchStmts FROM #RetailPlans WHERE StatementDate = '2023-03-31 23:59:57'


SELECT PayOffDate, COUNT(1)
FROM #TempFebStmts
GROUP BY PayOffDate
ORDER BY PayOffDate DESC

DROP TABLE IF EXISTS #TempMarchPayOff
SELECT * INTO #TempMarchPayOff FROM #TempFebStmts WHERE PayOffDate = '2023-03-31 23:59:57'

DROP TABLE IF EXISTS #TempMarchPayOffWithSH
SELECT T.*, SH.ccinhparent125AID, SH.WaiveMinDue
INTO #TempMarchPayOffWithSH
FROM #TempMarchPayOff T
JOIN LS_P1MARPRODDB01.ccgs_coreissue_secondary.dbo.StatementHeader SH WITH (NOLOCK) ON (T.StatementDate = SH.StatementDate AND T.parent02AID = SH.acctID)

SELECT COUNT(1) FROM #TempMarchPayOffWithSH WHERE CycleDueDTD = 0
SELECT COUNT(1) FROM #TempMarchPayOffWithSH WHERE CycleDueDTD = 0 AND WaiveMinDue = '1'
SELECT COUNT(1) FROM #TempMarchPayOffWithSH WHERE CycleDueDTD = 0 AND CreditBalanceMovement >= EqualPaymentAmt

SELECT COUNT(1) FROM #TempMarchPayOffWithSH WHERE CycleDueDTD = 1
SELECT COUNT(1) FROM #TempMarchPayOffWithSH WHERE CycleDueDTD = 1 AND CurrentDue = 0 -- Invalid case
SELECT COUNT(1) FROM #TempMarchPayOffWithSH WHERE CycleDueDTD = 1 AND CurrentDue > 0

SELECT COUNT(1) FROM #TempMarchPayOffWithSH WHERE CycleDueDTD > 1
SELECT COUNT(1) FROM #TempMarchPayOffWithSH WHERE CycleDueDTD > 1 AND CurrentDue = 0
SELECT COUNT(1) FROM #TempMarchPayOffWithSH WHERE CycleDueDTD > 1 AND CurrentDue > 0


SELECT COUNT(1) FROM #TempMarchPayOffWithSH WHERE CurrentDue = 0 AND CurrentBalance > 0
SELECT COUNT(1) FROM #TempMarchPayOffWithSH WHERE CurrentDue = 0 AND WaiveMinDue = '1'
SELECT COUNT(1) FROM #TempMarchPayOffWithSH WHERE CurrentDue = 0 AND WaiveMinDue IS NULL
SELECT COUNT(1) FROM #TempMarchPayOffWithSH WHERE CurrentDue = 0 AND WaiveMinDue IS NULL AND CreditBalanceMovement >= EqualPaymentAmt
SELECT COUNT(1) FROM #TempMarchPayOffWithSH WHERE CurrentDue = 0 AND WaiveMinDue IS NULL AND ISNULL(CreditBalanceMovement,0) < EqualPaymentAmt
SELECT COUNT(1) FROM #TempMarchPayOffWithSH WHERE CurrentDue = 0 AND WaiveMinDue IS NULL AND CurrentBalance = AmountOfTotalDue

SELECT * FROM #TempMarchPayOffWithSH WHERE CurrentDue = 0 AND CreditBalanceMovement >= EqualPaymentAmt

/*
SELECT * FROM #TempMarchPayOff where  currentdue > 0 

DROP TABLE IF EXISTS #TempNotPaidOffPlans
SELECT T1.acctID,T1.parent02AID,T1.PlanUUID,T1.CreditPlanType,T1.StatementDate,T1.CurrentBalance FebCB, T1.CycleDueDTD FebCycleDueDTD, T2.CurrentBalance MarchCB, T2.CycleDueDTD MarchCycleDueDTD,T1.AmountOfTotalDue FebDue, T2.AmountOfTotalDue MarchDue,
T1.PayoffDate FebPayOffDate, T2.PayoffDate MarchPayOffDate,T1.CreditBalanceMovement 
INTO #TempNotPaidOffPlans
FROM #TempMarchPayOff T1
JOIN #TempMarchStmts T2 ON (T1.acctID = T2.acctId AND T2.CurrentBalance > 0)

SELECT * FROM #TempNotPaidOffPlans  --WHERE CurrentDue > 0

DROP TABLE IF EXISTS #Accounts
--SELECT DISTINCT parent02AID INTO #Accounts FROM #TempNotPaidOffPlans
SELECT parent02AID, SUM(FebDue) FebDue, SUM(MarchDue) MarchDue INTO #Accounts FROM #TempNotPaidOffPlans GROUP BY parent02AID

SELECT * FROM #Accounts

SELECT * FROM PaymentSchedule WITH (NOLOCK) WHERE acctID = 11501511 ORDER BY ScheduleID DESC

--325955303
--325846231

SELECT ACHPaymentDate, Frequency, SendFlag, TranID,* FROM ACHIntermediate WITH (NOLOCK) WHERE acctID = 208789 AND ACHPaymentDate BETWEEN '2023-03-01' AND '2023-03-31 23:59:57'

--82529970935
--82864491063
--83055337223
--83056314387

SELECT * FROM PaymentSchedule WITH (NOLOCK) WHERE ScheduleID = 135116041


SELECT * FROM ACHIntermediate WITH (NOLOCK) WHERE PymtScheduleId = 135116041

SELECT TransactionAmount,* FROM CCArd_Primary WITH (NOLOCK) WHERE TranID = 81449680996

SELECT * FROM CurrentBalanceAudit WITH (NOLOCK) WHERE AID = 2108368 AND TID = 82667880091 AND ATID = 51

DROP TABLE IF EXISTS #ACHPayments
SELECT A.parent02AID acctID, A.FebDue, AC.AccountNumber, PymtScheduleId, TranID, AC.ACHPaymentDate, PaymentAmount, SendFlag, Frequency, PaymentType
INTO #ACHPayments
FROM #Accounts A
JOIN ACHIntermediate AC ON (A.parent02AID = AC.acctID AND AC.ACHPaymentDate BETWEEN '2023-03-01' AND '2023-03-31 23:59:57')

DROP TABLE IF EXISTS #Payments
SELECT acctID, SUM(PaymentAmount) PaymentAmount INTO #Payments FROM #ACHPayments WHERE SendFlag = 1 GROUP BY acctID

DROP TABLE IF EXISTS #PaymentsInMarch
SELECT parent02AID,FebDue,MarchDue,PaymentAmount
INTO #PaymentsInMarch 
FROM #Accounts A
JOIN #Payments P ON (A.parent02AID = P.acctID)

SELECT * FROM #PaymentsInMarch WHERE PaymentAmount > FebDue

SELECT * FROM #TempRecords WHERE parent02AID = 208789

DROP TABLE IF EXISTS #TempDueStatus
;WITH CTE
AS
(
SELECT T.parent02AID, SUM(CASE WHEN T.CreditPlanType IN ('0', '10') THEN AmountOfTotalDue ELSE 0 END) FebNonretailDue, SUM(CASE WHEN T.CreditPlanType IN ('16') THEN AmountOfTotalDue ELSE 0 END) FebRetailDue
FROM #PaymentsInMarch P
JOIN #TempRecords T ON (P.parent02AID = T.parent02AID /*AND T.CreditPlanType IN ('0', '10')*/ AND T.StatementDate = '2023-02-28 23:59:57.000')
GROUP BY T.parent02AID
)
SELECT P.parent02AID,FebDue,MarchDue, FebRetailDue, FebNonretailDue,PaymentAmount
INTO #TempDueStatus 
FROM #PaymentsInMarch P JOIN CTE C ON (P.parent02AID = C.parent02AID)

SELECT * FROM #TempDueStatus WHERE PaymentAmount > FebRetailDue+FebNonretailDue AND MarchDue > 0 AND febDue > 0

SELECT * FROM #TempDueStatus WHERE Parent02AID = 1627577

SELECT * FROM #ACHPayments WHERE acctID = 1627577

SELECT * FROM #TempMarchPayOff WHERE Parent02AID = 1627577


;WITH CTE
AS
(
SELECT * FROM #TempDueStatus WHERE PaymentAmount > FebRetailDue+FebNonretailDue AND MarchDue > 0 AND febDue > 0
)
SELECT * FROM #TempNotPaidOffPlans T JOIN CTE C ON (T.parent02AID = C.parent02AID)
WHERE T.FebCB <= T.MarchCB


SELECT T.*, ccinhparent125AID, WaiveMinDue 
FROM #TempMarchPayOff  T
JOIN StatementHeader SH WITH (NOLOCK) ON (T.parent02AID = SH.acctID AND T.StatementDate = SH.StatementDate)
WHERE T.Parent02AID IN (571930, 3454915, 1296976, 1957870, 12710088, 1278303, 2151812, 3874634, 437608, 1508269, 275776, 
296421, 440934, 2466352, 3793647, 1345728, 2525009, 12820208, 2004496, 4830915, 
11507647, 21589137, 16809082, 21606420, 17322374, 17950555, 21665350)

SELECT * FROM #TempFebStmts WHERE Parent02AID = 571930
SELECT * FROM #TempMarchStmts WHERE Parent02AID = 571930

SELECT TransactionAmount,* FROM CCArd_Primary WITH (NOLOCK) WHERE TranID = 83492488351

SELECT TransactionAmount, TxnAcctID,* FROM CCArd_Primary WITH (NOLOCK) WHERE TranRef = 83492488351


;WITH cte
AS
(
SELECT SendFlag, COUNT(1) [Count]
FROM #ACHPayments 
GROUP BY SendFlag
)
SELECT CL.LutDescription, SendFlag, [Count]
FROM CTE C
LEFT JOIN CCArdLookUp CL WITH (NOLOCK) ON (C.SendFlag = CL.LutCode AND CL.LutId = 'PymtSendFlag')

SELECT * FROM #ACHPayments WHERE acctID = 11501511
*/