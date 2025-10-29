Feature: Scenario 5

Background:
  Given Run as "rerun"

Scenario: Test Given
    Given Test Given
    Then Age system to "2021-01-10" Date

Scenario: Create Account With BillingCycle 15
  Given Create Account
      |JsonTag    |Value      |
      |ProductID  |7131       |
      |StoreName  |JazzStore  |
      |BillingCycle | 15 |
      |CreditLimit | 10000 |
  Then Verify Account Number in Database
  And Save tag into variable "AccountCreation"

Scenario: Post purchase and Cash Transaction
  Given execute Post purchase_1 of $1000 by trancode 4005
  Then Age system to "2021-05-20" Date
  # Then Verify Transaction in DB

Scenario: Post payment of Due
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Given execute Post Payment_1 of $AmountOfTotalDue by trancode 2102
  Given execute Post Payment_1 of $AmountOfTotalDue by trancode 2102 at 20210310010101
  # Then Verify Transaction in DB

