CREATE or alter PROCEDURE USP_GETTxnDetails_Behave
  @ExecutionID  INT = 0,
  @VariableName VARCHAR(500),
  @FeatureName  VARCHAR(1000)
AS
  BEGIN
    DECLARE @VariableValue VARCHAR(3000)
    IF(@ExecutionID = 0)
    BEGIN
      SELECT @VariableValue = variablevalue from featurestepdatastore (nolock)
      WHERE  featurename = @FeatureName
      AND    variablename=@VariableName
    END
    ELSE
    BEGIN
      SELECT @VariableValue = variablevalue
      FROM   Featurestepdatastore (nolock)
      WHERE  executionid = @ExecutionID
      AND    variablename=@VariableName
    END
    DECLARE @tranid DECIMAL(19,0) = try_cast( @VariableValue as decimal(19, 0)) ;
    WITH cte AS
    (
           SELECT accountnumber,
                  c.tranid,
                  txncode_internal,
                  cmttrantype,
                  posttime,
                  trantime,
                  transactionamount,
                  Isnull(claimid, '') claimid,
				  cs.invoicenumber,
				  c.rmatranuuid,
				  c.txnsource
           FROM   Ccard_primary c (nolock)
		   left join ccard_Secondary cs  (nolock) on c.tranid = cs.tranid
           WHERE  c.tranid = @tranid )
    SELECT accountnumber,
           Cast(tranid AS VARCHAR(50)) tranid,
           txncode_internal,
           cmttrantype,
           CONVERT(VARCHAR, posttime, 120) posttime,
           CONVERT(VARCHAR, trantime, 120) trantime,
           claimid,
           cast(transactionamount AS varchar) transactionamount,
           m.actualtrancode ,
           m.manualadjustmenttxncode,
           m1.actualtrancode AS manualreversaltrancode,
		   cte.invoicenumber,
		   cte.rmatranuuid,
		   cte.txnsource
    FROM   cte
    JOIN   monetarytxncontrol m(nolock)
    ON     cte.txncode_internal = m.transactioncode
    JOIN   monetarytxncontrol m1(nolock)
    ON     m1.transactioncode = m.manualadjustmenttxncode
  END