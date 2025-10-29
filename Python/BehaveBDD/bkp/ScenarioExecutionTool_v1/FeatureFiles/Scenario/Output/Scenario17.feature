Feature: Scenario 17

Background:
  Given Run as "rerun"

Scenario: Test Given
    Given Test Given
    Then Age system to "2020-08-02" Date

Scenario: Create Account With BillingCycle 3
  Given Create Account
      |JsonTag      |  Value     |
      |ProductID    |  7131      |
      |StoreName    |  JazzStore |
      |BillingCycle |  3         |
      |CreditLimit  |  10000     |
  Then Verify Account Number in Database
  And Save tag into variable "AccountCreation"

Scenario: Post Purchase, cash and BT Transaction
  Given Post purchase of $"100" by trancode "4005"
  Then Wait for "60" seconds
  Given Post cash purchase of $"50" by trancode "3001" and "13748"
  Then Wait for "60" seconds
  Given Post cash purchase of $"100" by trancode "4005" and "13746"
  Then Verify Transaction in DB

Scenario: Age system Statement-1
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Then  Age system to "2020-08-04" Date

Scenario: Age system -- Statement-2
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Then  Age system to "2020-09-04" Date

Scenario: Age system
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Then  Age system to "2020-09-14" Date

Scenario: Post payment of less than Due
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Given Post Payment_"1" of $"AmountOfTotalDue-10" by trancode "2102" at "posttime"
  Then Verify Transaction in DB

Scenario: Age system
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Then  Age system to "2020-09-21" Date

Scenario: Post Payment of remaining amount amount due
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Given Post Payment_"2" of $"10" by trancode "2102" at "posttime"
  Then Verify Transaction in DB

Scenario: Age system
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Then  Age system to "2020-10-04" Date

#Scenario: Post payment of amount greater than CB of BT Plan

Scenario: Age system
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Then  Age system to "2020-10-08" Date

Scenario: Post Payment of SRB
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Given Post Payment_"4" of $"StatementRemainingBalanceWithInstallmentDue" by trancode "2102" at "posttime"
  Then Verify Transaction in DB

#Scenario: Update billing table 11153 to account

Scenario: Post Purchase, cash and BT Transaction
  Given Post purchase of $"50" by trancode "4005"
  Then Wait for "60" seconds
  Given Post cash purchase of $"29.5" by trancode "4005" and "13746"
  Then Wait for "60" seconds
  Given Post cash purchase of $"25" by trancode "3001" and "13748"
  Then Verify Transaction in DB

Scenario: Age till account become Charged Off
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Then  Age system to "2021-06-08" Date

Scenario: Age system to "2021-06-09" Date
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Then  Age system to "2021-06-09" Date

Scenario: Post Payment of $150
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Given Post Payment_"5" of $"150" by trancode "2102" at "posttime"
  Then Verify Transaction in DB