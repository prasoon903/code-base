Feature: Scenario 16

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

Scenario: Post Purchase Transaction
  Given Post purchase of $"800" by trancode "4005"
  Then Wait for "60" seconds
  Given Post purchase of $"1200" by trancode "4005"
  Then Wait for "60" seconds
  Given Post purchase of $"700" by trancode "4005"
  Then Verify Transaction in DB

Scenario: Age system statement-1
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
