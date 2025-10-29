
#Feature:  Verify delinquency should not impact when two payments of same amount was made and one would get rev
#  Scenario: Test Given
#    Given Get max execuationid for feature
#"Given Post Payment_123 of $10 by trancode 2102 on CPM 2212 at 20221212121212"
Feature: Test Run new2222
  Background:
    Given Run as "rerun"

  Scenario: Create Account
      Given execute Create Account
          |JsonTag    |Value      |
          |ProductID  |7131       |
          |StoreName  |JazzStore  |
          |BillingCycle | 8 |
          |CreditLimit | 5000 |
      Then Verify Account Number in Database
      And Save tag into variable "AccountCreation"

  Scenario: Post purchase and Cash Transaction
      Given execute Post purchase_1 of $285 by trancode 4005
      Given execute Post cashpurchase_1 of $301 by trancode 3001 on CPM 13748

      Given execute Get AccountSummary
      Then Save tag into variable "AccountSummary"

  Scenario: Post payment of min due
      Given execute Post Payment_1 of $29 by trancode 2102 at posttime

  Scenario: Post payment_1 Reversal
      Given execute post payment reversal of Payment_1

#  Scenario: Post payment of min due
#    Given Get AccountSummary
#        |JsonTag          |Value           |
#        |AccountNumber    |3150001100411390|
##    When Verify API response is OK
#    Then Save tag into variable "AccountSummary"
#    Scenario: Create Account With BillingCycle 8
      # Given Start CI AppServer
      # Given Take DB Backup



#
#  Background:
#    Given Run as "new"
#
#  Scenario: TestRun
#    Given Create Account
#          |JsonTag    |Value      |
#          |ProductID  |7131       |
#          |StoreName  |JazzStore  |
#          |BillingCycle | 8 |
#          |CreditLimit | 5000 |
#    Then Verify Account Number in Database
#    And Save tag into variable "AccountCreation"
#
#    Given Post purchase of $"50" by trancode "4005"
##    Given Post Payment of $"20" by trancode "2102" at "posttime"
#    Given Post Payment_"1" of $"10" by trancode "2102" at "posttime"
#    Then Verify Transaction in DB
#    Given Post cash purchase of $"50" by trancode "3001" and "13748"
#    Given Get AccountSummary
#    Given Post Payment Reversal of "Payment_1"
#    Then Verify Transaction in DB

# Scenario: Post payment of min due1
#      Given Post Transaction
#          |JsonTag          |Value           |
#          |AccountNumber    |1150001100411408|
#          |TranType         |2108           |
#          |TransactionAmount|10|
#      When Verify API response is OK
#      Then Save tag into variable
#           |TagName        |VariableName      |
#           |TransactionID  |P1Tranid|
#
#      Given Post Transaction
#          |JsonTag          |Value           |
#          |AccountNumber    |1150001100411408|
#          |TranType         |2102           |
#          |TransactionAmount|10|
#      When Verify API response is OK
#      Then Save tag into variable
#           |TagName        |VariableName      |
#           |TransactionID  |P2Tranid|

#    Scenario: Post Payment-1 reversal
#      Given Post Transaction
#          |JsonTag          |Value           |
#          |AccountNumber    |1150001100411390|
#          |TranType         |2207            |
#          |TransactionAmount|29            |
#          |ReversalTargetTranID  |1814415500157059096  |
#      When Verify API response is OK
#      Then Verify Transaction in DB