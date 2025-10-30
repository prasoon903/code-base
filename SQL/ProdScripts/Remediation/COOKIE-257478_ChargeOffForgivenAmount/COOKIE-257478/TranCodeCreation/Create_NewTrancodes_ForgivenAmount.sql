
/*============================================================================
Author : Ritik Yadav
Reviewer : Satyam Agrawal
Date : 22/11/2023
JIRA : COOKIE-259287, COOKIE-257478, CARDS-103273
Description : New Tran Code Balance Write Offs
=============================================================================*/
IF EXISTS (SELECT TOP 1 1 FROM CPS_Environment WUITH(NOLOCK) WHERE Environment_Name LIKE '%PLAT%')
BEGIN 
	BEGIN TRY 
	BEGIN TRANSACTION 

			EXEC USP_PDF_MTC_CreateNewTranCode1 '49','53','4933','53',0,'FORGIVEN AMOUNT - REMEDIATION',NULL,'49','53','Credit Card Cancelled Debt'
			EXEC USP_PDF_MTC_CreateNewTranCode1 '49','53','4933M','53',0,'FORGIVEN AMOUNT - REMEDIATION',NULL,'49','53','Credit Card Cancelled Debt'

					--------------------------------------------------4933--------------------------------------------------------
			UPDATE TranCodeLookup SET 
			IncludeInStmtTotals=NULL ,TranType=1, StatementSection=3,TrancodeCategory=12,
			tpyNAD=NULL,	tpyLAD=NULL,	tpyBlob=NULL 
			WHERE lutid='trancode' and LutCode IN (
			SELECT TransactionCode FROM MonetaryTxnControl WITH (NOLOCK) WHERE ActualTranCode IN ('4933' ) AND GroupID = 53 )
	
			UPDATE Syn_Cauth_trancodelookup set 
			IncludeInStmtTotals=NULL ,Trantype=1, StatementSection=3,
			tpyNAD=NULL,	tpyLAD=NULL,	tpyBlob=NULL 
			WHERE lutid='trancode' and LutCode IN(
			SELECT TransactionCode FROM MonetaryTxnControl WITH (NOLOCK) WHERE ActualTranCode IN ('4933' ) AND GroupID = 53)

			UPDATE TranCodeCatalog SET 
			IncludeInStmtTotals=NULL ,Trantype=1,
			tpyNAD=NULL,	tpyLAD=NULL,	tpyBlob=NULL 
			WHERE TransactionCode in ('4933')


			--Making Trancode Manual
			UPDATE MonetaryTxnControl SET LogicModuleType=11 ,status=0 ,
			tpyNAD=NULL,	tpyLAD=NULL,	tpyBlob=NULL 
			WHERE ActualTranCode in ('4933' ) AND GroupID = 53

			UPDATE TranCodeLookup SET  diversionindicator=2 ,displayentry=0,
			tpyNAD=NULL,	tpyLAD=NULL,	tpyBlob=NULL 
			WHERE lutid='trancode' and LutCode IN (
			SELECT TransactionCode FROM MonetaryTxnControl WITH (NOLOCK) WHERE ActualTranCode IN ('4933' ) AND GroupID = 53 )


			----- Updating Merge Trancode Parameter
			UPDATE TranCodeLookup SET 
			IncludeInStmtTotals=NULL ,TranType=1, StatementSection=3,TrancodeCategory=15,
			tpyNAD=NULL,	tpyLAD=NULL,	tpyBlob=NULL 
			WHERE lutid='trancode' and LutCode IN (
			SELECT TransactionCode FROM MonetaryTxnControl WITH (NOLOCK) WHERE ActualTranCode IN ('4933M' ) AND GroupID = 53 )

			UPDATE Syn_Cauth_trancodelookup set 
			IncludeInStmtTotals=NULL ,Trantype=1, StatementSection=3,
			tpyNAD=NULL,	tpyLAD=NULL,	tpyBlob=NULL 
			WHERE lutid='trancode' and LutCode IN(
			SELECT TransactionCode FROM MonetaryTxnControl WITH (NOLOCK) WHERE ActualTranCode IN ('4933M' ) AND GroupID = 53)

			UPDATE TranCodeCatalog SET 
			IncludeInStmtTotals=NULL ,Trantype=1,
			tpyNAD=NULL,	tpyLAD=NULL,	tpyBlob=NULL 
			WHERE TransactionCode in ('4933M' )


			-- Adding Merge Related Parameter and LogicModuleType =  Others 
			UPDATE MonetaryTxnControl SET MergeTrancode = 'M' , LogicModuleType = 10
			WHERE ActualTranCode in ('4933M' )

			UPDATE MonetaryTxnControl SET MergeRepostTrancode = (SELECT TOP 1 LTRIM(RTRIM(TransactionCode)) 
				FROM MonetaryTxnControl WITH(NOLOCK) WHERE ActualTranCode =  '4933M' AND GroupID = 53)
			WHERE ActualTranCode =  '4933' AND GroupID = 53



	COMMIT TRANSACTION
	END TRY
	BEGIN CATCH 
	IF @@trancount >0
		ROLLBACK TRANSACTION
		SELECT ERROR_MESSAGE(),ERROR_LINE(),ERROR_NUMBER()
		RAISERROR('ERROR OCCURED :-', 16, 1);
	END CATCH
END

IF EXISTS (SELECT TOP 1 1 FROM CPS_Environment WUITH(NOLOCK) WHERE Environment_Name LIKE '%Jazz%')
BEGIN 
	BEGIN TRY 
	BEGIN TRANSACTION 

			EXEC USP_PDF_MTC_CreateNewTranCode1 '49','53','4933','53',0,'FORGIVEN AMOUNT - REMEDIATION',NULL,'49','53','Credit Card Cancelled Debt'

					--------------------------------------------------4933--------------------------------------------------------
			UPDATE TranCodeLookup SET 
			IncludeInStmtTotals=NULL ,TranType=1, StatementSection=3,TrancodeCategory=5,
			tpyNAD=NULL,	tpyLAD=NULL,	tpyBlob=NULL 
			WHERE lutid='trancode' and LutCode IN (
			SELECT TransactionCode FROM MonetaryTxnControl WITH (NOLOCK) WHERE ActualTranCode IN ('4933' ) AND GroupID = 53 )
	
			UPDATE Syn_Cauth_trancodelookup set 
			IncludeInStmtTotals=NULL ,Trantype=1, StatementSection=3,
			tpyNAD=NULL,	tpyLAD=NULL,	tpyBlob=NULL 
			WHERE lutid='trancode' and LutCode IN(
			SELECT TransactionCode FROM MonetaryTxnControl WITH (NOLOCK) WHERE ActualTranCode IN ('4933' ) AND GroupID = 53)

			UPDATE TranCodeCatalog SET 
			IncludeInStmtTotals=NULL ,Trantype=1,
			tpyNAD=NULL,	tpyLAD=NULL,	tpyBlob=NULL 
			WHERE TransactionCode in ('4933')


			--Making Trancode Manual
			UPDATE MonetaryTxnControl SET LogicModuleType=11 ,status=0 ,
			tpyNAD=NULL,	tpyLAD=NULL,	tpyBlob=NULL 
			WHERE ActualTranCode in ('4933' ) AND GroupID = 53

			UPDATE TranCodeLookup SET  diversionindicator=2 ,displayentry=0,
			tpyNAD=NULL,	tpyLAD=NULL,	tpyBlob=NULL 
			WHERE lutid='trancode' and LutCode IN (
			SELECT TransactionCode FROM MonetaryTxnControl WITH (NOLOCK) WHERE ActualTranCode IN ('4933' ) AND GroupID = 53 )


	COMMIT TRANSACTION
	END TRY
	BEGIN CATCH 
	IF @@trancount >0
		ROLLBACK TRANSACTION
		SELECT ERROR_MESSAGE(),ERROR_LINE(),ERROR_NUMBER()
		RAISERROR('ERROR OCCURED :-', 16, 1);
	END CATCH
END