#1.02/02/2021 Post Purchase transaction $5000
#2.13/02/2021 Age till 1st Statement
#3.01/03/2021 Post payment of $30 (Less than min due)
#4.13/03/2021 Age till 2nd statement
#5.13/04/2021 Age till 3rd statement
#6.After Fix
#7.27/04/2021 Post backdated Transaction (Datetim localtransaction 01032021)

  Feature: Verify Late should get reversed when there is incycle backdated payment.

  Background:
    Given Run as "new"

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
    Given Post purchase of $"5000" by trancode "4005"
    Then  Age system to "2021-02-13" Date
    Given Get AccountSummary
    Then Save tag into variable "AccountSummary"

  Scenario: Post payment of $30 (Less than min due)
    Given Post Payment_"1" of $"30" by trancode "2102" at "20210213151515"
    Then  Age system to "2021-03-13" Date
    Then  Age system to "2021-04-13" Date
    Given Get AccountSummary
    Then Save tag into variable "AccountSummary"

  Scenario: Post across cycle back-dated payment
    Given Post Payment_"1" of $"30" by trancode "2102" at "20210301151515"
    Given Get AccountSummary
    Then Save tag into variable "AccountSummary"