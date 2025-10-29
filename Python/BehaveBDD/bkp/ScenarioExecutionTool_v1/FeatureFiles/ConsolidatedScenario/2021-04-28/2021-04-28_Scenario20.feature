Feature: Scenario 20

Background:
  Given Run as "rerun"

Scenario: Post payment of currentbalance + 50
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Given Post Payment_"1" of $"CardBalance+50" by trancode "2102" at "posttime"
  Then Verify Transaction in DB

Scenario: Age system
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"

Scenario: Post Purchase Transaction
  Given Post purchase of $"100" by trancode "4005"