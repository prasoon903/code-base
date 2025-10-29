Feature: Scenario 13

Background:
  Given Run as "rerun"

Scenario: Post payment of Due and cash purchase 2
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Given Post Payment_"1" of $"AmountOfTotalDue" by trancode "2102" at "posttime"
  Then Verify Transaction in DB
  Given Post cash purchase of $"160" by trancode "3001" and "13748"
  Then Verify Transaction in DB

Scenario: Age system
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
