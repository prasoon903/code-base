Feature: Scenario 17

Background:
  Given Run as "rerun"

Scenario: Post payment of less than Due
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Given Post Payment_"1" of $"AmountOfTotalDue-10" by trancode "2102" at "posttime"
  Then Verify Transaction in DB

Scenario: Age system
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
