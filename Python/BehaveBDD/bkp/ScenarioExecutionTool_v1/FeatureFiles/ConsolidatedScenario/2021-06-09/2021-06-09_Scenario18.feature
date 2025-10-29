Feature: Scenario 18

Background:
  Given Run as "rerun"

Scenario: Age system
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"

Scenario: Post payment reversal of Payment 3
  Given Post Payment Reversal of Payment_"3"
  Then Verify Transaction in DB