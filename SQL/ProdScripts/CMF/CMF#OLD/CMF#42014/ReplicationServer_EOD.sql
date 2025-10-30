-- TO BE RUN ON REPLICATION SERVER ONLY
---  1 row update each statement 
USE CCGS_RPT_CoreIssue
GO

BEGIN TRANSACTION

	UPDATE AccountInfoForReport SET CycleDueDTD = 0, SystemStatus = 2, AmountOfTotalDue = AmountOfTotalDue - 42, AmountOfPayment60DLate = AmountOfPayment60DLate - 42,
	 RunningMinimumDue = RunningMinimumDue - 42, RemainingMinimumDue = RemainingMinimumDue - 42, DaysDelinquent = 0, DateOfDelinquency = NULL, DateOfOriginalPaymentDueDTD = NULL, 
	 TotalDaysDelinquent = 0 WHERE BSacctId = 4879059 AND BusinessDay = '2020-09-02 23:59:57'

	UPDATE AccountInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 11.37, AmountOfTotalDue = AmountOfTotalDue - 11.37, 
	RunningMinimumDue = RunningMinimumDue - 11.37, RemainingMinimumDue = RemainingMinimumDue - 11.37,
	 DateOfOriginalPaymentDueDTD = NULL WHERE BSacctId = 7922350 AND BusinessDay = '2020-09-02 23:59:57'
	UPDATE PlanInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 1.99,
	 AmountOfTotalDue = AmountOfTotalDue - 1.99	 WHERE CPSacctId = 19350508 AND BusinessDay = '2020-09-02 23:59:57'

	UPDATE AccountInfoForReport SET CycleDueDTD = 0, SystemStatus = 2, AmountOfTotalDue = AmountOfTotalDue - 25, AmountOfPayment60DLate = AmountOfPayment60DLate - 25,
	 RunningMinimumDue = RunningMinimumDue - 25, RemainingMinimumDue = RemainingMinimumDue - 25, DaysDelinquent = 0, DateOfDelinquency = NULL, 
	 DateOfOriginalPaymentDueDTD = NULL, TotalDaysDelinquent = 0 WHERE BSacctId = 2651783 AND BusinessDay = '2020-09-02 23:59:57'

	UPDATE AccountInfoForReport SET AmtOfPayCurrDue = AmtOfPayCurrDue - 38.38, AmountOfTotalDue = AmountOfTotalDue - 38.38, RunningMinimumDue = RunningMinimumDue - 38.38,
	 RemainingMinimumDue = RemainingMinimumDue - 38.38, DateOfOriginalPaymentDueDTD = NULL	  WHERE BSacctId = 389157 AND BusinessDay = '2020-09-02 23:59:57'

	UPDATE PlanInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 29.86,
	 AmountOfTotalDue = AmountOfTotalDue - 29.86 	WHERE CPSacctId = 401377 AND BusinessDay = '2020-09-02 23:59:57'

	UPDATE AccountInfoForReport SET CycleDueDTD = 1, SystemStatus = 2, AmountOfTotalDue = AmountOfTotalDue - 113.16, AmountOfPayment60DLate = AmountOfPayment60DLate - 113.16,
	 RunningMinimumDue = RunningMinimumDue - 113.16, RemainingMinimumDue = RemainingMinimumDue - 113.16, DaysDelinquent = 0, DateOfDelinquency = NULL,
	  DateOfOriginalPaymentDueDTD = '2020-09-30 00:00:00.000',
	   TotalDaysDelinquent = 0 	  WHERE BSacctId = 9452918 AND BusinessDay = '2020-09-02 23:59:57'

	UPDATE AccountInfoForReport SET CycleDueDTD = 1, SystemStatus = 2, AmountOfTotalDue = AmountOfTotalDue - 144.74, AmountOfPayment60DLate = AmountOfPayment60DLate - 144.74,
	 RunningMinimumDue = RunningMinimumDue - 144.74, RemainingMinimumDue = RemainingMinimumDue - 144.74, DaysDelinquent = 0, DateOfDelinquency = NULL,
	  DateOfOriginalPaymentDueDTD = '2020-09-30 00:00:00.000'
	  , TotalDaysDelinquent = 0	   WHERE BSacctId = 8980362 AND BusinessDay = '2020-09-02 23:59:57'

	UPDATE AccountInfoForReport SET CycleDueDTD = 0, SystemStatus = 2, AmountOfTotalDue = AmountOfTotalDue - 48, AmountOfPayment60DLate = AmountOfPayment60DLate - 48, 
	RunningMinimumDue = RunningMinimumDue - 48, RemainingMinimumDue = RemainingMinimumDue - 48, DaysDelinquent = 0, DateOfDelinquency = NULL, DateOfOriginalPaymentDueDTD = NULL,
	 TotalDaysDelinquent = 0 WHERE BSacctId = 2331990 AND BusinessDay = '2020-09-02 23:59:57'

	UPDATE AccountInfoForReport SET CycleDueDTD = 1, SystemStatus = 2, AmountOfTotalDue = AmountOfTotalDue - 2.99, AmountOfPayment60DLate = AmountOfPayment60DLate - 2.99, 
	RunningMinimumDue = RunningMinimumDue - 2.99, RemainingMinimumDue = RemainingMinimumDue - 2.99, DaysDelinquent = 0, DateOfDelinquency = NULL,
	 DateOfOriginalPaymentDueDTD = '2020-09-30 00:00:00.000', TotalDaysDelinquent = 0 WHERE BSacctId = 9749132 AND BusinessDay = '2020-09-02 23:59:57'

	UPDATE AccountInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 34.04, AmountOfTotalDue = AmountOfTotalDue - 34.04,
	 RunningMinimumDue = RunningMinimumDue - 34.04, RemainingMinimumDue = RemainingMinimumDue - 34.04,
	  DateOfOriginalPaymentDueDTD = NULL 	  WHERE BSacctId = 248746 AND BusinessDay = '2020-09-02 23:59:57'

	UPDATE PlanInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 14.37, 
	AmountOfTotalDue = AmountOfTotalDue - 14.37 WHERE CPSacctId = 260816 AND BusinessDay = '2020-09-02 23:59:57'

	UPDATE AccountInfoForReport SET CycleDueDTD = 0, SystemStatus = 2, AmountOfTotalDue = AmountOfTotalDue - 58.25, 
	AmountOfPayment60DLate = AmountOfPayment60DLate - 58.25, RunningMinimumDue = RunningMinimumDue - 58.25, RemainingMinimumDue = RemainingMinimumDue - 58.25,
	 DaysDelinquent = 0, DateOfDelinquency = NULL, DateOfOriginalPaymentDueDTD = NULL, TotalDaysDelinquent = 0 WHERE BSacctId = 9407183 AND BusinessDay = '2020-09-02 23:59:57'

	UPDATE AccountInfoForReport SET CycleDueDTD = 0, SystemStatus = 2, AmountOfTotalDue = AmountOfTotalDue - 52.33,
	 AmountOfPayment60DLate = AmountOfPayment60DLate - 52.33, RunningMinimumDue = RunningMinimumDue - 52.33,
	  RemainingMinimumDue = RemainingMinimumDue - 52.33, DaysDelinquent = 0, DateOfDelinquency = NULL, DateOfOriginalPaymentDueDTD = NULL,
	   TotalDaysDelinquent = 0 WHERE BSacctId = 9596679 AND BusinessDay = '2020-09-02 23:59:57'

	UPDATE AccountInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 31.67, AmountOfTotalDue = AmountOfTotalDue - 31.67,
	 RunningMinimumDue = RunningMinimumDue - 31.67, RemainingMinimumDue = RemainingMinimumDue - 31.67,
	  DateOfOriginalPaymentDueDTD = NULL WHERE BSacctId = 9608821 AND BusinessDay = '2020-09-02 23:59:57'
	UPDATE PlanInfoForReport SET CycleDueDTD = 0, AmtOfPayCurrDue = AmtOfPayCurrDue - 21.82,
	 AmountOfTotalDue = AmountOfTotalDue - 21.82 WHERE CPSacctId = 23700979 AND BusinessDay = '2020-09-02 23:59:57'

	UPDATE AccountInfoForReport SET CycleDueDTD = 0, SystemStatus = 2, AmountOfTotalDue = AmountOfTotalDue - 25.00, AmountOfPayment60DLate = AmountOfPayment60DLate - 25.00,
	 RunningMinimumDue = RunningMinimumDue - 25.00, RemainingMinimumDue = RemainingMinimumDue - 25.00, DaysDelinquent = 0, DateOfDelinquency = NULL,
	  DateOfOriginalPaymentDueDTD = NULL, TotalDaysDelinquent = 0 WHERE BSacctId = 4617276 AND BusinessDay = '2020-09-02 23:59:57'

	UPDATE AccountInfoForReport SET CycleDueDTD = 0, SystemStatus = 2, AmountOfTotalDue = AmountOfTotalDue - 25.00, AmountOfPayment60DLate = AmountOfPayment60DLate - 25.00, 
	RunningMinimumDue = RunningMinimumDue - 25.00, RemainingMinimumDue = RemainingMinimumDue - 25.00, DaysDelinquent = 0, DateOfDelinquency = NULL,
	 DateOfOriginalPaymentDueDTD = NULL, TotalDaysDelinquent = 0 WHERE BSacctId = 4191664 AND BusinessDay = '2020-09-02 23:59:57'


COMMIT TRANSACTION
--ROLLBACK TRANSACTION