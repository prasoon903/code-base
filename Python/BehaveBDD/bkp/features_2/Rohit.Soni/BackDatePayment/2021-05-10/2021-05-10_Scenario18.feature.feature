Feature: Scenario 18

Feature: Scenario 18


Scenario: Post payment of Due
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Given Post Payment_"2" of $"AmountOfTotalDue" by trancode "2102" at "posttime"
  Then Verify Transaction in DB

Scenario: Age system to "2021-05-10" Date
  Then  Age system to "2021-05-10" Date
