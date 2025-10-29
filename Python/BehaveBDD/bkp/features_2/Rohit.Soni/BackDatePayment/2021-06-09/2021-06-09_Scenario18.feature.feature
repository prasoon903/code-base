Feature: Scenario 18

Feature: Scenario 18

  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"

Scenario: Age system to "2021-06-09" Date
  Then  Age system to "2021-06-09" Date

Scenario: Post payment reversal of Payment 3
  Given Post Payment Reversal of Payment_"3"
  Then Verify Transaction in DB