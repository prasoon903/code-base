Feature: Scenario 18

Background:
  Given Run as "rerun"

Scenario: Post over-payment
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Given Post Payment_"3" of $"50" by trancode "2102" at "posttime"
  Then Verify Transaction in DB

Scenario: Age system Statement-2
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
