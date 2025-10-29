 Feature: Scenario 7.

 Background:
   Given Run as "rerun"

  Scenario: Test Given
      Given Test Given
      Then Age system to "2021-02-02" Date

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
    Given execute Post purchase_1 of $5000 by trancode 4005
    Then  Age system to "2021-02-13" Date


  Scenario: Post payment of $30 (Less than min due)
    Given Get AccountSummary
    Then Save tag into variable "AccountSummary"
    Given execute Post Payment_1 of $30 by trancode 2102
    Then  Age system to "2021-03-13" Date

  Scenario: Age system
    Given Test Given
    Then  Age system to "2021-04-13" Date


  Scenario: Post across cycle back-dated payment
    Given Get AccountSummary
    Then Save tag into variable "AccountSummary"
    Given execute Post Payment_2 of $30 by trancode 2102
    Given Get AccountSummary
    Then Save tag into variable "AccountSummary"
