Feature: Scenario 18

Background:
  Given Run as "rerun"

Scenario: Create Account With BillingCycle 7
  Given Create Account
      |JsonTag      |  Value     |
      |ProductID    |  7131      |
      |StoreName    |  JazzStore |
      |BillingCycle |  7         |
      |CreditLimit  |  10000     |
  Then Verify Account Number in Database
  And Save tag into variable "AccountCreation"

Scenario: Post Purchase, cash and BT Transaction
  Given Post purchase of $"149" by trancode "4005"
  Then Wait for "60" seconds
  Given Post cash purchase of $"50.38" by trancode "3001" and "13748"
  Then Wait for "60" seconds
  Given Post cash purchase of $"55" by trancode "4005" and "13746"
  Then Verify Transaction in DB
  
Scenario: Age system Statement-1
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
