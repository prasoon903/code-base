Feature: Scenario 101

Background:
  Given Run as "rerun"

Scenario: Test Given
    Given Test Given
    Then Age system to "2021-07-13" Date

Scenario: Create Account With BillingCycle 8
  Given Create Account
      |JsonTag      |  Value     |
      |ProductID    |  7131      |
      |StoreName    |  JazzStore |
      |BillingCycle |  8         |
      |CreditLimit  |  10000     |
  Then Verify Account Number in Database
  And Save tag into variable "AccountCreation"
  And Age system to "2021-07-13" Date

Scenario: Post purchase and Cash Transaction
  Given execute Post purchase_1 of $1000 by trancode 4005
  Given Get Account Plan Details
  Then  Age system to "2021-07-14" Date

Scenario: Post purchase and Cash Transaction
  Given execute Post purchase_2 of $1000 by trancode 4005
  Given Get Account Plan Details
  Then Age system to "2021-08-10" Date

Scenario: Post payment of Due 
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Given execute Post Payment_1 of $29 by trancode 2102
  Then Wait for 60 seconds
  Given Get Account Plan Details
  # Then Verify Transaction in DB
  Then  Age system to "2021-08-12" Date

Scenario: Post same cycle backdated purchase
  Given execute Post purchase_3 of $100 by trancode 4005 at 20210811211212
  Given Get Account Plan Details
  # Then Verify Transaction in DB
  
  Scenario: GetAccountSummary
    Given Get AccountSummary
    Then Save tag into variable "AccountSummary"
    Then Age system to "2021-08-13" Date

