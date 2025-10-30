-- TO BE EXECUTED ON PRIMARY SERVER COREISSUE DATABASE ONLY

BEGIN TRANSACTION
--COMMIT TRANSACTION
--ROLLBACK TRANSACTION

UPDATE TOP(1) StatementHeader SET Principal = Principal + 25.74 WHERE AcctId = 6730375 AND StatementID = 165420011

UPDATE TOP(1) SummaryHeader SET Principal = Principal + 25.74, decurrentbalance_trantime_ps = decurrentbalance_trantime_ps + 25.74 WHERE AcctId = 16354533 AND StatementID = 165420011



UPDATE TOP(1) AccountInfoForReport SET Principal = Principal + 25.74 WHERE BSAcctId = 6730375 AND BusinessDay = '2022-06-30 23:59:57'

UPDATE TOP(1) PlanInfoForReport SET Principal = Principal + 25.74 WHERE CPSAcctId = 16354533 AND BusinessDay = '2022-06-30 23:59:57'



