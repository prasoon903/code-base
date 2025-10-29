Feature: Scenario 13

Background:
  Given Run as "rerun"

Scenario: Test Given
    Given Test Given
    Then Age system to "2021-02-01" Date

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
  Then  Age system to "2021-02-13" Date

Scenario: Age system
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Then  Age system to "2021-02-15" Date

Scenario: Post payment of Due and cash purchase 2
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Given Post Payment_"1" of $"AmountOfTotalDue" by trancode "2102" at "posttime"
  Then Verify Transaction in DB
  Given Post cash purchase of $"160" by trancode "3001" and "13748"
  Then Verify Transaction in DB

Scenario: Age system
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Then  Age system to "2021-03-13" Date

Scenario: Age system
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Then  Age system to "2021-03-20" Date

Scenario: Post payment of Due and cash purchase 3
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Given Post Payment_"2" of $"AmountOfTotalDue" by trancode "2102" at "posttime"
  Then Verify Transaction in DB
  Given Post cash purchase of $"50" by trancode "3001" and "13748"
  Then Verify Transaction in DB

Scenario: Age system
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Then  Age system to "2021-04-13" Date

Scenario: Age system
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Then  Age system to "2021-04-19" Date

Scenario: Post payment of Due
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Given Post Payment_"3" of $"AmountOfTotalDue" by trancode "2102" at "posttime"
  Then Verify Transaction in DB
