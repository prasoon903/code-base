Feature: Scenario for multiple retail paid off plans v5

  Background:
    Given Run as "rerun"

  Scenario: Test Given
      Given Test Given
      Then Age system to "2018-08-05" Date

  Scenario: Create Account With BillingCycle 31
      Given Create Account
          |JsonTag    |Value      |
          |ProductID  |7131       |
          |StoreName  |CookieStore  |
          |BillingCycle | 31 |
          |CreditLimit | 5000 |
      Then Verify Account Number in Database
      And Save tag into variable "AccountCreation"

  Scenario: Test Given
    Given Test Given
    Then Age system to "2018-08-06" Date
