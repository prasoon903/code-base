Feature: Scenario 17

Background:
  Given Run as "rerun"

  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"

Scenario: Post Payment of $150
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Given Post Payment_"5" of $"150" by trancode "2102" at "posttime"
  Then Verify Transaction in DB