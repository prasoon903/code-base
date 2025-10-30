-- PRASOON PARASHAR

BEGIN TRAN

	UPDATE CPSgmentCreditCard 
	SET 
		CardAcceptorNameLocation = 'Apple Store            RESTON        VA',
		FirstDueDate = '2020-02-29 23:59:57.000',
		TermCmplDate ='2022-01-31 23:59:57.000',
		OriginalPurchaseAmount = '199.00'  
	WHERE acctid = 10782222
	-- 1 rows update

	UPDATE CPSgmentAccounts 
	SET
		InvoiceNumber = '120120145731332'
	WHERE acctid = 10782220
	-- 1 rows update

	UPDATE CCard_Secondary
	SET
		InvoiceNumber = '120120145731332'
	WHERE TranID = 24400826089
	-- 1 rows update

	UPDATE CPSgmentAccounts SET parent02AID = 0 - parent02AID WHERE acctId IN (10782221)
	-- 1 rows update
	
	DELETE FROM XrefTable WHERE ParentATID = 51 AND ParentAID = 682840 AND ChildATID = 52 AND ChildAID = 10782221
	-- 1 row delete

--COMMIT TRAN
--ROLLBACK TRAN

BEGIN TRAN

	UPDATE CPSgmentCreditCard 
	SET 
		CardAcceptorNameLocation = 'Apple Store            SHERMAN OAKS  CA',
		FirstDueDate = '2020-02-29 23:59:57.000',
		TermCmplDate ='2022-01-31 23:59:57.000',
		OriginalPurchaseAmount = '299.00'  
	WHERE acctid = 10793980
	-- 1 rows update

	UPDATE CPSgmentAccounts 
	SET
		InvoiceNumber = '120118134927245'
	WHERE acctid = 10793978
	-- 1 rows update

	UPDATE CCard_Secondary
	SET
		InvoiceNumber = '120118134927245'
	WHERE TranID = 24350423832
	-- 1 rows update

	UPDATE CPSgmentAccounts SET parent02AID = 0 - parent02AID WHERE acctId IN (10793979)
	-- 1 rows update
	
	DELETE FROM XrefTable WHERE ParentATID = 51 AND ParentAID = 4251440 AND ChildATID = 52 AND ChildAID = 10793979
	-- 1 row delete

--COMMIT TRAN
--ROLLBACK TRAN

-- VALIDATION

--SELECT acctId, CardAcceptorNameLocation, FirstDueDate, TermCmplDate, OriginalPurchaseAmount FROM CPSgmentCreditCard WITH (NOLOCK) WHERE acctId = 10782222
--SELECT acctId, parent02AID, InvoiceNumber FROM CPSgmentAccounts WITH (NOLOCK) WHERE acctId = 10782220
--SELECT TranID, InvoiceNumber FROM CCard_Secondary WITH (NOLOCK) WHERE TranID = 24400826089
--SELECT acctId, parent02AID, InvoiceNumber FROM CPSgmentAccounts WITH (NOLOCK) WHERE acctId = 10782221
--SELECT * FROM XrefTable WITH (NOLOCK) WHERE ParentATID = 51 AND ParentAID = 682840 AND ChildATID = 52 AND ChildAID = 10782221
----------------------
--SELECT acctId, CardAcceptorNameLocation, FirstDueDate, TermCmplDate, OriginalPurchaseAmount FROM CPSgmentCreditCard WITH (NOLOCK) WHERE acctId = 10793980
--SELECT acctId, parent02AID, InvoiceNumber FROM CPSgmentAccounts WITH (NOLOCK) WHERE acctId = 10793978
--SELECT TranID, InvoiceNumber FROM CCard_Secondary WITH (NOLOCK) WHERE TranID = 24350423832
--SELECT acctId, parent02AID, InvoiceNumber FROM CPSgmentAccounts WITH (NOLOCK) WHERE acctId = 10793979
--SELECT * FROM XrefTable WITH (NOLOCK) WHERE ParentATID = 51 AND ParentAID = 4251440 AND ChildATID = 52 AND ChildAID = 10793979