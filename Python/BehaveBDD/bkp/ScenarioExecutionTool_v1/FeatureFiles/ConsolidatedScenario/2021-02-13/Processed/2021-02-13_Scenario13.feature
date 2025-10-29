Feature: Scenario 13

Background:
  Given Run as "rerun"

Scenario: Create Account With BillingCycle 12
  Given Create Account
      |JsonTag    |Value      |
      |ProductID  |7131       |
      |StoreName  |JazzStore  |
      |BillingCycle | 12 |
      |CreditLimit | 10000 |
  Then Verify Account Number in Database
  And Save tag into variable "AccountCreation"

Scenario: Post purchase 1 and Cash purchase 1
  Given Post purchase of $"1000" by trancode "4005"
  Then Wait for "60" seconds
  Given Post cash purchase of $"500" by trancode "3001" and "13748"
  Then Wait for "60" seconds
  Given Post cash purchase of $"800" by trancode "4005" and "13746"
  Then Verify Transaction in DB

Scenario: Age system
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
