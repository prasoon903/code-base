Feature: Scenario 19

Background:
  Given Run as "rerun"

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
  Then Wait for "60" seconds
  Given Post cash purchase of $"130.38" by trancode "3001" and "13748"
  Then Verify Transaction in DB

Scenario: Age system Statement-1
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
