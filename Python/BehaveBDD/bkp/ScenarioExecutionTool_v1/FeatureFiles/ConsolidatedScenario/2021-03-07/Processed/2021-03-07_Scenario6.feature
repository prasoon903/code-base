Feature: Scenario 6.

  Background:
    Given Run as "rerun"

  Scenario: Create Account With BillingCycle 8
      Given Create Account
          |JsonTag    |Value      |
          |ProductID  |7131       |
          |StoreName  |JazzStore  |
          |BillingCycle | 8 |
          |CreditLimit | 5000 |
      Then Verify Account Number in Database
      And Save tag into variable "AccountCreation"

  Scenario: Post purchase and Cash Transaction
    Given Post purchase of $"1000" by trancode "4005"
    Then Wait for "60" seconds
    Given Post cash purchase of $"500" by trancode "3001" and "13748"

  Scenario: Post payment of min due
      Given Get AccountSummary
      Then Save tag into variable "AccountSummary"
      Given Post Payment_"1" of $"29" by trancode "2102" at "posttime"
      Given Get AccountSummary
      Then Save tag into variable "AccountSummary"
