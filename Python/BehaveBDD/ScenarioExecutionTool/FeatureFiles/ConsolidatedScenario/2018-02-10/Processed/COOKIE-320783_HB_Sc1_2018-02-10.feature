Feature: COOKIE-320783_HB_Sc1

Background:
  Given Run as "rerun"

Scenario: Create Account With BillingCycle 31
  Given Create Account
        |JsonTag    |Value      |
        |ProductID  |7139       |
        |StoreName  |Cookie-2Store  |
        |BillingCycle | 31 |
        |CreditLimit | 10000 |
  Then Verify Account Number in Database
  And Save tag into variable "AccountCreation"
  
  
Scenario: Age system 
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
