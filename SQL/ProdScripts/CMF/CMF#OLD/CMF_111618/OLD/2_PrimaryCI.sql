BEGIN TRAN
--COMMIT 
--ROLLBACK

UPDATE BC
SET daysdelinquent = T.daysdelinquent, Nopaydaysdelinquent = T.Nopaydaysdelinquent, dateoforiginalpaymentduedtd = T.dateoforiginalpaymentduedtd, 
FirstDueDate = T.FirstDueDate, DtOfLastDelinqCTD = T.DtOfLastDelinqCTD 
FROM BSegmentCreditCard BC WITH (NOLOCK)
JOIN ##TempDelinq T ON (BC.acctID = T.BSAcctID)