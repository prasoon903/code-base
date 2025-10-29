from behave import *
from Scripts.ExecutableFunctions import *
from Scripts.DataManager import *
from Scripts.GetLogger import MessageLogger
from Scripts.SetLoggerGlobals import get_global_EXECUTION_ID


@given('execute {action} {details}')
def step_impl(context, action, details):
    try:
        # Use regular expressions to match the variations of the steps
        action = action.lower()
        details = details.lower()
        EXECUTION_ID = get_global_EXECUTION_ID()
        hitAPI = False
        keepJsonResponse = True
        TranTime = ""
        PostTime = ""
        IsTestAccount = False
        MessageLogger.info(
            "*********************| " + action + " " + details + " |*********************" + str(EXECUTION_ID))

        if action in ("create", "get", "add"):
            # Implement logic for "Create" statement
            input_string = action
            match = re.search(r'(\S+)', input_string)
            API, Status, amount, txntype, digit, disputeaction, months, field, value = fn_ExtractData(details)
            APIName = API
            # APIName = details
            context.apiname = fn_GetAPINAME(APIName)
            context.Status = Status
            # actype = "create"
            actype = action
            context.activitytype = actype
            context.amount = amount
            context.months = months
            context.field = field
            context.value = value
            hitAPI = True

        elif action in "post":
            APIName = "PostSingleTransaction"
            context.apiname = fn_GetAPINAME(APIName)
            # Implement logic for "Post" statement
            FullString = action + " " + details
            MessageLogger.info("FullString: " + FullString)
            match = re.search(r'post (.*?) of', FullString)
            hitAPI = True
            if match:
                word_in_between = match.group(1)
                word_in_between = word_in_between.lower()
                MessageLogger.info(word_in_between)
                parts = word_in_between.split("_")
                if len(parts) > 0:
                    word_in_between = parts[0]
                    MessageLogger.info("after " + word_in_between)
                if word_in_between in ("payment reversal", "purchase reversal", "dispute", "disputeresolution"):
                    match = re.search(r'of (\S+)', details)
                    context.Txninfo = match.group(1)
                    context.txntype = context.Txninfo
                    actype = "post transaction reversal"
                    IsTestAccount, TranTime, PostTime = fn_SetTxnTimeForAccount(EXECUTION_ID, "")
                    if word_in_between in ("dispute", "disputeresolution"):
                        context.disputeamount = 0
                        context.disputeaction = 0
                        match = re.search(r'for (\S+)', details)
                        MessageLogger.info("match: " + str(match))
                        context.Txninfo = match.group(1)
                        MessageLogger.info(FullString)
                        API, Status, amount, txntype, digit, disputeaction, months, field, value = fn_ExtractData(details)
                        MessageLogger.info("amount: " + str(amount))
                        if match:
                            context.disputeamount = amount
                            context.cnt = digit
                            if len(parts) > 1:
                                context.cnt = parts[1]
                        actype = word_in_between
                        context.disputeaction = disputeaction
                        context.apiname = fn_GetAPINAME(API)
                        context.txntype = word_in_between
                    context.activitytype = actype
                elif (word_in_between in (
                "payment", "debit", "credit", "purchase", "cashpurchase", "return", "btpurchase", "promopurchase", "retailpurchase")):
                    variable, digit, amount, by, cpm, at, txntype = extract_informationforPST(FullString)
                    MessageLogger.info(f"From input_string:")
                    MessageLogger.info(f"Variable: {variable}")
                    MessageLogger.info(f"digit: {digit}")
                    MessageLogger.info(f"Amount: {amount}")
                    MessageLogger.info(f"By: {by}")
                    MessageLogger.info(f"CPM: {cpm}")
                    MessageLogger.info(f"At: {at}")
                    MessageLogger.info(f"txntype: {txntype}")
                    TotalAmount = 0.0
                    if "+" in amount:
                        AmountList = amount.split("+")
                        MessageLogger.info(AmountList)
                        for amountValue in AmountList:
                            if not re.match(r"^\d+(\.\d+)?$", amountValue):
                                TotalAmount = TotalAmount + float(
                                    fn_GetValueFromDataStore(EXECUTION_ID, amountValue)
                                )
                            else:
                                TotalAmount = TotalAmount + float(amountValue)
                    elif "-" in amount:
                        AmountList = amount.split("-")
                        MessageLogger.info(AmountList)
                        for amountValue in AmountList:
                            if not re.match(r"^\d+(\.\d+)?$", amountValue):
                                TotalAmount = TotalAmount + float(
                                    fn_GetValueFromDataStore(EXECUTION_ID, amountValue)
                                )
                            else:
                                TotalAmount = TotalAmount - float(amountValue)
                    elif not re.match(r"^\d+(\.\d+)?$", amount):
                        value = fn_GetValueFromDataStore(EXECUTION_ID, amount)
                        TotalAmount = value
                    else:
                        TotalAmount = amount
                    amount = str(TotalAmount)
                    MessageLogger.info(f"Amount: {amount}")

                    context.variable = variable
                    context.amount = amount
                    context.by = by
                    context.cpm = cpm
                    context.at = at
                    actype = "post transaction"
                    context.activitytype = actype
                    context.cnt = digit
                    context.txntype = txntype
                    IsTestAccount, TranTime, PostTime = fn_SetTxnTimeForAccount(EXECUTION_ID, context.at)
        else:
            # Implement logic for other statements
            MessageLogger.error("Invalid Step")

        if hitAPI:
            try:
                MessageLogger.info("APIName " + str(context.apiname))
                MessageLogger.info("activitytype" + str(context.activitytype))
                MessageLogger.info("Code with new execution id: " + str(get_global_EXECUTION_ID()))
                MessageLogger.info("action in " + action)
                EXECUTION_ID = get_global_EXECUTION_ID()
                payLoad = {}
                fn_InsertFeatureStepExecutionInfo(EXECUTION_ID, context.feature.name, context.scenario.name,
                                                  context.activitytype + "" + context.apiname, 'InProgress')

                if action.strip() in ("create", "get", "add"):
                    if action == "get":
                        data = {
                            "TagName": ["AccountNumber"],
                            "VariableName": ["@MyAccountNumber"]
                        }
                        context.PaymentTable = fn_TablefromJSON(data)
                        payLoad = fn_CreateJsonPayloadUsingTable(EXECUTION_ID, context.PaymentTable)

                    elif action == "add":
                        if context.apiname == "AddManualStatus":
                            data = {
                                "TagName": ["AccountNumber", "ManualStatus"],
                                "VariableName": ["@MyAccountNumber", context.Status]
                            }
                            context.PaymentTable = fn_TablefromJSON(data)
                            payLoad = fn_CreateJsonPayloadUsingTable(EXECUTION_ID, context.PaymentTable)
                            keepJsonResponse = False
                        elif context.apiname == "RemoveManualStatus":
                            data = {
                                "TagName": ["AccountNumber", "ManualStatus"],
                                "VariableName": ["@MyAccountNumber", context.Status]
                            }
                            context.PaymentTable = fn_TablefromJSON(data)
                            payLoad = fn_CreateJsonPayloadUsingTable(EXECUTION_ID, context.PaymentTable)
                            keepJsonResponse = False
                        elif context.apiname == "ReageEnrollment":
                            data = {
                                "TagName": ["AccountNumber", "FixedPaymentAmount", "NumberOfPayments"],
                                "VariableName": ["@MyAccountNumber", context.amount, context.months]
                            }
                            context.PaymentTable = fn_TablefromJSON(data)
                            payLoad = fn_CreateJsonPayloadUsingTable(EXECUTION_ID, context.PaymentTable)
                            keepJsonResponse = False
                        elif context.apiname == "TCAPEnrollment":
                            data = {
                                "TagName": ["AccountNumber", "TCAPMonths"],
                                "VariableName": ["@MyAccountNumber", context.months]
                            }
                            context.PaymentTable = fn_TablefromJSON(data)
                            payLoad = fn_CreateJsonPayloadUsingTable(EXECUTION_ID, context.PaymentTable)
                            keepJsonResponse = False
                        elif context.apiname == "PWPEnrollment":
                            data = {
                                "TagName": ["AccountNumber", "PWPMonths"],
                                "VariableName": ["@MyAccountNumber", context.months]
                            }
                            context.PaymentTable = fn_TablefromJSON(data)
                            payLoad = fn_CreateJsonPayloadUsingTable(EXECUTION_ID, context.PaymentTable)
                            keepJsonResponse = False
                        elif context.apiname == "AccountUpdate":
                            data = {
                                "TagName": ["AccountNumber", "Field1", "Value1"],
                                "VariableName": ["@MyAccountNumber", context.field, context.value]
                            }
                            context.PaymentTable = fn_TablefromJSON(data)
                            payLoad = fn_CreateJsonPayloadUsingTable(EXECUTION_ID, context.PaymentTable)
                            keepJsonResponse = False
                    else:
                        payLoad = fn_CreateJsonPayloadUsingTable(EXECUTION_ID, context.table)
                else:
                    if context.activitytype == "post transaction":
                        MessageLogger.info("activity of " + context.activitytype)
                        data = {
                            "TagName": ["AccountNumber", "TranType", "TransactionAmount", "DateTimeLocalTransaction",
                                        "CreditPlanMaster", "TransactionTime", "TransactionPostTime"],
                            "VariableName": ["@MyAccountNumber", "TranType", "TransactionAmount", "DateTimeLocalTransaction",
                                             "CreditPlanMaster", "TransactionTime", "TransactionPostTime"]
                        }

                        context.PaymentTable = fn_TablefromJSON(data)
                        payLoad = fn_CreateJsonPayloadUsingTable(EXECUTION_ID, context.PaymentTable)
                        payLoad['TranType'] = context.by
                        payLoad['TransactionAmount'] = context.amount
                        payLoad['CreditPlanMaster'] = context.cpm
                        payLoad['TransactionPostTime'] = PostTime
                        if IsTestAccount:
                            payLoad['TransactionTime'] = TranTime
                            payLoad['DateTimeLocalTransaction'] = ""
                        else:
                            payLoad['TransactionTime'] = ""
                            payLoad['DateTimeLocalTransaction'] = TranTime

                        # if context.at != "posttime":
                        #     payLoad['DateTimeLocalTransaction'] = context.at
                        # else:
                        #     payLoad['DateTimeLocalTransaction'] = ""

                    if context.activitytype == "post transaction reversal":
                        MessageLogger.info("reversal of " + context.Txninfo)
                        Payment_1 = context.Txninfo + "_tranid"
                        TxnDetail = fn_GetTxnDetails(EXECUTION_ID, Payment_1, context.feature.name)
                        MessageLogger.info(TxnDetail)
                        data = {
                            "TagName": ["AccountNumber", "TranType", "TransactionAmount", "ReversalTargetTranID", "TransactionTime", "TransactionPostTime"],
                            "VariableName": ["@MyAccountNumber", "TranType", "TransactionAmount", "ReversalTargetTranID", "TransactionTime", "TransactionPostTime"]
                        }

                        context.PaymentTable = fn_TablefromJSON(data)
                        payLoad = fn_CreateJsonPayloadUsingTable(EXECUTION_ID, context.PaymentTable)
                        first_item = TxnDetail[0]

                        # Access the value associated with "ManualReversalTrancode" in the dictionary
                        result = first_item.get("ManualReversalTrancode", None)  # Use .get() to avoid KeyError
                        payLoad['TranType'] = first_item.get("ManualReversalTrancode", None)
                        payLoad['TransactionAmount'] = first_item.get("transactionamount", None)
                        payLoad['ReversalTargetTranID'] = first_item.get("tranid", None)
                        payLoad['AccountNumber'] = first_item.get("accountnumber", None)
                        payLoad['TransactionTime'] = TranTime
                        payLoad['TransactionPostTime'] = PostTime


                    if context.activitytype == "dispute":
                        MessageLogger.info("dispute of " + context.Txninfo)
                        Payment_1 = context.Txninfo + "_tranid"
                        TxnDetail = fn_GetTxnDetails(EXECUTION_ID, Payment_1, context.feature.name)
                        MessageLogger.info(TxnDetail)
                        data = {
                            "TagName": ["AccountNumber", "TransactionAmount", "TransactionNumber"],
                            "VariableName": ["@MyAccountNumber", "TransactionAmount", "TransactionNumber"]
                        }

                        context.PaymentTable = fn_TablefromJSON(data)
                        payLoad = fn_CreateJsonPayloadUsingTable(EXECUTION_ID, context.PaymentTable)
                        first_item = TxnDetail[0]
                        payLoad['TransactionAmount'] = context.disputeamount
                        payLoad['TransactionNumber'] = first_item.get("tranid", None)
                        payLoad['AccountNumber'] = first_item.get("accountnumber", None)

                    if context.activitytype == "disputeresolution":
                        MessageLogger.info("dispute resolution of " + context.Txninfo)
                        Payment_1 = context.Txninfo + "_TranID"
                        TxnDetail = fn_GetTxnDetails(EXECUTION_ID, Payment_1, context.feature.name)
                        MessageLogger.info(TxnDetail)
                        data = {
                            "TagName": ["AccountNumber", "TransactionAmount", "CardIssuerReferenceData", "Action"],
                            "VariableName": ["@MyAccountNumber", "TransactionAmount", "CardIssuerReferenceData", "Action"]
                        }

                        context.PaymentTable = fn_TablefromJSON(data)
                        payLoad = fn_CreateJsonPayloadUsingTable(EXECUTION_ID, context.PaymentTable)
                        first_item = TxnDetail[0]
                        payLoad['TransactionAmount'] = context.disputeamount
                        payLoad['Action'] = context.disputeaction
                        payLoad['CardIssuerReferenceData'] = first_item.get("ClaimID", None)
                        payLoad['AccountNumber'] = first_item.get("accountnumber", None)
                        keepJsonResponse = False

                MessageLogger.info("Payload here", payLoad)
                MessageLogger.info("context.apiname here " + context.apiname)
                response = fn_HitAPI(context.apiname, payLoad)
                context.response = response
                fn_InsertFeatureStepExecutionInfo(EXECUTION_ID, context.feature.name, context.scenario.name,
                                                  action + "" + context.apiname, 'Done')

                fn_InsertFeatureStepExecutionInfo(EXECUTION_ID, context.feature.name, context.scenario.name,
                                                  "Verify API response is OK", 'InProgress')

                assert context.response.ok, fn_InsertFeatureStepExecutionInfo(EXECUTION_ID, context.feature.name,
                                                                              context.scenario.name,
                                                                              "Verify API response is OK",
                                                                              'Fail Assert API Response is not ok')

                JsonData = context.response.json()
                context.jsonData = context.response.json()
                MessageLogger.info("APIResponse")
                MessageLogger.info(JsonData)
                ErrorFound, ErrorNumber, ErrorMessage = fn_CheckErrorFound(JsonData)
                MessageLogger.info(f"ErrorFound: {ErrorFound} \nErrorNumber: {ErrorNumber} \nErrorMessage: {ErrorMessage}")
                assert ErrorFound.upper() == 'NO', fn_InsertFeatureStepExecutionInfo(EXECUTION_ID, context.feature.name,
                                                                                     context.scenario.name,
                                                                                     "Verify API response is OK",
                                                                                     'FAIL Error Found Yes')
                fn_InsertFeatureStepExecutionInfo(EXECUTION_ID, context.feature.name, context.scenario.name,
                                                  "Verify API response is OK", 'Done')

                jsonResponse = ""
                if action in ("Create", "Get", "add"):
                    context.AccountNumber = payLoad['AccountNumber']
                else:
                    if context.activitytype not in ("dispute", "disputeresolution"):
                        context.TransactionID = JsonData['TransactionID']
                        context.AccountNumber = payLoad['AccountNumber']
                        context.TransactionAmount = payLoad['TransactionAmount']
                        if context.activitytype != "post transaction reversal":
                            TagName = context.txntype + "_" + str(context.cnt) + "_Tranid"
                        else:
                            TagName = "Reversal_" + context.Txninfo + "_tranid"
                        MessageLogger.info("TagName = " + TagName)
                        jsonResponse = fn_GetAPIResponseTags(context.apiname)
                        jsonResponse = fn_OverrideTagName(jsonResponse, "TransactionID", TagName)
                        bflag, errortnp, timeout = verfiyTxninDB(context.AccountNumber, context.TransactionID)
                        assert bflag is False or errortnp is True or timeout is True, fn_InsertFeatureStepExecutionInfo(
                            EXECUTION_ID, context.feature.name,
                            context.scenario.name,
                            "Transaction posted Successfully",
                            'FAIL in posting')
                    elif context.activitytype in ("dispute"):
                        context.AccountNumber = payLoad['AccountNumber']
                        context.ClaimID = JsonData['CardIssuerReferenceData']
                        TagName = context.txntype + "_" + str(context.cnt) + "_claimiD"
                        MessageLogger.info("TagName = " + TagName)
                        jsonResponse = fn_GetAPIResponseTags(context.apiname)
                        jsonResponse = fn_OverrideTagName(jsonResponse, "CardIssuerReferenceData", TagName)
                        TagName = context.txntype + "_" + str(context.cnt) + "_traniD"
                        jsonResponse = fn_OverrideTagName(jsonResponse, "OriginalTransactionNumber", TagName)
                        MessageLogger.info("Dispute response: ")
                        MessageLogger.info(jsonResponse)

                if keepJsonResponse:
                    table_var = fn_TablefromJSON(jsonResponse)
                    # MessageLogger.info("Rohit", table_var)
                    context.payment_table = table_var
                    # MessageLogger.info(context.payment_table)
                    # MessageLogger.info("Rohit here for save variable")
                    # MessageLogger.info("json variable value11111", context.jsonData)
                    assert len(context.payment_table[0]) == 2, fn_InsertFeatureStepExecutionInfo(EXECUTION_ID,
                                                                                                 context.feature.name,
                                                                                                 context.scenario.name,
                                                                                                 "Save tag into variable",
                                                                                                 'Fail More than two column')
                    # MessageLogger.info("json variable value----------------11111111" + context.jsonData)

                    try:
                        # MessageLogger.info("Rohit here for save variable new")
                        for row in context.payment_table:
                            fn_InsertFeatureStepDataStore(EXECUTION_ID, context.feature.name, context.scenario.name, row[1],
                                                          str(context.jsonData[row[0]]))
                            fn_InsertFeatureStepExecutionInfo(EXECUTION_ID, context.feature.name, context.scenario.name,
                                                              "Save tag into variable", 'Done')
                    except AssertionError as ae:
                        # Handle AssertionError specifically (if needed)
                        MessageLogger.error(f"AssertionError occurred: {ae}")
                        raise Exception('An error occurred during this step')
                        exit()
                    except Exception as e:
                        fn_InsertFeatureStepExecutionInfo(EXECUTION_ID, context.feature.name, context.scenario.name,
                                                          "Save tag into variable", 'Fail ')
                        MessageLogger.error(str(e))
                        raise Exception('An error occurred during this step')
                        exit()

            except AssertionError as ae:
                # Handle AssertionError specifically (if needed)
                MessageLogger.error(f"AssertionError occurred: {ae}")
                raise Exception('An error occurred during this step')
                exit()
            except Exception as e:
                MessageLogger.error(f"AssertionError occurred: {e}")
                fn_InsertFeatureStepExecutionInfo(EXECUTION_ID, context.feature.name, context.scenario.name,
                                                  "Post Transaction", 'Fail - ')
        else:
            MessageLogger.error("Invalid Step and API is not being called")
    except Exception as e:
        MessageLogger.error(f"AssertionError occurred: {e}")