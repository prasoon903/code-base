Begin Tran 
--Commit 
--rollback 
-- 1 rows update 

	  UPDATE AIR
      SET    AIR.DaysDelinquent = SE.DaysDelinquent,
			 AIR.TotalDaysDelinquent = SE.NoPayDaysDelinquent,
			 AIR.DateOfDelinquency = SE.DtOfLastDelinqCTD,
			 AIR.AmtOfPayCurrDue = SH.AmtOfPayCurrDue,
             AIR.AmtOfPayXDLate = SH.AmtOfPayXDLate,
             AIR.AmountOfPayment30DLate = SH.AmountOfPayment30DLate,
             AIR.AmountOfPayment60DLate = SH.AmountOfPayment60DLate,
             AIR.AmountOfPayment90DLate = SH.AmountOfPayment90DLate,
             AIR.AmountOfPayment120DLate = SH.AmountOfPayment120DLate,
             AIR.AmountOfPayment150DLate = SH.AmountOfPayment150DLate,
             AIR.AmountOfPayment180DLate = SH.AmountOfPayment180DLate,
             AIR.AmountOfPayment210DLate = SH.AmountOfPayment210DLate,
			 AIR.ActualDRPStartDate      = SH.ActualDRPStartDate, --Added on StatementHeader to Update on Businessday = LastStatementDate
			 AIR.ccinhparent125AID       = SH.ccinhparent125AID,   --Added on StatementHeader to Update on Businessday = LastStatementDate
			 AIR.CurrentBalance					= SH.CurrentBalance,
			 AIR.Principal						= SH.Principal,
			 AIR.AmountOfTotalDue				= SH.AmountOfTotalDue,
			 AIR.SystemStatus					= SH.SystemStatus,
			 AIR.CycleDueDTD					= SH.CycleDueDTD,
			 AIR.DateOfTotalDue					= SH.DateOfTotalDue,
			 AIR.CreditLimit					= SH.CreditLimit,
			 AIR.TotalOutStgAuthAmt				= SH.TotalOutStgAuthAmt,
			 AIR.PendingOTB						= SE.PendingOTB,
			 AIR.recoveryfeesbnp				= SH.recoveryfeesbnp,
			 AIR.RecoveryFeesCTD				= SH.RecoveryFeesCTD,
			 AIR.DateOfOriginalPaymentDueDTD    = SH.DateOfOriginalPaymentDueDTD,
			 AIR.AmountOfDebitsCTD              = SH.AmountOfDebitsCTD,
			 AIR.AmountOfCreditsCTD             = SH.AmountOfCreditsCTD,
			 AIR.DisputesAmtNS                  = SH.DisputesAmtNS,
			 AIR.SystemChargeOffStatus          = SH.SystemChargeOffStatus,
			 AIR.AmtOfInterestYTD               = SH.AmtOfInterestYTD,
			 AIR.userchargeoffstatus            = SH.userchargeoffstatus,
			 AIR.CurrentBalanceCo               = SH.CurrentBalanceCo,
			 AIR.ManualInitialChargeOffReason   = SH.ManualInitialChargeOffReason,
			 AIR.AutoInitialChargeOffReason     = SH.AutoInitialChargeOffReason,
			 AIR.AmountOfPurchasesLTD           = SH.AmountOfPurchasesLTD,
			 AIR.AmtOfDispRelFromOTB            = SH.AmtOfDispRelFromOTB,
			 AIR.SRBWithInstallmentDue          = SH.SRBWithInstallmentDue,
			 AIR.SBWithInstallmentDue           = SH.SBWithInstallmentDue,
			 AIR.LAstStatementdate				= '2021-08-31 23:59:57.000',
			 AIR.DateOfNextStmt					= '2021-09-30 23:59:57.000'
      FROM   AccountInfoForReport AIR
             JOIN StatementHeader SH WITH(NOLOCK)
               ON ( AIR.Businessday = '2021-08-31 23:59:57.000'
                    AND AIR.BSAcctid = SH.acctId)
			JOIN StatementHeaderEx SE WITH(NOLOCK)
			  ON (SH.acctId = SE.acctId
                    AND SH.StatementID = SE.StatementID)
					where   SH.acctid in (1775930, 20453980) 
					 		AND SH.StatementDate = '2021-08-31 23:59:57.000'

