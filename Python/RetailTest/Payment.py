class Payment:

    def __init__(self
                 , AccountNumber
                 , TranType
                 , Amount):
        self.AccountNumber = AccountNumber
        self.Amount = Amount
        self.TranType = TranType

    def Payment(self):
        from Clearing import Clearing
        # AccountNumber = ROverPayment["AccountNumber"]
        # print(self.AccountNumber)

        # TranType = "2104"
        ReversalTranID = ""
        # Amount = "120"

        R1 = Clearing(self.AccountNumber,
                      self.TranType,
                      ReversalTranID,
                      self.Amount)

        RPayment = R1.clearing()

        return RPayment
