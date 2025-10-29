Feature: PLAT-143677 scenario run

  Background:
    Given Run as "rerun"

  Scenario: Age System
	Given Test Given
    Then Age system to "2021-03-01" Date
      
  Scenario: Create Account With BillingCycle 23
    Given Create Account
        |JsonTag    |Value      |
        |ProductID  |7131       |
        |StoreName  |JazzStore  |
        |BillingCycle | 23 |
        |CreditLimit | 10000 |
    Then Verify Account Number in Database
    And Save tag into variable "AccountCreation"

  Scenario: Post purchase
    Given execute Post purchase_1 of $3500 by trancode 4005
    Then Wait for 60 seconds
    Then Verify Transaction in DB
    Given Get Account Plan Details
    Then  Age system to "2021-03-30" Date

  Scenario: Post payment of min due
    Given Get AccountSummary
    Then Save tag into variable "AccountSummary"
    Given execute Post Payment_1 of $35 by trancode 2102
    Then Verify Transaction in DB
    Given Get Account Plan Details
    Given Get AccountSummary
    Then Save tag into variable "AccountSummary"

  Scenario: Post purchase
    Given execute Post BTpurchase_1 of $1500 by trancode 4005 on CPM 13746
    Then Wait for "10" seconds
    Then Verify Transaction in DB
    Given Get Account Plan Details
    Given Get AccountSummary
    Then Save tag into variable "AccountSummary"

  Scenario: Age System
	Given Test Given
    Then Age system to "2021-03-31" Date