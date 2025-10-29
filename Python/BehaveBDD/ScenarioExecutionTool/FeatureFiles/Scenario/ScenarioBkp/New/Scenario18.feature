Feature: Scenario 18

Background:
  Given Run as "rerun"

Scenario: Test Given
    Given Test Given
    Then Age system to "2021-04-02" Date

Scenario: Create Account With BillingCycle 7
  Given Create Account
      |JsonTag      |  Value     |
      |ProductID    |  7131      |
      |StoreName    |  JazzStore |
      |BillingCycle |  7         |
      |CreditLimit  |  10000     |
  Then Verify Account Number in Database
  And Save tag into variable "AccountCreation"

Scenario: Post Purchase, cash and BT Transaction
  Given execute Post purchase_1 of $149 by trancode 4005
  Then Wait for 60 seconds
  Given execute Post cashpurchase_1 of $50.38 by trancode 3001 on CPM 13748
  Then Wait for 60 seconds
  Given execute Post BTpurchase_1 of $55 by trancode 4005 on CPM 13746
  # Then Verify Transaction in DB
  
Scenario: Age system Statement-1
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Then  Age system to "2021-04-08" Date
  
Scenario: Age system
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Then  Age system to "2021-04-27" Date

Scenario: Post payment of Due
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Given execute Post Payment_1 of $AmountOfTotalDue by trancode 2102
  # Then Verify Transaction in DB

Scenario: Age system
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Then  Age system to "2021-05-02" Date

Scenario: Post Purchase return
  Given execute Post purchase return of $149 by trancode 4103
  # Then Verify Transaction in DB

Scenario: Age system
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Then  Age system to "2021-05-03" Date

Scenario: Post payment reversal of Payment 1
  Given execute Post Payment Reversal of Payment_1
  # Then Verify Transaction in DB

Scenario: Post purchase transaction
  Given execute Post purchase_2 of $200 by trancode 4005
  # Then Verify Transaction in DB

Scenario: Age system Statement-2
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Then  Age system to "2021-05-08" Date

Scenario: Age system
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Then  Age system to "2021-05-09" Date

Scenario: Post payment of Due
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Given execute Post Payment_2 of $AmountOfTotalDue by trancode 2102
  # Then Verify Transaction in DB

Scenario: Age system
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Then  Age system to "2021-05-10" Date

Scenario: Post over-payment
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Given execute Post Payment_3 of $50 by trancode 2102
  # Then Verify Transaction in DB

Scenario: Age system Statement-2
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Then  Age system to "2021-06-08" Date

Scenario: Age system
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Then  Age system to "2021-06-09" Date

Scenario: Post payment reversal of Payment 3
  Given execute Post Payment Reversal of Payment_3
  # Then Verify Transaction in DB