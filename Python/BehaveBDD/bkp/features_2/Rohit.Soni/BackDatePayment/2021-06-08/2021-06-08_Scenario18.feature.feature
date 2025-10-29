Feature: Scenario 18

Feature: Scenario 18


Scenario: Post over-payment
  Given Get AccountSummary
  Then Save tag into variable "AccountSummary"
  Given Post Payment_"3" of $"50" by trancode "2102" at "posttime"
  Then Verify Transaction in DB

Scenario: Age system to "2021-06-08" Date -- Statement-2
  Then  Age system to "2021-06-08" Date
