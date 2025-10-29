 Feature: Scenario 7.

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

  Scenario: Post purchase
    Given Post purchase of $"5000" by trancode "4005"
