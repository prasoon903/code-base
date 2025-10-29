Feature: Scenario 18

Background:
  Given Run as "rerun"

Scenario: Post payment of Due
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Given Post Payment_"1" of $"AmountOfTotalDue" by trancode "2102" at "posttime"
  Then Verify Transaction in DB

Scenario: Age system
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
