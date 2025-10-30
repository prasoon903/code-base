
DROP TABLE IF EXISTS ##TempData
GO
CREATE TABLE  ##TempData (SN DECIMAL(19, 0) IDENTITY(1, 1), AccountUUID VARCHAR(64), TranTime DATETIME, Amount MONEY, ClientID VARCHAR(64))

--SELECT COUNT(1) FROM ##TempData

INSERT INTO ##TempData (AccountUUID, ClientID, Amount) VALUES ('c4f32a26-9734-453c-8b03-1b9154b69d73', '13212c4c-af05-4dfd-9d67-662e46b414fb', 328.94)
INSERT INTO ##TempData (AccountUUID, ClientID, Amount) VALUES ('bcc9fb32-9085-4500-b1c1-0e39187d4fbc', 'e6bafffb-be44-4cd8-a682-cd4e3eb5ab73', 291.11)
INSERT INTO ##TempData (AccountUUID, ClientID, Amount) VALUES ('c05f8846-1316-4616-84fa-4ee0d669bbc1', '099537e6-df19-4fdf-a78f-3fd5618a234b', 1526.18)
