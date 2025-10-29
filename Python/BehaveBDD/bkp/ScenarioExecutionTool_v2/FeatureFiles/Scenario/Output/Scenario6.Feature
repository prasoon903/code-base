Feature: Scenario 6.

  Background:
    Given Run as "rerun"

  Scenario: Test Given
      Given Test Given
      Then Age system to "2021-02-04" Date

  Scenario: Create Account With BillingCycle 8
      Given Create Account
          |JsonTag    |Value      |
          |ProductID  |7131       |
          |StoreName  |JazzStore  |
          |BillingCycle | 8 |
          |CreditLimit | 5000 |
      Then Verify Account Number in Database
      And Save tag into variable "AccountCreation"

  Scenario: Post purchase and Cash Transaction
    Given execute Post purchase_1 of $1000 by trancode 4005
    Then Wait for 60 seconds
    Given execute Post cashpurchase_1 of $500 by trancode 3001 on CPM 13748
    # Then Verify Transaction in DB
    Given Get Account Plan Details
    Then  Age system to "2021-03-07" Date

  Scenario: Post payment of min due
    Given Get AccountSummary
    Then Save tag into variable "AccountSummary"
    Given execute Post Payment_1 of $29 by trancode 2102
    # Then Verify Transaction in DB
    Given Get Account Plan Details
    Given Get AccountSummary
    Then Save tag into variable "AccountSummary"
