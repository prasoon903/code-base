Feature: Scenario 15.1

Background:
  Given Run as "rerun"

Scenario: Create Account With BillingCycle 7
  Given Create Account
      |JsonTag    |Value      |
      |ProductID  |7131       |
      |StoreName  |JazzStore  |
      |BillingCycle | 7 |
      |CreditLimit | 10000 |
  Then Verify Account Number in Database
  And Save tag into variable "AccountCreation"

Scenario: Post Promo Purchase Transaction $200 and Cash Transaction of $100
  Given Post cash purchase of $"200" by trancode "4005" and "13756"
  Then Wait for "60" seconds
  Given Post cash purchase of $"500" by trancode "3001" and "13748"
  Then Verify Transaction in DB

Scenario: Age system statement-1
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
