-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreIssue
GO


BEGIN TRANSACTION
--COMMIT TRANSACTION
-- ROLLBACK TRANSACTION

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue - 2.59 WHERE acctId = 14715 AND StatementID = 103864609
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 1, AmtOfPayXDLate = AmtOfPayXDLate - 2.59 WHERE acctId = 14715 AND StatementID = 103864609


UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue - 24.30 WHERE acctId = 15984 AND StatementID = 103674638
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 1, AmtOfPayXDLate = AmtOfPayXDLate - 24.30 WHERE acctId = 15984 AND StatementID = 103674638



UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue - 24.82 WHERE acctId = 16587 AND StatementID = 103624673
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 1, AmtOfPayXDLate = AmtOfPayXDLate - 24.82 WHERE acctId = 16587 AND StatementID = 103624673



UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue - 21.03 WHERE acctId = 55603609 AND StatementID = 103895005
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 1, AmtOfPayXDLate = AmtOfPayXDLate - 21.03 WHERE acctId = 55603609 AND StatementID = 103895005



UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue - 24.34 WHERE acctId = 56291 AND StatementID = 103665056
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 1, AmtOfPayXDLate = AmtOfPayXDLate - 24.34 WHERE acctId = 56291 AND StatementID = 103665056



UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue - 24.69 WHERE acctId = 120236 AND StatementID = 103885350
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 1, AmtOfPayXDLate = AmtOfPayXDLate - 24.69 WHERE acctId = 120236 AND StatementID = 103885350



UPDATE TOP(1) StatementHeader SET MinimumPaymentDue = MinimumPaymentDue - 42.88, AmountOfTotalDue = AmountOfTotalDue - 42.88, AmtOfPayXDLate = AmtOfPayXDLate - 42.88,
AmtOfPayPastDue = AmtOfPayPastDue - 42.88, CycleDueDTD = 1, SystemStatus = 2 WHERE acctId = 122810 AND StatementID = 103905657



UPDATE TOP(1) StatementHeader SET AmtOfPayCurrDue = AmtOfPayCurrDue + 3.4, AmtOfPayXDLate = AmtOfPayXDLate - 3.4,
AmtOfPayPastDue = AmtOfPayPastDue - 3.4, CycleDueDTD = 0, SystemStatus = 2 WHERE acctId = 244248 AND StatementID = 104005704


UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue - 3.4 WHERE acctId = 20590875 AND StatementID = 104005704
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0, AmtOfPayXDLate = AmtOfPayXDLate - 3.4 WHERE acctId = 20590875 AND StatementID = 104005704




UPDATE TOP(1) StatementHeader SET AmtOfPayCurrDue = AmtOfPayCurrDue + 52.30, AmtOfPayXDLate = AmtOfPayXDLate - 26.15, AmountOfPayment30DLate = AmountOfPayment30DLate - 26.15, 
AmtOfPayPastDue = AmtOfPayPastDue - 52.30, SRBWithInstallmentDue = SRBWithInstallmentDue - 52.30, SBWithInstallmentDue = SBWithInstallmentDue - 52.30, 
CycleDueDTD = 1, SystemStatus = 2 WHERE acctId = 417786 AND StatementID = 103690220


UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue + 7.78 WHERE acctId = 430006 AND StatementID = 103690220
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 1, CurrentDue = CurrentDue + 7.78 WHERE acctId = 430006 AND StatementID = 103690220

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue + 3.41 WHERE acctId = 6277877 AND StatementID = 103690220
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 1, CurrentDue = CurrentDue + 3.41 WHERE acctId = 6277877 AND StatementID = 103690220

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = 0 WHERE acctId = 57775975 AND StatementID = 103690220
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0, CurrentDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, 
SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 57775975 AND StatementID = 103690220

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = 0 WHERE acctId = 57775976 AND StatementID = 103690220
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0, CurrentDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, 
SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 57775976 AND StatementID = 103690220



UPDATE TOP(1) StatementHeader SET AmtOfPayCurrDue = AmtOfPayCurrDue + 25, AmtOfPayXDLate = AmtOfPayXDLate - 25,
AmtOfPayPastDue = AmtOfPayPastDue - 25, CycleDueDTD = 0, SystemStatus = 2 WHERE acctId = 588281 AND StatementID = 104110148

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue - 25 WHERE acctId = 600501 AND StatementID = 104110148
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0, AmtOfPayXDLate = AmtOfPayXDLate - 25 WHERE acctId = 600501 AND StatementID = 104110148



UPDATE TOP(1) StatementHeader SET AmtOfPayCurrDue = AmtOfPayCurrDue + 23.20, AmtOfPayXDLate = AmtOfPayXDLate - 23.20, 
AmtOfPayPastDue = AmtOfPayPastDue - 23.20, SRBWithInstallmentDue = SRBWithInstallmentDue - 23.20, SBWithInstallmentDue = SBWithInstallmentDue - 23.20, 
CycleDueDTD = 0, SystemStatus = 2 WHERE acctId = 659234 AND StatementID = 104226115

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = 0 WHERE acctId = 66215965 AND StatementID = 104226115
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0, CurrentDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, 
SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 66215965 AND StatementID = 104226115

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = 0 WHERE acctId = 66810225 AND StatementID = 104226115
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0, CurrentDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, 
SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 66810225 AND StatementID = 104226115



UPDATE TOP(1) StatementHeader SET AmtOfPayCurrDue = AmtOfPayCurrDue + 4.08, AmtOfPayXDLate = AmtOfPayXDLate - 4.08, 
AmtOfPayPastDue = AmtOfPayPastDue - 4.08, SRBWithInstallmentDue = SRBWithInstallmentDue - 4.08, SBWithInstallmentDue = SBWithInstallmentDue - 4.08, 
CycleDueDTD = 0, SystemStatus = 2 WHERE acctId = 883659 AND StatementID = 104403680

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = 0 WHERE acctId = 66742392 AND StatementID = 104403680
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0, CurrentDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, 
SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 66742392 AND StatementID = 104403680



UPDATE TOP(1) StatementHeader SET AmtOfPayCurrDue = AmtOfPayCurrDue + 34.66, AmtOfPayXDLate = AmtOfPayXDLate - 34.66, 
AmtOfPayPastDue = AmtOfPayPastDue - 34.66, SRBWithInstallmentDue = SRBWithInstallmentDue - 34.66, SBWithInstallmentDue = SBWithInstallmentDue - 34.66, 
CycleDueDTD = 0, SystemStatus = 2 WHERE acctId = 1240951 AND StatementID = 104747916

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = 0 WHERE acctId = 66478297 AND StatementID = 104747916
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0, CurrentDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, 
SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 66478297 AND StatementID = 104747916

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = 0 WHERE acctId = 66478298 AND StatementID = 104747916
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0, CurrentDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, 
SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 66478298 AND StatementID = 104747916



UPDATE TOP(1) StatementHeader SET AmtOfPayCurrDue = AmtOfPayCurrDue + 41.51, AmountOfPayment30DLate = AmountOfPayment30DLate - 41.51, 
AmtOfPayPastDue = AmtOfPayPastDue - 41.51, SRBWithInstallmentDue = SRBWithInstallmentDue - 41.5, SBWithInstallmentDue = SBWithInstallmentDue - 41.5, 
CycleDueDTD = 0, SystemStatus = 2 WHERE acctId = 1255358 AND StatementID = 104769291

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = 0 WHERE acctId = 44752305 AND StatementID = 104769291
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0, CurrentDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, 
SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 44752305 AND StatementID = 104769291

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = 0 WHERE acctId = 45639853 AND StatementID = 104769291
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0, CurrentDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, 
SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 45639853 AND StatementID = 104769291



UPDATE TOP(1) StatementHeader SET AmtOfPayCurrDue = AmtOfPayCurrDue + 25, AmtOfPayXDLate = AmtOfPayXDLate - 25, 
AmtOfPayPastDue = AmtOfPayPastDue - 25, CycleDueDTD = 0, SystemStatus = 2 WHERE acctId = 1344799 AND StatementID = 104837873

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = 0 WHERE acctId = 1357219 AND StatementID = 104837873
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0, CurrentDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, 
SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 1357219 AND StatementID = 104837873



UPDATE TOP(1) StatementHeader SET AmtOfPayCurrDue = AmtOfPayCurrDue + 4.47, AmtOfPayXDLate = AmtOfPayXDLate - 4.47, 
AmtOfPayPastDue = AmtOfPayPastDue - 4.47, CycleDueDTD = 0, SystemStatus = 2 WHERE acctId = 1356278 AND StatementID = 104856766

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = 0 WHERE acctId = 8350272 AND StatementID = 104856766
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0, CurrentDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, 
SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 8350272 AND StatementID = 104856766



UPDATE TOP(1) StatementHeader SET AmtOfPayCurrDue = AmtOfPayCurrDue + 49.16, AmtOfPayXDLate = AmtOfPayXDLate - 49.16, 
AmtOfPayPastDue = AmtOfPayPastDue - 49.16, SRBWithInstallmentDue = SRBWithInstallmentDue - 49.16, SBWithInstallmentDue = SBWithInstallmentDue - 49.16, 
CycleDueDTD = 0, SystemStatus = 2 WHERE acctId = 1378174 AND StatementID = 104866604

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = 0 WHERE acctId = 67069091 AND StatementID = 104866604
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0, CurrentDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, 
SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 67069091 AND StatementID = 104866604


UPDATE TOP(1) StatementHeader SET AmtOfPayCurrDue = AmtOfPayCurrDue + 0.02, AmtOfPayPastDue = AmtOfPayPastDue - 0.02,
AmountOfPayment60DLate = AmountOfPayment60DLate - 0.02 WHERE acctId = 1392139 AND StatementID = 104934604

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue + 10.46 WHERE acctId = 1404559 AND StatementID = 104934604
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 1, CurrentDue = CurrentDue + 10.46 WHERE acctId = 1404559 AND StatementID = 104934604

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue - 0.02 WHERE acctId = 12720174 AND StatementID = 104934604
UPDATE TOP(1) SummaryHeaderCreditCard SET AmountOfPayment60DLate = AmountOfPayment60DLate - 0.02 WHERE acctId = 12720174 AND StatementID = 104934604



UPDATE TOP(1) StatementHeader SET AmtOfPayCurrDue = AmtOfPayCurrDue + 37.45, AmtOfPayXDLate = AmtOfPayXDLate - 37.45, 
AmtOfPayPastDue = AmtOfPayPastDue - 37.45, SRBWithInstallmentDue = SRBWithInstallmentDue - 37.45, SBWithInstallmentDue = SBWithInstallmentDue - 37.45, 
CycleDueDTD = 0, SystemStatus = 2 WHERE acctId = 1508643 AND StatementID = 105037539

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = 0 WHERE acctId = 41925982 AND StatementID = 105037539
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0, CurrentDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, 
SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 41925982 AND StatementID = 105037539



UPDATE TOP(1) StatementHeader SET AmtOfPayCurrDue = AmtOfPayCurrDue + 3, AmtOfPayXDLate = AmtOfPayXDLate - 3, 
AmtOfPayPastDue = AmtOfPayPastDue - 3, CycleDueDTD = 0, SystemStatus = 2 WHERE acctId = 1722050 AND StatementID = 105218369

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = 0 WHERE acctId = 13449029 AND StatementID = 105218369
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0, CurrentDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, 
SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 13449029 AND StatementID = 105218369



UPDATE TOP(1) StatementHeader SET AmtOfPayCurrDue = AmtOfPayCurrDue + 1.17, AmtOfPayXDLate = AmtOfPayXDLate - 1.17, 
AmtOfPayPastDue = AmtOfPayPastDue - 1.17, CycleDueDTD = 0, SystemStatus = 2 WHERE acctId = 1841625 AND StatementID = 105290706

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = 0 WHERE acctId = 16149698 AND StatementID = 105290706
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0, CurrentDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, 
SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 16149698 AND StatementID = 105290706



UPDATE TOP(1) StatementHeader SET MinimumPaymentDue = MinimumPaymentDue - 172.89, AmountOfTotalDue = AmountOfTotalDue - 172.89, AmtOfPayCurrDue = AmtOfPayCurrDue + 52.02, 
AmtOfPayXDLate = AmtOfPayXDLate - 224.91, AmtOfPayPastDue = AmtOfPayPastDue - 224.91, SRBWithInstallmentDue = SRBWithInstallmentDue - 224.91, 
SBWithInstallmentDue = SBWithInstallmentDue - 224.91, CycleDueDTD = 1, SystemStatus = 2 WHERE acctId = 1845697 AND StatementID = 105286088

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue + 224.91 WHERE acctId = 1865687 AND StatementID = 105286088
UPDATE TOP(1) SummaryHeaderCreditCard SET CurrentDue = CurrentDue + 224.91 WHERE acctId = 1865687 AND StatementID = 105286088

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = 0 WHERE acctId = 67385604 AND StatementID = 105286088
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0, CurrentDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, 
SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 67385604 AND StatementID = 105286088



UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue + 3.07 WHERE acctId = 2136728 AND StatementID = 105532781
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 1, CurrentDue = CurrentDue + 3.07 WHERE acctId = 2136728 AND StatementID = 105532781




UPDATE TOP(1) StatementHeader SET AmtOfPayCurrDue = AmtOfPayCurrDue + 54.64, AmtOfPayXDLate = AmtOfPayXDLate - 54.64,
AmtOfPayPastDue = AmtOfPayPastDue - 54.64, SRBWithInstallmentDue = SRBWithInstallmentDue + 94.33, 
SBWithInstallmentDue = SBWithInstallmentDue + 94.33, CycleDueDTD = 1, SystemStatus = 2 WHERE acctId = 2706267 AND StatementID = 106120160

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = 0 WHERE acctId = 13079736 AND StatementID = 106120160
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0, CurrentDue = 0, AmtOfPayXDLate = 0 WHERE acctId = 13079736 AND StatementID = 106120160

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue + 1124.01 WHERE acctId = 69562449 AND StatementID = 106120160
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 1, CurrentDue = CurrentDue + 1124.01, SRBWithInstallmentDue = SRBWithInstallmentDue + 1124.01, 
SBWithInstallmentDue = SBWithInstallmentDue + 1124.01 WHERE acctId = 69562449 AND StatementID = 106120160




UPDATE TOP(1) StatementHeader SET AmtOfPayCurrDue = AmtOfPayCurrDue + 33.81, AmtOfPayXDLate = AmtOfPayXDLate - 33.81, 
AmtOfPayPastDue = AmtOfPayPastDue - 33.81, SRBWithInstallmentDue = SRBWithInstallmentDue - 9.54, SBWithInstallmentDue = SBWithInstallmentDue - 9.54, 
CycleDueDTD = 0, SystemStatus = 2 WHERE acctId = 2724147 AND StatementID = 106136111

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = 0 WHERE acctId = 2872157 AND StatementID = 106136111
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0, CurrentDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, 
SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 2872157 AND StatementID = 106136111

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = 0 WHERE acctId = 36114861 AND StatementID = 106136111
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0, CurrentDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, 
SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 36114861 AND StatementID = 106136111




UPDATE TOP(1) StatementHeader SET AmtOfPayCurrDue = AmtOfPayCurrDue + 1.31, AmtOfPayXDLate = AmtOfPayXDLate - 1.31,
AmtOfPayPastDue = AmtOfPayPastDue - 1.31, SRBWithInstallmentDue = SRBWithInstallmentDue + 22.04, 
SBWithInstallmentDue = SBWithInstallmentDue + 22.04, CycleDueDTD = 1, SystemStatus = 2 WHERE acctId = 2837196 AND StatementID = 106246793

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = 0 WHERE acctId = 9699839 AND StatementID = 106246793
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0, CurrentDue = 0, AmtOfPayXDLate = 0 WHERE acctId = 9699839 AND StatementID = 106246793

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue + 239.50 WHERE acctId = 45993145 AND StatementID = 106246793
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 1, CurrentDue = CurrentDue + 239.50, SRBWithInstallmentDue = SRBWithInstallmentDue + 239.50, 
SBWithInstallmentDue = SBWithInstallmentDue + 239.50 WHERE acctId = 45993145 AND StatementID = 106246793




UPDATE TOP(1) StatementHeader SET AmtOfPayCurrDue = AmtOfPayCurrDue + 0.1, AmtOfPayPastDue = AmtOfPayPastDue - 0.1,
AmountOfPayment30DLate = AmountOfPayment30DLate - 0.10 WHERE acctId = 2983913 AND StatementID = 106328530

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue + 28.4 WHERE acctId = 3472063 AND StatementID = 106328530
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 1, CurrentDue = CurrentDue + 28.4 WHERE acctId = 3472063 AND StatementID = 106328530

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue - 0.1 WHERE acctId = 10320496 AND StatementID = 106328530
UPDATE TOP(1) SummaryHeaderCreditCard SET AmountOfPayment30DLate = AmountOfPayment30DLate - 0.1 WHERE acctId = 10320496 AND StatementID = 106328530




UPDATE TOP(1) StatementHeader SET AmtOfPayCurrDue = AmtOfPayCurrDue + 18.7, AmtOfPayXDLate = AmtOfPayXDLate - 18.7, 
AmtOfPayPastDue = AmtOfPayPastDue - 18.7, SRBWithInstallmentDue = SRBWithInstallmentDue - 18.7, SBWithInstallmentDue = SBWithInstallmentDue - 18.7, 
CycleDueDTD = 0, SystemStatus = 2 WHERE acctId = 3996361 AND StatementID = 106533913

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = 0 WHERE acctId = 11109111 AND StatementID = 106533913
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0, CurrentDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, 
SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 11109111 AND StatementID = 106533913




UPDATE TOP(1) StatementHeader SET AmtOfPayCurrDue = AmtOfPayCurrDue + 41.62, AmtOfPayXDLate = AmtOfPayXDLate - 41.62, 
AmtOfPayPastDue = AmtOfPayPastDue - 41.62, SRBWithInstallmentDue = SRBWithInstallmentDue - 41.62, SBWithInstallmentDue = SBWithInstallmentDue - 41.62, 
CycleDueDTD = 1, SystemStatus = 2 WHERE acctId = 7853217 AND StatementID = 107243100

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = 0 WHERE acctId = 67249738 AND StatementID = 107243100
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0, CurrentDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, 
SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 67249738 AND StatementID = 107243100

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = AmountOfTotalDue + 20.98 WHERE acctId = 19159375 AND StatementID = 107243100
UPDATE TOP(1) SummaryHeaderCreditCard SET CurrentDue = CurrentDue + 20.98 WHERE acctId = 19159375 AND StatementID = 107243100




UPDATE TOP(1) StatementHeader SET AmtOfPayCurrDue = AmtOfPayCurrDue + 0.64, AmtOfPayXDLate = AmtOfPayXDLate - 0.64, 
AmtOfPayPastDue = AmtOfPayPastDue - 0.64, CycleDueDTD = 0, SystemStatus = 2 WHERE acctId = 8940606 AND StatementID = 107370885

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = 0 WHERE acctId = 33326406 AND StatementID = 107370885
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0, CurrentDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, 
SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 33326406 AND StatementID = 107370885




UPDATE TOP(1) StatementHeader SET AmtOfPayCurrDue = AmtOfPayCurrDue + 171.19, AmtOfPayXDLate = AmtOfPayXDLate - 171.19, 
AmtOfPayPastDue = AmtOfPayPastDue - 171.19, SRBWithInstallmentDue = SRBWithInstallmentDue - 146.19, SBWithInstallmentDue = SBWithInstallmentDue - 146.19, 
CycleDueDTD = 0, SystemStatus = 2 WHERE acctId = 9806096 AND StatementID = 107517700

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = 0 WHERE acctId = 24106254 AND StatementID = 107517700
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0, CurrentDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, 
SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 24106254 AND StatementID = 107517700

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = 0 WHERE acctId = 33539153 AND StatementID = 107517700
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0, CurrentDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, 
SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 33539153 AND StatementID = 107517700

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = 0 WHERE acctId = 33539154 AND StatementID = 107517700
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0, CurrentDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, 
SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 33539154 AND StatementID = 107517700

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = 0 WHERE acctId = 37712715 AND StatementID = 107517700
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0, CurrentDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, 
SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 37712715 AND StatementID = 107517700

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = 0 WHERE acctId = 37712824 AND StatementID = 107517700
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0, CurrentDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, 
SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 37712824 AND StatementID = 107517700

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = 0 WHERE acctId = 37712825 AND StatementID = 107517700
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0, CurrentDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, 
SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 37712825 AND StatementID = 107517700

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = 0 WHERE acctId = 53701058 AND StatementID = 107517700
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0, CurrentDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, 
SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 53701058 AND StatementID = 107517700

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = 0 WHERE acctId = 67224884 AND StatementID = 107517700
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0, CurrentDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, 
SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 67224884 AND StatementID = 107517700

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = 0 WHERE acctId = 67225007 AND StatementID = 107517700
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0, CurrentDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, 
SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 67225007 AND StatementID = 107517700




UPDATE TOP(1) StatementHeader SET AmtOfPayCurrDue = AmtOfPayCurrDue + 8.72, AmtOfPayXDLate = AmtOfPayXDLate - 8.72, 
AmtOfPayPastDue = AmtOfPayPastDue - 8.72, CycleDueDTD = 0, SystemStatus = 2 WHERE acctId = 10655987 AND StatementID = 107624261

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = 0 WHERE acctId = 28870326 AND StatementID = 107624261
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0, CurrentDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, 
SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 28870326 AND StatementID = 107624261



UPDATE TOP(1) StatementHeader SET AmtOfPayCurrDue = AmtOfPayCurrDue + 64.49, AmtOfPayXDLate = AmtOfPayXDLate - 64.49, 
AmtOfPayPastDue = AmtOfPayPastDue - 64.49, SRBWithInstallmentDue = SRBWithInstallmentDue - 64.49, SBWithInstallmentDue = SBWithInstallmentDue - 64.49, 
CycleDueDTD = 0, SystemStatus = 2 WHERE acctId = 11089488 AND StatementID = 107682275

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = 0 WHERE acctId = 35504324 AND StatementID = 107682275
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0, CurrentDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, 
SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 35504324 AND StatementID = 107682275

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = 0 WHERE acctId = 36850490 AND StatementID = 107682275
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0, CurrentDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, 
SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 36850490 AND StatementID = 107682275


UPDATE TOP(1) StatementHeader SET AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmtOfPayPastDue = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0, 
CycleDueDTD = 0, SystemStatus = 2 WHERE acctId = 11520974 AND StatementID = 107794060

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = 0 WHERE acctId = 67551672 AND StatementID = 107794060
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0, CurrentDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, 
SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 67551672 AND StatementID = 107794060


UPDATE TOP(1) StatementHeader SET AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmtOfPayPastDue = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0, 
CycleDueDTD = 0, SystemStatus = 2 WHERE acctId = 13071394 AND StatementID = 108210332

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = 0 WHERE acctId = 66851331 AND StatementID = 108210332
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0, CurrentDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, 
SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 66851331 AND StatementID = 108210332


UPDATE TOP(1) StatementHeader SET AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmtOfPayPastDue = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0, 
CycleDueDTD = 0, SystemStatus = 2 WHERE acctId = 13572797 AND StatementID = 108344142

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = 0 WHERE acctId = 67141268 AND StatementID = 108344142
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0, CurrentDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, 
SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 67141268 AND StatementID = 108344142



UPDATE TOP(1) StatementHeader SET AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmtOfPayPastDue = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0, 
CycleDueDTD = 0, SystemStatus = 2 WHERE acctId = 13611044 AND StatementID = 108380549

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = 0 WHERE acctId = 40157009 AND StatementID = 108380549
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0, CurrentDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, 
SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 40157009 AND StatementID = 108380549


UPDATE TOP(1) StatementHeader SET AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmtOfPayPastDue = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0, 
CycleDueDTD = 0, SystemStatus = 2 WHERE acctId = 18041996 AND StatementID = 108749301

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = 0 WHERE acctId = 66124027 AND StatementID = 108749301
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0, CurrentDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, 
SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 66124027 AND StatementID = 108749301


UPDATE TOP(1) StatementHeader SET AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmtOfPayPastDue = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0, 
CycleDueDTD = 0, SystemStatus = 2 WHERE acctId = 18390195 AND StatementID = 109443788

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = 0 WHERE acctId = 57295800 AND StatementID = 109443788
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0, CurrentDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, 
SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 57295800 AND StatementID = 109443788

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = 0 WHERE acctId = 66432453 AND StatementID = 109443788
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0, CurrentDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, 
SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 66432453 AND StatementID = 109443788


UPDATE TOP(1) StatementHeader SET AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmtOfPayPastDue = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0, 
CycleDueDTD = 0, SystemStatus = 2 WHERE acctId = 13071394 AND StatementID = 108210332

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = 0 WHERE acctId = 66851331 AND StatementID = 108210332
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0, CurrentDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, 
SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 66851331 AND StatementID = 108210332

UPDATE TOP(1) StatementHeader SET AmtOfPayCurrDue = 0, AmtOfPayXDLate = 0, AmtOfPayPastDue = 0, SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0, 
CycleDueDTD = 0, SystemStatus = 2 WHERE acctId = 20602937 AND StatementID = 109888282

UPDATE TOP(1) SummaryHeader SET AmountOfTotalDue = 0 WHERE acctId = 65591084 AND StatementID = 109888282
UPDATE TOP(1) SummaryHeaderCreditCard SET CycleDueDTD = 0, CurrentDue = 0, AmtOfPayXDLate = 0, AmountOfPayment30DLate = 0, 
SRBWithInstallmentDue = 0, SBWithInstallmentDue = 0 WHERE acctId = 65591084 AND StatementID = 109888282


