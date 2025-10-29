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
  Given Post purchase of $"149" by trancode "4005"
  Then Wait for "60" seconds
  Given Post cash purchase of $"55" by trancode "4005" and "13746"
  Then Wait for "60" seconds
  Given Post cash purchase of $"50.38" by trancode "3001" and "13748"
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
  Given Post Payment_"1" of $"CardBalance+50" by trancode "2102" at "posttime"
  Then Verify Transaction in DB

Scenario: Age system
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Then  Age system to "2021-04-28" Date

Scenario: Post Purchase Transaction
  Given Post purchase of $"100" by trancode "4005"