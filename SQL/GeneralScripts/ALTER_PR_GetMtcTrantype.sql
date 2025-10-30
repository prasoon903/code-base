ALTER PROCEDURE PR_GetMtcTrantype
@ActualTranCode varchar (20)
AS
BEGIN
	SELECT TL.*   
	FROM  trancodelookup TL WITH(nolock)   
		  JOIN monetarytxncontrol MTC WITH(nolock)   
		  ON TL.lutcode = MTC.transactioncode   
		  WHERE actualtrancode = @ActualTranCode
END