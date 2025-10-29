#1.02/03/2021 Post Transactions
#Purchase = $200.00
#Cash = $130.38
#2.13/03/2021 1st statement
#3.13/04/2021 2nd Statement
#4.19/04/2021 Post Payment of Current of Cash Plan
#5.20/04/2021 Post payment of  Current balance of Purchase Plan


Feature: Scenario 19

Background:
  Given Run as "rerun"

Scenario: Test Given
    Given Test Given
    Then Age system to "2021-03-02" Date

Scenario: Create Account With BillingCycle 12
  Given Create Account
      |JsonTag      |  Value     |
      |ProductID    |  7131      |
      |StoreName    |  JazzStore |
      |BillingCycle |  12        |
      |CreditLimit  |  10000     |
  Then Verify Account Number in Database
  And Save tag into variable "AccountCreation"

Scenario: Post Purchase, cash and BT Transaction
  Given Post purchase of $"200" by trancode "4005"
  Given Post cash purchase of $"130.38" by trancode "3001" and "13748"
  Then Verify Transaction in DB

Scenario: Age system to "2021-03-13" Date -- Statement-1
  Then  Age system to "2021-03-13" Date
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"

Scenario: Age system to "2021-04-13" Date -- Statement-2
  Then  Age system to "2021-04-13" Date
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"

Scenario: Age system to "2021-04-19" Date
  Then  Age system to "2021-04-19" Date

Scenario: Post Payment of Current balance of Cash Plan

Scenario: Post Payment of Current balance of Purchase Plan