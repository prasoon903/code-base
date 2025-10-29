Feature: Scenario 12

Background:
  Given Run as "rerun"

Scenario: Test Given
    Given Test Given
    Then Age system to "2021-01-25" Date

Scenario: Create Account With BillingCycle 3
  Given Create Account
      |JsonTag    |Value      |
      |ProductID  |7131       |
      |StoreName  |JazzStore  |
      |BillingCycle | 3 |
      |CreditLimit | 10000 |
  Then Verify Account Number in Database
  And Save tag into variable "AccountCreation"

Scenario: Post purchase and Cash Transaction
  Given execute Post purchase_1 of $1000 by trancode 4005
  Then Wait for "60" seconds
  Given execute Post cashpurchase_1 of $500 by trancode 3001 on CPM 13748
  Then Wait for "60" seconds
  Given execute Post BTpurchase_1 of $800 by trancode 4005 on CPM 13748
  Then Verify Transaction in DB

Scenario: Age system
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Then  Age system to "2021-02-04" Date


Scenario: Age system
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Then  Age system to "2021-02-13" Date

Scenario: Post payment of Due
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Given execute Post Payment_1 of $AmountOfTotalDue by trancode 2102
  Then Verify Transaction in DB

Scenario: Age system
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Then  Age system to "2021-03-04" Date

Scenario: Age system to "2021-03-13" Date
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Then  Age system to "2021-03-13" Date

Scenario: Post payment of Due
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Given execute Post Payment_2 of $AmountOfTotalDue by trancode 2102
  Then Verify Transaction in DB

Scenario: Age system
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Then  Age system to "2021-04-04" Date

Scenario: Age system
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Then  Age system to "2021-04-27" Date

Scenario: Post payment reversal of Payment 1
  Given execute Post Payment Reversal of Payment_1
  Then Verify Transaction in DB