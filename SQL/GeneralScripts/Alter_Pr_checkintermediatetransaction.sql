
 ALTER PROCEDURE Pr_checkintermediatetransaction @accountnumber VARCHAR (19),    
                                            @StartTime     DATETIME,    
                                            @EndTime       DATETIME,    
                                            @acctid        INT    
AS    
SET NOCOUNT ON    
  
BEGIN    
  SET TRANSACTION ISOLATION LEVEL SERIALIZABLE    
  
  CREATE TABLE #TempTranid_I    
    (    
       Tranid DECIMAL(19)    
    )    
  
  BEGIN    
      INSERT INTO #TempTranid_I    
                  (Tranid)    
      SELECT Tranid    
      FROM   CCard_Primary WITH (nolock)    
      WHERE  AccountNumber = @accountnumber    
             AND tranid NOT IN (SELECT RevTgt    
                                FROM   CCard_Primary WITH (nolock)    
                                WHERE  AccountNumber = @accountnumber    
                                       AND RevTgt IS NOT NULL)    
  
      SELECT A.TxnAcctId,    
             A.CMTTRANTYPE,    
             Sum(Isnull(A.TransactionAmount, 0)) TransactionAmount,    
             A.PaymentCreditFlag,  
             A.PostTime    
      FROM   CCARD_PRIMARY A WITH (nolock)    
             JOIN (SELECT tranid    
                   FROM   CCard_Primary WITH (nolock)    
                   WHERE  tranid IN (SELECT tranid    
                                     FROM   #TempTranid_I)    
                          AND AccountNumber = @accountnumber    
                          AND TranTime >= @StartTime    
                          AND TranTime <= @EndTime    
                          AND cmttrantype IN ( '03', '05', '07', '09',    
                                               '11', '13', '15', '17',    
                                               '19', '21', '23', '41', '49'    
                                             )    
                          AND ( PostingFlag = 1 )    
                          AND RevTgt IS NULL) B    
               ON ( A.TranRef = B.TranId )    
      WHERE  A.NoBlobIndicator = '6'    
      GROUP  BY A.TxnAcctId,    
                A.CMTTRANTYPE,    
                A.PaymentCreditFlag,  
                A.PostTime    
      --UNION    
      --SELECT V.TxnAcctId,    
      --       '121'                               CMTTRANTYPE,    
      --       Sum(Isnull(V.TransactionAmount, 0)) TransactionAmount,    
      --       '40'                                PaymentCreditFlag,  
      --       V.PostTime    
      --FROM   CCard_Primary V WITH (NOLOCK)    
      --       JOIN (SELECT revtgt    
      --             FROM   CCard_Primary WITH (nolock)    
      --             WHERE  AccountNumber = @accountnumber    
      --                    AND CMTTRANTYPE = '43'    
      --                    AND PostTime >= @StartTime    
      --                    AND PostTime <= @EndTime) X    
      --         ON ( V.TranId = X.RevTgt )    
      --WHERE  ( PostingFlag = 1 ) 
      --GROUP  BY V.TxnAcctId,    
      --          V.CMTTRANTYPE,    
      --          V.PaymentCreditFlag,  
      --          V.PostTime    
  END    
END  