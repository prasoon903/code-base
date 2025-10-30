--DROP TABLE IF EXISTS ##Allplans2
--select parent02aid,sh.currentbalance,sh.acctid,sh.statementdate ,creditplantype,equalpaymentamt,shcc.currentdue,sh.amountoftotaldue , shcc.srbwithinstallmentdue , shcc.cycleduedtd

--  into ##Allplans2  from  statementvalidation s  with(nolock) 
--join summaryheader sh  with(nolock)   on  (s.acctid = sh.parent02aid  and   s.statementdate = sh.statementdate    )
--join summaryheadercreditcard  shcc  with(nolock)   on  (sh.acctid = shcc.acctid    and   sh.statementid  = shcc.statementid    )
--where sh.statementdate = '2022-04-30 23:59:57' and  s.validationfail = 'Q10' and   creditplantype  = 0  and currentbalance > amountoftotaldue 

--select * from ##Allplans2 where currentbalance > amountoftotaldue  and   creditplantype  = 0 


-- TO BE RUN ON PRIMARY SERVER COREISSUE DATABASE
BEGIN TRANSACTION
--COMMIT TRANSACTION
--ROLLBACK TRANSACTION

--SELECT * FROM ##tempPlans_Corrected

----SELECT DISTINCT BSAcctId FROM ##tempPlans_Corrected

--SELECT * FROM ##tempAccounts_Corrected

UPDATE CPS
SET AmountOfTotalDue = CPS.AmountOfTotalDue + CPS.currentbalance, 
AmtOfPayCurrDue = CPS.AmtOfPayCurrDue + CPS.currentbalance,
CycleDueDTD = 1
FROM CPSgmentCreditCard CPS
JOIN ##Allplans2 T1 ON (CPS.acctId = T1.acctid)




UPDATE SH
SET AmountOfTotalDue = SH.AmountOfTotalDue + SH.currentbalance
FROM SummaryHeader SH 
JOIN ##Allplans2 T1 ON (SH.acctId = T1.acctid  AND T1.statementdate = SH.StatementDate)

UPDATE SHCC
SET CurrentDue = SHCC.CurrentDue + T1.currentBalance
FROM SummaryHeaderCreditCard SHCC
JOIN SummaryHeader SH ON (SH.acctId = SHCC.acctID AND SH.StatementID = SHCC.acctId)
JOIN ##Allplans2 T1 ON (SH.acctId = T1.acctid AND T1.statementdate = SH.StatementDate)


UPDATE PIR
SET AmountOfTotalDue = SH.AmountOfTotalDue + T1.CurrentBalance,
AmtOfPayCurrDue = PIR.AmtOfPayCurrDue  + T1.CurrentBalance,
CycleDueDTD = 1
FROM PlanInfoForreport PIR
JOIN ##Allplans2 T1 ON (PIR.CPSacctId = T1.CPSAcctId AND T1.BusinessDay = PIR.BusinessDay)


