Feature: Verify delinquency should not impact when two payments of same amount was made and
  one would get reversed on next cycle.Also verify the distribution after payment reversal.
  Background:
    Given Run as "rerun"

  Scenario: Test Given
      Given Test Given
      Then Age system to "2021-01-08" Date

  Scenario: Create Account With BillingCycle 8
      Given Create Account
          |JsonTag    |Value      |
          |ProductID  |7131       |
          |StoreName  |JazzStore  |
          |BillingCycle | 8 |
          |CreditLimit | 5000 |
      Then Verify Account Number in Database
      And Save tag into variable "AccountCreation"
      And Age system to "2021-04-04" Date

  Scenario: Post purchase and Cash Transaction
    Given execute Post purchase_1 of $285 by trancode 4005
    Then Wait for 60 seconds
    Given execute Post cashpurchase_1 of $300 by trancode 3001 on CPM 13748
    Then  Age system to "2021-04-13" Date



  Scenario: Post payment of min due
    Given Get AccountSummary
    Then Save tag into variable "AccountSummary"
    Given execute Post Payment_1 of $29 by trancode 2102


  Scenario: Post payment of min due again
    Given Get AccountSummary
    Then Save tag into variable "AccountSummary"
    Given execute Post Payment_2 of $29 by trancode 2108
    Then Age system to "2021-05-10" Date

  Scenario: Post Payment-1 reversal
      Given execute Post Payment Reversal of Payment_1
      # Then Verify Transaction in DB
      Then Age system to "2021-05-12" Date

  Scenario: Post Backdate Payment-1
      Given execute Post Payment_3 of $20 by trancode 2108


  Scenario: Post Payment-2 reversal
    Given execute Post Payment Reversal of Payment_2
    # Then Verify Transaction in DB
    Given Get AccountSummary
    Then Save tag into variable "AccountSummary"

  Scenario: Post Backdate Payment-2
    Given execute Post Payment_4 of $29 by trancode 2108
    # Then Verify Transaction in DB
    Given Get AccountSummary
    Then Save tag into variable "AccountSummary"

  Scenario: Post Backdate Payment-1 Reversal
    Given execute Post Payment Reversal of Payment_3
    # Then Verify Transaction in DB
    Given Get AccountSummary
    Then Save tag into variable "AccountSummary"

  Scenario: Post Backdate Payment-2 Reversal
      Given execute Post Payment Reversal of Payment_4
      # Then Verify Transaction in DB