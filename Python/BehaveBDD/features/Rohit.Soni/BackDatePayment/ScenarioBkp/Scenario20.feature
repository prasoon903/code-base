#1. 02/04/2021 Post Transactions  Purchase = $149.00 BT = $55.00 Cash = $50.38
#2.13/04/2021 age till statement
#3.27/04/2021 Post Over payment (amount should be CB + $50.00)
#4.28/04/2021 Post Purchase Transaction $100.00

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
  Given Post cash purchase of $"55" by trancode "4005" and "13746"
  Given Post cash purchase of $"50.38" by trancode "3001" and "13748"
  Then Verify Transaction in DB
  Given Get Account Plan Details

Scenario: Age system to "2021-04-13" Date -- Statement-1
  Then  Age system to "2021-04-13" Date
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"

Scenario: Age system to "2021-04-27" Date
  Then  Age system to "2021-04-27" Date

Scenario: Post payment of currentbalance + 50
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Given Post Payment_"1" of $"CardBalance+50" by trancode "2102" at "posttime"
  Then Verify Transaction in DB

Scenario: Age system to "2021-04-28" Date
  Then  Age system to "2021-04-28" Date

Scenario: Post Purchase Transaction
  Given Post purchase of $"100" by trancode "4005"