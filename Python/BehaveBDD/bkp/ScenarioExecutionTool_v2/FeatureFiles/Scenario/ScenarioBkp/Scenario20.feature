Feature: Scenario 20

Background:
  Given Run as "rerun"

Scenario: Test Given
    Given Test Given
    Then Age system to "2021-04-02" Date

Scenario: Create Account With BillingCycle 12
  Given Create Account
      |JsonTag      |  Value     |
      |ProductID    |  7131      |
      |StoreName    |  JazzStore |
      |BillingCycle |  12        |
      |CreditLimit  |  10000     |
  Then Verify Account Number in Database
  And Save tag into variable "AccountCreation"

Scenario: Post Purchase cash and BT Transaction
  Given execute Post purchase_1 of $149 by trancode 4005
  Then Wait for "60" seconds
  Given execute Post cashpurchase_1 of $55 by trancode 4005 on CPM 13746
  Then Wait for "60" seconds
  Given execute Post BTpurchase_1 of $50.38 by trancode 3001 on CPM 13748
  Then Verify Transaction in DB
  Given Get Account Plan Details

Scenario: Age system Statement-1
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Then  Age system to "2021-04-13" Date

Scenario: Age system
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Then  Age system to "2021-04-27" Date

Scenario: Post payment of currentbalance + 50
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Given execute Post Payment_1 of $CardBalance+50 by trancode 2102
  Then Verify Transaction in DB

Scenario: Age system
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Then  Age system to "2021-04-28" Date

Scenario: Post Purchase Transaction
  Given execute Post purchase_2 of $100 by trancode 4005