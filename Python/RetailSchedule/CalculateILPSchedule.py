from GetUniqueID import GetUniqueID


class CalculateILPSchedule:

    def CalculateILPSchedule(self,
                             cAPR,
                             iEqualPaymentTerm,
                             cLoanAmount,
                             dNextStatementDate,
                             dPosttime,
                             cDailyfactorF,
                             sAccuralMethod,
                             sIntonInt,
                             iPlanID,
                             iInterestPlan,
                             iParent02AID,
                             iAPIFlag,
                             iTranID,
                             cEqualPaymentAmount,
                             iAuthTranID,
                             CPSUniversalUniqueID,
                             RetailUniversalUniqueID,
                             iRevisedFlag,
                             cInFirstMonthPayment,
                             sTransactionUniqueID,
                             sTranType,
                             iActivity,
                             iWaiveMinDueCycle,
                             iCaseID,
                             dLastStatementdatePassed,
                             sDrCrIndicator,
                             sCardAcceptorNameLocation):

        sILPScheduleType = "Initial"
        iActivityOrder = 1
        iIteration = 4

        PostValue = GetUniqueID()

        ILPSchedule = dict()

        # cLoanAmount = float(cLoanAmount)
        # cAPR = float(cAPR)

        if iRevisedFlag != 1:
            iScheduleID = PostValue.GetUniqueID("ScheduleID")

        cDailyfactor = cDailyfactorF

        if cEqualPaymentAmount > 0:
            iIteration = 1
            cEqualPaymentAmountCalc = 0
            iScheduleIndicator = 1

        if cEqualPaymentAmount is None:
            cEqualPaymentAmount = 0.0

        if cLoanAmount <= 0:
            iEqualPaymentTerm = 1

        PV = round(cLoanAmount, 2)
        rate = round(cAPR, 6)

        TempReal1 = 0
        cPMT = 0
        if iEqualPaymentTerm > 0:
            TempReal1 = 1 - pow(1 + rate, -iEqualPaymentTerm)

        if TempReal1 > 0:
            cPMT = round(PV * rate / TempReal1, 2)
        else:
            if iEqualPaymentTerm > 0 and PV > 0:
                cPMT = round(PV / iEqualPaymentTerm, 2)

        if cEqualPaymentAmount > 0:
            if cLoanAmount > cEqualPaymentAmount:
                cPMT = cEqualPaymentAmount
            else:
                cPMT = cLoanAmount

            rRegularPaymentAmount = round(cPMT, 2)

        rRegularPaymentAmount = round(cPMT, 2)
        iTotalCycleToSkip = iWaiveMinDueCycle

        if iTotalCycleToSkip > 0 and iEqualPaymentTerm > 0:
            iEqualPaymentTerm = iEqualPaymentTerm + iTotalCycleToSkip

        rRegularPaymentAmountHold = rRegularPaymentAmount

        iExtendedTerms = 3
        iEqualPaymentTermExtended = iEqualPaymentTerm + iExtendedTerms

        for iOuterLoop in range(iIteration):
            sContrib = "Iteration_" + str(iOuterLoop) + "_" + str(iPlanID)

            ILPSchedule[sContrib] = {}

            cDailyfactor = cDailyfactorF
            rDailyFactorwithInt = float(round(cAPR, 10)) * float(round(cDailyfactor, 10))
            dNextStatementDate_InUse = dNextStatementDate
            cBSFC = float(round(cLoanAmount, 4))
            cCurrentBalance = cBSFC
            rRemainingPrincipal = cCurrentBalance
            iWaiveMinDueCycle = iTotalCycleToSkip
            cTotalLoanTermInt = 0

            for iInnerLoop in range(iEqualPaymentTermExtended):
                ILPSchedule[sContrib][iInnerLoop] = {}
                if iWaiveMinDueCycle > 0:
                    rRegularPaymentAmount = float(0.00)
                    if iInnerLoop > 0:
                        iWaiveMinDueCycle = iWaiveMinDueCycle - 1
                    else:
                        rRegularPaymentAmount = rRegularPaymentAmountHold

                ILPSchedule[sContrib][iInnerLoop]["ILPLoanCycle"]                           = iInnerLoop
                ILPSchedule[sContrib][iInnerLoop]["ILPLoanTerm"]                            = iEqualPaymentTerm
                ILPSchedule[sContrib][iInnerLoop]["ILPPMTPaymentAmount"]                    = cPMT
                ILPSchedule[sContrib][iInnerLoop]["ILPLoanDate"]                            = dPosttime
                ILPSchedule[sContrib][iInnerLoop]["ILPIteration"]                           = iOuterLoop
                ILPSchedule[sContrib][iInnerLoop]["ILPRegularPaymentAmountforIteration"]    = rRegularPaymentAmount
                ILPSchedule[sContrib][iInnerLoop]["PstCmnAcctStateDate"]                    = dNextStatementDate_InUse

                rTotalInterest = 0
                rBilledPrincipalCTD = 0
                rRemainingPrincipal = 0

                if iInnerLoop == 0:
                    rBilledPrincipalCTD = 0
                    rRemainingPrincipal = cCurrentBalance

                if iInnerLoop > 0:
                    rBilledPrincipalCTD = rRegularPaymentAmount - rTotalInterest
                    rRemainingPrincipal = cCurrentBalance - rBilledPrincipalCTD

                if iInnerLoop == 0:





