Feature: Scenario 18

Background:
  Given Run as "rerun"

Scenario: Post payment reversal of Payment 1
  Given Post Payment Reversal of Payment_"1"
  Then Verify Transaction in DB

Scenario: Post purchase transaction
  Given Post purchase of $"200" by trancode "4005"
  Then Verify Transaction in DB

Scenario: Age system Statement-2
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
