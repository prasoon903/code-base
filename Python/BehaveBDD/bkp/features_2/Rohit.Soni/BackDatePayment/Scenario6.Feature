Feature: Verify Late should get reversed when there is incycle backdated payment.

  Background:
    Given Run as "new"

  Scenario: Test Given
      Given Test Given
      Then Age system to "2021-02-04" Date

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
      Given Post cash purchase of $"500" by trancode "3001" and "13748"
      Then  Age system to "2021-03-07" Date

      Given Get AccountSummary
      Then Save tag into variable "AccountSummary"

  Scenario: Post payment of min due
      Given Post Payment_"1" of $"29" by trancode "2102" at "20210301151515"

      Given Get AccountSummary
      Then Save tag into variable "AccountSummary"
