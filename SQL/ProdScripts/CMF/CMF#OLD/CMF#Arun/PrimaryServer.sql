BEGIN TRANSACTION
-- COMMIT TRANSACTION
-- ROLLBACK TRANSACTION

----UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 83259657
----UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 83295792
----UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 81959312
----UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 81190768
----UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 82271542
----UPDATE TOP(1) CCard_Primary SET AccountNumber = '1100011173823067', ClientID = '3ea11168-5310-468b-8334-9976a0b1bab1', TxnAcctID = 17006796, EmbAcctId = 23037222 WHERE TranID = 59375432334
----update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 36.62 where  acctid  =  47221237
----update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 6.20 where  acctid  =  47221238
----update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  - 8.25 where  acctid  =  55038090
----UPDATE TOP(1) BSegmentCreditCard SET ManualInitialChargeOffStartDate = '2022-03-31 23:59:57'  WHERE AcctID = 18286471


UPDATE TOP(1) BSegment_Primary SET CycleDueDTD = 0, SystemStatus = 2, AmtOfPayCurrDue = 0 WHERE acctID = 4568915
UPDATE TOP(1) BSegmentCreditCard SET AmountOfTotalDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0,  RunningMinimumDue = 0, RemainingMinimumDue = 0, SRBWithInstallmentDue = 0, DaysDelinquent = 0, NoPayDaysDelinquent = 0,   DAteOfOriginalPaymentDueDTD = NULL, DtOfLastDelinqCTD = NULL, FirstDueDate = NULL  WHERE acctID = 4568915

UPDATE TOP(1) CPSgmentCreditCard SET CycleDueDTD = 0, AmountOfTotalDue = 0, AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, AmountOfPayment60DLate = 0 WHERE acctID = 8557073

update top(1) cpsgmentaccounts  set AmountOfCreditsLTD =  AmountOfCreditsLTD  + 27.13 where  acctid  =  46631724

UPDATE TOP(1) CPSgmentAccounts SET CreditPlanType = '0' WHERE acctId = 83345891

UPDATE TOP(1) BSegmentCreditCard SET ManualInitialChargeOffStartDate = '2022-04-30 23:59:57'  WHERE AcctID = 18286471

--SELECT ManualInitialChargeOffStartDate, AutoInitialChargeOffStartDate, chargeoffdate, * FROM BSegmentCreditCard WITH (NOLOCK) WHERE AcctID = 18286471

