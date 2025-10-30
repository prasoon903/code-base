
DROP TABLE IF EXISTS TempMergeSummaryHeader
SELECT * INTO TempMergeSummaryHeader FROM MergeSummaryHeader WHERE 1 = 2

ALTER TABLE TempMergeSummaryHeader ADD SN DECIMAL(19, 0) IDENTITY(1, 1)