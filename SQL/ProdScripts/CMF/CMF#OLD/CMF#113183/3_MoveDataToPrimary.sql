--RUN ON PRIMARY SERVER ONLY

--SELECT * FROM sys.servers

INSERT INTO TempBsegmentChargeoffUpdate(Acctid, WrongChargeOffdate, CBA_ChargeoffDate)
SELECT Acctid, WrongChargeOffdate, CBA_ChargeoffDate FROM P1MARPRODDB02.CCGS_RPT_coreIssue.DBO.TempBsegmentChargeoffUpdate

