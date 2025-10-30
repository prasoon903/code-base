Begin  Tran 
--Commit 
--rollback 


      UPDATE PIR
      SET    PIR.AmtOfPayCurrDue = SHCC.CurrentDue,
             PIR.AmtOfPayXDLate = SHCC.AmtOfPayXDLate,
             PIR.AmountOfPayment30DLate = SHCC.AmountOfPayment30DLate,
             PIR.AmountOfPayment60DLate = SHCC.AmountOfPayment60DLate,
             PIR.AmountOfPayment90DLate = SHCC.AmountOfPayment90DLate,
             PIR.AmountOfPayment120DLate = SHCC.AmountOfPayment120DLate,
             PIR.AmountOfPayment150DLate = SHCC.AmountOfPayment150DLate,
             PIR.AmountOfPayment180DLate = SHCC.AmountOfPayment180DLate,
             PIR.AmountOfPayment210DLate = SHCC.AmountOfPayment210DLate,
			 PIR.CurrentBalance          = SH.CurrentBalance,
			 PIR.Principal               = SH.Principal,
			 PIR.AmountOfTotalDue        = SH.AmountOfTotalDue,
			 PIR.IntBilledNotPaid        = SH.IntBilledNotPaid,
			 PIR.AmtOfInterestCTD        = SH.AmtOfInterestCTD,
			 PIR.recoveryfeesbnp         = SH.recoveryfeesbnp,
			 PIR.RecoveryFeesCTD         = SH.RecoveryFeesCTD,
			 PIR.AmountOfPurchasesLTD    = SH.AmountOfPurchasesLTD,
			 PIR.AmountOfReturnsLTD      = SH.AmountOfReturnsLTD,
			 PIR.CurrentBalanceCO        = SHCC.CurrentBalanceCO,
			 PIR.SRBWithInstallmentDue   = SHCC.SRBWithInstallmentDue,
			 PIR.SBWithInstallmentDue    = SHCC.SBWithInstallmentDue,
			 PIR.RetailAniversaryDate    = SHCC.RetailAniversaryDate,
			 PIR.LastStatementDate		  = '2021-08-31 23:59:57.000'
      FROM   PlanInfoForReport PIR
             JOIN SummaryHeader SH WITH(NOLOCK)
               ON ( 
                     PIR.CPSAcctid = SH.acctId
                    AND SH.StatementDate = '2021-08-31 23:59:57.000' )
             JOIN SummaryHeaderCreditCard SHCC WITH(NOLOCK)
               ON ( SH.acctId = SHCC.acctId
                    AND SH.StatementID = SHCC.StatementID )
					where  sh.parent02aid in  (1775930, 20453980) 
					and PIR.BusinessDay  = '2021-08-31 23:59:57.000'