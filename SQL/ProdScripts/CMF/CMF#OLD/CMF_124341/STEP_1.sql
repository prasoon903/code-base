

SELECT * FROM Trans_In_Acct WITH (NOLOCK) WHERE Tran_Id_Index = 118777919066

SELECT FileName,* FROM CCard_Secondary WITH (NOLOCK) WHERE TranID = 118777919066
SELECT Postingref,* FROM CCard_Primary WITH (NOLOCK) WHERE TranID = 118777919066
SELECT * FROM CommonTNP WITH (NOLOCK) WHERE TranID = 118777919066

------------------------- STEP 1 ----------------------------

BEGIN TRANSACTION
--COMMIT TRANSACTION
--ROLLBACK TRANSACTION

UPDATE CCard_Secondary SET FileName = 'CI@ForcePost' WHERE TranID = 118777919066
UPDATE CCard_Primary SET Postingref = 'Transaction posted successfully' WHERE TranID = 118777919066 AND AccountNumber = '1100011162765329'


-------------------------------------------------------------

------------------------- STEP 2 ----------------------------

BEGIN TRANSACTION
--COMMIT TRANSACTION
--ROLLBACK TRANSACTION

DECLARE @CurrentDate DATETIME = GETDATE()

INSERT INTO CommonTNP(tnpdate,priority,TranTime,TranId,ATID,acctId,ttid,NADandROOFlag,GetAllTNPJobsFlag,Retries,InstitutionID)
VALUES
(@CurrentDate, 0, @CurrentDate, 118777919066, 51, 13950076, 0, 0, 0, 0, 6981)



-------------------------------------------------------------
