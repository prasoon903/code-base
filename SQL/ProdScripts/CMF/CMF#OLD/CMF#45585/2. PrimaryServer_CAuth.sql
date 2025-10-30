-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreAuth
GO

BEGIN TRANSACTION

	-- UPDATE WILL BE 1 ROW EACH STATEMENT


	Update TOP(1) Bsegment_Primary SET AmtOfDispRelFromOTB = (AmtOfDispRelFromOTB - 22.99) where acctid=4639245



COMMIT TRANSACTION
--ROLLBACK TRANSACTION

--select AmtOfDispRelFromOTB from bsegment_primary with (nolock) where acctid = 4639245